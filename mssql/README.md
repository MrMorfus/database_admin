# mssql_server
content descriptions:

* EMail_Alert_4_Blocks      - a fancy html email when locks occur in any database
* SA_Logging_trigger        - a login trigger to monitor who is using the SA acocunt
* BAK_Retore_NewName        - back up a database and immdiately restore it with a new name
* Activity_Monitor          - two table variables to catch and report out processes that are blocked, and by whom
* AssignPerms_Single_Object - assign accounts to single datbase objects
* ChangePassword            - update a linked server password
* Copy_SIDs_for_accoiunts   - copy the SID from one account on a server to another for RPC IN/OUT on linked servers
* DangerSQL                 - instructions and permissions to turn XP_commandshell on
* SSRS_Jobs_Lookup          - reports and lookups for ssrs jobs/reports/email updates/etc
* EXEC_ALL_sqljobs          - start all jobs on the sql server
* Find_nonascii_char        - search for any non-ascii character in a column
* LinkedServer_Add_Acct     - add a linked server with this account based on a list of servers
* ForAllDBs_Add_AD_acct     - add an active directory account for every database on the server
* MassUpdate_Owners         - update all database object ownership from whatever to DBO
* MassUpdate_SQLjobs_SSRS   - update the owner for sql scheduled jobs and ssrs reports
* New_Server_Setup          - new instance setup: set tempdb, set compression, set dbmail, set mem, etc
* Permissions_SQL           - additional permissions to allow view access to things
* 
