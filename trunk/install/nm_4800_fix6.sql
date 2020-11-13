----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix6.sql-arc   1.1   Nov 13 2020 08:54:22   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4800_fix6.sql  $ 
--       Date into PVCS   : $Date:   Nov 13 2020 08:54:22  $
--       Date fetched Out : $Modtime:   Nov 12 2020 14:46:30  $
--       Version     	  : $Revision:   1.1  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
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
DEFINE logfile1='nm_4800_fix6_&log_extension'
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
 -- Check that NET has been installed @ v4.8.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.8.0.0'
                                );

END;
/

WHENEVER SQLERROR CONTINUE


--------------------------------------------------------------------------------
-- DDL
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT Add HUS_ACK_TC to HIG_USERS
SET TERM OFF
--

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE hig_users ADD hus_ack_tc DATE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT Creating View v_node_proximity_check
SET TERM OFF
--
SET FEEDBACK ON
start v_node_proximity_check.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_nm_hig_users
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_hig_users.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body lb_get
SET TERM OFF
--
SET FEEDBACK ON
start lb_get.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3merge
SET TERM OFF
--
SET FEEDBACK ON
start nm3merge.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Trigger nm_asset_locations_all_who
SET TERM OFF
--
SET FEEDBACK ON
start nm_asset_locations_all_who.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger nm_asset_locations_b_ins
SET TERM OFF
--
SET FEEDBACK ON
start nm_asset_locations_b_ins.trg
SET FEEDBACK OFF
	
--
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Metadata
SET TERM OFF
--
BEGIN
  INSERT INTO hig_products (hpr_product,
                            hpr_product_name,
                            hpr_version,
                            hpr_key,
                            hpr_sequence)
       VALUES ('LB',
               'Location Bridge',
               '4.8.0.3',
               '76',
               99);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX
    THEN
        UPDATE hig_products
           SET hpr_version = '4.8.0.3'
         WHERE hpr_product = 'LB';
END;
/
COMMIT;
--
-- Requires HIG2 recompile, otherwise upgrade not logged
ALTER PACKAGE hig2 COMPILE PACKAGE; 

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4800_fix6.sql'
				,p_remarks        => 'NET 4800 FIX 6 (Build 1)'
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
