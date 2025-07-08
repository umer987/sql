Create Database Question1;

Use Question1;

Create Table Warehouses (
	WarehouseID Varchar(10) Primary Key,
	Location Varchar(50),
	Capacity INT
);

Create Table Shipments (
	ShipmentID Varchar(10) Primary Key,
	WarehouseID Varchar(10),
	ClientID Varchar(10),
	Date Date,
	Quantity INT,
	Foreign Key (WarehouseID) References Warehouses (WarehouseID)
);

Insert Into Warehouses (WarehouseID, Location, Capacity)
Values 
	('W001', 'Houston', 1200),
	('W002', 'Atlanta', 800),
	('W003', 'Seattle', 600);


Insert Into Shipments(ShipmentID, WarehouseID, ClientID, Date, Quantity)
Values 
	('SHP001', 'W001', 'CLT001', '2024-01-10', 75),
	('SHP002', 'W002', 'CLT002', '2024-01-12', 40),
	('SHP003', 'W003', 'CLT003', '2024-01-15', 25);

--1 Stored Procedure Design
Create Procedure GetTotalShipments
	@startDate Date,
	@endDate Date
As
Begin
	Select 
		WarehouseID,
		SUM (Quantity) As TotalShipments
	From Shipments
	Where Date Between @startDate and @endDate
	Group By WarehouseID;
END;

EXEC GetTotalShipments '2024-01-01', '2024-01-30';

--2 ShipmentRecords
Create Procedure GetShipmentRecords
	@ClientID Varchar(10)
AS
BEGIN 
	Select *
	From Shipments
	Where ClientID = @ClientID;
END;

EXEC GetShipmentRecords 'CLT002';

--3 View Display all shipment within specific month
CREATE VIEW MonthlyShipments AS
SELECT 
    FORMAT(Date, '2024-01') AS ShipmentMonth,
    Location,
    SUM(Quantity) AS TotalShipments
FROM Shipments
JOIN Warehouses ON Shipments.WarehouseID = Warehouses.WarehouseID
GROUP BY FORMAT(Date, '2024-01'), Location;

Select * From MonthlyShipments;

--4 Warehouse Comparison 
Select Location, Max(Quantity) As TotalQuantity
From Shipments
Join Warehouses ON Shipments.WareHouseID = Warehouses.WarehouseID
Where Location IN ('Houston', 'Atlanta')
Group By Location
Order By TotalQuantity DESC;