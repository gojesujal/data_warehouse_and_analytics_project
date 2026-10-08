# SQL Data Warehouse & Analytics Project

A modern **SQL data warehouse built with PostgreSQL**, following the **Medallion Architecture** to transform raw CRM and ERP data into clean, integrated, analytics-ready datasets.

The project covers the complete workflow from raw data ingestion and ETL to dimensional modeling, data quality validation, and SQL-based analytics.

---

## 📌 Project Overview

This project demonstrates how to build a data warehouse from multiple source systems and prepare the data for analytical workloads.

The main stages of the project are:

1. **Data Ingestion** — Load raw CRM and ERP CSV files into the Bronze layer.
2. **Data Cleaning & Transformation** — Standardize and clean the data in the Silver layer.
3. **Data Integration & Modeling** — Combine the cleaned sources into a Gold-layer dimensional model.
4. **Data Quality** — Validate data consistency, uniqueness, relationships, and business rules.
5. **Analytics** — Perform exploratory and advanced SQL analysis using the Gold layer.

---

## 🏗️ Data Architecture

The warehouse follows the **Medallion Architecture**:

```text
CRM CSV Files ─────┐
                   ├──► Bronze ──► Silver ──► Gold ──► Analytics
ERP CSV Files ─────┘
```

### 🥉 Bronze Layer

The Bronze layer stores the source data with minimal transformation.

It contains raw data from:

* CRM customer data
* CRM product data
* CRM sales data
* ERP customer data
* ERP location data
* ERP product category data

The Bronze layer is responsible for:

* Loading source data
* Preserving the original source structure
* Providing a raw foundation for downstream processing

---

### 🥈 Silver Layer

The Silver layer cleans and standardizes the Bronze data.

Transformations include:

* Removing duplicate records
* Handling NULL and blank values
* Standardizing categorical values
* Cleaning customer and product attributes
* Validating dates
* Handling invalid or future dates
* Deriving product start and end dates
* Integrating related CRM and ERP information

The goal of this layer is to produce **clean, consistent, and reliable data** for dimensional modeling.

---

### 🥇 Gold Layer

The Gold layer contains business-ready data organized using a **star-schema style dimensional model**.

It consists of:

### `gold.dim_customers`

Customer dimension containing:

* Customer key
* Customer ID
* Customer number
* First name
* Last name
* Country
* Marital status
* Gender
* Birth date
* Creation date

Customer information is integrated from the CRM and ERP source systems.

### `gold.dim_products`

Product dimension containing:

* Product key
* Product ID
* Product number
* Product name
* Category
* Sub-category
* Maintenance
* Cost
* Product line
* Start date
* End date

Product category information is enriched using the ERP source data.

### `gold.fact_sales`

Sales fact containing transactional measures and relationships to the customer and product dimensions.

Key measures include:

* Sales
* Quantity
* Price

Key dates include:

* Order date
* Shipping date
* Due date

Surrogate keys are used to connect the fact table with the corresponding dimensions.

---

## 📊 Analytics

The `analytics/` directory contains SQL analyses performed on the Gold layer.

The analysis covers areas such as:

* Database and dimension exploration
* Date and time analysis
* Measures and KPIs
* Changes over time
* Cumulative analysis
* Performance analysis
* Part-to-whole analysis
* Customer segmentation
* Product and customer reporting

The analytical queries are designed to demonstrate practical SQL techniques used to explore data, identify trends, measure performance, and generate business insights.

---

## 🔍 Data Quality

Data quality checks are performed throughout the warehouse to ensure the reliability of the final dataset.

Checks include:

* Duplicate detection
* NULL validation
* Data standardization
* Invalid date detection
* Primary-key uniqueness
* Surrogate-key uniqueness
* Referential integrity
* Fact-to-dimension relationship validation

The Gold layer specifically validates relationships between:

```text
gold.fact_sales
       │
       ├──► gold.dim_customers
       │
       └──► gold.dim_products
```

---

## 📂 Repository Structure

```text
data_warehouse_and_analytics_project/
│
├── analytics/
│   └── SQL queries for data exploration,
│       analysis, reporting, and insights
│
├── datasets/
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── source_erp/
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── docs/
│   ├── Data Warehouse Architecture
│   ├── Data Catalog
│   ├── Data Flow
│   └── Data Model
│
├── scripts/
│   ├── bronze/
│   │   ├── bronze_ddl.sql
│   │   └── load_bronze.sql
│   │
│   ├── silver/
│   │   ├── silver_ddl.sql
│   │   ├── load_silver.sql
│   │   └── quality_check_silver.sql
│   │
│   ├── gold/
│   │   ├── gold_ddl.sql
│   │   └── quality_check_gold.sql
│   │
│   └── init_script.sql
│
└── README.md
```

---

## 🔄 Project Workflow

```text
1. Source CSV Files
        ↓
2. Bronze Layer
        ↓
3. Data Cleaning & Validation
        ↓
4. Silver Layer
        ↓
5. Data Integration & Business Rules
        ↓
6. Gold Layer
        ↓
7. Data Quality Checks
        ↓
8. Analytics
```

---

## 🛠️ Technologies Used

* **PostgreSQL** — Data warehouse database
* **SQL** — ETL, transformations, data validation, and analytics
* **Git & GitHub** — Version control
* **CSV** — Source data format

---

## 🎯 Project Objectives

This project was built to practice and demonstrate:

* SQL and PostgreSQL
* Data warehouse architecture
* Medallion Architecture
* ETL pipelines
* Data cleaning and transformation
* CRM and ERP data integration
* Dimensional modeling
* Star schema design
* Fact and dimension modeling
* Data quality validation
* Analytical SQL
* Git and GitHub workflows

---

## 👤 Author

**Sujal Goje**

Computer Engineering Student

[GitHub](https://github.com/gojesujal)
