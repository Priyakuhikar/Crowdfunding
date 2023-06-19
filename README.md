# Crowdfunding


- Campaign Creation: Users can create crowdfunding campaigns by providing details such as title, description, funding target, deadline, and an image. Each campaign is assigned a unique ID.

- Donation: Users can donate Ether to active campaigns by specifying the campaign ID and sending the desired amount. The donation amount is recorded and added to the campaign's total collected amount.

- Ownership and Access Control: Only the campaign owner can withdraw the funds. The contract includes a modifier, "onlyOwner," which restricts certain operations to the owner.

- Withdrawal of Funds: After the campaign deadline has passed and the campaign is no longer active, the owner can withdraw the funds collected. The entire collected amount is transferred to the owner's address.

- Event Logging: The contract emits events for campaign creation, donation received, and funds withdrawn. These events provide transparency and allow external applications to track and respond to contract updates.

- Retrieving Campaign Information: Users can access campaign information such as the list of donators and their corresponding donation amounts by providing the campaign ID. Additionally, an array of all campaigns created so far can be obtained.
