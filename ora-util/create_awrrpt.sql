set heading off termout off echo off FEED OFF VER OFF TRIMS ON


set pages 9999
set lines 5000

DEF BEGIN_SNAP=&1
DEF END_SNAP=&2
DEF DBID=&3
DEF DBNAME=&4
DEF INST=&5

SPOOL &&DBNAME._awrrpt_&&BEGIN_SNAP..html

SELECT 
   output  
FROM    
   TABLE(
DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(
   l_dbid     => &&DBID,
   l_inst_num => &&INST,
   l_bid      => &&BEGIN_SNAP,
   l_eid      => &&END_SNAP
))
;

SPOOL OFF

undefine 1 BEGIN_SNAP
undefine 2 END_SNAP
undefine 3 DBID
undefine 4 DBNAME
undefine 5 INST
