DECLARE @sp_who2 TABLE 
(
   RowNum INT IDENTITY(1,1),
   SPID INT,  
   Status VARCHAR(1000) NULL,  
   Login SYSNAME NULL,  
   HostName SYSNAME NULL,  
   BlkBy SYSNAME NULL,  
   DBName SYSNAME NULL,  
   Command VARCHAR(1000) NULL,  
   CPUTime INT NULL,  
   DiskIO INT NULL,  
   LastBatch VARCHAR(1000) NULL,  
   ProgramName VARCHAR(1000) NULL,  
   SPID2 INT,
   REQUESTID INT NULL
)
INSERT INTO @sp_who2
EXEC sp_who2
-- Get the number of rows in the looping table
DECLARE @RowCount INT
SET @RowCount = (SELECT COUNT(RowNum) FROM @sp_who2)
-- Declare an iterator
DECLARE @I INT
-- Initialize the iterator
SET @I = 1
-- Loop through the rows of a table @myTable
WHILE (@I <= @RowCount)
BEGIN
        -- Declare variables to hold the data which we get after looping each record
        DECLARE @iSPID varchar(10), @iLogin VARCHAR(50), @SQL NVARCHAR(100)
        -- Get the data from table and set to variables
        SELECT @iSPID = SPID, @iLogin = [Login] FROM @sp_who2 WHERE RowNum = @I
        -- Display the looped data
        IF @iLogin IN('compworks\SBell','compworks\EMensch','compworks\KEfthyvoulos')
			SET @SQL = 'KILL ' + @iSPID
			--SELECT @SQL
			EXEC(@SQL)
        -- Increment the iterator
        SET @I = @I  + 1
END