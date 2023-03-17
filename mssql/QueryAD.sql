EXEC GetActiveDirectoryGroupMembers
      @LDAPDomain             = 'LDAP://RLN'
      , @LDAPUserName         = 'RLN\DevAdmin'
      , @LDAPPassword         = 'xxxxxxx'
      , @GroupDN              = 'CN=reports,OU=SDLC,OU=TRL-Objects,DC=tricore,DC=org'
      , @SearchValue          = NULL
         
EXEC GetActiveDirectoryGroups
      @LDAPDomain                   = 'LDAP://RLN'
      , @LDAPUserName         = 'RLN\DevAdmin'
      , @LDAPPassword         = 'xxxxxxx'
      , @SearchValue          = 'reports'