set lines 200
col name for a20
col owner for a15
col description for a30


select name,
       owner,
       description
  from dba_sqlset
;

