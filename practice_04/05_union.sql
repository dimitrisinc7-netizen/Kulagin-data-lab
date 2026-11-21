--Завдання 5.1. Стрічка подій замовлення
select o.country_code,
       'замовлення' as metric,
       sum(o.total_amount) as amount
from shop.orders o
where o.created_at between '2025-12-01' and '2026-01-01'
group by o.country_code
union all
select o.country_code,
       'позиції',
       sum(oi.quantity * oi.unit_price)
from shop.orders o
join shop.order_items oi on oi.order_id = o.order_id
where o.created_at between '2025-12-01' and '2026-01-01'
group by o.country_code
union all
select o.country_code,
       'успешні платежі',
       sum(p.amount)
from shop.orders o
join shop.payments p on p.order_id = o.order_id
                    and p.payment_type = 'payment'
                    and p.status = 'succeeded'
where o.created_at between '2025-12-01' and '2026-01-01'
group by o.country_code
order by country_code, metric;