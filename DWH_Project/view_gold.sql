create view gold.dim_customers as 
	select 
		row_number() over (order by cst_id) as customer_key -- create a surrogate key
		ci.cst_id as customer_id,
		ci.cst_key as customer_name,
		ci.cst_firstname as first_name,    
		ci.cst_lastname as last_name,
		la.cntry as country,
		ci.cst_marital_status as marital_status,
		case when ci.cst_gndr != 'n/a' then ci.cst_gndr --crm is master table
			else coalesce(ca.gen, 'n/a')
		end as gender,
		ca.bdate as birthdate,
		ci.cst_create_date as create_date
	from silver.crm_cust_info as ci
	left join silver.erp_cust_az12 as ca
	on ci.cst_key = ca.cid
	left join silver.erp_loc_a101 la
	on la.cid = ci.cst_key;

create view gold.dim_products as 
	select 
		row_number() over (
				order by pi.prd_start_dt, pi.prd_key ) as product_key -- create a surrogate key
		pi.prd_id as product_id,
		pi.prd_key as product_number,
		pi.prd_nm as product_name,
		pi.cat_id as category_id,
		pc.cat as category,
		pc.subcat as subcategory,
		pc.maintenance,
		pi.prd_cost as cost,	
		pi.prd_line as product_line,	
		pi.prd_start_dt as start_date
	from silver.crm_prod_info as pi
	left join silver.erp_px_cat_g1v2 as pc
	on pi.cat_id = pc.id 
	where prd_end_dt is null;

/*because this is a fact table, we should connect surrogates key 
	from products and customers table into this
	below are product_key and customer_key to replace 
	sls_prd_key and sls_cust_id 
*/
create view gold.fact_sales as 
	select 
		sls_ord_num as order_number,
		pr.product_key,
		cu.customer_key,
		sls_order_dt as order_date,
		sls_ship_dt as shipping_date,
		sls_due_dt as due_date,
		sls_sales as due_amount,
		sls_quantity as quantity,
		sls_price as price
	from silver.crm_sales_details as sd
	left join gold.dim_products pr
	on sd.sls_prd_key = pr.product_number
	left join gold.dim_customers cu
	on sd.sls_cust_id = cu.customer_id;