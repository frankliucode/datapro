
column filename new_value filename noprint;

select '&1' || '_' || '&2' || '.txt' filename from dual;

SET SERVEROUTPUT ON SIZE 64000

spool &filename

declare 
  v_ddl clob;
  v_pos number;
  v_sql varchar(32767); 
begin
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);      
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'TABLESPACE',true);   
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',true);       
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);     
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'PRETTY',true);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'EXPORT',true);

  select dbms_metadata.get_ddl('TABLE', '&2', '&1')
    into v_ddl 
    from dual;



    v_sql := dbms_lob.substr(v_ddl, 32767);
    v_pos := instr(v_sql, CHR(00));
    dbms_output.put_line('--- ' || v_pos);
    dbms_output.put_line(v_sql);
    dbms_output.put_line('=======');
    v_sql := dbms_lob.substr(v_ddl, 32767, 32767);
    v_pos := instr(v_sql, CHR(00));
    dbms_output.put_line('--- ' || v_pos);
    dbms_output.put_line(v_sql);

end;
/

spool off

quit
