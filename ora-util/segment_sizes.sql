accept owner prompt 'Enter owner:'
accept table_name prompt 'Enter table_name:'


variable b1 varchar2(40);
variable b2 varchar2(40);
begin
  :b1 := upper('&owner');
  :b2 := upper('&table_name');
end;
/


select s.segment_name, trunc(s.bytes/1024/1024) mb, s.tablespace_name, s.owner
from dba_segments s 
where  s.owner = :b1
and s.segment_name = :b2
or s.segment_name in (
    select index_name 
    from dba_indexes i 
    join dba_segments s on s.owner = i.owner and s.segment_name = i.table_name
    where i.owner = :b1 and i.table_name = :b2
);

undefine :b1
undefine :b2
