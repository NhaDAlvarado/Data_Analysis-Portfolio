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
with delivery_metrics as (
  select 
    case  -- Time of Day Analysis (Morning/Afternoon/Evening/Night)
      when extract (hour from trip_start_date) between 5 and 11 then 'Morning (5-11 AM)'
      when extract (hour from trip_start_date) between 12 and 17 then 'Afternoon (12-5 PM)'
      when extract (hour from trip_start_date) between 18 and 23 then 'Evening (6-11 PM)'
      else 'Night (12-4 AM)'
    end as time_of_day,
    -- Day of Week Analysis
    to_char(trip_start_date, 'Day') as day_of_week,
    -- Seasonal Analysis
    case 
      when extract (month from trip_start_date) in (12, 1, 2) THEN 'Winter'
      when extract (month from trip_start_date) in (3, 4, 5) THEN 'Spring'
      when extract (month from trip_start_date) in (6, 7, 8) THEN 'Summer'
      else 'Fall'
    end as season,
    on_time_delivery
  from gold.table_combined
  where trip_start_date is not null
)
select -- Time of Day Performance
  'Time of Day' as measure_dimension,
  time_of_day as category,
  count(*) as total_shipments,
  sum(case when on_time_delivery then 1 else 0 end) as on_time_count,
  round(100.0 * sum(case when on_time_delivery then 1 else 0 end) / count(*), 2) as on_time_pct
from delivery_metrics
group by time_of_day

union all

select -- Day of Week Performance
  'Day of Week' as measure_dimension,
  day_of_week as category,
  count(*) as total_shipments,
  sum(case when on_time_delivery then 1 else 0 end) as on_time_count,
  round(100.0 * sum(case when on_time_delivery then 1 else 0 end) / count(*), 2) as on_time_pct
from delivery_metrics
group by day_of_week

union all

select -- Seasonal Performance
  'Season' as measure_dimension,
  season as category,
  count(*) as total_shipments,
  sum(case when on_time_delivery then 1 else 0 end) as on_time_count,
  round(100.0 * sum(case when on_time_delivery then 1 else 0 end) / count(*), 2) as on_time_pct
from delivery_metrics
group by season
order by measure_dimension, on_time_pct DESC;

-- What are the most common origin-destination pairs? Are there high-demand routes that need optimization?
with routes_analysis as (
	select least(origin_region, des_region) 
			|| ' <-> ' 
			||greatest(origin_region, des_region) as route,
			origin_region, 
			des_region,
			count(*) as shipments_cnt,
			round(avg(distance_in_km)::numeric,2) as avg_distance_km,
			sum(case when on_time_delivery is true then 1 else 0 end) as on_time_cnt,
			round(100.0*sum(case when on_time_delivery is true then 1 else 0 end)/count(*),2) as on_time_pct,
			round(avg(distance_in_km::numeric/nullif(delivery_time,0)),2) as avg_speed_kmph
	from gold.table_combined
	where origin_region is not null 
	and des_region is not null 
	group by route, origin_region, des_region
)
select route,
	shipments_cnt,
	avg_distance_km,
	on_time_pct,
	avg_speed_kmph,
	case  
	    when shipments_cnt > 100 and on_time_pct < 80 then 'High Volume, Low Reliability'
	    when avg_speed_kmph < 30 THEN 'Low Speed Alert'
		when avg_speed_kmph is null then 'Need Information'
	    else 'Normal'
	end as optimization_priority
from routes_analysis 
order by optimization_priority desc, shipments_cnt desc;

-- Is there a correlation between distance covered and on-time delivery?
select case when distance_in_km <=100 then '0-100 km'
			when distance_in_km <=500 then '101-500 km'
			when distance_in_km <=1000 then '501-1000 km'
			when distance_in_km <=1500 then '1001-1500 km'
			else '1500+ km'
		end as distance_group,
		sum(case when on_time_delivery is true then 1 else 0 end) as on_time_cnt,
		count(*) as shipments_cnt,
		round(100.0*sum(case when on_time_delivery is true then 1 else 0 end)/count(*),2) as on_time_pct
from gold.table_combined
group by distance_group;

-- Are drivers consistently meeting the minimum daily km coverage? If not, why?
with driver_daily_performance as (
	select driver_name,
		trip_start_date::date as delivery_date,
		sum(distance_in_km) as actual_kms_covered, 
		max(minimum_kms_covered_in_day) as target_kms,
		sum(distance_in_km) - max(minimum_kms_covered_in_day) as kms_variance,
		count(*) as shipments_completed,
		round(100.0*sum(case when on_time_delivery is true then 1 else 0 end)/count(*),2) as on_time_pct,
		count(distinct origin_region || ' -> ' || des_region) as unique_routes,
		round(avg(distance_in_km)::numeric,2) as avg_shipment_distance
	from gold.table_combined
	where minimum_kms_covered_in_day >0
	and distance_in_km > 0
	and trip_start_date is not null 
	group by driver_name, delivery_date
	having max(minimum_kms_covered_in_day) >0 
)
select driver_name,
		count(*) as days_worked,
		sum(case when actual_kms_covered >= target_kms then 1 else 0 end) as days_met_target,
		round(100.0*sum(case when actual_kms_covered >= target_kms then 1 else 0 end)/count(*),2) as target_compliance_pct,
		round(avg(kms_variance)::numeric,2) as avg_daily_kms_variance,
		round(avg(actual_kms_covered)::numeric,2) as avg_actual_kms,
		round(avg(target_kms)::numeric,2) as avg_target_kms,
		round(avg(on_time_pct), 2) as avg_on_time_pct,
		round(avg(unique_routes), 2) as avg_unique_routes_per_day,
		round(avg(avg_shipment_distance), 2) as avg_shipment_distance,
		sum(case when shipments_completed <3 then 1 else 0 end) as low_shipment_days
from driver_daily_performance
group by driver_name
order by target_compliance_pct desc,
	avg_daily_kms_variance;

-- Which vehicle types are most efficient (cost, time, distance) for different delivery types?
with vehicle_stats as (
	select vehicle_type, 
	round(avg(fixed_costs)::numeric,2) as avg_fixed_costs,
	round(avg(maintenance),2) as avg_maintenance,
	round(avg(distance_in_km)::numeric,2) as avg_distance_in_km,
	round(avg(delivery_time),2) as avg_delivery_time,
	round(avg(distance_in_km::numeric/nullif((delivery_time/60),0)),2) as avg_speed_kmph,
	avg(case when on_time_delivery is true then 1 else 0 end) as on_time_rate,
	count(*) as shipments_cnt
from gold.table_combined
-- where fixed_costs is not null
-- 	and delivery_time is not null 
group by vehicle_type
)
select
	vehicle_type,
	avg_fixed_costs,
	avg_maintenance,
	round(avg_fixed_costs + avg_maintenance, 2) AS total_avg_cost,
	avg_distance_in_km,
	avg_delivery_time,
	avg_speed_kmph,
	round((avg_distance_in_km / nullif(avg_fixed_costs + avg_maintenance, 0)), 2) as km_per_cost_unit,
	shipments_cnt,
	round(100.0*on_time_rate, 2) as on_time_pct,
	round(
	0.3 * (avg_distance_in_km / nullif(avg_fixed_costs + avg_maintenance, 0))
	+ 0.4 * avg_speed_kmph
	+ 0.3 * on_time_rate
	, 2) as efficiency_score
from vehicle_stats
order by efficiency_score desc, total_avg_cost asc;

-- Who are the top customers/suppliers by delivery volume?
with customer_metrics as (
	select customer_id, 
		customer_name_code,
		count(*) as shipments_cnt,
		round(100.0*sum(case when on_time_delivery is true then 1 else 0 end)/count(*),2) as on_time_pct,
		count(distinct date_trunc('month', booking_id_date)) as active_months,
		count(distinct origin_region) as origin_regions_covered,
	    count(distinct des_region) as destination_regions_covered,
	    max(booking_id_date) as last_shipment_date
	from gold.table_combined
	where customer_id is not null
	group by customer_id, customer_name_code
)
select customer_id, 
	customer_name_code,
	shipments_cnt,
	case when shipments_cnt > 100 then 'Platinum'
	    when shipments_cnt > 50 then 'Gold'
	    when shipments_cnt > 20 then 'Silver'
		else 'Bronze'
  	end as customer_tier,
	on_time_pct,
	round(shipments_cnt/nullif(active_months,0),2) as shipments_per_month,
	origin_regions_covered,
	destination_regions_covered,
	last_shipment_date,
	current_date - last_shipment_date ::date as date_since_last_shipment
from customer_metrics
order by shipments_cnt desc;

-- Are there frequent delays for specific customers/suppliers? If so, why?
with supplier_delays AS (
  select
    supplier_id,
    supplier_name_code,
    count(*) as total_shipments,
    sum(case when on_time_delivery is false then 1 else 0 end) as delayed_shipments,
    round(100.0 * sum(case when on_time_delivery is false then 1 else 0 end) / count(*), 2) as delay_percentage,
    round(avg(distance_in_km)::numeric, 2) as avg_distance,
    mode() within group (order by vehicle_type) as most_common_vehicle,
    count(distinct driver_name) as driver_count,
    round(avg(extract(epoch from (actual_eta - (planned_eta + trip_start_date))/3600)), 2) AS avg_eta_deviation_hours,
    mode() within group (order by material_shipper) AS most_common_material
  from gold.table_combined
  where supplier_id is not null
  group by supplier_id, supplier_name_code
)
select
  supplier_id,
  supplier_name_code,
  total_shipments,
  delayed_shipments,
  delay_percentage,
  avg_distance,
  most_common_vehicle,
  driver_count,
  avg_eta_deviation_hours,
  most_common_material,
  case
    when delay_percentage > 30 and avg_distance > 500 then 'Long-Haul Challenges'
    when delay_percentage > 30 and driver_count < 3 then 'Limited Driver Pool'
    when delay_percentage > 30 and most_common_vehicle in ('Small Truck', 'Van') then 'Vehicle Capacity Issues'
    when delay_percentage > 30 and most_common_material in ('Perishable', 'Fragile') then 'Special Handling Delays'
	when delay_percentage > 30 then 'General Performance Issues'
    else 'Within Acceptable Thresholds'
  end as delay_profile
from supplier_delays
order by delay_percentage;

-- How do urban vs. rural vs. sub-urban deliveries differ in performance?
-- select * from gold.table_combined;
select des_area,
	count(distinct booking_id) as booking_count,
    sum(case when on_time_delivery is true then 1 else 0 end) as ontime_shipments,
    round(100.0 * sum(case when on_time_delivery is true then 1 else 0 end) / count(*), 2) as on_time_pct,
    round(avg(distance_in_km)::numeric, 2) as avg_distance,
    round(avg(extract(epoch from (actual_eta - (planned_eta + trip_start_date))/3600)), 2) AS avg_eta_deviation_hours,
	count(distinct supplier_name_code) as unique_supplier,
	mode() within group (order by vehicle_type) as common_vehicle_type,
    mode() within group (order by material_shipper) AS most_common_material
from gold.table_combined
where des_area is not null
    and des_area != 'Unknown'
group by des_area; 

-- How often do actual delivery locations (curr_lat/curr_lon) differ from planned destinations?
with delivery_deviations as (
	select
	    booking_ID,
	    -- Calculate approximate distance using Pythagorean theorem (in km)
	    sqrt( power((curr_lat - des_lat) * 111.32, 2)  -- 1 degree latitude ≈ 111.32 km
	        + power((curr_lon - des_lon) * cos(radians(des_lat)) * 111.32, 2))* 1000 AS deviation_meters,
	    des_area,
	    vehicle_type,
	    distance_in_km,
	    delivery_time,
	    on_time_delivery
	from gold.table_combined
	where curr_lat is not null 
    and curr_lon is not null
    and des_lat is not null
    and des_lon is not null
)
select
	case
		when deviation_meters <= 50 then '(1) 10-50m (Exact)'
		when deviation_meters <= 200 then '(2) 51-200m (Close)'
		when deviation_meters <= 500 then '(3) 201-500m (Noticeable)'
		when deviation_meters <= 1000 then '(4) 501m-1km (Significant)'
    	else '(5) >1km (Major)'
	end as deviation_range,
  count(*) as shipments_count,
  round(100.0 * count(*) / (select count(*) from delivery_deviations), 2) as pct_of_total,
  round(avg(deviation_meters)::numeric, 2) as avg_deviation,
  round(avg(distance_in_km)::numeric, 2) as avg_distance_km,
  round(avg(delivery_time)::numeric, 2) as avg_delivery_hours,
  round(100.0 * sum(case when on_time_delivery is true then 1 else 0 end) / count(*), 2) as on_time_pct,
  mode() within group (order by des_area) as most_common_area,
  mode() within group (order by vehicle_type) as most_common_vehicle
from delivery_deviations
group by deviation_range
order by deviation_range;

-- Are there discrepancies between trip start/end times and GPS tracking data?
-- Are there drivers/vehicles frequently involved in late deliveries?
-- Which regions have the highest delivery demand? Are there underserved areas?
-- Do certain origin/destination clusters (based on lat/lon) have unique challenges?
-- Are there gaps in GPS ping data? How does missing data affect ETA accuracy?
-- Are there unusual patterns (e.g., long idle times, detours) that suggest operational issues?