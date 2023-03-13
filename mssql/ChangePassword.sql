-- setup history table
create table Common.dbo.ChangePasswordHistory (
  server varchar(100),
  login varchar(100),
  status varchar(10),
  modified_by varchar(100),
  time_stamp datetime
)

-- Usage:
--   exec ChangePassword 'TRL-BPA-00', 'sa', 'Abc_123!@#'

create proc ChangePassword 
  @linked_server varchar(100), 
  @login varchar(100), 
  @new_password varchar(100)
as

set nocount on
declare @cmd nvarchar(4000), @result int

set @cmd = N'exec ['+@linked_server+'].master.dbo.sp_password null, '''+@new_password+''', '''+@login+''''
exec sp_executesql @result = @cmd

insert into Common.dbo.ChangePasswordHistory
select @linked_server, @login, case when @result=0 then 'SUCCEEDED' else 'FAILED' end, system_user, getdate()

