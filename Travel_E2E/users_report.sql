/*
===============================================================================
Users Report
===============================================================================
Purpose:
    - This report consolidates key users metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments users into categories (VIP, Regular, New) and age groups.
		- VIP: Customers with at least  2 years of history and spending more than $30000
		- Regular: Customers with at least 2  years of history but spending $30000 or less
		- New: Customers with a lifespan less than 2 years 
    3. Aggregates user-level metrics:
		- total hotel books
		- total flight books
		- total spending
		- lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average booking value 
		- average yearly spend 
===============================================================================
*/
drop view if exists gold.report_users;
create view gold.report_users as
with extract_info as (
	select name, 
		company, 
		gender, 
		age,
		count(h.travel_code) as bookings_cnt,
		round(sum(h.total)::numeric + sum(f.price)::numeric,2) as total_spending,
		min(h.checkin_date) as first_booking_date,
		max(h.checkin_date) as latest_booking_date,
		round((max(h.checkin_date) - min(h.checkin_date))/365.0,2) as life_span_years,
		ntile(3) over (
					order by round(
							sum(h.total)::numeric + sum(f.price)::numeric
								,2) desc, 
							round(
							(max(h.checkin_date) - min(h.checkin_date))/365.0
								,2) desc
		) as users_seg
	from gold.dim_users as u
	left join gold.fact_hotels as h
	on h.user_code = u.user_code 
	left join gold.fact_flights as f
	on f.user_code = u.user_code 
	and f.travel_code = h.travel_code 
	group by name, company, gender, age
)
select name, 
	company, 
	gender, 
	age,
	case 
		when age between 20 and 29 then '20-29'
		when age between 30 and 39 then '30-39'
		when age between 40 and 49 then '40-49'
		when age between 50 and 59 then '50-59'
		else'60-69'
	end as age_groups,
	bookings_cnt,
	total_spending,
	case 
		when users_seg = 1 and life_span_years is not null then 'VIP'
		when users_seg = 2 then 'Regular'
		else 'New'
	end as users_seg,
	first_booking_date,
	latest_booking_date,
	life_span_years,
	round((current_date - latest_booking_date)/365.0,2)as recency_in_years,
	case 
		when bookings_cnt <1 then total_spending
		else round(total_spending/bookings_cnt,2)
	end as avg_booking_value,
	case 
		when life_span_years <1 then total_spending
		else round(total_spending/life_span_years,2)
	end as avg_yearly_spend
from extract_info; 