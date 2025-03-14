
/*===== EXPLORATORY DATA ANALYSIS (EDA) =====*/ 
-- 1. How many unique users are in the dataset?
select count(user_code) as users
from gold.dim_users;

-- 2. What are the most common departure and arrival cities for flights?
(select 'Departure City' as measure_name,
	departure_city as city, 
	count(*) as depart_city_count 
from gold.fact_flights
group by departure_city)
union all 
(select 'Arrival City' as measure_name,
	arrival_city as city, 
	count(*) as arrival_city_count 
from gold.fact_flights
group by arrival_city);

-- 3. What is the average stay duration in hotels per city?
select city, 
	round(avg(stay_duration),2) as avg_stay
from gold.fact_hotels
group by city;

-- 4. What is the distribution of flight prices?
select min(price) as min_price,
	max(price) as max_price
from gold.fact_flights;

-- 5. What is the distribution of hotel prices?
select min(price) as min_price,
	max(price) as max_price
from gold.fact_hotels;

-- 6. How many flights are one-way vs. round-trip?
select count(*) as round_trip_count
from gold.fact_flights
where round_trip = 'Yes';

-- 7. What is the gender distribution of users in the dataset?
select gender, count(*) as gen_cnt
from gold.dim_users
group by gender; 

-- 8. What are the top 5 most frequently booked hotels?
select hotel_name, count(*) as book_cnt
from gold.fact_hotels
group by hotel_name
order by book_cnt desc
limit 5;

-- 9. What are the top 10 most frequently traveled routes?
select departure_city, 
	arrival_city, 
	count(*) as routes_cnt
from gold.fact_flights
group by departure_city, arrival_city
order by routes_cnt desc 
limit 10;

-- 10. How does hotel price vary by state?
select state, 
	hotel_name, 
	round(avg(price)::numeric,2) as avg_price
from gold.fact_hotels
group by state, hotel_name;

-- 11. How many users in each company
select company, 
	count(user_code) as users_cnt
from gold.dim_users
group by company;
	
/*===== MAGNITUDE ANALYSIS =====*/ 
-- What are the top 5 most expensive and cheapest hotels booked?
(select 'Top 5 expensive' as measure_name, 
	hotel_name, 
	round(avg(price)::numeric,2) as avg_price 
from gold.fact_hotels
group by hotel_name
order by avg_price desc
limit 5)

union all

(select 'Top 5 cheapest' as measure_name, 
	hotel_name, 
	round(avg(price)::numeric,2) as avg_price
from gold.fact_hotels
group by hotel_name 
order by avg_price
limit 5);

-- Which cities generate the highest revenue from hotel bookings?
select city, 
	round(sum(total)::numeric,2) as total_rev
from gold.fact_hotels
group by city
order by total_rev desc; 

-- What is the total revenue generated from flights and hotels?
(select 'hotel_revenue' as measure_name, 
	round(sum(total)::numeric,2)
from gold.fact_hotels)

union all

(select 'flight_revenue' as measure_name, 
	round(sum(price)::numeric,2)
from gold.fact_flights);

-- Which agencies have the highest share of flight bookings?
select agency, 
	count(travel_code) as book_cnt 
from gold.fact_flights
group by agency 
order by book_cnt desc;

-- What is the total number of unique users who booked hotels and flights?
(select 'user_book_hotels_cnt' as measure_name,
	count(distinct user_code)
from gold.fact_hotels)

union all

(select 'user_book_flights_cnt' as measure_name,
	count(distinct user_code)
from gold.fact_flights);

-- What are the most frequently booked round-trip flight destinations?
select arrival_city, count(*) as book_cnt
from gold.fact_flights
group by arrival_city
order by book_cnt desc; 

/*===== RANKING ANALYSIS =====*/ 
-- Which cities have the highest and lowest average hotel stay duration?
(select 'lowest_stay' as measure_name, 
	city, 
	round(avg(stay_duration)::numeric,2) as avg_stay
from gold.fact_hotels 
group by city 
order by avg_stay 
limit 1)

union all 

(select 'longest_stay' as measure_name, 
	city, 
	round(avg(stay_duration)::numeric,2) as avg_stay
from gold.fact_hotels 
group by city 
order by avg_stay desc 
limit 1);

-- What are the top 5 destinations with the highest flight demand?
select arrival_city, count(travel_code) as book_cnt
from gold.fact_flights
group by arrival_city
order by book_cnt
limit 5;

-- Which hotels have the highest total revenue?
select  hotel_name, 
	round(sum(total)::numeric,2) as total_rev 
from gold.fact_hotels 
group by hotel_name
order by total_rev desc 
limit 1;

-- Which flight agencies have the best average pricing for flights?
select agency, 
	round(avg(price),2) as avg_price
from gold.fact_flights
group by agency
order by avg_price
limit 1;

-- What are the top 5 most popular hotels based on user bookings?
select hotel_name, count(distinct user_code) as book_cnt
from gold.fact_hotels
group by hotel_name
order by book_cnt desc
limit 5;

-- Which state has the most hotel bookings?
select state, 
	count(distinct hotel_name) as hotel_cnt
from gold.fact_hotels
group by state
order by hotel_cnt desc; 

-- Which airlines or agencies have the highest customer retention rate?
with extract_info as (
	select agency, 
		extract(year from depart_date) as year,
		count(distinct user_code) as num_users
	from gold.fact_flights 
	group by agency, year
)
select agency, year, 
	round(
		100.0*num_users/(
		lag(num_users) over (partition by agency order by year)
		)
	,2) as retention_rate
from extract_info
order by year desc, retention_rate desc;

/*===== CHANGE OVER TIME ANALYSIS =====*/  
-- How has the average hotel price changed over the past year?
select extract(year from checkin_date) as year,
	round(avg(price)::numeric,2) as avg_price
from gold.fact_hotels
group by year 
order by year; 

-- How do seasonal trends affect travel patterns for Argo’s customers?
select case 
			when extract(month from depart_date) between 1 and 3 then 'Winter'
			when extract(month from depart_date) between 4 and 6 then 'Spring'
			when extract(month from depart_date) between 7 and 9 then 'Summer'
			when extract(month from depart_date) between 10 and 12 then 'Fall'
		else null
	end as seasonal_trends,
	count(travel_code) as flights_count
from gold.fact_flights
group by seasonal_trends
order by flights_count desc; 

-- How does flight demand change month over month?
select extract(month from depart_date) as month,
	count(travel_code) as flights_count
from gold.fact_flights
group by month
order by flights_count desc; 

-- Are customers booking hotels for longer stays compared to previous years?
with extract_info as (
	select extract(year from checkin_date) as year,
		round(avg(stay_duration)::numeric,2) as avg_stay
	from gold.fact_hotels
	group by year 
)
select year, avg_stay,
	case 
		when (lag(avg_stay) over (order by year)) - avg_stay < 0 then 'stay longer'
		when (lag(avg_stay) over (order by year)) - avg_stay >= 0 then 'stay less'
		else null
	end as compare_to_prev_year
from extract_info;

-- How has the average flight duration changed over time?
select extract(year from depart_date) as year,
	round(avg(flight_duration)::numeric,2)
from gold.fact_flights
group by year;

-- How does user engagement vary by month?
select extract(month from checkin_date) as month,
	count(distinct user_code) as users_engage
from gold.fact_hotels 
group by month;

/*===== CUMULATIVE ANALYSIS =====*/ 
-- What is the cumulative revenue from hotel bookings over time?
with extract_info as (
	select extract(year from checkin_date) as year,
		round(sum(total)::numeric,2) as total_revenue
	from gold.fact_hotels
	group by year
)
select year, total_revenue, 
	sum(total_revenue) over (order by year) as running_revenue
from extract_info;

-- What is the cumulative growth in unique customers booking hotels and flights?
with combine_hotels_flights_users as (
	(select extract(year from checkin_date) as year,
		user_code 
	from gold.fact_hotels)
	
	union
	
	(select extract(year from depart_date) as year,
		user_code 
	from gold.fact_flights)
),
count_users as (
	select year, 
		count(distinct user_code) as users_cnt
	from combine_hotels_flights_users
	group by year 
)
select year, users_cnt,
	sum(users_cnt) over (order by year) as cum_cnt
from count_users;

-- How does cumulative flight revenue compare to cumulative hotel revenue?
with hotels_info as (
	select extract(year from checkin_date) as year,
		round(sum(total)::numeric,2) as hotels_revenue
	from gold.fact_hotels
	group by year
),
flights_info as (
	select extract(year from depart_date) as year,
		round(sum(price)::numeric,2) as flights_revenue
	from gold.fact_flights
	group by year
)
select h.year, 
	hotels_revenue, 
	sum(hotels_revenue) over (order by h.year) as hotel_cum_revenue,
	flights_revenue,
	sum(flights_revenue) over (order by h.year) as flight_cum_revenue,
	case 
        when sum(hotels_revenue) over (order by h.year) = 0 THEN NULL 
        ELSE ROUND(sum(flights_revenue) over (order by h.year) 
					/ sum(hotels_revenue) over (order by h.year), 2) 
    end as flight_to_hotel_ratio
from hotels_info as h
join flights_info as f
on h.year = f.year;

-- - What is the cumulative effect of discounts on total revenue?
-- - How has the cumulative distance traveled by customers changed over time?

/*===== PERFORMANCE ANALYSIS =====*/ 
-- - Which hotels have the highest customer retention rate?
-- - What percentage of flights arrive on time, and which agencies perform best?
-- - How do hotels with higher prices compare in terms of customer retention?
-- - What is the average flight duration per agency, and how does it impact bookings?
-- - How do direct vs. connecting flights compare in terms of performance and price?
-- - Which hotels have the highest repeat booking rate?
-- - What is the correlation between flight price and customer satisfaction?

/*===== PART TO WHOLE ANALYSIS =====*/
-- - What percentage of total revenue comes from flights vs. hotels?
-- - What proportion of customers book both flights and hotels?
-- - What is the share of round-trip vs. one-way flights in total bookings?
-- - What proportion of customers are repeat travelers?
-- - What is the distribution of travel bookings by user age groups?
-- - How does each agency contribute to total flight revenue?

/*===== DATA SEGMENTATION =====*/ 
-- - How do travel preferences differ by age group and gender?
-- - What are the most preferred hotels for business travelers vs. leisure travelers?
-- - How do travel patterns vary for high-spending vs. low-spending customers?
-- - Are there differences in booking behavior between repeat and one-time customers?
-- - How do hotel preferences vary by region?
-- - What factors influence flight selection the most for different customer segments?

/*=====  Key Insight Goal: 
"How can Argo offer the best travel experience for its customers?" =====*/ 
-- - Identify cost-effective yet high-quality travel options.
-- - Optimize travel packages based on demand trends.
-- - Improve customer retention by analyzing repeat booking behavior.
-- - Personalize recommendations based on customer preferences.
-- - Enhance partnerships with top-performing airlines and hotels.
-- - Adjust pricing strategies to align with market demand and seasonality.
