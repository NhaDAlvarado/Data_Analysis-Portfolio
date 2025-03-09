-- select * from bronze.users
-- select * from bronze.hotels
-- select * from bronze.flights

-- Check for null or duplicate key
select code, name, count(*) 
from bronze.users
group by code, name
having count(*) >1 or count(*) is null;

select travelcode, count(*)
from bronze.hotels
group by travelcode
having count(*) >1 or count(*) is null;

select usercode, count(*)
from bronze.hotels
group by usercode
having count(*) is null;

-- check what users.code in users table but not in hotels table
select code
from bronze.users
where code not in (
	select usercode from bronze.hotels
);

-- Check for unwanted spaces
select name
from bronze.users
where name != trim(name);

-- check for null or negative number
select age
from bronze.users
where age is null or age <0;

select price, days, total
from bronze.hotels
where total != round(price::numeric * days::numeric,2)
	or price is null 
	or days is null
	or total <0 ;

select price, time, distance
from bronze.flights
where price is null 
	or time is null
	or distance <0 ;

-- check for outbound date
select date 
from bronze.hotels
where date > current_date or date < '1900-01-01';

select date 
from bronze.flights
where date > current_date or date < '1900-01-01';

