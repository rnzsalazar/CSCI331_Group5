/* =====================================================================
   CS331 – Chapter 7 SQL Examples (AdventureWorks)
   Medium Article Sources (2 total):

   1. Saumya Srivastava – (https://medium.com/%40saumya.sriv27/4-understanding-sql-and-or-and-not-operators-40e3ac664518?utm_source=chatgpt.com)
      "Understanding SQL — AND, OR, and NOT Operators"
      (Logical operator fundamentals)
      Used in Examples: 1, 2, 3

   2. JavaGuides – (https://medium.com/javaguides/advanced-sql-queries-joins-subqueries-and-window-functions-1f24f897137a?utm_source=chatgpt.com)
      "Advanced SQL Queries: Joins, Subqueries, and Window Functions"
      (Joins, subqueries, aggregates, set operations)
      Used in Examples: 4, 5, 6, 7, 8, 9, 10
===================================================================== */


/* =====================================================================
   Example 1 – Customers in a specific city AND state (AND)
   Inspired by: Medium article on logical operators (AND/OR/NOT)

   Proposition:
   List all customers who live in the city 'Seattle' AND in the state 'WA'.

   Notes:
   - Sales.Customer.PersonID -> Person.Person.BusinessEntityID
   - Person.BusinessEntityAddress links people to Person.Address
   - Person.Address contains City and StateProvinceID
===================================================================== */
SELECT
    c.CustomerID,
    p.FirstName,
    p.LastName,
    a.City,
    sp.StateProvinceCode
FROM Sales.Customer AS c
JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress AS bea
    ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address AS a
    ON bea.AddressID = a.AddressID
JOIN Person.StateProvince AS sp
    ON a.StateProvinceID = sp.StateProvinceID
WHERE a.City = 'Seattle'
  AND sp.StateProvinceCode = 'WA';


/* =====================================================================
   Example 2 – High-priced products with profitable pricing (AND)
   Inspired by: Medium article on logical operators (AND/OR/NOT)

   Proposition:
   Show all products whose ListPrice is greater than 1000
   AND whose ListPrice is greater than StandardCost
   (i.e., the product is both high-priced AND sold above cost).
===================================================================== */
SELECT
    p.ProductID,
    p.Name,
    p.StandardCost,
    p.ListPrice
FROM Production.Product AS p
WHERE p.ListPrice > 1000
  AND p.ListPrice > p.StandardCost;


/* =====================================================================
   Example 3 – Orders from multiple territories (OR)
   Inspired by: Medium article on logical operators (AND/OR/NOT)

   Proposition:
   Retrieve all sales orders that belong to either the 'Northwest'
   OR the 'Northeast' sales territories.
===================================================================== */
SELECT
    soh.SalesOrderID,
    soh.OrderDate,
    st.Name       AS TerritoryName,
    st.CountryRegionCode
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE st.Name = 'Northwest'
   OR st.Name = 'Northeast';


/* =====================================================================
    Proposition 4 – Email-active users who opted for promotion level 2
    Inspired by Medium article: Advanced SQL (Joins, Subqueries, Aggregations).
	Description:
    Finds users with EmailPromotion = 2 AND at least one email address.
    How it works:
   INTERSECT keeps only BusinessEntityIDs appearing in both sets.
===================================================================== */
SELECT p.BusinessEntityID, ea.EmailAddress
FROM Person.EmailAddress AS ea
JOIN Person.Person AS p
    ON p.BusinessEntityID = ea.BusinessEntityID
WHERE p.BusinessEntityID IN (
    SELECT BusinessEntityID FROM Person.Person WHERE EmailPromotion = 2
    INTERSECT
    SELECT BusinessEntityID FROM Person.EmailAddress
)
ORDER BY ea.EmailAddress;


/* =====================================================================
   Example 5 – Customers with large total sales (JOIN + HAVING)
   Inspired by: Medium article on joins, aggregates, and HAVING

   Proposition:
   Find customers whose total sales amount (SUM of TotalDue across all
   their orders) is greater than 100,000.

   Notes:
   - SalesOrderHeader.TotalDue already includes tax and freight.
===================================================================== */
SELECT
    c.CustomerID,
    SUM(soh.TotalDue) AS TotalSalesAmount
FROM Sales.Customer AS c
JOIN Sales.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY
    c.CustomerID
HAVING
    SUM(soh.TotalDue) > 100000;


/* =====================================================================
   Example 6 – Products priced above the average product price (scalar subquery)
   Inspired by: Medium article on subqueries and comparison with aggregates

   Proposition:
   Show all products whose ListPrice is higher than the average
   ListPrice of all products.
===================================================================== */
SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM Production.Product AS p
WHERE p.ListPrice >
    (
        SELECT AVG(ListPrice)
        FROM Production.Product
    );


/* =====================================================================
   Example 7 – Customers with at least one high-value order (IN + subquery)
   Inspired by: Medium article on subqueries and IN

   Proposition:
   List all customers who have at least one order where TotalDue > 10,000.
===================================================================== */
SELECT
    c.CustomerID
FROM Sales.Customer AS c
WHERE c.CustomerID IN
(
    SELECT
        soh.CustomerID
    FROM Sales.SalesOrderHeader AS soh
    WHERE soh.TotalDue > 10000
);


/* =====================================================================
   Example 8 – Customers who have NEVER placed an order (LEFT JOIN + NULL)
   Inspired by: Medium article on joins and anti-join patterns

   Proposition:
   Find all customers who have never placed any sales orders from a Bike Store

   Pattern:
   - LEFT JOIN customers to SalesOrderHeader
   - Filter rows where SalesOrderHeader.CustomerID IS NULL
     (no matching order exists).
===================================================================== */
SELECT
    c.CustomerID,
    c.PersonID,
    c.StoreID,
    c.TerritoryID
FROM Sales.Customer AS c
LEFT JOIN Sales.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL AND c.StoreID = 934;


/* =====================================================================
   Example 9 – Customers with orders in Canada OR the United States (UNION)
   Inspired by Medium Article #2 (Set Operations)

   Proposition:
   Retrieve all customers who placed at least one order in Canada
   UNION customers who placed at least one order in the United States.

   Description:
   UNION combines both lists and removes duplicates, giving a clean list
   of North American customers. Always returns rows because AdventureWorks
   contains both CA and US territories.
===================================================================== */

SELECT DISTINCT soh.CustomerID, st.CountryRegionCode 
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE st.CountryRegionCode = 'CA'   -- Canada

UNION

SELECT DISTINCT soh.CustomerID, st.CountryRegionCode 
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE st.CountryRegionCode = 'US'   -- United States;



/* =====================================================================
   Example 10 – Employees with titles containing 'Manager' but NOT 'Senior'
   Inspired by Medium Article #2 (Set operations using EXCEPT)

   Proposition:
   Return all employees whose JobTitle includes 'Manager'
   EXCEPT those whose JobTitle also includes 'Senior'.

   Description:
   Demonstrates EXCEPT as a filtering set subtraction.
===================================================================== */
SELECT JobTitle, BusinessEntityID
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%'

EXCEPT

SELECT JobTitle, BusinessEntityID
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Senior Manager%';