USE DB_COMMON
GO
IF EXISTS (Select * from sysobjects where name = 'LogList')
DROP TABLE LogList
GO
CREATE TABLE LogList ([DB_IDent] INT IDENTITY (1,1), [DBname] VARCHAR (200),[Size] INT, [Per_cent] INT, [Status] INT, [Database_ID] INT)
GO
-- Fill da table with the log size
INSERT INTO LogList([DBname],[Size], [Per_cent], [Status])
	 EXEC ('DBCC SQLPERF(logspace)')
GO
-- Remove the system DBs, leave them alone
DELETE FROM LogList WHERE DBname IN('master','tempdb','model','msdb')
GO
-- Go grab the database IDs
update LogList
set LogList.Database_ID = sys.master_files.database_id
from LogList
INNER JOIN sys.master_files on sys.master_files.physical_name LIKE '%' + LogList.DBname + '%'

-- Declare some variables
DECLARE @RowCount INT, @I INT
-- Now SET THEM!
SET @RowCount = (SELECT COUNT(DB_IDent) FROM LogList) 
SET @I = 1
-- Loop through the rows of LogList
WHILE (@I <= @RowCount)
BEGIN
        -- Declare some MOAR variables
		DECLARE @iDBname VARCHAR(100), @iDBlog VARCHAR(100), @iPercent INT, @SQL VARCHAR(MAX), @SQL2 VARCHAR(MAX), @iDBID VARCHAR(100)
        -- Get the data from table and set to variables
        SELECT @iDBname = DBname, @iPercent = Per_cent, @iDBID = Database_ID FROM LogList WHERE DB_Ident = @I
        -- Do some junk, like shrink some logs lazy ass.
        IF @iPercent < 50
			BEGIN
			-- DO NOT, EVER, EVER,!!!!!! USE THIS PART ON PRODUCTION
				SET @SQL2 = 'ALTER DATABASE [' + @iDBname + '] SET RECOVERY SIMPLE'
				EXEC(@SQL2)
				-- SELECT @SQL2
				SET @iDBlog = (SELECT name FROM sys.master_files WHERE database_id = @iDBID AND type_desc = 'LOG')
				SET @SQL = 'USE [' + @iDBname + '] DBCC SHRINKFILE (' + @iDBlog + ', 1)'
				EXEC(@SQL)
				-- SELECT @SQL
			END
		ELSE
			BEGIN
				PRINT 'NOTHIENR'
			END
        -- Increment the iterator
        SET @I = @I  + 1
        -- YAY! Go to Hawaii!!
END



/**
SELECT * FROM sys.master_files WHERE database_id = 273 and type_desc = 'LOG'
SELECT * FROM LogList WHERE Per_cent < 50
**/