accept sql_id prompt 'enter sql_id:'

column filename new_val filename

SET TRIMSPOOL ON
SET TRIM ON
SET PAGES 0
SET LINESIZE 1000
SET LONG 1000000
SET LONGCHUNKSIZE 1000000

variable b1 VARCHAR2(30);

begin
    :b1 := '&sql_id';
end;
/

select 'sqlmon_' || to_char(sysdate, 'dd_hh24miss_') || :b1 || '.html' filename from dual;

SPOOL &filename
SELECT DBMS_SQL_MONITOR.REPORT_SQL_MONITOR(
    sql_id => :b1,
    report_level => 'ALL',
    TYPE => 'active')
FROM DUAL;
SPOOL OFF

