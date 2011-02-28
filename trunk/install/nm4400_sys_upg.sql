--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4400_sys_upg.sql-arc   3.0   Feb 28 2011 15:34:14   Ade.Edwards  $
--       Module Name      : $Workfile:   nm4400_sys_upg.sql  $
--       Date into PVCS   : $Date:   Feb 28 2011 15:34:14  $
--       Date fetched Out : $Modtime:   Feb 28 2011 15:33:20  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
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

