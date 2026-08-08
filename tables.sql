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

