
if exists(select * from sys.tables
where name ='fact_sales'
)
drop table fact_sales
create table fact_sales(
product_FK INT not null,
customer_FK INT not null,
territory_Fk INT not null,
order_date_FK INT NOT NULL,
sales_order_id VARCHAR(50) not null,
line_number INT not null,
quantity INT,
unit_price MONEY,
unit_cost MONEY,
tax_amount MONEY,
freight MONEY,
extended_sales MONEY,
extened_cost MONEY,
created_at DATETIME NOT NULL DEFAULT(GETDATE())
-- primary key 
CONSTRAINT PK_fact_sales PRIMARY KEY clustered (sales_order_id,line_number)
-- foreign key
CONSTRAINT FK_sales_fact_dim_product FOREIGN KEY (product_FK)  REFERENCES dim_product(product_key),
CONSTRAINT FK_sales_fact_dim_customer FOREIGN KEY (customer_FK) REFERENCES dim_customer(customer_key),
CONSTRAINT FK_sales_fact_dim_territory FOREIGN KEY (territory_FK) REFERENCES dim_territory(territory_key),
CONSTRAINT FK_sales_fact_dim_date FOREIGN KEY (order_date_FK) REFERENCES dim_date(date_key)

)


IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_product'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_product;

CREATE INDEX fact_sales_dim_product
  ON fact_sales(product_FK);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_customer'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_customer;

CREATE INDEX fact_sales_dim_customer
  ON fact_sales(customer_FK);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_territory'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_territory;

CREATE INDEX fact_sales_dim_territory
  ON fact_sales(territory_FK);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_date'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_date;

CREATE INDEX fact_sales_dim_date
  ON fact_sales(order_date_FK); 