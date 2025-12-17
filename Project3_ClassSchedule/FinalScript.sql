/* =========================================================
  PROJECT 3 – BASE DATABASE + TABLE DEFINITIONS
  Compatible with STORED PROCEDURE LOADER
  ========================================================= */




SET NOCOUNT ON;
SET XACT_ABORT ON;
GO




/* ---------- Recreate Database ---------- */
IF DB_ID(N'ClassSchedule') IS NOT NULL
BEGIN
   ALTER DATABASE ClassSchedule SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE ClassSchedule;
END
GO




CREATE DATABASE ClassSchedule;
GO
USE ClassSchedule;
GO




/* ---------- Schemas ---------- */
CREATE SCHEMA Uploadfile;
GO
CREATE SCHEMA Faculty;
GO
CREATE SCHEMA CollegeCatalog;
GO
CREATE SCHEMA Campus;
GO
CREATE SCHEMA ClassSession;
GO
CREATE SCHEMA DbSecurity;
GO
CREATE SCHEMA Process;
GO




/* =========================================================
  STAGING TABLE (SOURCE – BAK EQUIVALENT)
  ========================================================= */




CREATE TABLE Uploadfile.CurrentSemesterCourseOfferings
(
   Semester               VARCHAR(50),
   Sec                    VARCHAR(50),
   Code                   VARCHAR(50),
   [Course (hr, crd)]     VARCHAR(50),
   Description            VARCHAR(100),
   [Day]                  VARCHAR(50),
   [Time]                 VARCHAR(50),
   Instructor             VARCHAR(100),
   Location               VARCHAR(50),
   Enrolled               VARCHAR(50),
   [Limit]                VARCHAR(50),
   [Mode of Instruction]  VARCHAR(50)
);
GO




/* =========================================================
  SECURITY
  ========================================================= */




CREATE TABLE DbSecurity.UserAuthorization
(
   UserAuthorizationKey INT NOT NULL
       CONSTRAINT PK_UserAuthorization PRIMARY KEY,




   IndividualProject    VARCHAR(20)  NOT NULL
       CONSTRAINT DF_UserAuth_Project DEFAULT ('PROJECT 3'),




   GroupName            VARCHAR(20)  NOT NULL
       CONSTRAINT DF_UserAuth_Group DEFAULT ('Group #5'),




   GroupMemberLastName  NVARCHAR(50) NOT NULL,
   GroupMemberFirstName NVARCHAR(50) NOT NULL,




   ClassTime            CHAR(5)      NOT NULL
       CONSTRAINT DF_UserAuth_ClassTime DEFAULT ('10:45'),




   DateAdded            DATETIME2(7) NOT NULL
       CONSTRAINT DF_UserAuth_DateAdded DEFAULT (SYSDATETIME())
);
GO




INSERT INTO DbSecurity.UserAuthorization
(
   UserAuthorizationKey,
   IndividualProject,
   GroupName,
   GroupMemberLastName,
   GroupMemberFirstName,
   ClassTime,
   DateAdded
)
VALUES
(1, 'PROJECT 3', 'Group #5', 'Islam',     'Nadia',     '10:45', SYSDATETIME()),
(2, 'PROJECT 3', 'Group #5', 'Cueva',     'Renzo',     '10:45', SYSDATETIME()),
(3, 'PROJECT 3', 'Group #5', 'Sanchez',   'Bryan',     '10:45', SYSDATETIME()),
(4, 'PROJECT 3', 'Group #5', 'Lynn',      'Htoo',      '10:45', SYSDATETIME()),
(5, 'PROJECT 3', 'Group #5', 'Bulatao',   'Alexander', '10:45', SYSDATETIME()),
(6, 'PROJECT 3', 'Group #5', 'Mehta',     'Devak',     '10:45', SYSDATETIME());
GO








/* =========================================================
  CORE ENTITIES
  ========================================================= */




CREATE TABLE Faculty.Instructor
(
   InstructorId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Instructor PRIMARY KEY,
   InstructorName NVARCHAR(100) NOT NULL,
   UserAuthorizationKey INT NOT NULL,
   DateAdded DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
   DateOfLastUpdate DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
   CONSTRAINT FK_Instructor_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE CollegeCatalog.Department
(
   DepartmentId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Department PRIMARY KEY,
   DepartmentCode NVARCHAR(60) NOT NULL,
   UserAuthorizationKey INT NOT NULL,
   DateAdded DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
   DateOfLastUpdate DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
   CONSTRAINT UQ_Department UNIQUE (DepartmentCode),
   CONSTRAINT FK_Department_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE CollegeCatalog.Course
(
   CourseId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Course PRIMARY KEY,
   DepartmentId INT NOT NULL,
   CourseCode NVARCHAR(60) NOT NULL,
   CourseDescription NVARCHAR(400) NULL,
   UserAuthorizationKey INT NOT NULL,
   DateAdded DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
   DateOfLastUpdate DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
   CONSTRAINT UQ_Course UNIQUE (CourseCode),
   CONSTRAINT FK_Course_Department
       FOREIGN KEY (DepartmentId)
       REFERENCES CollegeCatalog.Department(DepartmentId),
   CONSTRAINT FK_Course_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE CollegeCatalog.Semester
(
   SemesterId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Semester PRIMARY KEY,
   SemesterName VARCHAR(50) NOT NULL,
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT UQ_Semester UNIQUE (SemesterName),
   CONSTRAINT FK_Semester_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE ClassSession.ModeOfInstruction
(
   ModeOfInstructionId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_MOI PRIMARY KEY,
   ModeOfInstructionName NVARCHAR(50) NOT NULL,
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT UQ_MOI UNIQUE (ModeOfInstructionName),
   CONSTRAINT FK_MOI_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE ClassSession.Schedule
(
   ScheduleId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Schedule PRIMARY KEY,
   Days NVARCHAR(25) NULL,
   [Time] NVARCHAR(50) NULL,
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT UQ_Schedule UNIQUE (Days, [Time]),
   CONSTRAINT FK_Schedule_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE Campus.Location
(
   LocationId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Location PRIMARY KEY,
   LocationCode NVARCHAR(100) NOT NULL,
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT UQ_Location UNIQUE (LocationCode),
   CONSTRAINT FK_Location_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE Campus.ClassroomLocation
(
   ClassroomLocationId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Classroom PRIMARY KEY,
   ClassroomCode INT NULL,
   LocationId INT NOT NULL,
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT UQ_Classroom UNIQUE (LocationId, ClassroomCode),
   CONSTRAINT FK_Classroom_Location
       FOREIGN KEY (LocationId)
       REFERENCES Campus.Location(LocationId),
   CONSTRAINT FK_Classroom_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE Faculty.InstructorDepartment
(
   InstructorId         INT NOT NULL,
   DepartmentId         INT NOT NULL,
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT PK_InstructorDepartment PRIMARY KEY (InstructorId, DepartmentId),
   CONSTRAINT FK_ID_Instructor
       FOREIGN KEY (InstructorId)
       REFERENCES Faculty.Instructor(InstructorId),
   CONSTRAINT FK_ID_Department
       FOREIGN KEY (DepartmentId)
       REFERENCES CollegeCatalog.Department(DepartmentId),
   CONSTRAINT FK_ID_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO




CREATE TABLE ClassSession.Class
(
   ClassId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Class PRIMARY KEY,
   SemesterId INT NOT NULL,
   CourseId INT NOT NULL,
   InstructorId INT NOT NULL,
   ScheduleId INT NOT NULL,
   LocationId INT NOT NULL,
   ModeOfInstructionId INT NOT NULL,
   SectionCode NVARCHAR(25) NOT NULL,
   Enrollment INT NULL,
   EnrollmentLimit INT NULL,
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT FK_Class_Semester
       FOREIGN KEY (SemesterId) REFERENCES CollegeCatalog.Semester(SemesterId),
   CONSTRAINT FK_Class_Course
       FOREIGN KEY (CourseId) REFERENCES CollegeCatalog.Course(CourseId),
   CONSTRAINT FK_Class_Instructor
       FOREIGN KEY (InstructorId) REFERENCES Faculty.Instructor(InstructorId),
   CONSTRAINT FK_Class_Schedule
       FOREIGN KEY (ScheduleId) REFERENCES ClassSession.Schedule(ScheduleId),
   CONSTRAINT FK_Class_Location
       FOREIGN KEY (LocationId) REFERENCES Campus.Location(LocationId),
   CONSTRAINT FK_Class_MOI
       FOREIGN KEY (ModeOfInstructionId) REFERENCES ClassSession.ModeOfInstruction(ModeOfInstructionId),
   CONSTRAINT FK_Class_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE TABLE Process.WorkflowSteps
(
   WorkflowStepId INT IDENTITY(1,1) NOT NULL
       CONSTRAINT PK_Workflow PRIMARY KEY,
   WorkflowStepDescription NVARCHAR(200) NOT NULL,
   TableRowCount INT NULL,
   StartTime DATETIME2(7) NULL DEFAULT SYSDATETIME(),
   EndTime DATETIME2(7) NULL DEFAULT SYSDATETIME(),
   UserAuthorizationKey INT NOT NULL,
   CONSTRAINT FK_Workflow_UA
       FOREIGN KEY (UserAuthorizationKey)
       REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO












STORE PROCEDURES:
USE [ClassSchedule];
GO
SET NOCOUNT ON;
GO




/* =========================================================
  PROJECT 3 – STORED PROC LOADER (DOCUMENTED + DELEGATED)
  Authors split evenly across:
    Nadia Islam, Htoo Lynn, Alexander Bulatao




  FIX:
  - All loaders now stamp UserAuthorizationKey using @UserAuthorizationKey.
  - Master loader assigns different users per stage (Nadia=1, Htoo=2, Alexander=5).
  - You can change the 3 IDs in ONE place inside usp_LoadAllProductionTables.




  Source table:
    [QueensClassScheduleThisCurrentSemester].[Uploadfile].[CurrentSemesterCourseOfferings]
  ========================================================= */




----------------------------------------------------------------
-- 0) SOURCE WRAPPER TVF (matches YOUR Uploadfile column names)
----------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Group5')
   EXEC ('CREATE SCHEMA Group5');
GO




CREATE OR ALTER FUNCTION Group5.tvf_SourceOfferings()
RETURNS TABLE
AS
RETURN
(
   SELECT
       LTRIM(RTRIM([Semester]))                     AS SemesterName,
       LTRIM(RTRIM([Sec]))                          AS SectionCode,
       TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM([Code])) ,'')) AS ClassCode,




       LTRIM(RTRIM([Course (hr, crd)]))             AS CourseRaw,
       LTRIM(RTRIM([Description]))                  AS CourseDescription,




       LTRIM(RTRIM([Day]))                          AS Days,
       LTRIM(RTRIM([Time]))                         AS [Time],




       LTRIM(RTRIM([Instructor]))                   AS InstructorName,
       LTRIM(RTRIM([Location]))                     AS LocationCode,




       TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM([Enrolled])) ,'')) AS Enrollment,
       TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM([Limit]))    ,'')) AS EnrollmentLimit,




       LTRIM(RTRIM([Mode of Instruction]))          AS ModeOfInstructionName
   FROM [QueensClassScheduleThisCurrentSemester].[Uploadfile].[CurrentSemesterCourseOfferings]
);
GO








/* =========================================================
  NADIA ISLAM – Workflow procedures + FK toggle procedures
  ========================================================= */




-- =============================================
-- Author: Nadia Islam
-- Procedure: Process.usp_TrackWorkFlow
-- Create date: 2025-12-16
-- Description: Inserts a workflow audit record into Process.WorkflowSteps.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_TrackWorkFlow
   @WorkFlowDescription  VARCHAR(100),
   @TableRowCount        INT            = NULL,
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @NextId INT =
       ISNULL((SELECT MAX(WorkflowStepId) FROM Process.WorkflowSteps), 0) + 1;




   INSERT INTO Process.WorkflowSteps
   (
       WorkflowStepId,
       WorkflowStepDescription,
       TableRowCount,
       StartTime,
       EndTime,
       UserAuthorizationKey
   )
   VALUES
   (
       @NextId,
       @WorkFlowDescription,
       @TableRowCount,
       SYSDATETIME(),
       SYSDATETIME(),
       @UserAuthorizationKey
   );
END;
GO




-- =============================================
-- Author: Nadia Islam
-- Procedure: Process.usp_ShowWorkflowSteps
-- Create date: 2025-12-16
-- Description: Displays Process.WorkflowSteps in WorkflowStepId order.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_ShowWorkflowSteps
AS
BEGIN
   SET NOCOUNT ON;




   SELECT
       WorkflowStepId,
       WorkflowStepDescription,
       TableRowCount,
       StartTime,
       EndTime,
       UserAuthorizationKey
   FROM Process.WorkflowSteps
   ORDER BY WorkflowStepId;
END;
GO




-- =============================================
-- Author: Nadia Islam
-- Procedure: Process.usp_DropForeignKeys
-- Create date: 2025-12-16
-- Description: Disables (NOCHECK) all foreign key constraints.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_DropForeignKeys
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @sql NVARCHAR(MAX) = N'';




   SELECT @sql = @sql + N'
ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name) +
N' NOCHECK CONSTRAINT ' + QUOTENAME(fk.name) + N';'
   FROM sys.foreign_keys fk
   JOIN sys.tables t ON fk.parent_object_id = t.object_id;




   IF @sql <> N'' EXEC sys.sp_executesql @sql;
END;
GO




-- =============================================
-- Author: Nadia Islam
-- Procedure: Process.usp_AddForeignKeys
-- Create date: 2025-12-16
-- Description: Re-enables all foreign key constraints (WITH CHECK CHECK).
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_AddForeignKeys
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @sql NVARCHAR(MAX) = N'';




   SELECT @sql = @sql + N'
ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name) +
N' WITH CHECK CHECK CONSTRAINT ' + QUOTENAME(fk.name) + N';'
   FROM sys.foreign_keys fk
   JOIN sys.tables t ON fk.parent_object_id = t.object_id;




   IF @sql <> N'' EXEC sys.sp_executesql @sql;
END;
GO








/* =========================================================
  HTOO LYNN – Truncate + lookup/parent table loaders
  ========================================================= */




-- =============================================
-- Author: Htoo Lynn
-- Procedure: Process.usp_TruncateTables
-- Create date: 2025-12-16
-- Description: Deletes rows from production tables in FK-safe order.
--              Optionally keeps Process.WorkflowSteps when @KeepWorkflow=1.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_TruncateTables
   @KeepWorkflow BIT = 0
AS
BEGIN
   SET NOCOUNT ON;




   DELETE FROM Faculty.InstructorDepartment;
   DELETE FROM ClassSession.Class;
   DELETE FROM Campus.ClassroomLocation;




   DELETE FROM ClassSession.Schedule;
   DELETE FROM Campus.Location;




   DELETE FROM CollegeCatalog.Course;
   DELETE FROM CollegeCatalog.Department;




   DELETE FROM Faculty.Instructor;




   DELETE FROM ClassSession.ModeOfInstruction;
   DELETE FROM CollegeCatalog.Semester;




   IF @KeepWorkflow = 0
       DELETE FROM Process.WorkflowSteps;
END;
GO




-- =============================================
-- Author: Htoo Lynn
-- Procedure: Process.usp_LoadSemester
-- Create date: 2025-12-16
-- Description: Loads distinct SemesterName values from source into Semester.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadSemester
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH src AS
   (
       SELECT DISTINCT
           SemesterName = COALESCE(NULLIF(LTRIM(RTRIM(SemesterName)), ''), 'Unknown')
       FROM Group5.tvf_SourceOfferings()
   )
   INSERT INTO CollegeCatalog.Semester (SemesterName, UserAuthorizationKey)
   SELECT s.SemesterName, @UserAuthorizationKey
   FROM src s
   WHERE NOT EXISTS
   (
       SELECT 1
       FROM CollegeCatalog.Semester sem
       WHERE sem.SemesterName = s.SemesterName
   );




   EXEC Process.usp_TrackWorkFlow 'Load Semester', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Htoo Lynn
-- Procedure: Process.usp_LoadModeOfInstruction
-- Create date: 2025-12-16
-- Description: Loads distinct ModeOfInstructionName values from source into MOI.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadModeOfInstruction
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH src AS
   (
       SELECT DISTINCT
           MOI = COALESCE(NULLIF(LTRIM(RTRIM(ModeOfInstructionName)), ''), 'Unknown')
       FROM Group5.tvf_SourceOfferings()
   )
   INSERT INTO ClassSession.ModeOfInstruction (ModeOfInstructionName, UserAuthorizationKey)
   SELECT s.MOI, @UserAuthorizationKey
   FROM src s
   WHERE NOT EXISTS
   (
       SELECT 1
       FROM ClassSession.ModeOfInstruction m
       WHERE m.ModeOfInstructionName = s.MOI
   );




   EXEC Process.usp_TrackWorkFlow 'Load ModeOfInstruction', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Htoo Lynn
-- Procedure: Process.usp_LoadLocation
-- Create date: 2025-12-16
-- Description: Loads distinct LocationCode values from source into Location.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadLocation
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH src AS
   (
       SELECT DISTINCT
           LocationCode = NULLIF(LTRIM(RTRIM(LocationCode)), '')
       FROM Group5.tvf_SourceOfferings()
       WHERE LocationCode IS NOT NULL AND LTRIM(RTRIM(LocationCode)) <> ''
   )
   INSERT INTO Campus.Location (LocationCode, UserAuthorizationKey)
   SELECT s.LocationCode, @UserAuthorizationKey
   FROM src s
   WHERE NOT EXISTS
   (
       SELECT 1
       FROM Campus.Location l
       WHERE l.LocationCode = s.LocationCode
   );




   EXEC Process.usp_TrackWorkFlow 'Load Location', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Htoo Lynn
-- Procedure: Process.usp_LoadSchedule
-- Create date: 2025-12-16
-- Description: Loads distinct (Days, Time) into ClassSession.Schedule.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadSchedule
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH src AS
   (
       SELECT DISTINCT
           DaysVal = COALESCE(NULLIF(LTRIM(RTRIM(Days)), ''), 'TBD'),
           TimeVal = COALESCE(NULLIF(LTRIM(RTRIM([Time])), ''), 'TBD')
       FROM Group5.tvf_SourceOfferings()
   )
   INSERT INTO ClassSession.Schedule (Days, [Time], UserAuthorizationKey)
   SELECT s.DaysVal, s.TimeVal, @UserAuthorizationKey
   FROM src s
   WHERE NOT EXISTS
   (
       SELECT 1
       FROM ClassSession.Schedule sch
       WHERE sch.Days = s.DaysVal
         AND sch.[Time] = s.TimeVal
   );




   EXEC Process.usp_TrackWorkFlow 'Load Schedule', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO








/* =========================================================
  ALEXANDER BULATAO – Core entity loaders + master loader
  ========================================================= */




-- =============================================
-- Author: Alexander Bulatao
-- Procedure: Process.usp_LoadDepartment
-- Create date: 2025-12-16
-- Description: Loads DepartmentCode as prefix of CourseRaw.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadDepartment
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH src AS
   (
       SELECT DISTINCT
           DeptCode =
               LEFT(
                   LTRIM(RTRIM(CourseRaw)),
                   CHARINDEX(' ', LTRIM(RTRIM(CourseRaw)) + ' ') - 1
               )
       FROM Group5.tvf_SourceOfferings()
       WHERE CourseRaw IS NOT NULL AND LTRIM(RTRIM(CourseRaw)) <> ''
   )
   INSERT INTO CollegeCatalog.Department (DepartmentCode, UserAuthorizationKey)
   SELECT s.DeptCode, @UserAuthorizationKey
   FROM src s
   WHERE s.DeptCode IS NOT NULL AND s.DeptCode <> ''
     AND NOT EXISTS
     (
         SELECT 1
         FROM CollegeCatalog.Department d
         WHERE d.DepartmentCode = s.DeptCode
     );




   EXEC Process.usp_TrackWorkFlow 'Load Department', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Alexander Bulatao
-- Procedure: Process.usp_LoadInstructor
-- Create date: 2025-12-16
-- Description: Loads distinct InstructorName values into Faculty.Instructor.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadInstructor
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH src AS
   (
       SELECT DISTINCT
           InstructorName = NULLIF(LTRIM(RTRIM(InstructorName)), '')
       FROM Group5.tvf_SourceOfferings()
       WHERE InstructorName IS NOT NULL AND LTRIM(RTRIM(InstructorName)) <> ''
   )
   INSERT INTO Faculty.Instructor (InstructorName, UserAuthorizationKey)
   SELECT s.InstructorName, @UserAuthorizationKey
   FROM src s
   WHERE NOT EXISTS
   (
       SELECT 1
       FROM Faculty.Instructor i
       WHERE i.InstructorName = s.InstructorName
   );




   EXEC Process.usp_TrackWorkFlow 'Load Instructor', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Alexander Bulatao
-- Procedure: Process.usp_LoadCourse
-- Create date: 2025-12-16
-- Description: Loads Course from CourseRaw (cleaned) and joins DepartmentId.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadCourse
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH s AS
   (
       SELECT DISTINCT
           CourseClean =
               LTRIM(RTRIM(
                   CASE
                       WHEN CHARINDEX('(', CourseRaw) > 0
                           THEN LEFT(CourseRaw, CHARINDEX('(', CourseRaw) - 1)
                       ELSE CourseRaw
                   END
               )),
           CourseDescription = NULLIF(LTRIM(RTRIM(CourseDescription)), '')
       FROM Group5.tvf_SourceOfferings()
       WHERE CourseRaw IS NOT NULL AND LTRIM(RTRIM(CourseRaw)) <> ''
   ),
   x AS
   (
       SELECT
           DeptCode = LEFT(CourseClean, CHARINDEX(' ', CourseClean + ' ') - 1),
           CourseCode = CourseClean,
           CourseDescription
       FROM s
       WHERE CHARINDEX(' ', CourseClean) > 0
   )
   INSERT INTO CollegeCatalog.Course (DepartmentId, CourseCode, CourseDescription, UserAuthorizationKey)
   SELECT
       d.DepartmentId,
       x.CourseCode,
       x.CourseDescription,
       @UserAuthorizationKey
   FROM x
   JOIN CollegeCatalog.Department d
     ON d.DepartmentCode = x.DeptCode
   WHERE NOT EXISTS
   (
       SELECT 1
       FROM CollegeCatalog.Course c
       WHERE c.CourseCode = x.CourseCode
   );




   EXEC Process.usp_TrackWorkFlow 'Load Course', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Alexander Bulatao
-- Procedure: Process.usp_LoadInstructorDepartment
-- Create date: 2025-12-16
-- Description: Loads bridge Faculty.InstructorDepartment.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadInstructorDepartment
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH src AS
   (
       SELECT DISTINCT
           InstructorName = NULLIF(LTRIM(RTRIM(InstructorName)), ''),
           DeptCode =
               LEFT(
                   LTRIM(RTRIM(CourseRaw)),
                   CHARINDEX(' ', LTRIM(RTRIM(CourseRaw)) + ' ') - 1
               )
       FROM Group5.tvf_SourceOfferings()
       WHERE CourseRaw IS NOT NULL AND LTRIM(RTRIM(CourseRaw)) <> ''
         AND InstructorName IS NOT NULL AND LTRIM(RTRIM(InstructorName)) <> ''
   )
   INSERT INTO Faculty.InstructorDepartment (InstructorId, DepartmentId, UserAuthorizationKey)
   SELECT DISTINCT
       i.InstructorId,
       d.DepartmentId,
       @UserAuthorizationKey
   FROM src s
   JOIN Faculty.Instructor i
     ON i.InstructorName = s.InstructorName
   JOIN CollegeCatalog.Department d
     ON d.DepartmentCode = s.DeptCode
   WHERE NOT EXISTS
   (
       SELECT 1
       FROM Faculty.InstructorDepartment id
       WHERE id.InstructorId = i.InstructorId
         AND id.DepartmentId = d.DepartmentId
   );




   EXEC Process.usp_TrackWorkFlow 'Load InstructorDepartment', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Alexander Bulatao
-- Procedure: Process.usp_LoadClassroomLocation
-- Create date: 2025-12-16
-- Description: Loads Campus.ClassroomLocation by parsing digits from LocationCode.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadClassroomLocation
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH loc AS
   (
       SELECT DISTINCT
           LocationCode = NULLIF(LTRIM(RTRIM(LocationCode)), '')
       FROM Group5.tvf_SourceOfferings()
       WHERE LocationCode IS NOT NULL AND LTRIM(RTRIM(LocationCode)) <> ''
   ),
   joined AS
   (
       SELECT
           l.LocationId,
           l.LocationCode,
           FirstDigitPos = NULLIF(PATINDEX('%[0-9]%', l.LocationCode), 0)
       FROM loc s
       JOIN Campus.Location l
         ON l.LocationCode = s.LocationCode
   ),
   parsed AS
   (
       SELECT
           LocationId,
           ClassroomCode =
               CASE
                   WHEN FirstDigitPos IS NULL THEN NULL
                   ELSE LTRIM(RTRIM(
                       LEFT(
                           SUBSTRING(LocationCode, FirstDigitPos, 25),
                           PATINDEX('%[^0-9]%', SUBSTRING(LocationCode, FirstDigitPos, 25) + 'X') - 1
                       )
                   ))
               END
       FROM joined
   )
   INSERT INTO Campus.ClassroomLocation (ClassroomCode, LocationId, UserAuthorizationKey)
   SELECT DISTINCT
       p.ClassroomCode,
       p.LocationId,
       @UserAuthorizationKey
   FROM parsed p
   WHERE p.ClassroomCode IS NOT NULL AND p.ClassroomCode <> ''
     AND NOT EXISTS
     (
         SELECT 1
         FROM Campus.ClassroomLocation cl
         WHERE cl.LocationId = p.LocationId
           AND cl.ClassroomCode = p.ClassroomCode
     );




   EXEC Process.usp_TrackWorkFlow 'Load ClassroomLocation', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Alexander Bulatao
-- Procedure: Process.usp_LoadClass
-- Create date: 2025-12-16
-- Description: Loads ClassSession.Class by resolving FK IDs.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadClass
   @UserAuthorizationKey INT
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @t DATETIME = GETDATE();




   ;WITH s AS
   (
       SELECT
           SemesterName   = NULLIF(LTRIM(RTRIM(SemesterName)), ''),
           CourseClean    =
               LTRIM(RTRIM(
                   CASE
                       WHEN CHARINDEX('(', CourseRaw) > 0
                           THEN LEFT(CourseRaw, CHARINDEX('(', CourseRaw) - 1)
                       ELSE CourseRaw
                   END
               )),
           InstructorName = NULLIF(LTRIM(RTRIM(InstructorName)), ''),
           DaysVal        = COALESCE(NULLIF(LTRIM(RTRIM(Days)), ''), 'TBD'),
           TimeVal        = COALESCE(NULLIF(LTRIM(RTRIM([Time])), ''), 'TBD'),
           LocationCode   = NULLIF(LTRIM(RTRIM(LocationCode)), ''),
           MOI            = COALESCE(NULLIF(LTRIM(RTRIM(ModeOfInstructionName)), ''), 'Unknown'),
           SectionCode    = NULLIF(LTRIM(RTRIM(SectionCode)), ''),
           Enrollment     = Enrollment,
           EnrollmentLimit= EnrollmentLimit
       FROM Group5.tvf_SourceOfferings()
   )
   INSERT INTO ClassSession.Class
   (
       SemesterId,
       CourseId,
       InstructorId,
       ScheduleId,
       LocationId,
       ModeOfInstructionId,
       SectionCode,
       Enrollment,
       EnrollmentLimit,
       UserAuthorizationKey
   )
   SELECT
       sem.SemesterId,
       c.CourseId,
       i.InstructorId,
       sch.ScheduleId,
       loc.LocationId,
       moi.ModeOfInstructionId,
       s.SectionCode,
       s.Enrollment,
       s.EnrollmentLimit,
       @UserAuthorizationKey
   FROM s
   JOIN CollegeCatalog.Semester sem
     ON sem.SemesterName = COALESCE(s.SemesterName, 'Unknown')
   JOIN CollegeCatalog.Course c
     ON c.CourseCode = s.CourseClean
   LEFT JOIN Faculty.Instructor i
     ON i.InstructorName = s.InstructorName
   JOIN ClassSession.Schedule sch
     ON sch.Days = s.DaysVal
    AND sch.[Time] = s.TimeVal
   JOIN Campus.Location loc
     ON loc.LocationCode = s.LocationCode
   JOIN ClassSession.ModeOfInstruction moi
     ON moi.ModeOfInstructionName = s.MOI
   WHERE s.SectionCode IS NOT NULL
     AND NOT EXISTS
     (
         SELECT 1
         FROM ClassSession.Class x
         WHERE x.SemesterId = sem.SemesterId
           AND x.CourseId = c.CourseId
           AND x.InstructorId = i.InstructorId
           AND x.ScheduleId = sch.ScheduleId
           AND x.LocationId = loc.LocationId
           AND x.ModeOfInstructionId = moi.ModeOfInstructionId
           AND x.SectionCode = s.SectionCode
     );




   EXEC Process.usp_TrackWorkFlow 'Load Class', @@ROWCOUNT, @UserAuthorizationKey;
END;
GO




-- =============================================
-- Author: Alexander Bulatao
-- Procedure: Process.usp_LoadAllProductionTables
-- Create date: 2025-12-16
-- Description: Master ETL loader with split UserAuthorizationKey ownership:
--              Nadia=1, Htoo=2, Alexander=5.
-- =============================================
CREATE OR ALTER PROCEDURE Process.usp_LoadAllProductionTables
   @KeepWorkflow BIT = 0
AS
BEGIN
   SET NOCOUNT ON;




   DECLARE @NadiaKey INT = 1;
   DECLARE @HtooKey  INT = 2;
   DECLARE @AlexKey  INT = 5;




   BEGIN TRY
       EXEC Process.usp_TrackWorkFlow 'START LoadAllProductionTables', NULL, @AlexKey;




       EXEC Process.usp_DropForeignKeys;
       EXEC Process.usp_TruncateTables @KeepWorkflow = @KeepWorkflow;




       -- Htoo: core lookups
       EXEC Process.usp_LoadSemester          @HtooKey;
       EXEC Process.usp_LoadModeOfInstruction @HtooKey;
       EXEC Process.usp_LoadSchedule          @HtooKey;
       EXEC Process.usp_LoadLocation          @HtooKey;




       -- Alex: academic entities + bridges + final fact table
       EXEC Process.usp_LoadDepartment            @AlexKey;
       EXEC Process.usp_LoadCourse                @AlexKey;
       EXEC Process.usp_LoadInstructor            @AlexKey;
       EXEC Process.usp_LoadInstructorDepartment  @AlexKey;
       EXEC Process.usp_LoadClassroomLocation     @AlexKey;
       EXEC Process.usp_LoadClass                 @AlexKey;




       EXEC Process.usp_AddForeignKeys;




       EXEC Process.usp_TrackWorkFlow 'END LoadAllProductionTables', NULL, @AlexKey;
   END TRY
   BEGIN CATCH
   BEGIN TRY
       EXEC Process.usp_AddForeignKeys;
   END TRY
   BEGIN CATCH
   END CATCH;




   DECLARE @msg NVARCHAR(4000);
   DECLARE @ErrMsg NVARCHAR(200);




   SET @msg = ERROR_MESSAGE();
   SET @ErrMsg = N'ERROR: ' + LEFT(@msg, 100);




   EXEC Process.usp_TrackWorkFlow @ErrMsg, NULL, @AlexKey;




   THROW;
END CATCH
END;
GO






DROP TABLE IF EXISTS Process.WorkflowSteps;
GO


CREATE TABLE Process.WorkflowSteps
(
    WorkflowStepId          INT IDENTITY(1,1)
        CONSTRAINT PK_Workflow PRIMARY KEY,


    WorkflowStepDescription NVARCHAR(200) NOT NULL,
    TableRowCount           INT NULL,
    StartTime               DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
    EndTime                 DATETIME2(7) NOT NULL DEFAULT SYSDATETIME(),
    UserAuthorizationKey    INT NOT NULL,


    CONSTRAINT FK_Workflow_UA
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES DbSecurity.UserAuthorization(UserAuthorizationKey)
);
GO








CREATE OR ALTER PROCEDURE Process.usp_TrackWorkFlow
    @WorkFlowDescription  VARCHAR(100),
    @TableRowCount        INT            = NULL,
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;


    INSERT INTO Process.WorkflowSteps
    (
        WorkflowStepDescription,
        TableRowCount,
        StartTime,
        EndTime,
        UserAuthorizationKey
    )
    VALUES
    (
        @WorkFlowDescription,
        @TableRowCount,
        SYSDATETIME(),
        SYSDATETIME(),
        @UserAuthorizationKey
    );
END;
GO






SELECT *
FROM CollegeCatalog.Course




SELECT *
FROM Faculty.Instructor




/* =========================================================
   MASTER LOAD – LOAD ALL PRODUCTION TABLES
   ========================================================= */


/*
EXEC Process.usp_LoadAllProductionTables @KeepWorkflow = 0;
EXEC Process.usp_ShowWorkflowSteps;


TEST:


SELECT *
FROM CollegeCatalog.Course




SELECT *
FROM Faculty.Instructor


*/




/* =========================================================
   WORKFLOW AUDIT – VERIFY PROCEDURE EXECUTION
   ========================================================= */


/*
EXEC Process.usp_ShowWorkflowSteps;
GO
*/




/* =========================================================
   OPTIONAL / MAINTENANCE EXECUTES
   ========================================================= */


/* Truncate production tables only (keeps workflow history) */
/*
EXEC Process.usp_TruncateTables @KeepWorkflow = 1;
GO
*/


/* Disable all foreign keys */
/*
EXEC Process.usp_DropForeignKeys;
GO
*/







