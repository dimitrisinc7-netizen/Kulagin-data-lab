--Завдання 3.1. Підсумки 2025 року за країнами
select country_code,
       count(order_id) as orders_cnt, 
       count(distinct customer_id) as customers_cnt, 
       sum(total_amount) as total_sum,
       round(avg(total_amount), 2) as avg_check,
       min(total_amount) as min_check,
       max(total_amount) as max_check
from orders
where created_at between '2025-01-01' and '2026-01-01'
group by country_code

--Завдання 3.2. Помісячна динаміка в Україні
select date_trunc('month', created_at)::date as order_month,
       count(order_id) as orders_cnt,
       count(distinct customer_id) as customers_cnt,
       sum(total_amount) as total_sum,
       round(avg(total_amount), 2) as avg_check
from orders
where country_code = 'UA'
and status = 'received'
group by date_trunc('month', created_at)
order by order_month

--Завдання 3.3. Замовлення за годинами доби
select country_code, 
       extract(hour from created_at) as order_hour,
       count(order_id) as orders_cnt,
       round(avg(total_amount), 2) as avg_check
from orders
group by extract(hour from created_at), country_code
order by country_code

--Завдання 3.4. Постійні покупці
select customer_id,
       count(order_id) as orders_cnt,
       sum(total_amount) as total_sum,
       min(created_at::date) as first_order_date, 
       max(created_at::date) as last_order_date
from orders
where country_code = 'UA'
group by customer_id
having count(order_id) >= 15
and sum(total_amount) >= 500000
order by total_sum desc, customer_id
limit 20