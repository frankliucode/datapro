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

with 
  function part_high_value(tab_name varchar2, part_name varchar2) 
  return varchar2 is
    h_value varchar2(256);
  begin
    select high_value
      into h_value
      from dba_tab_partitions p
     where p.table_name = tab_name
       and p.partition_name = part_name;
    return h_value;
  end;
select p.partition_position pos,
       p.table_owner,
       p.table_name,
       p.partition_name,
       substr(part_high_value(p.table_name, p.partition_name), 1, 20) hi_value,
       p.tablespace_name,
       trunc(s.BYTES / 1024/1024) size2_mb
from  dba_segments s
join dba_tab_partitions p
on s.owner = p.table_owner
and s.segment_name = p.table_name
and s.partition_name = p.partition_name
where p.table_owner = upper(:b1)
and p.table_name = upper(:b2)
order by 1
/

col partition_position for 9999

with 
  function part_high_value(ind_name varchar2, part_name varchar2) 
  return varchar2 is
    h_value varchar2(256);
  begin
    select high_value
      into h_value
      from dba_ind_partitions p
     where p.index_name = ind_name
       and p.partition_name = part_name;
    return h_value;
  end;
select p.partition_position pos,
       i.OWNER,
       i.TABLE_NAME,
       i.INDEX_NAME,
       p.partition_name,
       p.tablespace_name,
       substr(part_high_value(p.index_name, p.partition_name), 1, 20) hi_value,
       trunc(s.BYTES/1024/1024) size_mb
from dba_segments s
join dba_ind_partitions p
on s.owner = p.index_owner
and s.segment_name = p.index_name
and s.partition_name = p.partition_name
join dba_indexes i on i.OWNER= p.index_owner
and i.INDEX_NAME = p.index_name
where i.TABLE_OWNER = upper(:b1) 
and i.TABLE_NAME = upper(:b2)
order by 1
/

undefine b1
undefine b2
