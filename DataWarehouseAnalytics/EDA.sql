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

-- Date exploration
