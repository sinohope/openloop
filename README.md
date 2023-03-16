# Changelog

| Version | Log           | Date       | Modifier |
| ---- | ------------- | ---------- | ------ |
| v1.0 | first version | 2023-03-12 | kevin  |



# Versions
[简体中文版本](./README_ZH.md)



# Glossary


Roles: User U, Exchange E, Custody Platform C.

Main Exchange Account: Abbreviated as MEA. It is an account opened by User U on the exchange E, usually uniquely identified by an appkey.

Collateral Vault Account: Abbreviated as CVA. When User U needs to map assets to Exchange E, a CVA is created on Custody Platform C. CVA and MEA achieve a one-to-one mapping. The unique ID of CVA is collateral_Id.



# Main Steps

## Initiate

![](./images/setup_cva_share.png)

![](./images/setup_seq.png)

## Deposit

![](./images/deposit.png)

## Settlement

![](./images/settlement.png)

## Withdrawal

![](./images/withdraw.png)

# API  Spec

## Custody->Exchange

### /exchange/v1/connect

```
Description: connect the colleteralId with appkey
Method: POST
Query parameter：
collateralId: collateral account id
exchangeAccountId: exchange account id, can be appkey
Response:
{
status,
collateralId,
rejectReason,
}
```

### /exchange/v1/address

```
Description: notify the exchange to collateral asset address
Method: POST
Body parameter：
collateralId: collateral account id
assets:[
{
currency,
network,
assetId,
address,
tag,
}
]
```

### /exchange/v1/withdraw

```
Description: initiate withdrawal request from CVA, if exchange confirm, it will reduce the customer available amount in MEA
Method: POST
Body parameter：
collateralId: collateral account id
collateralTxId:
assetId
amount
to
tag
```

### /exchange/v1/settlement/list

```
description: get settlement list of the collateral id
method：GET
query parameter：
txId：custody tx id
collateralId: collateral account id
response:

{
to_exchange:[
    {
         assetid,
         amount,
         to,
         totag,
         status   
    }
],
to_collateral:[

]
}
```

### /exchange/v1/settlement/status

```
Description: get status of a settlement
Method：GET
Query parameter：
settlementId required: settlement id

Response:
enum of settlement status
```

### /exchange/v1/settlement

```
Description: send settlement request to exchange, for
Method：POST
Query parameter：
txId required：custody tx id
collateralId required: collateral account id
```

## Exchange->Custody

### /collateral/v1/transactions

```
Description: get status of custody tx
Method：GET
Query parameter：
txId requred：sinohope tx id
```

### /collateral/v1/settlement

```
Description: send settlement request to sinohope, for the collateralId
Method：POST
Query parameter：
collateralId required: collateral account id
```
