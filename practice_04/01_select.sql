-- Завдання 1.1. Покупці без електронної пошти
select customer_id, first_name, last_name, phone, registered_at::date
from shop.customers 
where country_code = 'PL' 
    and email is null
    and registered_at between '2025-12-01' and '2026-01-01'
order by registered_at desc, customer_id;

--Завдання 1.2. Пошук у каталозі
select product_id , sku , name , weight_kg 
from shop.products
where sku like 'PHN-%' or sku like 'TAB-%'
     and name ilike 'Pro%'
     and name not like '%Pro Max%'
order by weight_kg desc, sku;

--Задание 1.3. Варианты оплаты
select distinct country_code, payment_method, installments_count
from shop.orders 
order by country_code , payment_method , installments_count

--Завдання 1.4. Третя сторінка списку повернених замовлень
select order_id, created_at::date, total_amount, payment_method  
from orders
where status = 'returned_to_sender'
     and country_code = 'UA'
     and created_at between '2025-01-01' and '2026-01-01'
order by total_amount desc
limit 25 offset 50

