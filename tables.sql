CREATE DATABASE ecommerce_db;
use ecommerce_db;
show databases;
show tables;
select *from customers;
select *from order_items;
select *from orders;
select *from products;
select *from returns;

#Q1 2026(1 january to 1 june),return the top 5 product categories by revenue.include the number of distinct orders behind each category
select p.category, sum(oi.quantity*oi.unit_price-oi.discount_amount) as revenue,COUNT(DISTINCT o.order_id) AS distinct_orders
from order_items oi
join products p on p.product_id=oi.product_id
join orders o on o.order_id=oi.order_id
where o.order_ts>='2024-01-05' and o.order_ts<='2024-06-01'
group by p.category
order by revenue desc limit 5;

#Find the number of products in each category
select category,count(product_id) as total_products
from products 
group by category;

#Rank customers based on their total spending.
select c.customer_id, total_spendings
from(
	select c.customer_id,sum(oi.quantity*oi.unit_price-oi.discount_amount) as total_spendings,
    rank() over(order by total_spendings desc) as rnk
    from customers c
    join orders o on(o.customer_id=c.customer_id)
    join order_items oi on(o.order_id=oi.order_id)
    group by c.customer_id
    ) as ranked_spendings;
#or
select 
    ranked_spendings.customer_id, 
    ranked_spendings.total_spendings,
    ranked_spendings.rnk
from (
    select 
        c.customer_id,
        sum(oi.quantity * oi.unit_price - oi.discount_amount) as total_spendings,
        rank() over (order by sum(oi.quantity * oi.unit_price - oi.discount_amount) desc) as rnk
    from customers c
    join orders o on o.customer_id = c.customer_id
    join order_items oi on o.order_id = oi.order_id
    group by c.customer_id
) as ranked_spendings
order by ranked_spendings.rnk;

#or using CTE
with customer_spendings AS(
	select c.customer_id,sum(oi.quantity*oi.unit_price-discount_amount) as total_spendings
    from customers c
    join orders o on o.customer_id=c.customer_id
    join order_items oi on o.order_id=oi.order_id
    group by c.customer_id
)
select *from customer_spendings;
select customer_id,total_spendings,
	rank() over(order by customer_spendings desc) as rnk
    from customer_spendings 
    order by rnk;
# Show customer name, total orders, total spending, and their difference from the average customer spending.

#Find customers whose total spending is above the average spending of all customers.
select customer_id,total_spendings
from(
	select c.customer_id,sum(oi.quantity*oi.unit_price-oi.discount_amount) as total_spendings,
    avg(sum(oi.quantity*oi.unit_price-oi.discount_amount)) over() as avg_spendings
    from customers c
    join orders o on o.customer_id=c.customer_id
    join order_items oi on oi.order_id=o.order_id
	group by c.customer_id
) sub
where total_spendings>avg_spendings;



