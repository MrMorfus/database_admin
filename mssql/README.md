# mssql_server
content descriptions:

* EMail_Alert_4_Blocks      - a fancy html email when locks occur in any database
* SA_Logging_trigger        - a login trigger to monitor who is using the SA acocunt
* BAK_Retore_NewName        - back up a database and immdiately restore it with a new name
* Activity_Monitor          - two table variables to catch and report out processes that are blocked, and by whom
* AssignPerms_Single_Object - assign accounts to single datbase objects
* ChangePassword            - update a linked server password
* Copy_SIDs_for_accounts   - copy the SID from one account on a server to another for RPC IN/OUT on linked servers
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
* Purge_OLD_Logins          - clean an entire server of old logins, no longer in the login folder
* Set_Log_Space_Free        - find all logs and set the free space free
* SPID_txt_lookup           - look up the syntax text of a SPID
* sql_uptime                - totaly server uptime and services status
* SSRS_Listing_Report       - various reports for ssrs, and reverse lookups
* Kill_all_per_db           - kill all sessions per database
* DTS_Copy_ServerToServer   - copy a DTS package from one server to another 
* populate_envir            - recon scripts to collect information about all the databases on a server
* Tracely_Default_objs      - enable the default trace and start collecting object info 
* Audit_logins              - stored procedures to execute for logins
* Audit_roles               - stored procedure to execute for roles
* QueryAD                   - main script to execute to find AD users and their groups
* QueryADGroupMembers       - stored procedure used by the query script
* QueryADGroups             - stored procedure used by the query script
* Restrict_logins_by_IP     - limit the IP addresses allowed to access a server
* DEAUTH_users              - find a list of users and kill them
* parse_JSON                - pasrse a JSON out of a max varchar, adjust the compatibility mode first
