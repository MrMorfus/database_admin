--
-- SQL 2008 TDE Setup and Administration
--
-- Backup the TDE certificate and keys. Done as part of SetupTDE but can be redone by this script
-- if the backup files are lost.


DECLARE @PassPhrase varchar(255), @BackupFolder varchar(512), @EXECsql varchar(512), @DateStr varchar(32), @Debug int, @SRVRcertKey varchar(255), @SRVRcert varchar(255)

/*
** WHILE NOBODY ELSE CAN SEE **
This information is for DBAs ONLY!!
** Do not save the file once set **
*/
SELECT @PassPhrase = ''
	,@BackupFolder = 'C:\xxxxx\xxxxxx'
	,@SRVRcertKey = 'TDEServerMaster_.key'
	,@SRVRcert = 'TDEServerCertificate_.key'
	,@Debug = 1

PRINT 'Backing up Server Master Key to ' + @BackupFolder + @SRVRcertKey
PRINT 'NB SQL Server service account needs write permission in ' + @BackupFolder + ' which may have been removed to avoid accidental deletion'
set @EXECsql = 'BACKUP master key to file = ''' + @BackupFolder + @SRVRcertKey + ' encryption by password = ''' + @PassPhrase + ''''
if @Debug = 1 PRINT @EXECsql
SELECT(@EXECsql)

PRINT 'Backing up Server certificate to ' + @BackupFolder + @SRVRcert
PRINT 'Backing up Server certificate private key to ' + @BackupFolder + @SRVRcert
use master
set @EXECsql =
   'BACKUP certificate TDEServerCertificate TO FILE = ''' + @BackupFolder + @SRVRcert + ''' WITH private key (file = ''' + @BackupFolder + @SRVRcert + ''' +
   , encryption by password = ''' + @PassPhrase + ''')'
if @Debug = 1 PRINT @EXECsql
SELECT(@EXECsql)
