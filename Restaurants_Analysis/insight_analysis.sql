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
-- select * from restaurants

-- 13. What are the most frequent keywords used in the `description` column for top-rated restaurants?
-- 14. Which market has the most diverse cuisine options based on `description`?
-- 15. What are the top-rated restaurants offering a specific cuisine (e.g., Burgers)?
-- 16. What is the average rating of restaurants by state?
-- 17. How many restaurants have an average rating of 4.5 or above?
-- 18. What percentage of restaurants have fewer than 100 ratings?
-- 19. Which city has the highest cumulative rating count across all restaurants?
-- 20. What is the correlation between the number of ratings and the average rating?
-- 21. How many restaurants fall into each `priceRange` category?
-- 22. Which `priceRange` has the highest average rating?
-- 23. What is the distribution of price ranges across markets?
-- 24. Which city has the most affordable restaurants (lowest `priceRange`) on average?
-- 25. How does the `priceRange` vary across different timezones?
-- 26. How many restaurants offer `asapDeliveryAvailable` services?
-- 27. What is the average `asapDeliveryTimeMinutes` for restaurants in each market?
-- 28. Which city has the fastest average delivery time?
-- 29. How many restaurants offer both `asapDeliveryAvailable` and `pickupAvailable` services?
-- 30. What is the average `asapPickupMinutes` for each market?
-- 31. How many restaurants offer both `asapDeliveryAvailable` and `asapPickupAvailable`?
-- 32. What percentage of restaurants in each market offer pickup services?
-- 33. How does the availability of `asapPickupAvailable` vary across states?
-- 34. Which city has the highest number of restaurants with `asapDeliveryAvailable = TRUE`?
-- 35. What is the correlation between `asapDeliveryAvailable` and average ratings?
-- 36. What are the northernmost and southernmost restaurants (based on `latitude`)?
-- 37. Which restaurant is located farthest west and farthest east (based on `longitude`)?
-- 38. How does average rating vary by geographic location (latitude/longitude clusters)?
-- 39. What is the distribution of restaurants in a specific range of latitude and longitude (e.g., near a city)?
-- 40. How many restaurants fall within a specific radius (e.g., 10 miles) of a given coordinate?
-- 41. Which market has the highest-rated restaurants with more than 500 reviews?
-- 42. What is the average number of ratings for restaurants with `averageRating >= 4`?
-- 43. Which state has the highest percentage of 5-star restaurants?
-- 44. What is the median rating for restaurants across different `priceRange` categories?
-- 45. How many restaurants in each market have `ratingCount` > 1000?
-- 46. How does the number of restaurants offering delivery services compare across timezones?
-- 47. Which markets have the fastest pickup times on average?
-- 48. What is the average rating for restaurants that are `asapDeliveryAvailable = TRUE` versus those that are not?
-- 49. How does the average rating vary for restaurants offering `pickupAvailable` services?
-- 50. What percentage of restaurants with `asapDeliveryAvailable` have a rating of 4.5 or higher?
