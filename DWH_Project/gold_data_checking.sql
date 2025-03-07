-- check if any duplicate after joining tables
select cst_id, count(*) as count_cust from (
	select ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,    
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	from silver.crm_cust_info as ci
	left join silver.erp_cust_az12 as ca
	on ci.cst_key = ca.cid
	left join silver.erp_loc_a101 la
	on la.cid = ci.cst_key
) as t
group by cst_id
having count(*) >1;

-- check intergration of gender from 2 sources 
select distinct 
	ci.cst_gndr,
	ca.gen,
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr --crm is master table
		else coalesce(ca.gen, 'n/a')
	end as new_gen
from silver.crm_cust_info as ci
left join silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on la.cid = ci.cst_key
order by ci.cst_gndr, ca.gen	





