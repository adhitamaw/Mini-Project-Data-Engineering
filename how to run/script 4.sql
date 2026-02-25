-- di gunakan setelah berhasil step pipline elt

-- membuat table fakta dan table dimensi di data modelling, dilakukan setelah di elt 

-- fact
create table data_modelling.fact_orders as
select 
	o."orderNumber",
	"productCode",
	"quantityOrdered",
	"priceEach",
	"orderLineNumber",
	"orderDate",
	"requiredDate",
	"shippedDate",
	status,
	comments,
	"customerNumber"

from raw.orders as o
left join raw.orderdetails as od on o."orderNumber" = od."orderNumber";



create table data_modelling.fact_payments as
select
	*
from raw.payments p;




-- dimension
create table data_modelling.dim_customers as 
select
	*
from raw.customers o;

--
create table data_modelling.dim_products as 
select
*
from raw.products p;

--
create table data_modelling.dim_produclines as 
select
*
from raw.productlines p;

--
create table data_modelling.dim_employees as 
select
*
from raw.employees e;

--
create table data_modelling.dim_offices as 
select
*
from raw.offices o;



-- analytics query

-- 1 Menampilkan setiap transaksi order beserta nama produknya.
select 
	"productName",
	"quantityOrdered"
from data_modelling.dim_products as dp
left join data_modelling.fact_orders as fo on dp."productCode" = fo."productCode"
;


-- 2 Menampilkan total jumlah penjualan per produk.
select 
	"productName",
	sum("quantityOrdered")
from data_modelling.dim_products as dp
left join data_modelling.fact_orders as fo on dp."productCode" = fo."productCode"
group by "productName"
order by sum("quantityOrdered") desc
;
