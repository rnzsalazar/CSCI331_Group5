

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
	)


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
)