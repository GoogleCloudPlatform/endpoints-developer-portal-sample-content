# Using Staked's APIs to Delegate to the Cosmos Pool

## Step 0: Pre-requisites
- You have a Cosmos account with some Atoms you want to delegate to Staked
- That account is accessible via the `gaiacli keys list` on a PC that is or is not internet connected -OR- the account is available on a ledger
- Using one of the two methods above, you can sign a transaction with those keys and return the signature via API.

## Step 1: API key
You will need an API key to access Staked's APIs. If you don't already have an API key, contact Staked to request one.

## Step 2: Delegate Assets
- Use the `delegations` endpoint to request a delegation transaction to sign and register the address for subsequent reporting. [Documentation]()
- Shell example:
  - `curl -X POST -H "content-type:application/json"
    -d '{
      "address": "cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk", "chain": "COSMOS",
      "attributes": {
        "amount": 1000000uatom"}}'
        "http://testnet.staked.cloud/api/delegations?key=YOURAPIKEY"`
  - response will be a Delegation object with attributes, including a txn to sign, like:
    `{"chain-id": "gaia-13003",
      "status": "ToSign",
      "txnToSign":
        {"type":"auth/StdTx",
         "value":
           {"msg":
             [{"type":"cosmos-sdk/MsgDelegate",
               "value":
                 {
                   "delegator_address":"cosmos18vspjrcxgq66spd5c4s42eg8v7u20wquqs7faw",
                   "validator_address":"cosmosvaloper18vspjrcxgq66spd5c4s42eg8v7u20wqu9y2u3a",
                   "amount":
                     {
                       "denom":"atom",
                       "amount":"1"
                     }
                 }
               }
             ],
             "fee":
               {"amount":
                 [
                   {
                     "denom":"muon",
                     "amount":"1000"
                   }
                 ],
                "gas":"19690"
               },
             "signatures":null,
             "memo":"Delegation Txn Created by Staked: 05/22/2019 17:52:07Z"
           }
        }
    }`

## Step 3: Sign the Transaction with Your Private Key
- Assumes `gaiacli` and that you have `--recover` a key with the alias `MyKey`
- With the txn json from above in a file `txn_to_sign.json`, run the following:
  - `gaiacli tx sign delegate_to_sign.json --from=MyKey --chain-id=gaia-13003`
  - `chain-id` is what was returned from the POST to delegations
- the output will be a nearly identical json as the input, but including signatures:
  - `..."signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "A4XybJrkjSCI1iW6x+n33BfHqti03ZAoxJff2hRjJiDt"
        },
        "signature": "PMvDe3M21V8++s1i62+SKmANe1kPay5LOH4cVVgcNAdSFDEHf8Rbn+SCWiCUrW+1pXf6O+R6Vdhid/Eh3KF8yg=="
      }
    ],...`

## Step 4: PUT Signed Transaction to the Delegations Endpoint
- wrap the signedTx in a json attribute and PUT it
- `curl -X PUT -H "content-type:application/json"
  -d '{"signedTx": SIGNED_OUTPUT}'
    "http://testnet.staked.cloud/api/delegations/cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk?key=YOURAPIKEY"`

## Step 6: Access Reporting
- Use the `reports` endpoint to access reporting. [api doc here](https://developer.staked.cloud/docs/testnet.staked.cloud/1/routes/reports/get) You can request reporting on the Cosmos address with date filters for rewards:

## Step 7: Unbonding
The delegation can be Unbonded with a DELETE call on the address

- API call to shut down the masternode
  - `curl -X DELETE -H "content-type:application/json"  
    "http://testnet.staked.cloud/api/delegations/cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk?key=YOURAPIKEY"`

## References
Cosmos SDK Docs
