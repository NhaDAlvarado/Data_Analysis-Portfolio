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
-- select * from ecommerce_data

-- 5.What is the average transaction amount per customer?
-- 6.How many customers have availed discounts?
-- 7.What is the average revenue per customer for each gender?
-- 8.What is the lifetime value of the top 10 customers by revenue?
-- 9.How many customers have made multiple purchases?
-- 10.What is the percentage of returning customers vs. one-time customers?
-- 11.How many transactions occurred in total?
-- 12.What is the monthly trend of transactions over the dataset's timeline?
-- 13.Which purchase methods (e.g., credit card, debit card) are most frequently used?
-- 14.What is the average, minimum, and maximum transaction amount?
-- 15.What is the most common transaction size (in terms of gross amount)?
-- 16.How many transactions had discounts applied?
-- 17.How many transactions were made per location?
-- 18.What is the average discount amount per transaction?
-- 19.Which month had the highest number of transactions?
-- 20.How many transactions were made in each age group?
-- 21.Which product categories are most frequently purchased?
-- 22.Which product category generates the highest revenue?
-- 23.What is the average net revenue per product category?
-- 24.Which product category has the highest average discount applied?
-- 25.Which product category has the lowest gross-to-net ratio?
-- 26.What is the percentage contribution of each product category to total revenue?
-- 27.How many distinct product categories are there?
-- 28.Which product category is most popular among specific age groups?
-- 29.What is the average purchase frequency for each product category?
-- 30.Which product category is most commonly purchased using discounts?
-- 31.What is the total revenue generated by all transactions?
-- 32.What is the net revenue (after discounts) for all transactions?
-- 33.What is the gross revenue trend over time (monthly/yearly)?
-- 34.What is the net revenue trend over time (monthly/yearly)?
-- 35.What is the contribution of discounts to overall revenue reduction?
-- 36.Which regions contribute most to total revenue?
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