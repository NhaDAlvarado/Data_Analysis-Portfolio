/* move file to tmp for permission (do these cmd in terminal)
cp /path/to/file/flights.csv /tmp/ 
cp /path/to/file/hotels.csv /tmp/ 
cp /path/to/file/users.csv /tmp/ 
*/

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
    RAISE NOTICE 'Loading flights table';
    RAISE NOTICE '--------------------------------';

    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.flights <<';
        TRUNCATE TABLE bronze.flights RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.flights <<';
        COPY bronze.flights 
		FROM '/tmp/flights.csv' 
		WITH CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load flights info: %', SQLERRM;
    END;

	RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading hotels table';
    RAISE NOTICE '--------------------------------';

    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.hotels <<';
        TRUNCATE TABLE bronze.hotels RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.hotels <<';
        COPY bronze.hotels 
		FROM '/tmp/hotels.csv' 
		WITH CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load hotels info: %', SQLERRM;
    END;

    RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading users table';
    RAISE NOTICE '--------------------------------';
    BEGIN
        start_time := clock_timestamp();
        RAISE NOTICE '>> Truncate the table bronze.users <<';
        TRUNCATE TABLE bronze.users RESTART IDENTITY;

        RAISE NOTICE '>> Bulk insert data into bronze.users <<';
        COPY bronze.users 
		FROM '/tmp/users.csv' 
		WITH CSV HEADER;

        end_time := clock_timestamp();
        RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load users info: %', SQLERRM;
    END;

    batch_end_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Bronze Layer is completed';
    RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================';
END;
$$;