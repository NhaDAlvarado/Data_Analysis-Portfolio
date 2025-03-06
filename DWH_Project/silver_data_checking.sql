-- Check for null or duplicates in primary key
-- Expectation: No Result
select cst_id, count(*) as duplicate_count
from silver.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is null;

select prd_id, count(*) as duplicate_count
from silver.crm_prod_info
group by prd_id
having count(*) >1 or prd_id is null;

-- Check for unwanted spaces
-- Expectation: No Result
select cst_firstname
from silver.crm_cust_info
where cst_firstname like ' %' -- check white space before firstname 
	or cst_firstname like '% '; -- check white spaces after firstname

select cst_lastname
from silver.crm_cust_info
where cst_lastname like ' %' -- check white space before lastname 
	or cst_lastname like '% '; -- check white spaces after lastname

select cst_gndr
from silver.crm_cust_info
where cst_gndr like ' %' -- check white space before gender 
	or cst_gndr like '% '; -- check white spaces after gender 

select prd_nm
from silver.crm_prod_info
where prd_nm like ' %'  
	or prd_nm like '% ';

-- Check for nulls or negative numbers
-- Expectation: No results
select prd_cost
from silver.crm_prod_info
where prd_cost is null 
	or prd_cost< 0;

-- Data Standardization & Consistency
-- We expand abbreviations into their full forms. For example, 'F' becomes 'Female
select distinct cst_gndr
from silver.crm_cust_info;

select distinct cst_marital_status 
from silver.crm_cust_info;

select distinct prd_line
from silver.crm_prod_info;

select distinct gen
from silver.erp_cust_az12;


-- Check for invalid dates 
select prd_end_dt, prd_start_dt
from silver.crm_prod_info
where prd_end_dt < prd_start_dt

-- Check if column cat_id from table silver.crm_prod_info match with id from bronze.erp_px_cat_g1v2
select cat_id, 
from silver.crm_prod_info
where cat_id not in (
	select id from bronze.erp_px_cat_g1v2);

-- Check if column cat_id from table silver.crm_prod_info match with sls_prd_key from silver.crm_sales_details
select cat_id, 
from silver.crm_prod_info
where prd_key not in (
	select sls_prd_key from silver.crm_sales_details)
order by prd_key;

-- Check if column cat_id from table silver.crm_sales_details  match with sls_prd_key from silver.crm_prod_info
select
	sls_prd_key
from silver.crm_sales_details 
where sls_prd_key not in (
	select prd_key from silver.crm_prod_info
);

-- Check if column sls_cust_id from table bronze match with id from silver.crm_cust_info
select sls_cust_id
from silver.crm_sales_details 
where sls_cust_id not in (
	select cst_id from silver.crm_cust_info
);

/*
RULES:
	- If Sales is negative, 0, or null, derive it using Quantity and Price
	- If Prices is 0, or null, calculate it using Sales and Quantity 
	- If Price is negative, convert it to a positive value 
*/
select distinct
	sls_sales, 
	sls_quantity, 
	sls_price
from silver.crm_sales_details
where sls_sales !=  sls_quantity * sls_price
	or sls_quantity is null 
	or sls_price is null 
	or sls_sales is null
	or sls_quantity <=0 
	or sls_price <=0  
	or sls_sales <=0 
order by sls_sales, sls_quantity, sls_price;

-- Check if column cid from table bronze.erp_cust_az12 match with cst_id from silver.crm_cust_info
select 
	case 
		when cid like 'NAS%' then substring(cid from 4) 
		else cid
	end as cid
from silver.erp_cust_az12
where case 
		when cid like 'NAS%' then substring(cid from 4) 
		else cid
	end not in (
	select distinct cst_key from silver.crm_cust_info
);

--  check outbound birthdate
select bdate 
from silver.erp_cust_az12
where bdate >current_timestamp; 

-- check cid from silver.erp_loc_a101 match with cst_ket from silver.crm_cust_info
select replace(cid, '-','') as cid,
	cntry
from silver.erp_loc_a101
where replace(cid, '-','') not in (
	select cst_key from silver.crm_cust_info
)

-- check cntry value
select distinct cntry 
from silver.erp_loc_a101