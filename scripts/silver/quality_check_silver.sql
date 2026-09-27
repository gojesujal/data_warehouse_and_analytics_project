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
