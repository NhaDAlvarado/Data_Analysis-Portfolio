-- call silver.load_silver()

-- select * from silver.users
-- select * from silver.hotels
-- select * from silver.flights

-- Check for null or duplicate key
select code, name, count(*) 
from silver.users
group by code, name
having count(*) >1 or count(*) is null;

select travelcode, count(*)
from silver.hotels
group by travelcode
having count(*) >1 or count(*) is null;

select usercode, count(*)
from silver.hotels
group by usercode
having count(*) <1;

select from_state, count(*)
from silver.flights
group by from_state
having count(*) <1;

select to_state, count(*)
from silver.flights
group by to_state
having count(*) <1;

-- check what users.code in users table but not in hotels table
select code
from silver.users
where code not in (
	select usercode from silver.hotels
);

-- Check for unwanted spaces
select name
from silver.users
where name != trim(name);

-- check for null or negative number
select age
from silver.users
where age is null or age <0;

select price, days, total
from silver.hotels
where total != round(price::numeric * days::numeric,2)
	or price is null 
	or days is null
	or total <0 ;

select price, time, distance
from silver.flights
where price is null 
	or time is null
	or distance <0 ;

-- check for outbound date
select date 
from silver.hotels
where date > current_date or date < '1900-01-01';

select date 
from silver.flights
where date > current_date or date < '1900-01-01';

select distinct from_state
from silver.flights;

select distinct to_state
from silver.flights
