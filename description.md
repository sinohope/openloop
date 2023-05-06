# Changelog

| Version | Log           | Date       | Modifier |
| ---- | ------------- | ---------- | ------ |
| v1.0.0 | first version | 2023-03-12 | Kevin  |
| v1.1.0 | second version| 2023-03-24 | Kevin  |
| v1.2.0 | third version | 2023-05-04 | Darlzan  |


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

# Response code definition

Commonly, for all APIs, the HTTP status codes should use those registered by IANA.
See: <https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml>

In OpenLoop, we should use a few well defined HTTP status codes as follow:

- `200`: Successful response. Refer to each API for the detailed response data.
- `400`: Return Bad Request.
- `401`: Unauthorized. Either API details are missing or invalid
- `403`: Forbidden - You do not have access to the requested resource.
- `415`: Unsupported media type. You need to use application/json.
- `500`: Exchange/SinoHope internal error.
