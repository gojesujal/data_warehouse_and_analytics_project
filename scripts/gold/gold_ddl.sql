-- ====================================================================
-- Gold Layer: Dimension & Fact Views
-- ====================================================================
-- Purpose:
--     Create analytical views by integrating and transforming
--     data from the Silver Layer.
--
-- Views:
--     - gold.dim_customers
--     - gold.dim_products
--     - gold.fact_sales
--
-- Data Flow:
--     Bronze → Silver → Gold
-- ====================================================================


-- ====================================================================
-- dim_customers
-- ====================================================================
-- Creates the customer dimension.
-- - Integrates gender from CRM and ERP.
-- - Enriches customer data with birth date and country.
-- - Generates a surrogate customer key.
-- ====================================================================

CREATE VIEW gold.dim_customers AS

SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_no,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,

    -- CRM is the master source for gender
    CASE 
        WHEN ci.cst_gndr IS NULL OR ci.cst_gndr = 'n/a' 
        THEN ca.gen
        ELSE ci.cst_gndr 
    END AS gender,

    ca.bdate AS birth_date,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info AS ci

-- Enrich with birth date and gender
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid

-- Enrich with country
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;


-- ====================================================================
-- dim_products
-- ====================================================================
-- Creates the product dimension.
-- - Enriches products with category information from ERP.
-- - Generates a surrogate product key.
-- - Keeps only currently active products.
-- ====================================================================

CREATE VIEW gold.dim_products AS

SELECT
    ROW_NUMBER() OVER (
        ORDER BY pi.prd_start_dt, pi.prd_key
    ) AS product_key,

    pi.prd_id AS product_id,
    pi.prd_key AS product_number,
    pi.prd_nm AS product_name,
    pi.cat_id AS category_id,
    pc.cat AS category_name,
    pc.subcat AS sub_category_name,
    pc.maintenance,
    pi.prd_cost AS cost,
    pi.prd_line AS line,
    pi.prd_start_dt AS start_date,
    pi.prd_end_dt AS end_date

FROM silver.crm_prd_info AS pi

-- Enrich with category information
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pi.cat_id = pc.id

-- Keep only active products
WHERE pi.prd_end_dt IS NULL;


-- ====================================================================
-- fact_sales
-- ====================================================================
-- Creates the sales fact view.
-- - Adds customer and product surrogate keys.
-- - Connects sales transactions to dimension tables.
-- - Contains sales measures and transaction dates.
-- ====================================================================

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
    sd.sls_price AS price

FROM silver.crm_sales_details AS sd

-- Connect sales to customer dimension
LEFT JOIN gold.dim_customers AS dc 
    ON sd.sls_cust_id = dc.customer_id::VARCHAR

-- Connect sales to product dimension
LEFT JOIN gold.dim_products AS dp 
    ON sd.sls_prd_key = dp.product_number;

