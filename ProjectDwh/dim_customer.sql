use EO_AndventureWorksDw2022

IF exists (
 select * from sys.foreign_keys
 where name ='FK_sales_fact_dim_customer'
 and parent_object_id=OBJECT_ID('dim_customer')
)
alter table dim_customer
drop constraint FK_sales_fact_dim_customer



If exists(
select * from sys.tables
where name ='dim_customer')
drop table dim_customer

create table dim_customer(
customer_key int not null identity(1,1),
customer_id int not null,
customer_name nvarchar(50),
address1 nvarchar(50),
address2 nvarchar(50),
city nvarchar(50),
phone nvarchar(50),
source_system_code tinyint not null,
start_date datetime not null default(getdate()),
end_date datetime  null default null,
is_current tinyint not null default 1
constraint pk_dim_customer PRIMARY KEY clustered(customer_key)
)

set identity_insert dim_customer ON 
insert into dim_customer(customer_key,customer_id, customer_name,address1,address2,city,phone,source_system_code,start_date,end_date,is_current)
Values(0,0,'Unknown','Unknown','Unknown','Unknown','Unknown',0,'1900-01-01',null,1)
set identity_insert dim_customer OFF

-- foreign key

if exists(select * from sys.tables
where name ='sales_fact'
)
alter table sales_fact
ADD constraint fk_fact_sales_dim_customer foreign key (customer_key)
REFERENCES dim_customer(customer_key)




-- index 
if exists
(
select * from sys.indexes
where name ='dim_customer_customer_id'
and object_id=OBJECT_ID('dim_customer'))
drop index dim_customer.dim_customer_customer_id

create index dim_customer_customer_id
ON dim_customer(customer_id)

if exists(
select * from sys.indexes
where name='dim_customr_customer_city'
and object_id=OBJECT_ID('dim_coustomer')
)
drop index dim_customer.dim_customr_cutomer_city
create index dim_customr_cutomer_city
on dim_customer(city)



