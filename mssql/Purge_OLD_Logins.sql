/*
## Safety pig has arrived!
##                               _
##  _._ _..._ .-',     _.._(`))
## '-. `     '  /-._.-'    ',/
##    )         \            '.
##   / _    _    |             \
##  |  a    a    /              |
##  \   .-.                     ;  
##   '-('' ).-'       ,'       ;
##      '-;           |      .'
##         \           \    /
##         | 7  .__  _.-\   \
##         | |  |  ``/  /`  /
##        /,_|  |   /,_/   /
##           /,_/      '`-'
##
## MAKE SURE TO SET YOUR DATABASE CORRECTLY BEFORE
##            YOU EXECUTE THIS SCRIPT
*/
USE []
-- table varible to hold list of users to purge
DECLARE @thePURGE TABLE
(
	SomeRows INT IDENTITY(1,1),
	UserName VARCHAR(2000)
)
-- fill the table with a list compared to the server logins
INSERT INTO @thePURGE(Username)
(
	SELECT u.name FROM master..syslogins l
		right join sysusers u on l.sid = u.sid 
    WHERE 
		l.sid IS null AND 
		issqlrole <> 1 AND 
		isapprole <> 1 AND 
			(u.name <> 'INFORMATION_SCHEMA' AND 
			u.name <> 'guest' AND 
			u.name <> 'system_function_schema' AND
			u.name <> 'sys')
)
SELECT * FROM @thePURGE -- Checklist of logins going to be purged
-- make a counter for first loop
DECLARE
	@RowCount1 INT,
	@I INT
	
SET @RowCount1 = (SELECT COUNT(SomeRows) FROM @thePURGE)
SET @I = 1
-- start first loop for users to purge
WHILE (@I <= @RowCount1)
BEGIN
	DECLARE 
		@TARGET VARCHAR(2000),
		@SQL VARCHAR(2000)
		
	SET @TARGET = (SELECT UserName FROM @thePURGE WHERE SomeRows = @I)
	-- table varible to hold objects owned by purging user
	DECLARE @items TABLE
	(
	SomeRows INT IDENTITY(1,1),
	OwnerName VARCHAR(2000),
	Thing VARCHAR(1000)
	)
	-- fill table variable with things
	INSERT INTO @items(OwnerName, Thing)
	(
	SELECT USER_NAME(UID) AS UserOwner, name AS thing
	FROM dbo.sysobjects
	WHERE USER_NAME(UID) = @TARGET
	)
	-- make second counter for next loop
	DECLARE
		@RowCount2 INT,
		@II INT
		
	SET @RowCount2 = (SELECT COUNT(SomeRows) FROM @items)
	SET @II = 1
	-- loop through the things and transfer ownership
	WHILE (@II <= @RowCount2)
		BEGIN
			DECLARE 
				@Ownername VARCHAR(2000),
				@Thing VARCHAR(2000),
				@SQL2 VARCHAR(2000)
				
				SET @Ownername = (SELECT OwnerName FROM @items WHERE SomeRows = @II)
				SET @Thing = (SELECT Thing FROM @items WHERE SomeRows = @II)
				-- change owenership of current object selected in the loop
				SET @SQL2 = 'EXEC sp_changeobjectowner [' + @OwnerName + '.' + @Thing + '], ' + '''dbo'''
				EXEC(@SQL2)
				/*
				BEGIN CATCH
					PRINT 'Wacky Waving Inflatable Arm-Flailing Tubeman'
					-- shaddup
				END CATCH
				*/
			SET @II = @II + 1
		END
	SET @SQL = 'EXEC sp_revokedbaccess ''' + @TARGET + ''''
	EXEC(@SQL)
	SET @I = @I + 1
END