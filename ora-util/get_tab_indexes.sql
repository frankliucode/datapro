set heading off
set feedback off
set termout off
set trims on
set linesize 300
set pagesize 0

spool _tab_indexes_.txt

select i.owner || ',' ||
       i.index_name || ',' || 
       nvl(c.constraint_type, 'I')
  from dba_indexes i 
left join dba_constraints c on i.index_name = c.constraint_name and i.owner = c.owner
 where i.owner = upper('&1') 
   and i.table_name = upper('&2')
;

spool off

quit


