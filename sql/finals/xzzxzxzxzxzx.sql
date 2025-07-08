use ballon
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


create procedure totalshipment
	@startdate date ,@enddate date
	as
	begin
	select 
	WarehouseID,
	SUM(Quantity) as totalshipment
	from Shipments
	where Date between @startdate and @enddate
	group by WarehouseID
	end;
	exec totalshipment '2024-01-10', '2024-01-10'

	create procedure shipment_by_client
	@client NVARCHAR(50)
	as
	begin 
	select
	ShipmentID ,
	WarehouseID,
	ClientID,
	Date,
	Quantity
	from Shipments
	where @client = ClientID
	end;
	exec shipment_by_client 'CLT002'
	-----------------------------------------------------------------------------
	SELECT 
    s.ShipmentID,
    w.WarehouseID,
    w.Location,
    s.ClientID,
    s.Date,
    s.Quantity
FROM 
    warehouse w
INNER JOIN 
    Shipments s
ON 
    w.WarehouseID = s.WarehouseID;


CREATE VIEW MonthlyShipments AS
SELECT 
    w.Location AS WarehouseLocation,
    MONTH(s.Date) AS ShipmentMonth,
    YEAR(s.Date) AS ShipmentYear,
    SUM(s.Quantity) AS TotalShipments
FROM 
    Warehouse w
JOIN 
    Shipments s
ON 
    w.WarehouseID = s.WarehouseID
GROUP BY 
    w.Location, 
    MONTH(s.Date), 
    YEAR(s.Date);
	select * from MonthlyShipments
	select * from warehouse
select * from Shipments


create view shipmentdetails as
select 
	warehouse.Location as warehouse_location,
	MONTH(Shipments.Date) as shipdate,
	YEAR(Shipments.Date) as shipyear,
	SUM(quantity) as totalshipments
	from warehouse
	join 
	shipments
	on warehouse.warehouseid = shipments.warehouseid
	group by 
	warehouse.location,
	month(Shipments.Date),
	YEAR(Shipments.Date);
	select * from shipmentdetails
	-------------------------------------------------------------------------------------------------------
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

	select 
	warehouse.Location as loac,
	sum(Shipments.quantity) as totalship
	from warehouse
	inner join
	Shipments
	on
	warehouse.warehouseid = Shipments.shipmentid
	where warehouse.location in ('Houston','Atlanta')
	group by warehouse.location
	ORDER BY 
    totalship DESC;


select * from warehouse
select * from Shipments
-----------------------------------------------------------------------------------------------qqqqqqqqqqqqq222222222222222222
------------------------------------------------------------------aaaaaaaaaaaaaaaaaaaaaaaaaa


CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    EnrollmentYear INT NOT NULL,  -- Mandatory field
    Department VARCHAR(50) unique NOT NULL
);
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT CHECK (Credits > 0),
    Department VARCHAR(50) NOT NULL,
    FOREIGN KEY (Department) REFERENCES Students(Department) ON DELETE CASCADE
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE DEFAULT GETDATE(),
    UNIQUE (StudentID, CourseID),  -- Ensuring no duplicate enrollments
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) 
);
INSERT INTO Courses (CourseID, CourseName, Credits, Department)
VALUES
(101, 'Data Structures', 3, 'Computer Science'),
(102, 'Thermodynamics', 4, 'Mechanical Engineering'),
(103, 'Circuit Analysis', 8, 'Electrical Engineering'),
(104, 'Database Management', 6, 'Computer Science'),
(105, 'Marketing Strategies', 7, 'Business Administration');
INSERT INTO Students (StudentID, FullName, Email, EnrollmentYear, Department)
VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', 2023, 'Computer Science'),
(2, 'Bob Smith', 'bob.smith@example.com', 2022, 'Mechanical Engineering'),
(3, 'Charlie Brown', 'charlie.brown@example.com', 2023, 'Electrical Engineering'),
(4, 'David Williams', 'david.williams@example.com', 2021, 'Software Engineering'), -- changed department
(5, 'Emma Wilson', 'emma.wilson@example.com', 2022, 'Business Administration');


INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
VALUES
(1, 101, '2024-01-10'),  -- Alice enrolls in Data Structures
(2, 102, '2024-01-12'),  -- Bob enrolls in Thermodynamics
(3, 103, '2024-01-15'),  -- Charlie enrolls in Circuit Analysis
(4, 104, '2024-02-01'),  -- David enrolls in Database Management
(5, 105, '2024-02-10'),  -- Emma enrolls in Marketing Strategies
(1, 104, '2024-03-05');  -- Alice enrolls in Database Management

SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;
----4
SELECT 
    e.EnrollmentID,
    s.FullName AS StudentName,
    s.Department,
    c.CourseName,
    e.EnrollmentDate
FROM 
    Enrollments e
JOIN 
    Students s ON e.StudentID = s.StudentID
JOIN 
    Courses c ON e.CourseID = c.CourseID;

	--5555555
	SELECT 
    c.CourseID, 
    c.CourseName, 
    COUNT(e.StudentID) AS EnrollmentCount
FROM 
    Enrollments e
JOIN 
    Courses c ON e.CourseID = c.CourseID
GROUP BY 
    c.CourseID, c.CourseName
ORDER BY 
    EnrollmentCount DESC;
	-------List Students by Course:
	SELECT 
    s.FullName, 
    s.Department, 
    c.CourseName, 
    c.Credits
FROM 
    Enrollments e
JOIN 
    Students s ON e.StudentID = s.StudentID
JOIN 
    Courses c ON e.CourseID = c.CourseID
WHERE 
    e.CourseID = c.CourseID;
	---

	--Display Students and Courses

	SELECT 
    s.StudentID,
    s.FullName, 
    c.CourseName
FROM 
    Students s
LEFT JOIN 
    Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN 
    Courses c ON e.CourseID = c.CourseID;


	--":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::questionon 3
	-- Create Patients table
CREATE TABLE Patients (
    PatientID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender CHAR(1)
);

-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100),
    Speciality VARCHAR(50)
);

-- Create Appointments table
CREATE TABLE Appointments (
    AppointmentID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    DoctorID VARCHAR(10),
    Date DATE,
    Fee DECIMAL(10, 2),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
-- Insert Patients data
INSERT INTO Patients (PatientID, Name, Age, Gender)
VALUES
('PAT001', 'John', 28, 'M'),
('PAT002', 'Emma', 34, 'F'),
('PAT003', 'Michael', 40, 'M');

-- Insert Doctors data
INSERT INTO Doctors (DoctorID, Name, Speciality)
VALUES
('DOC001', 'Dr. Williams', 'Pediatrics'),
('DOC002', 'Dr. Brown', 'Orthopedics'),
('DOC003', 'Dr. Taylor', 'Dermatology');

-- Insert Appointments data
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, Date, Fee)
VALUES
('APPT001', 'PAT001', 'DOC001', '2024-02-10', 600),
('APPT002', 'PAT002', 'DOC002', '2024-02-11', 750),
('APPT003', 'PAT003', 'DOC003', '2024-02-12', 900);

select * from doctors
select * from Appointments
select * from Patients

-------------------------------------------1Calculate Total Revenue
select sum(fee) as total_revenue
from Appointments
------------------------------------------2Doctor Appointment Count
select 
Doctors.Name as doctorname,
count(Appointments.AppointmentID) as totalappoinments from Appointments
join Doctors on Appointments.DoctorID = Doctors.DoctorID
group by Doctors.name





SELECT 
    Doctors.Name AS DoctorName,
    COUNT(Appointments.AppointmentID) AS TotalAppointments
FROM 
    Appointments
JOIN 
    Doctors ON Appointments.DoctorID = Doctors.DoctorID
GROUP BY 
    Doctors.Name;
	----------------------------------------3
	SELECT TOP 1 
    Patients.PatientID,
    Patients.Name AS PatientName,
    COUNT(Appointments.AppointmentID) AS TotalAppointments
FROM 
    Appointments
JOIN 
    Patients ON Appointments.PatientID = Patients.PatientID
GROUP BY 
    Patients.PatientID, Patients.Name
ORDER BY 
    TotalAppointments DESC;
--------------------------------------------4
-- Find the patient with the highest and lowest number of appointments
WITH AppointmentCounts AS (
    SELECT 
        Patients.PatientID,
        Patients.Name AS PatientName,
        COUNT(Appointments.AppointmentID) AS TotalAppointments
    FROM 
        Appointments
    JOIN 
        Patients ON Appointments.PatientID = Patients.PatientID
    GROUP BY 
        Patients.PatientID, Patients.Name
)
SELECT 
    PatientName,
    TotalAppointments
FROM 
    AppointmentCounts
WHERE 
    TotalAppointments = (SELECT MAX(TotalAppointments) FROM AppointmentCounts)
   OR 
    TotalAppointments = (SELECT MIN(TotalAppointments) FROM AppointmentCounts);
