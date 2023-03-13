USE DB_COMMON
GO
-- Make a bucket
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[BLOCK]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE BLOCK;
CREATE TABLE BLOCK
(
	blockID INT IDENTITY(1,1),
	spid INT, 
	hostname VARCHAR(100), 
	nt_username VARCHAR(100), 
	cmd VARCHAR(100), 
	waittime INT, 
	blocked BIT
)
-- Insert some data to work on
INSERT BLOCK(spid, hostname, nt_username, cmd, waittime, blocked)
(SELECT spid, hostname, nt_username, cmd, waittime, blocked FROM sys.sysprocesses WHERE blocked != 0)
-- If there are blocks, ALERT THE INTERNETZ
DECLARE @BLOCKS INT
SET @BLOCKS = (SELECT COUNT(*) FROM BLOCK)
IF @BLOCKS > 1
	BEGIN
		-- Make purdy EMAIL
		DECLARE @HTML_Body1 VARCHAR(MAX), @HTML_Head1 VARCHAR(MAX), @HTML_Tail1 VARCHAR(MAX), @EMAIL_Body VARCHAR(MAX)
		 SET @HTML_Head1 = '<html>'
		 SET @HTML_Head1 = @HTML_Head1 + '<head>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <style>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' body{font-family: arial; font-size: 13px;}table{font-family: arial; font-size: 13px; border-collapse: collapse;width:100%} td {padding: 2px;height:15px;border:solid 1px black;} th {padding: 2px;background-color:black;color:white;border:solid 1px black;}' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' </style>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + '</head>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + '<table>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <tr>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <th>SPID</th>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <th>HOSTNAME</th>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <th>USERNAME</th>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <th>CMD</th>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <th>WAIT_TIME</th>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' <th>BLOCKED</th>' + CHAR(13) + CHAR(10)
		 SET @HTML_Head1 = @HTML_Head1 + ' </tr>' + CHAR(13) + CHAR(10)
		 SET @HTML_Tail1 = '</table></body></html>'
		-- Make the body of the email with our data
		 SET @HTML_Body1 = @HTML_Head1 + (Select Cast(spid as Varchar (80)) AS [TD], Cast(hostname as Varchar (80)) AS [TD], Cast(nt_username as Varchar (80)) AS [TD], Cast(cmd as Varchar (80)) AS [TD], Cast(waittime as Varchar (80)) AS [TD], Cast(blocked as Varchar (80)) AS [TD] FROM BLOCK FOR XML RAW('tr') ,ELEMENTS) + @HTML_Tail1
		 SET @EMAIL_Body = '<BR><BR>' + @HTML_Body1
	
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='SQL Administrator',
		@subject='*!*BLOCKS DETECTED*!*',
		@recipients='Your email list; here for who; to alert',
		@Body = @EMAIL_Body,
		@body_format = 'HTML'
	END

