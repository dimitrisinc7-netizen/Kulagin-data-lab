-- 1. помилка: duplicate key value violates unique constraint "customers_email_key"
insert into customers(email, full_name, phone, country, city) values ('olena.koval@example.com', 'Лесь Лупан', '+380934444444', 'UA', 'Хацапетівка' )
-- 2. помилка: new row for relation "products" violates check constraint "products_price_check"
insert into products(sku, name, brand, category, price, stock, is_active, attributes) values('APL-AP5', 'AirPods 4', 'Apple', 'Навушники', '0', '45', 'true', '{"anc": true}')
-- 3. помилка: insert or update on table "order_items" violates foreign key constraint
insert into order_items (order_id, product_id, quantity, unit_price) values('1', '42', '1', '13000')
-- 4. помилка: duplicate key value violates unique constraint "order_items_pkey"
insert into order_items (order_id, product_id, quantity, unit_price) values('1', '18', '3', '13999.00')
-- 5. помилка: new row for relation "orders" violates check constraint "orders_status_check"
update orders set status = 'returned' where order_id = 1
-- 6. update or delete on table "customers" violates foreign key constraint "orders_customer_id_fkey" on table "orders"
delete from customers where customer_id = 1