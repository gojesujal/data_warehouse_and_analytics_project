-- dim_customer

--1. Checking for duplicate primary keys
-- Expected: No results

SELECT customer_id, COUNT(*)
FROM gold.dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;
