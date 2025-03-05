/*
==========================================
Insert values to table silver.crm_cust_info
==========================================
*/
-- INSERT INTO silver.crm_cust_info (
--     cst_id,
--     cst_key,
--     cst_firstname,    
--     cst_lastname,
--     cst_marital_status,
--     cst_gndr,
--     cst_create_date
-- )
-- WITH check_for_duplicate AS (
--     SELECT *,
--         ROW_NUMBER() OVER (
--             PARTITION BY cst_id 
--             ORDER BY cst_create_date DESC
--         ) AS flag_last
--     FROM bronze.crm_cust_info
-- )
-- SELECT 
--     cst_id,
--     cst_key, 
--     TRIM(cst_firstname) AS cst_firstname,
--     TRIM(cst_lastname) AS cst_lastname,
--     CASE 
--         WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
--         WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
--         ELSE 'n/a'
--     END AS cst_marital_status,
--     CASE 
--         WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
--         WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
--         ELSE 'n/a'
--     END AS cst_gndr,
--     cst_create_date
-- FROM check_for_duplicate
-- WHERE flag_last = 1;


-- -- truncate table silver.crm_cust_info 
-- select * from silver.crm_cust_info 

/*
==========================================
Insert values to table silver.crm_prod_info
==========================================
*/
select prd_id,
	prd_key,
	replace(left(prd_key,5),'-','_') as cat_id, 
	replace(substring(prd_key from 7 for length(prd_key)),'-','_') as prod_key,
	prd_nm,
	coalesce(prd_cost,0) as prd_cost,
	CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Orther Sales'
		WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
	prd_start_dt,
	prd_end_dt
from bronze.crm_prod_info;

