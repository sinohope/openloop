# Changelog

| 版本 | log           | 时间       | 修改人 |
| ---- | ------------- | ---------- | ------ |
| v1.0 | first version | 2023-03-12 | kevin  |

# Versions

[English Version](./README.md)


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

## Custody->Exchange

### POST /exchange/v1/connect

```
用于CVA账户与MEA账户绑定

请求参数：
参数名                类型              是否必须           描述
collateralId         string            Y                CVA账户的唯一标识
exchangeAccountId    string            Y                请求绑定的MEA账户的唯一标识，API KEY

响应参数
参数名                类型              是否必须           描述
status               boolean           Y                枚举：False/True (绑定失败/成功)；
rejectReason         string or null    N                如果交易所拒绝绑定，请返回具体原因；若通过校验，可为空
```

### POST /exchange/v1/address

```
用于SinoHope通知交易所为CVA账户新增地址

请求参数：
参数名                类型              是否必须           描述
requestId            string            Y                本次绑定请求的标识
collateralId         string            Y                CVA账户的唯一标识
assets               array             Y                CVA账户创建时，默认生成几个常用地址，并一次性通知交易所；后续基于用户操作，按需通知新增地址；
> currency           string            Y                交易所定义的币种标识
> network            string            Y                交易所定义的链标识
> assetId            string            Y                SinoHope定义的资产标识（不同链的相同币种，资产标识不同）
> address            string            Y                SinoHope为用户的CVA账户分配的地址
> tag                string or null    N                SinoHope为用户的CVA账户分配的tag；不会有共用地址的情况，这个字段是否可以删掉？(待定)

响应参数
参数名                类型              是否必须           描述
received             boolean           Y                枚举：False/True (失败/成功)；
```

### GET /exchange/v1/address/status

```
用于SinoHope查询交易所异步处理添加CVA地址的状态

请求参数：
参数名                类型              是否必须           描述
requestId            string            Y                本次绑定请求的标识

响应参数
参数名                类型              是否必须           描述
status               boolean           Y                枚举：False/True (失败/成功)；
```

### POST /exchange/v1/settlement/network

```
用于用户向交易所指定向CVA地址结算的默认网络（一币多链的场景）

请求参数：
参数名                类型              是否必须           描述
collateralId         string            Y                CVA账户的唯一标识
assetId              string            Y                SinoHope定义的资产标识
perferedNetwork      string            Y                交易所向CVA账户结算的默认网络，用户在SinoHope侧指定（可选网络的范围，SinoHope预先与交易所确认）

响应参数
参数名                类型              是否必须           描述
```

### POST /exchange/v1/settlement/list

```
用于用户主动发起结算的场景，SinoHope向交易所请求结算明细清单

请求参数：
参数名                类型              是否必须           描述
collateralId         string            Y                CVA账户的唯一标识
settlementId         string            Y                一个结算批次的唯一标识
assetId              string            N                适用于用户主动发起结算的场景，单币种结算

响应参数
参数名                类型              是否必须           描述
settlementId_ex      string            Y                交易所侧的结算批次标识
to_exchange          array             Y                CVA账户向交易所转出的资产列表
> assetid            string            Y                SinoHope的资产标识（对于一币多链的场景，交易所需要按用户CVA地址上的余额拆分明细）
> amount             string            Y                结算金额
> toAddress          string            Y                交易所收款地址
> toTag              string or null    N                交易所收款地址tag
to_collateral        array             Y                交易所向CVA账户转入的资产列表
> assetid            string            Y                SinoHope的资产标识（对于一币多链的场景，按照用户绑定地址时传入的preferedNetwork字段，合并结算资产）
> amount             string            Y                结算金额
> toAddress          string            Y                CVA地址
> toTag              string or null    N                CVA地址tag，不会有共用地址的情况，这个字段是否可以删掉？（待定）
```

### POST /exchange/v1/settlement/confirm #### TBD

```
用户确认账单后，SinoHope通知交易所可开始向CVA地址发起结算

请求参数：
参数名                类型              是否必须           描述
collateralId         string            Y                CVA账户的唯一标识
settlementId         string            Y                一个结算批次的唯一标识
assetId              string            N                适用于用户部分确认的场景（待定）

响应参数
参数名                类型              是否必须           描述

```

### GET /exchange/v1/settlement/status

```
用于SinoHope向交易所查询结算进度

请求参数：
参数名                类型              是否必须           描述
settlementId         string            Y                一个结算批次的唯一标识

响应参数
参数名                类型              是否必须           描述
data                 array             Y                返回该批次内的多个资产的结算进度
> assetid            string            Y                交易所向CVA转出的资产列表
> status             string            Y                结算状态，枚举待定()
> txHash             string or null    N                如已完成转账，返回txHash
```

### POST /exchange/v1/settlement/finish

```
SinoHope结算完成后，通知交易所

请求参数：
参数名                类型              是否必须           描述
settlementId         string            Y                一个结算批次的唯一标识
data                 array             Y                返回该批次内的多个资产的结算进度
> assetid            string            Y                CVA账户向交易所转出的资产列表
> status             string            Y                结算状态，枚举待定
> txHash             string or null    N                如已完成转账，返回txHash

响应参数
参数名                类型              是否必须           描述
```

### POST /exchange/v1/withdraw

```
用户从CVA账户发起提币后，SinoHope向交易所请求授权

请求参数：
参数名                类型              是否必须           描述
collateralId         string            Y                CVA账户的唯一标识
txId                 string            Y                SinoHope定义的提币订单的唯一标识（如提币上链失败，仍然使用相同的txId发起提币请求）
assetId              string            Y                SinoHope的币种标识
amount               string            Y                用户提币金额
fromAddress          string            Y                用户CVA地址（同一币链，多个地址的情况）
fromTag              string            Y                用户CVA地址的tag

响应参数
参数名                类型              是否必须           描述
```


## Exchange->Custody

### POST /collateral/v1/address/status

```
交易所异步处理新增地址的请求，完成后通知SinoHope

请求参数：
参数名                类型              是否必须           描述
requestId            string            Y                本次绑定请求的标识

响应参数
参数名                类型              是否必须           描述
status               boolean           Y                枚举：False/True (失败/成功)；
```

### POST /collateral/v1/settlement

```
交易所主动发起结算，通知SinoHope结算明细清单

请求参数：
参数名                类型              是否必须           描述
settlementId_ex      string            Y                交易所侧的结算批次标识
collateralId         string            Y                CVA账户的唯一标识
to_exchange          array             Y                CVA账户向交易所转出的资产列表
> assetid            string            Y                SinoHope的资产标识（对于一币多链的场景，交易所需要按用户CVA地址上的余额拆分明细）
> amount             string            Y                结算金额
> toAddress          string            Y                交易所收款地址
> toTag              string or null    N                交易所收款地址tag
to_collateral        array             Y                交易所向CVA账户转入的资产列表
> assetid            string            Y                SinoHope的资产标识（对于一币多链的场景，按照用户绑定地址时传入的preferedNetwork字段，合并结算资产）
> amount             string            Y                结算金额
> toAddress          string            Y                CVA地址
> toTag              string or null    N                CVA地址tag，不会有共用地址的情况，这个字段是否可以删掉？

响应参数
参数名                类型              是否必须           描述
settlementId         string            Y                一个结算批次的唯一标识			
```

### GET /collateral/v1/transactions

```
交易所根据SinoHope发起的提币订单号，查询CVA账户提币进展；

请求参数：
参数名                类型              是否必须           描述
txId                 string            Y                提币订单的唯一标识

响应参数
参数名                类型              是否必须           描述
status               string            Y                结算状态，枚举待定
txHash               string or null    N                如已完成提币广播，返回txHash
```

## Client->Custody

### 结算明细通知
```
待定
```

### 结算明细确认
```
待定
```



