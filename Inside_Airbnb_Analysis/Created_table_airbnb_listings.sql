CREATE TABLE airbnb_listings (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    host_id BIGINT,
    host_name VARCHAR(255),
    neighbourhood_group VARCHAR(255),
    neighbourhood VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    room_type VARCHAR(255),
    price DECIMAL(10, 2),
    minimum_nights INT,
    number_of_reviews INT,
    last_review DATE,
    reviews_per_month DECIMAL(5, 2),
    calculated_host_listings_count INT,
    availability_365 INT
);

ALTER TABLE airbnb_listings ADD COLUMN license VARCHAR(255);
ALTER TABLE airbnb_listings ADD COLUMN number_of_reviews_ltm INT;

ALTER TABLE airbnb_listings
ALTER COLUMN license TYPE TEXT;

select * from airbnb_listings


