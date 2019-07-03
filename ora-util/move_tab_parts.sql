col partition_name for a15
col table_name for a30
col index_name for a20
col table_owner for a20
col hi_value for a25
col owner for a30
col pos for 9999
set lines 200

accept owner prompt 'Enter owner:'
accept table_name prompt 'Enter table_name:'

variable b1 varchar2(40);
variable b2 varchar2(40);
begin
  :b1 := '&owner';
  :b2 := '&table_name';
end;
/

declare
    cursor c1 is
    select p.partition_position pos,
       p.table_owner,
       p.table_name,
       p.partition_name,
       p.tablespace_name,
       p.high_value,
       s.BYTES / 1024/1024 size_mb
from  dba_segments s
join dba_tab_partitions p
on s.owner = p.table_owner
and s.segment_name = p.table_name
and s.partition_name = p.partition_name
where p.table_owner = upper(:b1)
and p.table_name = upper(:b2)
and s.BYTES > 1024*1024*1024
order by 1;    
begin
for i in c1 loop
    if substr(i.high_value, 1,20) <= to_char(sysdate, 'YYYY') || lpad(to_char(sysdate-21, 'WW'), 2, '0') then
        dbms_output.put_line(i.table_owner || '.' || i.table_name || ',' || i.partition_name || ',' || i.high_value || ',' || i.tablespace_name || ',' ||i.size_mb);
    end if;
end loop;
dbms_output.put_line('---');
dbms_output.put_line('DDL');
dbms_output.put_line('---');
for i in c1 loop
    if substr(i.high_value, 1,20) <= to_char(sysdate, 'YYYY') || lpad(to_char(sysdate-21, 'WW'), 2, '0') then
        dbms_output.put_line('alter table ' || i.table_owner || '.' || i.table_name || ' move partition ' || i.partition_name || ' update indexes;');
    end if;
end loop;
end;
/


undefine b1
undefine b2
