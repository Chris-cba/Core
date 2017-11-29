--
---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/install/install_sdeutil.sql-arc   1.0   Nov 29 2017 09:45:54   Upendra.Hukeri  $
--       Module Name      : $Workfile:   install_sdeutil.sql  $
--       Date into PVCS   : $Date:   Nov 29 2017 09:45:54  $
--       Date fetched Out : $Modtime:   Nov 29 2017 09:42:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Upendra Hukeri
--
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
---------------------------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Grab date/time to append to log file name
--
UNDEFINE sde_log_extension
COL      sde_log_extension NEW_VALUE sde_log_extension NOPRINT
SET TERM OFF
SELECT TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS') || '.LOG' sde_log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
-- Spool to Logfile
--------------------------------------------------------------------------------
--
DEFINE sde_logfile='java_shapefile_tool_&sde_log_extension'
spool &sde_logfile
--
--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT sde_varchar_array
SET TERM OFF
--
SET FEEDBACK ON
START sde_varchar_array.tyh
--
SET TERM ON
PROMPT sde_varchar_2d_array
SET TERM OFF
--
SET FEEDBACK ON
START sde_varchar_2d_array.tyh
--
--------------------------------------------------------------------------------
-- ROLE
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Role SDE_USER
SET TERM OFF
--
SET FEEDBACK ON
CREATE ROLE SDE_USER;
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- PACKAGE HEADER
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Package Header sde_util
SET TERM OFF
--
SET FEEDBACK ON
START sde_util.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Package Body sde_util
SET TERM OFF
--
SET FEEDBACK ON
START sde_util.pkw
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