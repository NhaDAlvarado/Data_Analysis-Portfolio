CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
    batch_start_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================';

    RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading CRM tables';
    RAISE NOTICE '--------------------------------';

    -- Load CRM Customer Info
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.crm_cust_info <<';
        TRUNCATE TABLE bronze.crm_cust_info RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.crm_cust_info <<';
        COPY bronze.crm_cust_info FROM '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_crm/cust_info.csv' 
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load CRM Customer Info: %', SQLERRM;
    END;

    -- Load CRM Product Info
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.crm_prod_info <<';
        TRUNCATE TABLE bronze.crm_prod_info RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.crm_prod_info <<';
        COPY bronze.crm_prod_info FROM '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_crm/prod_info.csv' 
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load CRM Product Info: %', SQLERRM;
    END;

    -- Load CRM Sales Details
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.crm_sales_details <<';
        TRUNCATE TABLE bronze.crm_sales_details RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.crm_sales_details <<';
        COPY bronze.crm_sales_details FROM '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_crm/sales_details.csv' 
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load CRM Sales Details: %', SQLERRM;
    END;

    RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading ERP tables';
    RAISE NOTICE '--------------------------------';

    -- Load ERP Customer Data
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.erp_cust_az12 <<';
        TRUNCATE TABLE bronze.erp_cust_az12 RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.erp_cust_az12 <<';
        COPY bronze.erp_cust_az12 FROM '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_erp/cust_az12.csv' 
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load ERP Customer Data: %', SQLERRM;
    END;

    -- Load ERP Location Data
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.erp_loc_a101 <<';
        TRUNCATE TABLE bronze.erp_loc_a101 RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.erp_loc_a101 <<';
        COPY bronze.erp_loc_a101 FROM '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_erp/LOC_A101.csv' 
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load ERP Location Data: %', SQLERRM;
    END;

    -- Load ERP Product Category Data
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.erp_px_cat_g1v2 <<';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2 RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.erp_px_cat_g1v2 <<';
        COPY bronze.erp_px_cat_g1v2 FROM '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_erp/PX_CAT_G1V2.csv' 
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load ERP Product Category Data: %', SQLERRM;
    END;

    batch_end_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Bronze Layer is completed';
    RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================';
END;
$$;
