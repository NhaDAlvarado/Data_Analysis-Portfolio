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


-- 7.How many listings does each host manage?
-- 8.Which hosts have the highest number of listings?
-- 9.What is the distribution of listings' availability over the next 365 days?
-- 10.What percentage of listings are fully booked (0 availability) for the next 365 days?
-- 11.What is the average minimum number of nights required by room type?
-- 12.Which hosts have listings with the highest review counts?
-- 13.What is the correlation between price and the number of reviews?
-- 14.How does price vary with the availability of listings (based on availability_365)?
-- 15.Which neighborhoods have the highest number of listings with price = 0?
-- 16.How has the number of reviews changed over time for listings?
-- 17.What is the average price of listings by room type?
-- 18.What are the top 5 neighborhoods with the highest availability for the next year?
-- 19.Which neighborhoods have the lowest average number of reviews?
-- 20.What is the average price of listings for hosts with multiple listings?
-- 21.What are the top 10 most-reviewed listings?
-- 22.How does the price differ between neighborhoods with high and low review counts?
-- 23.Which room type generates the highest average monthly reviews?
-- 24.What percentage of listings are available for more than 300 days a year?
-- 25.What is the average review count for listings priced above $500 per night?
-- 26.What are the top 5 neighborhoods with the highest host engagement (measured by multiple listings)?
-- 27.How many listings have received reviews in the past 30 days?
-- 28.What is the most common review score for listings with high availability?
-- 29.Which listings have not received any reviews?
-- 30.What is the average price for listings with reviews in the past year?
