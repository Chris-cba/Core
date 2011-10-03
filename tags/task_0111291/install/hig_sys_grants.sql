-------------------------------------------------------------------------------
--
-- hig_sys_grants.sql
--
-- On Oracle 9i the highways owner requires certain extra privileges.
-- These privileges are owned by SYS and so can not noramlly be granted by 
-- the higowner script which runs as SYSTEM.
--
-- This script grants the required privileges to SYSTEM with the admin option
-- so that it can regrant them to any highways owners that are created.
--
-------------------------------------------------------------------------------
REM SCCS ID Keyword, do no remove
define sccsid = '"@(#)hig_sys_grants.sql	1.4 11/28/03"';
--
prompt
prompt Highways SYS grants script
prompt Exor Corporation 2003
prompt
--
BEGIN
  IF USER <> 'SYS'
  THEN
    Raise_Application_Error(-20000, 'This script must be run as SYS');
  END IF;
  
  EXECUTE IMMEDIATE 'grant select any dictionary to system with admin option';
  EXECUTE IMMEDIATE 'grant execute on dbms_pipe to system with grant option';
  EXECUTE IMMEDIATE 'grant execute on dbms_rls to system with grant option';
  EXECUTE IMMEDIATE 'grant execute on dbms_lock to system with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_sys_privs to system with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_tab_privs to system with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_users to system with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_role_privs to system with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_ts_quotas to system with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_roles to system with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_profiles to system with grant option';
  EXECUTE IMMEDIATE 'grant execute on dbms_scheduler to system with grant option';
  EXECUTE IMMEDIATE 'grant execute on dbms_network_acl_admin to system with grant option';  -- Task 0110486 - ACL in 11gr2
  EXECUTE IMMEDIATE 'Grant Select on Sys.Dba_Scheduler_Jobs To Exor_Core';
END;
/
