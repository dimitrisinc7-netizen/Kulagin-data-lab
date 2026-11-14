drop table if exists customers, products, orders, order_items, categories;
create table categories (
    category_id   bigint generated always as identity primary key,
    name            text not null unique,
    description     text
);
create table customers (
    customer_id   bigint generated always as identity primary key,
    email         text not null unique,
    full_name     text not null,
    phone         text,
    country       text not null check (country IN ('UA', 'PL')),
    city          text not null,
    registered_at timestamptz not null default now()
);
create table products (
    product_id    bigint generated always as identity primary key,
    sku           text not null unique,
    name          text not null,
    brand         text not null,
    category      text not null,
    price         numeric(10, 2) not null check (price > 0),
    stock         integer not null default 0 check (stock >= 0),
    is_active     boolean not null default true,
    attributes    json 
);
create table orders (
    order_id      bigint generated always as identity primary key,
    customer_id   bigint not null references customers (customer_id),
    status        text not null default 'new' check (status in ('new', 'paid', 'shipped', 'cancelled', 'delivered')),
    created_at    timestamptz not null default now()
);
create table order_items (
    order_id      bigint not null references orders (order_id) on delete cascade, 
    product_id    bigint not null references products (product_id) on delete restrict,
    quantity      integer not null check (quantity > 0),
    unit_price    numeric(10, 2) not null check (unit_price > 0),
    primary key (product_id, order_id)
);