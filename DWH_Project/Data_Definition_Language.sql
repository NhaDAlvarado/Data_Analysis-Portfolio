-- CREATE SCHEMAS
create schema bronze;
create schema silver;
create schema gold;

-- DATA DEFINITION LANGUAGE DEFINES THE STRUCTURE OF DATABASE TABLES
create table bronze.crm_cust_info (
	cst_id int,
	cst_key varchar(50),
	cst_firstname varchar(50),	
	cst_lastname varchar(50),
	cst_marital_status	varchar(50),
	cst_gndr varchar(50),
	cst_create_date date
);

create table bronze.crm_prod_info (
	prd_id int,
	prd_key	varchar(50),
	prd_nm	varchar(50),
	prd_cost int,	
	prd_line varchar(50),	
	prd_start_dt date,
	prd_end_dt date
);

create table bronze.crm_sales_details (
	sls_ord_num	varchar(50),
	sls_prd_key	varchar(50),
	sls_cust_id	int,
	sls_order_dt int,
	sls_ship_dt	int, 
	sls_due_dt int,
	sls_sales int,	
	sls_quantity int,	
	sls_price int
);

create table bronze.erp_CUST_AZ12 (
	cid	varchar(50),
	bdate date,
	gen varchar(50)
);

create table bronze.erp_LOC_A101 (
	cid	varchar(50),
	cntry varchar(50)
);

create table bronze.erp_PX_CAT_G1V2 (
	id varchar(50),
	cat	varchar(50),
	subcat varchar(50),
	maintenance varchar(50)
);
