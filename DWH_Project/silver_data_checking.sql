-- Check for null or duplicates in primary key
-- Expectation: No Result
select cst_id, count(*) as duplicate_count
from silver.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is null;

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

-- Data Standardization & Consistency
-- We expand abbreviations into their full forms. For example, 'F' becomes 'Female
select distinct cst_gndr
from silver.crm_cust_info;

select distinct cst_marital_status 
from silver.crm_cust_info;
