----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix58_sys.sql-arc   1.1   Jul 20 2018 11:01:54   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix58_sys.sql  $ 
--       Date into PVCS   : $Date:   Jul 20 2018 11:01:54  $
--       Date fetched Out : $Modtime:   Jul 19 2018 09:50:54  $
--       Version     	  : $Revision:   1.1  $
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
DEFINE logfile1='nm_4700_fix58_sys_&log_extension'
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
 -- Ensure this script is being run as SYS User
 --
 IF USER != 'SYS'
 THEN
	RAISE_APPLICATION_ERROR(-20000, 'This script must be run as SYS User');
 END IF;

END;
/
 
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Create public synonyms for SYS objects
--------------------------------------------------------------------------------
--

SET TERM ON 
PROMPT Creating Public Synonyms
SET TERM OFF
--
DECLARE
 synonym_exists exception;
 pragma exception_init (synonym_exists,-955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM proxy_users FOR proxy_users';
EXCEPTION
  WHEN synonym_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/
--
--------------------------------------------------------------------------------
-- Grant privileges for SYS objects
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Granting Privileges
SET TERM OFF

BEGIN
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CRYPTO TO SYSTEM WITH GRANT OPTION';
  EXECUTE IMMEDIATE 'GRANT SELECT ON PROXY_USERS TO SYSTEM WITH GRANT OPTION';
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
