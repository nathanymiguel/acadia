
-- Here is a sample of measures used in report, for all see DAX-Measures.xlsx

-- Calculate the total number of customers up to the most recent year: 970858
SELECT SUM(Customers) AS TotalCustomers
FROM acadia-2024.acadiatest1.debtdata
WHERE Year <= (
  SELECT MAX(Year) FROM acadia-2024.acadiatest1.debtdata
);

-- Calculate the total number of customers for the most recent year only: 484580
SELECT SUM(Customers) AS Total_Customers
FROM acadia-2024.acadiatest1.debtdata
WHERE Year = (
  SELECT MAX(Year) FROM acadia-2024.acadiatest1.debtdata
);

-- Calculate the total number of customers for the year prior to the most recent year: 486278
SELECT SUM(Customers) AS Total_Customers
FROM acadia-2024.acadiatest1.debtdata
WHERE Year = (
  SELECT MAX(Year) - 1 FROM acadia-2024.acadiatest1.debtdata
);

-- SQL query to calculate the percentage change in customers between the current and previous year
WITH YearlyData AS (
    SELECT
        Year,
        SUM(Customers) AS TotalCustomers
    FROM
        acadia-2024.acadiatest1.debtdata
    GROUP BY
        Year
),
CurrentAndPreviousData AS (
    SELECT
        a.Year AS CurrentYear,
        a.TotalCustomers AS CurrentYearCustomers,
        b.TotalCustomers AS PreviousYearCustomers
    FROM
        YearlyData a
    LEFT JOIN
        YearlyData b ON a.Year = b.Year + 1
)
SELECT
    CurrentYear,
    CurrentYearCustomers,
    PreviousYearCustomers,
    (CurrentYearCustomers - PreviousYearCustomers) / NULLIF(PreviousYearCustomers, 0) * 100 AS CustomerGrowthRate
FROM
    CurrentAndPreviousData;
