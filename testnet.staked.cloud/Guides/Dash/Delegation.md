# Using Staked's APIs to launch Dash Masternodes

## Step 0: Pre-requisites
In order to set up a you'll need to use a Dash faucet to obtain enough DASH to create an address with exactly 1000 Dash and get a Masternode txn_id (link to Dash instructions for this).

There are several testnet faucets:
 * http://test.faucet.masternode.io
 * http://faucet.test.dash.crowdnode.io
 * https://test.faucet.dashninja.pl

 All instructions in this step assume you are using either the dash command line tool or the debug console in the GUI wallet. If you are using the debug console, remove `dash-cli` from the begining of each command mentioned below.

 * Create two new addresses, the first to hold your masternode collateral and the second to serve as your owner address
 You can create addresses using the following command:

 `dash-cli getnewaddress <address-alias>`

 Example

 `dash-cli getnewaddress masternode_1_owner`

 * Send exactly 1,000 Dash to your collateral address

 `dash-cli sendtoaddress <address> <amount>`

 Example

 `dash-cli sendtoaddress XkGe5utNkxXzsCHtDAXEXRBHXouHamYHBB 1000`

 * Get the transaction id and output index of the transaciton you just created (you may need to wait up to 2 minutes until your transaction is added to a block).

 `dash-cli masternode outputs`

 Which looks like this:

 ```
 {
   "8960321b0c43a51e35d0226debfc117ae22856c1710af855e7997e3aa9b4ed82": "1",
  "053c79483f8b5eab7f53175d3a26dc45c295e3ac213f188237d40f2cd2f84da9": "1",
  "370820cef360f0d383200d1d72e6886aaaf16a114b209c4344a866b920c506d1": "1"
  }
  ```

 * You will need a `payoutAddress` which can be generated using the commands above, and can be shared on different masternods.


## Step 1: API key
You will need an API key to access Staked's APIs. If you don't already have an API key, contact Staked to request one. For Dash, we will support 2 masternodes per partner account in a sandbox/tesnet environment.

## Step 2: Delegate Assets
- Use the `delegate` endpoint to register a new masternode address. [Documentation]()
- Shell example:
  - `curl -X POST -H "content-type:application/json"
    -d '{
      "address": "XkGe5utNkxXzsCHtDAXEXRBHXouHamYHBB", "chain": "DASH",
      "attributes": {
        "collateralHash": "8960321b0c43a51e35d0226debfc117ae22856c1710af855e7997e3aa9b4ed82",
        "collateralIndex": 1,
        "payoutAddress": "yWL1Q8bp7TFP3F1Yp9yEcJHF3jM4XrugXz"}}'
        "http://testnet.staked.cloud/api/delegations?key=YOURAPIKEY"`
  - response will be a Delegation object with attributes and one of the following status:
    `WaitingForNodePort`
    `WaitingForIpAddress`
    `WaitingForKeys`
    `WaitingToRegister`
    `WaitingForSigning`
    `WaitingToSubmit`
    `Ready`


## Step 3: Check Masternode Status
- Use the `delegation` endpoint with the address parameter to check the status of your new masternode. [api docs here](https://developer.staked.cloud/docs/testnet.staked.cloud/1/routes/delegations/get)
- Shell example:
  - `curl -X GET "http://testnet.staked.cloud/api/delegations/XkGe5utNkxXzsCHtDAXEXRBHXouHamYHBB?key=YOURAPIKEY"`
  - response will be a Delegation object with attributes and a status.  When the `status` is `WaitingForSigning`, the `attributes` for the masternode address will include the `signMessage` attribute [api docs here](https://developer.staked.cloud/docs/testnet.staked.cloud/1/types/dash_attrs) to perform the on chain commands in the next step.

## Step 4: Sign Delegation Message
This must be run on wallet/device that holds collateral key. This can be done completely offline (for example, if the user holds collateral keys in a ledger), and the `signMessage` is the output from above.
```
signmessage collateralAddress signMessage
```
Example Response:
```
H3ub9BATtvuV+zDGdkUQNoUGpaYFr/O1FypmrSmH5WJ0KFRi8T10FSew0EJO/+Ij+OLv4r0rt+HS9pQFsZgc2dE=
```

## Step 5: PUT the signedTx on the delegation
`curl -X PUT -H "Content-Type: application/json" http://testnet.staked.cloud/api/delegations/yWL1Q8bp7TFP3F1Yp9yEcJHF3jM4XrugXz?key=YOURAPIKEY -d '{"attributes": { "signedTx": "H8pIRIGfOf54rOpfSWGDhNMQhFSK297NCf9g9+sO26b+aH+hD3DQy3olBESCXxj7GeZS8hhdJKc18Ib0DvC7BoA="}}'`

The status of the delegation object is now `WaitingToSubmit`.  When the Masternode is synched, the signedTx will be submitted and the status will be `Ready`.

## Step 6: Access Reporting
- Use the `reports` endpoint to access reporting. [api doc here](https://developer.staked.cloud/docs/testnet.staked.cloud/1/routes/reports/get) You can request reporting on all Dash accounts or a single address:

## Step 7: Unbonding
The masternode can be shutdown on the backend with a DELETE call on the ownerAddress

- API call to shut down the masternode
  - `curl -X DELETE -H "content-type:application/json"  "http://testnet.staked.cloud/api/delegations/XkGe5utNkxXzsCHtDAXEXRBHXouHamYHBB?key=YOURAPIKEY"`

## References
[Dash CLI](https://docs.dash.org/en/stable/wallets/dashcore/cmd-rpc.html#dash-cli)
[Dash Core Docs](https://docs.dash.org/en/stable/masternodes/setup.html?highlight=register_prepare#prepare-a-proregtx-transaction)
