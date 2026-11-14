begin;
create table categories (
    category_id    bigint generated always as identity primary key,
    name           text not null unique
   );
insert into categories(name) 
values('Смартфони'),
      ('Ноутбуки'), 
      ('Планшети'),
      ('Навушники'), 
      ('Розумні годинники')
alter table products add category_id bigint references categories (category_id) on delete restrict
update products set category_id = categories.category_id from categories where categories.name = products.category
alter table products alter column category_id set not null;
alter table products drop column category;
commit;