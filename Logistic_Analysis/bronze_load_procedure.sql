/* move file to tmp for permission (do these cmd in terminal)
cp /Users/miadang/Desktop/DA/logistic_analysis/source/Transportation_Primary.csv /tmp/ 
cp /Users/miadang/Desktop/DA/logistic_analysis/source/Transportation_Refined.csv /tmp/ 
*/

CREATE OR REPLACE PROCEDURE bronze.bronze_load()
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
    RAISE NOTICE 'Loading Transportation_Primary tables';
    RAISE NOTICE '--------------------------------';

	-- Load SportBenefitsStatementsDataByYear
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.Transportation_Primary <<';
        TRUNCATE TABLE bronze.Transportation_Primary RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.Transportation_Primary <<';
        COPY bronze.Transportation_Primary 
		FROM '/tmp/Transportation_Primary.csv'
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load Transportation_Primary: %', SQLERRM;
    END;

    -- Load Transportation_Refined
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.Transportation_Refined <<';
        TRUNCATE TABLE bronze.Transportation_Refined RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.Transportation_Refined <<';
        COPY bronze.Transportation_Refined 
		FROM '/tmp/Transportation_Refined.csv'
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load Transportation_Refined: %', SQLERRM;
    END;

    batch_end_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Bronze Layer is completed';
    RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================';
END;
$$;

-- call bronze.bronze_load();