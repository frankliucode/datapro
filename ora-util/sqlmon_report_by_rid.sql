set trimspool on 
set trim on 
set verify off
set feedback off
set pages 0 
set linesize 1000 
set long 1000000 
set longchunksize 1000000 

accept report_id prompt 'enter report_id:'

variable b1 VARCHAR2(30);

begin
    :b1 := '&report_id';
end;
/

column filename new_val filename

select 'sqlmon_' || to_char(sysdate, 'dd_hh24miss_') || :b1 || '.html' filename from dual;
SPOOL &filename

SELECT DBMS_AUTO_REPORT.REPORT_REPOSITORY_DETAIL(RID => :b1, TYPE => 'active') FROM dual
;

spool off
 
