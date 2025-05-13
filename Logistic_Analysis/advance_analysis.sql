-- What is the on-time delivery rate for each region? 
with cal_delivery_per_region as (
		select des_region, 
		count(*) as num_delivery 
	from gold.table_combined
	group by des_region
),
cal_delivery_on_time as (
	select des_region,
		count(*) as num_on_time
	from gold.table_combined
	where on_time_delivery = true
	group by des_region
)
select d.des_region, 
	num_on_time,
	num_delivery,
	round(100.0*num_on_time/num_delivery ,2) as pct 
from cal_delivery_per_region as d
join cal_delivery_on_time as t
on d.des_region = t.des_region
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
	from gold.table_combined
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
			/count(*),2) as on_time_pct,
	round(avg(extract(epoch from (actual_eta - (trip_start_date + planned_eta)))/(60*60)),2) as avg_delay_hours
from gold.table_combined
where actual_eta is not null
	and planned_eta is not null
	and trip_start_date is not null
group by supplier_id, supplier_name_code
order by on_time_pct desc, delivery_cnt desc;

-- What is the relationship between distance traveled and fixed costs?  
with cost_data as (
	select distance_in_km, 
		fixed_costs,
		case when distance_in_km <=100 then '0-100 km'
			when distance_in_km <=500 then '101-500 km'
			when distance_in_km <=1000 then '501-1000 km'
			when distance_in_km <=1500 then '1001-1500 km'
			else '1500+ km'
		end as distance_group
	from gold.table_combined
	where distance_in_km is not null
		and fixed_costs is not null
)
select distance_group,
	count(*) as shipments,
	round(avg(fixed_costs), 2) as avg_fixed_cost,
  round(min(fixed_costs), 2) as min_fixed_cost,
  round(max(fixed_costs), 2) as max_fixed_cost,
  round(avg(fixed_costs::numeric/distance_in_km::numeric), 2) as cost_per_km
from cost_data
group by distance_group
order by cost_per_km;

-- How do maintenance costs vary by vehicle type vs usage?  
select vehicle_type,
	round(avg(maintenance)::numeric,2) as avg_maintenance,
	round(avg(maintenance/ distance_in_km)::numeric,4) as maintenance_cost_per_km,
	round(avg(distance_in_km)::numeric,2) as avg_distance_km,
	count(*) as shipment_cnt
from gold.table_combined
where maintenance is not null
	and distance_in_km is not null
group by vehicle_type
order by maintenance_cost_per_km desc;

-- What is the average delivery time for different distances (short, medium, long-haul)?
select vehicle_type, 
		case when distance_in_km <=500 then 'Short (≤500km)'
			when distance_in_km <=1000 then 'Medium (501-1000km)'
			else 'Long-haul'
		end as distance_group,
		round(avg(delivery_time)::numeric,2) as avg_delivery_time,
		round(avg(distance_in_km/delivery_time)::numeric,2) as avg_speed_kmph
from gold.table_combined
where delivery_time is not null
group by distance_group, vehicle_type
order by distance_group desc, avg_delivery_time desc; 

-- How does delivery performance vary by time of day, day of week, or season?
-- select * from gold.table_combined;


-- What are the most common origin-destination pairs? Are there high-demand routes that need optimization?

-- Is there a correlation between distance covered and on-time delivery?

-- Are drivers consistently meeting the minimum daily km coverage? If not, why?

-- How do actual routes (based on GPS pings) compare to optimal routes?
-- Which vehicle types are most efficient (cost, time, distance) for different delivery types?

-- How does driver performance (on-time delivery, distance covered) vary across regions?

-- Are there specific drivers who consistently outperform or underperform?

-- Does driver experience (based on historical trips) impact delivery success?
-- Who are the top customers/suppliers by delivery volume?

-- Are there frequent delays for specific customers/suppliers? If so, why?

-- How does delivery performance vary by customer/supplier location?

-- Are there high-value customers (frequent/reliable deliveries) that need priority handling?
-- How do urban vs. rural vs. sub-urban deliveries differ in performance?

-- Which regions have the highest delivery demand? Are there underserved areas?

-- Are there seasonal trends in delivery volumes or delays?

-- Do certain origin/destination clusters (based on lat/lon) have unique challenges?
-- Are there gaps in GPS ping data? How does missing data affect ETA accuracy?

-- How often do actual delivery locations (des_lat/des_lon) differ from planned destinations?

-- Are there discrepancies between trip start/end times and GPS tracking data?
-- Are there drivers/vehicles frequently involved in late deliveries?

-- Do certain suppliers/materials consistently cause delays?

-- Are there unusual patterns (e.g., long idle times, detours) that suggest operational issues?