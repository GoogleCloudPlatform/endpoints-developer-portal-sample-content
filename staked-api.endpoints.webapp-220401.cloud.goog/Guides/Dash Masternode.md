# Using Staked's APIs to launch Dash Masternodes

## Step 1: Pre-requisites
You will need an API key to access Staked's APIs. If you don't already have an API key, contact Staked to request one. For Dash, we will support 2 masternodes per partner account in a sandbox/tesnet environment.

Additionally, you'll need to use a Dash faucet to obtain enough DASH to create an address with exactly 1000 Dash and get a Masternode txn_id (link to Dash instructions for this).

There are several testnet faucets: 
 * http://test.faucet.masternode.io 
 * http://faucet.test.dash.crowdnode.io
 * https://test.faucet.dashninja.pl

## Step 2: Delegate Assets
- Use the `delegate` endpoint to register a new masternode address. [Documentation]()
- Shell example:
  - `curl -X POST -H "content-type:application/json" -d '{"address": "KT1.....", "amount": "1000.0", "txn_id": ""], "user_id": "PARNTERID"}' "http://testnet.api.staked.cloud/chain/DASH/delegate?key=AIzaSyDP2E-04AmxEyQCCyl_xPcNVaVqZPJHwl4"`
  - response will be a GUID from Staked for that address and a status (for DASH, the initial status will be "CREATING").

## Step 3: Check Masternode Status
- Use the `address` endpoint to check the status of your new masternode. [Documentation]()
- What are possible status responses? 
- Shell example:
  - `curl -X GET "http://testnet.api.staked.cloud/chain/DASH/address/ADDRESS?key=AIzaSyDP2E-04AmxEyQCCyl_xPcNVaVqZPJHwl4"`
  - response is structure for the "1000 Dash" address and the status of the underlying Masternode, and other attributes of the Masternode.  When the masternode is ready for launch, we will return a status of "SUBMIT". The response will also contain the launch message that needs to be signed.

## Step 4: Sign Delegation Message
- Provide link to Dash documentation for signing the message.
- The API caller can either submit the message directly to the chain (assuming they are running a fully synched node in their wallet or SDK environment), or provide us with the signed message and we will submit it.
- API call to submit the signed txn
  - `curl -X PUT -H "content-type:application/json" -d '{"signed_txn": "SIGNED_TRANSACTION_STRING"}' "http://testnet.api.staked.cloud/chain/DASH/address/ADDRESS?key=AIzaSyDP2E-04AmxEyQCCyl_xPcNVaVqZPJHwl4"`

## Step 5: Access Reporting
- Use the `report` endpoint to access reporting. [Documentation]() You can request reporting on all Dash accounts or a single address:
  - `curl -X GET "http://testnet.api.staked.cloud/chain/DASH/report?key=AIzaSyDP2E-04AmxEyQCCyl_xPcNVaVqZPJHwl4"`
  - `curl -X GET "http://testnet.api.staked.cloud/chain/DASH/address/ADDRESS/report?key=AIzaSyDP2E-04AmxEyQCCyl_xPcNVaVqZPJHwl4"`

## Step 6: Unbonding

All good things come to an end. At some point, the customer may want to unbond (a.k.a Stop staking), allowing them to transfer or sell their currency.
- API call to submit the signed txn
  - `curl -X DELETE -H "content-type:application/json" -d '{"signed_txn": "SIGNED_TRANSACTION_STRING"}' "http://testnet.api.staked.cloud/chain/DASH/address/ADDRESS?key=AIzaSyDP2E-04AmxEyQCCyl_xPcNVaVqZPJHwl4"`
  - TODO: Do we want a DELETE or a POST to undelegate?