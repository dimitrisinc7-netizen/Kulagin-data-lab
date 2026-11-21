--Завдання 4.1. Продажі брендів
select c.name as country,
       b.name as brand,
       count(distinct o.order_id) as orders_cnt,
       sum(oi.quantity) as units_sold,
       sum(oi.quantity * unit_price) as revenue
from shop.orders o
join shop.order_items oi on oi.order_id = o.order_id
join shop.products p on p.product_id = oi.product_id
join shop.brands b on b.brand_id = p.brand_id 
join shop.countries c on c.country_code = o.country_code
where status = 'received'
and  o.created_at between '2025-10-01' and '2026-01-01'
group by c.country_code, c.name, b.brand_id, b.name
order by c.name, revenue desc, b.name;

--Завдання 4.2. Товари без продажів
select p.*,
       b.name as brand,
       c.name as category
from shop.products p
left join shop.order_items oi on oi.product_id = p.product_id
left join shop.brands b on b.brand_id = p.brand_id
left join shop.categories c on c.category_id = p.category_id
where oi.product_id is null
order by p.product_id

--Завдання 4.3. Дерево каталогу
select c.category_id, c.name as category, 
       par.name as parent, 
       count(p.product_id) as products_cnt
from shop.categories c
left join shop.categories par on par.category_id = c.parent_id
left join shop.products p on p.category_id   = c.category_id
group by c.category_id, c.name, par.name
order by c.category_id

--Завдання 4.4. Країни і перевізники
select c.name as country, 
       car.name as carrier, 
       count (o.order_id) as orders_cnt
from shop.carriers car
left join orders o on o.carrier_id = car.carrier_id and o.status = 'shipped'
left join shop.countries c on c.country_code = o.country_code
where created_at between '2025-10-01' and '2026-01-01'
group by c.name, car.name

--Завдання 5.1. Стрічка подій замовлення
select created_at as event_at,
       'заказ створено' as event,
       total_amount as amount
from shop.orders 
where order_id = 271060
union all
select created_at,
       case status
           when 'succeeded' then 'платіж успішний'
           when 'failed'then 'платіж відхилено'
       end,
       amount
from shop.payments
where order_id = 271060 and status IN ('succeeded', 'failed')
union all
select received_at,
       'отримано',
       null
from shop.shipments
where order_id = 271060 and received_at is not null
order by event_at

--Завдання 5.2. Звірка сум за грудень 2025 року
with dec_orders as (select order_id, country_code, total_amount
                    from shop.orders
                    where created_at between '2025-10-01' and '2026-01-01'
)
select country_code,
       'заказ' as metric,
       sum(total_amount) as amount
from dec_orders
group by country_code 
union all
select o.country_code,
       'позиції',
       sum(oi.quantity * oi.unit_price)
from dec_orders o
join shop.order_items oi on oi.order_id = o.order_id
group by o.country_code
union all 
select o.country_code,
       'успішні платежі',
       sum(p.amount)
from dec_orders o
join shop.payments p on p.order_id = o.order_id
                    and p.payment_type = 'payment'
                    and p.status = 'succeeded'
group by o.country_code
order by country_code, metric