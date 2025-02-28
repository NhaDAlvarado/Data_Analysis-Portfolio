-- TREND OVER TIME ANALYSIS
-- Analyze sale performance overtime 
select 
	extract(month from order_date) as month,
	extract(year from order_date) as year,
sum(sales_amount),
count(distinct customer_key) as total_customers
from gold.fact_sales
where order_date is not null
group by month, year; 

-- CUMULATIVE ANALYSIS
-- total sales per month and running total sales over time
with month_total_sale as (
	SELECT 
	    date_trunc('month', order_date) AS month,
	    SUM(sales_amount) AS total_sales,
		avg(price) as avg_price 
	FROM gold.fact_sales
	where order_date is not null
	group by month
)
select month, total_sales,
	sum(total_sales) over (order by month) as running_total,
	round(avg(avg_price) over (order by month),2) as moving_avg
from month_total_sale;

-- PERFORMANCE ANALYSIS
-- compare product sales to both its average sales performance and the previous year sales
-- select * from gold.dim_products
-- select * from gold.fact_sales 
with yearly_sale as (
	select extract(year from order_date) as year,
		product_name,	
		sum(sales_amount)as current_sale
	from gold.fact_sales as f
	join gold.dim_products as d
	on f.product_key = d.product_key
	where order_date is not null
	group by year, product_name
),
compare_w_avg_and_prev_sale as (	
	select year, product_name, current_sale,
		round(avg(current_sale) over (partition by product_name)) as avg_sale,
		lag(current_sale) over (partition by product_name order by year) as prv_sale,
		current_sale - round(avg(current_sale) over (
					partition by product_name)) as diff_avg,
		current_sale - lag(current_sale) over (
					partition by product_name order by year) as diff_prev
	from yearly_sale 
)
select year, product_name, 
	current_sale, 
	avg_sale, prv_sale, diff_avg,
	case when diff_avg > 0 then 'above avg'
		else 'below avg'
	end as avg_change,
	diff_prev,
	case when diff_prev > 0 then 'increase'
		when diff_prev <= 0 then 'decrease'
		else null
	end as prev_change
from compare_w_avg_and_prev_sale;

-- PART TO WHOLE ANALYSIS
-- What categories contribute the most to overall sales?
with sale_per_cate_per_year as (
	select extract(year from s.order_date) as year,
		p.category, 
		sum(s.sales_amount) as sale_per_category
	from gold.dim_products as p
	join gold.fact_sales as s
	on p.product_key = s.product_key
	where order_date is not null
	group by year, p.category
	order by year 
),
sale_yearly as (
	select year, category, sale_per_category,
	sum(sale_per_category) over (partition by year) as sale_per_year
	from sale_per_cate_per_year
)
select year, category, sale_per_category, sale_per_year,
	round(100.0*sale_per_category/sale_per_year,2) || '%' as percentage
from sale_yearly;

-- DATA SEGMENTATION

