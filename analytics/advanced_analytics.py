```sql
-- ============================================================
-- TOTAL SALES, CUSTOMERS AND QUANTITY OVER MONTHS
-- ============================================================
-- Analyze monthly sales performance by looking at:
--   - Total sales
--   - Number of unique customers
--   - Total quantity sold
-- ============================================================

SELECT 
  TO_CHAR(order_date, 'YYYY_MM') AS year_month, 
  SUM(sales) AS total_sales,
  COUNT(DISTINCT customer_key) AS total_customers,
  SUM(quantity) AS total_quantity
  
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- ============================================================
-- CUMULATIVE ANALYSIS
-- ============================================================
-- Analyze yearly sales and calculate:
--   - Total sales for each year
--   - Running/cumulative sales
--   - Average sales over time
-- ============================================================


SELECT 
  year,
  total_sales,
  SUM(total_sales) OVER (ORDER BY year) AS running_sales,
  ROUND(AVG(average) OVER (ORDER BY year)) AS moving_average
FROM 
  (SELECT 
    EXTRACT(YEAR FROM order_date) AS year, 
    SUM(sales) AS total_sales,
    AVG(sales) AS average
  
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY 1
  ORDER BY 1);


-- ============================================================
-- PERFORMANCE ANALYSIS
-- ============================================================
-- Compare yearly product sales against:
--   - The product's average yearly sales
--   - The product's previous year's sales
--
-- This helps identify whether product performance is:
--   - Above or below its average
--   - Increasing or decreasing compared to the previous year
-- ============================================================

WITH cte AS
  (SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    product_name, 
    SUM(sales) AS yearly_sales
  FROM gold.fact_sales
  LEFT JOIN gold.dim_products USING(product_key) 
  WHERE order_date IS NOT NULL
  GROUP BY 2,1
  ORDER BY 2,1
  )

SELECT
  year,
  product_name,
  yearly_sales,
  ROUND(yearly_sales - AVG(yearly_sales) OVER (PARTITION BY product_name)) AS avg_diff,
  
  -- Categorize yearly sales compared to the product's average
  CASE 
    WHEN ROUND(yearly_sales - AVG(yearly_sales) OVER (PARTITION BY product_name))>0 THEN 'Above avg'
    WHEN ROUND(yearly_sales - AVG(yearly_sales) OVER (PARTITION BY product_name))<0 THEN 'Below avg'
    ELSE 'Avg'
  END AS avg_change,

  -- Calculate the difference between current year
  -- and previous year's sales
  yearly_sales- LAG(yearly_sales) OVER (PARTITION BY product_name ORDER BY year) AS prev_year_diff,

  -- Categorize the year-over-year sales change
  CASE
    WHEN yearly_sales- LAG(yearly_sales) OVER (PARTITION BY product_name ORDER BY year) >0 THEN 'Increase'
    WHEN yearly_sales- LAG(yearly_sales) OVER (PARTITION BY product_name ORDER BY year) <0 THEN 'Decrease'
    ELSE 'No change'
  END AS prev_year_change
FROM cte;




-- ============================================================
-- CATEGORY CONTRIBUTION TO TOTAL SALES
-- ============================================================
-- Find which product categories contribute the most
-- to the overall sales.
-- ============================================================

SELECT
  category_name,
  CONCAT(ROUND(100*SUM(sales)/ SUM(SUM(SALES)) OVER(),2),'%') AS sales_percent_share
FROM gold.fact_sales 
LEFT JOIN gold.dim_products
USING(product_key)
GROUP BY 1
ORDER BY 2 DESC;


-- ============================================================
-- COUNTRY CONTRIBUTION TO TOTAL QUANTITY
-- ============================================================
-- Find which countries contribute the most
-- to the total quantity sold.
-- ============================================================

SELECT
  country,
  CONCAT(ROUND(100*SUM(quantity)/ SUM(SUM(quantity)) OVER(),2),'%') AS quantity_percent_share
FROM gold.fact_sales 
LEFT JOIN gold.dim_customers 
USING(customer_key)
GROUP BY 1
ORDER BY 2 DESC;



-- ============================================================
-- PRODUCT COST SEGMENTATION
-- ============================================================
-- Categorize products based on their cost and count
-- the number of products in each cost category.
-- ============================================================

SELECT 
  CASE 
    WHEN cost < 100 THEN 'Below 100'
    WHEN cost < 500  THEN 'Between 100-500'
    WHEN cost < 1000 THEN 'Between 500-1000'
    WHEN cost > 1000 THEN 'Above 1000'
  END AS cost_category, 
  COUNT(*)

FROM gold.dim_products
GROUP BY 1;


/* ============================================================
   CUSTOMER SEGMENTATION
   ============================================================
   Group customers into three segments based on their
   spending behavior and customer lifespan:

   - VIP:
     Customers with at least 12 months of history
     and spending more than €5,000.

   - Regular:
     Customers with at least 12 months of history
     but spending €5,000 or less.

   - New:
     Customers with a lifespan of less than 12 months.

   The query finds the total number of customers
   in each group.
   ============================================================ */

WITH cte AS(
  SELECT
    customer_key,

    -- Calculate customer lifespan in months
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12
+
EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS order_lifespan,

    -- Calculate total sales for each customer
    SUM(sales) AS total_sales
    
  FROM gold.fact_sales
  LEFT JOIN gold.dim_customers USING (customer_key)
  GROUP BY 1
  )

SELECT 
  CASE
    WHEN order_lifespan <12 THEN 'New'
    WHEN total_sales > 5000 THEN 'VIP'
    ELSE 'Regular'
  END AS customer_category,
  COUNT(*)
  
FROM cte
GROUP BY 1
ORDER BY 1 DESC;
```
