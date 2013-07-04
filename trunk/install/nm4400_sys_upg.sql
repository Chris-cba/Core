--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4400_sys_upg.sql-arc   3.1   Jul 04 2013 14:19:46   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4400_sys_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:19:46  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:18:58  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
PROMPT
PROMPT Highways SYS grants upgrade script
PROMPT Bentley Systems 2011
PROMPT
--
BEGIN
--
  IF USER <> 'SYS'
  THEN
    Raise_Application_Error(-20000, 'This script must be run as SYS');
  END IF;
--
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_NETWORK_ACL_ADMIN TO SYSTEM WITH GRANT OPTION';
--
  FOR i IN (
      SELECT 'GRANT EXECUTE ON DBMS_NETWORK_ACL_ADMIN TO '||owner||' WITH GRANT OPTION' l_sql
        FROM dba_objects
       WHERE object_type = 'TABLE'
         AND object_name = 'HIG_USERS'
  )
  LOOP
    EXECUTE IMMEDIATE i.l_sql;
  END LOOP;
--
END;
/

