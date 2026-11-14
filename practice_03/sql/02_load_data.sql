copy customers (customer_id, email, full_name, phone, country, city, registered_at) from '/data/customers.csv' with (format csv, header true);
copy products (product_id, sku, name, brand, category, price, stock, is_active, attributes) from '/data/products.csv' with (format csv, header true);
copy orders (order_id, customer_id, status, created_at) from '/data/orders.csv' with (format csv, header true);
copy order_items (order_id, product_id, quantity, unit_price) from '/data/order_items.csv' with (format csv, header true);
select setval(pg_get_serial_sequence('customers', 'customer_id'), (select max(customer_id) from customers));
insert into customers(email, full_name, phone, country, city) values ('nazar.kravets@example.com', 'Назар Кравец', '+380671234567', 'UA', 'Тернопіль')