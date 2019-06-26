# Using Staked's APIs to Delegate to the Cosmos Pool

## Step 0: Pre-requisites

- You have a Cosmos account with some Atoms you want to delegate to Staked.
- That account is accessible via the `gaiacli keys list` on a PC that is or is not internet connected -*OR*- the account is available on a ledger.
- Using one of the two methods above, you can sign a transaction with those keys and return the signature via API.

## Step 1: API key

You will need an API key to access Staked's APIs. If you don't already have an API key, contact Staked to request one.

## Step 2: Delegate Assets

- Use the `/delegations` ([Documentation](https://developer.staked.cloud/docs/testnet.staked.cloud/1/routes/delegations/%7Bchain%7D/get)) endpoint to request a delegation transaction to sign and register the address for subsequent reporting.
- Shell example:

  ```bash
    $ curl -X POST -H "content-type:application/json" -d '{"amount": "100"}' "http://testnet.staked.cloud/api/delegations/COSMOS/delegator/cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk?api_key=<YOURAPIKEY>"
  ```

  - Response will be a Delegation object with attributes, including a txn to sign, like:
  
  ```json
  {
    "id": "<id>",
    "address": "gaia-cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk",
    "chain": "COSMOS",
    "attributes": {
      "tx": {
        "fee": {
          "gas": "99429",
          "amount": [
            {
              "denom": "uatom",
              "amount": "1000"
            }
          ]
        },
        "msg": [
          {
            "type": "cosmos-sdk/MsgDelegate",
            "value": {
              "amount": {
                "denom": "atom",
                "amount": "100"
              },
              "delegator_address": "cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk",
              "validator_address": "cosmosvaloper18vspjrcxgq66spd5c4s42eg8v7u20wqu9y2u3a"
            }
          }
        ],
        "memo": "Delegation txn created by Staked: <timestamp>",
        "signatures": null
      },
      "type": "auth/StdTx",
      "chain_id": "gaia-13003"
    },
    "amount": "100",
    "created": "<timestamp>",
    "status": "CREATED"
  }
  ```

## Step 3: Sign the Transaction with Your Private Key

- Assumes `gaiacli` and that you have `--recover` a key with the alias `MyKey`
- With the json from above, copy `attributes` into a file `txn_to_sign.json`. Then, rename `attributes` to `txnToSign`.
- -*OR*-
- If you prefer to use `jq`, you can pipe the curl command into jq like:  

  ```bash
  $ curl ... | jq ' {txnToSign: .attributes} ' > txn_to_sign.json
  ```

- With `txn_to_sign.json`, run the following, with `chain-id` from the POST response:  

  ```bash
  $ gaiacli tx sign delegate_to_sign.json --from=MyKey --chain-id=gaia-13003
  ```

- The output will be a nearly identical json as the input, but including signatures:

```json
{
  ...
  "signatures": [
    {
      "pub_key": {
        "type": "tendermint/PubKeySecp256k1",
        "value": "A4XybJrkjSCI1iW6x+n33BfHqti03ZAoxJff2hRjJiDt"
      },
      "signature": "PMvDe3M21V8++s1i62+SKmANe1kPay5LOH4cVVgcNAdSFDEHf8Rbn+SCWiCUrW+1pXf6O+R6Vdhid/Eh3KF8yg=="
    }
  ],
  ...
}
```

## Step 4: PUT Signed Transaction to the Delegations Endpoint

- Rewrap the signed tx in `attributes` and PUT it:

  ```bash
  $ curl -X PUT -H "content-type:application/json" -d '{"attributes": <SIGNED_OUTPUT>}' "http://testnet.staked.cloud/api/delegations/COSMOS/delegator/cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk?api_key=<YOURAPIKEY>"
  ```

## Step 6: Access Reporting

- Use the `/reports` ([Documentation](https://developer.staked.cloud/docs/testnet.staked.cloud/1/routes/reports/%7Bchain%7D/balance/get)) endpoint to access reporting. You can request reporting on the Cosmos address with date filters for rewards:

## ~~Step 7: Unbonding~~ **COMING SOON**

<!--
Comment this out until we setup unbonding
~~The delegation can be Unbonded with a DELETE call on the address~~

~~- API call to shut down the masternode~~
  ```bash
  $ curl -X DELETE -H "content-type:application/json" "http://testnet.staked.cloud/api/delegations/COSMOS/delegator/cosmos1scdqxnwvhng5nhzfeptgtu57nh48mc5hymd5sk?api_key=<YOURAPIKEY>"
  ```
-->

## References

[Cosmos SDK Docs](https://cosmos.network/rpc/#/ICS0/post_txs)
