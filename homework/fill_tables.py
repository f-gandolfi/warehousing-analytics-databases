import pandas as pd
import sqlalchemy as sql

db = sql.create_engine("postgresql://postgres@localhost/ds_assignment1")

#import all tables from old dataset into pandas dataframes
employees = pd.read_sql_table("employees", db)
customers = pd.read_sql_table("customers", db)
offices = pd.read_sql_table("offices", db)
orders = pd.read_sql_table("orders", db)
products = pd.read_sql_table("products", db)
products_ordered = pd.read_sql_table("products_ordered", db)

#create big measures table with all the measures + foreign keys of the dimension tables
measures = products_ordered.join(orders.set_index('order_number'), on='order_number').drop(columns = ['comments', 'status']).join(
        products.set_index('product_code')[['buy_price', 'quantity_in_stock', '_m_s_r_p']], on='product_code').join(
                employees.set_index('employee_number')['office_code'], on ='sales_rep_employee_number').join(
                        customers.set_index('customer_number')['credit_limit'], on='customer_number')

#add to the measures table columns on revenues, costs and profits
measures['revenues'] = measures['quantity_ordered']*measures['price_each']
measures['costs'] = measures['quantity_ordered']*measures['buy_price']
measures['profits'] = measures['revenues'] - measures['costs']
measures['profit_margin'] = measures['profits'] / (measures['quantity_ordered']*measures['price_each'])

#I decided to keep the 3 different dates in the measures table (but as ids, should make joins faster), referencing to a single date_id
#column in the dates dimension table that has all the details for each date
date_dim = pd.DataFrame(orders['order_date'].append(orders['required_date']).append(
        orders['shipped_date']).drop_duplicates()).rename(columns = {0:'date'})
date_dim = date_dim.sort_values(by=['date']).reset_index(drop=True)
date_dim['date_id'] = date_dim.index
date_dim['date_id']=date_dim['date_id'].replace(559,-1)
measures = measures.join(date_dim.set_index('date'), on='order_date').drop(columns = 'order_date').rename(columns = {'date_id':'order_date'})
measures = measures.join(date_dim.set_index('date'), on='shipped_date').drop(columns = 'shipped_date').rename(columns = {'date_id':'shipped_date'})
measures = measures.join(date_dim.set_index('date'), on='required_date').drop(columns = 'required_date').rename(columns = {'date_id':'required_date'})

date_dim['day_week'] = date_dim['date'].dt.dayofweek
date_dim['day_month'] = date_dim['date'].dt.day
date_dim['month'] = date_dim['date'].dt.month
date_dim['quarter'] = date_dim['date'].dt.quarter
date_dim['year'] = date_dim['date'].dt.year

#drop columns I don't need from tables
products = products.drop(columns = ['buy_price', 'quantity_in_stock', '_m_s_r_p', 'html_description'])
customers = customers.drop(columns = 'credit_limit')
employees = employees.drop(columns = 'office_code')
orders_info = orders[['order_number', 'status', 'comments']]

#write all the tables in the SQL dataset
db = sql.create_engine("postgresql://postgres@localhost/ds_assignment2")
employees.to_sql('employees_dim', db, if_exists = 'append', index = False)
offices.to_sql('offices_dim', db, if_exists = 'append', index = False)
date_dim.to_sql('dates_dim', db, if_exists = 'append', index = False)
customers.to_sql('customers_dim', db, if_exists = 'append', index = False)
orders_info.to_sql('orders_info_dim', db, if_exists = 'append', index = False)
products.to_sql('products_info_dim', db, if_exists = 'append', index = False)
measures.to_sql('measures', db, if_exists = 'append', index = False)