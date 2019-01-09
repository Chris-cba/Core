----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm4800_exor_core.sql-arc   1.0   Jan 09 2019 10:25:36   Chris.Baugh  $
--       Module Name      : $Workfile:   nm4800_exor_core.sql  $ 
--       Date into PVCS   : $Date:   Jan 09 2019 10:25:36  $
--       Date fetched Out : $Modtime:   Jul 11 2018 14:09:14  $
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
DEFINE logfile1='nm4800_exor_core_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;
--
BEGIN
 --
 -- Ensure this script is being run as EXOR_CORE User
 --
 IF USER != 'EXOR_CORE'
 THEN
	RAISE_APPLICATION_ERROR(-20000, 'This script must be run as EXOR_CORE User');
 END IF;

END;
/
 
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body nm3ctx
SET TERM OFF
--
SET FEEDBACK ON
start nm3ctx.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating Package Body nm3security
SET TERM OFF
--
SET FEEDBACK ON
start nm3security.pkw
SET FEEDBACK OFF

--
SPOOL OFF
--
EXIT


--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
