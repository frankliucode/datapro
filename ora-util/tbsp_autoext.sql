SET DEF ON TERM OFF ECHO ON FEED OFF
set serveroutput on size unlimited
SET TERM ON ECHO OFF
PRO
PRO Parameter 1:
PRO tbsp_name (required)
PRO
DEF tbsp_name = '&1';
PRO
PRO Parameter 2:
PRO max_size (required)
PRO
DEF max_size = '&2';
PRO

DECLARE
  v_str VARCHAR2(200);
  v_bigfile VARCHAR2(10);
  v_max VARCHAR2(10);
begin
  select bigfile
  into v_bigfile
  from dba_tablespaces
  where tablespace_name = upper('&&tbsp_name')
  ;

  if v_bigfile = 'NO' then
    v_max := '32000M';
  else
    v_max := '&&max_size';
  end if;

  FOR i IN (SELECT file_name
              FROM dba_data_files
             WHERE tablespace_name = upper('&&tbsp_name.')
             )
  LOOP
    v_str := 'alter database datafile ''' || i.file_name || ''' autoextend on next 10M maxsize ' || v_max;
    dbms_output.put_line(v_str);
    EXECUTE IMMEDIATE v_str;
  END LOOP;
end;
/
