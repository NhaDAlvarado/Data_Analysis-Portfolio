/*
===============================================================================
Hotels Report
===============================================================================
Purpose:
    - This report consolidates key hotels metrics and behaviors.

Highlights:
    1. Gathers essential fields such as hotel name, city, state, price, 
		checkin date, 
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total books
       - total sales
       - total customers (unique)
       - retention rate 
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

drop view if exists gold.report_hotels;
create view gold.report_hotels as
with extract_info as (
	select 
		hotel_name,
		city, 
		state, 
		count (distinct user_code) as users_cnt,
		count (travel_code) as booking_cnt,
		round(avg(stay_duration)::numeric,2) as avg_stay,
		round(avg(price)::numeric,2) as avg_price,
		round(sum(total)::numeric,2) as total_revenue, 
		min(checkin_date) as first_booking_date, 
		max(checkin_date) as latest_booking_date,
		ntile(3) over (order by sum(total) desc, count (travel_code) desc) as hotel_seg,
		round((max(checkin_date) - min(checkin_date))/ 365.5 ,2)as life_span
	from gold.fact_hotels 
	group by hotel_name,
		city, 
		state
)
select hotel_name,
	city, 
	state,
	case 
		when hotel_seg =1 then 'High-Performence'
		when hotel_seg =2 then 'Mid-Range'
		else 'Low-Performence'
	end as hotel_segments,
	users_cnt,
	booking_cnt,
	avg_stay,
	avg_price,
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
from extract_info;
