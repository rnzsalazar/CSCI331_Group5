USE [PrestigeCars_Project3];
GO

CREATE TABLE Process.WorkflowSteps(
	StepId Udt.SurrogateKeyInt IDENTITY(1,1) PRIMARY KEY,
	StepName VARCHAR(100) NOT NULL,
	StepDescription VARCHAR(255) NULL,
	StepOrder INT NOT NULL
);