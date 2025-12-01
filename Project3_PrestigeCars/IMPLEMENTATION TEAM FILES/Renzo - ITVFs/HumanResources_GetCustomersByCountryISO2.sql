USE [PrestigeCars_Project3];
GO
--Retrieves Customers by their 2 letter Country Code
CREATE FUNCTION HumanResources.GetCustomersByCountryISO2
(
    @CountryISO2 CHAR(2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.CustomerId,c.FirstName,c.LastName,c.Email,c.Phone,c.City,rf.CountryName,rf.CountryISO2
    FROM HumanResources.Customer AS c
    INNER JOIN ReferenceData.Country AS rf 
        ON c.CountryId = rf.CountryId
    WHERE rf.CountryISO2 = @CountryISO2
);