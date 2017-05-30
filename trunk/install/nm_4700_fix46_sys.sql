----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix46_sys.sql-arc   1.0   May 30 2017 16:29:46   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix46_sys.sql  $ 
--       Date into PVCS   : $Date:   May 30 2017 16:29:46  $
--       Date fetched Out : $Modtime:   Mar 15 2017 15:24:04  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
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
DEFINE logfile1='nm_4700_fix46_sys_&log_extension'
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
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT exor_password_engine.pkh
SET TERM OFF
--
SET FEEDBACK ON
start exor_password_engine.pkh
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT exor_password_engine.pkw
SET TERM OFF
--
SET FEEDBACK ON
start exor_password_engine.pkw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT f_password_verify.fnw
SET TERM OFF
--
SET FEEDBACK ON
start f_password_verify.fnw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Create Profile to enforce password complexity
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating ENFORCE Profile
SET TERM OFF

DECLARE
 profile_exists exception;
 pragma exception_init (profile_exists,-2379);

BEGIN
  execute immediate 'CREATE PROFILE ENFORCE    LIMIT'||
                    '               IDLE_TIME                 20'||
                    '               FAILED_LOGIN_ATTEMPTS     5'||
                    '               PASSWORD_LIFE_TIME        90'||
                    '               PASSWORD_REUSE_TIME       90'||
                    '               PASSWORD_REUSE_MAX        UNLIMITED'||
                    '               PASSWORD_VERIFY_FUNCTION  F_PASSWORD_VERIFY'||
                    '               PASSWORD_LOCK_TIME        DEFAULT'||
                    '               PASSWORD_GRACE_TIME       10';
EXCEPTION
  WHEN profile_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/

--
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

  EXECUTE IMMEDIATE 'GRANT EXECUTE ON exor_password_engine TO ' || username;
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON f_password_verify TO ' || username;
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CRYPTO TO ' || username;
  EXECUTE IMMEDIATE 'GRANT ALTER PROFILE TO ' || username;

END;
/
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
  EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM exor_password_engine FOR exor_password_engine';
EXCEPTION
  WHEN synonym_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/

DECLARE
 synonym_exists exception;
 pragma exception_init (synonym_exists,-955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM f_password_verify FOR f_password_verify';
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
