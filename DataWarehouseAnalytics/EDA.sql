-- Explore all objects in database
select * from information_schema.tables;

-- Explore all columns in the database
select * from information_schema.columns
where table_name = 'dim_products';

-- Explore all countries our customer come from
select distinct country 
from gold.dim_customers;

-- Explore all categories 
select distinct category, subcategory
from gold.dim_products
order by category;

-- Find the date of the first and last order
select min(order_date) as first_order_date,
	max(order_date) as last_order_date,
	(max(order_date)-min(order_date))/365 as order_length_in_year
from gold.fact_sales;

-- Find the youngest and oldest customer
select min(extract(year from age(current_date, birthdate))) as youngest,
	max(extract(year from age(current_date, birthdate))) as oldest
from gold.dim_customers;

-- Find the total sales
select sum(sales_amount) as total_sales
from gold.fact_sales;

-- Find how many items are sold
select sum(quantity) as total_item_sold
from gold.fact_sales;

-- Find the avg selling price
select round(avg(price),2) as avg_price
from gold.fact_sales;

-- Fing the total  number of orders
select count(distinct order_number) as total_orders
from gold.fact_sales;

-- Find the total number of products
select count(product_key) as num_of_products
from gold.fact_sales;

-- Find the total number of customers
select count(customer_key) as num_of_customers
from gold.dim_customers;

-- Find the total number of customers that has placed an order
select count(distinct customer_key) as cus_placed_orders
from gold.fact_sales;

-- Generate a report that show all key metrics of business
select 'Total Sales' as measure_name, sum(sales_amount) from gold.fact_sales
union all
select 'Total Quantity' as measure_name, sum(quantity) from gold.fact_sales
union all
select 'Avg Price' as measure_name, round(avg(price),2) from gold.fact_sales
union all
select 'Total Orders' as measure_name, count(distinct order_number) from gold.fact_sales
union all
select 'Total Products' as measure_name, count(product_key)  from gold.fact_sales
union all
select 'Total Customers' as measure_name, count(customer_key)  from gold.dim_customers
union all
select 'Customers placed order' as measure_name, count(distinct customer_key)  from gold.fact_sales;


