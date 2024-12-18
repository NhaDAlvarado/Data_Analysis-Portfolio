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
select locality, count(*) as num_of_property,
	round(100.0*count(*)/(select count(*) from ny_housing_market),2) as percentage
from ny_housing_market
group by locality
order by percentage desc; 

-- 6.What is the total number of properties listed in each locality?
-- select * from ny_housing_market

-- 7.How many properties are listed by each broker?
-- 8.What is the price range (min and max) for properties in each borough?
-- 9.What is the average number of bedrooms for properties by property type?
-- 10.How many properties have at least 3 bedrooms and 2 bathrooms?
-- 11.Which properties are listed above $1 million?
-- 12.What are the top 10 most expensive properties in the dataset?
-- 13.What is the average price for properties with 2 bedrooms?
-- 14.Which borough has the highest average property price?
-- 15.Which property type has the highest average price?
-- 16.How does the price vary across different neighborhoods within Manhattan?
-- 17.What is the average price for properties with less than 500 square feet?
-- 18.Which borough has the lowest average price per square foot?
-- 19.What is the average price for properties built before the year 2000?
-- 20.What is the most common price range (e.g., in $50,000 intervals) for properties?
-- 21.What is the geographical distribution of properties (latitude and longitude)?
-- 22.How many properties are located within Manhattan?
-- 23.Which neighborhood has the highest density of listings?
-- 24.What are the 5 most common streets for property listings?
-- 25.What is the average price of properties located on each street?
-- 26.How many properties are within a 1-mile radius of Central Park (given its latitude and longitude)?
-- 27.Which borough has the most properties listed within 0.5 miles of Times Square?
-- 28.What is the most expensive property listed within 0.5 miles of Wall Street?
-- 29.What is the average number of properties listed in each ZIP code?
-- 30.How does the number of properties vary by administrative area (e.g., counties)?
-- 31.What is the largest property by square footage?
-- 32.What is the smallest property by square footage?
-- 33.What is the average square footage for properties in each borough?
-- 34.What is the total square footage of all properties listed in Brooklyn?
-- 35.How does the price per square foot vary by property type?
-- 36.What is the most common property size range (e.g., in 500 sq. ft. intervals)?
-- 37.Which properties have a square footage greater than 5,000?
-- 38.Which borough has the highest average square footage for properties?
-- 39.What is the relationship between square footage and price for properties in Staten Island?
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