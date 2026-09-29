# SQL Data Warehouse Project

A modern SQL data warehouse project built using **PostgreSQL** and the **Medallion Architecture** to transform raw source data into clean, business-ready data for analytics and reporting.

---

## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture**:
<img width="1268" height="568" alt="Screenshot 2026-09-29 at 9 13 01 AM" src="https://github.com/user-attachments/assets/19e05514-f145-4a39-bad3-ff855cfb5e7b" />


### 🥉 Bronze Layer

Stores raw data loaded from the source systems with minimal transformation.

**Main responsibilities:**

* Load raw source data
* Preserve source-level information
* Provide a foundation for downstream transformations

### 🥈 Silver Layer

Cleans and standardizes the raw Bronze data.

**Main responsibilities:**

* Data cleaning
* Handling NULL and invalid values
* Removing duplicates
* Standardizing formats and values
* Applying transformations and business rules

### 🥇 Gold Layer

Contains business-ready data designed for analytical workloads.

**Main responsibilities:**

* Create dimension and fact views
* Integrate data from multiple source systems
* Generate surrogate keys
* Establish relationships between facts and dimensions
* Prepare data for reporting and analytics

---

## 🔄 ETL Process

The warehouse follows a structured ETL workflow:

```text
Source CSV Files
      │
      ▼
Bronze Layer
      │
      │  Cleaning & Transformation
      ▼
Silver Layer
      │
      │  Data Integration & Modeling
      ▼
Gold Layer
      │
      ▼
Analytics & Reporting
```

---

## 🧩 Data Model

The Gold Layer follows a **star-schema style dimensional model**.

### Dimension Views

#### `gold.dim_customers`

Contains customer information including:

* Customer ID
* Customer number
* First and last name
* Country
* Marital status
* Gender
* Birth date
* Creation date

Customer data is integrated from CRM and ERP sources.

#### `gold.dim_products`

Contains product information including:

* Product ID
* Product number
* Product name
* Category
* Sub-category
* Maintenance
* Cost
* Product line
* Start and end dates

Product information is enriched with category data from ERP.

### Fact View

#### `gold.fact_sales`

Contains sales transactions and connects them to the customer and product dimensions using surrogate keys.

Key measures include:

* Sales
* Quantity
* Price

Key dates include:

* Order date
* Shipping date
* Due date

---

## 🔍 Data Quality

Quality checks are performed throughout the warehouse to improve data reliability.

Examples include:

* Duplicate primary-key checks
* NULL checks
* Data standardization checks
* Invalid date checks
* Referential integrity checks
* Dimension key uniqueness checks
* Fact-to-dimension relationship validation

The Gold Layer specifically validates:

* Uniqueness of customer surrogate keys
* Uniqueness of product surrogate keys
* Referential integrity between `fact_sales` and the customer/product dimensions

---

## 🛠️ Technologies Used

* **PostgreSQL** — Data warehouse database
* **SQL** — Data transformation, validation, and analysis
* **Git & GitHub** — Version control
* **CSV** — Source data format

---

## 📁 Repository Structure

```text
sql_data_warehouse_project/
│
├── datasets/
│   └── Source CSV datasets
│
├── docs/
│   └── Project documentation and data architecture
│
├── scripts/
│   ├── Bronze/
│   ├── Silver/
│   └── Gold/
│
└── README.md
```

---

## 🚀 Project Workflow

1. Load source CSV files into the **Bronze Layer**.
2. Validate the raw data.
3. Transform and clean the data into the **Silver Layer**.
4. Apply business rules and standardization.
5. Build the **Gold Layer** dimensional model.
6. Create customer and product dimensions.
7. Create the sales fact view.
8. Perform Gold Layer quality checks.
9. Use the Gold Layer for analytical queries and reporting.

---

## 🎯 Project Goals

The main goals of this project are to:

* Build a structured SQL data warehouse.
* Practice real-world ETL workflows.
* Understand Medallion Architecture.
* Develop dimensional data models.
* Improve SQL and PostgreSQL skills.
* Implement data quality and validation checks.
* Create analytics-ready datasets.

---

## 👤 Author

**Sujal Goje**

Computer Engineering Student

[GitHub](https://github.com/gojesujal)
