accept sql_id prompt 'Enter sql_id:'

variable b1 varchar2(40);

begin
  :b1 := '&sql_id';
end;
/


set lines 200
set pages 9999

select plan_table_output 
from table(dbms_xplan.display_cursor(
     sql_id => :b1,
     format => 'ADVANCED'))
;

undefine b1
