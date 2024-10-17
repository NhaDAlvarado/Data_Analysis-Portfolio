-- 1.What is the average price of listings by neighborhood?
select neighbourhood, round(avg(price),2) as avg_price
from airbnb_listings
group by neighbourhood
order by avg_price;

-- 2.How many listings are available in each neighborhood?
select neighbourhood,
	sum(case when availability_365 != 0 then 1 else 0 end) as available_listings 
from airbnb_listings
group by neighbourhood;

-- 3.Which room type is the most common in each neighborhood?
select neighbourhood, room_type, count(room_type) as count_rooms
from airbnb_listings
group by neighbourhood,room_type
order by neighbourhood, count_rooms desc; 

-- 4.What is the distribution of room types across the entire city?
select room_type, 
	round(100.0*count(room_type)/ (select count(room_type) from airbnb_listings),2) as room_type_percentage
from airbnb_listings
group by room_type;

-- 5.What are the top 10 most expensive neighborhoods based on average price?
select neighbourhood, round(avg(price),2) as avg_price
from airbnb_listings
group by neighbourhood 
order by avg_price desc
limit 10;

-- 6.What is the average number of reviews per month for listings by neighborhood?
select neighbourhood, round(avg(reviews_per_month),2) as avg_reviews
from airbnb_listings
group by neighbourhood;

-- 7.How many listings does each host manage?
select host_name, count(*) as num_of_listings 
from airbnb_listings
group by host_name
order by num_of_listings desc;

-- 8.Which hosts have the highest number of listings?
select host_name, count(*) as num_of_listings 
from airbnb_listings
group by host_name
order by num_of_listings desc
limit 1 ;

-- 9.What is the distribution of listings' availability over the next 365 days?
with month_availability as (
	select *,
		case when availability_365 = 0 then 'fully booked'
			when availability_365 between 1 and 31 then '0-1 month'
			when availability_365 between 31 and 61 then '1-2 months'
			when availability_365 between 61 and 91 then '2-3 months'
			when availability_365 between 91 and 121 then '3-4 months'
			when availability_365 between 121 and 151 then '4-5 months'
			when availability_365 between 151 and 181 then '5-6 months'
			when availability_365 between 181 and 211 then '6-7 months'
			when availability_365 between 211 and 241 then '7-8 months'
			when availability_365 between 241 and 271 then '8-9 months'
			when availability_365 between 271 and 301 then '9-10 months'
			when availability_365 between 301 and 331 then '10-11 months'
			else '11-12 months'
		end as month_available	
	from airbnb_listings
)
select month_available,
	round(100.0*count(id)/(select count(*) from airbnb_listings),2) as percentage
from month_availability
group by month_available;

-- 10.What percentage of listings are fully booked (0 availability) for the next 365 days?
with month_availability as (
	select *,
		case when availability_365 = 0 then 'fully booked'
			when availability_365 between 1 and 31 then '0-1 month'
			when availability_365 between 31 and 61 then '1-2 months'
			when availability_365 between 61 and 91 then '2-3 months'
			when availability_365 between 91 and 121 then '3-4 months'
			when availability_365 between 121 and 151 then '4-5 months'
			when availability_365 between 151 and 181 then '5-6 months'
			when availability_365 between 181 and 211 then '6-7 months'
			when availability_365 between 211 and 241 then '7-8 months'
			when availability_365 between 241 and 271 then '8-9 months'
			when availability_365 between 271 and 301 then '9-10 months'
			when availability_365 between 301 and 331 then '10-11 months'
			else '11-12 months'
		end as month_available	
	from airbnb_listings
)
select month_available,
	round(100.0*count(id)/(select count(*) from airbnb_listings),2) as percentage
from month_availability
where month_available =  'fully booked' 
group by month_available;

-- 11.What is the average minimum number of nights required by room type?
select room_type, round(avg(minimum_nights)) as avg_minimum_nights
from airbnb_listings
group by room_type;

-- 12.Which hosts have listings with the highest review counts?
select host_name, sum(number_of_reviews) as total_review
from airbnb_listings
group by host_name
order by total_review desc
limit 1;

-- 13.What is the correlation between price and the number of reviews?
select corr(price, number_of_reviews) as price_reviews_correlation
from airbnb_listings
where price > 0 and number_of_reviews > 0;

/*The correlation is near 0, it suggests there is little to no linear relationship 
between price and the number of reviews
*/

-- 14.How does price vary with the availability of listings (based on availability_365)?
with month_availability as (
	select *,
		case when availability_365 = 0 then 'fully booked'
			when availability_365 between 1 and 31 then '0-1 month'
			when availability_365 between 31 and 61 then '1-2 months'
			when availability_365 between 61 and 91 then '2-3 months'
			when availability_365 between 91 and 121 then '3-4 months'
			when availability_365 between 121 and 151 then '4-5 months'
			when availability_365 between 151 and 181 then '5-6 months'
			when availability_365 between 181 and 211 then '6-7 months'
			when availability_365 between 211 and 241 then '7-8 months'
			when availability_365 between 241 and 271 then '8-9 months'
			when availability_365 between 271 and 301 then '9-10 months'
			when availability_365 between 301 and 331 then '10-11 months'
			else '11-12 months'
		end as month_available	
	from airbnb_listings
)
select round(avg(price),2) as avg_price, month_available
from month_availability
group by month_available
order by avg_price;

-- 15.Which neighborhoods have the highest number of listings with price = 0?
select neighbourhood, count (*) as num_of_listings
from airbnb_listings
where price = 0
group by neighbourhood
order by num_of_listings desc;

-- 16.How has the number of reviews changed over time for listings?
select date_trunc('month', last_review) as review_month,
    count(*) as total_reviews
from airbnb_listings
where last_review is not null
group by review_month
order by review_month;

-- 17.What is the average price of listings by room type?
select room_type, round(avg(price)) as avg_price
from airbnb_listings
group by room_type;

-- 18.What are the top 5 neighborhoods with the highest availability for the next year?
select neighbourhood, round(avg(availability_365)) as avg_availability
from airbnb_listings
group by neighbourhood
order by avg_availability desc
limit 5;

-- 19.Which neighborhoods have the lowest average number of reviews?
select neighbourhood, round(avg(number_of_reviews),2) as avg_num_reviews
from airbnb_listings
group by neighbourhood
order by avg_num_reviews
limit 1;

-- 20.What is the average price of listings for hosts with multiple listings?
select host_name, round(avg(price),2) as avg_price
from airbnb_listings
group by host_name
having count(*) > 1
order by avg_price;

-- 21.What are the top 10 most-reviewed listings?
select name, sum(number_of_reviews) as total_reviews 
from airbnb_listings
group by name
order by total_reviews  desc
limit 10;

-- 22.How does the price differ between neighborhoods with high and low review counts?
select neighbourhood, sum(number_of_reviews) as total_reviews, 
	round(avg(price),2) as avg_price
from airbnb_listings
group by neighbourhood
order by total_reviews;

-- 23.Which room type generates the highest average monthly reviews?
select room_type, sum(reviews_per_month) as total_reviews
from airbnb_listings
group by room_type
order by total_reviews desc;

-- 24.What percentage of listings are available for more than 300 days a year?
select round(
	100.0*sum(case when availability_365 > 300 then 1 else 0 end)
	/(select count(*) from airbnb_listings)
	,2) as percentage
from airbnb_listings;

-- 25.What is the average review count for listings priced above $500 per night?
select round(avg(number_of_reviews),2) as avg_review_count
from airbnb_listings
where price > 500;

-- 26.What are the top 5 neighborhoods with the highest host engagement (measured by multiple listings)?
with num_listings_per_host_in_neighbor as (
	select neighbourhood, host_name, count(*) as num_listings
	from airbnb_listings
	group by neighbourhood, host_name
	order by neighbourhood, host_name
)
select neighbourhood, 
sum(case when num_listings >1 then 1 else 0 end) as num_of_host_have_nultiple_listings
from num_listings_per_host_in_neighbor
group by neighbourhood
order by num_of_host_have_nultiple_listings desc
limit 5;

-- 27.How many listings have received reviews in the past 30 days?
-- 28.What is the most common review score for listings with high availability?
-- 29.Which listings have not received any reviews?
-- 30.What is the average price for listings with reviews in the past year?
