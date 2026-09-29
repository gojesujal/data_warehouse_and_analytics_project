/*
===============================================================================
Gold Layer: Quality Checks
===============================================================================
Script Purpose:
    This script performs validation checks on the Gold Layer of the data
    warehouse to ensure that the analytical data is accurate, consistent,
    and properly structured.

    The checks focus on:
    - Validating the uniqueness of surrogate keys in dimension tables.
    - Ensuring referential integrity between fact and dimension tables.
    - Verifying that relationships within the Gold Layer data model are valid.

Usage Notes:
    - These checks are intended to be executed after the Gold Layer has been
      populated or refreshed.
    - A valid dataset should return no results for the duplicate-key and
      referential-integrity checks.
    - Any returned records should be investigated before using the Gold Layer
      for reporting or analytical purposes.
    - This script only performs validation and does not modify any data.

Database:
    PostgreSQL

Layer:
    Gold

===============================================================================
*/


-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================

-- Check for duplicate customer surrogate keys
-- Expected: No results

SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================

-- Check for duplicate product surrogate keys
-- Expected: No results

SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================

-- Check referential integrity between fact and dimension tables
-- Expected: No results

SELECT * 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products AS p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL 
   OR c.customer_key IS NULL;
