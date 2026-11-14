begin;

select setval(pg_get_serial_sequence('orders', 'order_id'), (select max(order_id) from orders));
select product_id, sku, price, stock from products where sku in ('APL-IPD11-A16', 'SNY-XM5') order by product_id for update;
insert into orders (customer_id) select customer_id from customers where email = 'nazar.kravets@example.com' returning order_id;
insert into order_items (order_id, product_id, quantity, unit_price) select 73, product_id, quantity, price from(values('APL-IPD11-A16', 2), ('SNY-XM5', 1)) as v(sku, quantity) join products on products.sku = v.sku; 
update products set stock = stock - 2 where sku = 'APL-IPD11-A16';
update products set stock = stock - 1 where sku = 'SNY-XM5';

commit;

begin;

insert into orders (customer_id) select customer_id from customers where customer_id=1 returning order_id;
insert into order_items (order_id, product_id, quantity, unit_price) select currval(pg_get_serial_sequence('orders', 'order_id')), product_id, 3, price from products where sku = 'APL-MBA13-M4';
update products set stock = stock - 3 where sku = 'APL-MBA13-M4';

rollback;

select setval(pg_get_serial_sequence('products', 'product_id'), (select max(product_id) from products));

begin;

insert into products (sku, name, brand, price, stock, category_id) values ('APL-APP3', 'AirPods Pro 3', 'Apple', 11999.00, 42, 4),
                                                                          ('SMS-S25-256', 'Galaxy S25 256GB', 'Samsung', 35999.00, 20, 1),
                                                                          ('GGL-PX10-128', 'Pixel 10 128GB', 'Google', 34999.00, 15, 1),
                                                                          ('LNV-TABP12', 'Tab P12', 'Lenovo', 15499.50, 10, 3)
on conflict (sku) do update
set price = excluded.price, stock = excluded.stock returning sku, old.price AS old_price, new.price AS new_price;
savepoint before_discontinue;
delete from products where sku = 'JBL-T520BT';
rollback to savepoint before_discontinue;
update products set is_active = false where sku = 'JBL-T520BT';

commit;
  