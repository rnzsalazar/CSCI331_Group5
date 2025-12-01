USE [PrestigeCars_Project3];
GO

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