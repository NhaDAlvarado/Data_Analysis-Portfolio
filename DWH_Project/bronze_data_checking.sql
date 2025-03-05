-- Check for null or duplicates in primary key
-- Expectation: No Result
select cst_id, count(*) as duplicate_count
from bronze.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is null;

select prd_id, count(*) as duplicate_count
from bronze.crm_prod_info
group by prd_id
having count(*) >1 or prd_id is null;

-- Check for unwanted spaces
-- Expectation: No Result
select cst_firstname
from bronze.crm_cust_info
where cst_firstname like ' %' -- check white space before firstname 
	or cst_firstname like '% '; -- check white spaces after firstname

select cst_lastname
from bronze.crm_cust_info
where cst_lastname like ' %' -- check white space before lastname 
	or cst_lastname like '% '; -- check white spaces after lastname

select cst_gndr
from bronze.crm_cust_info
where cst_gndr like ' %' -- check white space before gender 
	or cst_gndr like '% '; -- check white spaces after gender 

select prd_nm
from bronze.crm_prod_info
where prd_nm like ' %'  
	or prd_nm like '% ';

-- Check for nulls or negative numbers
-- Expectation: No results
select prd_cost
from bronze.crm_prod_info
where prd_cost is null 
	or prd_cost< 0;

-- Data Standardization & Consistency
-- We expand abbreviations into their full forms. For example, 'F' becomes 'Female
select distinct cst_gndr
from bronze.crm_cust_info;

select distinct cst_marital_status 
from bronze.crm_cust_info;

select distinct prd_line
from bronze.crm_prod_info;

-- Check for invalid dates 


-- Check if column cat_id from table crm_prod_info match with id from erp_px_cat_g1v2
select prd_id,
	prd_key,
	replace(left(prd_key,5),'-','_') as cat_id, 
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
from bronze.crm_prod_info
where replace(left(prd_key,5),'-','_') not in (
	select id from bronze.erp_px_cat_g1v2);

-- Check if column cat_id from table crm_prod_info match with sls_prd_key from crm_sales_details
select prd_id,
	prd_key,
	replace(left(prd_key,5),'-','_') as cat_id, 
	replace(substring(prd_key from 7 for length(prd_key)),'-','_') as prod_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
from bronze.crm_prod_info
where replace(substring(prd_key from 7 for length(prd_key)),'-','_') not in (
	select sls_prd_key from bronze.crm_sales_details);


