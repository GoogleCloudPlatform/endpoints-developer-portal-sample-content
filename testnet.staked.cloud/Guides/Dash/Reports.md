# DASH Reporting API guide

Staked's reporting API allows delegators to obtain delegation and rewards data.

## Pre-requisites

- You will need an API key to access Staked's APIs. If you don't already have an API key, contact Staked to request one.

## Using the Reporting API

- With Staked's reporting API, you may obtain: delegation balance and transactions.  Transactions, which encompass both delegation transactions and rewards transactions, can be queried by kind.

- Currency amounts are recorded in a smaller denomination and should be converted to DASH by dividing by conversion factor `100,000,000`.
   

# Query by address

## Balance


Shell example:
  ```bash
    $ curl -X GET "http://testnet.staked.cloud/api/reports/DASH/delegator/Xg2sTDb7rTf3vmRjQmSXqT4qPu9dYJ66oA/balance?api_key=<YOURAPIKEY>"
  ```

Output example:
  ```json
  {
    "balance": 5000000,
    "timestamp": "2019-07-08T17:09:08.753866"
  }
  ```

- `balance`: Delegation balance - divide by `100,000,000` to convert to DASH
- `timestamp`: Timestamp of balance

## Transactions

- Transactions are queried by `kind`.  Not setting `kind` will return transactions of all kinds. 

- You can also query for transactions within a time period by setting `start` and `end` parameters which are in the format `YYYY-mm-dd` (`2019-05-12` for example).  Time periods can be bounded in one direction as well - for example by setting `start` but not `end`, you will query for transactions from `start` time onwards.

Delegation:

- `STK`: Delegation transactions
- `UNSTK`: Undelegation transactions

Rewards:

- `PAID`: Rewards which have been paid

Shell example:  
  ```bash
    $ curl -X GET "http://testnet.staked.cloud/api/reports/DASH/delegator/Xg2sTDb7rTf3vmRjQmSXqT4qPu9dYJ66oA/txns?api_key=<YOURAPIKEY>&start=2019-04-02&kind=paid"
  ```

Output example:
  ```json
  [
    ...
    {
        "id": 149085,
        "kind": "PAID",
        "transaction_time": "2019-06-05T21:17:06",
        "transaction_address": "4CA0DE34960577F5ED8D75CB573322FD5FD1A9F02ADEA9CDFB8C0C8F0DC90492",
        "amount": null,
        "reward": 193873,
        "fees": 100,
        "total": 193973,
        "block_reference": 554796
    },
    {
        "id": 149086,
        "kind": "PAID",
        "transaction_time": "2019-05-15T05:19:51",
        "transaction_address": "3471B104CC9A5FAF5CBF6441412D9E1E5108DE28CBB913E7E8440BBC842C8542",
        "amount": null,
        "reward": 109348,
        "fees": 0,
        "total": 109348,
        "block_reference": 283855
    },
    ...
  ]
  ```

- `id`: Internal identification number
- `kind`: Transaction kind
- `transaction_time`: Timestamp of transaction
- `transaction_address`: Hash address of transaction
- `amount`: Amount of delegation or undelegation
- `reward`: Amount of staking/validation rewards
- `fees`: Amount of fees 
- `total`: Sum of `reward` and `fees` 
- `block_reference`: Block height of transaction

`amount` applicable to `STK`/`UNSTK` transactions and
`reward`, `fees`, and `total` applicable to `PAID` transactions

Convert all currency amount values to DASH by dividing by conversion factor `100,000,000`.

# Query all addresses associated with API key

## Balance

Example:
  ```bash
    $ curl -X GET "http://testnet.staked.cloud/api/reports/DASH/balance?api_key=<YOURAPIKEY>"
  ```

## Transactions

Example:  
  ```bash
    $ curl -X GET "http://testnet.staked.cloud/api/reports/DASH/txns?api_key=<YOURAPIKEY>"
  ```



