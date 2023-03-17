--
-- SQL 2008 TDE Setup and Administration
--
-- Restore/setup TDE certificates and keys from backup files ready to switch on TDE for a DB 
-- or restore a backup already encrypted by TDE.
--
-- Use RemoveTDE.sql first if the server has previously been configured for TDE.

DECLARE @PassPhrase varchar(255)
DECLARE @BackupFolder varchar(512)
DECLARE @ExecSQL varchar(512)
DECLARE @DateStr varchar(32)
DECLARE @Debug int

-- ** WHILE NOBODY ELSE CAN SEE **
-- This is to be manually set by HR
-- ** Do not save the file once set **

set @PassPhrase = ''
set @BackupFolder = 'C:\xxxxx\xxxxxx'
set @Debug = 1

PRINT 'Restoring master key from file'
use master
set @ExecSQL = 'restore master key from file = ''' + @BackupFolder + 'TDEServerMaster_.key''' +
' decryption by password = ''' + @PassPhrase + '''' + 
' encryption by password = ''' + @PassPhrase + ''''
if @Debug = 1 PRINT @ExecSQL
exec(@ExecSQL)

/*
restore master key from file = 'I:\Program Files\MSSQL\MSSQL10.HR\MSSQL\TDE\TDEServerMasterKey.key' 
decryption by password = '1_HR_Supplied_PassPhrase_For_TDE' 
encryption by password = '1_HR_Supplied_PassPhrase_For_TDE'
*/

PRINT 'Encrypting master key WITH service master key'
use master
set @ExecSQL = 'open master key decryption by password = ''' + @PassPhrase + ''''
if @Debug = 1 PRINT @ExecSQL
exec(@ExecSQL)

alter master key add encryption by service master key

/*
open master key decryption by password = '1_HR_Supplied_PassPhrase_For_TDE'
*/

PRINT 'Restoring certificate from file'
use master
set @ExecSQL = 
   'create certificate TDEServerCertificate_ from file = ''' + @BackupFolder + 'TDEServerCertificate_.cer''' +
   ' WITH private key (file = ''' + @BackupFolder + 'TDEServerCertificate_.key''' +
   ', decryption by password = ''' + @PassPhrase + ''')'
if @Debug = 1 PRINT @ExecSQL
exec(@ExecSQL)




/*
create certificate TDEServerCertificate
from file = 'I:\Program Files\MSSQL\MSSQL10.HR\MSSQL\TDE\TDEServerCertificate.cer'
WITH private key
(
   file = 'I:\Program Files\MSSQL\MSSQL10.HR\MSSQL\TDE\TDEServerCertificate.key',
   decryption by password = '1_HR_Supplied_PassPhrase_For_TDE'
)
*/

PRINT 'Creating XX_DATABASE_XX Database Encryption Key'
CREATE DATABASE ESIS;
use ESIS;
create database encryption key WITH algorithm = aes_256 encryption by server certificate TDEServerCertificate_

PRINT ''
PRINT 'SQL Server is now ready to restore an encrypted XX_DATABASE_XX backup or encrypt an existing unencrypted database via TurnOnTDE'
