USE [DBA_COMMON]
GO
DROP TABLE [dbo].[NAV_Clients]
GO
CREATE TABLE [dbo].[NAV_Clients](
	[NavClients_ID] [int] IDENTITY(1,1) NOT NULL,
	[Server] [varchar](50) NULL,
	[Instance] [varchar](10) NULL,
	[DB_name] [varchar](50) NULL,
	[Program_prefix] [varchar](50) NULL,
	[Program_prefix2] [varchar](50) NULL,
	[Teleforms_prefix] [varchar](10) NULL,
	[SDLC_enviro] [varchar](10) NULL,
	[IsActive] [bit] NULL,
	[IsNAV] [bit] NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
DROP TABLE [dbo].[tmp_Clients]
GO
CREATE TABLE [dbo].[tmp_Clients](
	[NavClients_ID] [int] IDENTITY(1,1) NOT NULL,
	[Server] [varchar](50) NULL,
	[Instance] [varchar](10) NULL,
	[DB_name] [varchar](50) NULL,
	[Program_prefix] [varchar](50) NULL,
	[Program_prefix2] [varchar](50) NULL,
	[Teleforms_prefix] [varchar](10) NULL,
	[Per_se] [varchar](50) NULL,
	[SDLC_enviro] [varchar](10) NULL,
	[IsActive] [bit] NULL,
	[IsNAV] [bit] NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL
) ON [PRIMARY]
GO


EXEC sp_MSforeachdb'
USE [?];
INSERT INTO [PPLSQL03\SQL03].[DBA_COMMON].dbo.[tmp_Clients]([Server],[Instance],[DB_name],[Program_prefix],[Program_prefix2],[Teleforms_prefix],[Per_se],[SDLC_enviro],[IsActive],[IsNAV],[StartDate],[EndDate])
(SELECT 
@@SERVERNAME AS SVRname, 
''SQL03'' AS Instance, 
DB_NAME() AS db_name, 
LEFT([name], CHARINDEX(''$'',[name],1)) AS Program_Prefix, 
LEFT([name], CHARINDEX(''$'',[name],1)-1) AS Program_Prefix2, 
'''' AS Teleforms_prefix, 
LEFT([name], CHARINDEX(''$'',[name],1)) AS Per_se, 
''PROD'' AS SDLC_enviro, 
1 AS IsActive, 
1 AS IsNAV, 
''1/1/2018'' AS [StartDate], 
''12/31/2078'' AS [EndDate] 
FROM sys.tables 
WHERE [name] LIKE ''%$%'')'

INSERT INTO [DBA_COMMON].dbo.[NAV_Clients]([Server],[Instance],[DB_name],[Program_prefix],[Program_prefix2],[Teleforms_prefix],[SDLC_enviro],[IsActive],[IsNAV],[StartDate],[EndDate])
(SELECT [Server],[Instance],[DB_name],[Program_prefix],[Program_prefix2],[Teleforms_prefix],[SDLC_enviro],[IsActive],[IsNAV],[StartDate],[EndDate] FROM 
(
SELECT [Server]
      ,[Instance]
      ,[DB_name]
	  ,[Program_prefix]
	  ,[Program_prefix2]
	  ,[Teleforms_prefix]
      ,ROW_NUMBER() OVER (PARTITION BY [Per_se] ORDER BY [Per_se]) as num
      ,[SDLC_enviro]
      ,[IsActive]
	  ,[IsNAV]
      ,[StartDate]
      ,[EndDate]
  FROM [DBA_COMMON].dbo.[tmp_Clients]
) a
WHERE a.num = 1)
GO
/*

ALTER TABLE [DBA_COMMON].dbo.[NAV_Clients] WITH NOCHECK ADD CONSTRAINT chk_read_only CHECK( 1 = 0 )
GO

TRUNCATE TABLE [DBA_COMMON].dbo.[tmp_Clients]
INSERT INTO [PPLSQL03\SQL03].[DBA_COMMON].dbo.[tmp_Clients]([Server],[Instance],[DB_name],[Program_prefix],[Program_prefix2],[Teleforms_prefix],[Per_se],[SDLC_enviro],[IsActive],[IsNAV],[StartDate],[EndDate])
SELECT @@SERVERNAME AS SVRname,'SQL03' AS Instance,[name] AS [db_name],'' AS [Program_prefix],'' AS [Program_prefix2],'' AS [Teleforms_prefix],'' AS [Per_se], 'PROD' AS SDLC_enviro, 1 AS IsActive, 0 AS IsNav, '1/1/2018' AS [StartDate], '12/31/2078' AS [EndDate] 
FROM sys.databases WHERE [state] <> 6 AND [name] NOT IN(SELECT [db_name] FROM [PPLSQL03\SQL03].[DBA_COMMON].dbo.[NAV_Clients])

INSERT INTO [DBA_COMMON].dbo.[NAV_Clients]([Server],[Instance],[DB_name],[Program_prefix],[Program_prefix2],[Teleforms_prefix],[SDLC_enviro],[IsActive],[IsNAV],[StartDate],[EndDate])
SELECT [Server],[Instance],[DB_name],[Program_prefix],[Program_prefix2],[Teleforms_prefix],[SDLC_enviro],[IsActive],[IsNAV],[StartDate],[EndDate] FROM [DBA_COMMON].dbo.[tmp_Clients]
*/
DELETE FROM [DBA_COMMON].dbo.[NAV_Clients] WHERE [DB_name] IN('master','tempdb','msdb','model')
GO
SELECT * FROM [DBA_COMMON].dbo.[tmp_Clients]
SELECT * FROM [DBA_COMMON].dbo.[NAV_Clients]
