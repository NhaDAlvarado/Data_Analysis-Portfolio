-- select * from bronze.hotels
-- select * from bronze.users
-- select * from bronze.flights

-- Check for null or duplicate key
select code, name, count(*) 
from bronze.users
group by code, name
having count(*) >1 or count(*) is null;

select usercode, count(*)
from bronze.flights
group by usercode
having 

-- Check for unwanted spaces


