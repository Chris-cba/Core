----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm4800_system.sql-arc   1.0   Jan 09 2019 10:25:36   Chris.Baugh  $
--       Module Name      : $Workfile:   nm4800_system.sql  $ 
--       Date into PVCS   : $Date:   Jan 09 2019 10:25:36  $
--       Date fetched Out : $Modtime:   Nov 13 2018 15:21:40  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Identify Highways Owner
--
undefine p_highways_owner

ACCEPT p_highways_owner   char prompt 'ENTER THE NAME OF THE HIGHWAYS OWNER   : '

--
-- Grab date/time to append to log file name
--
UNDEFINE log_extension
COL      log_extension NEW_VALUE log_extension NOPRINT
SET TERM OFF
SELECT  TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS') || '.LOG' log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
--
-- Spool to Logfile
--
DEFINE logfile1='nm4800_system_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;

SELECT 'Install Running on ' || LOWER(USER || '@' || instance_name || '.' || host_name) || ' - DB ver : ' || version
FROM v$instance;
--
BEGIN
 --
 -- Ensure this script is being run as SYSTEM User
 --
 IF USER != 'SYSTEM'
 THEN
	RAISE_APPLICATION_ERROR(-20000, 'This script must be run as SYSTEM User');
 END IF;

END;
/
 
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Header hig_process_admin
SET TERM OFF
--
SET FEEDBACK ON
start hig_process_admin.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Body Header hig_process_admin
SET TERM OFF
--
SET FEEDBACK ON
start hig_process_admin.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Grant privileges for SYSTEM objects
--------------------------------------------------------------------------------
--
DECLARE
 role_exists exception;
 pragma exception_init (role_exists,-1921);
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE PROCESS_ADMIN';
EXCEPTION
  WHEN role_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/

rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO Alert Admin Users

prompt CREATE ROLE ALERT_ADMIN;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE ALERT_ADMIN';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/
--
GRANT CREATE TRIGGER TO ALERT_ADMIN;
GRANT DROP ANY TRIGGER TO ALERT_ADMIN;
--

rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR Allowing user proxying

prompt CREATE ROLE EXOR_ALLOW_USER_PROXY;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE EXOR_ALLOW_USER_PROXY';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR to define a Proxy Owner

prompt CREATE ROLE PROXY_OWNER;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE PROXY_OWNER';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE PROCESS_ADMIN';
  EXCEPTION
    WHEN role_exists
    THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT CREATE ANY JOB TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT CREATE EXTERNAL JOB TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT MANAGE SCHEDULER TO PROCESS_ADMIN';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/

DECLARE
   lv_highways_owner Varchar2(100) := UPPER('&p_highways_owner');
BEGIN
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CRYPTO TO ' || lv_highways_owner;
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CRYPTO TO HIG_ADMIN';
  EXECUTE IMMEDIATE 'GRANT SELECT ON PROXY_USERS TO HIG_USER';
  EXECUTE IMMEDIATE 'GRANT SELECT ON SYS.USER$ TO ' || lv_highways_owner;
  EXECUTE IMMEDIATE 'Grant Select On Sys.Dba_Role_Privs To Exor_Core';
  EXECUTE IMMEDIATE 'Grant Select On Sys.user$ To Exor_Core';
  EXECUTE IMMEDIATE 'GRANT PROCESS_ADMIN to '||lv_highways_owner;
  EXECUTE IMMEDIATE 'GRANT PROCESS_ADMIN to '||lv_highways_owner||' WITH ADMIN OPTION';
END;
/

-- Object privileges granted to PROCESS_ADMIN
GRANT EXECUTE ON HIG_PROCESS_ADMIN TO PROCESS_ADMIN;

-- System privileges granted to PROCESS_ADMIN
GRANT ALTER SYSTEM TO PROCESS_ADMIN;

-- Due Oracle 12c limitations need to grant role here
GRANT PROCESS_ADMIN TO SYSTEM;

-- Code Grantees of PROCESS_ADMIN
GRANT PROCESS_ADMIN TO PACKAGE HIG_PROCESS_ADMIN;

SET TERM ON 
PROMPT Granting Privileges
SET TERM OFF
SET VERIFY OFF


-- Code Grantees of PROCESS_ADMIN
DECLARE
 synonym_exists exception;
 pragma exception_init (synonym_exists,-955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM hig_process_admin FOR hig_process_admin';
EXCEPTION
  WHEN synonym_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/
--
SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
