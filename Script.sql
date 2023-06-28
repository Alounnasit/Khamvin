-- --------------------------Script Get Mepom --------- --------------------


select ROW_NUMBER() OVER (ORDER BY t1.BRANCH) as RoN, t2.brand_name_la BRANCH_NAME, t1.BRANCH as BRANCH_CODE,
       count(distinct t1.BRANCH_CODE) UNIT_COUNT,
       sum(if((t1.F_APPROVED = true and t1.S_APPROVED = true) and t1.ENABLED = true and date_format(t1.CREATED_DATE, '%Y-%m-%d') between '2023-06-02'and '2023-06-02' ,1,0)) OPEN_IN_DAY,
       sum(if((t1.F_APPROVED = true and t1.S_APPROVED = true) and t1.ENABLED = false and date_format(t1.LAST_MODIFIES_DATE, '%Y-%m-%d') between '2023-06-02'and '2023-06-02',1,0)) CLOSE_IN_DAY,
       sum(if((t1.F_APPROVED = true and t1.S_APPROVED = true) and t1.ENABLED = true and date_format(t1.CREATED_DATE, '%Y-%m-%d') <= '2023-06-02',1,0)) QTY_TOTAL
from TB_APP_CUSTOMER t1 join BRANCHS_VIEW t2 on t1.BRANCH = t2.in_brn
group by t2.brand_name_la, t1.BRANCH;


-- --------------------------Script Get QR --------- --------------------

select ROW_NUMBER() OVER (ORDER BY t2.in_brn) as RoN,
       t2.brand_name_la BRANCH_NAME, t2.in_brn as BRANCH_CODE,
       a.UNIT_COUNT, a.OPEN_IN_DAY, a.CLOSE_IN_DAY,
       a.QTY_TOTAL
    from  BRANCHS_VIEW t2 left outer join
    (
    select
   t1.BRANCH_CODE,
   count(distinct t1.UNIT_CODE) UNIT_COUNT,
   sum(if(t1.STATUS_QR = true and date_format(t1.CREATED_DATE, '%Y-%m-%d') between '2023-05-11' and '2023-05-11',1,0)) OPEN_IN_DAY,
   sum(if(t1.STATUS_QR = false and date_format(t1.LAST_MODIFIED_DATE, '%Y-%m-%d') between '2023-05-11' and '2023-05-11',1,0)) CLOSE_IN_DAY,
   sum(if(t1.STATUS_QR = true and date_format(t1.CREATED_DATE, '%Y-%m-%d') <= '2023-05-11',1,0)) QTY_TOTAL
    from  TB_QR_MERCHANT t1
    group by t1.BRANCH_CODE
) a on t2.in_brn = a.BRANCH_CODE;
------------------------------------------------------------------------------------


select ROW_NUMBER() OVER (ORDER BY t2.in_brn) as RoN,
       t2.brand_name_la BRANCH_NAME, t2.in_brn as BRANCH_CODE,
       a.UNIT_COUNT, a.OPEN_IN_DAY, a.CLOSE_IN_DAY,
       a.QTY_TOTAL
    from  BRANCHS_VIEW t2 left outer join
    (
    select
   t1.BRANCH_CODE,
   count(distinct t1.UNIT_CODE) UNIT_COUNT,
   sum(if(t1.STATUS_QR = true,1,0 )) OPEN_IN_DAY,
   sum(if(t1.STATUS_QR = false ,1,0)) CLOSE_IN_DAY,
   sum(if(t1.STATUS_QR = true ,1,0)) QTY_TOTAL
    from  TB_QR_MERCHANT t1
    group by t1.BRANCH_CODE
) a on t2.in_brn = a.BRANCH_CODE;
-----------------------------------------------------------------------------------

select ROW_NUMBER() OVER (ORDER BY t2.brn_code) as RoN,
       t2.brn_code as UNIT_CODE, t2.brand_name_la UNIT_NAME,
       a.OPEN_IN_DAY, a.CLOSE_IN_DAY,
       a.QTY_TOTAL
    from  tb_add_branches t2 left outer join
    (
    select
   t1.UNIT_CODE,
   sum(if(t1.STATUS_QR = true and date_format(t1.CREATED_DATE, '%Y-%m-%d') between '2023-05-01' and '2023-05-01',1,0)) OPEN_IN_DAY,
   sum(if(t1.STATUS_QR = false and date_format(t1.LAST_MODIFIED_DATE, '%Y-%m-%d') between '2023-05-31' and '2023-05-31',1,0)) CLOSE_IN_DAY,
   sum(if(t1.STATUS_QR = true and date_format(t1.CREATED_DATE, '%Y-%m-%d') <= str_to_date(curdate(), '%Y-%m-%d'),1,0)) QTY_TOTAL  -- <= '2023-05-12',1,0)) QTY_TOTAL

    from  TB_QR_MERCHANT t1
    group by t1.UNIT_CODE
) a on t2.brn_code = a.UNIT_CODE
where t2.in_brn='001800'

-----------------------------------------------------------------------------------
SELECT count(*) from TB_QR_MERCHANT

select * from TB_QR_MERCHANT_OLD

SELECT count(*) from TB_QR_MERCHANT_OLD

select * from TB_QR_MERCHANT_OLD

SELECT count(*) from TB_QR_BANK_CODE

SELECT count(*) from TB_QR_SCAN

select * from TB_QR_MERCHANT_TYPE






-- --------------------------Script Get Payment Road Tax --------- --------------------

select sum(cast(TOTAL_PAY_AMT as INTEGER )) from TB_MOF_ROADTAX_PAYMENT where STATUS = true
and str_to_date(PAY_DATE, '%d/%m/%Y') between '2023-04-19' and '2023-05-16';


-- ------------------------------ Script Get Infor RoadTax -- ------------------------------

select count(*) from TB_APP_CUSTOMER where (S_APPROVED = true and F_APPROVED = true) -- and BRANCH = '000100'
and str_to_date(S_APPROVED_DATE,'%M %e, %Y') between '2023-04-19' and '2023-05-16';


---------------------------------------------LTC--------------------------------------------------

SELECT P.MSISDN as msisdn,
 P.AMOUNT as amount,
 P.FROM_ACCOUNT_NUMBER as fromAccoutNo,
 P.FROM_ACCOUNT_NAME as fromAccountName,
 P.FROM_ACCOUNT_CCY as fromCcy,
 P.TRANSACTION_ID as transId,
 Q.SERVICE_TYPE as serviceType,
 P.CREATE_AT as createAt,
 P.KCB_TX as TX

FROM TB_LTC_TPL_PAYMENT P
INNER JOIN TB_LTC_TPL_QUERY Q on P.QUERY_ID = Q.ID
WHERE P.PROVIDER = 'LTC'
 AND STATUS_TRANSACTION = 1
 AND SERVICE_TYPE IN ('PREPAID') ----Postpaid laiy deuan
AND P.CREATE_AT BETWEEN '2023-05-01' AND '2023-05-31';

--------------------------------------------UNITEL---------------------------------------------------------

SELECT P.MSISDN as msisdn,
 P.AMOUNT as amount,
 P.FROM_ACCOUNT_NUMBER as fromAccoutNo,
 P.FROM_ACCOUNT_NAME as fromAccountName,
 P.FROM_ACCOUNT_CCY as fromCcy,
 P.TRANSACTION_ID as transId,
 Q.SERVICE_TYPE as serviceType,
 P.CREATE_AT as createAt,
 P.KCB_TX as TX
 
FROM TB_UNITEL_PAYMENT  P
INNER JOIN TB_UNITEL_QUERY Q on P.QUERY_ID = Q.ID
WHERE  STATUS_TRANSACTION = 1
 AND SERVICE_TYPE IN ('PREPAID')
AND P.CREATE_AT BETWEEN '2023-05-01' AND '2023-05-31';

--------------------------------------------TPLUS---------------------------------------------------------
SELECT P.MSISDN as msisdn,
 P.AMOUNT as amount,
 P.FROM_ACCOUNT_NUMBER as fromAccoutNo,
 P.FROM_ACCOUNT_NAME as fromAccountName,
 P.FROM_ACCOUNT_CCY as fromCcy,
 P.TRANSACTION_ID as transId,
 Q.SERVICE_TYPE as serviceType,
 P.CREATE_AT as createAt,
 P.KCB_TX as TX
FROM TB_LTC_TPL_PAYMENT P
INNER JOIN TB_LTC_TPL_QUERY Q on P.QUERY_ID = Q.ID
WHERE P.PROVIDER = 'TPLUS'
 AND STATUS_TRANSACTION = 1
 AND SERVICE_TYPE IN ('PREPAID')
AND P.CREATE_AT BETWEEN '2023-06-01' AND '2023-06-27';

--------------------------------------------ETL---------------------------------------------------------
SELECT P.MSISDN as msisdn,
 P.AMOUNT as amount,
 P.FROM_ACCOUNT_NUMBER as fromAccoutNo,
 P.FROM_ACCOUNT_NAME as fromAccountName,
 P.FROM_ACCOUNT_CCY as fromCcy,
 P.TRANSACTION_ID as transId,
 Q.SERVICE_TYPE as serviceType,
 P.CREATE_AT as createAt,
 P.KCB_TX as TX
FROM TB_ETL_PAYMENT P
INNER JOIN TB_ETL_QUERY Q on P.QUERY_ID = Q.ID
WHERE STATUS_TRANSACTION = 1
 AND SERVICE_TYPE IN ('PREPAID')
AND P.CREATE_AT BETWEEN '2023-05-01' AND '2023-05-31';

---------------------------------------Electic----------------------------------------------------------------

SELECT I.CUSTOMER_ID as edlCode,
 I.CUSTOMER_NAME as edlName,
 P.PRO_ID as provinceId,
 P.PRO_NAME as provineName,
 M.FROM_ACCOUNT_NUMBER as fromAccountNo,
 M.FROM_ACCOUNT_NAME as fromAccountName,
 M.FROM_CURRENCY as fromCurrency,
 M.AMOUNT as amount,
 M.TX as tx,
 M.CREATE_AT
FROM TB_EDL_PAYMENT M
INNER JOIN TB_EDL_INQUIRY I ON M.INQUIRY_ID = I.ID
 INNER JOIN TB_EDL_PROVINCE P on I.PROVINCE_ID = P.PRO_ID
WHERE M.STATUS = 1
 AND M.RESPONSE_CODE = '00'
 AND M.CREATE_AT BETWEEN '2023-05-01' AND '2023-05-31'
 
 
 -----------------------------------water supply------------------------------------------------------------------------

SELECT P.BILL_CODE as wsCode,
 P.BILL_NAME as wsName,
 PV.BRANCH_CODE as provinceId,
 PV.PROVINCE_NAME as provinceName,
 P.FORM_ACCOUNT_NUMBER as fromAccountNo,
 P.FORM_ACCOUNT_NAME as fromAccountName,
 P.CURRENCY as currency,
 P.AMOUNT_PAY as amount,
 P.TX as tx,
 P.CREATE_AT as createAt
FROM TB_WATER_SUPPLY_PAYMENT P
INNER JOIN TB_WATER_SUPPLY_PROVINCE PV on P.BRANCH_CODE = PV.BRANCH_CODE
WHERE P.STATUS_PAYMENT = 1
 AND P.CREATE_AT BETWEEN '2023-05-01' AND '2023-05-31'

------------------------------------------------------------------------------------------------------------------------

SELECT MERCHANT_NAME_59 AS MERCHANT_NAME,
 ACCOUNT_NUMBER as ACCOUNT_NUMBER,
 ACCOUNT_NAME as ACCOUNT_NAME,
 TRANSACTION_CURRENCY_53 as CCY,
 MERCHANT_TEL as MERCHANT_TEL,
 CONTACT_PERSON AS CONTACT_PERSON,
 MERCHANT_VILLAGE AS VILLAGE,
 MERCHANT_CITY_90 as CITY,
 MERCHANT_PROVINCE as PROVINCE,
 BRANCH_CODE as BRANCH_CODE,
 UNIT_CODE as UNIT_CODE,
 CREATE_AT as CREATED,
 RECEIVER_ID_38_03 as MERCHANT_ID
FROM TB_QR_MERCHANT M
WHERE STATUS_QR = 1
 AND RECEIVER_ID_38_03 NOT IN (SELECT RECEIVER_ID -- NOT IN ແມ່ນການບໍ່ເຄື່ອນໄຫວ
 FROM (SELECT O.RECEIVER_ID
 FROM TB_TRF_OUT_GOING_TRANSFER O
WHERE O.TO_TYPE = 'QR'
 AND O.TRANSACTION_TYPE = '01'
 AND O.CREATE_AT BETWEEN '2023-05-01' AND '2023-05-31'
 GROUP BY O.RECEIVER_ID
 UNION ALL
 SELECT I.RECEIVER_ID
 FROM TB_TRF_INCOMING_TRANSFER I
WHERE I.RECEIVER_ID LIKE 'APBMCH______'
 AND I.CREATE_AT BETWEEN '2023-05-01' AND '2023-05-31'
 GROUP BY I.RECEIVER_ID) A
GROUP BY RECEIVER_ID);


-----------------------------------Krusi-----------------------------------------

#Kurgsri
SELECT i.CUSTOMER_CODE       as klsCode,
       i.NAME_EN             as klsNameEn,
       i.NAME_LO             as klsNameLo,
       i.CCY                 as klsCcy,
       p.FROM_ACCOUNT_NUMBER as fromAccountNo,
       p.FROM_ACCOUNT_NAME   as fromAccountName,
       p.FROM_CURRENCY       as fromCcy,
       p.PAY_AMOUNT          as amount,
       p.KCB_TX              as tx,
       p.CREATE_AT           as createAt
FROM TB_KLS_PAYMENTS p
         INNER JOIN TB_KLS_INQUIRY i on p.INQUIRY_ID = i.ID
WHERE p.PAYMENT_KCB_STATUS = '000'
  and i.CREATE_AT between '2023-06-01' and '2023-06-25';

------------------------------------kolao------------------------------------------- 

#Kolao
SELECT i.CUSTOMER_CODE    as klCode,
       i.CUSTOMER_NAME    as klName,
       i.CURRENCY         as klCcy,
       p.FROM_ACCT_NUMBER as fromAccountNo,
       p.FROM_ACCT_NAME   as fromAccountName,
       p.FROM_ACCT_CCY    as fromCcy,
       p.AMOUNT           as amount,
       p.TX               as tx,
       p.CREATE_AT        as createAt
FROM TB_KOLAO_PAYMENT p
         INNER JOIN TB_KOLAO_INQUIRY i on p.INQUIRY_ID = i.ID
WHERE p.RESPONSE_CODE = '000'
  and i.CREATE_AT between '2023-01-01' and '2023-06-25';
















