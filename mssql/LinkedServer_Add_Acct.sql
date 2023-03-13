/**

**/
-- Create a table variable to store user data
DECLARE @myTable TABLE
(
	UserID INT IDENTITY(1,1),
    Sname VARCHAR(100)
)
-- Fill the variable table
INSERT INTO @myTable(Sname)
-- Get all the database names minus the system databases
(SELECT SRV_NAME = srv.name FROM sys.servers srv WHERE is_linked = 1)
-- Get the number of rows in the looping table
DECLARE @RowCount INT
SET @RowCount = (SELECT COUNT(Sname) FROM @myTable) 
-- Declare an iterator
DECLARE @I INT
-- Initialize the iterator
SET @I = 1
-- Loop through the rows of a table @myTable
WHILE (@I <= @RowCount)
BEGIN
        -- Declare variables to hold the data which we get after looping each record
	    DECLARE @SRV VARCHAR(50), @SQL1 VARCHAR(1000)
        -- Get the data from table and set to variables
        SELECT @SRV = Sname FROM @myTable WHERE UserID = @I;
        -- Run Stuff
		SET @SQL1 = 'EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N''' + @SRV + ''',@useself=N''False'',@locallogin=NULL,@rmtuser=N''missing_link'',@rmtpassword=''xxXXXxxXxXXXxXXX'''
		EXEC (@SQL1)
        -- Increment the iterator
        SET @I = @I  + 1
END