
use EO_AndventureWorksDw2022
if exists
(
select * from sys.foreign_keys
where name='fk_fact_sales_dim_territory'and
parent_object_id=object_id('fact_sales')
)
alter table sales_fact
drop constraint fk_fact_sales_dim_territory


if exists (select * from sys.objects
where name ='dim_territory' and type ='U'
)
drop table dim_territory 

create table dim_territory(
territory_key int not null IDENTITY (1,1),
territory_id int not null,
territory_name nvarchar(50),
territory_country nvarchar(400),
source_system_code Tinyint not null,
start_date datetime NOT null default GETDATE() ,
end_date datetime null,
is_current Tinyint not null default 1
CONSTRAINT  pk_dim_territory PRIMARY KEY clustered (territory_key)
)

set identity_Insert dim_territory on
insert into dim_territory(territory_key,territory_id,territory_name,territory_country,source_system_code,start_date,end_date,is_current) 
values(0,0,'UnKnown','UnKnown',0,'1900-01-01',null,1)
set identity_insert dim_territory off


-- create foreign key
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'fact_sales')
  ALTER TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_territory FOREIGN KEY (territory_key)
    REFERENCES dim_territory(territory_key);

-- index

if exists(select * from sys.indexes
where name='dim_territory_territory_code'
)
drop index dim_territory.dim_territory_territory_code

create index dim_territory_territory_code
on dim_territory (territory_id)


