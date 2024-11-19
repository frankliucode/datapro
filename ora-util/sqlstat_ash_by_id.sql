select v.sql_id, v.start_time, v.end_time, 
    trunc((cast(v.end_time as date) - cast(v.start_time as date)) * 3600 * 24) elapsed, 
    sql_plan_hash_value 
from (
    select sql_id, sql_exec_id, 
        min(sql_exec_start) start_time, max(sample_time) end_time, 
        sql_plan_hash_value 
    from v$active_session_history 
    where sql_id in ( '0hqtgcgs2scny', 'dkd0wr1wx3a5m')
    group by sql_exec_id, sql_id, sql_plan_hash_value
    order by 1,2
) v
;
