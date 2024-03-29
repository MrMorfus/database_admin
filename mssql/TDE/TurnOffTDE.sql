--
-- SQL 2008 TDE Setup and Administration
--
-- Turn off XX_DATABASE_XX TDE encryption assuming it is already setup for server via SetupTDE or TurnOnTDE

declare @DateStr varchar(32)

print 'Switching OFF XX_DATABASE_XX data encryption via TDE'
use XX_DATABASE_XX
alter database XX_DATABASE_XX set encryption off

-- Let user know when encryption has completed
while not exists
(  
   select encryption_state from sys.dm_database_encryption_keys
   where DB_NAME(database_id) = 'XX_DATABASE_XX' and encryption_state = 1
)
begin
   set @DateStr = convert(varchar, getdate(), 120)
   raiserror('%s Waiting 5 seconds for database decryption to complete', 0, 0, @DateStr) with nowait
   waitfor delay '00:00:05' 
end

print 'Decryption complete'

select   db_name(database_id),
         case encryption_state 
            when 0 then '0 - No database encryption key present, no encryption'
            when 1 then '1 - Unencrypted'
            when 2 then '2 - Encryption in progress'
            when 3 then '3 - Encrypted'
            when 4 then '4 - Key change in progress'
            when 5 then '5 - Decryption in progress'
         end encryption_state_desc,
         *
from sys.dm_database_encryption_keys

print ''
print 'XX_DATABASE_XX database is now unencrypted but SQL Server is still configured. It can be re-encrypted using TurnOnTDE.sql'
print 'Restart SQL to clear tempdb encryption status in sys.dm_database_encryption_keys.'
