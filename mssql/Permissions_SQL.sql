
	/* CREATE A NEW ROLE PER DB*/
	CREATE ROLE db_executor

	/* GRANT EXECUTE TO THE ROLE PER DB*/
	GRANT EXECUTE TO db_executor
	/* ADD AD GROUP TO THIS ROLE AFTER IT IS CREATED */

	/* GRANT VIEW DEFS PER DB*/
	/* USE sp_helprotect TO TROUBLESHOOT*/
	GRANT VIEW DEFINITION TO [COMPWORKS\SQL Server Access - Production - Read _ Write]

	/* GRANT VIEW SERVER FOR DTS LEGACY*/
	GRANT VIEW SERVER STATE TO [COMPWORKS\SQL Server Access - Production - Read _ Write]

	/* GRANT SQL JOB VIEWS; RUN IN MSDB*/
	EXECUTE sp_addrolemember
	@rolename = 'SQLAgentReaderRole', -- SQLAgentOperatorRole
	@membername = '[COMPWORKS\SQL Server Access - Production - Read _ Write]'

	/* GRANT BULKADMIN */
	EXECUTE sp_addsrvrolemember
	@rolename = 'bulkadmin',
	@loginame = 'COMPWORKS\SQL Server Access - Production - Read _ Write'

	/* GRANT JOB EXECUTION; RUN IN MSDB*/
	EXECUTE sp_addrolemember
	@rolename = 'SQLAgentOperatorRole',
	@membername = '[COMPWORKS\SQL Server Access - Production - Read _ Write]'

	/* GRANT EXEC PLAN VIEW PER DB*/
	GRANT SHOWPLAN TO "[COMPWORKS\SQL Server Access - Production - Read _ Write]"

	/* GRANT VIEW FOR PERF DASHBOARD */
	GRANT VIEW SERVER STATE TO "[COMPWORKS\SQL Server Access - Production - Read _ Write]"
	GRANT ALTER TRACE TO "[COMPWORKS\SQL Server Access - Production - Read _ Write]"

