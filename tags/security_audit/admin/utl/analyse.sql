--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/analyse.sql-arc   2.2   Apr 13 2018 12:53:20   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   analyse.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:20  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
set feedback off
set lines 132
set pages 0
--
spool temp.ana
SELECT 'ANALYZE '||object_type||' '||object_name||' COMPUTE STATISTICS;'
from user_objects
where object_type IN ('TABLE','INDEX')
ORDER BY DECODE(object_type
               ,'TABLE',1
               ,'INDEX',2
               ,3
               )
        ,object_name;
spool off
--
prompt .
prompt Doing the analyse statements, this may take some time
prompt .
--
@temp.ana
--
host del temp.ana
--
set pages 50
set feedback on
--
