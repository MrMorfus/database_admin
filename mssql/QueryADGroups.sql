USE [COMMON]
GO

/****** Object:  StoredProcedure [dbo].[GetActiveDirectoryGroups]    Script Date: 07/23/2010 09:24:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[GetActiveDirectoryGroups]
		-- Add the parameters for the stored procedure here
		@LDAPDomain			NVARCHAR(MAX)
		, @LDAPUserName		NVARCHAR(MAX)
		, @LDAPPassword		NVARCHAR(MAX)
		, @SearchValue		NVARCHAR(MAX)
	AS
	BEGIN
		BEGIN TRY
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			-- Insert statements for procedure here
			DECLARE
				@GroupTable TABLE
				(
					objectGuid							UNIQUEIDENTIFIER
					, distinguishedName					NVARCHAR(MAX)
					, SAMAccountName					NVARCHAR(MAX)
					, mail								NVARCHAR(MAX)
					, sn								NVARCHAR(MAX)
					, name								NVARCHAR(MAX)
					, cn								NVARCHAR(MAX)
				)
			
			DECLARE
				@OpenRowSetSQL	NVARCHAR(MAX)
				
			SET @OpenRowSetSQL	= 
				'
					SELECT
						CAST(objectGuid AS UNIQUEIDENTIFIER) AS objectGuid
						, distinguishedName
						, SAMAccountName
						, mail
						, sn
						, name
						, cn
					FROM 
						OPENROWSET
						(
							''ADSDSOObject''
							, ''adsdatasource''; ''' + @LDAPUserName + '''; ''' + @LDAPPassword + '''
							,
								''
									<' + @LDAPDomain + '>;(&(objectCategory=group));objectGuid, distinguishedName, SAMAccountName, mail, sn, name, cn;subtree
								''
						)
				'
				
			--SELECT @OpenRowSetSQL
			INSERT INTO @GroupTable
			EXEC (@OpenRowSetSQL)

			SELECT
				objectGuid
				, distinguishedName
				, SAMAccountName
				, mail
				, sn
				, name
				, cn
			FROM
				@GroupTable
			WHERE
				SAMAccountName LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR mail LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR sn LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR name LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR cn LIKE ('%' + COALESCE(@SearchValue, '') + '%')
			ORDER BY
				sn ASC
			
			
			
		END TRY

		BEGIN CATCH
			-- RAISERROR with severity 11-19 will cause execution to 
			-- jump to the CATCH block
			DECLARE
				@ErrorMessage		NVARCHAR(MAX)
				, @ErrorSeverity	INT
				, @ErrorState		INT

			SELECT
				@ErrorMessage		= ERROR_MESSAGE()
				, @ErrorSeverity	= ERROR_SEVERITY()
				, @ErrorState		= ERROR_STATE()

			-- Use RAISERROR inside the CATCH block to return 
			-- error information about the original error that 
			-- caused execution to jump to the CATCH block.
			RAISERROR
			(
				@ErrorMessage		-- Message text
				, @ErrorSeverity	-- Severity
				, @ErrorState		-- State
			)
		END CATCH

	END


GO

