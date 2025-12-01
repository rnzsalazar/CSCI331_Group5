USE [PrestigeCars_Project3];
GO
--Retrieves Customers by their 3 letter Country Code
CREATE FUNCTION HumanResources.GetCustomersByCountryISO3
(
    @CountryISO3 CHAR(3)
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.CustomerId,c.FirstName,c.LastName,c.Email,c.Phone,c.City,rf.CountryName,rf.CountryISO3
    FROM HumanResources.Customer AS c
    INNER JOIN ReferenceData.Country AS rf 
        ON c.CountryId = rf.CountryId
    WHERE rf.CountryISO2 = @CountryISO3
);