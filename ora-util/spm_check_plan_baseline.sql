accept sql_handle prompt 'Enter sql_handle:'
accept plan_name prompt 'Enter plan_name:'

variable b1 varchar2(40);
variable b2 varchar2(40);
begin
  :b1 := '&sql_handle';
  :b2 := '&plan_name';
end;
/


set lines 200

col sql_txt for a20
col execs for 99999999
col plan_hash_value for 9999999999999
col parsing_schema_name for a15
col elapsed_time_secs for 9999999.99
col cpu_time_secs for 9999999.99


select plan_table_output 
from table(dbms_xplan.DISPLAY_SQL_PLAN_BASELINE(
     sql_handle => :b1,
     plan_name  => :b2,
     --plan_hash_value => 3001039988,
     format => 'ADVANCED'))
;

undefine b1
undefine b2

