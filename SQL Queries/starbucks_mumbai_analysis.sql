CREATE DATABASE starbucks;
use starbucks;

create table customers(
  customer_id varchar(10) primary key,
  customer_name varchar(30),
  age int,
  gender varchar(15),
  area varchar(30),
  membership_type varchar(30)
  );
  
  create table stores(
   store_id varchar(20) primary key,
   store_name varchar(80),
   location varchar(80)
   );
   
   create table products(
   product_id varchar(20) primary key,
   product_name varchar(50),
   category varchar (50),
   price float(20)
   );

   create table orders(
   orders_id varchar(10) primary key,
   customer_id varchar(10),
   store_id varchar(20),
   order_date date,
   
   foreign key (customer_id) references customers(customer_id),
   foreign key (store_id) references stores(store_id)
   );
   
   create table order_details(
   detail_id varchar(10) primary key,
   orders_id varchar(10),
   product_id varchar(20),
   quantity int,
   
   foreign key (orders_id) references orders(orders_id),
   foreign key (product_id) references products(product_id)
   );
   
   show tables;
   
   select count(*) as total_cutomers from customers;
   select count(*) from stores;
   select count(*) from products;
   
   select count(*) from orders;
   select count(*) from order_details;
   
   select sum(p.price * od.quantity) as total_revenue
   from order_details od
   join products p
   on od.product_id = p.product_id;
   
   
   select round(
   sum(p.price * od.quantity)/
   count(distinct o.orders_id),
   2)
   as avg_orders
   from orders o
   join order_details od
   on o.orders_id = od.orders_id
   join products p
   on od.product_id = p.product_id;

   select sum(quantity) as total_quantity from order_details;

select p.product_name,
sum(p.price * od.quantity) as revenue
from products p
join order_details od
on p.product_id = od.product_id
group by p.product_name
order by revenue desc;


select p.product_name,
sum(od.quantity) as quantity_sold
from products p
join order_details od
on p.product_id = od.product_id
group by p.product_name
order by quantity_sold desc;


select p.category,
sum(p.price * od.quantity) as revenue
from products p
join order_details od
on p.product_id * od.product_id
group by p.category
order by revenue desc;



select p.product_name,
sum(od.quantity) as quantity_sold
from products p
join order_details od
on p.product_id = od.product_id
group by p.product_name
order by quantity_sold;


select c.customer_name,
sum(p.price * od.quantity) as total_spent
from customers c
join orders o
on c.customer_id = o.customer_id
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by c.customer_name
order by total_spent desc;


select c.membership_type,
sum(p.price * od.quantity) as revenue
from customers c
join orders o
on c.customer_id = o.customer_id
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by c.membership_type;



select c.gender,
sum(p.price * od.quantity) as revenue
from customers c
join orders o
on c.customer_id = o.customer_id
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by c.gender; 


select case
when age < 25 then '18-24'
when age < 35 then '25-34'
when age < 45 then '35-44'
else '45+'
end as age_group,
sum(p.price * od.quantity) as revenue
from customers c
join orders o
on c.customer_id = o.customer_id
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by age_group; 


select s.store_name,
sum(p.price * od.quantity) as revenue
from stores s
join orders o
on s.store_id = o.store_id
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by s.store_name
order by revenue desc;


select s.location,
sum(p.price * od.quantity) as revenue
from stores s
join orders o
on s.store_id = o.store_id
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by s.location
order by revenue desc;


select 
store_name,
revenue,
rank() over (order by revenue desc) as store_rank
from
(
select s.store_name,
sum(p.price * od.quantity) as revenue
from stores s
join orders o
on s.store_id = o.store_id
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by s.store_name) x;


select
month (order_date) as month_no,
sum(p.price * od.quantity) as revenue
from orders o
join order_details od
on o.orders_id = od.orders_id
join products p
on od.product_id = p.product_id
group by month(order_date)
order by month_no;


select
    month_no,
    revenue,
    sum(revenue) over(order by month_no) as running_total
from
(
    select
        month(order_date) as month_no,
        sum(p.price * od.quantity) as revenue
    from orders o
    join order_details od
        on o.orders_id = od.orders_id
    join products p
        on od.product_id = p.product_id
    group by month(order_date)
) x;

select *
from
(
    select
        c.membership_type,
        c.customer_name,
        sum(p.price * od.quantity) as spending,
        row_number() over(
            partition by c.membership_type
            order by sum(p.price * od.quantity) desc
        ) as rn
    from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_details od
        on o.orders_id = od.orders_id
    join products p
        on od.product_id = p.product_id
    group by c.membership_type, c.customer_name
) x
where rn = 1;


select
    store_name,
    revenue,
    round(
        (revenue * 100.0) /
        sum(revenue) over(),
        2
    ) as revenue_percentage
from
(
    select
        s.store_name,
        sum(p.price * od.quantity) as revenue
    from stores s
    join orders o
        on s.store_id = o.store_id
    join order_details od
        on o.orders_id = od.orders_id
    join products p
        on od.product_id = p.product_id
    group by s.store_name
) x;



 

