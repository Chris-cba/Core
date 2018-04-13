--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/set_tables_noparallel.sql-arc   2.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   set_tables_noparallel.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:51:54  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM Copyright 2018 Bentley Systems Incorporated. All rights reserved.
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
