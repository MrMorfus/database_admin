--
-- SQL 2008 TDE Setup and Administration
--
-- **** INITIAL setup TDE Encryption WHEN NOT ALREADY SETUP ****
--
-- If has been setup before run RemoveTDE.sql and restart SQL Server before
-- running this script.
--
-- If you run SetupTDE again on same server YOU WILL NOT BE ABLE TO RESTORE OLD BACKUPS UNLESS YOU KEEP THE OLD CERTIFICATE BACKUPS.

DECLARE @PassPhrase varchar(255), @TDE_Type bit, @BackupFolder varchar(512), @ExecSQL varchar(3000), @DateStr varchar(32), @Debug int, @ClientDB varchar(300), @CL_PassPhrase varchar(255)

/*
** WHILE NOBODY ELSE CAN SEE **
This information is for DBAs ONLY!!
** Do not save the file once set **
*/
SELECT @PassPhrase = ''
	,@BackupFolder = 'C:\xxxxxx\xxxxxx'
	,@ClientDB = ''
	,@CL_PassPhrase = ''
	,@Debug = 1
	,@TDE_Type = 0


IF @TDE_Type = 0 GOTO SRVRSETUP ELSE GOTO CLSETUP

-- Server lvl section, only needs to happen once
SRVRSETUP:
PRINT 'Creating Server Master Key'
USE MASTER
 SET @ExecSQL = 'CREATE master key encryption by password = ''' + @PassPhrase + ''''
IF @Debug = 1 PRINT @ExecSQL
EXEC(@ExecSQL)

PRINT 'Creating server certificate - never expires '
USE MASTER
CREATE certificate TDEServerCertificate WITH subject = 'TDEServerCertificate_AGSSQLW03' , expiry_date = '3500-Jan-01'

PRINT 'Backing up Server Master Key to ' + @BackupFolder + 'TDEServerMaster_AGSSQLW03.key'
PRINT 'NB SQL Server service account needs write permission in ' + @BackupFolder + ' which may have been removed to avoid accidental deletion'
SET @ExecSQL = 'BACKUP master key to file = ''' + @BackupFolder + 'TDEServerMaster_AGSSQLW03.key''' + ' encryption by password = ''' + @PassPhrase + ''''
IF @Debug = 1 PRINT @ExecSQL
EXEC(@ExecSQL)

PRINT 'Backing up Server certificate to ' + @BackupFolder + 'TDEServerCertificate_AGSSQLW03.cer'
PRINT 'Backing up Server certificate private key to ' + @BackupFolder + 'TDEServerCertificate_AGSSQLW03.key'
USE MASTER
SET @ExecSQL =
   'BACKUP certificate TDEServerCertificate TO FILE = ''' + @BackupFolder + 'TDEServerCertificate_AGSSQLW03.cer''' + 
   ' WITH private key (file = ''' + @BackupFolder + 'TDEServerCertificate_AGSSQLW03.key''' +
   ', encryption by password = ''' + @PassPhrase + ''')'
IF @Debug = 1 PRINT @ExecSQL
EXEC(@ExecSQL)

GOTO HALT


-- Database section for indiviual DBs
CLSETUP:
SET @ExecSQL = 
	'CREATE CERTIFICATE ' + @ClientDB + '_ECert WITH SUBJECT = ''' + @ClientDB + 'DEK Certificate'';'
EXEC(@ExecSQL)

SET @ExecSQL =
	'BACKUP CERTIFICATE ' + @ClientDB + '_ECert TO FILE = ''' + @BackupFolder + @ClientDB + '_ECert.bak''
	   WITH PRIVATE KEY (
			 FILE = ''' + @BackupFolder + @ClientDB + '_ECert_PrivateKey.pvk'',
			 ENCRYPTION BY PASSWORD = ''' + @CL_PassPhrase + ''');'
IF @Debug = 1 PRINT @ExecSQL
EXEC(@ExecSQL)

PRINT 'Creating ' + @ClientDB + ' Database Encryption Key'
SET @ExecSQL = 
	'USE [' + @ClientDB + '] CREATE database encryption key WITH algorithm = aes_256 encryption by server certificate ' + @ClientDB + '_ECert'
IF @Debug = 1 PRINT @ExecSQL
EXEC(@ExecSQL)

PRINT 'Switching on ' + @ClientDB + ' data encryption via TDE'
SET @ExecSQL = 
	'ALTER DATABASE [' + @ClientDB + '] SET encryption ON'
IF @Debug = 1 PRINT @ExecSQL
EXEC(@ExecSQL)

-- Let user know when encryption has completed
while not exists
(  
   select encryption_state from sys.dm_database_encryption_keys
   where DB_NAME(database_id) = @ClientDB and encryption_state = 3
)
begin
   set @DateStr = convert(varchar, getdate(), 120)
   raiserror('%s Waiting 5 seconds for database decryption to complete', 0, 0, @DateStr) with nowait
   waitfor delay '00:00:05' 
end

/* NOTES:
DECLARE @BackupFolder varchar(512)
DECLARE @ExecSQL varchar(3000)
DECLARE @ClientDB varchar(300)
set @BackupFolder = 'C:\FIATUT\Ecert\'
set @ClientDB = 'XX_DATABASE_XX'
*/

HALT:
Print 'We are done'