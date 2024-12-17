CREATE TABLE ny_housing_market (
    broker_title TEXT,                         -- Title of the broker or agent
    property_type VARCHAR(100),               -- Type of property (e.g., Condo, House, Townhouse)
    price DECIMAL(15, 2),                     -- Price of the property
    beds INT,                                 -- Number of bedrooms
    baths DECIMAL(5, 2),                      -- Number of bathrooms
    property_sqft DECIMAL(10, 2),             -- Size of the property in square feet
    address TEXT,                             -- Address of the property
    state VARCHAR(100),                       -- State information (e.g., "New York, NY 10022")
    main_address TEXT,                        -- Full main address
    administrative_area_level_2 TEXT,         -- County or administrative area level 2
    locality TEXT,                            -- Locality or city
    sublocality TEXT,                         -- Sublocality or neighborhood
    street_name TEXT,                         -- Name of the street
    long_name TEXT,                           -- Additional details about the street
    formatted_address TEXT,                   -- Full formatted address
    latitude DECIMAL(9, 6),                   -- Latitude for geolocation
    longitude DECIMAL(9, 6)                   -- Longitude for geolocation
);

select * from ny_housing_market 
