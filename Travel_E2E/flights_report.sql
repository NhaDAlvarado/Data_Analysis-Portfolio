/*
===============================================================================
Flights Report
===============================================================================
Purpose:
    - This report consolidates key flights metrics and behaviors.

Highlights:
    1. Gathers essential fields such as agency, flighttype, route,
		price, depart_date, return_date.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
		(divide tables into 3 base on booking counts and total revenue)
    3. Aggregates product-level metrics:
       - total books
	   - total routes
       - total sales
       - total customers (unique)
       - lifespan (in years)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average yearly revenue
===============================================================================
*/

drop view if exists gold.report_flights;
create view gold.report_flights as
with extract_info as (
	select 
		distinct (greatest(departure_city, arrival_city) 
			|| ' <-> ' 
			|| least(departure_city, arrival_city)) as route,
		agency, 
		flighttype as flight_type, 
		count (distinct user_code) as users_cnt,
		count (travel_code) as booking_cnt,
		sum(price) as total_revenue, 
		min(depart_date) as first_booking_date, 
		max(depart_date) as latest_booking_date,
		ntile(3) over (order by sum(price) desc, count (travel_code) desc) as route_seg,
		round((max(depart_date) - min(depart_date))/ 365.5 ,2)as life_span
	from gold.fact_flights 
	group by route,
			agency, 
			flighttype
)
select route,
	agency,
	flight_type,
	case 
		when route_seg =1 then 'High-Performence'
		when route_seg =2 then 'Mid-Range'
		else 'Low-Performence'
	end as route_segments,
	users_cnt,
	booking_cnt,
	total_revenue,
	first_booking_date,
	latest_booking_date,
	life_span,
	round((current_date - latest_booking_date)/365.5,2)as recency,
	case 
		when booking_cnt <= 1 then total_revenue
		else round(total_revenue/booking_cnt,2)
	end as avg_books_revenue,
	case
		when life_span <= 1 then total_revenue
		else round (total_revenue/life_span,2)
	end as avg_yearly_revenue 
from extract_info
