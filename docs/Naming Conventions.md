# Naming Conventions

These are the naming rules for everything in the data warehouse: schemas, tables, views, columns and stored procedures. Following them keeps names predictable, so anyone can tell what an object is and where it came from just by reading its name.

## Contents

1. [General Principles](#general-principles)
2. [Table Naming](#table-naming)
   - [Bronze Layer](#bronze-layer)
   - [Silver Layer](#silver-layer)
   - [Gold Layer](#gold-layer)
3. [Column Naming](#column-naming)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure Naming](#stored-procedure-naming)
5. [Quick Reference](#quick-reference)

---

## General Principles

| Rule | What it means |
|---|---|
| **snake_case** | Write all names in lowercase, with words separated by underscores (`_`), e.g. `customer_info`. |
| **English only** | Use English for every name. |
| **No reserved words** | Never use SQL reserved words as names, e.g. `order`, `user`, `group`, `select`. |

---

## Table Naming

### Bronze Layer

**Pattern:** `<sourcesystem>_<entity>`

- `<sourcesystem>` is the system the data comes from, e.g. `crm` or `erp`.
- `<entity>` is the table's original name from the source system. Keep it exactly as it is, with no renaming.

**Example:** `crm_customer_info` holds customer information from the CRM system.

### Silver Layer

**Pattern:** `<sourcesystem>_<entity>`

Silver uses the same rules as bronze: start with the source system name and keep the original table name. Silver tables mirror bronze one-to-one, so a table keeps the same name in both layers.

**Example:** `bronze.crm_customer_info` → `silver.crm_customer_info`

### Gold Layer

**Pattern:** `<category>_<entity>`

- `<category>` is a prefix that shows what role the table plays, e.g. `dim` or `fact`.
- `<entity>` is a clear, business-friendly name that matches the business domain, e.g. `customers`, `products` or `sales`.

**Examples:**
- `dim_customers` is the dimension table for customer data.
- `fact_sales` is the fact table holding sales transactions.

#### Category Prefixes

| Prefix | Meaning | Examples |
|---|---|---|
| `dim_` | Dimension table | `dim_customers`, `dim_products` |
| `fact_` | Fact table | `fact_sales` |
| `report_` | Report table | `report_customers`, `report_sales_monthly` |

---

## Column Naming

### Surrogate Keys

**Pattern:** `<table_name>_key`

Every primary key in a dimension table ends with `_key`.
- `<table_name>` is the table or entity the key belongs to.
- `_key` marks the column as a surrogate key.

**Example:** `customer_key` is the surrogate key in `dim_customers`.

### Technical Columns

**Pattern:** `dwh_<column_name>`

Every technical column starts with `dwh_`.
- `dwh_` is reserved for system-generated metadata only, never for business data.
- `<column_name>` describes what the column is for.

**Example:** `dwh_create_date` stores the date a record was loaded into the warehouse.

---

## Stored Procedure Naming

**Pattern:** `load_<layer>`

Every stored procedure that loads data is named after the layer it loads. `<layer>` is the target layer, e.g. `bronze` or `silver`.

**Examples:**
- `load_bronze` loads data into the bronze layer.
- `load_silver` loads data into the silver layer.

---

## Quick Reference

| Object | Pattern | Example |
|---|---|---|
| Bronze table | `<sourcesystem>_<entity>` | `bronze.crm_customer_info` |
| Silver table | `<sourcesystem>_<entity>` | `silver.crm_customer_info` |
| Gold object | `<category>_<entity>` | `gold.dim_customers`, `gold.fact_sales` |
| Surrogate key | `<table_name>_key` | `customer_key` |
| Technical column | `dwh_<column_name>` | `dwh_create_date` |
| Load procedure | `load_<layer>` | `load_bronze`, `load_silver` |
