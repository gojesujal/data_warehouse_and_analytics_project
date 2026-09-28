-- crm_cust_info
-- 1: Checking for duplicate primary keys
-- Expection: No results

SELECT cst_id, COUNT(cst_id)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(cst_id) > 1;



-- 2: Checking for NULL primary keys
-- Expection: No results

SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL ;


-- 3: Checking for unwanted spaces
-- Expectation: no result

SELECT *
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT *
FROM silver.crm_cust_info
WHERE  cst_lastname != TRIM(cst_lastname);


-- 4: Data Standardization and consistency
SELECT cst_marital_status, cst_gndr
FROM silver.crm_cust_info


----------------------------------------------------

-- crm_prd_info
-- 1: Checking for duplicate primary keys
-- Expection: No results

SELECT prd_id, COUNT(prd_id)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1;




-- 2: Checking for NULL or negative values
-- Expection: No results

SELECT *
FROM silver.crm_prd_info
WHERE prd_id IS NULL ;

SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0 ;



-- 3: Checking for unwanted spaces
-- Expectation: no result

SELECT *
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- 4: Data Standardization and consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- 5: Checking Invalid Dates
-- Expectation: No result

SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt>prd_end_dt
  

-------------------------------------------------------


-- crm_sales_details
-- 1: Checking for unwanted spaces
-- Expection: No results

SELECT *
FROM silver.crm_sales_details
WHERE TRIM(sls_ord_num) != sls_ord_num;


-- 2: Checking for NULL or negative values
-- Expection: No results

SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL;


-- 3: Checking Invalid Dates
-- Expectation: No result

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL OR sls_order_dt <= 0 OR LENGTH(sls_order_dt::TEXT) != 8;

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt IS NULL OR sls_ship_dt <= 0 OR LENGTH(sls_ship_dt::TEXT) != 8;

SELECT *
FROM silver.crm_sales_details
WHERE sls_due_dt IS NULL OR sls_due_dt <= 0 OR LENGTH(sls_due_dt::TEXT) != 8;


SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt;

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt > sls_due_dt;


-- 4: sales data consistency
-- expected: no results

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales IS NULL OR sls_sales <= 0
   OR sls_price IS NULL OR sls_price <= 0
   OR sls_sales != sls_quantity * sls_price;



-----------------------------------------


-- erp_cust_az12

-- 1. Checking for duplicates in primary key
-- Expected: No result

SELECT cid, COUNT(cid)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(cid) > 1;


-- 2. Checking for NULL values in primary key
-- Expected: No result

SELECT cid
FROM silver.erp_cust_az12
WHERE cid IS NULL;


-- 3. Checking for invalid values in bdate
-- Expected: No result

SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate IS NULL;


-- 4. Data standardization
-- Expected: Male, Female or n/a

SELECT DISTINCT(gen)
FROM silver.erp_cust_az12;

SELECT *
FROM silver.erp_cust_az12
WHERE gen IS NULL;












