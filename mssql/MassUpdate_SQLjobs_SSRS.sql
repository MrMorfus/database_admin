--This is for SQL Jobs
USE MSDB
GO
SELECT 'EXEC msdb.dbo.sp_update_job @job_name=N'''+NAME+''' , @owner_login_name=N''COMPWORKS\sqlservices''' FROM sysjobs
GO
SELECT  dbo.SQLAGENT_SUSER_SNAME(owner_sid)
      , SUSER_SNAME(owner_sid)
      , *
FROM    dbo.sysjobs

--This is for SSRS reports
USE Reports_SSRS
GO
DECLARE @OldUserID uniqueidentifier
DECLARE @NewUserID uniqueidentifier
SELECT @OldUserID = UserID FROM dbo.Users WHERE UserName = 'DOMAINA\OldUser'
SELECT @NewUserID = UserID FROM dbo.Users WHERE UserName = 'DOMAINB\NewUser'
UPDATE dbo.Subscriptions SET OwnerID = @NewUserID WHERE OwnerID = @OldUserID