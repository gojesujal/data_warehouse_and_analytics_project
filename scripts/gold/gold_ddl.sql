-- dim_customers
-- we are storing this as a view

--data integration: gender
--data enrichment: added birthdate and country

CREATE VIEW gold.dim_customers AS

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
  



----------------------------------------

-- dim_products

-- added category data from erp

CREATE VIEW gold.dim_products AS

SELECT
  ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt, pi.prd_key) as product_key,
  pi.prd_id AS product_id,
  pi.prd_key AS product_number,
  pi.prd_nm AS product_name,
  pi.cat_id AS category_id,
  pc.cat AS category_name,
  pc.subcat AS sub_category_name,
  pc.maintenance,
  pi.prd_cost AS cost,
  pi.prd_line as line,
  pi.prd_start_dt as start_date,
  pi.prd_end_dt as end_date
  

FROM silver.crm_prd_info AS pi

LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pi.cat_id = pc.id

WHERE pi.prd_end_dt IS NULL


----------------------------------------------



-- fact_sales

-- added surrogate keys to connect dimension tables 

CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num AS order_number,
dp.product_key,
dc.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales,
sd.sls_quantity AS quantity,
sd.sls_price as price

FROM silver.crm_sales_details as sd

LEFT JOIN gold.dim_customers AS dc ON sd.sls_cust_id = dc.customer_id::VARCHAR

LEFT JOIN gold.dim_products AS dp ON sd.sls_prd_key = dp.product_number





