USE [PrestigeCars_Project3];
GO

CREATE TABLE ReferenceData.Country(
	CountryId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	CountryName Udt.CountryName NOT NULL,
	CountryISO2 Udt.ISO2 NOT NULL,
	CountryISO3 Udt.ISO3 NOT NULL,
	SalesRegionId Udt.SurrogateKeyInt NOT NULL,
	FOREIGN KEY (SalesRegionId) REFERENCES ReferenceData.SalesRegion(SalesRegionId)
);

