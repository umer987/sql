use called
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
--question 1
CREATE PROCEDURE CalculateTotalShipments
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    -- Ensure the result is properly formatted
    SET NOCOUNT ON;

    -- Query to calculate total shipments
    SELECT 
        WarehouseID,
        SUM(Quantity) AS TotalQuantity
    FROM Shipments
    WHERE [Date] BETWEEN @StartDate AND @EndDate
    GROUP BY WarehouseID;
END;
EXEC CalculateTotalShipments @StartDate = '2024-01-10', @EndDate = '2025-01-31';
--q2
CREATE PROCEDURE GetClientShipments(
    @ClientID VARCHAR(50)
)
AS
BEGIN
    SELECT 
        ShipmentID,
        WarehouseID,
        [Date],
        Quantity
    FROM Shipments
    WHERE ClientID = @ClientID;
END;
EXEC GetClientShipments @ClientID = 'CLT001';

--3
CREATE VIEW MonthlyShipments AS
SELECT 
    Warehouse.Location AS WarehouseLocation,
    Shipments.ShipmentID,
    Shipments.ClientID,
    Shipments.[Date],
    Shipments.Quantity
FROM Shipments
INNER JOIN Warehouse ON Shipments.WarehouseID = Warehouse.WarehouseID
WHERE MONTH(Shipments.[Date]) = MONTH(GETDATE()) 
  AND YEAR(Shipments.[Date]) = YEAR(GETDATE());


SELECT * FROM MonthlyShipments;
--4
SELECT 
    WarehouseID,
    SUM(Quantity) AS TotalQuantity
FROM Shipments
WHERE WarehouseID IN ('W001', 'W002') -- Houston (W001) and Atlanta (W002)
GROUP BY WarehouseID
ORDER BY TotalQuantity DESC;
----------------------------------------q2
--1
--CREATE TABLE Students (
--    StudentID INT PRIMARY KEY, -- Unique StudentID
--    FirstName VARCHAR(100),
--    LastName VARCHAR(100),
--    EnrollmentYear INT NOT NULL, -- Mandatory EnrollmentYear
--    Department VARCHAR(100) Unique 
--);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    EnrollmentYear INT NOT NULL,
    DepartmentID INT unique,
    UNIQUE (FirstName, LastName, EnrollmentYear) -- Prevent duplication
);
--2
--CREATE TABLE Courses (
--    CourseID INT PRIMARY KEY,
--    CourseName VARCHAR(100),
--    Department VARCHAR(100) NOT NULL ,
--	FOREIGN KEY (Department) REFERENCES Students(Department)
--);
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES students(DepartmentID) -- Assuming Departments table exists
);
--5
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    UNIQUE (StudentID, CourseID), -- Ensure no duplicate enrollments
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
--7
SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    c.CourseID,
    c.CourseName,
    e.EnrollmentDate
FROM 
    Enrollments e
JOIN 
    Students s ON e.StudentID = s.StudentID
JOIN 
    Courses c ON e.CourseID = c.CourseID;
	--8
	SELECT 
    s.FirstName,
    s.LastName,
    c.CourseName
FROM 
    Students s
JOIN 
    Enrollments e ON s.StudentID = e.StudentID
JOIN 
    Courses c ON e.CourseID = c.CourseID;
	------------------------------------------------------------------9
	CREATE TRIGGER PreventOverlappingEnrollments
ON Enrollments
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @StudentID INT, @CourseID INT, @StartDate DATE, @EndDate DATE;

    SELECT @StudentID = StudentID, @CourseID = CourseID
    FROM inserted;

    -- Assuming you have a CourseSchedule table
    IF EXISTS (
        SELECT 1
        FROM Enrollments e
        JOIN CourseSchedule cs ON e.CourseID = cs.CourseID
        WHERE e.StudentID = @StudentID
        AND (
            (cs.StartDate < (SELECT StartDate FROM CourseSchedule WHERE CourseID = @CourseID) 
             AND cs.EndDate > (SELECT StartDate FROM CourseSchedule WHERE CourseID = @CourseID)) OR
            (cs.StartDate < (SELECT EndDate FROM CourseSchedule WHERE CourseID = @CourseID) 
             AND cs.EndDate > (SELECT EndDate FROM CourseSchedule WHERE CourseID = @CourseID)) OR
            (cs.StartDate >= (SELECT StartDate FROM CourseSchedule WHERE CourseID = @CourseID) 
            
	--------------------------------------------------10
	CREATE TRIGGER PreventOverlappingEnrollments
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    
    SELECT COUNT(*)
    INTO overlap_count
    FROM Enrollments e
    JOIN CourseSchedule cs ON e.CourseID = cs.CourseID
    WHERE e.StudentID = NEW.StudentID
    AND (
        (cs.StartDate < NEW.StartDate AND cs.EndDate > NEW.StartDate) OR
        (cs.StartDate < NEW.EndDate AND cs.EndDate > NEW.EndDate) OR
        (cs.StartDate >= NEW.StartDate AND cs.EndDate <= NEW.EndDate)
    );

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Enrollment overlaps with an existing course.';
    END IF;
END;CREATE TRIGGER PreventOverlappingEnrollments
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    
    SELECT COUNT(*)
    INTO overlap_count
    FROM Enrollments e
    JOIN CourseSchedule cs ON e.CourseID = cs.CourseID
    WHERE e.StudentID = NEW.StudentID
    AND (
        (cs.StartDate < NEW.StartDate AND cs.EndDate > NEW.StartDate) OR
        (cs.StartDate < NEW.EndDate AND cs.EndDate > NEW.EndDate) OR
        (cs.StartDate >= NEW.StartDate AND cs.EndDate <= NEW.EndDate)
    );

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Enrollment overlaps with an existing course.';
    END IF;
END;