USE Sakila_OLAP;
GO

---Check years in tables
SELECT DISTINCT
    d.YearNumber
FROM FactRentalSales f
INNER JOIN DimDate d
    ON f.DateKey = d.DateKey
ORDER BY d.YearNumber;
GO


-- Create Partition Function using Date Key,

CREATE PARTITION FUNCTION PF_FactRentalSales_ByYear (INT)
AS RANGE RIGHT FOR VALUES
(
    20060101,
    20070101
);
GO

---- Create Partition Scheme
CREATE PARTITION SCHEME PS_FactRentalSales_ByYear
AS PARTITION PF_FactRentalSales_ByYear
ALL TO ([PRIMARY]);
GO

--CREATE NONCLUSTERED INDEX
CREATE NONCLUSTERED INDEX IX_FactRentalSales_DateKey_Partitioned
ON FactRentalSales (DateKey)
ON PS_FactRentalSales_ByYear (DateKey);
GO

--Test PARTITION 

SELECT
    $PARTITION.PF_FactRentalSales_ByYear(DateKey) AS PartitionNumber,
    COUNT(*) AS RowsCount,
    MIN(DateKey) AS MinDateKey,
    MAX(DateKey) AS MaxDateKey
FROM FactRentalSales
GROUP BY $PARTITION.PF_FactRentalSales_ByYear(DateKey)
ORDER BY PartitionNumber;
GO
