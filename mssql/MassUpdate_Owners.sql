USE [DB_COMMON]
GO

/****** Object:  StoredProcedure [dbo].[Object_SWAP]    Script Date: 08/02/2017 15:24:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<MMW>
-- Create date: <08/01/2017>
-- Description:	<Change objects from user to DBO>
-- =============================================
CREATE PROCEDURE [dbo].[Object_SWAP] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
-- table varible to hold list of users to purge
DECLARE @ownerSWAP TABLE
(
	SomeRows INT IDENTITY(1,1),
	UserName VARCHAR(2000),
	Thing VARCHAR(2000)
)
-- fill the table with a list compared to the server logins
INSERT INTO @ownerSWAP(Username, Thing)
(
	SELECT USER_NAME(UID) AS UserOwner, name AS thing
	FROM dbo.sysobjects WHERE USER_NAME(UID) = 'missing_link'
)
SELECT * FROM @ownerSWAP
-- make a counter for first loop
DECLARE
	@RowCount1 INT,
	@I INT
	
SET @RowCount1 = (SELECT COUNT(SomeRows) FROM @ownerSWAP)
SET @I = 1
-- start first loop for users to purge
WHILE (@I <= @RowCount1)
BEGIN
	DECLARE 
		@Ownername VARCHAR(2000),
		@object VARCHAR(2000),
		@SQL2 VARCHAR(2000)
		
		SET @Ownername = (SELECT UserName FROM @ownerSWAP WHERE SomeRows = @I)
		SET @object = (SELECT Thing FROM @ownerSWAP WHERE SomeRows = @I)
		-- change owenership of current object selected in the loop
		SET @SQL2 = 'EXEC sp_changeobjectowner [' + @OwnerName + '.' + @object + '], ' + '''dbo'''
		EXEC(@SQL2)
	SET @I = @I + 1
END

/*
SELECT USER_NAME(UID) AS UserOwner, name AS thing
	FROM dbo.sysobjects WHERE USER_NAME(UID) = 'missing_link'

EXEC sp_changeobjectowner 'missing_link.BLOCK', 'dbo'
*/
END

GO


