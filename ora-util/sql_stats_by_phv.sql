accept phv prompt 'Enter plan_hash_value:'

variable b1 varchar2(40);
begin
  :b1 := &phv;
end;
/

set lines 150
set pages 9999
col begin_interval_time for a30
col sql_profile for a30
col inst_id for 99
select s.snap_id, 
       h.begin_interval_time,
       s.sql_id,              
       s.plan_hash_value,
       --s.instance_number inst_id,
       round(s.elapsed_time_delta/1000000, 1) elapsed,
       s.executions_delta execs,
       round(s.elapsed_time_delta/s.executions_delta/1000000, 4) avg,
       s.sql_profile
from dba_hist_sqlstat s 
join dba_hist_snapshot h on s.snap_id = h.snap_id 
and s.instance_number = h.instance_number
where s.executions_delta > 0
--and s.sql_id = :b1
and s.snap_id > 75800
and s.plan_hash_value = :b1 
order by 1
;

undefine b1
