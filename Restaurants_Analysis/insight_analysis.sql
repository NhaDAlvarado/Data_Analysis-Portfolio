-- 1. What is the total number of restaurants listed in the table?
select count(name) as num_of_restaurants
from restaurants;

-- 2. How many unique markets are covered in the dataset?
select count(distinct market) 
from restaurants; 

-- 3. What are the top 5 cities with the highest number of restaurants?
select city, count(name) as num_restaurants
from restaurants
group by city 
order by num_restaurants desc; 

-- 4. Which state has the highest average restaurant rating?
select state, 
	round(avg(averagerating)::numeric,2) as avg_rating
from restaurants
group by state;

-- 5. What are the top 5 most popular restaurant names (based on frequency)?
select name, 
	count(name) as count_same_name
from restaurants
group by name
order by count_same_name desc 
limit 5; 

-- 6. What is the distribution of restaurants across different zip codes?
select zipcode, 
	count(name) as num_restaurants,
	round(100.0*count(name)/ (select count(name) from restaurants), 2) as percentage
from restaurants
group by zipcode; 

-- 7. Which city has the highest average restaurant rating?
select city, 
	round(avg(averagerating)::numeric,2) as avg_rating
from restaurants
group by city
order by avg_rating desc;

-- 8. What is the total number of restaurants available in each timezone?
select timezone, 
	count(name) as num_of_restaurants
from restaurants
group by timezone; 

-- 9. Which market has the largest number of restaurants offering pickup services?
select market, count(name) as num_of_restaurants
from restaurants
where pickupavailable = true 
group by market;

-- 10. What are the top 5 states with the most expensive restaurants (based on price range)?
with city_price as (
	select state,
		case when pricerange = '$' then 1
			when pricerange = '$$' then 2
			when pricerange = '$$$' then 3
			when pricerange = '$$$$' then 4
		else null
		end as price
	from restaurants
)
select state, round(avg(price),2) as avg_price
from city_price
group by state
order by avg_price desc; 

-- 11. What are the most commonly mentioned cuisines in the `description` column?
with cleaned_description as (
	select substring(description from 
					position('•' in description) + 1) AS text_description
	from restaurants
),
unnest_description as (
	select unnest(STRING_TO_ARRAY(text_description, ',')) as description_word
	from cleaned_description
)
select description_word, count(*) as mentioned_cuisines_count
from unnest_description
group by description_word
order by mentioned_cuisines_count desc;

-- 12. Which restaurant in each market has the highest rating?
with state_rating as (
	select state, 
		name, 
		averagerating,
		row_number() over (partition by state order by averagerating desc) as rn
	from restaurants
)
select state, name, averagerating
from state_rating
where rn =1; 

-- 13. What are the most frequent keywords used in the `description` column for top-rated restaurants?
with top_rated as (
	select name, description, averagerating as avg_rating
	from restaurants
	where averagerating =5
),
cleaned_description as (
	select substring(description from 
					position('•' in description) + 1) AS text_description
	from top_rated
),
unnest_description as (
	select unnest(STRING_TO_ARRAY(text_description, ',')) as key_word
	from cleaned_description
)
select key_word, count(*) as frequency
from unnest_description
group by key_word
order by frequency desc;

-- 14. Which market has the most diverse cuisine options based on `description`?
WITH cuisine_extracted AS (
    SELECT market, 
           UNNEST(STRING_TO_ARRAY(description, ',')) AS cuisine
    FROM restaurants
),
unique_cuisines AS (
    SELECT market, TRIM(cuisine) AS cuisine_type
    FROM cuisine_extracted
    GROUP BY market, TRIM(cuisine)
),
market_diversity AS (
    SELECT market, COUNT(DISTINCT cuisine_type) AS unique_cuisine_count
    FROM unique_cuisines
    GROUP BY market
)
SELECT market, unique_cuisine_count
FROM market_diversity
ORDER BY unique_cuisine_count DESC
LIMIT 1;

-- 15. What are the top-rated restaurants offering a specific cuisine (e.g., Burgers)?
with clean_description as (
    select name, 
		averagerating as avg_rating,
		substring(description from position('•' in description) + 1) as cleaned_description
    from restaurants
),
trim_space as (
	select name, avg_rating,
		trim(cleaned_description) as cuisine
	from clean_description
)
select name,avg_rating, cuisine 
from trim_space
where cuisine like '%Burgers' 
	or cuisine like 'Burgers%'
order by avg_rating desc; 

-- 16. What is the average rating of restaurants by state?
select state, avg(averagerating) as avg_rating
from restaurants
group by state; 

-- 17. How many restaurants have an average rating of 4.5 or above?
select count(*) as num_of_res
from restaurants
where averagerating > 4.5;

-- 18. What percentage of restaurants have fewer than 100 ratings?
select round(100.0*count(*)/(select count(*) from restaurants),2) as percentage 
from restaurants
where ratingcount <100;

-- 19. Which city has the highest cumulative rating count across all restaurants?
select city, sum(ratingcount) as total_rating_count
from restaurants
group by city 
order by total_rating_count desc; 

-- 20. What is the correlation between the number of ratings and the average rating?
select corr(averagerating, ratingcount) as corr
from restaurants; 

-- 21. How many restaurants fall into each `priceRange` category?
select pricerange, count(*) as num_of_restaurants
from restaurants
group by pricerange; 

-- 22. Which `priceRange` has the highest average rating?
select pricerange, avg(averagerating) as avg_rating
from restaurants
group by pricerange
order by avg_rating desc; 

-- 23. What is the distribution of price ranges across markets?
with price_range as (
	select state, pricerange, count(*) as num_res_per_price_per_state
	from restaurants
	group by state, pricerange
),
count_res_in_state as (
	select state, count(*) as num_res_per_state 
	from restaurants
	group by state
)
select p.state, pricerange,
	round(100.0*num_res_per_price_per_state/num_res_per_state,2) as percentage
from price_range as p
join count_res_in_state as c
on p.state = c.state; 

-- 24. Which city has the most affordable restaurants (lowest `priceRange`) on average?
with city_price as (
	select city,
		case when pricerange = '$' then 1
			when pricerange = '$$' then 2
			when pricerange = '$$$' then 3
			when pricerange = '$$$$' then 4
		else null
		end as price
	from restaurants
)
select city, round(avg(price),2) as avg_price
from city_price
group by city
order by avg_price; 

-- 25. How does the `priceRange` vary across different timezones?
with time_zone_price as (
	select timezone,
		case when pricerange = '$' then 1
			when pricerange = '$$' then 2
			when pricerange = '$$$' then 3
			when pricerange = '$$$$' then 4
		else null
		end as price
	from restaurants
)
select timezone, 
	round(avg(price),2) as avg_price
from time_zone_price
group by timezone
order by avg_price; 

-- 26. How many restaurants offer `asapDeliveryAvailable` services?
select asapdeliveryavailable, count(*) as num_of_res
from restaurants
group by asapdeliveryavailable;

-- 27. What is the average `asapDeliveryTimeMinutes` for restaurants in each market?
select city, round(avg(asapdeliverytimeminutes),2) as avg_mins
from restaurants
group by city;

-- 28. Which city has the fastest average delivery time?
select city, round(avg(asapdeliverytimeminutes),2) as avg_mins
from restaurants
group by city
order by avg_mins 
limit 1;

-- 29. How many restaurants offer both `asapDeliveryAvailable` and `pickupAvailable` services?
select count(*) as num_res
from restaurants
where asapdeliveryavailable = true
and pickupavailable = true; 

-- 30. What is the average `asapPickupMinutes` for each market?
select city, round(avg(asappickupminutes),2) as avg_mins
from restaurants
group by city;

-- 31. How many restaurants offer both `asapDeliveryAvailable` and `asapPickupAvailable`?
select count(*) as num_res
from restaurants
where asapdeliveryavailable = true
and asappickupavailable = true; 

-- 32. What percentage of restaurants in each market offer pickup services?
with num_of_res_per_city as (
	select city, count(*) as num_of_res
	from restaurants
	group by city
),
num_of_res_offer_pickup as (
	select city, count(*) as num_of_res_offer_pickup
	from restaurants
	where pickupavailable = true
	group by city
)
select c.city, num_of_res_offer_pickup, num_of_res,
round(100.0*num_of_res_offer_pickup/num_of_res,2) as percentage
from num_of_res_per_city as c
join num_of_res_offer_pickup as p
on c.city = p.city;

-- 33. How does the availability of `asapPickupAvailable` vary across states?
with num_of_res_per_state as (
	select state, count(*) as num_of_res
	from restaurants
	group by state
),
num_of_res_offer_pickup_asap as (
	select state, count(*) as num_of_res_offer_pickup_asap
	from restaurants
	where asappickupavailable = true
	group by state
)
select c.state, num_of_res_offer_pickup_asap, num_of_res,
round(100.0*num_of_res_offer_pickup_asap/num_of_res,2) as percentage
from num_of_res_per_state as c
join num_of_res_offer_pickup_asap as p
on c.state = p.state;

-- 34. Which city has the highest number of restaurants with `asapDeliveryAvailable = TRUE`?
select city, count(*) as num_of_res
from restaurants
where asapdeliveryavailable = true
group by city
order by num_of_res desc
limit 1; 

-- 35. What is the correlation between `asapDeliveryAvailable` and average ratings?
select asapDeliveryAvailable, 
	count(*) as num_of_res, 
	avg(averagerating) as avg_rating
from restaurants
group by asapDeliveryAvailable;

-- 36. What are the northernmost and southernmost restaurants (based on `latitude`)?
(select 'Northernmost' as location, * 
 from restaurants 
 order by latitude DESC 
 limit 1)
union all
(select 'Southernmost' as location, * 
 from restaurants 
 order by latitude asc
 limit 1);

-- 37. Which restaurant is located farthest west and farthest east (based on `longitude`)?
(select 'Farthest West' as location, * 
 from restaurants 
 order by longitude DESC 
 limit 1)
union all
(select 'Farthest East' as location, * 
 from restaurants 
 order by longitude asc
 limit 1);

-- 38. How does average rating vary by geographic location (latitude/longitude clusters)?
WITH location_clusters AS (
    SELECT 
        WIDTH_BUCKET(latitude, (SELECT MIN(latitude) FROM restaurants), 
                               (SELECT MAX(latitude) FROM restaurants), 10) AS lat_cluster,
        WIDTH_BUCKET(longitude, (SELECT MIN(longitude) FROM restaurants), 
                                (SELECT MAX(longitude) FROM restaurants), 10) AS lon_cluster,
        AVG(averageRating) AS avg_rating,
        COUNT(*) AS total_restaurants
    FROM restaurants
    GROUP BY lat_cluster, lon_cluster
)
SELECT * 
FROM location_clusters
ORDER BY avg_rating DESC;

-- 39. What is the distribution of restaurants in a specific range of latitude and longitude (e.g., near a city)?
SELECT 
    FLOOR(latitude * 10) / 10 AS lat_group,
    FLOOR(longitude * 10) / 10 AS lon_group,
    COUNT(*) AS restaurant_count
FROM restaurants
WHERE latitude BETWEEN 29.5 AND 29.9
  AND longitude BETWEEN -95.3 AND -95.7
GROUP BY lat_group, lon_group
ORDER BY restaurant_count DESC;

-- 40. How many restaurants fall within a specific radius (e.g., 10 miles) of a given coordinate?
WITH params AS (
    SELECT 
        29.7227 AS target_lat,   
        -95.3705 AS target_lon, 
        10 AS radius_miles       -- Search radius in miles
)
SELECT COUNT(*) AS total_restaurants
FROM restaurants, params
WHERE (
    3959 * acos(
        cos(radians(target_lat)) * cos(radians(latitude)) 
        * cos(radians(longitude) - radians(target_lon)) 
        + sin(radians(target_lat)) * sin(radians(latitude))
    )
) <= radius_miles;

-- 41. Which market has the highest-rated restaurants with more than 500 reviews?
select city, count(*) as res_count
from restaurants
where ratingcount > 500
group by city
order by res_count desc 
limit 1; 

-- 42. What is the average number of ratings for restaurants with `averageRating >= 4`?
select round(avg(ratingcount),2) as avg_num_of_ratings
from restaurants
where averagerating >=4;

-- 43. Which state has the highest percentage of 5-star restaurants?
-- select * from restaurants
with five_star_res as (
	select city, count(*) as five_star_res_count
	from restaurants
	where averagerating =5 
	group by city
),
num_of_res as (
	select city, count(*) as res_count
	from restaurants
	group by city
)
select s.city, five_star_res_count, res_count,
	round(100.0* five_star_res_count/res_count,2) as percentage
from five_star_res as s
join num_of_res as c
on s.city = c.city 
order by percentage desc; 

-- 44. What is the median rating for restaurants across different `priceRange` categories?
-- 45. How many restaurants in each market have `ratingCount` > 1000?
-- 46. How does the number of restaurants offering delivery services compare across timezones?
-- 47. Which markets have the fastest pickup times on average?
-- 48. What is the average rating for restaurants that are `asapDeliveryAvailable = TRUE` versus those that are not?
-- 49. How does the average rating vary for restaurants offering `pickupAvailable` services?
-- 50. What percentage of restaurants with `asapDeliveryAvailable` have a rating of 4.5 or higher?
