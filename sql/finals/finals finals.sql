--new for finals 
use prepations


create table productss(
	pid varchar(100) primary key ,
	pname varchar(100) ,
	pexpiry varchar(100) 
);
insert into productss(pid , pname , pexpiry)
values 
(1,'mouse','12-2-21'),
(2,'keyboard','123454');
select * from productss
--CREATE: Makes a new table or object in the database.
--ALTER: Changes an existing table or object, like adding or removing a column.
--DROP: Deletes a table or object completely.
--TRUNCATE: Removes all data from a table but keeps the table structure. 
 alter table productss add  pcode varchar(200)
  alter table productss drop COLUMN  pcode
  truncate table productss
  alter table productss add companyname varchar(1)
  alter table productss drop column companyname
  update productss set pname ='bloothooth' where pid =1
  delete productss where pid = 1
  drop table productss

  --built-in functions 
  CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,       -- Unique identifier for each transaction
    customer_name VARCHAR(100),          -- Name of the customer
    transaction_date DATE,               -- Date of the transaction
    transaction_amount DECIMAL(10, 2)    -- Amount for the transaction
);
INSERT INTO Transactions (transaction_id, customer_name, transaction_date, transaction_amount)
VALUES 
(1, 'Alice', '2025-01-01', 100.00),
(2, 'Bob', '2025-01-02', 250.50),
(3, 'Charlie', '2025-01-03', 300.75),
(4, 'Alice', '2025-01-04', 150.25),
(5, 'Bob', '2025-01-05', 200.00);
select * from Transactions
select COUNT(*) as totalpesa from Transactions
select SUM(transaction_amount) as adds from Transactions
select avg(transaction_amount) as adds from Transactions
select min(transaction_amount) as adds from Transactions
select max(transaction_amount) as adds from Transactions
select customer_name ,SUM(transaction_amount) from Transactions group by customer_name