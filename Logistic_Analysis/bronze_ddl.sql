-- DATA DEFINITION LANGUAGE DEFINES THE STRUCTURE OF DATABASE TABLES
-- bronze schema
-- create schema bronze;
-- create schema silver;
-- create schema gold;

drop table if exists bronze.Transportation_Primary;
create table bronze.Transportation_Primary (
	gps_provider text,
	booking_ID text,
	market_regular varchar(30),
	booking_ID_date date,
	vehicle_no text,
	origin_location text,
	destination_location text,
	org_lat_lon text,
	des_lat_lon text,
	data_ping_time text,
	planned_eta text,
	curr_location text,
	des_location text,
	actual_eta text,
	curr_lat text,
	curr_lon text,
	ontime varchar(30),
	delay varchar(30),
	origin_location_code text,
	destination_location_code text,
	trip_start_date text,
	trip_end_date text,
	distance_in_km text,
	vehicle_type text,
	minimum_kms_covered_in_day text,
	driver_name text,
	driver_phone_no text,
	customer_id text,
	customer_name_code text,
	supplier_id text,
	supplier_name_code text,
	material_shipper text
);

drop table if exists bronze.Transportation_Refined;
create table bronze.Transportation_Refined (
	delivery_id text,
	origin_location text,
	destination_location text,
	region varchar(50),
	created_at timestamp,
	actual_delivery_time timestamp,
	on_time_delivery boolean,
	customer_rating int,
	condition_text text,
	fixed_costs int,
	maintenance int,
	different int,
	area varchar(50),
	delivery_time int
);