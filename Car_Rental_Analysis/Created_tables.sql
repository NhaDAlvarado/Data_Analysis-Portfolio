CREATE TABLE CarRentalData (
    fuelType VARCHAR(50),
    rating DECIMAL(3, 2),
    renterTripsTaken DECIMAL(5, 2),
    reviewCount DECIMAL(5, 2),
    location_city VARCHAR(100),
    location_country VARCHAR(50),
    location_latitude DECIMAL(10, 6),
    location_longitude DECIMAL(10, 6),
    location_state VARCHAR(50),
    owner_id BIGINT,
    rate_daily DECIMAL(10, 2),
    vehicle_make VARCHAR(100),
    vehicle_model VARCHAR(100),
    vehicle_type VARCHAR(50),
    vehicle_year INT,
    airportcity VARCHAR(100)
);

ALTER TABLE carrentaldata
ALTER COLUMN owner_id TYPE NUMERIC;

ALTER TABLE carrentaldata
ALTER COLUMN vehicle_year TYPE NUMERIC;

select * from carrentaldata

