Create Database Question4;
use Question4;

-- Creating Products Table
Create Table Products (
    ProductID VARCHAR(10) Primary Key,
    Name VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

-- Inserting Data into Products Table
Insert into Products (ProductID, Name, Category, Price, Stock)
Values
('PRD001', 'Smartphone', 'Electronics', 900, 15),
('PRD002', 'Sofa', 'Furniture', 600, 20),
('PRD003', 'Tablet', 'Electronics', 300, 30);

-- Creating Sales Table
Create Table Sales (
    SaleID VARCHAR(10) Primary Key,
    ProductID VARCHAR(10),
    Quantity INT,
    SaleDate DATE,
	Foreign Key (ProductID) References Products(ProductID)
);

-- Inserting Data into Sales Table
Insert into Sales (SaleID, ProductID, Quantity, SaleDate)
Values
('SAL001', 'PRD001', 3, '2025-01-10'),
('SAL002', 'PRD002', 2, '2025-01-11'),
('SAL003', 'PRD003', 1, '2025-01-12');


select * from Products
select * from Sales
--1 Extracting valuable data from Products and Sales tables

select Products.ProductID,Products.Name,Products.Stock , Products.Price,
		Sales.SaleDate,Sales.Quantity
		from Products join Sales on Products.ProductID=Sales.ProductID




----------------usman
Select P.ProductID, P.Name, P.Category, P.Price, P.Stock, 
       S.SaleID, S.Quantity, S.SaleDate
From Products P
Inner Join Sales S
On P.ProductID = S.ProductID;

--2 Calculate metrics (total revenue, remaining stock, and total units sold)
select Products.Name, Products.Category, 
SUM(Sales.Quantity) as toatal_revenue,
Products.Stock - SUM(Sales.Quantity) as stock_left,
SUM(Sales.Quantity*Products.Price) as total_unit_sold
from Products inner join Sales on Products.ProductID=Sales.ProductID
group by Products.Name ,Products.Category,Products.Stock



Select P.Name, P.Category,
	   SUM(S.Quantity) AS TotalUnitsSold,
	   P.Stock - SUM(S.Quantity) AS RemainingStock,
	   SUM(S.Quantity * P.Price) AS TotalRevenue 
From Products P
Inner Join Sales S ON P.ProductID = S.ProductID
Group By P.Name, P.Category, P.Stock;

--3 Adding a New Category to Products Table
Insert into Products (ProductID, Name, Category, Price, Stock)
Values ('PRD005', 'Gaming Mouse', 'Gaming Accessories', 50, 100);

Select * from Products;

--4 Retrieve Sales for Specific Product 
Select S.SaleID, P.Name, P.Category, S.Quantity, S.SaleDate
From Sales S
Inner Join Products P
ON S.ProductID = P.ProductID
Where P.Name = 'SmartPhone';

--5 Top-Selling Product
Select Top 1 P.Name, P.Category, SUM(S.Quantity) AS TotalUnitsSold
From Sales S
Inner Join Products P
ON S.ProductID = P.ProductID
Group By P.Name, P.Category
Order By TotalUnitsSold DESC;

--Aditional Operations
--1 Automate Database Tasks (Update Stock after Sales and Revenue Calculation)
Create Trigger StockAfterSales
ON Sales
After Insert
AS 
Begin 
	Declare @ProductID Varchar(10);
	Declare @Quantity INT;

	Select @ProductID = ProductID, @Quantity = Quantity
	From inserted;

	Update Products
	Set Stock = Stock - @Quantity
	Where ProductID = @ProductID;
END;

Select * From sys.triggers Where name = 'StockAfterSales';

--2 Update Stock Level 
Update Products
Set Stock = Stock - 5;

Select * From Products;

--3 Procedures
-- Update Stock After Sales
Create Procedure ProcedureStockAfterSales
@ProductID Varchar(10),
@Quantity INT
AS
Begin
	Update Products
	Set Stock = Stock - @Quantity
	Where ProductID = @ProductID;
END;

EXEC ProcedureStockAfterSales 'PRD001', 3;
Select * From Products;

-- Calculate Total Sales Revenue
Create Procedure ProcedureTotalSalesRevenue
AS
Begin
	Select P.Name, P.Category,
			SUM(S.Quantity * P.Price) AS TotalRevenue
	From Products P
	Inner Join Sales S
	ON P.ProductID = S.ProductID
	Group By P.Name, P.Category;
END;

EXEC ProcedureTotalSalesRevenue;

-- Generate Product Performance Report
Create Procedure ProcedureGeneratePerformanceReport
AS
Begin
	Select P.Name, P.Category, P.Stock,
		SUM(S.Quantity) AS TotalUnitsSold,
		SUM(S.Quantity * P.Price) AS TotalRevenue
	From Products P
	Inner Join Sales S
	ON P.ProductID = S.ProductID
	Group By P.Name, P.Category, P.Stock;
End;

EXEC ProcedureGeneratePerformanceReport;