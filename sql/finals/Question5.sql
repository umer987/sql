Create Database Question5;
use Question5;

CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

INSERT INTO Products VALUES
('P001', 'Laptop', 'Electronics', 1500, 20),
('P002', 'Sofa', 'Furniture', 800, 10),
('P003', 'Monitor', 'Electronics', 300, 15);

CREATE TABLE Sales (
    SaleID VARCHAR(10) PRIMARY KEY,
    ProductID VARCHAR(10) FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Sales VALUES
('S001', 'P001', 3, '2025-01-15'),
('S002', 'P002', 1, '2025-01-16'),
('S003', 'P003', 2, '2025-01-17');

CREATE TABLE Patients (
    PatientID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Gender CHAR(1)
);

INSERT INTO Patients VALUES
('PAT001', 'John', 30, 'M'),
('PAT002', 'Emily', 25, 'F'),
('PAT003', 'Michael', 40, 'M');

CREATE TABLE Doctors (
    DoctorID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    Speciality VARCHAR(50)
);

INSERT INTO Doctors VALUES
('DOC001', 'Dr. Smith', 'Cardiology'),
('DOC002', 'Dr. Brown', 'Neurology'),
('DOC003', 'Dr. Taylor', 'Orthopedics');

CREATE TABLE Appointments (
    AppointmentID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10) FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID VARCHAR(10) FOREIGN KEY REFERENCES Doctors(DoctorID),
    Date DATE,
    Fee DECIMAL(10, 2)
);

INSERT INTO Appointments VALUES
('A001', 'PAT001', 'DOC001', '2025-01-18', 500),
('A002', 'PAT002', 'DOC002', '2025-01-19', 700),
('A003', 'PAT003', 'DOC003', '2025-01-20', 800);

Select * From Products;
Select * From Sales;

Select * From Patients;
Select * From Appointments;
Select * From Doctors;


--1 Data Analysis
-- Product with highest sales
Select Top 1 P.Name, P.Category, 
	SUM(S.Quantity) AS TotalUnitsSold
From Products P
Inner Join Sales S ON P.ProductID = S.ProductID
Group By P.Name, P.Category
Order By TotalUnitsSold DESC;

Select Top 1 D.Name,
	COUNT(A.AppointmentID) AS TotalAppointments
From Doctors D
Inner Join Appointments A ON D.DoctorID = A.DoctorID
Group By D.Name
Order By TotalAppointments DESC;

-- Patient with highest number of visits
Select Top 1 P.Name,
	COUNT(A.AppointmentID) AS VisitCount
From Patients P
Inner Join Appointments A ON P.PatientID = A.PatientID
Group By P.Name
Order By VisitCount DESC;

--2 Automation
-- Trigger for stock reduction after a sale
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

Select * From Sys.triggers Where name = 'StockAfterSales';

Update Products
Set Stock = Stock - 5;

Select * From Products;

--Trigger to Validate PatientID and DoctorID


--3 Stored Procedure
--Total Revenue from appointments within a date range
Create Procedure TotalAppointmentRevenue
	@startDate Date,
	@endDate Date
AS
BEGIN
	Select SUM(Fee) AS TotalRevenue 
	From Appointments
	Where Date Between @startDate and @endDate;
End;

EXEC TotalAppointmentRevenue '2025-01-1', '2025-01-30';

--Total Revenue from sales by product category
Create Procedure RevenueByCategory
AS
BEGIN
	Select P.Category, SUM(S.Quantity * P.Price) AS TotalRevenue
	From Products P
	Inner Join Sales S ON P.ProductID = S.ProductID
	Group By P.Category;
END;

EXEC RevenueByCategory;

--4 Joins and Aggregation
--Total revenue and units sold per porduct
Select P.Name,
	SUM(S.Quantity * P.Price) AS TotalRevenue,
	SUM(S.Quantity) AS TotalUnitsSold
From Products P
Inner Join Sales S
ON P.ProductID = S.ProductID
Group By P.Name;

--Total appointments per doctor
Select D.Name, COUNT(A.AppointmentID) AS TotalAppointments
From Doctors D
Inner Join Appointments A
ON D.DoctorID = A.DoctorID
Group By D.Name;

--Details of patients treated by a specific doctor 
SELECT p.*
FROM Patients p
INNER JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.DoctorID = 'DOC001';

--5 Constraints 
-- Unique Constraint for appointments on same date
Alter Table Appointments
Add Constraint PatientDate Unique (PatientID, Date);

INSERT INTO Appointments VALUES
('A006', 'PAT001', 'DOC006', '2025-01-18', 600);

-- Unique constraint for sales on same date
Alter Table Sales 
Add Constraint ProductDate Unique (ProductID, SaleDate);

INSERT INTO Sales VALUES
('S006', 'P001', 6, '2025-01-15');

--7 Category Management
--Add a new category
INSERT INTO Products 
VALUES 
	('P004', 'Gaming Mouse', 'Gaming Accessories', 50, 25);

Select * From Products;

--Display products in new category
Select P.Name, P.Stock, SUM(S.Quantity) AS TotalSales
From Products P 
Left Join Sales S
ON P.ProductID = S.ProductID
WHERE P.Category = 'Gaming Accessories'
Group By P.Name, P.Stock;