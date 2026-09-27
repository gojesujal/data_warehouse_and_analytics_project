-- crm_cust_info
-- removing duplicate primary key by selecting the latest data
-- removing unwanted spaces
-- data standardisation: cst_gndr
-- data standardisation: cst_marital_status

TRUNCATE TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date
)

  
SELECT 
  cst_id,
  cst_key,
  TRIM(cst_firstname) as cst_firstname,
  TRIM(cst_lastname) as cst_lastname,
  
  CASE cst_marital_status WHEN  'M' THEN 'Married' WHEN  'S' THEN 'Single' ELSE 'n/a' END as cst_marital_status,
  
  CASE cst_gndr WHEN  'F' THEN 'Female' WHEN  'M' THEN 'Male' ELSE 'n/a' END as cst_gndr,
  cst_create_date
  
FROM(
  SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_latest 
  FROM bronze.crm_cust_info
  WHERE cst_id is not NULL

  )
WHERE flag_latest = 1









