USE [PrestigeCars_Project3];
GO

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