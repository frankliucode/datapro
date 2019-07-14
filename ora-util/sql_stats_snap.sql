alter session set nls_date_format="yyyy-mm-dd hh24:mi:ss";

accept sql_id prompt 'Enter sql_id: '

col begin_interval_time for a30
col avg for 99999.9
col elapsed for 9999999.9
col sql_profile for a30
select s.snap_id, 
       h.begin_interval_time,
       s.sql_id,              
       s.plan_hash_value,
       s.instance_number,
       round(s.elapsed_time_delta/1000000, 1) elapsed,
       s.executions_delta,
       round(s.elapsed_time_delta/s.executions_delta/1000000, 1) avg,
       s.sql_profile
from dba_hist_sqlstat s 
join dba_hist_snapshot h on s.snap_id = h.snap_id 
and s.instance_number = h.instance_number
where s.sql_id = '&&sql_id'
order by 1
;
