-- 1.What is the average price of properties in the dataset?
select round(avg(price),2) as avg_price
from ny_housing_market;

-- 2.What is the median price of properties in the dataset?
select percentile_cont(0.5) within group (order by price) as median
from ny_housing_market;

-- 3.How many properties are available for each property type?
select property_type, count(*) as num_of_property
from ny_housing_market
group by property_type 
order by num_of_property desc; 

-- 4.What is the average price per square foot for all properties?
select round(avg(price/property_sqft),2) as avg_price_per_sqft
from ny_housing_market;

-- 5.What is the distribution of properties across different boroughs?
select sublocality, count(*) as num_of_property,
	round(100.0*count(*)/(select count(*) from ny_housing_market),2) as percentage
from ny_housing_market
group by sublocality
order by percentage desc; 

-- 6.What is the total number of properties listed in each locality?
select locality, count(*) as num_of_property
from ny_housing_market
group by locality;

-- 7.How many properties are listed by each broker?
select broker_title, count(*) as num_of_property
from ny_housing_market
group by broker_title; 

-- 8.What is the price range (min and max) for properties in each borough?
select sublocality, min(price) as min_price, max(price) as max_price
from ny_housing_market
group by sublocality; 

-- 9.What is the average number of bedrooms for properties by property type?
select property_type, round(avg(beds)) as avg_bedrooms
from ny_housing_market
group by property_type; 

-- 10.How many properties have at least 3 bedrooms and 2 bathrooms?
select count(*) as num_of_property
from ny_housing_market
where beds >=3 and baths >=2; 

-- 11.Which properties are listed above $1 million?
select count(*) as property_above_1_mil,
	round(100.0*count(*)/(select count(*) from ny_housing_market),2) as percentage
from ny_housing_market
where price > 1000000;

-- 12.What are the top 10 most expensive properties in the dataset?
with ranking_10 as (
	select 
		dense_rank() over (order by price desc) as ranking, 
		*
	from ny_housing_market
)
select *
from ranking_10
where ranking <=10;

-- 13.What is the average price for properties with 2 bedrooms?
select round(avg(price),2) as avg_price
from ny_housing_market
where beds = 2;

-- 14.Which borough has the highest average property price?
select sublocality, round(avg(price),2) as avg_price
from ny_housing_market
group by sublocality
order by avg_price desc
limit 1;

-- 15.Which property type has the highest average price?
select property_type, round(avg(price),2) as avg_price
from ny_housing_market
group by property_type
order by avg_price desc
limit 1;

-- 16.How does the price vary across different neighborhoods within Manhattan?
select case 
		when price <100000 then 'less than 100000'
		when price >=100000 and price <500000 then '0.1mil - 0.5mil'
		when price >=500000 and price <1000000 then '0.5mil - 1mil'
		when price >=1000000 and price <1500000 then '1mil - 1.5mil'
		when price >=1500000 and price <2000000 then '1.5mil - 2mil'
		when price >=2000000 and price <2500000 then '2mil - 2.5mil'
		when price >=2500000 and price <3000000 then '2.5mil - 3mil'
		when price >=3000000 and price <3500000 then '3mil - 3.5mil'
		when price >=3500000 and price <4000000 then '3.5mil - 4mil'
		else '4mil+'
	end as price_groups,
	count(*) as num_of_property
from ny_housing_market
where state like 'Manhattan%'
group by price_groups;

-- 17.What is the average price for properties with less than 500 square feet?
select round(avg(price),2) as avg_price
from ny_housing_market
where property_sqft < 500;

-- 18.Which borough has the lowest average price per square foot?
select sublocality, round(avg(price/property_sqft),2) as avg_price_per_sqft
from ny_housing_market
group by sublocality
order by avg_price_per_sqft
limit 1;

-- 19.What is the average price for properties sale by COMPASS?
select round(avg(price),2) as avg_price
from ny_housing_market
where broker_title = 'Brokered by COMPASS';

-- 20.What is the most common price range (e.g., in $50,000 intervals) for properties?
select case 
		when price <100000 then 'less than 100000'
		when price >=100000 and price <500000 then '0.1mil - 0.5mil'
		when price >=500000 and price <1000000 then '0.5mil - 1mil'
		when price >=1000000 and price <1500000 then '1mil - 1.5mil'
		when price >=1500000 and price <2000000 then '1.5mil - 2mil'
		when price >=2000000 and price <2500000 then '2mil - 2.5mil'
		when price >=2500000 and price <3000000 then '2.5mil - 3mil'
		when price >=3000000 and price <3500000 then '3mil - 3.5mil'
		when price >=3500000 and price <4000000 then '3.5mil - 4mil'
		else '4mil+'
	end as price_groups,
	count(*) as num_of_property
from ny_housing_market
group by price_groups
order by num_of_property desc;

-- 21.What is the geographical distribution of properties (latitude and longitude)?
select case
        when latitude > 41.0 then 'North'
        when latitude <= 40.7 then 'South'
        when longitude > -73.8 then 'East'
        else 'West'
    end as region,
    count(*) as property_count,
	round(100.0*count(*)/(select count(*) from ny_housing_market),2) as percentage
from ny_housing_market
group by region
order by percentage desc;

-- 22.How many properties are located within Manhattan?
select count(*) as property_count
from ny_housing_market
where state like 'Manhattan%';

-- 23.Which neighborhood has the highest density of listings?
select street_name as city_name, count(*) as property_count
from ny_housing_market
group by street_name
order by property_count desc;

-- 24.What are the 5 most common streets for property listings?
select street_name , count(*) as property_count
from ny_housing_market
group by street_name
order by property_count desc
limit 5;

-- 25.What is the average price of properties located on each street?
select street_name , round(avg(price),2) as avg_price
from ny_housing_market
group by street_name;

-- 26.How many properties are within a 1-mile radius of Central Park (given its latitude and longitude)?
select count(*) as property_count
from ny_housing_market
where 
    3958.8 * acos(
        cos(radians(40.785091)) * cos(radians(latitude)) *
        cos(radians(longitude) - radians(-73.968285)) +
        sin(radians(40.785091)) * sin(radians(latitude))
    ) <= 1;

-- 27.Which borough has the most properties listed within 0.5 miles of Times Square?
select sublocality as borough,
    count(*) as property_count
from ny_housing_market
where 
    3958.8 * acos(
        cos(radians(40.758896)) * cos(radians(latitude)) *
        cos(radians(longitude) - radians(-73.985130)) +
        sin(radians(40.758896)) * sin(radians(latitude))
    ) <= 0.5
group by sublocality
order by property_count desc;

-- 28.What is the most expensive property listed within 0.5 miles of Wall Street?
select price
from ny_housing_market
where 
    3958.8 * acos(
        cos(radians(40.707491)) * cos(radians(latitude)) *
        cos(radians(longitude) - radians(-74.011276 )) +
        sin(radians(40.707491)) * sin(radians(latitude))
    ) <= 0.5
order by price desc
limit 1;

-- 29.What is the average number of properties listed in each ZIP code?
select state as zipcode, count(*) as property_count
from ny_housing_market
group by zipcode;

-- 30.How does the number of properties vary by administrative area (e.g., counties)?
select administrative_area_level_2, count(*) as property_count
from ny_housing_market
group by administrative_area_level_2;

-- 31.What is the largest property by square footage?
select * 
from ny_housing_market
order by property_sqft desc
limit 1;

-- 32.What is the smallest property by square footage?
select * 
from ny_housing_market
order by property_sqft 
limit 1;

-- 33.What is the average square footage for properties in each borough?
select sublocality, round(avg(property_sqft),2) as avg_sqft
from ny_housing_market
group by sublocality;

-- 34.What is the total square footage of all properties listed in Brooklyn?
select street_name, sum(property_sqft) as total_sqft
from ny_housing_market
where street_name =  'Brooklyn'
group by street_name;

-- 35.How does the price per square foot vary by property type?
select property_type,
	round(avg(price/property_sqft),2) as avg_price_per_sqft 
from ny_housing_market 
group by property_type;

-- 36.What is the most common property size range (e.g., in 500 sq. ft. intervals)?
select case 
	when property_sqft <500 then 'less than 500 sqft'
	when property_sqft >=500 and property_sqft <1500 then '500- 1500sqft'
	when property_sqft >=1500 and property_sqft <2500 then '1500- 2500sqft'
	when property_sqft >=2500 and property_sqft <3500 then '2500- 3500sqft'
	when property_sqft >=3500 and property_sqft <4500 then '3500- 4500sqft'
	when property_sqft >=4500 and property_sqft <5500 then '4500- 5500sqft'
	when property_sqft >=5500 and property_sqft <6500 then '5500- 6500sqft'
	else 'more than 6500sqft'
	end as size_range,
	count(*) as property_count
from ny_housing_market
group by size_range 
order by property_count desc; 

-- 37.Which properties have a square footage greater than 5,000?
select count(*) as property_count
from ny_housing_market
where property_sqft > 5000;

-- 38.Which borough has the highest average square footage for properties?
select sublocality, round(avg(property_sqft),2) as avg_sqft
from ny_housing_market
group by sublocality
order by avg_sqft desc; 

-- 39.What is the relationship between square footage and price for properties in Staten Island?
-- select * from ny_housing_market
select case 
			when property_sqft <500 then 'less than 500 sqft'
			when property_sqft >=500 and property_sqft <1500 then '500- 1500sqft'
			when property_sqft >=1500 and property_sqft <2500 then '1500- 2500sqft'
			when property_sqft >=2500 and property_sqft <3500 then '2500- 3500sqft'
			when property_sqft >=3500 and property_sqft <4500 then '3500- 4500sqft'
			when property_sqft >=4500 and property_sqft <5500 then '4500- 5500sqft'
			when property_sqft >=5500 and property_sqft <6500 then '5500- 6500sqft'
			else 'more than 6500sqft'
	end as size_range,
	case 
			when price <100000 then 'less than 100000'
			when price >=100000 and price <500000 then '0.1mil - 0.5mil'
			when price >=500000 and price <1000000 then '0.5mil - 1mil'
			when price >=1000000 and price <1500000 then '1mil - 1.5mil'
			when price >=1500000 and price <2000000 then '1.5mil - 2mil'
			when price >=2000000 and price <2500000 then '2mil - 2.5mil'
			when price >=2500000 and price <3000000 then '2.5mil - 3mil'
			when price >=3000000 and price <3500000 then '3mil - 3.5mil'
			when price >=3500000 and price <4000000 then '3.5mil - 4mil'
			else '4mil+'
	end as price_groups,
	count(*) as num_of_property
from ny_housing_market
where state like 'Staten Island%'
group by size_range, price_groups 
order by size_range, price_groups;

-- 40.How many properties have a square footage between 1,000 and 2,000?
-- 41.Which broker has listed the highest number of properties?
-- 42.What is the average price of properties listed by each broker?
-- 43.How many properties are listed by brokers in Manhattan compared to Brooklyn?
-- 44.Which broker has the most properties priced above $5 million?
-- 45.Which broker has the highest average square footage for their listings?
-- 46.How many brokers have listed properties in more than one borough?
-- 47.What is the average number of properties listed per broker?
-- 48.Which brokers have listed properties with the highest number of bedrooms?
-- 49.What is the price range of properties listed by each broker?
-- 50.How does the average price of properties vary between brokers?