/*
												Just open this script on the server, where the object lives.
												Fill out the two variables.
												Go to Hawaii!
*/

-- Make a table to hold logins and crap
DECLARE @myTable TABLE
(
	UserID INT IDENTITY(1,1),
    AcctName VARCHAR(100)
)
DECLARE @Database VARCHAR(100), @Object VARCHAR (100)
	SET @Database = 'DBA_Tools' -- Set to the database where the object lives
	SET @Object = 'SP_SITES'    -- Set the object name, duh.
-- Fill the variable table
INSERT INTO @myTable(AcctName)(SELECT name FROM sys.syslogins WHERE name LIKE 'CompIQ%')
-- Get the number of rows in the looping table
DECLARE @RowCount INT
SET @RowCount = (SELECT COUNT(AcctName) FROM @myTable) 
-- Declare an iterator
DECLARE @I INT
-- Initialize the iterator
SET @I = 1
-- Loop through the rows of a table @myTable
WHILE (@I <= @RowCount)
BEGIN
        -- Declare variables to hold the data which we get after looping each record
	    DECLARE @Acct VARCHAR(50),@SQL1 VARCHAR(1000)
        -- Get the data from table and set to variables
        SELECT @Acct = AcctName FROM @myTable WHERE UserID = @I;
        -- Run Stuff
		SET @SQL1 = 'GRANT EXECUTE ON OBJECT::' + @Database + '.dbo.' + @Object + ' TO ' + @Acct
		EXEC(@SQL1)
        -- Increment the iterator
        SET @I = @I  + 1
END