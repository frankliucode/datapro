set feedback off ver off

define BEGIN_TIME=&1

set lines 200
col BEGIN_INTERVAL_TIME for a30
col END_INTERVAL_TIME for a30

select dbid, snap_id, BEGIN_INTERVAL_TIME, END_INTERVAL_TIME 
  from dba_hist_snapshot 
 where begin_interval_time > to_date('&&BEGIN_TIME', 'yyyymmdd-hh24mi') 
   and begin_interval_time < to_date('&&BEGIN_TIME', 'yyyymmdd-hh24mi') + 4/24
order by 2 desc
;

undefine 1 BEGIN_TIME


