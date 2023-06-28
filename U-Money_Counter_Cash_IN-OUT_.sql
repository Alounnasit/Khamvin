
----------------------------------U-Money------This Script Using In 10.1.11.224 DATABASES Using Schema U-Money-----------------------
############# U-Money Counter Cash In
SELECT i.bank_account  as FromAcctNo,
       i.ccy           as Ccy,
       i.phone_number  as Wallet,
       i.account_name  as WalletName,
       i.amount        as Amount,
       i.fee           as Fee,
       i.tx            as Tx,
       i.bank_trans_id as TransId,
       i.createat      as CreateAt
FROM tb_log_cash_in i
where content_tx = '000'
  and payment_response_code = '00000'
  and createat between '2023-05-01' and '2023-05-31'

############# U-Money Counter Cash Out
SELECT o.bank_account      as FromAcctNo,
       o.ccy               as Ccy,
       o.phone_number      as Wallet,
       o.account_name      as WalletName,
       o.amount            as Amount,
       o.fee               as Fee,
       o.tx                as Tx,
       o.merchant_trans_id as TransId,
       o.createat          as CreateAt
FROM tb_log_cash_out o
where content_tx = '000'
  and payment_response_code = '00000'
  and createat between '2023-05-01' and '2023-05-31'
