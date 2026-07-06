CREATE DATABASE Sakila_OLAP;
GO

USE Sakila_OLAP;
GO

/* =========================
     Dimension: Customer
========================= */
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,            
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Active BIT
);
GO

/* =========================
   Dimension: Film
   Source: Film + FilmCategory + Category + Language
========================= */
CREATE TABLE DimFilm (
    FilmKey INT IDENTITY(1,1) PRIMARY KEY,
    FilmID INT NOT NULL,                 
    FilmTitle NVARCHAR(255),
    Description NVARCHAR(MAX),
    ReleaseYear INT,
    RentalRate DECIMAL(10,2),
    RentalDuration INT,
    FilmLength INT,
    Rating NVARCHAR(10),
    CategoryName NVARCHAR(50),
    LanguageName NVARCHAR(50)
);
GO

/* =========================
   Dimension: Date
   Source: RentalDate / PaymentDate
========================= */
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,         
    FullDate DATE NOT NULL,
    DayNumber INT,
    MonthNumber INT,
    MonthName NVARCHAR(20),
    QuarterNumber INT,
    YearNumber INT
);
GO

/* =========================
   Dimension: Store
========================= */
CREATE TABLE DimStore (
    StoreKey INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,               
    Address NVARCHAR(255),
    District NVARCHAR(100),
    City NVARCHAR(100),
    Country NVARCHAR(100)
);
GO

/* =========================
   Dimension: Staff
========================= */
CREATE TABLE DimStaff (
    StaffKey INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL,            
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    StoreID INT,
    Active BIT
);
GO

/* =========================
   Fact Table: Rental Sales
   Source: Rental + Payment + Inventory
========================= */
CREATE TABLE FactRentalSales (
    FactRentalSalesKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    CustomerKey INT NOT NULL,
    FilmKey INT NOT NULL,
    DateKey INT NOT NULL,
    StoreKey INT NOT NULL,
    StaffKey INT NOT NULL,

    RentalID INT,
    PaymentID INT,
    InventoryID INT,

    PaymentAmount DECIMAL(10,2) NOT NULL,
    RentalCount INT NOT NULL DEFAULT 1,
    RentalDuration INT,

    CONSTRAINT FK_FactRentalSales_DimCustomer
        FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),

    CONSTRAINT FK_FactRentalSales_DimFilm
        FOREIGN KEY (FilmKey) REFERENCES DimFilm(FilmKey),

    CONSTRAINT FK_FactRentalSales_DimDate
        FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),

    CONSTRAINT FK_FactRentalSales_DimStore
        FOREIGN KEY (StoreKey) REFERENCES DimStore(StoreKey),

    CONSTRAINT FK_FactRentalSales_DimStaff
        FOREIGN KEY (StaffKey) REFERENCES DimStaff(StaffKey)
);
GO
