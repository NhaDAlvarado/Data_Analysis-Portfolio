-- 1.How many unique customers are there in the dataset?
select count (distinct cid) as num_customers
from ecommerce_data;

-- 2.What is the gender distribution of customers?
select gender, 
	round(100.0*count(*)/(select count(*) from ecommerce_data),2) as percentage
from ecommerce_data
group by gender;

-- 3.What is the age group distribution of customers?
select age_group, 
	round(100.0*count(*)/(select count(*) from ecommerce_data),2) as percentage
from ecommerce_data
group by age_group
order by percentage desc; 

-- 4.Which age group generates the highest revenue?
select age_group, 
	round(sum(net_amount)::numeric) as total_revenue
from ecommerce_data
group by age_group
order by total_revenue desc; 

-- 5.What is the average transaction amount per customer?
select round(avg(gross_amount)::numeric,2) as avg_transaction_amount
from ecommerce_data;

-- 6.How many customers have availed discounts?
select count(distinct cid) as num_of_mem
from ecommerce_data
where discount_availed = 'Yes';

-- 7.What is the average revenue per customer for each gender?
select gender, 
	round((sum(net_amount)/count (distinct cid))::numeric,2) as avg_revenue
from ecommerce_data
group by gender;

-- 8.What is the lifetime value of the top 10 customers by revenue?
select cid, round(sum(net_amount)::numeric) as revenue
from ecommerce_data
group by cid
order by revenue desc 
limit 10; 

-- 9.How many customers have made multiple purchases?
with multi_transaction as (
	select cid as cus_id, count(tid) as num_of_transac
	from ecommerce_data
	group by cid
	having count(tid) >1 
)
select count (distinct cus_id) as num_of_cus 
from multi_transaction;

-- 10.What is the percentage of returning customers vs. one-time customers?
with transaction as (
	select cid as cus_id, count(tid) as num_of_tran
	from ecommerce_data
	group by cid
),
return_cus as (
	select round(100.0*count (cus_id)/(select count (distinct cid) from ecommerce_data)::numeric,2) as return_cus_percentage 
	from transaction
	where num_of_tran >1
),
one_time_cus as (
	select round(100.0*count (cus_id)/(select count (distinct cid) from ecommerce_data)::numeric,2) as one_time_cus_percentage 
	from transaction
	where num_of_tran =1
)	
select return_cus_percentage, one_time_cus_percentage
from return_cus
cross join one_time_cus;

-- 11.How many transactions occurred in total?
select count(distinct tid) as num_of_trans
from ecommerce_data;

-- 12.What is the monthly trend of transactions over the dataset's timeline?
select to_char(purchase_date, 'MM-YYYY') as month_year,
	count(tid) as num_of_trans
from ecommerce_data
group by month_year 
order by month_year; 

-- 13.Which purchase methods (e.g., credit card, debit card) are most frequently used?
select purchase_method, count(tid) as num_of_trans
from ecommerce_data
group by purchase_method
order by num_of_trans desc; 

-- 14.What is the average, minimum, and maximum transaction amount?
select round(avg(gross_amount)::numeric,2) as avg_tranc_amount,
	round(min(gross_amount)::numeric,2) as min_trans_amount, 
	round(max(gross_amount)::numeric,2) as max_trans_amount
from ecommerce_data;

-- 15.What is the most common transaction size (in terms of gross amount)?
select case 
		when gross_amount < 1000 then 'less than 1000$'
		when gross_amount between 1000 and 2000 then '1000$ - $2000'
		when gross_amount between 2000.1 and 3000 then '2000$ - $3000'
		when gross_amount between 3000.1 and 4000 then '3000$ - $4000'
		when gross_amount between 4000.1 and 5000 then '4000$ - $5000'
		when gross_amount between 5000.1 and 6000 then '5000$ - $6000'
		when gross_amount between 6000.1 and 7000 then '6000$ - $7000'
		else 'more than $7000'
	end as gross_amount_groups,
	count(tid) as num_of_trans
from ecommerce_data
group by gross_amount_groups
order by num_of_trans desc; 

-- 16.How many transactions had discounts applied?
select sum(
	case when discount_availed = 'Yes' then 1 else 0 end
	) as num_of_dis_trans
from ecommerce_data;

-- 17.How many transactions were made per location?
select location, count(tid) as num_of_trans
from ecommerce_data
group by location
order by num_of_trans desc; 

-- 18.What is the average discount amount per transactions
select round(avg(discount_amount_inr)::numeric,2) as avg_discount_amount
from ecommerce_data;

-- 19.Which month had the highest number of transactions?
select extract(month from purchase_date) as month,
	count(tid) as num_of_trans
from ecommerce_data
group by month
order by num_of_trans desc; 

-- 20.How many transactions were made in each age group?
select age_group, count(tid) as num_of_trans
from ecommerce_data
group by age_group;

-- 21.Which product categories are most frequently purchased?
select product_category, count(tid) as num_of_trans
from ecommerce_data
group by product_category
order by num_of_trans desc; 

-- 22.Which product category generates the highest revenue?
select product_category, sum(net_amount) as revenue
from ecommerce_data
group by product_category
order by revenue desc; 

-- 23.What is the average net revenue per product category?
select product_category, round(avg(net_amount)::numeric,2) as revenue
from ecommerce_data
group by product_category
order by revenue desc; 

-- 24.Which product category has the highest average discount applied?
select product_category, round(avg(discount_amount_inr)::numeric,2) as avg_discount
from ecommerce_data
group by product_category
order by avg_discount desc; 

-- 25.Which product category has the lowest gross-to-net ratio?
select product_category, 
	round(avg(gross_amount/net_amount)::numeric,2) as gross_to_net_ratio
from ecommerce_data
group by product_category
order by gross_to_net_ratio; 

-- 26.What is the percentage contribution of each product category to total revenue?
select product_category, 
	round(100.0*(sum(net_amount)/(select sum(net_amount) from ecommerce_data))::numeric,2) as contribution_per_category
from ecommerce_data
group by product_category
order by contribution_per_category desc; 

-- 27.How many distinct product categories are there?
select count(distinct product_category) as num_of_category
from ecommerce_data;

-- 28.Which product category is most popular among specific age groups?
select age_group, product_category, count(tid) as num_of_trans,
	round(100.0*count(tid)/sum(count(tid)) over (partition by age_group),2) as percentage
from ecommerce_data
group by age_group, product_category
order by age_group, percentage desc; 

-- 29.What is the average purchase frequency for each product category?
select product_category,
	round(100.0*count(tid)::numeric /count(distinct cid),2) as avg_purchase_freq
from ecommerce_data 
group by product_category 
order by avg_purchase_freq desc; 

-- 30.Which product category is most commonly purchased using discounts?
select product_category, count(tid) as num_of_trans
from ecommerce_data
where discount_availed = 'Yes'
group by product_category
order by num_of_trans desc; 

-- 31.What is the total revenue generated by all transactions?
select sum(gross_amount) as total_revenue_b4_dis
from ecommerce_data;

-- 32.What is the net revenue (after discounts) for all transactions?
select sum(net_amount) as revenue_after_dis
from ecommerce_data ;

- 33.What is the gross revenue trend over time (monthly/yearly)?
select to_char(purchase_date, 'MM-YYYY') as month_year,
	round(sum(gross_amount)::numeric,2) as gross_revenue
from ecommerce_data
group by month_year 
order by month_year; 

-- 34.What is the net revenue trend over time (monthly/yearly)?
select to_char(purchase_date, 'MM-YYYY') as month_year,
	round(sum(net_amount)::numeric,2) as net_revenue
from ecommerce_data
group by month_year 
order by month_year; 

-- 35.What is the contribution of discounts to overall revenue reduction?
select round(100.0* 
	sum(discount_amount_inr)::numeric/sum(gross_amount)::numeric,2
	) as dis_cont_percentage
from ecommerce_data; 

-- 36.Which regions contribute most to total revenue?
select location, sum(gross_amount) as revenue_b4_discount,
	round(100.0*sum(gross_amount)::numeric/(select sum(gross_amount) from ecommerce_data)::numeric,2) as percentage
from ecommerce_data
group by location
order by percentage desc; 

-- 37.What is the average gross revenue per transaction?
-- 38.What is the average net revenue per transaction?
-- 39.What percentage of gross revenue comes from discounted transactions?
-- 40.What percentage of gross revenue comes from non-discounted transactions?
-- 41.Which locations have the highest number of transactions?
-- 42.Which locations generate the highest revenue?
-- 43.What is the average transaction value for each location?
-- 44.Which product categories are most popular in each location?
-- 45.What is the average discount applied in each location?
-- 46.How does the gross-to-net revenue ratio vary by location?
-- 47.Which location has the highest average revenue per customer?
-- 48.What is the gender distribution of customers in each location?
-- 49.What are the top 3 locations with the highest customer retention rates?
-- 50.What is the average transaction count per location?