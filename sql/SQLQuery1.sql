-- First, check if the database exists and drop it if necessary
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Bank_BC')
BEGIN
    DROP DATABASE Bank_BC;
END

-- Create the database
CREATE DATABASE Bank_BC;
GO

-- Use the newly created database
USE Bank_BC;
GO

-- Check if the table exists and drop it if necessary
IF OBJECT_ID('Bank_Customer', 'U') IS NOT NULL
BEGIN
    DROP TABLE Bank_Customer;
END

-- Create the Bank_Customer table
CREATE TABLE Bank_Customer 
(
    Cust_ID INT PRIMARY KEY,
    Cust_Nam VARCHAR(30),
    Cust_CNIC BIGINT,
    Cust_Account_No VARCHAR(20),
    Cust_Email VARCHAR(30),
    Cust_Add VARCHAR(50),
    Cust_Phone VARCHAR(20),
    Cust_Account_Type VARCHAR(15),
    Cust_Card_Type VARCHAR(20),
    Open_Date DATE
);

-- Insert a record into the Bank_Customer table
INSERT INTO Bank_Customer 
VALUES 
(1, 'Shafeeq Bhai', 422012277996389, 'PKHBL0017788991159', 
'shafeeqay@gmail.com', 'House# 9211, Perfume Chawk', '03001234567', 'Current', 'Golden', '2024-03-20'),
(2, 'Shafeeq Bhai', 422012277996389, 'PKHBL0017788991159', 
'shafeeqay@gmail.com', 'House# 9211, Perfume Chawk', '03001234567', 'Current', 'Golden', '2024-03-20'),
(3, 'Shafeeq Bhai', 422012277996389, 'PKHBL0017788991159', 
'shafeeqay@gmail.com', 'House# 9211, Perfume Chawk', '03001234567', 'Current', 'Golden', '2024-03-20');

-- Select all records from the Bank_Customer table
SELECT * FROM Bank_Customer;