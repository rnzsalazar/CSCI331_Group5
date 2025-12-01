Use PrestigeCars_Project3
Go


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

