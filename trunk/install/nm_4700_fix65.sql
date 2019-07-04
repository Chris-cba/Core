----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix65.sql-arc   1.0   Jul 04 2019 13:42:38   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix65.sql  $ 
--       Date into PVCS   : $Date:   Jul 04 2019 13:42:38  $
--       Date fetched Out : $Modtime:   Jul 04 2019 11:45:00  $
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
DEFINE logfile1='nm_4700_fix65_&log_extension'
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


--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body nm3rsc
SET TERM OFF
--
SET FEEDBACK ON
start nm3rsc.pkw
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating View v_nm_ordered_extent
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_ordered_extent.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_nm_ordered_extent_details
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_ordered_extent_details.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix65.sql'
				,p_remarks        => 'NET 4700 FIX 65 (Build 1)'
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
