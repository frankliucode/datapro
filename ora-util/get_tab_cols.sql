set heading off
set feedback off
set termout off
set trims on
set linesize 300
set pagesize 0


spool _tab_cols_.txt


select c.OWNER || ',' || 
       c.TABLE_NAME || ',' ||
       c.COLUMN_NAME || ',' ||
       c.DATA_TYPE || ',' ||
       c.DATA_LENGTH || ',' ||
       nvl2(c.DATA_PRECISION, to_char(c.DATA_PRECISION), '-') || ',' ||
       nvl2(c.DATA_SCALE, to_char(c.DATA_SCALE), '-') || ',' || 
       c.NULLABLE
from dba_tab_columns c 
where c.owner = upper('&1')
and c.TABLE_NAME = upper('&2') 
order by c.COLUMN_ID
;


quit
