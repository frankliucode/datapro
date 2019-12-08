SELECT 
    a.inst_id,
    substr(DECODE(request,0,'Holder: ','Waiter: ')||a.sid,1,15) sess, 
    b.serial#, 
    a.type, 
    a.id1, 
    a.id2, 
    a.lmode, 
    a.request,
    a.block, 
    a.ctime, 
    b.username, 
    b.status, 
    b.sql_id, 
    b.prev_sql_id, 
    b.ROW_WAIT_OBJ#
from gv$session b,
    (select distinct b.*
       from gv$lock a,
            gv$lock b
      where a.id1 = b.id1
        and a.id2 = b.id2
        and a.request > 0) a
where a.sid = b.sid
and a.inst_id = b.inst_id
order by a.id1, a.id2, a.block desc, ctime
;

