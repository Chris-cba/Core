--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/system_objects.sql-arc   1.0   Jan 09 2019 10:29:58   Chris.Baugh  $
--       Module Name      : $Workfile:   system_objects.sql  $
--       Date into PVCS   : $Date:   Jan 09 2019 10:29:58  $
--       Date fetched Out : $Modtime:   Jul 05 2018 08:52:02  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
prompt Creating System Objects

@@hig_process_admin.pkh

@@hig_process_admin.pkw

prompt Creating Process Admin Role
   
DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE process_admin';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

GRANT EXECUTE ON HIG_PROCESS_ADMIN TO PROCESS_ADMIN;
GRANT ALTER SYSTEM TO PROCESS_ADMIN;
GRANT PROCESS_ADMIN TO PACKAGE HIG_PROCESS_ADMIN;
CREATE OR REPLACE PUBLIC SYNONYM hig_process_admin FOR hig_process_admin;
