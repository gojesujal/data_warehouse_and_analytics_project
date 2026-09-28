-- dim_customer
-- we are storing this as a view

--data integration: gender
--data enrichment: added birthdate and country

CREATE VIEW gold.dim_customer AS

SELECT 
  ROW_NUMBER() OVER (ORDER BY ci.cst_id ) AS customer_key,
  ci.cst_id as customer_id,
  ci.cst_key as customer_no,
  ci.cst_firstname as first_name,
  ci.cst_lastname as last_name,
  la.cntry as country,
  ci.cst_marital_status as marital_status,
  
  case when ci.cst_gndr is null or ci.cst_gndr = 'n/a' then ca.gen
    else ci.cst_gndr end as gender, --CRM is master
  
  ca.bdate as birth_date,
  ci.cst_create_date as create_date
  
  
FROM silver.crm_cust_info AS ci
  
LEFT JOIN silver.erp_cust_az12 AS ca
  ON ci.cst_key = ca.cid
  
LEFT JOIN silver.erp_loc_a101 AS la
  ON ci.cst_key = la.cid
  
