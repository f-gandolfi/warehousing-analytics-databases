DROP DATABASE ds_assignment2;
CREATE DATABASE ds_assignment2;
\c ds_assignment2;

CREATE TABLE employees_dim (
employee_number INTEGER PRIMARY KEY,
last_name VARCHAR NOT NULL,
first_name VARCHAR NOT NULL,
job_title VARCHAR,
reports_to INTEGER
);


CREATE TABLE offices_dim (
office_code INTEGER PRIMARY KEY,
city VARCHAR NOT NULL,
state VARCHAR,
country VARCHAR NOT NULL,
office_location VARCHAR
);

CREATE TABLE dates_dim (
date_id INTEGER PRIMARY KEY,
date DATE,
day_week INTEGER,
day_month INTEGER,
month INTEGER,
quarter INTEGER,
year INTEGER
);

CREATE TABLE customers_dim (
customer_number INTEGER PRIMARY KEY,
customer_name VARCHAR NOT NULL,
contact_last_name VARCHAR,
contact_first_name VARCHAR,
city VARCHAR,
state VARCHAR,
country VARCHAR,
customer_location VARCHAR
);

CREATE TABLE orders_info_dim (
order_number INTEGER PRIMARY KEY,
status VARCHAR,
comments VARCHAR
);

CREATE TABLE products_info_dim (
product_code VARCHAR PRIMARY KEY,
product_line VARCHAR NOT NULL,
product_name VARCHAR,
product_scale VARCHAR,
product_vendor VARCHAR,
product_description VARCHAR
);

CREATE TABLE measures (
quantity_ordered INTEGER NOT NULL,
price_each FLOAT NOT NULL,
quantity_in_stock INTEGER,
buy_price FLOAT,
revenues FLOAT,
costs FLOAT,
profits FLOAT, 
profit_margin FLOAT, 
_m_s_r_p FLOAT,
credit_limit INTEGER,
order_line_number INTEGER,
/*foreign keys*/
order_number INTEGER REFERENCES orders_info_dim(order_number),
product_code VARCHAR REFERENCES products_info_dim(product_code),
customer_number INTEGER REFERENCES customers_dim(customer_number),
office_code INTEGER REFERENCES offices_dim(office_code),
order_date INTEGER REFERENCES dates_dim(date_id),
required_date INTEGER REFERENCES dates_dim(date_id),
shipped_date INTEGER REFERENCES dates_dim(date_id),
sales_rep_employee_number INTEGER REFERENCES employees_dim(employee_number)
);
