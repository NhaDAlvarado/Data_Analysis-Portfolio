drop view if exists gold.dim_users;
create view gold.dim_users as 
select
	code as user_code,
	company,
	name ,
	gender,
	age
from silver.users;	

drop view if exists gold.fact_hotels;
create view gold.fact_hotels as 
select 
	h.travelCode as travel_code,
	h.userCode as user_code,
	h.name as hotel_name,
	h.place as city,
	h.state,
	h.days as stay_duration,
	h.price,
	h.total,
	h.date as checkin_date,
	f.date as checkout_date
from silver.hotels as h
left join silver.flights as f
on h.travelCode = f.travelCode
	and h.date < f.date;

drop view if exists gold.fact_flights;
create view gold.fact_flights as 
with extract_info as (
	select 
		row_number() over (partition by travelCode order by date) as rn,
		travelCode as travel_code,
		userCode as user_code,
		from_location as departure_city,
		from_state as departure_state,
		to_location as arrival_city,
		to_state as arrival_state,
		flightType,
		count(*) over (partition by travelcode) as count,
		round(sum(price) over (partition by travelcode)::numeric,2) as price,
		round(sum(time) over (partition by travelcode)::numeric,2) as flight_duration,  
		round(sum(distance) over (partition by travelcode)::numeric,2) as distance,    
		agency,    
		date as depart_date,
		lead(date) over (partition by travelcode order by date) as return_date
	from silver.flights
)
select travel_code, 
	user_code, 
	departure_city,
	departure_state,
	arrival_city,	
	arrival_state,
	flightType,
	case 
		when count =2 then 'Yes'
		else 'No'
	end as round_trip,
	price,
	flight_duration,
	distance,
	agency,
	depart_date,
	return_date
from extract_info
where rn =1; 

-- select * from gold.fact_hotels;
-- select * from gold.fact_flights;
-- select * from gold.dim_users;