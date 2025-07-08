USE online_database;

IF OBJECT_ID('goods', 'U') IS NULL
BEGIN
    CREATE TABLE goods (
        ProductID INT IDENTITY(1,1) PRIMARY KEY,
        ProductName VARCHAR(255) NOT NULL,
        Price DECIMAL(10, 2) NOT NULL,
        StockQuantity INT NOT NULL
    );
END

IF OBJECT_ID('Cust', 'U') IS NULL
BEGIN
    CREATE TABLE Cust (
        CustomerID INT IDENTITY(1,1) PRIMARY KEY,
        Name VARCHAR(255) NOT NULL,
        Email VARCHAR(255) UNIQUE NOT NULL,
        Phone VARCHAR(20)
    );
END

IF OBJECT_ID('Orders', 'U') IS NULL
BEGIN
    CREATE TABLE Orders (
        OrderID INT IDENTITY(1,1) PRIMARY KEY,
        CustomerID INT NOT NULL,
        OrderDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (CustomerID) REFERENCES Cust(CustomerID)
    );
END

IF OBJECT_ID('OrderDetails', 'U') IS NULL
BEGIN
    CREATE TABLE OrderDetails (
        OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
        OrderID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
        FOREIGN KEY (ProductID) REFERENCES goods(ProductID)
    );
END

-- Insert sample data into goods if not already present
IF NOT EXISTS (SELECT 1 FROM goods WHERE ProductName = 'Wireless Keyboard')
BEGIN
    INSERT INTO goods (ProductName, Price, StockQuantity)
    VALUES
        ('Wireless Keyboard', 29.99, 100),
        ('Bluetooth Mouse', 19.99, 150);
END

-- Select data
SELECT * FROM goods;
