set heading off
set feedback off
set termout off
set trims on
set linesize 300
set pagesize 0

spool _tab_ref_cons_.txt

select c2.owner || ',' || 
       c2.table_name || ',' || 
       c2.constraint_name || ',' || 
       cc2.column_name || ',' || 
       c1.table_name || ',' || 
       cc1.column_name
  from dba_constraints c1
  join dba_constraints c2 on c1.constraint_name = c2.r_constraint_name and c1.owner = c2.owner
  join dba_cons_columns cc1 on c1.constraint_name = cc1.constraint_name and c1.owner = cc1.owner
  join dba_cons_columns cc2 on c2.constraint_name = cc2.constraint_name and c2.owner = cc2.owner
 where c1.owner = upper('&1')
   and c1.table_name = upper('&2')
   and c1.constraint_type = 'P'
;

spool off
quit

