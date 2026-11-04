-- check for duplicates or NULLs in the primary key
-- Expectation: no results
USE DataWarehouse
SELECT
    prd_id,
    COUNT(*)
FROM bronze.crm_prod_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;
-- from results, we can see there are no duplicate primary keys


-- check for unwanted spaces in prd_nm
-- Expectation: no results
SELECT *
FROM bronze.crm_prod_info
WHERE prd_nm != TRIM(prd_nm);
-- result: good


-- check for NULLs or negative numbers in prd_cost
-- Expectation: no results
SELECT *
FROM bronze.crm_prod_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
-- result: we have two nulls


-- check data standardisation and consistency in prd_line
-- Expectation: a short list of consistent values
SELECT DISTINCT prd_line
FROM bronze.crm_prod_info;

-- change the prd_line to full meaning from abbreviation for data standardization and consistency 


-- check for invalid date orders (end date before start date)
-- Expectation: no results
SELECT *
FROM bronze.crm_prod_info
WHERE prd_end_dt < prd_start_dt;

/*
Problem: invalid date order
    In crm_prod_info, each row is one version of a product, with a start date and an
    end date showing when that version was valid. In some rows the end date comes
    before the start date, which is impossible. The end dates in the source are
    unreliable, so any report that asks which version of a product was valid on a
    given day could return wrong or contradictory answers.

Solution:
    Stop trusting the stored end date and derive it from the start dates instead.
    For each product, order its versions by start date. A version ends the day before
    the next version starts, so its end date becomes the next version's start date
    minus one day. The newest version has no next version, so its end date stays
    NULL, which correctly means it is still current. Every product then has a clean
    timeline where each version follows the last with no gaps or overlaps.

Assumption:
    This only works if a product's versions don't overlap and the start dates
    themselves are right. Check a few of the bad rows first to confirm that.
*/

SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt_test
FROM bronze.crm_prod_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');



-- check after cleaning and insertion


-- quality check: silver.crm_prod_info

-- check for duplicates or NULLs in the primary key
-- Expectation: no results
USE DataWarehouse;

SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prod_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- check for unwanted spaces in prd_nm
-- Expectation: no results
SELECT *
FROM silver.crm_prod_info
WHERE prd_nm != TRIM(prd_nm);


-- check for NULLs or negative numbers in prd_cost
-- Expectation: no results (the NULLs were replaced with 0)
SELECT *
FROM silver.crm_prod_info
WHERE prd_cost < 0 OR prd_cost IS NULL;


-- check data standardisation and consistency in prd_line
-- Expectation: only full names (Mountain, Road, Other Sales, Touring) and n/a
SELECT DISTINCT prd_line
FROM silver.crm_prod_info;


-- check for invalid date orders (end date before start date)
-- Expectation: no results
SELECT *
FROM silver.crm_prod_info
WHERE prd_end_dt < prd_start_dt;


-- spot check one product's timeline
-- Expectation: each version ends the day before the next one starts, the last one has a NULL end date
SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt
FROM silver.crm_prod_info
WHERE prd_key IN ('HL-U509-R', 'HL-U509')
ORDER BY prd_key, prd_start_dt;
