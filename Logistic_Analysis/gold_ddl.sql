drop view if exists gold.table_combined;
create view gold.table_combined as 
	select gps_provider,
		p.booking_ID,
		market_regular,
		booking_ID_date,
		vehicle_no,
		p.origin_location,
		case when p.destination_location = 'CUMMINS EMISSIONS SYSTEM,,SATARA,MAHARASHTRA' then 'CUMMINS EMISSIONS SYSTEM,SATARA,MAHARASHTRA'
			when p.destination_location like '%, India' then substring(p.destination_location, 1, position(', India' in p.destination_location) - 1)
			else p.destination_location
		end as destination_location,
		r.region,
		org_lat,
		org_lon,
		des_lat,
		des_lon,
		data_ping_time,
		planned_eta,
		curr_location,
		des_location,
		actual_eta,
		curr_lat,
		curr_lon,
		ontime,
		delay,
		r.on_time_delivery,
		r.customer_rating,
		r.condition_text,
		r.fixed_costs,
		r.maintenance,
		r.different,
		r.area,
		r.delivery_time,
		origin_location_code,
		destination_location_code,
		trip_start_date,
		trip_end_date,
		distance_in_km,
		case when trim(vehicle_type) = '17 FT Container' then 'Large Container Truck'
			when trim(vehicle_type) = '40 FT 3XL Trailer 35MT' then 'Extra-Long Trailer Truck'
			when trim(vehicle_type) = '32 FT Multi-Axle 14MT - HCV' then 'Heavy Cargo Truck'
			when trim(vehicle_type) = '32 FT Single-Axle 7MT - HCV' then 'Medium Cargo Truck'
			when trim(vehicle_type) = '24 FT SXL Container' then 'Medium Container Truck'
			when trim(vehicle_type) = '20 FT SXL Container' then 'Small Container Truck'
			when trim(vehicle_type) = '19 FT OPEN BODY 8 MT' then 'Open-Bed Truck'
			when trim(vehicle_type) = '1 MT Tata Ace (Open Body)' then 'Mini Pickup Truck (Open)'
			when trim(vehicle_type) = '1 MT Tata Ace (Closed Body)' then 'Mini Pickup Truck (Closed)'
			when trim(vehicle_type) = '1.5 MT Pickup (Open Body)' then 'Small Pickup Truck (Open)'
			when trim(vehicle_type) = '24 / 26 FT Taurus Open 21MT - HCV' then 'Flatbed Truck'
			when trim(vehicle_type) = '20 FT CLOSE 7MT-MCV' then 'Box Truck (like delivery trucks)'
			when trim(vehicle_type) = '14 FT Open - 3 MT' then 'Small Utility Truck'
			when trim(vehicle_type) = '1.5 MT Vehicle (Closed Body)' then 'Small Enclosed Van'
	        when trim(vehicle_type) = '15 FT Single-Axle 7.2MT (8.5 H) Container - HCV' then 'Medium Container Truck (15ft)'
	        when trim(vehicle_type) = '17 FT Open 5MT - MCV' then 'Small Open-Bed Truck (17ft)'
	        when trim(vehicle_type) = '19 FT Open 7MT - MCV' then 'Medium Open-Bed Truck (19ft)'
	        when trim(vehicle_type) = '19 FT SXL Container' then 'Medium Container Truck (19ft)'
	        when trim(vehicle_type) = '20 FT Closed Container 8MT' then 'Small Box Truck (20ft)'
	        when trim(vehicle_type) = '20 FT Open 9MT - MCV' then 'Large Open-Bed Truck (20ft)'
	        when trim(vehicle_type) = '22 FT Closed Container' then 'Medium Box Truck (22ft)'
	        when trim(vehicle_type) = '22 FT Open Body 16MT' then 'Large Flatbed Truck (22ft)'
	        when trim(vehicle_type) = '22 FT Taurus Open 16MT - HCV' then 'Heavy Flatbed Truck (22ft)'
	        when trim(vehicle_type) = '24 / 26 FT Closed Container 20MT - HCV' then 'Large Box Truck (24-26ft)'
	        when trim(vehicle_type) = '24 | 26 FT Taurus Open 21MT - HCV' then 'Extra-Long Flatbed Truck (24-26ft)'
	        when trim(vehicle_type) = '25 FT Closed Body 20MT' then 'Large Enclosed Truck (25ft)'
	        when trim(vehicle_type) = '25 FT Open Body 21MT' then 'Extra-Long Open-Bed Truck (25ft)'
	        when trim(vehicle_type) = '26 FT Taurus Open 27MT - HCV' then 'Heavy-Duty Flatbed Truck (26ft)'
	        when trim(vehicle_type) = '27 FT Open Body 21MT' then 'Jumbo Open-Bed Truck (27ft)'
	        when trim(vehicle_type) = '28 FT Open Body 25MT' then 'Mega Open-Bed Truck (28ft)'
	        when trim(vehicle_type) = '30 FT Open MXL 30MT' then 'Giant Flatbed Truck (30ft)'
	        when trim(vehicle_type) = '30 FT Open SXL 30MT' then 'Giant Open Cargo Truck (30ft)'
	        when trim(vehicle_type) = '31 FT Open Body 18MT' then 'Super-Long Open Truck (31ft)'
	        when trim(vehicle_type) = '32 FT Closed Container 15 MT' then 'Extra-Large Box Truck (32ft)'
	        when trim(vehicle_type) = '32 FT Multi-Axle MXL 18MT' then 'Heavy Long-Haul Truck (32ft)'
	        when trim(vehicle_type) = '32 FT Open Taurus' then 'Super-Long Flatbed (32ft)'
	        when trim(vehicle_type) = '37 FT Trailer (Open)' then 'Oversized Open Trailer (37ft)'
	        when trim(vehicle_type) = '40 FT Flat Bed Double-Axle 21MT - Trailer' then 'Big Flatbed Trailer (40ft)'
	        when trim(vehicle_type) = '40 FT Flat Bed Multi-Axle 27MT - Trailer' then 'Heavy-Duty Flatbed Trailer (40ft)'
	        when trim(vehicle_type) = '40 FT Flat Bed Single-Axle 20MT - Trailer' then 'Long Flatbed Trailer (40ft)'
	        when trim(vehicle_type) = '50 FT Flat Bed 30MT - Trailer' then 'Mega Flatbed Trailer (50ft)'
	        when trim(vehicle_type) = 'Mahindra LCV 1MT' then 'Mini Cargo Van'
	        when trim(vehicle_type) = 'Tata 407 / 14 FT Open 3MT LCV' then 'Small Pickup Truck (14ft)'
	        when trim(vehicle_type) = 'Tata 407 Open 2MT - Mini-LCV' then 'Mini Open-Bed Truck'
			when trim(vehicle_type) = '24 / 26 FT  Closed Container  20MT - HCV' then 'Large Enclosed Container Truck (24-26ft)'
			when trim(vehicle_type) = '32 FT Open Tarus' then 'Extra-Long Flatbed Truck (32ft)'
			when trim(vehicle_type) = '20 FT Closed  Container 8MT' then 'Medium Box Truck (20ft)'
			else 'n/a'
		end as vehicle_type,
		minimum_kms_covered_in_day,
		driver_name,
		driver_phone_no,
		customer_id,
		customer_name_code,
		supplier_id,
		supplier_name_code,
		material_shipper
	from silver.Transportation_Primary as p
	left join silver.Transportation_Refined as r
	on p.booking_id = r.delivery_id;