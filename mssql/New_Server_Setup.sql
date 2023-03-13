-- Set default compression for SQL Server
USE master;
GO
EXEC sp_configure 'backup compression default', '1';
RECONFIGURE WITH OVERRIDE;
GO
RECONFIGURE;
GO

-- Move TempDB to it's own drive. Execute and then restart the SQL Services
USE master;
GO
ALTER DATABASE TempDB MODIFY FILE
(NAME = tempdev, FILENAME = 'H:\DATA\datatempdb.mdf') -- <= Set your path
GO
ALTER DATABASE TempDB MODIFY FILE
(NAME = templog, FILENAME = 'H:\DATA\datatemplog.ldf') -- <= Set your path
GO

-- Set the default data locations
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE'
	, N'SoftwareMicrosoftMSSQLServerMSSQLServer'
	, N'DefaultData'
	, REG_SZ
	, N'D:\DATA\' -- <= Set your path
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE'
	, N'SoftwareMicrosoftMSSQLServerMSSQLServer'
	, N'DefaultLog'
	, REG_SZ
	, N'F:\LOGS\' -- <= Set your path
GO

-- Set default memory for SQL to eat
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'max server memory', 16384; -- <= set your MAX memory
GO
RECONFIGURE;
GO
sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO

-- Set model DB to simple recovery
USE master;
ALTER DATABASE model SET RECOVERY SIMPLE;
GO

-- Set up database mail and profile
USE MSDB;
GO
-- Create a Database Mail account
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'SQL Administrator',
    @description = 'Admin SQL database mail',
    @email_address = 'noreply@something.com',
    @replyto_address = 'someone.anyone@something.com',
    @display_name = 'SQL Administrator',
    @mailserver_name = 'exchange.DNS.address' ;

-- Create a Database Mail profile
EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'SQL Administrator',
    @description = 'SQL Admin mail for alerts' ;

-- Add the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'SQL Administrator',
    @account_name = 'SQL Administrator',
    @sequence_number =1 ;

-- Grant access to the profile to the DBMailUsers role
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'SQL Administrator',
    @principal_name = 'dbo',
    @is_default = 1 ;

