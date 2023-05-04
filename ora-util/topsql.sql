

DEF OFFSET1=&1
DEF OFFSET2=&2
DEF RUN_TIME=&3

col osuser for a15

select 
    current_t, 
    sql_exec_start, 
    sql_id, 
    trunc((CAST(current_t AS DATE) - sql_exec_start) * (3600*24)) duration , 
    sql_plan_hash_value, --user_id
    osuser,
    sid,
    blocking_session,
    schemaname
from (
select 
    max(h.sample_time) current_t, 
    max(s.osuser) osuser,
    max(s.blocking_session) blocking_session,
    max(s.schemaname) schemaname,
    max(s.sid) sid,
    h.sql_exec_start, 
    h.sql_id, 
    h.sql_plan_hash_value--, user_id
from v$active_session_history h
left join v$session s on h.session_id = s.sid
where h.sample_time > sysdate - &&OFFSET1/1440
and h.sample_time < sysdate - &&OFFSET2/1440
--and sql_id in ('514gv6k2kttsb', '775z8tjnbkc4c', 'b7sz213t38ktt')
and h.sample_time > h.sql_exec_start + &&RUN_TIME/(1440*60)
group by h.sql_plan_hash_value, h.sql_exec_start, h.sql_id--, user_id
)
order by 1 desc, 2 desc
;

undefine 1 OFFSET1
undefine 2 OFFSET2
undefine 3 RUN_TIME

