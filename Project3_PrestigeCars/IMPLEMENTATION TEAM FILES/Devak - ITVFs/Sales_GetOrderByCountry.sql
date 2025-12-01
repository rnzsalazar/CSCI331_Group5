--Retrieve orders by the location that the customer was from
CREATE FUNCTION Sales.GetOrdersByCountry(@CountryISO2 CHAR(2))
RETURNS TABLE
AS
RETURN
(
    SELECT so.SalesOrderId,c.FirstName + ' ' + c.LastName AS CustomerFullName, co.CountryName
    FROM Sales.SalesOrder AS so
    INNER JOIN HumanResources.Customer AS c ON so.CustomerId = c.CustomerId
    INNER JOIN ReferenceData.Country AS co ON c.CountryId = co.CountryId
    WHERE co.CountryISO2 = @CountryISO2
);