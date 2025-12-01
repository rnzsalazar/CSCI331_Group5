USE [PrestigeCars_Project3];
GO
--Find the people under a specific department
CREATE FUNCTION HumanResources.GetStaffByDepartment
(
    @DepartmentName VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT StaffId,StaffName,Department
    FROM HumanResources.Staff
    WHERE Department = @DepartmentName
);