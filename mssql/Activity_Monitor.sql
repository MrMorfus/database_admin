DECLARE @Table TABLE(
        SPID INT,
        Status VARCHAR(MAX),
        LOGIN VARCHAR(MAX),
        HostName VARCHAR(MAX),
        BlkBy VARCHAR(MAX),
        DBName VARCHAR(MAX),
        Command VARCHAR(MAX),
        CPUTime INT,
        DiskIO INT,
        LastBatch VARCHAR(MAX),
        ProgramName VARCHAR(MAX),
        SPID_1 INT,
        REQUESTID INT
)

Declare @table2 Table(
		block int,
		count int
	)


INSERT INTO @Table EXEC sp_who2


--Change select and Where clause to capture needed information.
--SELECT *
--FROM    @Table
--where blkby not like '%.%'
--order by blkby desc, spid
--where spid = 168
--WHERE status <> 'sleeping'

insert into @table2
select distinct blkby, count(*)
from @table
where blkby not like '%.%'
Group by blkby
while (select count(*) from @table2) > 0
begin
		declare @spid int
		select @spid = (select top 1 block from @table2 order by count desc)
		Print @spid

		select * from master..sysprocesses where spid = (@spid)

		dbcc inputbuffer(@spid)

		delete from @table2 where block = @spid
	end

--select * from sys.sysdatabases

-- Find the top queries consuming the most CPU
SELECT getdate() as "RunTime", st.text, qp.query_plan, a.* 
FROM sys.dm_exec_requests a 
CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) as st 
CROSS APPLY sys.dm_exec_query_plan(a.plan_handle) as qp 
order by CPU_time desc