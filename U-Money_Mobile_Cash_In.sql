-- ------------------------------U-Money------------------------------
############ U-Money Mobile Cash In
SELECT F.FROM_ACCOUNT_NUMBER as FromAcctNo,
       F.FROM_ACCOUNT_CCY    as Ccy,
       F.ACCOUNT_UMONEY      as Wallet,
       G.ACCOUNT_NAME        as WalletName,
       F.AMOUNT              as Amount,
       F.FEE                 as Fee,
       F.KCB_TX              as Tx,
       F.APB_TRANS_ID        as TransId,
       F.CREATE_AT           as CreateAt
FROM TB_UM_TRANSFER F
         INNER JOIN TB_UM_ACCOUNT_INFO G on F.GET_ACCOUNT_INFO = G.ID
WHERE F.UM_RES_CODE = '00000'
  AND F.CREATE_AT BETWEEN '2023-03-01' and '2023-03-31';
