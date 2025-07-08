use daraz;

if OBJECT_ID('product', 'U') is null
begin

create table product(
	productid int identity(1,1) primary key,
	productname varchar(200) not null ,
	productprice varchar (10) not null  ,

);

end

if OBJECT_ID('costumer', 'U') is null
begin
create table costumer(
	custumerid int identity(1,1) PRIMARY KEY,
	custumername varchar(200) not null ,
	custumeraddrss varchar (10) not null  ,

);
end
if OBJECT_ID('oder', 'U') is null
begin
create table oder(
	orderid int identity(1,1) primary key,
	ordername varchar(200) not null ,
	orderdate datetime default getdate()   ,
	addres varchar(200) not null,
	
);
end
if OBJECT_ID('orderdetails', 'U') is null
begin
create table orderdetails(
			OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
        OrderID INT NOT NULL,
        productID INT NOT NULL,
		foreign key (orderid)references oder(orderid),
		foreign key (productid) references product(productid),

);
end

SET IDENTITY_INSERT product ON
 INSERT INTO product(Productid,ProductName, ProductPrice )
    VALUES
        (1,'Wireless Keyboard', 29.99),
        (2,'Bluetooth Mouse', 19.99);
SET IDENTITY_INSERT product OFF

select * from product;