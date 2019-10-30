set heading off
set feedback off
set termout off
set trims on
set linesize 300
set pagesize 0

spool _tab_cons_.txt

select c1.owner || ',' ||
       c1.table_name || ',' ||
       c1.constraint_type || ',' ||
       c1.constraint_name || ',' ||
       cc1.column_name || ',' ||
       cc1.position || ',' ||
       c2.table_name || ',' ||
       cc2.column_name || ',' ||
       i.tablespace_name
from dba_constraints c1 
left join dba_constraints c2 
      on c1.r_constraint_name = c2.constraint_name 
     and c1.owner = c2.owner
left join dba_cons_columns cc1 
      on c1.constraint_name = cc1.constraint_name 
     and c1.owner = cc1.owner
left join dba_cons_columns cc2 
      on c2.constraint_name = cc2.constraint_name 
     and c2.owner = cc2.owner
left join dba_indexes i 
      on i.index_name = c1.constraint_name 
     and c1.constraint_type = 'P'
     and c1.owner = i.owner
where c1.owner = '&1'
  and c1.table_name = '&2'
  and c1.constraint_type in ('R', 'P')
order by c1.constraint_type, 
         c1.constraint_name, 
         cc1.position
;

spool off
quit

