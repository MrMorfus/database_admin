USE master
GO
-- Create table to hold valid IP values
CREATE TABLE ValidIPAddress (IP NVARCHAR(15)
CONSTRAINT PK_ValidAddress PRIMARY KEY)

-- Declare local machine as valid one
INSERT INTO ValidIPAddress
SELECT '<local machine>'
-- Create Logon Trigger to stop logins from invalid IPs
CREATE TRIGGER tr_LogOn_CheckIP ON ALL SERVER
    FOR LOGON
AS
    BEGIN
        DECLARE @IPAddress NVARCHAR(50) ;
        SET @IPAddress = EVENTDATA().value('(/EVENT_INSTANCE/ClientHost)[1]',
                                           'NVARCHAR(50)') ;
        IF NOT EXISTS ( SELECT  IP
                        FROM    master..ValidIPAddress
                        WHERE   IP = @IPAddress )
            BEGIN
            -- If login is not a valid one, then undo login process
                SELECT  @IPAddress
                ROLLBACK --Undo login process
            END

    END