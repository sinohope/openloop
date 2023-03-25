# Changelog

| Version | Log           | Date       | Modifier |
| ---- | ------------- | ---------- | ------ |
| v1.0.0 | first version | 2023-03-12 | Kevin  |
| v1.1.0 | second version| 2023-03-24 | Kevin  |


# Glossary

Roles: User U, Exchange E, Custodian Platform C.

Main Exchange Account: Abbreviated as MEA. It is an account opened by user U on exchange E, usually identified by an API key.

Collateral Vault Account: Abbreviated as CVA. When user U needs to map assets to exchange E, a CVA is created on custodian platform C. CVA is one-to-one mapped with MEA. The unique ID of CVA is collateralId.


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
