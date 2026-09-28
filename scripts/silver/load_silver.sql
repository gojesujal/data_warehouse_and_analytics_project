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

-----------------------------------------------------------
  

-- crm_prd_info
-- data derivation: prd_key into cat_id and prd_key
-- replaced null values in prd_cost by 0
-- standardized prd_line
-- Handled invalid dates by replacing end_date by next sale's start_date

TRUNCATE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info(
  prd_id,
  cat_id,
  prd_key,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt,
  prd_end_dt
)

SELECT 
  prd_id,
  REPLACE(LEFT(prd_key,5),'-','_') AS cat_id,
  SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
  prd_nm,
  COALESCE(prd_cost,0) AS prd_cost,

  CASE prd_line 
    WHEN 'M ' THEN 'Mountain' 
    WHEN 'R ' THEN 'Road'
    WHEN 'S ' THEN 'Other Sales'
    WHEN 'T ' THEN 'Touring'
    ELSE 'n/a'
  END AS prd_line,
  
  prd_start_dt,
  
  LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt )-1 AS prd_end_dt
  
FROM bronze.crm_prd_info


---------------------------------------------------


-- bronze.crm_sales_details
-- Handling integer type dates
-- if sales is -ve, NULL or zero, calculate it using quantity*price
-- if price is -ve, make it +ve
-- if price is NULL or zero, calculate it using sales/quantity


TRUNCATE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  CASE  
    WHEN sls_order_dt= 0 OR LENGTH(sls_order_dt::TEXT)!=8 THEN NULL
    ELSE sls_order_dt::VARCHAR::DATE
    END AS sls_order_dt,

  CASE  
    WHEN sls_ship_dt= 0 OR LENGTH(sls_ship_dt::TEXT)!=8 THEN NULL
    ELSE sls_ship_dt::VARCHAR::DATE
    END AS sls_ship_dt,

  CASE  
    WHEN sls_due_dt= 0 OR LENGTH(sls_due_dt::TEXT)!=8 THEN NULL
    ELSE sls_due_dt::VARCHAR::DATE
    END AS sls_due_dt,

  CASE 
    WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity *ABS(sls_price) THEN sls_quantity *ABS(sls_price)
    ELSE sls_sales
  END AS sls_sales,

  sls_quantity,

  CASE 
    WHEN sls_price IS NULL OR sls_price <=0 THEN sls_sales
/NULLIF(sls_quantity,0) 
    ELSE sls_price
  END AS sls_price
  

  
FROM bronze.crm_sales_details




