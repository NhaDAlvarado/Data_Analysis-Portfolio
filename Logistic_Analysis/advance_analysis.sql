-- drop view if exists gold.table_updated;
-- create view gold.table_updated as 
-- select gps_provider,
-- 		booking_ID,
-- 		market_regular,
-- 		booking_ID_date,
-- 		vehicle_no,
-- 		origin_location,
-- 		destination_location,
-- 		case when region is null then trim(lower(substring(destination_location from '.*,(.*)')))
-- 			else trim(lower(region))
-- 		end as region,
-- 		org_lat,
-- 		org_lon,
-- 		des_lat,
-- 		des_lon,
-- 		data_ping_time,
-- 		planned_eta,
-- 		curr_location,
-- 		des_location,
-- 		actual_eta,
-- 		curr_lat,
-- 		curr_lon,
-- 		case when ontime = 'G' then true
-- 			else false
-- 		end as on_time_delivery,
-- 		customer_rating,
-- 		condition_text,
-- 		fixed_costs,
-- 		maintenance,
-- 		different,
-- 		area,
-- 		delivery_time,
-- 		origin_location_code,
-- 		destination_location_code,
-- 		trip_start_date,
-- 		trip_end_date,
-- 		distance_in_km,
-- 		vehicle_type,
-- 		minimum_kms_covered_in_day,
-- 		driver_name,
-- 		driver_phone_no,
-- 		customer_id,
-- 		customer_name_code,
-- 		supplier_id,
-- 		supplier_name_code,
-- 		material_shipper
-- from gold.table_combined
-- where (ontime is not null and delay is null)
-- or (ontime is null and delay is not null);

-- What is the on-time delivery rate for each region? 
with cal_delivery_per_region as (
		select region, 
		count(*) as num_delivery 
	from gold.table_updated 
	group by region
),
cal_delivery_on_time as (
	select region,
		count(*) as num_on_time
	from gold.table_updated
	where on_time_delivery = true
	group by region
)
select d.region, 
	num_on_time,
	num_delivery,
	round(100.0*num_on_time/num_delivery ,2) as pct 
from cal_delivery_per_region as d
join cal_delivery_on_time as t
on d.region = t.region
order by pct desc;

-- How does the average delay time vary by vehicle type? 
with expected_times as (
	select vehicle_type,
		actual_eta,
		planned_eta,
		trip_start_date,
		trip_end_date,
		trip_start_date+planned_eta as expected_arrival,
		round(extract(epoch from (actual_eta - (trip_start_date+planned_eta)))/(60*60),2) as delay_hours
	from gold.table_updated
	where actual_eta is not null
		and planned_eta is not null
		and trip_start_date is not null
)
select vehicle_type,
	avg(delay_hours) as avg_delay_hours,
	count(*) as trip_cnt
from expected_times
group by vehicle_type
order by avg_delay_hours desc;

-- Which suppliers or transport providers have the highest and lowest on-time delivery rates?  
select supplier_id, 
	supplier_name_code,
	sum(case when on_time_delivery = true then 1 else 0 end) as on_time_delivery_cnt,
	count(*) as delivery_cnt,
	round(100.0*sum(case when on_time_delivery = true then 1 else 0 end)
			/count(*),2) as on_time_pct
from gold.table_updated
where actual_eta is not null
	and planned_eta is not null
	and trip_start_date is not null
group by supplier_id, supplier_name_code;

-- What is the relationship between distance traveled and fixed costs?  
-- select * from gold.table_updated

-- - How do maintenance costs vary by vehicle type or age?  
-- - Are there significant differences in costs between rural and urban deliveries?  
-- - How does customer rating correlate with on-time delivery?  
-- - Which regions or suppliers have the highest and lowest customer ratings?  
-- - Does weather condition (e.g., sunny, rainy) impact customer ratings?  
-- - Which origin-destination pairs have the longest delays, and why?  
-- - Are there recurring delays on specific routes that need optimization?  
-- - How does the distance of a trip correlate with actual vs. planned ETA?   
-- - Which vehicle types are most efficient in terms of fuel or cost per kilometer?  
-- - Do certain drivers consistently perform better in terms of on-time delivery or customer ratings?  
-- - How does vehicle type impact delivery time and customer satisfaction?  
-- - How do weather conditions (e.g., cloudy, rainy) affect delivery delays?  
-- - Are certain regions more prone to weather-related delays?   
-- - Which suppliers or transport partners have the highest frequency of delays?  
-- - Are there differences in performance between market and regular bookings?  
-- - Are there specific locations (e.g., hubs, cities) with higher congestion or delays?  
-- - How do delivery times vary between rural and urban areas?  
-- - What is the average trip duration for different vehicle types?  
-- - How often do trips exceed the planned ETA, and by how much?  
-- - Are there seasonal or monthly trends in delivery performance?  
-- - How has on-time delivery performance changed over time?  




-- What is the average delivery delay time for late deliveries?
-- How many deliveries were completed on time vs. late per region?
-- What is the average delivery time per vehicle type?
-- Which day of the week has the most delayed deliveries?
-- What is the trend of on-time delivery rate over time (weekly/monthly)?
-- What is the maximum, minimum, and average delay per region?
-- How many deliveries exceeded their planned ETA?
-- What is the distribution of delivery delays across different vehicle types?
-- What percentage of deliveries have missing or null ETA values?
-- Which origin-destination pairs have the longest average delay?
-- Which region has the highest average delivery time?
-- What are the top 10 most delayed delivery routes by frequency?
-- Which areas have the highest number of late deliveries?
-- How does delivery time vary between market and regular deliveries (market_regular)?
-- What is the average distance traveled per delivery in each region?
-- Are there specific regions where the GPS provider is frequently missing or inconsistent?
-- Which routes show a consistent mismatch between planned and actual ETA?
-- Which vehicle types have the highest average maintenance costs?
-- How do fixed costs vary across suppliers or regions?
-- Is there a correlation between maintenance cost and delay frequency?
-- How many vehicles fail to meet their minimum kilometers per day?
-- What is the average cost (fixed + maintenance) per kilometer by vehicle type?
-- Which drivers have the highest on-time delivery rate?
-- Which customers have the lowest average customer ratings?