----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix57.sql-arc   1.2   Dec 15 2017 13:19:46   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix57.sql  $ 
--       Date into PVCS   : $Date:   Dec 15 2017 13:19:46  $
--       Date fetched Out : $Modtime:   Dec 14 2017 10:10:52  $
--       Version     	  : $Revision:   1.2  $
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
DEFINE logfile1='nm_4700_fix57_&log_extension'
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
-- Type
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating type sde_varchar_2d_array
SET TERM OFF
--
SET FEEDBACK ON
start sde_varchar_2d_array.tyh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating type sde_varchar_array
SET TERM OFF
--
SET FEEDBACK ON
start sde_varchar_array.tyh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating function get_lb_RPt_r_tab
SET TERM OFF
--
SET FEEDBACK ON
start get_lb_RPt_r_tab.fnw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating View hig_processes_all_v
SET TERM OFF
--
SET FEEDBACK ON
START hig_processes_all_v.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating View hig_processes_v
SET TERM OFF
--
SET FEEDBACK ON
START hig_processes_v.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating View v_obj_on_route
SET TERM OFF
--
SET FEEDBACK ON
START v_obj_on_route.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating View v_nm_ordered_members
SET TERM OFF
--
SET FEEDBACK ON
START v_nm_ordered_members.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Header sde_util.pkh
SET TERM OFF
--
SET FEEDBACK ON
START sde_util.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body sde_util.pkw
SET TERM OFF
--
SET FEEDBACK ON
START sde_util.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3rsc.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3rsc.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Removal of product options SHPJAVAEX and SHPJAVAUP 
--------------------------------------------------------------------------------
--
DELETE from hig_option_values
WHERE hov_id IN ('SHPJAVAEX','SHPJAVAUP')
/

DELETE from hig_option_list
WHERE hol_id IN ('SHPJAVAEX','SHPJAVAUP')
/
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix57.sql'
				,p_remarks        => 'NET 4700 FIX 57 (Build 1)'
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
