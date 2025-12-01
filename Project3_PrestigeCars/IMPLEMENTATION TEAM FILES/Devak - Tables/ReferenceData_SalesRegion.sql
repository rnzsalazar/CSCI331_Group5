USE [PrestigeCars_Project3];
GO

CREATE TABLE ReferenceData.SalesRegion(
	SalesRegionId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	SalesRegionName Udt.SalesRegionName UNIQUE NOT NULL
);