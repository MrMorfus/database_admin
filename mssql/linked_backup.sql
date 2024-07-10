DECLARE @BKP VARCHAR(300), @name VARCHAR(100), @SQL1 VARCHAR(3000)
SET @name = 'someDatabase'
SET @BKP = '''/var/opt/mssql/backup/' + @name + '.bak'''
SET @SQL1 = 'BACKUP DATABASE ' + @name + ' TO DISK = ' + @BKP
-- SELECT @SQL1
EXEC(@SQL1) AT [LINKED_SERVER]
