CREATE OR REPLACE PACKAGE BODY hig_process_admin
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/hig_process_admin.pkb-arc   1.0   Jun 18 2018 16:26:44   Chris.Baugh  $
  --       Module Name      : $Workfile:   hig_process_admin.pkb  $
  --       Date into PVCS   : $Date:   Jun 18 2018 16:26:44  $
  --       Date fetched Out : $Modtime:   Feb 06 2018 11:18:48  $
  --       Version          : $Revision:   1.0  $
  --       Based on SCCS version :
  ------------------------------------------------------------------
  --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  --all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

  g_package_name   CONSTANT VARCHAR2 (30) := 'hig_relationship_api';

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION scheduler_disabled
    RETURN VARCHAR2 
  IS
    --
    lv_retval             VARCHAR2(5);
    --
  BEGIN
    --
    SELECT DECODE(value, 0, 'TRUE', 'FALSE')
      INTO lv_retval
      FROM v$parameter 
     WHERE name= 'job_queue_processes';
   
    RETURN lv_retval;
    --
  END scheduler_disabled;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION pluggable_database
    RETURN BOOLEAN 
  IS
    --
    not_container_db EXCEPTION;
    PRAGMA EXCEPTION_INIT (not_container_db,-2003);
    --
    lv_database_type             VARCHAR2(11);
    --
  BEGIN
    --
    SELECT DECODE(SYS_CONTEXT('USERENV','CON_ID'),1,'CDB',0,'NOCONTAINER','PDB') TYPE 
      INTO lv_database_type
      FROM DUAL;
   
    IF lv_database_type = 'PDB'
    THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
    --
  EXCEPTION
    WHEN not_container_db
      THEN
        RETURN FALSE;
    WHEN OTHERS
      THEN
        RAISE;
  END pluggable_database;
--
-----------------------------------------------------------------------------
--
  PROCEDURE set_scheduler_state(pi_scheduler_state  VARCHAR2)
  IS
    --
    CURSOR check_role IS
    SELECT 1
      FROM dba_role_privs
     WHERE granted_role = 'PROCESS_ADMIN'
       AND grantee = Sys_Context('NM3_SECURITY_CTX','USERNAME');
    --
    lv_dummy      VARCHAR2(1);
    lv_row_found  BOOLEAN;
    --
  BEGIN
    --
    OPEN check_role;
    FETCH check_role INTO lv_dummy;
    lv_row_found := check_role%FOUND;
    CLOSE check_role;
    --
    IF NOT lv_row_found
    THEN
      --
      raise_application_error(-20001,'User must be assigned PROCESS_ADMIN Role to perform this function');
      --
    END IF;
    --
    IF pi_scheduler_state = 'UP'
    THEN
      --
      EXECUTE IMMEDIATE 'alter system set job_queue_processes=4000 container=current';
      --
    ELSIF pi_scheduler_state = 'DOWN'
    THEN
      --
      EXECUTE IMMEDIATE 'alter system set job_queue_processes=0 container=current';
      --
    END IF;
    --
  END set_scheduler_state;
--
-----------------------------------------------------------------------------
--

END hig_process_admin;
/