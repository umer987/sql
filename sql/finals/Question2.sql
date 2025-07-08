Create Database Question2;
use Question2;

--1 Students Table
Create Table Students (
	StudentID INT Primary Key,
	FirstName Varchar(30),
	LastName Varchar(30),
	EnrollmentYear INT Not Null,
	DepartmentID Int,
	Foreign Key (DepartmentID) References Departments(DepartmentID)
);

--2 Courses Table
Create Table Courses (
    CourseID INT PRIMARY KEY, 
    CourseName Varchar(30), 
    DepartmentID Int,
	Foreign Key (DepartmentID) References Departments(DepartmentID)
);

-- Departments Table for Referetial Integrity
Create Table Departments (
	DepartmentID Int Primary Key,
	DepartmentName Varchar(50),
);

--3 Analyze Tables and Constraints: 
-- Student table ensures the EnrollmentYear field is mandatory and prevents duplicate student records using the PRIMARY KEY constraint
-- Courses table ensures the Department field is mandatory and maintains referential integrity to the corresponding field in the Students table.

--4 Unique Constraint on Enrollments and 5 Create Enrollments Table
Create Table Enrollments (
	EnrollmentID Int Primary Key,
	StudentID Int, 
	CourseID Int,
	EnrollmentDate Date,
	Unique (StudentID, CourseID), -- 4 Unique Constraint
	Foreign Key (StudentID) References Students(StudentID),
	Foreign Key (CourseID) References Courses(CourseID)
);

--Inserting Data into Tables
Insert Into Departments (DepartmentID, DepartmentName)
Values (1, 'Computer Science'),
       (2, 'Mathematics'),
       (3, 'Physics');

Insert Into Students (StudentID, FirstName, LastName, EnrollmentYear, DepartmentID)
Values (1, 'John', 'Doe', 2023, 1),
       (2, 'Jane', 'Smith', 2022, 2),
       (3, 'Jim', 'Brown', 2021, 3),
       (4, 'Emily', 'Davis', 2024, 1);

Insert Into Courses (CourseID, CourseName, DepartmentID)
Values (101, 'Data Structures', 1),
       (102, 'Calculus', 2),
       (103, 'Quantum Physics', 3),
       (104, 'Algorithms', 1);

Insert Into Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate)
Values (1, 1, 101, '2023-09-01'),
       (2, 1, 104, '2023-09-01'),
       (3, 2, 102, '2022-09-01'),
       (4, 3, 103, '2021-09-01'),
       (5, 4, 101, '2024-01-15');

--6 Retrieves the complete enrollment details, including student and course information.
Select Enrollments.EnrollmentID, Students.StudentID, Students.FirstName, Students.LastName, EnrollmentDate, Students.EnrollmentYear, Courses.CourseID, Courses.CourseName
From Students
Inner Join Enrollments ON Students.StudentID = Enrollments.StudentID
Inner Join Courses ON Enrollments.CourseID = Courses.CourseID;

--7 Courses With High Enrollment
Select 
	Courses.CourseName, Count(Enrollments.StudentID) As NumberOfStudents
From Courses 
Inner Join Enrollments ON Courses.CourseID = Enrollments.CourseID
Group By Courses.CourseName
Having Count(Enrollments.StudentID) > 1;

--8 List Students By Course
Select 
	Students.FirstName, Students.LastName, Students.DepartmentID, Courses.CourseName, Courses.CourseID
From Students
Inner Join Enrollments ON Students.StudentID = Enrollments.StudentID
Inner Join Courses ON Enrollments.CourseID = Courses.CourseID
Where Courses.CourseID = 101;

--9 Display Students and Courses
Select
	Students.StudentID, Students.FirstName, Students.LastName, Courses.CourseID, Courses.CourseName
From Students
Inner Join Enrollments ON Students.StudentID = Enrollments.StudentID
Inner Join Courses ON Enrollments.CourseID = Courses.CourseID;

-- 10 Trigger for Overlapping Enrollments
Create Trigger OverLappingEnrol
ON Enrollments
After Insert 
As
Begin 
	
	Declare @OverlapCount INT;

	Select @OverlapCount = COUNT (*)
	From Enrollments
	Inner Join Courses
	ON Enrollments.CourseID = Courses.CourseID
	Inner Join inserted 
	ON Enrollments.StudentID = inserted.StudentID
	Where Enrollments.EnrollmentDate = inserted.EnrollmentDate
	And Enrollments.StudentID = inserted.StudentID
	And Enrollments.EnrollmentID = inserted.EnrollmentID;

	If @OverlapCount > 0
	Begin
		Rollback;
	End;
End;

-- To check if the trigger exists
Select * From sys.triggers Where name = 'OverLappingEnrol';

