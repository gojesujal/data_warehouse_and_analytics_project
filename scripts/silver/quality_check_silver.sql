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
  







