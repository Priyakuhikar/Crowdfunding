// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
        bool isActive;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public numberOfCampaigns = 0;

    modifier onlyOwner(uint256 _id) {
        require(campaigns[_id].owner == msg.sender, "Only the owner can perform this operation.");
        _;
    }

    event CampaignCreated(uint256 campaignId, address owner);
    event DonationReceived(uint256 campaignId, address donator, uint256 amount);
    event FundsWithdrawn(uint256 campaignId, address owner, uint256 amount);

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public {
        require(_deadline > block.timestamp, "The deadline should be a date in the future.");

        Campaign storage campaign = campaigns[numberOfCampaigns];
        campaign.owner = msg.sender;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;
        campaign.isActive = true;

        emit CampaignCreated(numberOfCampaigns, msg.sender);

        numberOfCampaigns++;
    }

    function donateToCampaign(uint256 _id) public payable {
        require(campaigns[_id].isActive, "This campaign is no longer active.");
        require(msg.value > 0, "Donation amount must be greater than zero.");

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(msg.value);

        campaign.amountCollected += msg.value;

        emit DonationReceived(_id, msg.sender, msg.value);
    }

    function withdrawFunds(uint256 _id) public onlyOwner(_id) {
        Campaign storage campaign = campaigns[_id];
        require(campaign.isActive == false, "The campaign is still active.");

        uint256 amount = campaign.amountCollected;

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");
        require(sent, "Failed to send funds.");

        campaign.amountCollected = 0;

        emit FundsWithdrawn(_id, campaign.owner, amount);
    }

    function getDonators(uint256 _id) public view returns (address[] memory, uint256[] memory) {
        Campaign storage campaign = campaigns[_id];
        return (campaign.donators, campaign.donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            allCampaigns[i] = campaigns[i];
        }

        return allCampaigns;
    }
}
