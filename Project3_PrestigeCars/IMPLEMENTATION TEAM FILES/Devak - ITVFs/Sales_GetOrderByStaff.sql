--Retrieve Orders by who sold them by passing the staff member's id
CREATE FUNCTION Sales.GetOrdersByStaff(@StaffId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT so.SalesOrderId,so.InvoiceNumber,so.OrderDate,c.FirstName + ' ' + c.LastName AS CustomerFullName
    FROM Sales.SalesOrder AS so
    INNER JOIN HumanResources.Customer AS c ON so.CustomerId = c.CustomerId
    INNER JOIN ReferenceData.Country AS co ON c.CountryId = co.CountryId
    WHERE so.StaffId = @StaffId
);