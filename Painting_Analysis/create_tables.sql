create table artist (
	artist_id int,
	full_name varchar(30),
	first_name varchar(20),
	middle_name varchar(20),
	last_name varchar (20),
	nationality varchar(20),
	style varchar (50),
	birth int,
	death int
);

create table canvas_size (
	size_id int,
	width int,
	height int,
	label text
);

create table museum_hours (
	museum_id int,
	day varchar(30),
	open varchar(30),
	close varchar(30)
);

create table museum (
	museum_id int,
	name text,
	address text,
	city varchar(50),
	state varchar (50),
	postal varchar(30),
	country varchar(30),
	phone text,
	url text
);

CREATE TABLE product_size (
    work_id INT NOT NULL,
    size_id VARCHAR(255) NOT NULL,
    sale_price INT NOT NULL,
    regular_price INT NOT NULL
);

CREATE TABLE subject (
    work_id INT NOT NULL,
    subject text 
);

CREATE TABLE works (
    work_id INT ,
    name TEXT ,
    artist_id INT ,
    style text,
    museum_id INT
);

select * from works