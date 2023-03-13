USE MSDB
GO

/*
--Replace All for the following:
--Source Server
[BEETLE]
--Destination Server
[ELCAMINO\QA]
*/

--How Many Rows will be Copied
Select COUNT(*) as 'Row Count To Be Copied'
From [BEETLE].[MSDB].[DBO].sysdtspackages
Where Name not in (Select Name From [ELCAMINO\QA].[MSDB].[DBO].sysdtspackages)
GO

--Insert The DTS Packages
Insert Into [ELCAMINO\QA].[MSDB].[DBO].sysdtspackages
Select * 
From [BEETLE].[MSDB].[DBO].sysdtspackages
Where Name not in (Select Name From [ELCAMINO\QA].[MSDB].[DBO].sysdtspackages) 
GO

--Destination Server Count
Select COUNT(*) as 'Destination Count'
From [ELCAMINO\QA].[MSDB].[DBO].sysdtspackages 
Where Name in (Select Name From [BEETLE].[MSDB].[DBO].sysdtspackages)
GO

--Source Server Count
Select COUNT(*) as 'Source Count' 
From [BEETLE].[MSDB].[DBO].sysdtspackages
GO