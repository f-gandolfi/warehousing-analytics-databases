\c ds_assignment2;

--- Get the top 3 product types that have proven most profitable
select d1.product_line as Most_profitable_lines
	from products_info_dim as d1
	join measures as m
	on m.product_code = d1.product_code
	group by d1.product_line
	order by sum(m.profits) desc
	limit(3);
	
--- Get the top 3 products by most items sold
select d1.product_name as Most_sold_products
	from products_info_dim as d1
	join measures as m
	on m.product_code = d1.product_code
	group by d1.product_code
	order by sum(m.quantity_ordered) desc
	limit(3);

--- Get the top 3 products by items sold per country of customer for: USA, Spain, Belgium
(select d1.product_name as Most_sold_products_country, c.country
	from products_info_dim as d1
	join measures as m
	on m.product_code = d1.product_code
	join customers_dim as c
	on m.customer_number = c.customer_number
	where country = 'USA'
	group by product_name, country
	order by sum(quantity_ordered) desc
	limit(3))
union all 
(select d1.product_name as Most_sold_products_country, c.country
	from products_info_dim as d1
	join measures as m
	on m.product_code = d1.product_code
	join customers_dim as c
	on m.customer_number = c.customer_number
	where country = 'Spain'
	group by product_name, country
	order by sum(quantity_ordered) desc
	limit(3))
union all
(select d1.product_name as Most_sold_products_country, c.country
	from products_info_dim as d1
	join measures as m
	on m.product_code = d1.product_code
	join customers_dim as c
	on m.customer_number = c.customer_number
	where country = 'Belgium'
	group by product_name, country
	order by sum(quantity_ordered) desc
	limit(3));

--- Get the most profitable day of the week
select day_week as Most_profitable_day
	from dates_dim as d
	join measures as m
	on m.order_date = d.date_id
	where date_id <> -1
	group by day_week
	order by sum(profits) desc
	limit(1);
		
--- Get the top 3 city-quarters with the highest average profit margin in their sales
select city, quarter
	from offices_dim as o
	join measures as m
	on o.office_code = m.office_code
	join dates_dim as d
	on m.order_date = d.date_id
	group by city, quarter
	order by avg(profit_margin) desc
	limit(3);
	
-- List the employees who have sold more goods (in $ amount) than the average employee.
select employee_number as Best_employees
	from employees_dim as e
	join measures as m
	on m.sales_rep_employee_number = e.employee_number
	group by employee_number
	having sum(revenues) > (
		select sum(revenues)/count(distinct employee_number)
		from employees_dim as e
		join measures as m
		on m.sales_rep_employee_number = e.employee_number
		) ;

-- List all the orders where the sales amount in the order is in the top 10% of all order sales amounts (BONUS: Add the employee number)
select order_number, max(sales_rep_employee_number) as employee_number
	from measures as m
	group by order_number
	order by sum(revenues) desc
	limit(select (count(*)  /10) from orders_info_dim);






