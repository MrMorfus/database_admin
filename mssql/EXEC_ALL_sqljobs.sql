-- Create a table variable to store user data
DECLARE @JOBS TABLE
(
    someID INT IDENTITY(1,1),
    JobName VARCHAR(200)
)

-- Insert some data to table to work on that data
INSERT INTO @JOBS(JobName)(SELECT name FROM MSDB.dbo.sysjobs)

-- Get the number of rows in the looping table
DECLARE @RowCount INT
SET @RowCount = (SELECT COUNT(someID) FROM @JOBS) 

-- Declare an iterator
DECLARE @I INT
-- Initialize the iterator
SET @I = 1

-- Loop through the rows of a table @myTable
WHILE (@I <= @RowCount)
BEGIN
        -- Declare variables to hold the data which we get after looping each record
        DECLARE @iJOB VARCHAR(200), @SQL VARCHAR(1000), @Status INT
        -- Get the data from table and set to variables
        SELECT @iJOB = JobName FROM @JOBS WHERE someID = @I
        -- Display the looped data
		SET @SQL = 'EXEC sp_start_job @job_name = ''' + @iJOB + ''' '
		EXEC(@SQL)
			SET @Status = EXEC msdb.dbo.sp_help_job @job_name = @iJOB
		
        -- Increment the iterator
        SET @I = @I  + 1
END


SELECT name FROM MSDB.dbo.sysjobs
exec msdb.dbo.sp_help_job @job_name = '' --status <> 4