-- 1.What is the average daily rental rate by vehicle type?
select vehicle_type, round(avg(rate_daily),2) as avg_rate_daily  
from carrentaldata
group by vehicle_type;

-- 2.Which city has the highest number of rental trips?
select sum(rentertripstaken) as num_of_renter, location_city 
from carrentaldata
group by location_city
order by num_of_renter desc; 

-- 3.What is the average rating of vehicles based on fuel type (electric, hybrid, gasoline)?
select fueltype, round(avg(rating),2) as avg_rating
from carrentaldata
group by fueltype;

-- 4.How does the number of renter trips correlate with the number of reviews?
select * from carrentaldata

-- 5.What is the distribution of rental rates across different vehicle makes and models?
-- 6.Which location has the highest concentration of electric vehicles?
-- 7.How do the average ratings compare between SUVs and cars?
-- 8.What is the average vehicle age for each vehicle type?
-- 9.Which owners have the highest number of renter trips?
-- 10.What is the relationship between vehicle year and rental price?
-- 11.Which state has the highest number of car rentals?
-- 12.What are the top 5 most rented vehicle models in each state?
-- 13.What is the average daily rate of vehicles in the top 5 highest-rated cities?
-- 14.How does the rental rate vary across different vehicle types by state?
-- 15.What is the trend in vehicle rating by rental trips taken?
-- 16.Which vehicle types are the most popular for long-term rentals (based on total trips taken)?
-- 17.How does vehicle age impact customer ratings?
-- 18.What is the geographical distribution of hybrid vehicles?
-- 19.What is the most common fuel type for vehicles with the highest ratings?
-- 20. What is the average number of reviews for each city?
-- 21.What is the average rental rate for each fuel type across different cities?
-- 22.How does the number of reviews affect the average rental rate for vehicles?
-- 23.Which city has the highest average rental rate for electric vehicles?
-- 24.What percentage of the total fleet are electric, hybrid, and gasoline vehicles?
-- 25.Which vehicle models have the highest ratings and how do their rental rates compare?
-- 26.What is the average number of trips taken per owner?
-- 27.How does the rental rate vary based on the location's latitude and longitude (proximity to major urban areas)?
-- 28.What is the distribution of vehicle models by state and how does this impact rental rates?
-- 29.How does customer rating vary by state and vehicle type?
-- 30.What is the most common vehicle make in the top 10 cities by number of rentals?
-- 31.What is the relationship between the vehicle’s daily rate and the total number of trips taken?
-- 32.How many vehicles have a daily rate higher than the average in their respective city?
-- 33.What is the median rental rate for vehicles in each airport city?
-- 34.Which vehicle make has the highest average rental rate?
-- 35.What are the top 10 most rented vehicles in terms of number of trips?
-- 36.How does the rental rate vary for vehicles with high reviews (greater than 50 reviews)?
-- 37.What is the average rental rate in cities with over 1000 total rentals?
-- 38.Which vehicle year range (e.g., 2010-2015, 2016-2020) is the most popular in terms of trips taken?
-- 39.What is the most popular vehicle type in locations with the highest customer satisfaction ratings?
-- 40.How do customer ratings compare between rural and urban locations (using latitude and longitude data)?
-- 41.What is the relationship between vehicle age and total number of trips taken?
-- 42.How does the average rental rate compare between cities with low and high numbers of electric vehicles?
-- 43.Which fuel type has the highest number of reviews on average?
-- 44.What is the correlation between vehicle make and customer satisfaction (rating)?
-- 45.Which vehicle models are most frequently rented in the top 5 most populated states?
-- 46.How many unique vehicle owners are there in each state?
-- 47.How does the average rental rate vary across vehicle makes within the same state?
-- 48.What is the most common vehicle year in each city?
-- 49.How does the average rental rate change based on the number of reviews a vehicle has received?
-- 50.What is the distribution of rental trips by owner for vehicles with more than 100 trips?