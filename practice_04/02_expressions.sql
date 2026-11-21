--Задание 2.1. График рассрочки
select *, 'Заказа № ' || order_id as order_label, created_at::date as order_date, 
           round(total_amount/installments_count, 2) as monthly_payment, 
           round(installments_count / 12, 2)  as term_years,
           case
               when installments_count <= 4 then 'короткий' 
               when installments_count in (5,6) then 'середній' 
               else 'довгий'
              end as term_group
from orders
where country_code = 'UA'
and created_at between '2025-12-25' and '2026-01-01'
and installments_count > 1
order by monthly_payment desc, order_id;

--Завдання 2.2. Стан відправлень
select *, shipped_at::date as shipped_date, arrived_at::date - shipped_at::date as transit_days,
          case 
          	when returned_at is not null then 'Повернено'
          	when received_at is not null then 'Отримано'
          	when arrived_at is not null then 'Очікує отримання'
          	when shipped_at is not null then 'У дорозі'
          	else 'Не відправлено'
          	end as state,
          	coalesce (returned_at, received_at, arrived_at, shipped_at, created_at) as last_event_at
from shipments 
where created_at between '2025-12-25' and '2026-01-01'
order by shipment_id

--Задание 2.3. Контакты новых покупателей
select *, first_name || ' ' || upper(last_name) as full_name, 
          case 
	        when email is null then phone 
	        when email is not null then email
	      end as contact,
	      case 
	      	when email is null then 'телефон'
	      	when email is not null then 'email'
	      end as contact_type,
	      extract(year from birth_date) as birth_year,
	      updated_at::date - registered_at::date as days_registered 
from customers
where country_code = 'UA'
and registered_at  between '2025-12-01' and '2026-01-01'
and email ilike '%ukr.net' or email is null
order by registered_at desc, customer_id