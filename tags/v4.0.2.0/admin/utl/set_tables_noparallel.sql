REM Copyright (c) Exor Corporation Ltd, 2004
REM @(#)set_tables_noparallel.sql	1.2 05/26/05

set echo off
set linesize 120
set heading off
set feedback off
--
---------------------------------------------------------------------------------------------------
--
DECLARE

  CURSOR c1 IS
  SELECT 'alter table '||table_name||' noparallel' v_sql
  FROM   user_tables
  WHERE  table_name like 'BATCH%'
  OR     table_name like 'CSV_%'
  OR     table_name like 'SWR%';
  
BEGIN

 FOR v_recs IN c1 LOOP
 
   EXECUTE IMMEDIATE(v_recs.v_sql);
  
 END LOOP;

END;
/
