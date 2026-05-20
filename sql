CREATE DATABASE TaskExpenseManagementDB;
GO

USE TaskExpenseManagementDB;
GO

/* =========================================================
   COMMON MASTER TABLES
========================================================= */

CREATE TABLE Roles
(
    RoleId BIGINT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0
);
GO


/* =========================================================
   USERS TABLE
========================================================= */

CREATE TABLE Users
(
    UserId BIGINT IDENTITY(1,1) PRIMARY KEY,

    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,

    Email NVARCHAR(150) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(15) NULL UNIQUE,

    PasswordHash NVARCHAR(MAX) NOT NULL,

    RoleId BIGINT NOT NULL,

    EmployeeCode NVARCHAR(50) NOT NULL UNIQUE,

    Designation NVARCHAR(100) NULL,
    Department NVARCHAR(100) NULL,

    ProfileImage NVARCHAR(500) NULL,

    LastLogin DATETIME2 NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Users_Roles
    FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);
GO


/* =========================================================
   USER SESSIONS
========================================================= */

CREATE TABLE UserSessions
(
    SessionId BIGINT IDENTITY(1,1) PRIMARY KEY,

    UserId BIGINT NOT NULL,

    RefreshToken NVARCHAR(MAX) NOT NULL,

    ExpiryDate DATETIME2 NOT NULL,

    IsRevoked BIT NOT NULL DEFAULT 0,

    IPAddress NVARCHAR(100) NULL,
    DeviceInfo NVARCHAR(500) NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_UserSessions_Users
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO


/* =========================================================
   PROJECTS TABLE
========================================================= */

CREATE TABLE Projects
(
    ProjectId BIGINT IDENTITY(1,1) PRIMARY KEY,

    ProjectName NVARCHAR(200) NOT NULL,
    ProjectCode NVARCHAR(50) NOT NULL UNIQUE,

    Description NVARCHAR(MAX) NULL,

    StartDate DATE NOT NULL,
    EndDate DATE NULL,

    Budget DECIMAL(18,2) NULL,

    Status NVARCHAR(50) NOT NULL,

    ManagerId BIGINT NOT NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Projects_Manager
    FOREIGN KEY (ManagerId) REFERENCES Users(UserId),

    CONSTRAINT CHK_Project_Status
    CHECK (Status IN ('Pending', 'Active', 'Completed', 'OnHold', 'Cancelled')),

    CONSTRAINT CHK_Project_Dates
    CHECK (EndDate IS NULL OR EndDate >= StartDate)
);
GO


/* =========================================================
   PROJECT MEMBERS
========================================================= */

CREATE TABLE ProjectMembers
(
    ProjectMemberId BIGINT IDENTITY(1,1) PRIMARY KEY,

    ProjectId BIGINT NOT NULL,
    UserId BIGINT NOT NULL,

    AssignedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_ProjectMembers_Project
    FOREIGN KEY (ProjectId) REFERENCES Projects(ProjectId),

    CONSTRAINT FK_ProjectMembers_User
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO


/* =========================================================
   TASKS TABLE
========================================================= */

CREATE TABLE Tasks
(
    TaskId BIGINT IDENTITY(1,1) PRIMARY KEY,

    ProjectId BIGINT NOT NULL,

    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,

    AssignedTo BIGINT NOT NULL,
    AssignedBy BIGINT NOT NULL,

    Priority NVARCHAR(20) NOT NULL,
    Status NVARCHAR(50) NOT NULL,

    StartDate DATE NOT NULL,
    DueDate DATE NOT NULL,

    EstimatedHours DECIMAL(5,2) NULL,
    ActualHours DECIMAL(5,2) NULL,

    CompletionPercentage INT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Tasks_Project
    FOREIGN KEY (ProjectId) REFERENCES Projects(ProjectId),

    CONSTRAINT FK_Tasks_AssignedTo
    FOREIGN KEY (AssignedTo) REFERENCES Users(UserId),

    CONSTRAINT FK_Tasks_AssignedBy
    FOREIGN KEY (AssignedBy) REFERENCES Users(UserId),

    CONSTRAINT CHK_Task_Priority
    CHECK (Priority IN ('Low', 'Medium', 'High', 'Critical')),

    CONSTRAINT CHK_Task_Status
    CHECK (Status IN ('Pending', 'InProgress', 'Completed', 'Rejected', 'Reopened')),

    CONSTRAINT CHK_Task_Dates
    CHECK (DueDate >= StartDate),

    CONSTRAINT CHK_Task_Completion
    CHECK (CompletionPercentage BETWEEN 0 AND 100)
);
GO


/* =========================================================
   TASK COMMENTS
========================================================= */

CREATE TABLE TaskComments
(
    CommentId BIGINT IDENTITY(1,1) PRIMARY KEY,

    TaskId BIGINT NOT NULL,
    UserId BIGINT NOT NULL,

    CommentText NVARCHAR(MAX) NOT NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_TaskComments_Task
    FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),

    CONSTRAINT FK_TaskComments_User
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO


/* =========================================================
   TASK ATTACHMENTS
========================================================= */

CREATE TABLE TaskAttachments
(
    AttachmentId BIGINT IDENTITY(1,1) PRIMARY KEY,

    TaskId BIGINT NOT NULL,

    FileName NVARCHAR(255) NOT NULL,
    FilePath NVARCHAR(1000) NOT NULL,

    FileSize BIGINT NULL,

    UploadedBy BIGINT NOT NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_TaskAttachments_Task
    FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),

    CONSTRAINT FK_TaskAttachments_User
    FOREIGN KEY (UploadedBy) REFERENCES Users(UserId)
);
GO


/* =========================================================
   EXPENSE CATEGORIES
========================================================= */

CREATE TABLE ExpenseCategories
(
    CategoryId BIGINT IDENTITY(1,1) PRIMARY KEY,

    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0
);
GO


/* =========================================================
   EXPENSES TABLE
========================================================= */

CREATE TABLE Expenses
(
    ExpenseId BIGINT IDENTITY(1,1) PRIMARY KEY,

    UserId BIGINT NOT NULL,
    ProjectId BIGINT NOT NULL,
    CategoryId BIGINT NOT NULL,

    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,

    Amount DECIMAL(18,2) NOT NULL,

    ExpenseDate DATE NOT NULL,

    Status NVARCHAR(50) NOT NULL DEFAULT 'Draft',

    SubmittedAt DATETIME2 NULL,

    ApprovedBy BIGINT NULL,
    ApprovedAt DATETIME2 NULL,

    RejectionReason NVARCHAR(MAX) NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Expenses_User
    FOREIGN KEY (UserId) REFERENCES Users(UserId),

    CONSTRAINT FK_Expenses_Project
    FOREIGN KEY (ProjectId) REFERENCES Projects(ProjectId),

    CONSTRAINT FK_Expenses_Category
    FOREIGN KEY (CategoryId) REFERENCES ExpenseCategories(CategoryId),

    CONSTRAINT FK_Expenses_ApprovedBy
    FOREIGN KEY (ApprovedBy) REFERENCES Users(UserId),

    CONSTRAINT CHK_Expense_Amount
    CHECK (Amount > 0),

    CONSTRAINT CHK_Expense_Status
    CHECK (Status IN ('Draft', 'Submitted', 'Approved', 'Rejected'))
);
GO


/* =========================================================
   EXPENSE ATTACHMENTS
========================================================= */

CREATE TABLE ExpenseAttachments
(
    AttachmentId BIGINT IDENTITY(1,1) PRIMARY KEY,

    ExpenseId BIGINT NOT NULL,

    FileName NVARCHAR(255) NOT NULL,
    FilePath NVARCHAR(1000) NOT NULL,

    FileType NVARCHAR(50) NULL,

    UploadedBy BIGINT NOT NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_ExpenseAttachments_Expense
    FOREIGN KEY (ExpenseId) REFERENCES Expenses(ExpenseId),

    CONSTRAINT FK_ExpenseAttachments_User
    FOREIGN KEY (UploadedBy) REFERENCES Users(UserId)
);
GO


/* =========================================================
   NOTIFICATIONS
========================================================= */

CREATE TABLE Notifications
(
    NotificationId BIGINT IDENTITY(1,1) PRIMARY KEY,

    UserId BIGINT NOT NULL,

    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,

    NotificationType NVARCHAR(50) NULL,

    IsRead BIT NOT NULL DEFAULT 0,

    RedirectUrl NVARCHAR(500) NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Notifications_User
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO


/* =========================================================
   AUDIT LOGS
========================================================= */

CREATE TABLE AuditLogs
(
    AuditId BIGINT IDENTITY(1,1) PRIMARY KEY,

    UserId BIGINT NULL,

    ActionType NVARCHAR(100) NOT NULL,
    TableName NVARCHAR(100) NOT NULL,

    RecordId BIGINT NOT NULL,

    OldValues NVARCHAR(MAX) NULL,
    NewValues NVARCHAR(MAX) NULL,

    IPAddress NVARCHAR(100) NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_AuditLogs_User
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO


/* =========================================================
   PASSWORD RESET OTP
========================================================= */

CREATE TABLE PasswordResetOtps
(
    OtpId BIGINT IDENTITY(1,1) PRIMARY KEY,

    UserId BIGINT NOT NULL,

    OTPCode NVARCHAR(20) NOT NULL,

    ExpiryTime DATETIME2 NOT NULL,

    IsUsed BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CreatedBy BIGINT NULL,

    UpdatedAt DATETIME2 NULL,
    UpdatedBy BIGINT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_PasswordResetOtps_User
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO


/* =========================================================
   INDEXES
========================================================= */

CREATE INDEX IX_Users_Email
ON Users(Email);
GO

CREATE INDEX IX_Users_EmployeeCode
ON Users(EmployeeCode);
GO

CREATE INDEX IX_Tasks_ProjectId
ON Tasks(ProjectId);
GO

CREATE INDEX IX_Tasks_AssignedTo
ON Tasks(AssignedTo);
GO

CREATE INDEX IX_Expenses_UserId
ON Expenses(UserId);
GO

CREATE INDEX IX_Expenses_ProjectId
ON Expenses(ProjectId);
GO

CREATE INDEX IX_Notifications_UserId
ON Notifications(UserId);
GO


/* =========================================================
   DEFAULT ROLES INSERT
========================================================= */

INSERT INTO Roles
(
    RoleName,
    Description
)
VALUES
('Admin', 'System Administrator'),
('Manager', 'Project Manager'),
('Employee', 'Employee');
GO
