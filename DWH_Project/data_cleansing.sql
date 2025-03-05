/*
==========================================
Insert values to table silver.crm_cust_info
==========================================
*/
BEGIN;
TRUNCATE TABLE silver.crm_cust_info RESTART IDENTITY;
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,    
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
WITH check_for_duplicate AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id 
            ORDER BY cst_create_date DESC
        ) AS flag_last
    FROM bronze.crm_cust_info
)
SELECT 
    cst_id,
    cst_key, 
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM check_for_duplicate
WHERE flag_last = 1 ;
COMMIT;
-- select * from silver.crm_cust_info 

/*
==========================================
Insert values to table silver.crm_prod_info
==========================================
*/
BEGIN;
TRUNCATE TABLE silver.crm_prod_info RESTART IDENTITY;
INSERT INTO silver.crm_prod_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,	
    prd_line,	
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,
    REPLACE(LEFT(prd_key, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key FROM 7) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
    prd_start_dt::DATE,
    (LEAD(prd_start_dt) OVER (PARTITION BY prd_nm ORDER BY prd_start_dt) - INTERVAL '1 day')::DATE AS prd_end_dt
FROM bronze.crm_prod_info;
COMMIT;

-- select * from silver.crm_prod_info 

/*
==========================================
Insert values to table silver.sales_details
==========================================
*/
-- BEGIN;
-- TRUNCATE TABLE silver.crm_sales_details RESTART IDENTITY;
-- INSERT INTO silver.crm_prod_info (
--     sls_prd_key	,
-- 	sls_cust_id	,
-- 	sls_order_dt,
-- 	sls_ship_dt, 
-- 	sls_due_dt,
-- 	sls_sales,	
-- 	sls_quantity,	
-- 	sls_price
-- )

SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
	case 
		when length(sls_order_dt::text) != 8 
				or sls_order_dt = 0 
				or sls_order_dt > 20500101
				or sls_order_dt < 19000101 
			then null
		else TO_DATE(sls_order_dt::text, 'YYYYMMDD') 
	end as sls_order_dt,
	case 
		when length(sls_ship_dt::text) != 8 
				or sls_ship_dt = 0 
				or sls_ship_dt > 20500101
				or sls_ship_dt < 19000101 
			then null
		else TO_DATE(sls_ship_dt::text, 'YYYYMMDD') 
	end as sls_ship_dt,
	case 
		when length(sls_due_dt::text) != 8 
				or sls_due_dt = 0 
				or sls_due_dt > 20500101
				or sls_due_dt < 19000101 
			then null
		else TO_DATE(sls_due_dt::text, 'YYYYMMDD') 
	end as sls_due_dt,
    sls_sales,    
    sls_quantity,    
    sls_price
FROM bronze.crm_sales_details 
ORDER BY sls_cust_id;


