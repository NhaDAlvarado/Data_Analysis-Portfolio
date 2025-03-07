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
order by ci.cst_gndr, ca.gen;

-- Filter out all historical data
with filter_out as (
	select 
		pi.prd_id,
		pi.cat_id,
		pi.prd_key,
		pi.prd_nm,
		pi.prd_cost,	
		pi.prd_line,	
		pi.prd_start_dt,
		pi.prd_end_dt,
		pc.cat,
		pc.subcat,
		pc.maintenance
	from silver.crm_prod_info as pi
	left join silver.erp_px_cat_g1v2 as pc
	on pi.cat_id = pc.id 
	where prd_end_dt is null 
)
-- check duplicate after join
select prd_key, count(*)
from filter_out
group by prd_key
having count(*) >1; 

-- foreign key integrity (dimensions)
select * 
from gold.fact_sales as f
left join gold.dim_customers as c
on c.customer_key = f.customer_key
left join gold.dim_products as p
on p.product_key = f.product_key
where p.product_key is null
	or c.customer_key is null;


