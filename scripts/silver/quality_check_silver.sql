/*
===============================================================================
Silver Layer Data Quality Checks
===============================================================================

Purpose:
    This script performs data quality checks on the Silver layer to validate
    that the transformed data meets the expected quality and consistency rules.

Checks include:
    - Duplicate primary keys
    - NULL primary keys
    - Unwanted spaces
    - Data standardization
    - Invalid dates
    - Invalid or negative values
    - Data consistency

Expected Result:
    Most validation queries should return NO RESULTS.
    Standardization queries using DISTINCT are used to review the values present.

Tables Checked:
    1. crm_cust_info
    2. crm_prd_info
    3. crm_sales_details
    4. erp_cust_az12
    5. erp_loc_a101
    6. erp_px_cat_g1v2

===============================================================================
*/


-- ============================================================
-- crm_cust_info
-- ============================================================

-- 1: Checking for duplicate primary keys
-- Expected: No results

SELECT 
    cst_id,
    COUNT(cst_id)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(cst_id) > 1;


-- 2: Checking for NULL primary keys
-- Expected: No results

SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;


-- 3: Checking for unwanted spaces
-- Expected: No results

SELECT *
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT *
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);


-- 4: Data standardization and consistency

SELECT 
    cst_marital_status,
    cst_gndr
FROM silver.crm_cust_info;


-- ============================================================
-- crm_prd_info
-- ============================================================

-- 1: Checking for duplicate primary keys
-- Expected: No results

SELECT 
    prd_id,
    COUNT(prd_id)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1;


-- 2: Checking for NULL or negative values
-- Expected: No results

SELECT *
FROM silver.crm_prd_info
WHERE prd_id IS NULL;

SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL
   OR prd_cost < 0;


-- 3: Checking for unwanted spaces
-- Expected: No results

SELECT *
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- 4: Data standardization and consistency

SELECT DISTINCT 
    prd_line
FROM silver.crm_prd_info;


-- 5: Checking invalid dates
-- Expected: No results

SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;


-- ============================================================
-- crm_sales_details
-- ============================================================

-- 1: Checking for unwanted spaces
-- Expected: No results

SELECT *
FROM silver.crm_sales_details
WHERE TRIM(sls_ord_num) != sls_ord_num;


-- 2: Checking for NULL values
-- Expected: No results

SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL;


-- 3: Checking invalid dates
-- Expected: No results

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_order_dt <= 0
   OR LENGTH(sls_order_dt::TEXT) != 8;

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt IS NULL
   OR sls_ship_dt <= 0
   OR LENGTH(sls_ship_dt::TEXT) != 8;

SELECT *
FROM silver.crm_sales_details
WHERE sls_due_dt IS NULL
   OR sls_due_dt <= 0
   OR LENGTH(sls_due_dt::TEXT) != 8;


-- Checking date sequence
-- Expected: No results

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt;

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt > sls_due_dt;


-- 4: Sales data consistency
-- Expected: No results

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales IS NULL
   OR sls_sales <= 0
   OR sls_price IS NULL
   OR sls_price <= 0
   OR sls_sales != sls_quantity * sls_price;


-- ============================================================
-- erp_cust_az12
-- ============================================================

-- 1: Checking for duplicates in primary key
-- Expected: No results

SELECT 
    cid,
    COUNT(cid)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(cid) > 1;


-- 2: Checking for NULL values in primary key
-- Expected: No results

SELECT cid
FROM silver.erp_cust_az12
WHERE cid IS NULL;


-- 3: Checking for invalid values in bdate
-- Expected: No results

SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate IS NULL;


-- 4: Data standardization
-- Expected: Male, Female or n/a

SELECT DISTINCT 
    gen
FROM silver.erp_cust_az12;

SELECT *
FROM silver.erp_cust_az12
WHERE gen IS NULL;


-- ============================================================
-- erp_loc_a101
-- ============================================================

-- 1: Checking for NULL values in primary key
-- Expected: No results

SELECT cid
FROM silver.erp_loc_a101
WHERE cid IS NULL;


-- 2: Checking for unwanted spaces
-- Expected: No results

SELECT *
FROM silver.erp_loc_a101
WHERE cntry != TRIM(cntry);


-- 3: Checking for missing country values
-- Expected: No results

SELECT *
FROM silver.erp_loc_a101
WHERE cntry IS NULL
   OR TRIM(cntry) = '';


-- 4: Data standardization and consistency
-- Expected: Germany, United States or original country value

SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101;


-- 5: Checking for '-' in customer ID
-- Expected: No results

SELECT *
FROM silver.erp_loc_a101
WHERE cid LIKE '%-%';


-- ============================================================
-- erp_px_cat_g1v2
-- ============================================================

-- 1: Checking for NULL primary keys
-- Expected: No results

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;


-- 2: Checking for unwanted spaces
-- Expected: No results

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE TRIM(cat) != cat
   OR TRIM(subcat) != subcat;


-- 3: Data standardization and consistency

SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;
