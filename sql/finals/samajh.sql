use jklhj
create table warehouse(
WarehouseID varchar(100) primary key,
Location varchar(100),
Capacity int ,
);
insert into warehouse(WarehouseID, Location, Capacity)
values
('W001', 'Houston' ,1200),
('W002', 'Atlanta', 800),
('W003 ','Seattle ',600);
CREATE TABLE Shipments (
  ShipmentID VARCHAR(255) PRIMARY KEY,
  WarehouseID VARCHAR(255),
  ClientID VARCHAR(255),
  Date DATE,
  Quantity INT
);

INSERT INTO Shipments (ShipmentID, WarehouseID, ClientID, Date, Quantity) VALUES
('SHP001', 'W001', 'CLT001', '2024-01-10', 75),
('SHP002', 'W002', 'CLT002', '2024-01-12', 40),
('SHP003', 'W003', 'CLT003', '2024-01-15', 25);
select * from warehouse
select * from Shipments
create view ship as select * from Shipments;
create view ship1 as select ShipmentID,WarehouseID from Shipments;
select * from ship1

select * from ship
----------------------------------------------------------question 1
CREATE PROCEDURE GetTotalShipments
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        WarehouseID,
        SUM(Quantity) AS TotalShipments
    FROM 
        Shipments
    WHERE 
        Date BETWEEN @StartDate AND @EndDate
    GROUP BY 
        WarehouseID;
END;
EXEC GetTotalShipments '2024-01-10', '2024-01-15';
-------------------------------------------------------------b
CREATE PROCEDURE GetClientShipments
    @ClientID NVARCHAR(50)
AS
BEGIN
    SELECT 
        ShipmentID,
        WarehouseID,
        ClientID,
        Date,
        Quantity
    FROM 
        Shipments
    WHERE 
        ClientID = @ClientID;
END;
exec GetClientShipments 'CLT002'
------------------------------------------c
CREATE VIEW DailyShipments AS
SELECT 
    Warehouse.Location AS WarehouseLocation,
    s.Date AS ShipmentDate,
    SUM(s.Quantity) AS TotalShipments
FROM 
    Warehouse 
JOIN 
    Shipments s
ON 
    Warehouse.WarehouseID = s.WarehouseID
GROUP BY 
    Warehouse.Location, 
    s.Date;
	select * from DailyShipments
	-------------------------------------------------d
	SELECT 
    w.Location AS WarehouseLocation,
    SUM(s.Quantity) AS TotalShipmentQuantity
FROM 
    Warehouse w
JOIN 
    Shipments s
ON 
    w.WarehouseID = s.WarehouseID
WHERE 
    w.Location IN ('Houston', 'Atlanta')
GROUP BY 
    w.Location
ORDER BY 
    TotalShipmentQuantity DESC;

select * from warehouse
select * from Shipments

--------------------------------::::::::::::::::::::::::::::question 2:::::::::::::::::::::::::::::::::::::::::::::::::::::
CREATE TABLE Patients (
    PatientID NVARCHAR(50) PRIMARY KEY,
    Name NVARCHAR(100),
    Age INT,
    Gender CHAR(1)
);
CREATE TABLE Doctors (
    DoctorID NVARCHAR(50) PRIMARY KEY,
    Name NVARCHAR(100),
    Speciality NVARCHAR(100)
);
CREATE TABLE Appointments (
    AppointmentID NVARCHAR(50) PRIMARY KEY,
    PatientID NVARCHAR(50),
    DoctorID NVARCHAR(50),
    Date DATE,
    Fee DECIMAL(10, 2),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
INSERT INTO Patients (PatientID, Name, Age, Gender) 
VALUES 
('PAT001', 'John', 28, 'M'),
('PAT002', 'Emma', 34, 'F'),
('PAT003', 'Michael', 40, 'M');
INSERT INTO Doctors (DoctorID, Name, Speciality) 
VALUES 
('DOC001', 'Dr. Williams', 'Pediatrics'),
('DOC002', 'Dr. Brown', 'Orthopedics'),
('DOC003', 'Dr. Taylor', 'Dermatology');
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, Date, Fee)
VALUES 
('APPT001', 'PAT001', 'DOC001', '2024-02-10', 600),
('APPT002', 'PAT002', 'DOC002', '2024-02-11', 750),
('APPT003', 'PAT003', 'DOC003', '2024-02-12', 900);
--------------------------------------------------------------------------a
SELECT 
    SUM(Fee) AS TotalRevenue
FROM 
    Appointments;
-------------------------------------------------------------b
SELECT 
    d.Name AS DoctorName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM 
    Appointments a
JOIN 
    Doctors d
ON 
    a.DoctorID = d.DoctorID
GROUP BY 
    d.Name;
	------------------------------------------------------------------c
	SELECT TOP 1
    p.PatientID,
    p.Name AS PatientName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM 
    Appointments a
JOIN 
    Patients p
ON 
    a.PatientID = p.PatientID
GROUP BY 
    p.PatientID, p.Name
ORDER BY 
    TotalAppointments ASC;
	------------------------------------------------------------------------d
	WITH AppointmentCounts AS (
    SELECT 
        p.PatientID,
        p.Name AS PatientName,
        COUNT(a.AppointmentID) AS TotalAppointments
    FROM 
        Appointments a
    JOIN 
        Patients p
    ON 
        a.PatientID = p.PatientID
    GROUP BY 
        p.PatientID, p.Name
)
SELECT 
    (SELECT TOP 1 PatientName FROM AppointmentCounts ORDER BY TotalAppointments DESC) AS MostAppointmentsPatient,
    (SELECT TOP 1 PatientName FROM AppointmentCounts ORDER BY TotalAppointments ASC) AS LeastAppointmentsPatient,
    (SELECT TOP 1 TotalAppointments FROM AppointmentCounts ORDER BY TotalAppointments DESC) AS MostAppointmentsCount,
    (SELECT TOP 1 TotalAppointments FROM AppointmentCounts ORDER BY TotalAppointments ASC) AS LeastAppointmentsCount;
	---------------------------------------------------------------------d
	SELECT 
    d.Name AS DoctorName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM 
    Appointments a
JOIN 
    Doctors d
ON 
    a.DoctorID = d.DoctorID
GROUP BY 
    d.Name;


	------------------------------------------------------------------e
