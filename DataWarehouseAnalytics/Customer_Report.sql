/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
create view gold.report_customers as 
with extract_info as (
	-- Base query: retrieves core columns from tables
	select customer_id, 
		first_name || ' ' || last_name as customer_name,
		extract (year from age(current_date, birthdate)) as age,
		sales_amount,
		s.order_date,
		order_number, s.product_key, quantity
	from gold.dim_customers as c
	join gold.fact_sales as s 
	on c.customer_key = s.customer_key
	join gold.dim_products as p
	on s.product_key = p.product_key
	where order_date is not null
),
customer_aggregation as (
	-- Summarizes key metrics at the customer level
	select customer_id, customer_name, age,
		count(distinct order_number) as total_orders,
		sum(sales_amount) as total_spending,
		sum(quantity) as total_quatity_purchase,
		count(distinct product_key) as total_products,
		max(order_date) as last_order_date,
		floor((max(order_date) - min(order_date))/30) as life_span	
	from extract_info 
	group by customer_id, customer_name, age
)
select customer_id, customer_name, age, 
	case when age < 20 then 'under 20'
		when age >=20 and age <30 then '20 - 29'
		when age >=30 and age <40 then '30 - 39'
		when age >=40 and age <50 then '40 - 49'
		when age >=50 and age <60 then '50 - 59'
		else 'above 60'
	end as age_groups,
	last_order_date,
	total_orders,
	total_quatity_purchase,
	total_products,
	total_spending,
	life_span,
	case 
		when life_span >= 12 and total_spending > 5000 then 'VIP'
		when life_span >= 12 and total_spending <= 5000 then 'Regular'
		else 'New'
	end as customer_groups,
	floor((current_date - last_order_date)::numeric/30) as recency,
	round(total_spending::numeric/total_orders::numeric,2) as avg_order_value, 
	case when life_span <=1 then total_spending
		else round(total_spending::numeric/life_span::numeric,2)
	end as avg_monthly_spend
from customer_aggregation

-- select * from gold.report_customers