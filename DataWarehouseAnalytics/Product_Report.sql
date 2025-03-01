/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
create view gold.products_report as 
with extract_info as (
	select product_name, 
		category, 
		subcategory, 
		cost,
		sales_amount,
		order_number,
		quantity,
		customer_key,
		order_date
	from gold.dim_products as p
	join gold.fact_sales as s
	on p.product_key = s.product_key
	where order_date is not null
),
products_aggregation as (
	select product_name, 
		category, 
		subcategory, 
		sum(cost) as total_cost,
		sum(sales_amount) as total_sale,
		(sum(sales_amount) - sum(cost)) as revenue,
		count(distinct order_number) as total_orders,
		count(quantity) as total_quantity_sold,
		count(distinct customer_key) as total_customer,
		max(order_date) as last_order_date,
		floor((max(order_date) - min(order_date))/30) as life_span
	from extract_info
	group by product_name, category, subcategory
)
select product_name, 
		category, 
		subcategory,
		total_cost,
		total_sale,
		revenue,
		case when revenue <100000 then 'Low_Performers'
			when revenue >=100000 and revenue <300000 then 'Mid-Range'
			else 'High-Performers'
		end as revenue_segment,
		total_orders, 
		total_quantity_sold,
		total_customer,
		life_span,
		floor((current_date - last_order_date) /30) as recency,
		round(revenue/nullif(total_orders,null),2) as avg_order_revenue,
		case when life_span <=1 then revenue
			else round(revenue::numeric/life_span::numeric,2) 
		end as avg_month_revenue
from products_aggregation

-- select * from gold.products_report