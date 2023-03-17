--
-- SQL 2008 TDE Setup and Administration
--
-- List status of XX_DATABASE_XX TDE encryption


-- Is XX_DATABASE_XX encrypted?
SELECT   db_name(database_id) AS DBName,
         case encryption_state 
            when 0 then '0 - No database encryption key present, no encryption'
            when 1 then '1 - Unencrypted'
            when 2 then '2 - Encryption in progress'
            when 3 then '3 - Encrypted'
            when 4 then '4 - Key change in progress'
            when 5 then '5 - Decryption in progress'
         end encryption_state_desc,
         *
from sys.dm_database_encryption_keys;

-- Have we got the expected server certificate?
SELECT * from master.sys.certificates where name = 'TDEServerCertificate'

-- Does the thumbPRINT of the certificate match the thumbPRINT of the database encryption?
SELECT 'ThumbPRINTs match', db_name(dek.database_id), ctf.thumbPRINT cert_thumbPRINT, dek.encryptor_thumbPRINT dek_thumbPRINT
from sys.dm_database_encryption_keys dek
join  master.sys.certificates ctf
on dek.encryptor_thumbPRINT = ctf.thumbPRINT
and db_name(dek.database_id) = 'ESIS'

UNION

SELECT 'ThumbPRINTs DO NOT match', db_name(database_id), ctf.thumbPRINT cert_thumbPRINT, dek.encryptor_thumbPRINT dek_thumbPRINT
from sys.dm_database_encryption_keys dek
join  master.sys.certificates ctf
on dek.encryptor_thumbPRINT != ctf.thumbPRINT
and db_name(dek.database_id) = 'ESIS'
and ctf.name = 'TDEServerCertificate'
