set heading off
set feedback off
set termout off
set trims on
set linesize 300
set pagesize 0

spool _tab_attr_.txt

select t.tablespace_name || ',' ||
       i.tablespace_name || ',' ||
       t.compression || ',' ||
       t.compress_for
  from dba_tables t
left join dba_constraints c on t.owner = c.owner  and t.table_name = c.table_name and c.constraint_type = 'P'
left join dba_indexes i on i.owner = c.owner and i.index_name = c.constraint_name
 where t.owner = upper('&1')
   and t.table_name = upper('&2');

spool off

quit

