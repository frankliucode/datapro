accept sql_set_name prompt 'Enter sql_set_name:'
accept sql_id prompt 'Enter sql_id:'
accept phv prompt 'Enter phv:'

variable b1 varchar2(40);
variable b2 varchar2(40);
variable b3 varchar2(40);
begin
  :b1 := '&sql_set_name';
  :b2 := '&phv';
  :b3 := '&sql_id';
end;
/


set serveroutput on

DECLARE
  my_plans pls_integer;
BEGIN
  my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(
       sqlset_name  => :b1, 
       sqlset_owner => 'SYSTEM',
       basic_filter => 'plan_hash_value = ''' || :b2 || ''' and sql_id = ''' || :b3 || ''''
     );
 dbms_output.put_line('created baseline: ' || my_plans);                           
END;
/


