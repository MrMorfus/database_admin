USE ReportServer
GO
-- Find the email address you are looking for and how many reports have that email
DECLARE @find VARCHAR(300), @old VARCHAR(300), @new VARCHAR(300), @update INT
SET @find = '%Jenn%' -- This is to help find the ones you want
SET @old = 'Gwend' -- Old email
SET @new = '' -- New email
SET @update = 0 -- Update switch after you set above variables
SELECT Path, Name, * 
	FROM ReportServer.dbo.Subscriptions S 
		INNER JOIN [Catalog] C ON S.Report_OID = C.ItemID 
	WHERE ExtensionSettings LIKE @find
-- Mass update the subscriptions with a new email
IF @update = 1
	UPDATE ReportServer.dbo.Subscriptions
	SET ExtensionSettings = CAST(REPLACE(CAST([ExtensionSettings] AS NVARCHAR(MAX)), @old,@new) AS NTEXT)
	WHERE ExtensionSettings LIKE @find
IF @update = 2
	SELECT CAST(REPLACE(CAST([ExtensionSettings] AS NVARCHAR(MAX)), @old,@new) AS NTEXT) FROM ReportServer.dbo.Subscriptions WHERE ExtensionSettings LIKE @find

------------------------------------------------------------------------------------------------------------------------------------	

-- Look up a Job name for an SSRS report
SELECT
      c.Name AS ReportName
      , rs.ScheduleID AS JOB_NAME
      , s.[Description]
      , s.LastStatus
      , s.LastRunTime
FROM
      ReportServer..[Catalog] c
      JOIN ReportServer..Subscriptions s ON c.ItemID = s.Report_OID
      JOIN ReportServer..ReportSchedule rs ON c.ItemID = rs.ReportID
      AND rs.SubscriptionID = s.SubscriptionID
	  WHERE c.Name = 'RawInventoryData'
      ORDER BY LastRunTime DESC
-------------------------------------------------------------------------------------------------------------------------------------      
-- search the jobs for a specific text 
USE msdb
GO
SELECT SERVERPROPERTY('SERVERNAME') as [InstanceName],
	j.job_id,
	j.name,
	js.step_id,
	js.command,
	j.enabled 
FROM	msdb.dbo.sysjobs j
JOIN	msdb.dbo.sysjobsteps js
	ON	js.job_id = j.job_id 
WHERE	js.command LIKE '%mark%' AND j.enabled = 1-- replace keyword with the word or stored proc that you are searching for
GO      
-------------------------------------------------------------------------------------------------------------------------------------
-- Update Operators email address
USE MSDB
GO
SELECT * FROM sysoperators
---------------------------------------------
DECLARE @old VARCHAR(300), @new VARCHAR(300)
SET @old = '@xerox.com'
SET	@new = '@conduent.com' 
---------------------------------------------
UPDATE sysoperators
SET email_address = REPLACE([email_address], @old,@new)
