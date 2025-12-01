Use PrestigeCars_Project3


--Creating Udts
-- Note: Udt.SurrogateKeyInt, Udt.YearInt are used in multiple tables

-- Udt for Production.Make
CREATE TYPE Udt.SurrogateKeyInt FROM INT NOT NULL 
CREATE TYPE Udt.MakeName FROM VARCHAR(50) NOT NULL

-- Udt For ProducInformation.Model

CREATE TYPE Udt.ModelName FROM VARCHAR(100) NOT NULL
CREATE TYPE Udt.ModelVariantName FROM VARCHAR(50) NULL
CREATE TYPE Udt.YearInt From INT NULL

-- Udt For ProductInformation.Vehicle

CREATE TYPE Udt.VIN FROM CHAR(17) NOT NULL
CREATE TYPE Udt.ColorName FROM VARCHAR(50) NOT NULL
CREATE TYPE Udt.BodyStyleName FROM VARCHAR(50) NOT NULL
CREATE TYPE Udt.EngineName FROM VARCHAR(50) NOT NULL
CREATE TYPE Udt.TransmissionName FROM VARCHAR(50) NOT NULL
CREATE TYPE Udt.FuelTypeName FROM VARCHAR(50) NOT NULL
CREATE TYPE Udt.CostAmount FROM DECIMAL(10,2) NOT NULL