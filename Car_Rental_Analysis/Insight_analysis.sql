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
select location_state, vehicle_type, round(avg(rating),2) as avg_rating 
from carrentaldata
group by location_state, vehicle_type
order by location_state, avg_rating desc; 

-- 30.What is the most common vehicle make in the top 10 cities by number of rentals?
with top_10 as (
	select location_city, sum(rentertripstaken) as num_trips,
	row_number() over (order by sum(rentertripstaken) desc) as city_rank
	from carrentaldata
	group by location_city
)
select vehicle_make, count(vehicle_make) as num_vehicles
from carrentaldata
where location_city in 
	(select location_city from top_10 where city_rank <=10)
group by vehicle_make
order by num_vehicles desc;

-- 31.What is the relationship between the vehicle’s daily rate and the total number of trips taken?
select corr(rate_daily, rentertripstaken) as correlation 
from carrentaldata;
/* A correlation result of -0.1 suggests a very weak negative relationship 
between the vehicle's daily rate (rate_daily) and the total number of trips 
taken (renterTripsTaken). This means that, on average, higher rental rates
might slightly reduce the number of trips taken, but the effect is minimal 
and likely insignificant.
*/

-- 32.How many vehicles have a daily rate higher than the average in their respective city?
with avg_rate_daily as (
	select location_city, rate_daily,
	round(avg(rate_daily) over (partition by location_city),2) as avg_daily_rate
	from carrentaldata
)
select location_city, count(*) as num_vehicles
from avg_rate_daily
where rate_daily > avg_daily_rate
group by location_city
order by num_vehicles desc;

-- 33.What is the median rental rate for vehicles in each airport city?
select airportcity, 
	percentile_cont(0.5) within group (order by rate_daily) as median
from carrentaldata
group by airportcity;

-- 34.Which vehicle make has the highest average rental rate?
select vehicle_make, round(avg(rate_daily),2) as avg_daily_rate
from carrentaldata
group by vehicle_make
order by avg_daily_rate desc;

-- 35.What are the top 10 most rented vehicles in terms of number of trips?
select vehicle_make, sum(rentertripstaken) as num_of_trips
from carrentaldata
group by vehicle_make
order by num_of_trips desc; 

-- 36.How does the rental rate vary for vehicles with high reviews (greater than 50 reviews)?
select vehicle_make, round(avg(rate_daily), 2) as avg_rental_rate
from carrentaldata
where reviewCount > 50
group by vehicle_make
order by avg_rental_rate desc;

-- 37.What is the average rental rate in cities with over 1000 total rentals?
with cities_over_1000_rentals as (
	select location_city ,sum(rentertripstaken) as num_of_trips
	from carrentaldata
	group by location_city
	having sum(rentertripstaken) >1000
)
select location_city, round(avg(rate_daily),2) as avg_rate
from carrentaldata
where location_city in (select location_city from cities_over_1000_rentals)
group by location_city
order by avg_rate desc;

-- 38.Which vehicle year range (e.g., 2010-2015, 2016-2020) is the most popular in terms of trips taken?
select case 
		when vehicle_year between 1955 and 1965 then '1955-1964'
		when vehicle_year between 1965 and 1975 then '1965-1974'
		when vehicle_year between 1975 and 1985 then '1975-1984'
		when vehicle_year between 1985 and 1995 then '1985-1994'
		when vehicle_year between 1995 and 2005 then '1995-2004'
		when vehicle_year between 2005 and 2015 then '2005-2014'
		when vehicle_year between 2015 and 2020 then '2015-2020'
	end as year_range,
sum(rentertripstaken) as num_trips_taken
from carrentaldata
group by year_range
order by num_trips_taken desc; 

-- 39.What is the most popular vehicle type in locations with the highest customer satisfaction ratings?
with locatons_with_highest_satisfaction as (
	select location_city, round(avg(rating),2) as avg_rating
	from carrentaldata
	group by location_city
	having avg(rating) =5 
)
select vehicle_type, count(vehicle_type) as num_vehicle
from carrentaldata
where location_city in (select location_city from locatons_with_highest_satisfaction)
group by vehicle_type
order by num_vehicle desc;

-- 40.How do customer ratings compare between rural and urban locations (using latitude and longitude data)?
select case 
		when (location_latitude between 34 and 42 and location_longitude between -118 and -74) then 'Urban'
        else 'Rural'
    end as location_type,
    round(avg(rating), 2) as avg_rating
from carrentaldata
where rating is not null
group by location_type;

-- 41.What is the relationship between vehicle age and total number of trips taken?
select case 
		when (extract(year from current_date) - vehicle_year) between 1 and 6 then '1 to 5 years old'
		when (extract(year from current_date) - vehicle_year) between 6 and 11 then '6 to 10 years old'
		when (extract(year from current_date) - vehicle_year) between 11 and 16 then '11 to 15 years old'
		when (extract(year from current_date) - vehicle_year) between 16 and 21 then '16 to 20 years old'
		else '20+'
	end as car_age_groups,
	sum(rentertripstaken) as num_of_trips
from carrentaldata
group by car_age_groups
order by num_of_trips desc ;

-- 42.How does the average rental rate compare between cities with low and high numbers of electric vehicles?
with electric_type as (
	select location_city, 
		count(*) as num_vehicle
	from carrentaldata
	where fueltype = 'ELECTRIC'
	group by location_city
),
city_categories as (
	select location_city, num_vehicle,
	case when num_vehicle >= (
		select percentile_cont(0.8) within group (order by num_vehicle) 
		from electric_type
		) then 'High Electric Vehicle City'
		else 'Low Electric Vehicle City'
	end as city_category
	from electric_type 
)	
select city_category, round(avg(rate_daily),2) as avg_rental_rate
from carrentaldata as c
join city_categories as e
on c.location_city = e.location_city
group by city_category; 

-- 43.Which fuel type has the highest number of reviews on average?
select fueltype, round(sum(reviewcount)/count(fueltype),2) as avg_num_review
from carrentaldata
group by fueltype
order by avg_num_review desc;

-- 44.What is the correlation between vehicle make and customer satisfaction (rating)?
select vehicle_make, round(avg(rating),2) as avg_rating
from carrentaldata 
group by vehicle_make
order by avg_rating desc; 

-- 45.Which vehicle models are most frequently rented in the top 5 most populated states?
with top_5_populated as (
	select location_state, sum(rentertripstaken) as total_trips,
		row_number() over (order by sum(rentertripstaken) desc) as ranking
	from carrentaldata
	group by location_state
)
select vehicle_model, sum(rentertripstaken) as total_trips
from carrentaldata
where location_state in (select location_state from top_5_populated where ranking <=5)
group by vehicle_model
order by total_trips desc; 

-- 46.How many unique vehicle owners are there in each state?
select location_state, count(distinct owner_id) as num_of_owner
from carrentaldata
group by location_state;

-- 47.How does the average rental rate vary across vehicle makes within the same state?
select location_state, vehicle_make, round(avg(rate_daily),2) as avg_rate
from carrentaldata
group by location_state, vehicle_make
order by location_state, avg_rate desc; 

-- 48.What is the most common vehicle year in each city?
with count_num_vehicle_per_year_in_city as (
	select location_city,vehicle_year, 
	count(*) as num_vehicle
	from carrentaldata
	group by location_city,vehicle_year
),
ranking_per_city as (
	select location_city, vehicle_year, num_vehicle,
	dense_rank() over (partition by location_city order by num_vehicle desc) as ranking
	from count_num_vehicle_per_year_in_city
)
select location_city, vehicle_year, num_vehicle
from ranking_per_city
where ranking =1; 

-- 49.How does the average rental rate change based on the number of reviews a vehicle has received?
-- select * from carrentaldata

-- 50.What is the distribution of rental trips by owner for vehicles with more than 100 trips?