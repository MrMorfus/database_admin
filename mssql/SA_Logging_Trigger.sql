USE DB_COMMON;
GO
CREATE TABLE [dbo].[SQL_Login_Audit](
	[SrvName] [sql_variant] NULL,
	[SPID] [smallint] NOT NULL,
	[Hostname] [nvarchar](128) NULL,
	[Login_name] [nvarchar](128) NULL,
	[ProgramName] [nvarchar](128) NULL,
	[DateCollected] [datetime] NOT NULL
) ON [PRIMARY]

USE master;
GO
CREATE TRIGGER connection_login_audit
ON ALL SERVER
FOR LOGON
AS
BEGIN
IF ORIGINAL_LOGIN()= 'sa'
	INSERT INTO [DB_COMMON].dbo.[SQL_Login_Audit]
    SELECT SERVERPROPERTY('ServerName') AS SrvName, @@SPID AS SPID, HOST_NAME() AS Hostname, SUSER_NAME() AS Login_name, program_name() AS ProgramName, GETDATE() AS DateCollected
END;


/**
SELECT [SrvName]
      ,[SPID]
      ,[Hostname]
      ,[Login_name]
      ,[ProgramName]
      ,[DateCollected]
      FROM [DB_COMMON].dbo.SQL_Login_Audit 
      WHERE DateCollected > DATEADD("HOUR", -4, GETDATE())
**/