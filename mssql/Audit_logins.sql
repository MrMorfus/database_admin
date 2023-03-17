Print 'Use the Microsoft SQL Query Analyzer (SQL Server Management Studio)'
Print 'delivered with SQL Server 2005 to run this query using the db_owner/sysadmin role.'
Print ''
Print 'Use the menu path Query > Results to file before running this query.'
Print ''
Print ''

Use master

Print 'SQL Server version'
select @@Version;
go

Print '[Shows Authentication Type (Mixed/Windows/SQL)]exec xp_loginconfig'
exec xp_loginconfig;
go

Print 'select * from sys.configurations;'
select * from sys.configurations;
go

Print 'select * from sys.sql_logins;'
select * from sys.sql_logins;
go

Print 'select * from sys.server_principals;'
select * from sys.server_principals;
go

Print 'select * from sys.server_permissions;'
select * from sys.server_permissions;
go

Print 'exec sp_helpsrvrolemember'
exec sp_helpsrvrolemember;
go

Print 'exec sp_helprolemember'
exec sp_helprolemember;
go

Print 'select * from sys.database_principals;'
select * from sys.database_principals;
go

Print 'exec sp_helpuser'
exec sp_helpuser;
go

Print 'exec sp_helprole'
exec sp_helprole;
go

Print 'exec sp_helprotect'
exec sp_helprotect;
go

Print 'select * from dbo.sysobjects where type not in (''S'')order by xtype, name;'
select * from dbo.sysobjects where type not in ('S') order by xtype, name;
go
