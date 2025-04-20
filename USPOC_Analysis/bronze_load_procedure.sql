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
    RAISE NOTICE 'Loading SportBenefitsStatementsDataByYear tables';
    RAISE NOTICE '--------------------------------';

	-- Load SportBenefitsStatementsDataByYear
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.SportBenefitsStatementsDataByYear <<';
        TRUNCATE TABLE bronze.SportBenefitsStatementsDataByYear RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.SportBenefitsStatementsDataByYear <<';
        COPY bronze.SportBenefitsStatementsDataByYear 
		FROM '/tmp/SportBenefitsStatementsDataByYear.csv'
			-- '/Users/miadang/Desktop/DA/USPOC_Analysis/sources/SportBenefitsStatementsDataByYear.csv'
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load SportBenefitsStatementsDataByYear: %', SQLERRM;
    END;

    -- Load NGBHealthDataOutputExtract
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.NGBHealthDataOutputExtract <<';
        TRUNCATE TABLE bronze.NGBHealthDataOutputExtract RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.NGBHealthDataOutputExtract <<';
        COPY bronze.NGBHealthDataOutputExtract 
		FROM '/tmp/NGBHealthDataOutputExtract.csv'
			-- '/Users/miadang/Desktop/DA/USPOC_Analysis/sources/NGBHealthDataOutputExtract.csv' 
        DELIMITER ',' CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load NGBHealthDataOutputExtract: %', SQLERRM;
    END;

    batch_end_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Bronze Layer is completed';
    RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================';
END;
$$;