DROP PROCEDURE IF EXISTS silver.load_silver;

CREATE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE 
	start_time timestamp;
	end_time timestamp;
	batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
	batch_start_time := clock_timestamp();
	RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '================================';

	RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading CRM tables';
    RAISE NOTICE '--------------------------------';
	
	BEGIN
		RAISE NOTICE '>> Truncating table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.crm_cust_info';
		start_time := clock_timestamp();
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
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
		-- select * from silver.crm_cust_info 
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.crm_cust_info : %', SQLERRM;
    END;
	
	BEGIN
		RAISE NOTICE '>> Truncating table: silver.crm_prod_info';
		TRUNCATE TABLE silver.crm_prod_info RESTART IDENTITY; 
		RAISE NOTICE '>> Inserting data into silver.crm_prod_info';
		start_time := clock_timestamp();
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
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.crm_prod_info : %', SQLERRM;
    END;
	-- select * from silver.crm_prod_info 
	
	BEGIN 
		RAISE NOTICE '>> Truncating table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.crm_sales_details';
		start_time := clock_timestamp();
		INSERT INTO silver.crm_sales_details (
		    sls_ord_num,
			sls_prd_key,
		    sls_cust_id,
		    sls_order_dt,
		    sls_ship_dt,
		    sls_due_dt,
		    sls_sales,
		    sls_quantity,
		    sls_price
		)
		SELECT 
		    sls_ord_num,
		    sls_prd_key,
		    sls_cust_id,
		    CASE 
		        WHEN LENGTH(sls_order_dt::text) != 8
		            OR sls_order_dt = 0 
		            OR sls_order_dt > 20500101 
		            OR sls_order_dt < 19000101 
		        THEN NULL
		        ELSE TO_DATE(sls_order_dt::text, 'YYYYMMDD') 
		    END AS sls_order_dt,
		    
		    CASE 
		        WHEN LENGTH(sls_ship_dt::text) != 8
		            OR sls_ship_dt = 0 
		            OR sls_ship_dt > 20500101
		            OR sls_ship_dt < 19000101
		        THEN NULL
		        ELSE TO_DATE(sls_ship_dt::text, 'YYYYMMDD')
		    END AS sls_ship_dt,
		    
		    CASE 
		        WHEN LENGTH(sls_due_dt::text) != 8 
		            OR sls_due_dt = 0
		            OR sls_due_dt > 20500101 
		            OR sls_due_dt < 19000101
		        THEN NULL
		        ELSE TO_DATE(sls_due_dt::text, 'YYYYMMDD')
		    END AS sls_due_dt,
		    
		    CASE 
		        WHEN sls_sales IS NULL 
		            OR sls_sales < 0 
		            OR sls_sales != sls_quantity * ABS(sls_price)
		        THEN sls_quantity * ABS(sls_price)
		        ELSE sls_sales
		    END AS sls_sales, 
		    
		    sls_quantity,
		    
		    CASE 
		        WHEN sls_price IS NULL 
		            OR sls_price < 0 
		        THEN sls_sales / NULLIF(sls_quantity, 0)
		        ELSE sls_price
		    END AS sls_price
		FROM bronze.crm_sales_details;
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.crm_sales_details  : %', SQLERRM;
    END;

	RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading ERP tables';
    RAISE NOTICE '--------------------------------';
	
	BEGIN
		RAISE NOTICE '>> Truncating table: silver.erp_CUST_AZ12';
		TRUNCATE TABLE silver.erp_CUST_AZ12 RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.erp_CUST_AZ12';
		start_time := clock_timestamp();
		INSERT INTO silver.erp_CUST_AZ12 (
		    cid,
		    bdate,
		    gen
		)
		SELECT 
		    CASE 
		        WHEN cid LIKE 'NAS%' AND LENGTH(cid) >= 4 THEN SUBSTRING(cid FROM 4) 
		        ELSE cid
		    END AS cid,
		    
		    CASE 
		        WHEN bdate::date > CURRENT_DATE THEN NULL
		        ELSE bdate::date
		    END AS bdate,
		    
		    CASE 
		        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		        ELSE 'n/a'
		    END AS gen
		FROM bronze.erp_cust_az12;
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.erp_CUST_AZ12  : %', SQLERRM;
    END;	

	BEGIN
		RAISE NOTICE '>> Truncating table: silver.erp_LOC_A101';
		TRUNCATE TABLE silver.erp_LOC_A101 RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.erp_LOC_A101';
		start_time := clock_timestamp();
		INSERT INTO silver.erp_LOC_A101 (
		    cid,
		    cntry
		)
		SELECT 
		    NULLIF(REPLACE(cid, '-', ''), '') AS cid,
		    CASE 
		        WHEN UPPER(TRIM(COALESCE(cntry, ''))) IN ('GERMANY', 'DE') THEN 'Germany'
		        WHEN UPPER(TRIM(COALESCE(cntry, ''))) IN ('UNITED STATES', 'US', 'USA') THEN 'United States'
		        WHEN COALESCE(TRIM(cntry), '') = '' THEN 'n/a'
		        ELSE TRIM(cntry)
		    END AS cntry
		FROM bronze.erp_loc_a101;
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.erp_LOC_A101  : %', SQLERRM;
    END;	

	BEGIN
		RAISE NOTICE '>> Truncating table: silver.erp_PX_CAT_G1V2';
		TRUNCATE TABLE silver.erp_PX_CAT_G1V2  RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.erp_PX_CAT_G1V2';
		start_time := clock_timestamp();
		INSERT INTO silver.erp_PX_CAT_G1V2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT 	id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_PX_CAT_G1V2; 
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.erp_PX_CAT_G1V2  : %', SQLERRM;
    END;

	batch_end_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Silver Layer is completed';
    RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================';
END; 
$$;
