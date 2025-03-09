-- CREATE SCHEMAS
-- create schema bronze;
-- create schema silver;
-- create schema gold;

DROP TABLE IF EXISTS bronze.flights;
CREATE TABLE bronze.flights (
    travelCode INT,
    userCode INT,
    from_location VARCHAR(50),
    to_location VARCHAR(50),
    flightType VARCHAR(50),
    price FLOAT,
    time FLOAT,  
    distance FLOAT,    
    agency VARCHAR(50),    
    date DATE
);

DROP TABLE IF EXISTS bronze.hotels;
CREATE TABLE bronze.hotels (
    travelCode int,
	userCode int,
	name varchar(50),
	place varchar(50),
	days int,
	price float,
	total float,
	date DATE
);

DROP TABLE IF EXISTS bronze.users;
CREATE TABLE bronze.users (
	code int,
	company	varchar(50),
	name varchar(50),
	gender varchar(50),
	age int	
);
