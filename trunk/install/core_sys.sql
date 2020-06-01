----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/core_sys.sql-arc   1.0   Jun 01 2020 14:14:52   Chris.Baugh  $
--       Module Name      : $Workfile:   core_sys.sql  $ 
--       Date into PVCS   : $Date:   Jun 01 2020 14:14:52  $
--       Date fetched Out : $Modtime:   May 12 2020 13:38:28  $
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
SET VERIFY OFF

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
DEFINE logfile1='core_sys_&log_extension'
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

grant execute on dbms_crypto to system with grant option;
grant select on proxy_users to system with grant option;
grant select on sys.user$ to system with grant option;
grant select on dba_role_privs to system with grant option;


--
SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
