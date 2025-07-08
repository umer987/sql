use practice

create table orders(
order_id int primary key,
coustumer_id varchar(100) not null,
order_date varchar(100) not null,


);

insert into orders(order_id , coustumer_id ,order_date)
values 
(1, '001','1-02-2024'),
(2,'002','2-02-2021'),
(3,'003','2-02-2023'),
(4,'004','2-02-2022');


create table coustum(
coustumer_id int primary key,
coustumer_name varchar(100),
contact varchar(11),
countary varchar(100),
);

insert into coustum(coustumer_id , coustumer_name , contact , countary)
values 
(1,'umer', '0313327114','pakistan'),
(2,'bilal', '031312511',  'pakistan'),
(3,'a rehman', '0314442511',  'pakistan'),
(4,'kala', '031377711',  'pakistan');


select * from orders
select * from coustum

select orders.order_id ,coustum.coustumer_name , orders.order_date 
from orders inner join coustum on orders.order_id= coustum.coustumer_id
