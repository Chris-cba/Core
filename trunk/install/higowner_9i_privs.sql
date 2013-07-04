--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/higowner_9i_privs.sql-arc   2.1   Jul 04 2013 13:45:30   James.Wadsworth  $
--       Module Name      : $Workfile:   higowner_9i_privs.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:01:12  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
define sccsid = '"@(#)higowner_9i_privs.sql	1.2 11/28/03"'
prompt
prompt Highways Owner 9i Privileges Grant Script
prompt Exor Corporation 2003
prompt
undefine p_user
ACCEPT p_user char prompt 'Please enter the username of the Highways owner: ';
--
prompt
SET verify OFF
SET feedback OFF
Set serverout on size 1000000
DECLARE
  p_user varchar2(100) := UPPER('&P_USER');
BEGIN
  IF USER <> 'SYSTEM'
  THEN
    Raise_Application_Error(-20000, 'This script must be run as SYSTEM.');
  END IF;
  
  EXECUTE IMMEDIATE 'grant select any dictionary to ' || p_user || ' with admin option';
  EXECUTE IMMEDIATE 'grant execute on dbms_pipe to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant execute on dbms_rls to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant execute on dbms_lock to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_sys_privs to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_tab_privs to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_users to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_role_privs to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_ts_quotas to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_roles to ' || p_user || ' with grant option';
  EXECUTE IMMEDIATE 'grant select on dba_profiles to ' || p_user || ' with grant option';
  dbms_output.put_line('Grants complete.');
END;
/
Set serverout off
prompt
