USE [PrestigeCars_Project3];
GO

CREATE TABLE HumanResources.Staff(
	StaffId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	StaffName Udt.PersonFullName NOT NULL,
	ManagerId Udt.SurrogateKeyInt NULL,
	Department Udt.DepartmentName NOT NULL,
	HierarchyReference Udt.HierarchyReference NULL,
	FOREIGN KEY (ManagerId) REFERENCES HumanResources.Staff(StaffId)
);