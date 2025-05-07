-- DROP PROCEDURE IF EXISTS silver.silver_load;

-- CREATE PROCEDURE silver.silver_load()
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE 
-- 	start_time timestamp;
-- 	end_time timestamp;
-- 	batch_start_time TIMESTAMP;
--     batch_end_time TIMESTAMP;
-- BEGIN
-- 	batch_start_time := clock_timestamp();
-- 	RAISE NOTICE '================================';
--     RAISE NOTICE 'Loading Silver Layer';
--     RAISE NOTICE '================================';

-- 	RAISE NOTICE '--------------------------------';
--     RAISE NOTICE 'Loading Transportation_Primary tables';
--     RAISE NOTICE '--------------------------------';
	
-- 	BEGIN
-- 		RAISE NOTICE '>> Truncating table: silver.Transportation_Primary';
-- 		TRUNCATE TABLE silver.Transportation_Primary RESTART IDENTITY;
-- 		RAISE NOTICE '>> Inserting data into silver.Transportation_Primary';
-- 		start_time := clock_timestamp();
-- 		insert into silver.Transportation_Primary (
-- 			gps_provider,
-- 			booking_ID,
-- 			market_regular,
-- 			booking_ID_date,
-- 			vehicle_no,
-- 			origin_location,
-- 			destination_location,
-- 			org_lat,
-- 			org_lon,
-- 			des_lat,
-- 			des_lon,
-- 			data_ping_time,
-- 			planned_eta,
-- 			curr_location,
-- 			des_location,
-- 			actual_eta,
-- 			curr_lat,
-- 			curr_lon,
-- 			ontime,
-- 			delay,
-- 			origin_location_code,
-- 			destination_location_code,
-- 			trip_start_date,
-- 			trip_end_date,
-- 			distance_in_km,
-- 			vehicle_type,
-- 			minimum_kms_covered_in_day,
-- 			driver_name,
-- 			driver_phone_no,
-- 			customer_id,
-- 			customer_name_code,
-- 			supplier_id,
-- 			supplier_name_code,
-- 			material_shipper
-- 		)
		-- select 
		-- 	case when gps_provider = 'NULL' then 'n/a'
		-- 		else gps_provider
		-- 	end as gps_provider,
		-- 	booking_ID,
		-- 	market_regular,
		-- 	booking_ID_date,
		-- 	vehicle_no,
		-- 	origin_location,
		-- 	destination_location,
		-- 	(split_part(org_lat_lon, ',', 1))::numeric as org_lat,
		-- 	(split_part(org_lat_lon, ',', 2))::numeric as org_lon,
		-- 	(split_part(des_lat_lon, ',', 1))::numeric as des_lat,
		-- 	(split_part(des_lat_lon, ',', 2))::numeric as des_lon,
		-- 	case when data_ping_time = 'NULL' then interval '0'
		--         else substring(data_ping_time, '^(\d+):')::int * interval '1 minute' 
		--             + substring(data_ping_time, '(\d+)\.')::int * interval '1 second' 
		--             + substring(data_ping_time, '\.(\d)$')::int * interval '0.1 second'
  --   		end as data_ping_time,
		-- 	case when planned_eta = 'NULL' then interval '0'
		--         else substring(planned_eta, '^(\d+):')::int * interval '1 minute' 
		--            + substring(planned_eta, '(\d+)\.')::int * interval '1 second' 
		--            + substring(planned_eta, '\.(\d)$')::int * interval '0.1 second'
  --   		end as planned_eta,
		-- 	case when curr_location = 'NULL' then 'n/a'
		-- 		else curr_location
		-- 	end as curr_location,
		-- 	des_location,
		-- 	case 
		-- 		when actual_eta = 'NULL' or actual_eta is null or actual_eta = '' then null
		-- 		when actual_eta ~ '^\d{1,2}/\d{1,2}/\d{2} \d{1,2}:\d{2}$' then to_timestamp(actual_eta, 'MM/DD/YY HH24:MI')
		-- 		when actual_eta ~ '^\d{4}-\d{2}-\d{2}' then actual_eta::timestamp
		-- 	end as actual_eta,
		-- 	case when curr_lat = 'NULL' then '0'::numeric
		-- 		else curr_lat::numeric
		-- 	end as curr_lat,
		-- 	case when curr_lon = 'NULL' then '0'::numeric
		-- 		else curr_lon::numeric
		-- 	end as curr_lon,
		-- 	case when ontime = 'NULL' then null
		-- 		else ontime
		-- 	end as ontime,
		-- 	case when delay = 'NULL' then null
		-- 		else delay
		-- 	end as delay,
		-- 	origin_location_code,
		-- 	coalesce(destination_location_code, 'n/a') as destination_location_code,
		-- 	case 
		-- 		when trip_start_date = 'NULL' or trip_start_date is null or trip_start_date = '' then null
		-- 		when trip_start_date ~ '^\d{1,2}/\d{1,2}/\d{2} \d{1,2}:\d{2}$' then to_timestamp(trip_start_date, 'MM/DD/YY HH24:MI')
		-- 		when trip_start_date ~ '^\d{4}-\d{2}-\d{2}' then trip_start_date::timestamp
		-- 		else null
		-- 	end as trip_start_date,
		-- 	case 
		-- 		when trip_end_date = 'NULL' or trip_end_date is null or trip_end_date = '' then null
		-- 		when trip_end_date ~ '^\d{1,2}/\d{1,2}/\d{2} \d{1,2}:\d{2}$' then to_timestamp(trip_end_date, 'MM/DD/YY HH24:MI')
		-- 		when trip_end_date ~ '^\d{4}-\d{2}-\d{2}' then trip_end_date::timestamp
		-- 		else null
		-- 	end as trip_end_date,
		-- 	case when distance_in_km = 'NULL' then '0'::numeric
		-- 		else distance_in_km::numeric
		-- 	end as distance_in_km,
		-- 	case when vehicle_type = 'NULL' then 'n/a'
		-- 		else vehicle_type
		-- 	end as vehicle_type,
		-- 	case when minimum_kms_covered_in_day = 'NULL' then '0'::numeric
		-- 		else minimum_kms_covered_in_day::numeric
		-- 	end as minimum_kms_covered_in_day,
		-- 	trim(driver_name) as driver_name,
		-- 	trim(driver_phone_no) as driver_phone_no,
		-- 	trim(customer_id) as customer_id,
		-- 	trim(customer_name_code) as customer_name_code,
		-- 	supplier_id,
		-- 	trim(supplier_name_code) as supplier_name_code,
		-- 	trim(material_shipper) as material_shipper
		-- from bronze.Transportation_Primary;
	-- 	end_time := clock_timestamp();
	-- 	RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));

	-- EXCEPTION WHEN OTHERS THEN
 --        RAISE NOTICE 'ERROR: Failed to load silver.Transportation_Primary : %', SQLERRM;
 --    END;

	-- RAISE NOTICE '--------------------------------';
 --    RAISE NOTICE 'Loading Transportation_Refined table';
 --    RAISE NOTICE '--------------------------------';
	-- BEGIN
	-- 	RAISE NOTICE '>> Truncating table: silver.Transportation_Refined';
	-- 	TRUNCATE TABLE silver.Transportation_Refined RESTART IDENTITY; 
	-- 	RAISE NOTICE '>> Inserting data into silver.Transportation_Refined';
	-- 	start_time := clock_timestamp();	
	-- 	insert into silver.Transportation_Refined (
	-- 		delivery_id,
	-- 		origin_location,
	-- 		destination_location,
	-- 		region,
	-- 		created_at,
	-- 		actual_delivery_time,
	-- 		on_time_delivery,
	-- 		customer_rating,
	-- 		condition_text,
	-- 		fixed_costs,
	-- 		maintenance,
	-- 		different,
	-- 		area,
	-- 		delivery_time
	-- 	)
		select
			delivery_id,
			origin_location,
			destination_location,
			region,
			created_at,
			actual_delivery_time,
			on_time_delivery,
			customer_rating,
			condition_text,
			fixed_costs,
			maintenance,
			different,
			area,
			delivery_time
		from bronze.Transportation_Refined;
-- 		end_time := clock_timestamp();
-- 		RAISE NOTICE '>> Load duration: % seconds', extract(epoch FROM (end_time - start_time));
-- 	EXCEPTION WHEN OTHERS THEN
--         RAISE NOTICE 'ERROR: Failed to load silver.Transportation_Refined  : %', SQLERRM;
--     END;

-- 	batch_end_time := clock_timestamp();
--     RAISE NOTICE '================================';
--     RAISE NOTICE 'Loading Silver Layer is completed';
--     RAISE NOTICE '>> Total Load duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
--     RAISE NOTICE '================================';
-- END; 
-- $$;