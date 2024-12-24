use EO_AndventureWorksDw2022
go

if exists(
	SELECT * from sys.foreign_keys
	where name='fk_fact_sales_dim_product'
	and parent_object_id=object_id('fact_sales'))
alter table fact_sales
drop constraint  fk_fact_sales_dim_product


if exists (select * from sys.objects where name='dim_product' and type ='U')
drop table dim_product
go
create table dim_product(
	product_key int not null identity(1,1),
	product_id int not null ,
	product_name nvarchar(50),
	product_description nvarchar(50),
	product_subcategory nvarchar(50),
	product_category nvarchar(50),
	color nvarchar(15),
	model_name nvarchar(50),
	reorder_point smallint,
	standard_cost money,
	-- metadata
	source_system_code tinyint not null,
	start_date datetime not null Default(getdate()),
	end_date datetime ,
	is_current tinyint not null Default(1)

	constraint pk_dim_product 
	PRIMARY KEY clustered(product_key)

)

set identity_insert dim_product on
INSERT INTO dim_product (product_key, product_id, product_name, product_description, 
                         product_subcategory, product_category, color, model_name, 
                         reorder_point, standard_cost, source_system_code, start_date, 
                         end_date, is_current)
values(0,0,'Unkown','Unkown','Unkown','Unkown','Unkown','Unkown',0,0,0,'1900-01-01',null,1)

set identity_insert dim_product off


if exists(select * from sys.tables where name='fact_sales')
alter table fact_sales
add constraint fk_sales_dim_product 
FOREIGN KEY (product_key)
REFERENCES dim_product(product_key)

-- index
if exists(
	select * from sys.indexes
	where name='dim_product_proudct_id'
	and object_id=object_id('dim_product')
)
drop index dim_product.dim_product_proudct_id
create index dim_product_proudct_id
on dim_product(product_id)



-- index 
if exists(
select * from sys.indexes
where name ='dim_proudct_product_category'
and object_id=object_id('dim_product'))
drop index dim_product.dim_proudct_product_category
create index dim_proudct_product_category
on dim_product(product_category)
 