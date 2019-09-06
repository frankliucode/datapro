set lines 200

col sql_txt for a20
col execs for 99999999
col plan_hash_value for 9999999999999
col parsing_schema_name for a15
col elapsed_time_secs for 9999999.99
col cpu_time_secs for 9999999.99

SELECT
     sql_id,
     plan_hash_value,
     --first_load_time,
     executions as execs,
     parsing_schema_name,
     round(elapsed_time  / 1000000, 2) as elapsed_time_secs,
     cpu_time / 1000000 as cpu_time_secs,
     --buffer_gets,
     --disk_reads,
     --direct_writes,
     --rows_processed,
     fetches,
     --optimizer_cost,
     dbms_lob.substr(sql_text, 20) sql_txt
   FROM TABLE(DBMS_SQLTUNE.SELECT_SQLSET(
        sqlset_name => '&&1',
        sqlset_owner => 'SYSTEM'
   ))
   where sql_id = '&&2'
;



select plan_table_output 
from table(dbms_xplan.DISPLAY_SQLSET(
     sqlset_name => '&&1',
     sql_id => '&&2',
     --plan_hash_value => 3001039988,
     format => 'TYPICAL',
     sqlset_owner => 'SYSTEM'))
;


