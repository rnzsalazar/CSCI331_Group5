USE PrestigeCars_Project3;
GO

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