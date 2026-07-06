USE Sakila_OLAP;
GO


INSERT INTO DimCustomer
(
    CustomerID,
    FirstName,
    LastName,
    FullName,
    Email,
    Active
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.first_name + ' ' + c.last_name AS FullName,
    c.email,
    c.active
FROM Sakila.dbo.customer c;
GO



INSERT INTO DimFilm
(
    FilmID,
    FilmTitle,
    Description,
    ReleaseYear,
    RentalRate,
    RentalDuration,
    FilmLength,
    Rating,
    CategoryName,
    LanguageName
)
SELECT
    f.film_id,
    f.title,
    f.description,
    f.release_year,
    f.rental_rate,
    f.rental_duration,
    f.length,
    f.rating,
    cat.name AS CategoryName,
    lang.name AS LanguageName
FROM Sakila.dbo.film f
    INNER JOIN Sakila.dbo.language lang
        ON f.language_id = lang.language_id
    INNER JOIN Sakila.dbo.film_category fc
        ON f.film_id = fc.film_id
    INNER JOIN Sakila.dbo.category cat
        ON fc.category_id = cat.category_id;
GO

INSERT INTO DimDate
(
    DateKey,
    FullDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    YearNumber
)
SELECT DISTINCT
    CONVERT(INT, CONVERT(VARCHAR, CAST(r.rental_date AS DATE), 112)) AS DateKey,
    CAST(r.rental_date AS DATE) AS FullDate,
    DAY(r.rental_date),
    MONTH(r.rental_date),
    DATENAME(MONTH, r.rental_date),
    DATEPART(QUARTER, r.rental_date),
    YEAR(r.rental_date)
FROM Sakila.dbo.rental r

UNION

SELECT DISTINCT
    CONVERT(INT, CONVERT(VARCHAR, CAST(p.payment_date AS DATE), 112)),
    CAST(p.payment_date AS DATE),
    DAY(p.payment_date),
    MONTH(p.payment_date),
    DATENAME(MONTH, p.payment_date),
    DATEPART(QUARTER, p.payment_date),
    YEAR(p.payment_date)
FROM Sakila.dbo.payment p;
GO


INSERT INTO DimStore
(
    StoreID,
    Address,
    District,
    City,
    Country
)
SELECT
    s.store_id,
    a.address,
    a.district,
    ci.city,
    co.country
FROM Sakila.dbo.store s
    INNER JOIN Sakila.dbo.address a
        ON s.address_id = a.address_id
    INNER JOIN Sakila.dbo.city ci
        ON a.city_id = ci.city_id
    INNER JOIN Sakila.dbo.country co
        ON ci.country_id = co.country_id;
GO



INSERT INTO DimStaff
(
    StaffID,
    FirstName,
    LastName,
    FullName,
    Email,
    StoreID,
    Active
)
SELECT
    st.staff_id,
    st.first_name,
    st.last_name,
    st.first_name + ' ' + st.last_name,
    st.email,
    st.store_id,
    st.active
FROM Sakila.dbo.staff st;
GO

INSERT INTO FactRentalSales
(
    CustomerKey,
    FilmKey,
    DateKey,
    StoreKey,
    StaffKey,

    RentalID,
    PaymentID,
    InventoryID,

    PaymentAmount,
    RentalCount,
    RentalDuration
)
SELECT

    dc.CustomerKey,
    df.FilmKey,
    
    CONVERT(INT,
        CONVERT(VARCHAR,
            CAST(p.payment_date AS DATE),112)
    ) AS DateKey,

    ds.StoreKey,
    dst.StaffKey,

    r.rental_id,
    p.payment_id,
    i.inventory_id,

    p.amount AS PaymentAmount,

    1 AS RentalCount,

    DATEDIFF
    (
        DAY,
        r.rental_date,
        r.return_date
    ) AS RentalDuration

FROM Sakila.dbo.payment p

    INNER JOIN Sakila.dbo.rental r
        ON p.rental_id = r.rental_id

    INNER JOIN Sakila.dbo.inventory i
        ON r.inventory_id = i.inventory_id

    INNER JOIN Sakila.dbo.film f
        ON i.film_id = f.film_id

    INNER JOIN Sakila.dbo.film_category fc
        ON f.film_id = fc.film_id

    INNER JOIN Sakila.dbo.category c
        ON fc.category_id = c.category_id

    INNER JOIN Sakila.dbo.language l
        ON f.language_id = l.language_id

    INNER JOIN DimCustomer dc
        ON dc.CustomerID = p.customer_id

    INNER JOIN DimFilm df
        ON df.FilmID = f.film_id
       AND df.CategoryName = c.name
       AND df.LanguageName = l.name

    INNER JOIN DimStore ds
        ON ds.StoreID = i.store_id

    INNER JOIN DimStaff dst
        ON dst.StaffID = p.staff_id;
GO


  -- TEST DATA

SELECT * FROM DimCustomer;
SELECT * FROM DimFilm;
SELECT * FROM DimDate;
SELECT * FROM DimStore;
SELECT * FROM DimStaff;

SELECT * FROM FactRentalSales;
GO
