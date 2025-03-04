CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================';

    RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading CRM tables';
    RAISE NOTICE '--------------------------------';

    -- Truncate the table bronze.crm_cust_info
    TRUNCATE TABLE bronze.crm_cust_info RESTART IDENTITY;
    -- Bulk insert data using COPY (from a file)
    EXECUTE format(
        'COPY bronze.crm_cust_info FROM %L DELIMITER '','' CSV HEADER',
        '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_crm/cust_info.csv'
    );

    -- Truncate the table bronze.crm_prod_info
    TRUNCATE TABLE bronze.crm_prod_info RESTART IDENTITY;
    -- Bulk insert data using COPY (from a file)
    EXECUTE format(
        'COPY bronze.crm_prod_info FROM %L DELIMITER '','' CSV HEADER',
        '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_crm/prod_info.csv'
    );

    -- Truncate the table bronze.crm_sales_details
    TRUNCATE TABLE bronze.crm_sales_details RESTART IDENTITY;
    -- Bulk insert data using COPY (from a file)
    EXECUTE format(
        'COPY bronze.crm_sales_details FROM %L DELIMITER '','' CSV HEADER',
        '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_crm/sales_details.csv'
    );

    RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading ERP tables';
    RAISE NOTICE '--------------------------------';

    -- Truncate the table bronze.erp_cust_az12
    TRUNCATE TABLE bronze.erp_cust_az12 RESTART IDENTITY;
    -- Bulk insert data using COPY (from a file)
    EXECUTE format(
        'COPY bronze.erp_cust_az12 FROM %L DELIMITER '','' CSV HEADER',
        '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_erp/cust_az12.csv'
    );

    -- Truncate the table bronze.erp_loc_a101
    TRUNCATE TABLE bronze.erp_loc_a101 RESTART IDENTITY;
    -- Bulk insert data using COPY (from a file)
    EXECUTE format(
        'COPY bronze.erp_loc_a101 FROM %L DELIMITER '','' CSV HEADER',
        '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_erp/LOC_A101.csv'
    );

    -- Truncate the table bronze.erp_px_cat_g1v2
    TRUNCATE TABLE bronze.erp_px_cat_g1v2 RESTART IDENTITY;
    -- Bulk insert data using COPY (from a file)
    EXECUTE format(
        'COPY bronze.erp_px_cat_g1v2 FROM %L DELIMITER '','' CSV HEADER',
        '/Users/miadang/Desktop/DA/DWH_Project/datasets/source_erp/PX_CAT_G1V2.csv'
    );

END;
$$;
