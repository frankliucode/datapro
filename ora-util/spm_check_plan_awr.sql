accept sql_id prompt 'Enter sql_id:'

variable b1 varchar2(40);
begin
  :b1 := '&sql_id';
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
from table(dbms_xplan.DISPLAY_AWR(
     sql_id => :b1,
     --plan_hash_value => 3001039988,
     format => 'ADVANCED'))     
;  

undefine b1

