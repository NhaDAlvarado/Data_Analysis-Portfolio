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

-- Are there discrepancies between trip start/end times and GPS tracking data?
-- Are there drivers/vehicles frequently involved in late deliveries?
-- Which regions have the highest delivery demand? Are there underserved areas?
-- Do certain origin/destination clusters (based on lat/lon) have unique challenges?
-- Are there gaps in GPS ping data? How does missing data affect ETA accuracy?
-- Are there unusual patterns (e.g., long idle times, detours) that suggest operational issues?