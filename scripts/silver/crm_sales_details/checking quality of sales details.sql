

-- check for unwanted spaces in sls_ord_num
-- Expectation: no results
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);
-- result: good

-- check that every product key in sales exists in the product table
-- Expectation: no results
SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prod_info);
-- result: good

-- check that every customer id in sales exists in the customer table
-- Expectation: no results
SELECT *
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);
-- result: good

--problem: dates are in integer form

-- check for invalid dates in sls_order_dt
-- Expectation: no results
SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
   OR sls_order_dt IS NULL
   OR LEN(sls_order_dt) != 8
   OR sls_order_dt > 20500101      -- far-future boundary
   OR sls_order_dt < 19000101;     -- far-past boundary
-- result: needs to fix

-- check for invalid dates in sls_ship_dt
-- Expectation: no results
SELECT sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
   OR sls_ship_dt IS NULL
   OR LEN(sls_ship_dt) != 8
   OR sls_ship_dt > 20500101      -- far-future boundary
   OR sls_ship_dt < 19000101;     -- far-past boundary
-- result: good

-- check for invalid dates in sls_due_dt
-- Expectation: no results
SELECT sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR sls_due_dt IS NULL
   OR LEN(sls_due_dt) != 8
   OR sls_due_dt > 20500101      -- far-future boundary
   OR sls_due_dt < 19000101;     -- far-past boundary
-- result: good

-- check for invalid date orders
-- Expectation: no results
-- an order can't be shipped or due before it was placed, and shipping after the due date is late
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;
-- result: good

-- Business rules:
-- Sales = quantity*price
-- Negative, zero and null values are not allowed

-- check data consistency: sales = quantity * price
-- negative, zero and NULL values are not allowed
-- Expectation: no results
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales    IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
   OR sls_sales    <= 0    OR sls_quantity <= 0    OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;
-- result: needs to fix

-- rules to fix:
-- if sales is negative, zero or null, derive it using quantity and price
-- if price is zero or null. calculate it using sales and quantity
-- if price is negative, convert to a positive value





