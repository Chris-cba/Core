--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4500_fix49.sql-arc   1.0   Mar 17 2016 08:05:46   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_4500_fix49.sql  $
--       Date into PVCS   : $Date:   Mar 17 2016 08:05:46  $
--       Date fetched Out : $Modtime:   Mar 16 2016 10:29:54  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Grab date/time to append to log file name
--
UNDEFINE log_extension
COL log_extension NEW_VALUE log_extension NOPRINT
SET TERM OFF
SELECT  TO_CHAR(SYSDATE,'DDMONYYYY_HH24MISS') || '.LOG' log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
-- Spool to Logfile
--------------------------------------------------------------------------------
--
DEFINE logfile1='nm_4500_fix49_&log_extension'
SPOOL &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;
--
SELECT 'Install Running on ' || LOWER(USER || '@' || instance_name || '.' || host_name) || ' - DB ver : ' || version
FROM v$instance;
--
SELECT 'Current version of ' || hpr_product || ' ' || hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG', 'NET');
--
WHENEVER SQLERROR EXIT
--
BEGIN
 --
 -- Check that the user isn't SYS or SYSTEM
 --
 IF USER IN ('SYS', 'SYSTEM')
 THEN
   raise_application_error(-20000, 'You cannot install this product as ' || USER);
 END IF;
--
 --
 -- Check that NET has been installed @ v4.5.0.0
 --
 hig2.product_exists_at_version (p_product => 'NET'
                                ,p_VERSION => '4.5.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4500_fix49.sql
SET TERM OFF
--
SET FEEDBACK ON
START log_nm_4500_fix49.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SPOOL OFF
EXIT
--
COMMIT;
--