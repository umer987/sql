Create Database Question3;
use Question3;

Create Table Appointments (
	AppointmentID Varchar(30) Primary Key,
	PatientID Varchar(30),
	DoctorID Varchar(30),
	Date Date,
	Fee INT,
	Foreign Key (PatientID) References Patients(PatientID),
	Foreign Key (DoctorID) References Doctors(DoctorID),
);

Create Table Patients (
	PatientID Varchar(30) Primary Key,
	Name Varchar(50),
	Age INT,
	Gender Varchar(10)
);

Create Table Doctors (
	DoctorID Varchar(30) Primary Key,
	Name Varchar(50),
	Speciality Varchar(50)
);

Insert Into Appointments(AppointmentID, PatientID, DoctorID, Date, Fee)
Values 
	('APPT001', 'PAT001', 'DOC001', '2024-02-10', 600),
	('APPT002', 'PAT002', 'DOC002', '2024-02-11', 750),
	('APPT003', 'PAT003', 'DOC003', '2024-02-12', 900);
	
Insert Into Patients(PatientID, Name, Age, Gender)
Values 
	('PAT001', 'John', 28, 'M'),
	('PAT002', 'Emma', 34, 'F'),
	('PAT003', 'Micheal', 40, 'M');

Insert Into Doctors(DoctorID, Name, Speciality)
Values 
	('DOC001', 'Dr. Williams', 'Pediatrics'),
	('DOC002', 'Dr. Brown', 'Orthopedics'),
	('DOC003', 'Dr. Taylor', 'Dermatology');

-- 1 Calculate Total Revenue
select * from Appointments
sElect * from Doctors
select * from Patients
Select SUM(FEE) as total_revenue
from Appointments




	SUM(Fee) AS TotalRevenue
From Appointments;

--2 Doctor Appointment Count 

select Doctors.Name , COUNT(Appointments.AppointmentID) as total_appoinments
from Appointments
join Doctors on Appointments.DoctorID= Doctors.DoctorID
group by Doctors.Name




Select 
	Doctors.Name, COUNT(Appointments.AppointmentID) AS TotalAppointments
From Appointments
Inner Join Doctors ON Appointments.DoctorID = Doctors.DoctorID
Group By Doctors.Name;

--3 Top Patient By Appointments
select Patients.Name , Patients.PatientID, COUNT(Appointments.AppointmentID) as total_number_ofappoinments
from Appointments join Patients on Appointments.PatientID = Patients.PatientID
group by Patients.Name, Patients.PatientID
order by total_number_ofappoinments desc;




Select 
	Patients.PatientID, Patients.Name, COUNT(Appointments.AppointmentID) AS TotalAppointments
From Appointments
Inner Join Patients ON Appointments.PatientID = Patients.PatientID
Group By Patients.PatientID, Patients.Name
Order By TotalAppointments DESC;

--4 Patient With Most and Least Appointments

Alter Table Appointments
Add AppointNumber INT;

UPDATE Appointments
SET AppointNumber = 4
WHERE AppointmentID = 'APPT001';

UPDATE Appointments
SET AppointNumber = 1
WHERE AppointmentID = 'APPT002';

UPDATE Appointments
SET AppointNumber = 3
WHERE AppointmentID = 'APPT003';

--MOST 
Select 
	Patients.PatientID, Patients.Name, MAX(Appointments.AppointNumber) AS HighestAppointNumber
From Appointments
Inner Join Patients ON Appointments.PatientID = Patients.PatientID
WHERE Appointments.AppointNumber = 
    (SELECT MAX(AppointNumber) FROM Appointments)
Group By Patients.PatientID, Patients.Name;

--LEAST
Select 
	Patients.PatientID, Patients.Name, MIN(Appointments.AppointNumber) AS LeastAppointNumber
From Appointments
Inner Join Patients ON Appointments.PatientID = Patients.PatientID
WHERE Appointments.AppointNumber = 
    (SELECT MIN(AppointNumber) FROM Appointments)
Group By Patients.PatientID, Patients.Name;

-- 5 Doctor NAME and Count Number of Appointment
Select 
	Doctors.Name, COUNT(Appointments.AppointmentID) AS TotalAppointments
From Appointments
Inner Join Doctors ON Appointments.DoctorID = Doctors.DoctorID
Group By Doctors.Name;


--7 Stored Procedure for Doctor Revenue
Create Procedure DoctorRevenue
@startDate Date,
@endDate Date
AS
Begin 
	Select Doctors.Name, SUM(Appointments.Fee) AS TOTAL_Revenue
	From Appointments
	Inner Join Doctors 
	ON Appointments.DoctorID = Doctors.DoctorID
	Where Appointments.Date Between @startDate and @endDate
	Group By Doctors.Name;
End;

Exec DoctorRevenue '2024-02-01', '2024-02-28';

