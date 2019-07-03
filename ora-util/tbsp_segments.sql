accept tbsp_name prompt 'Enter tbsp_name:'

variable b1 varchar2(40);
begin
  :b1 := upper('&tbsp_name');
end;
/

set lines 150
set pages 1000
col owner for a20
col segment_name for a30
col tablespace_name for a20
col mb for 99999999

select 
    owner, 
    segment_name, 
    trunc(bytes/1024/1024) mb, 
    tablespace_name 
from dba_segments 
where tablespace_name = :b1 
order by 3
;

undefine b1
