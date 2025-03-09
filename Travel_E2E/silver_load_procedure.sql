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
    RAISE NOTICE 'Loading Users tables';
    RAISE NOTICE '--------------------------------';
	
	BEGIN
		RAISE NOTICE '>> Truncating table: silver.users';
		TRUNCATE TABLE silver.users RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.users';
		start_time := clock_timestamp();
		insert into silver.users (
			code,
			company,
			name ,
			gender,
			age
			)
		select code,
			company,
			name ,
			case when upper(trim(gender)) = 'MALE' then 'Male'
				when upper(trim(gender)) = 'FEMALE' then 'Female'
				else 'n/a'
			end as gender,
			age
		from bronze.users;
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.users : %', SQLERRM;
    END;
	

	RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading Hotels tables';
    RAISE NOTICE '--------------------------------';
	BEGIN
		RAISE NOTICE '>> Truncating table: silver.hotels';
		TRUNCATE TABLE silver.hotels RESTART IDENTITY; 
		RAISE NOTICE '>> Inserting data into silver.hotels';
		start_time := clock_timestamp();
		INSERT INTO silver.hotels (
		    travelCode,
			userCode,
			name,
			place,
			state,
			days,
			price,
			total,
			date 
		)
		SELECT 
			travelCode,
			userCode,
			name,
			left(trim(place), position('(' in trim(place))-1) as place,
			replace(right(trim(place),3),')','') as state,
			days,
			price,
			total,
			date 
		FROM bronze.hotels;
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.hotels : %', SQLERRM;
    END;

	RAISE NOTICE '--------------------------------';
    RAISE NOTICE 'Loading Flights tables';
    RAISE NOTICE '--------------------------------';
	
	BEGIN 
		RAISE NOTICE '>> Truncating table: silver.flights';
		TRUNCATE TABLE silver.flights RESTART IDENTITY;
		RAISE NOTICE '>> Inserting data into silver.flights';
		start_time := clock_timestamp();
		INSERT INTO silver.flights (
		    travelCode,
		    userCode,
		    from_location,
			from_state,
		    to_location,
			to_state,
		    flightType,
		    price,
		    time,  
		    distance,    
		    agency,    
		    date 
		)
		SELECT 
			travelCode,
			userCode,
			left(trim(from_location), position('(' in trim(from_location))-1) as from_location,
			replace(right(trim(from_location),3),')','') as from_state,
			left(trim(to_location), position('(' in trim(to_location))-1) as to_location,
			replace(right(trim(to_location),3),')','') as to_state,
			flightType,
			price,
			time,  
			distance,    
			agency,    
			date 
		FROM bronze.flights;
		end_time := clock_timestamp();
		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
	EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERROR: Failed to load silver.flights  : %', SQLERRM;
    END;

	batch_end_time := clock_timestamp();
    RAISE NOTICE '================================';
    RAISE NOTICE 'Loading Silver Layer is completed';
    RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================';
END; 
$$;
