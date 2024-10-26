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
select corr (renterTripsTaken, reviewCount) as correlation
from carrentaldata;
/* the correlation between renterTripsTaken and reviewCount is 0.99 close to 1, 
it suggests that vehicles with more trips taken by renters tend to also have more reviews.
*/

-- 5.What is the distribution of rental rates across different vehicle makes and models?
with running_sum_by_make_and_model as (
	select vehicle_make, vehicle_model, 
	sum(rate_daily) as num_of_rating,
	sum(rate_daily) over (partition by vehicle_make, vehicle_model) as running_sum
	from carrentaldata
	group by vehicle_make, vehicle_model, rate_daily
)
select vehicle_make,vehicle_model, num_of_rating,running_sum,
round(100.0*num_of_rating/running_sum,2) as dis_percentage
from running_sum_by_make_and_model;

-- 6.Which location has the highest concentration of electric vehicles?
select count(fueltype) as num_of_electric_vehicles, location_city 
from carrentaldata
where fueltype = 'ELECTRIC'
group by location_city
order by num_of_electric_vehicles desc;

-- 7.How do the average ratings compare between SUVs and cars?
select vehicle_type, round(avg(rating),2) as avg_rating  
from carrentaldata
where vehicle_type in ('car', 'suv')
group by vehicle_type;

-- 8.What is the average vehicle age for each vehicle type?
select round(avg(extract(year from current_date) - vehicle_year),2) as avg_vehicle_age, vehicle_type
from carrentaldata
group by vehicle_type;

-- 9.Which owners have the highest number of renter trips?
select owner_id, count(*) as num_of_renter_trips
from carrentaldata
group by owner_id
order by num_of_renter_trips desc;

-- 10.What is the relationship between vehicle year and daily rental rate?
select corr(vehicle_year, rate_daily) as correlation
from carrentaldata;
/*A result close to 0 indicates little to no correlation.*/

-- 11.Which state has the highest number of car rentals?
select location_state, count(*) as num_of_car_rental
from carrentaldata
group by location_state
order by num_of_car_rental desc;

-- 12.What are the top 5 most rented vehicle models in each state?
with count_num_vehicle as (
	select location_state, vehicle_model, 
	count(vehicle_model) as num_of_vehicle
	from carrentaldata
	group by location_state, vehicle_model
),
ranking as (
	select location_state, vehicle_model, num_of_vehicle,
	dense_rank() over (partition by location_state order by num_of_vehicle desc) as ranking
	from count_num_vehicle
)
select location_state, vehicle_model, num_of_vehicle, ranking
from ranking
where ranking <= 5;

-- 13.What is the average daily rate of vehicles in the top 5 highest-rated cities?
with top_5_highest_rated as (
	select round(avg(rating),2) as avg_rating, 
	sum(rate_daily) as sum_rate_daily, location_state
	from carrentaldata
	group by location_state
	order by avg_rating desc
	limit 5
)
select round(avg(sum_rate_daily)) as avg_daily_rate
from top_5_highest_rated;

-- 14.How does the rental rate vary across different vehicle types by state?
select location_state, vehicle_type, round(avg(rate_daily),2) as average_rental_rate
from carrentaldata
group by location_state, vehicle_type
order by location_state, vehicle_type;

-- 15.What is the trend in vehicle rating by rental trips taken?
select case when renterTripsTaken between 0 and 10 then '0-10'
        when renterTripsTaken between 11 and 20 then '11-20'
        when renterTripsTaken between 21 and 30 then '21-30'
        when renterTripsTaken between 31 and 50 then '31-50'
        else '50+' 
    end as rental_trip_range,
    round(avg(rating),2) as average_rating
from carrentaldata
group by rental_trip_range
order by rental_trip_range;

-- 16.Which vehicle types are the most popular for long-term rentals (based on total trips taken)?
select vehicle_type, sum(rentertripstaken) as total_trips_taken
from carrentaldata
group by vehicle_type
order by total_trips_taken desc;

-- 17.How does vehicle age impact customer ratings?
select case 
		when (extract(year from current_date) - vehicle_year) between 1 and 6 then '1 to 5 years old'
		when (extract(year from current_date) - vehicle_year) between 6 and 11 then '6 to 10 years old'
		when (extract(year from current_date) - vehicle_year) between 11 and 16 then '11 to 15 years old'
		when (extract(year from current_date) - vehicle_year) between 16 and 21 then '16 to 20 years old'
		else '20+'
	end as car_age_groups,
	round(avg(rating),2) as avg_rating
from carrentaldata
group by car_age_groups
order by avg_rating;

-- 18.What is the geographical distribution of hybrid vehicles?
select location_state, count(fueltype) as num_hybrid_vehicles,
	round(
	(100.0* count(fueltype)
	/(select count(*) from carrentaldata where fueltype = 'HYBRID'))
	,2) as percentage
from carrentaldata
where fueltype = 'HYBRID'
group by location_state;

-- 19.What is the most common fuel type for vehicles with the highest ratings?
select fueltype, count(fueltype) as num_vehicle, round(avg(rating),2) as avg_rating
from carrentaldata
group by fueltype
order by num_vehicle desc;

-- 20. What is the average number of reviews for each city?
select location_city, round(avg(reviewcount)) as avg_reviewcount 
from carrentaldata
group by location_city;

-- 21.What is the average rental rate for each fuel type across different cities?
select location_city, fueltype, round(avg(rating),2) as avg_rating
from carrentaldata
group by location_city, fueltype
order by location_city;

-- 22.How does the number of reviews affect the average rental rate for vehicles?
select case 
        when reviewCount between 0 and 10 then '0-10'
        when reviewCount between 11 and 20 then '11-20'
        when reviewCount between 21 and 50 then '21-50'
        else '50+' 
    end as review_count_range,
    round(avg(rate_daily),2) as average_rental_rate
from carrentaldata
group by review_count_range
order by review_count_range;

-- 23.Which city has the highest average rental rate for electric vehicles?
select location_city, round(avg(rate_daily),2) as avg_rental_rate
from carrentaldata
where fueltype = 'ELECTRIC'
group by location_city
order by avg_rental_rate desc;

-- 24.What percentage of the total fleet are electric, hybrid, and gasoline vehicles?
select fueltype,
	round(100.0* count(fueltype)/(select count(*) from carrentaldata),2) as percentage
from carrentaldata
group by fueltype; 

-- 25.Which vehicle models have the highest ratings and how do their rental rates compare?
select vehicle_model, round(avg(rating),2) as avg_rating, round(avg(rate_daily),2) as avg_rental_rate
from carrentaldata
group by vehicle_model
having avg(rating) is not null
order by avg_rating desc;

-- 26.What is the average number of trips taken per owner?
select owner_id, round(avg(rentertripstaken)) as avg_trips_taken
from carrentaldata
group by owner_id
order by avg_trips_taken desc;

-- 27.How does the rental rate vary based on the location's latitude and longitude (proximity to major urban areas)?
select case 
        when location_latitude between 33 and 35 then 'Southern Region'
        when location_latitude between 36 and 40 then 'Central Region'
        when location_latitude between 41 and 43 then 'Northern Region'
        else 'Other' 
    end as latitude_region,
    case 
        when location_longitude between -124 and -120 then 'West Coast'
        when location_longitude between -119 and -90 then 'Central US'
        when location_longitude between -89 and -75 then 'East Coast'
        else 'Other' 
    end as longitude_region,
    round(avg(rate_daily), 2) as average_rental_rate
from carrentaldata
group by latitude_region, longitude_region
order by average_rental_rate desc;

-- 28.What is the distribution of vehicle models by state and how does this impact rental rates?
with count_num_vehicle as (
	select vehicle_model, location_state, round(avg(rate_daily),2) as avg_rental_rate, count(vehicle_model) as num_of_vehicle,
		count(vehicle_model) over (partition by location_state) as num_vehicle_by_state
	from carrentaldata
	group by vehicle_model, location_state
)
select vehicle_model, location_state, avg_rental_rate, num_of_vehicle,
round(100.0*num_of_vehicle/num_vehicle_by_state,2) as percentage_in_state
from count_num_vehicle
order by location_state, percentage_in_state desc;

-- 29.How does customer rating vary by state and vehicle type?
-- select * from carrentaldata

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