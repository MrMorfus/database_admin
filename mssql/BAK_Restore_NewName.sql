USE master
GO

DECLARE
	@orgname	VARCHAR(500),
	@newname	VARCHAR(500),
	@bakfolder	VARCHAR(500),
	@SQLbk		VARCHAR(6000),
	@SQLres		VARCHAR(6000)

SELECT
	@orgname = 'SUCKIT',
	@newname = 'TEST',
	@bakfolder = 'F:\DBA_tmp_restore\',
	--------------^^ Only set these.
	@SQLbk = 'BACKUP DATABASE [' + @orgname + '] TO DISK = N''' + @bakfolder + @orgname + '.BAK' + ''' WITH NOFORMAT, COMPRESSION, INIT,  NAME = N''' + @orgname + '-Full Database Backup''' + ', SKIP, NOREWIND, NOUNLOAD,  STATS = 10;',
	@SQLres = 'RESTORE DATABASE [' + @newname + '] FROM DISK = N''' + @bakfolder + @orgname + '.BAK' + ''' WITH MOVE ''' + @orgname + ''' TO ''F:\DiabloUT MSSQL\Data\' + @newname + '.mdf'', MOVE ''' + @orgname + '_log'' TO ''E:\DiabloUT MSSQL\Log\' + @newname + '.ldf'''
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SELECT @SQLbk
EXEC(@SQLbk)

DECLARE @percent INT
DONE:
	SELECT @percent = (SELECT percent_complete FROM sys.dm_exec_requests WHERE command LIKE '%BACKUP%')
	IF(@percent > 0) GOTO DONE;
		ELSE
			-- SELECT @SQLres	
			EXEC(@SQLres)
