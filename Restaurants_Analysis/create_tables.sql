create table restaurants (
	market varchar(30),
	name varchar(80),
	description text,
	displayAddress text,
	street text,
	city varchar(50),
	state varchar (20),
	zipCode varchar(20),
	timezone varchar (30),
	latitude DECIMAL(9,6),
	longitude DECIMAL(9,6),
	averageRating float,
	ratingCount int,
	priceRange text,
	imageUrl text,
	asapDeliveryAvailable boolean,
	asapDeliveryTimeMinutes int,
	pickupAvailable boolean,
	asapPickupAvailable boolean,
	asapPickupMinutes int
);

select * from restaurants
