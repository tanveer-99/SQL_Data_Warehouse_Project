# Data Warehouse and Analytics Project

A data warehouse built in SQL Server that takes raw sales data from two systems, a CRM and an ERP, and turns it into one clean, analysis-ready model.

You load the source files, clean and standardise the data, combine it into a star schema, and then answer business questions with SQL.

```
data-warehouse-project/
├── datasets/               the six source files the project loads
│   ├── source_crm/         three files from the CRM system
│   └── source_erp/         three files from the ERP system
├── docs/                   the diagrams, the data catalog and naming conventions
├── scripts/                the project scripts
│   ├── init_database.sql   creates the database and schemas: run it first
│   ├── bronze/             loads the raw files
│   ├── silver/             cleans and standardises the data
│   └── gold/               builds the views for analysis
├── tests/                  checks the quality of the silver and gold data
└── README.md
```

---

## 🏗️ Data Architecture

The project follows the Medallion Architecture, with **Bronze**, **Silver** and **Gold** layers inside SQL Server.

![High-level architecture](docs/high_level_architecture.png)

1. **Bronze layer:** stores the raw data as-is from the source systems. The CSV files are loaded straight into SQL Server tables.
2. **Silver layer:** cleans, standardises and normalises the data to prepare it for analysis.
3. **Gold layer:** holds the business-ready data, modelled as a star schema for reporting and analytics.

| | Bronze | Silver | Gold |
|---|---|---|---|
| **Definition** | Raw, unprocessed data, as-is from the sources | Clean and standardised data | Business-ready data |
| **Objective** | Traceability and debugging | Prepare data for analysis (intermediate layer) | Provide data for reporting and analytics |
| **Object type** | Tables | Tables | Views |
| **Load method** | Batch, full load (truncate and insert) | Batch, full load (truncate and insert) | None |
| **Transformations** | None | Cleansing, standardisation, normalisation, derived columns, enrichment | Integration, aggregation, business logic and rules |
| **Data model** | None (as-is) | None (as-is) | Star schema |
| **Audience** | Data engineers | Data engineers, analysts | Analysts, business users |

---

## 📖 Project Overview

In this project, I:

1. **Designed the architecture:** a modern data warehouse with three layers, bronze, silver and gold.
2. **Built the ETL pipelines:** loaded the source files and moved the data through the layers.
3. **Modelled the data:** fact and dimension views, ready for reports.
4. **Analysed it:** answered business questions with SQL.

---

## 🛠️ Tools

| Tool | Use |
|---|---|
| SQL Server | The data warehouse |
| SQL Server Management Studio (SSMS) | Writing and running the SQL |
| Git and GitHub | Version control and documentation |

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data sources:** import data from two source systems (ERP and CRM) provided as CSV files.
- **Data quality:** cleanse and resolve data quality issues prior to analysis.
- **Integration:** combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope:** focus on the latest dataset only. Historisation of data is not required.
- **Documentation:** provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics and Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer behaviour**
- **Product performance**
- **Sales trends**

These insights give stakeholders key business metrics and support strategic decision-making.

---

## 📂 Source Data

Two systems deliver six CSV files, loaded from folders on disk.

| System | Table | Content |
|---|---|---|
| CRM | `crm_cust_info` | Customer information |
| CRM | `crm_prod_info` | Current and historical product information |
| CRM | `crm_sales_details` | Transactional records of sales and orders |
| ERP | `erp_cust_az12` | Extra customer information (birthdate, gender) |
| ERP | `erp_loc_a101` | Customer location (country) |
| ERP | `erp_px_cat_g1v2` | Product categories |

---

## 🔗 Data Integration

How the source tables relate to each other. These links are what the gold layer joins on.

| From | To | Join |
|---|---|---|
| `crm_sales_details.sls_prd_key` | `crm_prod_info.prd_key` | Sales to product |
| `crm_sales_details.sls_cust_id` | `crm_cust_info.cst_id` | Sales to customer |
| `crm_prod_info.cat_id` | `erp_px_cat_g1v2.id` | Product to category |
| `crm_cust_info.cst_key` | `erp_cust_az12.cid` | Customer to birthdate and gender |
| `crm_cust_info.cst_key` | `erp_loc_a101.cid` | Customer to country |

The keys don't match as delivered. The silver layer reshapes them (removing prefixes and hyphens, splitting the product key) so the joins work.

---

## ⭐ Data Model (Gold Layer)

The gold layer is a **star schema** with one fact table and two dimensions.

![Data model: star schema](docs/data_model.png)

| Object | Type | What one row represents |
|---|---|---|
| `gold.dim_customers` | Dimension | One customer |
| `gold.dim_products` | Dimension | One product |
| `gold.fact_sales` | Fact | One order line (a product bought by a customer on an order) |

- Dimensions carry a **surrogate key** (`customer_key`, `product_key`), generated in the warehouse.
- The fact table holds those keys as foreign keys, plus the dates and the measures (`sales_amount`, `quantity`, `price`).
- Business rule: `sales_amount = quantity x price`.
- Customer attributes come from three source tables and product attributes from two. The CRM is the master source for gender, with the ERP value as a fallback when the CRM has none.

---

## 🧹 Data Quality Fixes

Every fix follows the same loop: check bronze for the problem, write the fix, check the cleaned result, then load.

| Table | Problem found | Fix |
|---|---|---|
| `crm_cust_info` | Duplicate customer IDs and NULL IDs | Remove NULL IDs, keep the latest record per ID (`ROW_NUMBER`) |
| | Spaces around names | `TRIM` |
| | Codes in marital status and gender (`S`, `M`, `F`) | Map to `Single`, `Married`, `Female`, `Male`, and `n/a` for anything else |
| `crm_prod_info` | Product key holds a category and a product code | Split into `cat_id` and `prd_key` |
| | NULL costs | Replace with `0` |
| | Product line codes | Map to readable names |
| | End date earlier than start date | Derive the end date from the next version's start date minus one day (`LEAD`) |
| | Dates carry a time part | Cast to `DATE` |
| `crm_sales_details` | Dates stored as integers (for example `20250103`), with zeros | Turn bad values into NULL, cast the rest to `DATE` |
| | Sales, quantity and price breaking `sales = quantity x price`, with NULL, zero or negative values | Recalculate sales from quantity and price, derive price from sales and quantity, make negative prices positive |
| `erp_cust_az12` | `NAS` prefix on the customer ID | Remove the prefix so it matches `cst_key` |
| | Birthdates in the future | Set to NULL |
| | Mixed gender values | Standardise to `Male`, `Female`, `n/a` |
| `erp_loc_a101` | Hyphen in the customer ID (`AW-00013676`) | Remove it so it matches `cst_key` |
| | Country abbreviations and blanks | `DE` to `Germany`, `US` and `USA` to `United States`, blank or NULL to `n/a` |
| `erp_px_cat_g1v2` | Checked for spaces and inconsistencies | Loaded as is where clean |

---

## 🏷️ Naming Conventions

All names use `snake_case`, in English, and avoid SQL reserved words.

| Object | Pattern | Example |
|---|---|---|
| Bronze and silver tables | `<sourcesystem>_<entity>` | `crm_cust_info` |
| Gold objects | `<category>_<entity>` | `dim_customers`, `fact_sales` |
| Surrogate keys | `<table>_key` | `customer_key` |
| Technical columns | `dwh_<name>` | `dwh_create_date` |
| Load procedures | `load_<layer>` | `load_bronze` |

Source tables keep their original names in bronze and silver. Gold uses business-friendly names (`dim_`, `fact_`, and `report_` for aggregates).

---

## 📊 Analytics

The gold layer supports the three questions from the requirements. Example queries:

**Customer behaviour:** which countries generate the most sales?
```sql
SELECT
    c.country,
    COUNT(DISTINCT f.customer_key) AS customers,
    SUM(f.sales_amount)            AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sales DESC;
```

**Product performance:** which categories sell best?
```sql
SELECT
    p.category,
    SUM(f.quantity)     AS units_sold,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;
```

**Sales trends:** how do sales change by month?
```sql
SELECT
    YEAR(order_date)  AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;
```

---

## ▶️ How to Run It

1. **Install** SQL Server and SQL Server Management Studio (SSMS), and connect to your instance.
2. **Put the CSV files** in the `datasets/` folders.
3. **Create the database and schemas:** run `scripts/init_database.sql`. This drops and recreates `DataWarehouse`, so don't run it on a database you want to keep.
4. **Bronze:** create the bronze tables, update the file paths inside the load procedure to match where the CSVs are on your machine, then run:
   ```sql
   EXEC bronze.load_bronze;
   ```
5. **Silver:** create the silver tables and run the silver load scripts. Load customers and products before sales.
6. **Gold:** create the views. Create the two dimensions before the fact view.
7. **Check it:** run the quality checks in `tests/`. Each should return no rows.

SQL Server must be able to read the folder holding the CSV files, or `BULK INSERT` fails with "file could not be opened".

---

## ⚠️ Known Data Issues

- The product category `CO_PE` exists in the product table but has no row in the category table, so those products have no category. They are kept, and the category columns show as `n/a` in gold.
- Some source records had invalid values that couldn't be repaired from the data alone (for example some order dates). They are stored as NULL, not guessed.

---

## 🙏 Acknowledgements

This project is based on the open-source [SQL Data Warehouse Project](https://github.com/DataWithBaraa/sql-data-warehouse-project) by Data With Baraa, which provides the source datasets and the project brief. The diagrams, notes and documentation in this repository were written for my own learning.
