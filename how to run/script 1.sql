-- build fake data and create data warehouse modeling star schema and data mart

-- table transaction

-- 1. 
create database data_warehouse;


-- 2. 
CREATE SCHEMA transactional;

-- 3. 
create table transactional.customer(
	customer_id serial primary key,
	customer_name varchar(100),
	email varchar(100),
	phone_number varchar(100)
);

-- 4
create table transactional.product(
	product_id serial primary key,
	product_name varchar(100),
	category varchar(50),
	price numeric(10,2)
);


-- 5 
create table transactional.transaction(
	transaction_id serial primary key,
	customer_id varchar(100),
	product_id varchar(100),
	transaction_date DATE,
	quantity INT,
	total_amount NUMERIC(12,2)
);

-- 6 INSERT INTO TABLE
-- a
insert into transactional.customer (customer_name, email, phone_number)
select
	'Customer ' || generate_series(101,200),
	'customer' || generate_series(101,200) || '@example.com',
	'+6209876478' || generate_series(1,100)
from generate_series(101,200);

-- b
insert into transactional.product (product_name, category, price)
select
	'Product ' || generate_series(101,200),
	'Category' || (generate_series(101,200) % 5+1) ,
	random() * 50 + 50
from generate_series(101,200);

-- c
insert into transactional."transaction" (customer_id, product_id, transaction_date, quantity, total_amount)
select
	(random() * 100 + 1 + 100) :: int,
	(random() * 100 + 1 + 100) :: int,
	current_date - ((random() * 100) :: int),
	(random() * 5 + 1) :: int,
	(random() * 100) :: numeric(12,2)
from generate_series(101,200);



-- lihat isi tabel 
select * from transactional.customer c;
select * from transactional.product p;
select * from transactional."transaction" t;


-- create data warehouse modeling star schema
create schema data_modelling;
-- a
create table data_modelling.fact_sales as
select
	*
from transactional."transaction" t;

--b
create table data_modelling.dim_customer as
select
	*
from transactional.customer;

-- c
create table data_modelling.dim_product as
select
	*
from transactional.product;


-- data mart
create schema data_mart;

create table data_mart.customer_sales as
-- analytic query
select
	sum(total_amount) as total_sales,
	customer_name
from data_modelling.fact_sales fs
left join data_modelling.dim_customer c on cast(fs.customer_id as INT) = c.customer_id
group by customer_name
order by total_sales desc
;


-- to see data mart
select * from data_mart.customer_sales ;









