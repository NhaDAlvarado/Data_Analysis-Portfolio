-- call bronze.load_bronze()

-- DATA DEFINITION LANGUAGE DEFINES THE STRUCTURE OF DATABASE TABLES
-- silver schema

drop table if exists silver.crm_cust_info;
create table silver.crm_cust_info (
	cst_id int,
	cst_key varchar(50),
	cst_firstname varchar(50),	
	cst_lastname varchar(50),
	cst_marital_status	varchar(50),
	cst_gndr varchar(50),
	cst_create_date date,
	dwh_create_date timestamp default current_timestamp
);

drop table if exists silver.crm_prod_info;
create table silver.crm_prod_info (
	prd_id int,
	cat_id varchar(50),
	prd_key	varchar(50),
	prd_nm	varchar(50),
	prd_cost int,	
	prd_line varchar(50),	
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date timestamp default current_timestamp
);

drop table if exists silver.crm_sales_details;
create table silver.crm_sales_details (
	sls_ord_num	varchar(50),
	sls_prd_key	varchar(50),
	sls_cust_id	int,
	sls_order_dt date,
	sls_ship_dt	date, 
	sls_due_dt date,
	sls_sales int,	
	sls_quantity int,	
	sls_price int,
	dwh_create_date timestamp default current_timestamp
);

drop table if exists silver.erp_CUST_AZ12;
create table silver.erp_CUST_AZ12 (
	cid	varchar(50),
	bdate date,
	gen varchar(50),
	dwh_create_date timestamp default current_timestamp
);

drop table if exists silver.erp_LOC_A101;
create table silver.erp_LOC_A101 (
	cid	varchar(50),
	cntry varchar(50),
	dwh_create_date timestamp default current_timestamp
);

drop table if exists silver.erp_PX_CAT_G1V2;
create table silver.erp_PX_CAT_G1V2 (
	id varchar(50),
	cat	varchar(50),
	subcat varchar(50),
	maintenance varchar(50),
	dwh_create_date timestamp default current_timestamp
);
