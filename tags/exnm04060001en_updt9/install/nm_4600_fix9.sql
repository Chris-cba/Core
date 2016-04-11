----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4600_fix9.sql-arc   1.0   Apr 11 2016 13:04:58   Upendra.Hukeri  $
--       Module Name      : $Workfile:   nm_4600_fix9.sql  $ 
--       Date into PVCS   : $Date:   Apr 11 2016 13:04:58  $
--       Date fetched Out : $Modtime:   Apr 11 2016 11:24:48  $
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
-- Spool to Logfile
--------------------------------------------------------------------------------
--
DEFINE logfile1='nm_4600_fix9_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;

SELECT 'Install Running on ' || LOWER(USER || '@' || instance_name || '.' || host_name) || ' - DB ver : ' || version
FROM v$instance;
--
SELECT 'Current version of ' || hpr_product || ' ' || hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG', 'NET', 'AST');
--
--------------------------------------------------------------------------------
-- 	Check(s)
--------------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT
--
BEGIN
	--
	-- Check that the user isn't SYS or SYSTEM
	--
	IF USER IN ('SYS', 'SYSTEM') THEN
		RAISE_APPLICATION_ERROR(-20000, 'You cannot install this product as ' || USER);
	END IF;
	--
	-- Check that WMP has been installed @ v4.6.0.0
	--
	hig2.product_exists_at_version  (p_product        => 'HIG'
									,p_VERSION        => '4.6.0.0'
									);
	--
END;
/
--
WHENEVER SQLERROR CONTINUE
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4600_fix9.sql
SET TERM OFF
--
SET FEEDBACK ON
START log_nm_4600_fix9.sql
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