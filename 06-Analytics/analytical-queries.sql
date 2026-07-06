USE Sakila_OLAP;
GO
--Total income by year - month - category (Using ROLLUP)
SELECT
    d.YearNumber,
    d.MonthNumber,
    f.CategoryName,
    SUM(fr.PaymentAmount) AS TotalRevenue
FROM FactRentalSales fr
INNER JOIN DimDate d
    ON fr.DateKey = d.DateKey
INNER JOIN DimFilm f
    ON fr.FilmKey = f.FilmKey
GROUP BY ROLLUP
(
    d.YearNumber,
    d.MonthNumber,
    f.CategoryName
)
ORDER BY
    d.YearNumber,
    d.MonthNumber,
    f.CategoryName;
GO

--Multi-dimensional analytical report showing revenue by (branch – category – year) with all possible analysis options (using CUBE)
SELECT
    s.StoreID,
    f.CategoryName,
    d.YearNumber,
    SUM(fr.PaymentAmount) AS TotalRevenue
FROM FactRentalSales fr
INNER JOIN DimStore s
    ON fr.StoreKey = s.StoreKey
INNER JOIN DimFilm f
    ON fr.FilmKey = f.FilmKey
INNER JOIN DimDate d
    ON fr.DateKey = d.DateKey
GROUP BY CUBE
(
    s.StoreID,
    f.CategoryName,
    d.YearNumber
)
ORDER BY
    s.StoreID,
    f.CategoryName,
    d.YearNumber;
GO


/*
A data SLICE displays total revenue (Total Revenue) by:
• Year
• Country where the store is located
• Film category
Data is only for:
• Years: 2005 – 2006
• Countries: USA - Canada
• Film Genres: Action - Comedy
*/
SELECT
    d.YearNumber AS [Year],
    s.Country,
    f.CategoryName,
    SUM(fr.PaymentAmount) AS TotalRevenue
FROM FactRentalSales fr
INNER JOIN DimDate d
    ON fr.DateKey = d.DateKey
INNER JOIN DimStore s
    ON fr.StoreKey = s.StoreKey
INNER JOIN DimFilm f
    ON fr.FilmKey = f.FilmKey
WHERE d.YearNumber IN (2005, 2006)
  AND s.Country IN ('USA', 'Canada')
  AND f.CategoryName IN ('Action', 'Comedy')
GROUP BY
    d.YearNumber,
    s.Country,
    f.CategoryName
ORDER BY
    d.YearNumber,
    s.Country,
    f.CategoryName;

--Analyze the Total Revenue in the database at the year level, then from the year level to the month, writing an SQL query for each level. (Drill down quirey)
SELECT
    d.YearNumber,
    SUM(fr.PaymentAmount) AS TotalRevenue
FROM FactRentalSales fr
INNER JOIN DimDate d
    ON fr.DateKey = d.DateKey
GROUP BY
    d.YearNumber
ORDER BY
    d.YearNumber;
GO

--------------------
SELECT
    d.YearNumber,
    d.MonthNumber,
    SUM(fr.PaymentAmount) AS TotalRevenue
FROM FactRentalSales fr
INNER JOIN DimDate d
    ON fr.DateKey = d.DateKey
GROUP BY
    d.YearNumber,
    d.MonthNumber
ORDER BY
    d.YearNumber,
    d.MonthNumber;
GO


--Divide customers into 4 groups according to the total revenue or amounts paid by each customer, clearly identifying the highest-spending customers and the lowest-spending customers.

WITH CustomerRevenue AS
(
    SELECT
        c.CustomerKey,
        c.CustomerID,
        c.FullName,
        SUM(fr.PaymentAmount) AS TotalPaid
    FROM FactRentalSales fr
    INNER JOIN DimCustomer c
        ON fr.CustomerKey = c.CustomerKey
    GROUP BY
        c.CustomerKey,
        c.CustomerID,
        c.FullName
),
CustomerGroups AS
(
    SELECT
        CustomerKey,
        CustomerID,
        FullName,
        TotalPaid,
        NTILE(4) OVER (ORDER BY TotalPaid DESC) AS CustomerGroup
    FROM CustomerRevenue
)
SELECT
    CustomerKey,
    CustomerID,
    FullName,
    TotalPaid,
    CustomerGroup,
    CASE
        WHEN CustomerGroup = 1 THEN 'Highest Spending Customers'
        WHEN CustomerGroup = 4 THEN 'Lowest Spending Customers'
        ELSE 'Middle Spending Customers'
    END AS GroupDescription
FROM CustomerGroups
ORDER BY
    CustomerGroup,
    TotalPaid DESC;
GO
