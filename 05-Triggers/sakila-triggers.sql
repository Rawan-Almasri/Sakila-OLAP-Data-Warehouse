USE Sakila_OLAP;
GO


--DDL Trigger to audit CREATE_TABLE in Database

CREATE TABLE audit_create
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(100),
    ObjectName NVARCHAR(255),
    ObjectType NVARCHAR(100),
    SqlCommand NVARCHAR(MAX),
    LoginName NVARCHAR(255),
    UserName NVARCHAR(255),
    EventDate DATETIME DEFAULT GETDATE()
);
GO


CREATE TRIGGER trg_Audit_Create_Table
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EventData XML;
    SET @EventData = EVENTDATA();

    INSERT INTO audit_create
    (
        EventType,
        ObjectName,
        ObjectType,
        SqlCommand,
        LoginName,
        UserName,
        EventDate
    )
    VALUES
    (
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)'),
        @EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)'),
        @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(255)'),
        USER_NAME(),
        GETDATE()
    );
END;
GO


CREATE TABLE test
(
    TestID INT PRIMARY KEY,
    TestName NVARCHAR(100)
);
GO

SELECT *
FROM audit_create;
GO
