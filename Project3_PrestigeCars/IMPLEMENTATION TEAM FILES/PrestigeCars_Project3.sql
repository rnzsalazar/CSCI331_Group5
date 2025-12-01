--IN CASE YOU ALREADY HAD IT CREATED, SO IT WON'T CAUSE ANY ISSUES
DROP DATABASE IF EXISTS [PrestigeCars_Project3];
GO

CREATE DATABASE [PrestigeCars_Project3];
GO

USE [PrestigeCars_Project3];
GO

--Creating the Schemas based on our ERD design phase
CREATE SCHEMA Udt;
GO
CREATE SCHEMA HumanResources;
GO
CREATE SCHEMA Process;
GO
CREATE SCHEMA ReferenceData;
GO
CREATE SCHEMA Sales;
GO
CREATE SCHEMA ProductInformation;
GO

--Creating the UDTs we listed on our Reference Data Sheet

--ReferenceData
CREATE TYPE Udt.SurrogateKeyInt
FROM INT NOT NULL;
GO
CREATE TYPE Udt.SalesRegionName
FROM VARCHAR(50) NOT NULL;
GO
CREATE TYPE Udt.CountryName
FROM VARCHAR(100) NOT NULL;
GO
CREATE TYPE Udt.ISO2
FROM CHAR(2) NOT NULL;
GO
CREATE TYPE Udt.ISO3
FROM CHAR(3) NOT NULL;
GO
--HumanResources
CREATE TYPE Udt.PersonFirstName
FROM VARCHAR(50) NOT NULL;
GO
CREATE TYPE Udt.PersonLastName
FROM VARCHAR(50) NOT NULL;
GO
CREATE TYPE Udt.EmailAddress
FROM VARCHAR(255) NOT NULL;
GO
CREATE TYPE Udt.PhoneNumber
FROM VARCHAR(20) NOT NULL;
GO
CREATE TYPE Udt.AddressLine
FROM VARCHAR(100) NOT NULL;
GO
CREATE TYPE Udt.CityName
FROM VARCHAR(50) NOT NULL;
GO
CREATE TYPE Udt.PostalCode
FROM VARCHAR(15) NOT NULL;
GO
CREATE TYPE Udt.PersonFullName
FROM VARCHAR(100) NOT NULL;
GO
CREATE TYPE Udt.DepartmentName
FROM VARCHAR(50) NOT NULL;
GO
CREATE TYPE Udt.HierarchyReference
FROM INT NULL;
GO
--Sales
CREATE TYPE Udt.InvoiceNumber
FROM VARCHAR(50) NOT NULL;
GO
CREATE TYPE Udt.PriceAmount
FROM DECIMAL(10,2) NOT NULL;
GO
CREATE TYPE Udt.PercentValue
FROM DECIMAL(5,2) NOT NULL;
GO
--Creating Udts
-- Note: Udt.SurrogateKeyInt, Udt.YearInt are used in multiple tables

-- Udt for Production.Make
CREATE TYPE Udt.MakeName FROM VARCHAR(50) NOT NULL
GO
-- Udt For ProducInformation.Model
CREATE TYPE Udt.ModelName FROM VARCHAR(100) NOT NULL
GO
CREATE TYPE Udt.ModelVariantName FROM VARCHAR(50) NULL
GO
CREATE TYPE Udt.YearInt From INT NULL
GO
-- Udt For ProductInformation.Vehicle
CREATE TYPE Udt.VIN FROM CHAR(17) NOT NULL
GO
CREATE TYPE Udt.ColorName FROM VARCHAR(50) NOT NULL
GO
CREATE TYPE Udt.BodyStyleName FROM VARCHAR(50) NOT NULL
GO
CREATE TYPE Udt.EngineName FROM VARCHAR(50) NOT NULL
GO
CREATE TYPE Udt.TransmissionName FROM VARCHAR(50) NOT NULL
GO
CREATE TYPE Udt.FuelTypeName FROM VARCHAR(50) NOT NULL
GO
CREATE TYPE Udt.CostAmount FROM DECIMAL(10,2) NOT NULL
GO

--Now we create our tables that are shown on our ERD
--We have to create them in the following order so they won't cause issues as some fields depend on other fields

--Create our Sales Region and Country table under the ReferenceData domain
CREATE TABLE ReferenceData.SalesRegion(
	SalesRegionId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	SalesRegionName Udt.SalesRegionName UNIQUE NOT NULL
);

CREATE TABLE ReferenceData.Country(
	CountryId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	CountryName Udt.CountryName NOT NULL,
	CountryISO2 Udt.ISO2 NOT NULL,
	CountryISO3 Udt.ISO3 NOT NULL,
	SalesRegionId Udt.SurrogateKeyInt NOT NULL,
	FOREIGN KEY (SalesRegionId) REFERENCES ReferenceData.SalesRegion(SalesRegionId)
);

--Create Staff and Customer under our HumanResources domain
CREATE TABLE HumanResources.Customer(
	CustomerId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	FirstName Udt.PersonFirstName NOT NULL,
	LastName Udt.PersonLastName NOT NULL,
	Email Udt.EmailAddress NOT NULL,
	Phone Udt.PhoneNumber NOT NULL,
	AddressLine Udt.AddressLine NOT NULL,
	City Udt.CityName NOT NULL,
	PostalCode Udt.PostalCode NOT NULL,
	CountryId Udt.SurrogateKeyInt NOT NULL,
	FOREIGN KEY (CountryId) REFERENCES ReferenceData.Country(CountryId)
);

CREATE TABLE HumanResources.Staff(
	StaffId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	StaffName Udt.PersonFullName NOT NULL,
	ManagerId Udt.SurrogateKeyInt NULL,
	Department Udt.DepartmentName NOT NULL,
	HierarchyReference Udt.HierarchyReference NULL,
	FOREIGN KEY (ManagerId) REFERENCES HumanResources.Staff(StaffId)
);

-- Creating Production Information Make
CREATE TABLE ProductInformation.Make(
	MakeId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	MakeName Udt.MakeName UNIQUE
)
-- Creating Production Information Model
-- Added Not NUll for user readability but didn't really need it since the create type has it already

CREATE TABLE ProductInformation.Model(
	ModelId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	MakeId Udt.SurrogateKeyInt NOT NULL FOREIGN KEY REFERENCES ProductInformation.Make(MakeId),
	ModelName Udt.ModelName,
	ModelVariant Udt.ModelVariantName,
	YearFirstProduced Udt.YearInt NOT NULL,
	YearLastProduced Udt.YearInt NULL
)

-- Creatign ProductInformation.Vehicle
CREATE TABLE ProductInformation.Vehicle(
	VehicleId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	VIN Udt.VIN UNIQUE,
	ModelId Udt.SurrogateKeyInt NOT NULL FOREIGN KEY REFERENCES ProductInformation.Model(ModelId),
	ExteriorColor Udt.ColorName,
	InteriorColor UDt.ColorName,
	BodyStyle Udt.BodyStyleName,
	Engine Udt.EngineName,
	Transmission Udt.TransmissionName,
	FuelType Udt.FuelTypeName,
	ModelYear Udt.YearInt NOT NULL,
	Cost Udt.CostAmount,
	RepairsCost Udt.CostAmount,
	PartsCost Udt.CostAmount,
	TransportingCost Udt.CostAmount
);

-- Adding ReviewBit Column
-- Forgot to add it earlier
CREATE TYPE Udt.FlagBit FROM BIT NOT NULL

ALTER TABLE ProductInformation.Vehicle
ADD ReviewRow Udt.FlagBit CONSTRAINT Default_ProductInformation_ReviewRow_Vehicle DEFAULT(0)

--Create the SalesOrder and SalesOrderDetail under our Sales domain
CREATE TABLE Sales.SalesOrder(
	SalesOrderId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	StaffId Udt.SurrogateKeyInt NOT NULL,
	CustomerId Udt.SurrogateKeyInt NOT NULL,
	OrderDate DATE NOT NULL,
	InvoiceNumber Udt.InvoiceNumber UNIQUE NOT NULL,
	ReviewRow BIT NOT NULL,
	FOREIGN KEY (StaffId) REFERENCES HumanResources.Staff(StaffId),
	FOREIGN KEY (CustomerId) REFERENCES HumanResources.Customer(CustomerId)
);


CREATE TABLE Sales.SalesOrderDetail(
	SalesOrderDetailId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	SalesOrderId Udt.SurrogateKeyInt NOT NULL,
	VehicleId Udt.SurrogateKeyInt NOT NULL,
	LineItemNumber INT NOT NULL,
	SalePrice Udt.PriceAmount NOT NULL,
	DiscountPercent Udt.PercentValue NOT NULL,
	ReviewRow BIT NOT NULL,
	FOREIGN KEY (SalesOrderId) REFERENCES Sales.SalesOrder(SalesOrderId),
	FOREIGN KEY (VehicleId) REFERENCES ProductInformation.Vehicle(VehicleId)
);

--Create the WorkflowSteps 
CREATE TABLE Process.WorkflowSteps(
	StepId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	StepName VARCHAR(100) NOT NULL,
	StepDescription VARCHAR(255) NULL,
	StepOrder INT NOT NULL
);
GO
--Now that we created our tables, we are adding data

--We used data from the original PrestigeCars
--SalesRegion
INSERT INTO ReferenceData.SalesRegion (SalesRegionName) VALUES ('Asia');
INSERT INTO ReferenceData.SalesRegion (SalesRegionName) VALUES ('EMEA');
INSERT INTO ReferenceData.SalesRegion (SalesRegionName) VALUES ('North America');

--Country
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('Belgium', 'BE', 'BEL', 2);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('France', 'FR', 'FRA', 2);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('Germany', 'DE', 'DEU', 2);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('Italy', 'IT', 'ITA', 2);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('Spain', 'ES', 'ESP', 2);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('United Kingdom', 'GB', 'GBR', 2);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('United States', 'US', 'USA', 3);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('China', 'CN', 'CHN', 1);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('India', 'IN', 'IND', 1);
INSERT INTO ReferenceData.Country (CountryName, CountryISO2, CountryISO3, SalesRegionId) VALUES ('Switzerland', 'CH', 'CHE', 2);

--Staff
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Amelia', NULL, 'Executive', 1);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Gerard', 1, 'Finance', 2);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Chloe', 1, 'Marketing', 2);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Susan', 1, 'Sales', 2);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Andy', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Steve', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Stan', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Nathan', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Maggie', 4, 'Sales', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Jenny', 2, 'Finance', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Chris', 2, 'Finance', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Megan', 3, 'Marketing', 3);
INSERT INTO HumanResources.Staff (StaffName, ManagerId, Department, HierarchyReference) VALUES ('Sandy', 11, 'Finance', 4);

--Customer
INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Pierre', 'Dubois', 'pierred@gmail.com', '347-123-1234', '14, Rue De La Hutte', 'Marseille', '13001', 2);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Sondra', 'Horowitz', 'sondrah@gmail.com', '347-123-1235', '10040 Great Western Road', 'Los Angeles', '90001', 7);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Alexei', 'Tolstoi', 'alexeit@gmail.com', '347-123-1236', '83, Abbey Road', 'London', 'N4 2CV', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Theo', 'Kowalski', 'theok@gmail.com', '347-123-1237', '1000 East 51st Street', 'New York', '11203', 7);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Peter', 'McLuckie', 'peterm@gmail.com', '347-123-1238', '73, Entwhistle Street', 'London', 'W10 BN', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Jason', 'Wight', 'jasonw@gmail.com', '347-123-1239', '5300 Star Boulevard', 'Washington', '99333', 7);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Peter', 'Smith', 'peters@gmail.com', '347-123-1240', '82, Ell Pie Lane', 'Birmingham', 'B5 5SD', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Ivana', 'Telford', 'ivanat@gmail.com', '347-123-1241', '52, Gerrard Mansions', 'Liverpool', 'L2 9RT', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Kieran', 'O''Harris', 'kierano@gmail.com', '347-123-1242', '71, Askwith Ave', 'Liverpool', 'L7 6OP', 6);

INSERT INTO HumanResources.Customer (FirstName, LastName, Email, Phone, AddressLine, City, PostalCode, CountryId) 
VALUES ('Laurence', 'Saint Yves', 'laurences@gmail.com', '347-123-1243', '49, Rue Quicampoix', 'Marseille', '13001', 2);

/*


Bryan's INSERT GOES HERE


*/


--SalesOrder
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 1, '2015-04-06', 'EURFR009', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 2, '2015-04-04', 'USDUS010', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 3, '2015-02-03', 'GBPGB003', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (5, 5, '2015-03-14', 'GBPGB018', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (6, 4, '2015-02-16', 'USDUS011', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (6, 6, '2015-01-25', 'USDUS012', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (7, 7, '2015-03-24', 'GBPGB019', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (7, 8, '2015-03-30', 'GBPGB020', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (8, 9, '2015-01-02', 'GBPGB021', 0);
INSERT INTO Sales.SalesOrder (StaffId, CustomerId, OrderDate, InvoiceNumber, ReviewRow) VALUES (9, 10, '2015-02-20', 'EURFR016', 0);


/*
--SalesOrderDetail
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (1, 1, 1, 65000.00, 4.15, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (2, 2, 1, 220000.00, 27.27, 1);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (3, 3, 1, 19500.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (4, 4, 1, 11500.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (5, 5, 1, 19950.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (6, 6, 1, 29500.00, 4.24, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (7, 7, 1, 49500.00, 4.95, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (8, 8, 1, 76000.00, 7.24, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (9, 9, 1, 19600.00, 0.00, 0);
INSERT INTO Sales.SalesOrderDetail (SalesOrderId, VehicleId, LineItemNumber, SalePrice, LineItemDiscount, ReviewRow) VALUES (10, 10, 1, 36500.00, 6.85, 0);

*/
GO

--Final thing is creating our ITVFs
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
GO

--Find the people under a specific department
CREATE FUNCTION HumanResources.GetStaffByDepartment
(
    @DepartmentName VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT StaffId,StaffName,Department
    FROM HumanResources.Staff
    WHERE Department = @DepartmentName
);
GO

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
GO

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
GO

-- Function Brings up the top 5 highest expensive repair cost models

CREATE FUNCTION ProductInformation.FindingHighestRepairCostEnginePerModelYear(@ModelYearCar Udt.YearInt)
Returns Table
AS
Return
(
	Select TOP 5 VehicleId,Engine, RepairsCost
	From ProductInformation.Vehicle
	Where ModelYear >= @ModelYearCar
	Order By RepairsCost Desc
);
GO

-- Function brings important information per the year of the models

CREATE FUNCTION ProductInformation.VehicleInventoryYear(@Year Udt.YearInt)
Returns Table
AS
Return
(
	Select
	V.vin,
	MA.MakeName,
	MO.ModelName,
	V.ModelYear,
	V.ExteriorColor,
	V.BodyStyle,
	V.Transmission,
	(V.Cost + V.PartsCost + V.TransportingCost + V.RepairsCost) AS TotalEstimatedCost
	From
		ProductInformation.Vehicle AS V
		Inner Join ProductInformation.Model AS MO
			ON V.ModelId = MO.ModelId
		Inner Join ProductInformation.Make AS MA
			ON MO.MakeId = MA.MakeId
	Where
		V.ModelYear = @Year
);