----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4900_fix1_themes.sql-arc   1.0   Apr 22 2021 11:58:38   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4900_fix1_themes.sql  $ 
--       Date into PVCS   : $Date:   Apr 22 2021 11:58:38  $
--       Date fetched Out : $Modtime:   Mar 04 2021 13:29:22  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
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
DEFINE logfile1='nm_4900_fix1_themes_&log_extension'
spool &logfile1

--
--------------------------------------------------------------------------------
-- Themes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Themes
SET TERM OFF
--
SET FEEDBACK ON
start sdl_themes.sql
SET FEEDBACK OFF

COMMIT;
--

SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
