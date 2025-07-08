
use finals
CREATE TABLE EMPLOYEES (
    EMP_ID INT PRIMARY KEY,
    EMP_NAME VARCHAR(50) NOT NULL,
    DEPARTMENT_ID INT,
    SALARY DECIMAL(10, 2)
);
CREATE TABLE DEPARTMENTS (
    DEPARTMENT_ID INT PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR(50) NOT NULL,
    LOCATION_ID INT
);
CREATE TABLE LOCATIONS (
    LOCATION_ID INT PRIMARY KEY,
    LOCATION_NAME VARCHAR(50) NOT NULL,
    COUNTRY VARCHAR(50)
);
INSERT INTO LOCATIONS VALUES (1, 'New York', 'USA');
INSERT INTO LOCATIONS VALUES (2, 'London', 'UK');
INSERT INTO LOCATIONS VALUES (3, 'Tokyo', 'Japan');
INSERT INTO LOCATIONS VALUES (4, 'Berlin', 'Germany');


INSERT INTO DEPARTMENTS VALUES (101, 'HR', 1);
INSERT INTO DEPARTMENTS VALUES (102, 'IT', 2);
INSERT INTO DEPARTMENTS VALUES (103, 'Sales', 3);
INSERT INTO DEPARTMENTS VALUES (104, 'Marketing', 4);
INSERT INTO DEPARTMENTS VALUES (105, 'Finance', 1);

INSERT INTO EMPLOYEES VALUES (1, 'Alice', 101, 50000.00);
INSERT INTO EMPLOYEES VALUES (2, 'Bob', 102, 60000.00);
INSERT INTO EMPLOYEES VALUES (3, 'Charlie', 103, 55000.00);
INSERT INTO EMPLOYEES VALUES (4, 'Diana', 104, 62000.00);
INSERT INTO EMPLOYEES VALUES (5, 'Eve', 105, 70000.00);
INSERT INTO EMPLOYEES VALUES (6, 'Frank', 102, 48000.00);
INSERT INTO EMPLOYEES VALUES (7, 'Grace', 103, 52000.00);
INSERT INTO EMPLOYEES VALUES (8, 'Hank', NULL, 45000.00);




select * from EMPLOYEES
select * from DEPARTMENTS
select * from LOCATIONS

select EMPLOYEES.EMP_NAME , DEPARTMENTS.DEPARTMENT_NAME from EMPLOYEES
inner join DEPARTMENTS on EMPLOYEES.DEPARTMENT_ID =DEPARTMENTS.DEPARTMENT_ID  





SELECT EMPLOYEES.EMP_NAME, DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEES
left JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;

SELECT EMPLOYEES.EMP_NAME, DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEES
FULL OUTER JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;

SELECT 
    EMPLOYEES.EMP_NAME, 
    DEPARTMENTS.DEPARTMENT_NAME, 
    LOCATIONS.LOCATION_NAME
FROM EMPLOYEES
INNER JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
INNER JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID;


--lab 11
--nested queries
SELECT EMP_ID, EMP_NAME, DEPARTMENT_ID
FROM Employees
WHERE DEPARTMENT_ID = (
    SELECT DEPARTMENT_ID
    FROM Departments
    WHERE DEPARTMENT_NAME = 'Marketing'
);
select * from EMPLOYEES
select * from DEPARTMENTS
SELECT EMP_ID, EMP_NAME, DEPARTMENT_ID
FROM Employees
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID
    FROM Departments
    WHERE DEPARTMENT_NAME IN ('HR', 'Sales')
);

--proceducer lab 12
-- Step 1: Create the Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,       -- Unique identifier for each sale
    ProductID INT,                -- Identifier for the product
    Quantity INT,                 -- Quantity sold
    Price DECIMAL(10, 2),         -- Price per unit
    SaleDate DATE                 -- Date of the sale
);

-- Step 2: Insert Sample Data into the Sales Table
INSERT INTO Sales (SaleID, ProductID, Quantity, Price, SaleDate)
VALUES
(1, 101, 2, 500.00, '2025-01-01'),
(2, 102, 1, 300.00, '2025-01-02'),
(3, 103, 3, 150.00, '2025-01-03');

-- Step 3: Create the Stored Procedure to Calculate Total Sales
CREATE PROCEDURE GetTotalSales
AS
BEGIN
    -- Calculate and return total sales revenue
    SELECT SUM(Quantity * Price) AS TotalRevenue
    FROM Sales;
END;
GO

-- Step 4: Execute the Stored Procedure
EXEC GetTotalSales;
GO




----triggrrs


-- Step 1: Create the Products Table


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,           -- Unique identifier for each product
    ProductName VARCHAR(100),            -- Name of the product
    Price DECIMAL(10, 2),                -- Price of the product
    Stock INT                            -- Stock quantity
);

-- Insert Sample Data into Products Table
INSERT INTO Products (ProductID, ProductName, Price, Stock)
VALUES
(1, 'Laptop', 1500.00, 10),
(2, 'Mouse', 25.00, 50),
(3, 'Keyboard', 45.00, 30);

-- Step 2: Create the ProductDeletionLog Table

CREATE TABLE ProductDeletionLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY, -- Auto-incremented unique identifier
    ProductID INT,                       -- ID of the deleted product
    ProductName VARCHAR(100),            -- Name of the deleted product
    DeletionDate DATETIME                -- Timestamp of the deletion
);


CREATE TRIGGER TrackProductDeletion
ON Products
AFTER DELETE
AS
BEGIN
    -- Insert details of deleted products into ProductDeletionLog
    INSERT INTO ProductDeletionLog (ProductID, ProductName, DeletionDate)
    SELECT ProductID, ProductName, GETDATE()
    FROM DELETED;
END;
GO

-- Step 4: Test the Trigger
-- Delete a Product from the Products Table
DELETE FROM Products WHERE ProductID = 2;
DELETE FROM Products WHERE ProductID = 3;
-- View the Log of Deleted Products
SELECT * FROM ProductDeletionLog;



-----views and indexes lab 13
