
set linesize 150

col snap_id format 9999999;
col rtime format a20;
col name format a16;
col total_mb format 999999;
col used_mb format 999999;
col free_mb format 999999;
col pct format 99.9;


select u.snap_id,
       u.rtime,
       ts.NAME,
       u.tablespace_size / 128 total_mb,
       u.tablespace_usedsize / 128 used_mb,
       (u.tablespace_size - u.tablespace_usedsize) / 128 free_mb,
       u.tablespace_usedsize * 100 / u.tablespace_size pct
  from dba_hist_tbspc_space_usage u
  join v$tablespace ts
    on ts.TS# = u.tablespace_id
 where ts.NAME = upper('&1')
   and substr(u.rtime, 12, 2) = '07'
order by u.snap_id desc   
;



