/*
===============================================================================
Load Bronze Layer
===============================================================================

Script Purpose:
    This script loads raw CSV files into the Bronze layer tables.

    Data is loaded as-is from the source CSV files without transformations.

    Run this script using the psql client:

    psql -d your_database_name -f scripts/bronze/load_bronze.sql

===============================================================================
*/

-- CRM Customer Information
\copy bronze.crm_cust_info
FROM './datasets/source_crm/cust_info.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

-- CRM Product Information
\copy bronze.crm_prd_info
FROM './datasets/source_crm/prd_info.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

-- CRM Sales Details
\copy bronze.crm_sales_details
FROM './datasets/source_crm/sales_details.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

-- ERP Customer Information
\copy bronze.erp_cust_az12
FROM './datasets/source_erp/cust_az12.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

-- ERP Location Information
\copy bronze.erp_loc_a101
FROM './datasets/source_erp/loc_a101.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

-- ERP Product Category Information
\copy bronze.erp_px_cat_g1v2
FROM './datasets/source_erp/px_cat_g1v2.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);
