----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix58_system.sql-arc   1.0   Jul 20 2018 10:58:34   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix58_system.sql  $ 
--       Date into PVCS   : $Date:   Jul 20 2018 10:58:34  $
--       Date fetched Out : $Modtime:   Jul 19 2018 10:47:44  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
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
DEFINE logfile1='nm_4700_fix58_system_&log_extension'
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
-- Grant privileges for SYS objects
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Granting Privileges
SET TERM OFF

DECLARE
  username hig_users.hus_username%TYPE;
BEGIN
  SELECT hus_username 
  INTO username
  FROM hig_users 
  WHERE hus_is_hig_owner_flag = 'Y';

  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CRYPTO TO ' || username;
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CRYPTO TO HIG_ADMIN';
  EXECUTE IMMEDIATE 'GRANT SELECT ON PROXY_USERS TO HIG_USER';

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
