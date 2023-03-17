USE [DB_COMMON]
GO

/****** Object:  StoredProcedure [dbo].[GetActiveDirectoryGroupMembers]    Script Date: 07/23/2010 09:24:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[GetActiveDirectoryGroupMembers]
		-- Add the parameters for the stored procedure here
		@LDAPDomain			NVARCHAR(MAX)
		, @LDAPUserName		NVARCHAR(MAX)
		, @LDAPPassword		NVARCHAR(MAX)
		, @GroupDN			NVARCHAR(MAX)
		, @SearchValue		NVARCHAR(MAX)
	AS
	BEGIN
		BEGIN TRY
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			-- Insert statements for procedure here
			DECLARE
				@UserTable TABLE
				(
					objectGuid							UNIQUEIDENTIFIER
					, distinguishedName					NVARCHAR(MAX)
					, SAMAccountName					NVARCHAR(MAX)
					, employeeID						NVARCHAR(MAX)
					, givenname							NVARCHAR(MAX)
					, sn								NVARCHAR(MAX)
					, mail								NVARCHAR(MAX)
					, manager							NVARCHAR(MAX)
					, department						NVARCHAR(MAX)
					, title								NVARCHAR(MAX)
					, l									NVARCHAR(MAX)
					, physicalDeliveryOfficename		NVARCHAR(MAX)
					, telephoneNumber					NVARCHAR(MAX)
					, mobile							NVARCHAR(MAX)
					, pager								NVARCHAR(MAX)
					, wWWHomePage						NVARCHAR(MAX)
				)
			
			DECLARE
				@OpenRowSetSQL	NVARCHAR(MAX)
				
			SET @OpenRowSetSQL	= 
				'
					SELECT
						CAST(objectGuid AS UNIQUEIDENTIFIER) AS objectGuid
						, distinguishedName
						, SAMAccountName
						, employeeID
						, givenname
						, sn
						, mail
						, manager
						, department
						, title
						, l
						, physicalDeliveryOfficename
						, telephoneNumber
						, mobile
						, pager
						, wWWHomePage
					FROM 
						OPENROWSET
						(
							''ADSDSOObject''
							, ''adsdatasource''; ''' + @LDAPUserName + '''; ''' + @LDAPPassword + '''
							,
								''
									<' + @LDAPDomain + '>;(&(MemberOf=' + @GroupDN + '));objectGuid, distinguishedName, SAMAccountName, employeeID, givenname, sn, mail, manager, department, title, l, physicalDeliveryOfficename, telephoneNumber, mobile, pager, wWWHomePage;subtree
								''
						)
				'
				
			--SELECT @OpenRowSetSQL
			INSERT INTO @UserTable
			EXEC (@OpenRowSetSQL)

			SELECT
				objectGuid
				, distinguishedName
				, SAMAccountName
				, employeeID
				, givenname
				, sn
				, mail
				, manager
				, department
				, title
				, l
				, physicalDeliveryOfficename
				, telephoneNumber
				, mobile
				, pager
				, wWWHomePage
			FROM
				@UserTable
			WHERE
				employeeID LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR givenname LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR sn LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR mail LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR department LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR title LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR physicalDeliveryOfficename LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR telephoneNumber LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR mobile LIKE ('%' + COALESCE(@SearchValue, '') + '%')
				OR pager LIKE ('%' + COALESCE(@SearchValue, '') + '%')
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

