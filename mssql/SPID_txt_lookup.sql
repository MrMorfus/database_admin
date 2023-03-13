
SELECT spid, hostname, nt_username, cmd, waittime, wt.blocking_session_id AS blocking_id, h2.TEXT AS BlockingText 
FROM sys.sysprocesses AS sp 
	INNER JOIN sys.dm_os_waiting_tasks AS wt ON sp.spid = wt.session_id 
	INNER JOIN sys.dm_exec_connections ec2 ON ec2.session_id = wt.blocking_session_id 
	CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2
WHERE spid = '1526' -- Your SPID goes here.
