----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix50.sql-arc   1.0   Jun 16 2017 09:51:42   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix50.sql  $ 
--       Date into PVCS   : $Date:   Jun 16 2017 09:51:42  $
--       Date fetched Out : $Modtime:   Jun 15 2017 15:34:10  $
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
DEFINE logfile1='nm_4700_fix50_&log_extension'
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
	RAISE_APPLICATION_ERROR(-20000, 'You cannot install this product as ' || USER);
 END IF;
 --
 -- Check that NET has been installed @ v4.7.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.7.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE

--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Header hig_process_security.pkh
SET TERM OFF
--
SET FEEDBACK ON
START hig_process_security.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header nm3flx.pkh
SET TERM OFF
--
SET FEEDBACK ON
START nm3flx.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header hig_process_security.pkh
SET TERM OFF
--
SET FEEDBACK ON
START hig_process_security.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body nm3ausec.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3ausec.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3rsc.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3rsc.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header nm3undo.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3undo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header hig_process_security.pkw
SET TERM OFF
--
SET FEEDBACK ON
START hig_process_security.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix50.sql'
				,p_remarks        => 'NET 4700 FIX 50 (Build 1)'
				,p_to_version     => NULL
				);
	--
	COMMIT;
	--
EXCEPTION 
	WHEN OTHERS THEN
	--
		NULL;
	--
END;
/
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
