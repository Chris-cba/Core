----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix61.sql-arc   1.4   Jan 31 2019 09:27:46   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix61.sql  $ 
--       Date into PVCS   : $Date:   Jan 31 2019 09:27:46  $
--       Date fetched Out : $Modtime:   Jan 31 2019 09:27:06  $
--       Version     	  : $Revision:   1.4  $
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
DEFINE logfile1='nm_4700_fix61_&log_extension'
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
PROMPT creating Package Body nm3pla.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3pla.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body hig_process_api.pkw
SET TERM OFF
--
SET FEEDBACK ON
START hig_process_api.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3asset.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3asset.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3close.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3close.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3gaz_qry.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3gaz_qry.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3undo.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3undo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body HIG_PROCESS_SECURITY.pkw
SET TERM OFF
--
SET FEEDBACK ON
START HIG_PROCESS_SECURITY.pkw
SET FEEDBACK OFF


--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating View v_contiguity_check.vw
SET TERM OFF
--
SET FEEDBACK ON
START v_contiguity_check.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating View v_nm_ordered_members.vw
SET TERM OFF
--
SET FEEDBACK ON
START v_nm_ordered_members.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating View v_nm_ordered_route_details.vw
SET TERM OFF
--
SET FEEDBACK ON
START v_nm_ordered_route_details.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating View v_all_contractor_users.vw
SET TERM OFF
--
SET FEEDBACK ON
START v_all_contractor_users.vw.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix61.sql'
				,p_remarks        => 'NET 4700 FIX 61 (Build 4)'
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
