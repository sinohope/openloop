# Changelog

Changes log, dates are displayed in UTC, shows in a reverse order.

### v1.2.1
> 2023/05/12 by Darlzan

- `/exchange/v1/address` : add request feild `settlementNetwork`.
- `/collateral/v1/settlement/tx/build` : remove feilds `network`, `address` in request, they should be determined by the settlement details.
- add security section for all "Exchange->Custody" apis.

### v1.2.0
> 2023/05/04 by Darlzan

- add apis relatied to mpc business

### v1.1.0
> 2023/03/24 by Kevin

Second working version.
### v1.1.0
> 2023/03/12 by Kevin

First version

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
