# Staked Partner API - Getting Started
Staked allows partners access to staking and lending capabilities through our APIs. Staked handles almost everything involved in running staking securely and reliably. This includes the servers that run staking node, 24/7 monitoring to ensure uptime and reliable operation, and reporting.  

Partners will typically interact with Staked in two ways:
1) **Delegation:** Customers sign a message delegating their holdings to a specific address (provided by Staked). This message “stakes” the holding and allows the customer to earn staking rewards.
2) **Reporting:** Everyone loves seeing the additional crypto they are earning. Staked provides a reporting API for full access to the details.

# Workflow Overview
The staking process generally uses the following workflow:

1. Register as an integration partner
2. Depending on the chain, execute some pre-requisites, then register a delegation on a chain.
3. If `status` in the Response not immediately `READY`, pol the delegation status until `READY` (few chains require this).
4. Sign delegation message and (optionally)
  * Submit directly to chain.
  * Submit signed message to Staked for chain submission.
5. Pull reporting for an address, chain, or partner portfolio.
6. Undelegate

A more detailed description and diagram available here: [flow diagram](Workflow&#32;Diagram)

# Next Steps / Getting Started
* [Developer Portal (for API Keys and Docs)](https://developer.staked.cloud/)
* [Launch a Dash Masternode](Dash&#32;Masternode)
* [Launch a Tezos Baker](Tezos&#32;Baker)
