use master
GO
SELECT TOP 10
   SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(qt.TEXT) ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1)
 , qs.execution_count
 , qs.total_logical_reads
 , qs.last_logical_reads
 , qs.total_logical_writes
 , qs.last_logical_writes
 , qs.total_worker_time
 , qs.last_worker_time
 , qs.total_elapsed_time/1000000 total_elapsed_time_in_S
 , qs.last_elapsed_time/1000000 last_elapsed_time_in_S
 , qs.last_execution_time
 , qp.query_plan
FROM sys.dm_exec_query_stats qs
   CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
   CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
--ORDER BY qs.total_logical_reads DESC -- logical reads
--ORDER BY qs.total_logical_writes DESC -- logical writes
ORDER BY qs.total_worker_time DESC -- CPU time
SELECT TOP 20
   SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(qt.TEXT) ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1)
 , qs.total_worker_time
 , qs.execution_count
 , qs.last_worker_time
FROM sys.dm_exec_query_stats (nolock) qs
   CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY qs.total_worker_time DESC -- CPU time
SELECT TOP 20
   SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(qt.TEXT) ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1)
 , qs.execution_count
 , qs.total_elapsed_time/1000000 total_elapsed_time_in_S
 , qs.last_elapsed_time/1000000 last_elapsed_time_in_S
FROM sys.dm_exec_query_stats (nolock) qs
   CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY qs.execution_count DESC -- executions
SELECT TOP 20
   SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(qt.TEXT) ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1)
 , qs.execution_count
 , qs.total_logical_reads
 , qs.last_logical_reads
 , qs.total_logical_writes
 , qs.last_logical_writes
 , qs.total_worker_time
 , qs.last_worker_time
 , qs.total_elapsed_time/1000000 total_elapsed_time_in_S
 , qs.last_elapsed_time/1000000 last_elapsed_time_in_S
 , qs.last_execution_time
FROM sys.dm_exec_query_stats (nolock) qs
   CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
   CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_logical_reads DESC -- IO
SELECT TOP 20
   SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(qt.TEXT) ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1)
 , qs.total_elapsed_time/qs.execution_count/1000000 avg_runtime_in_S
 , qs.execution_count
 , qs.total_elapsed_time/1000000 total_elapsed_time_in_S
 , qs.last_elapsed_time/1000000 last_elapsed_time_in_S
 , qs.last_execution_time
FROM sys.dm_exec_query_stats (nolock) qs
   CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
   CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_elapsed_time/qs.execution_count DESC 
-- runtime database job configuration and execution


-- job configuration
SELECT
   [sJOB].[job_id] AS [JobID]
   , [sJOB].[name] AS [JobName]
   , [sDBP].[name] AS [JobOwner]
   , [sCAT].[name] AS [JobCategory]
   , [sJOB].[description] AS [JobDescription]
   , CASE [sJOB].[enabled]
       WHEN 1 THEN 'Yes'
       WHEN 0 THEN 'No'
     END AS [IsEnabled]
   , [sJOB].[date_created] AS [JobCreatedOn]
   , [sJOB].[date_modified] AS [JobLastModifiedOn]
   , [sSVR].[name] AS [OriginatingServerName]
   , [sJSTP].[step_id] AS [JobStartStepNo]
   , [sJSTP].[step_name] AS [JobStartStepName]
   , CASE
       WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'
       ELSE 'Yes'
     END AS [IsScheduled]
   , [sSCH].[schedule_uid] AS [JobScheduleID]
   , [sSCH].[name] AS [JobScheduleName]
   , CASE [sJOB].[delete_level]
       WHEN 0 THEN 'Never'
       WHEN 1 THEN 'On Success'
       WHEN 2 THEN 'On Failure'
       WHEN 3 THEN 'On Completion'
     END AS [JobDeletionCriterion]
FROM
   [msdb].[dbo].[sysjobs] AS [sJOB]
   LEFT JOIN [msdb].[sys].[servers] AS [sSVR]
       ON [sJOB].[originating_server_id] = [sSVR].[server_id]
   LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT]
       ON [sJOB].[category_id] = [sCAT].[category_id]
   LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sJSTP]
       ON [sJOB].[job_id] = [sJSTP].[job_id]
       AND [sJOB].[start_step_id] = [sJSTP].[step_id]
   LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP]
       ON [sJOB].[owner_sid] = [sDBP].[sid]
   LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH]
       ON [sJOB].[job_id] = [sJOBSCH].[job_id]
   LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH]
       ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
ORDER BY [JobName]


-- job execution
SELECT
   [sJOB].[job_id] AS [JobID]
   , [sJOB].[name] AS [JobName]
   , CASE
       WHEN [sJOBH].[run_date] IS NULL OR [sJOBH].[run_time] IS NULL THEN NULL
       ELSE CAST(
               CAST([sJOBH].[run_date] AS CHAR(8))
               + ' '
               + STUFF(
                   STUFF(RIGHT('000000' + CAST([sJOBH].[run_time] AS VARCHAR(6)),  6)
                       , 3, 0, ':')
                   , 6, 0, ':')
               AS DATETIME)
     END AS [LastRunDateTime]
   , CASE [sJOBH].[run_status]
       WHEN 0 THEN 'Failed'
       WHEN 1 THEN 'Succeeded'
       WHEN 2 THEN 'Retry'
       WHEN 3 THEN 'Canceled'
       WHEN 4 THEN 'Running' -- In Progress
     END AS [LastRunStatus]
   , STUFF(
           STUFF(RIGHT('000000' + CAST([sJOBH].[run_duration] AS VARCHAR(6)),  6)
               , 3, 0, ':')
           , 6, 0, ':')
       AS [LastRunDuration (HH:MM:SS)]
   , [sJOBH].[message] AS [LastRunStatusMessage]
   , CASE [sJOBSCH].[NextRunDate]
       WHEN 0 THEN NULL
       ELSE CAST(
               CAST([sJOBSCH].[NextRunDate] AS CHAR(8))
               + ' '
               + STUFF(
                   STUFF(RIGHT('000000' + CAST([sJOBSCH].[NextRunTime] AS VARCHAR(6)),  6)
                       , 3, 0, ':')
                   , 6, 0, ':')
               AS DATETIME)
     END AS [NextRunDateTime]
FROM
   [msdb].[dbo].[sysjobs] AS [sJOB]
   LEFT JOIN (
               SELECT
                   [job_id]
                   , MIN([next_run_date]) AS [NextRunDate]
                   , MIN([next_run_time]) AS [NextRunTime]
               FROM [msdb].[dbo].[sysjobschedules]
               GROUP BY [job_id]
           ) AS [sJOBSCH]
       ON [sJOB].[job_id] = [sJOBSCH].[job_id]
   LEFT JOIN (
               SELECT
                   [job_id]
                   , [run_date]
                   , [run_time]
                   , [run_status]
                   , [run_duration]
                   , [message]
                   , ROW_NUMBER() OVER (
                                           PARTITION BY [job_id]
                                           ORDER BY [run_date] DESC, [run_time] DESC
                     ) AS RowNumber
               FROM [msdb].[dbo].[sysjobhistory]
               WHERE [step_id] = 0
           ) AS [sJOBH]
       ON [sJOB].[job_id] = [sJOBH].[job_id]
       AND [sJOBH].[RowNumber] = 1
ORDER BY [JobName]
