use harshadb
select *from employees;
select *from order_items;
select*from orders;
select*from products;
select*from customers;

#List all customers from Hyderabad, ordered by signup date (newest first)
select customer_name,city,signup_date
from customers
where city='Hyderabad'
order by signup_date DESC;

#Find all products priced above ₹2000.
select product_name,price
from products
where price>2000;

#Count the number of orders per order_status.
select order_status,count(order_status) as number_of_orders
from orders
group by order_status;

#Find the total revenue (order_total) generated in 2025.
select year(order_date) as year,SUM(order_total) As total_revenue
from orders
where year(order_date)='2025'
group by year(order_date);

#List the top 5 most expensive products in the "Electronics" category.
select product_name,category,price
from products
where category='Electronics'
order by price desc
LIMIT 5;

#Find all employees hired before 2024-06-01.
select employee_id,employee_name,hire_date
from employees
where hire_date<'2024-06-01';

#Get the average order value across all delivered orders.
select avg(order_total) as avg_order_value
from orders
where order_status='Delivered'

#Find customers who belong to the "Premium" segment and signed up in 2024
select*from customers
where customer_segment='Premium';

#For each city, find the total number of customers and total revenue from their orders.
select count(DISTINCT c.customer_id) AS num_customers ,c.city,sum(o.order_total) as total_revenue
from orders o
JOIN customers c ON c.customer_id=o.customer_id
group by c.city;

#Find the top 10 customers by total amount spent (only count Delivered orders).
select c.customer_name,sum(o.order_total) as total_spent
from orders o
join customers c ON c.customer_id=o.customer_id
where o.order_status='Delivered'
group by c.customer_name
order by total_spent DESC limit 10;

#For each product category, find total quantity sold and total revenue.
select p.category,SUM(i.quantity) as total_quantity_soild,sum(i.quantity*i.unit_price) as total_revenue
from order_items i
JOIN products p on p.product_id=i.product_id
group by p.category;

#List employees along with the total number of orders they've handled.
select e.employee_name,COUNT(o.order_id) as Total_orders
from orders o
JOIN employees e ON e.employee_id=o.employee_id
group by e.employee_name;

#Display all orders with the customer name.
select o.order_id, c.customer_name 
from customers c
JOIN orders o on o.customer_id=c.customer_id;

#Find the total number of orders placed by each customer.
select customer_name,count(o.order_id) as total_no_orders
from orders o
join customers c on c.customer_id=o.customer_id
group by customer_name;

#. Show each customer's total spending.
select c.customer_name,sum(o.order_total) as total_spending
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_name;

#Find the average order value for each customer.
<<<<<<< HEAD
select c.customer_name,round(avg(o.order_total),2) avg_order
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_name

#Display the top 5 customers based on total amount spent.
select c.customer_name,round(sum(order_total),2) as total_amountspend
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_name
order by total_amountspend desc
limit 5;

#Find products that have never been ordered.
select p.product_name,o.product_id from products p
left JOIN order_items o on o.product_id=p.product_id
where o.product_id is null;

#Show the total quantity sold for each product.
select p.product_name,SUM(o.quantity) as total_quantity
from order_items o
JOIN products p on p.product_id=o.product_id
group by p.product_name;

#Show employees along with the number of orders they handled.
select e.employee_id, e.employee_name,count(o.order_id) as num_of_orders
from orders o
left join employees e on e.employee_id=o.employee_id
group by e.employee_id,e.employee_name;

#Show monthly revenue.
select extract(year from order_date) as year,extract(month from order_date) as month,round(sum(order_total),2) as montly_revenue
from orders
group by extract(month from order_date),extract(year from order_date)
order by year,month;

#or
select month(order_date) as month,year(order_date) as year,round(sum(order_total),2) as monthly_revenue
from orders
group by month(order_date),year(order_date)
order by year,month;

#Find customers whose total spending is greater than the average customer spending.
select customer_name, total_spending
from (
    select c.customer_name, round(sum(o.order_total),2) as total_spending
    from orders o
    join customers c on c.customer_id = o.customer_id
    group by c.customer_name
) as customer_totals
where total_spending > (
    select avg(total_spending)
    from (
        select sum(o.order_total) as total_spending
        from orders o
        join customers c on c.customer_id = o.customer_id
        group by c.customer_id
    ) as customer_totals_2
)
order by total_spending desc;

#Find products whose price is greater than the average product price.
select product_name,category,price
from products
where price>(
	select avg(price)
    from products);

#Find employees whose total sales are above the company average.
select e.employee_name,round(sum(o.order_total),2) as total_sales
from orders o
join employees e on e.employee_id=o.employee_id 
group by e.employee_name
having sum(o.order_total)>(
	select avg(o.order_total) as avg_total
    from(
		select sum(o.order_total) as total_peremployee
        from sales
        group by e.employee_name
        ) as  emp_total
	);
    
#19. Find customers who never placed an order.
select c.customer_id,c.customer_name,o.order_id
from customers c
left join orders o on o.customer_id=c.customer_id
where o.customer_id is null;

#Find the second highest priced product.
select product_name,price
from products
where price=(
	select max(price) as high_price
    from products
    where price<(
		select max(price) as hig_price
        from products)
);

