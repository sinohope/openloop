# changelog

| 版本 | log           | 时间       | 修改人 |
| ---- | ------------- | ---------- | ------ |
| v1.0 | first version | 2023-03-12 | kevin  |
|      |               |            |        |
|      |               |            |        |



# 名词解析

角色：用户 U、交易所 E、托管平台C。

Main Exchange Account：简写为 MEA。是用户U 在交易所开设的一个账户，通常使用 appkey 来唯一标识。

Callateral Vault Account：简写为CVA。当用户U需要映射资产到交易所E，在托管平台C上创建 CVA。CVA 与MEA 实现一一映射。CVA 的唯一 ID 是 collateral_Id。

# 核心流程

## 初始化

![](./images/setup_cva_share.png)

![](./images/setup_seq.png)

## 充值

![](./images/deposit.png)

## 结算

![](./images/settlement.png)

## 提现

![](./images/withdraw.png)

# API  设计

## Sinohope->Exchange

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
txId：sinohope tx id
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
"NOT_FOUND" 
"PROCESSING" 
"CANCELLED" 
"FAILED" 
"PENDING_MANUAL_APPROVAL" 
"PENDING_SERVICE_MANUAL_APPROVAL" 
"REJECTED" "COMPLETED"
```

### /exchange/v1/settlement

```
Description: send settlement request to exchange, for
Method：POST
Query parameter：
txId required：sinohope tx id
collateralId required: collateral account id
```

## Exchange->Sinohope

### /collateral/v1/transactions

```
Description: get status of sinohope tx
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
