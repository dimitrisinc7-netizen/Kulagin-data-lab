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