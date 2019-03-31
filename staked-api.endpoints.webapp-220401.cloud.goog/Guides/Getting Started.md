# Staked Partner API - Getting Started
Staked allows partners access to staking and lending capabilities through our APIs. Staked handles almost everything involved in running staking securely and reliably. This includes the servers that run staking node, 24/7 monitoring to ensure uptime and reliable operation, and reporting.  

Partners will typically interact with Staked in two ways:
1) **Delegation:** Customers sign a message delegating their holdings to a specific address (provided by Staked). This message “stakes” the holding and allows the customer to earn staking rewards.
2) **Reporting:** Everyone loves seeing the additional crypto they are earning. Staked provides a reporting API for full access to the details.

# Workflow Overview
The staking process generally uses the following workflow:

1. Register as an integration partner
2. Register a delegation on a chain (address or txn_id, depending on chain)
3. Check status (some chains use pre-provisioned infrastructure, others dynamically provision) until ready.
4. Sign delegation message and (optionally)
  * Submit directly to chain.
  * Submit signed message to Staked for chain submission.
5. Pull reporting for a address, chain, or partner portfolio.
6. Undelegate

A more detailed description and diagram available here: [flow diagram](FLOW_DIAGRAM.md)

# Next Steps / Getting Started
* [Developer Portal (for API Keys and Docs)](https://endpointsportal.webapp-220401.cloud.goog/)
* [Launch a Dash Masternode](chaindocs/DASH_STAKING.md)
* [Launch a Tezos Baker](chaindocs/DASH_STAKING.md)
* Chain Links (for SDKs, CLIs, etc.)

