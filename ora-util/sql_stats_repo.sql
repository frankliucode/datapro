
SET TERM ON ECHO OFF
PRO
PRO Parameter sql_id:
PRO sql_id (required)
PRO
DEF sql_id = '&sql_id';
PRO

set pages 9999
set lines 200
col plan_hash for 99999999999999999
col sql_id for a30
col duration for 9999999999
alter session set nls_date_format = "yyyymmdd-hh24:mi:ss";

select
  r.period_start_time,
  r.period_end_time,
  r.report_id,
  key1 SQL_ID,
  EXTRACTVALUE(XMLType(report_summary),'/report_repository_summary/sql/stats/stat[@name="duration"]') duration,
  EXTRACTVALUE(XMLType(report_summary),'/report_repository_summary/sql/plan_hash') plan_hash
from dba_hist_reports r
where component_name= 'sqlmonitor' and key1 = '&&sql_id'
order by 1
;
