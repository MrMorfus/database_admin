USE MASTER;
DECLARE @SRVRname VARCHAR(80), @AD_svcacct VARCHAR(80), @rootacct VARCHAR(100)
SELECT @SRVRname = 'WTW2PPLDVDB001\DEVSQL01', @AD_svcacct = '[PCGUS\svc_something]'
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SET @rootacct = 'CREATE LOGIN ' + @AD_svcacct + 'FROM WINDOWS'
--EXEC(@rootacct)
-- Create a table variable to store user data
DECLARE @myDumpster TABLE
(
    SrvrID INT IDENTITY(1,1),
    dataName VARCHAR(80)
)
-- Insert some data to table to work on that data
INSERT INTO @myDumpster(dataName)
(SELECT DISTINCT([DB_name]) FROM [WTW2PPLDVDB001\DEVSQL01].[DBA_COMMON].dbo.[Nav_clients] WHERE isCRM = 1 AND [Server] = @SRVRname) --<==== You must manually update the location of the DBA_common DB.
-- Get the number of rows in the looping table
DECLARE @RowCount INT
SET @RowCount = (SELECT COUNT(SrvrID) FROM @myDumpster) 
-- Declare an iterator
DECLARE @I INT
-- Initialize the iterator
SET @I = 1
-- Loop through the rows of a table @myDumpster
WHILE (@I <= @RowCount)
BEGIN
        -- Declare variables to hold the data which we get after looping each record
        DECLARE @SQL1 VARCHAR(MAX), @SQL2 VARCHAR(MAX), @SQL3 VARCHAR(MAX), @SQL4 VARCHAR(MAX), @dbname VARCHAR(80), @svcacct VARCHAR(80)  
        -- Get the data from table and set to variables
        SELECT @dbname = dataName FROM @myDumpster WHERE SrvrID = @I
		SELECT @svcacct = @AD_svcacct
        -- Display the looped data: notes: CREATE ROLE db_executor; GRANT EXECUTE TO db_executor;
		SELECT @SQL1 = 'USE ['+ @dbname + ']; CREATE USER ' + @svcacct + ' FOR LOGIN ' + @svcacct
		SELECT @SQL2 = 'USE ['+ @dbname + ']; EXEC sp_addrolemember ''db_datareader'', ' + @svcacct
		SELECT @SQL3 = 'USE ['+ @dbname + ']; EXEC sp_addrolemember ''db_datawriter'', ' + @svcacct
		SELECT @SQL4 = 'USE ['+ @dbname + ']; EXEC sp_addrolemember ''db_executor'', ' + @svcacct
		--EXEC(@SQL1)
		EXEC(@SQL2)
		EXEC(@SQL3)
		EXEC(@SQL4)
        -- Increment the iterator
        SET @I = @I  + 1
END