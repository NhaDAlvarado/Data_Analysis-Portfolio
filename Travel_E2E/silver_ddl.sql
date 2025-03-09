DROP TABLE IF EXISTS silver.flights;
CREATE TABLE silver.flights (
    travelCode INT,
    userCode INT,
    from_location VARCHAR(50),
	from_state text,
    to_location VARCHAR(50),
	to_state text,
    flightType VARCHAR(50),
    price FLOAT,
    time FLOAT,  
    distance FLOAT,    
    agency VARCHAR(50),    
    date DATE,
	dwh_create_date timestamp default current_timestamp
);

DROP TABLE IF EXISTS silver.hotels;
CREATE TABLE silver.hotels (
    travelCode int,
	userCode int,
	name varchar(50),
	place varchar(50),
	state text,
	days int,
	price float,
	total float,
	date DATE,
	dwh_create_date timestamp default current_timestamp
);

DROP TABLE IF EXISTS silver.users;
CREATE TABLE silver.users (
	code int,
	company	varchar(50),
	name varchar(50),
	gender varchar(50),
	age int,
	dwh_create_date timestamp default current_timestamp
);
