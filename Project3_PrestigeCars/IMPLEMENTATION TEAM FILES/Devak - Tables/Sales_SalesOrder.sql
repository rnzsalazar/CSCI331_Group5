USE [PrestigeCars_Project3];
GO

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