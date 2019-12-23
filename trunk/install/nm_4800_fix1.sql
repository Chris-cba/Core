----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix1.sql-arc   1.0   Dec 23 2019 10:42:56   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4800_fix1.sql  $ 
--       Date into PVCS   : $Date:   Dec 23 2019 10:42:56  $
--       Date fetched Out : $Modtime:   Dec 23 2019 10:25:00  $
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
DEFINE logfile1='nm_4800_fix1_&log_extension'
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
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Header nm3inv
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Header nm3_java_utils
SET TERM OFF
--
SET FEEDBACK ON
start nm3_java_utils.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Header sdo_lrs
SET TERM OFF
--
SET FEEDBACK ON
start sdo_lrs.pkh
SET FEEDBACK OFF
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body nm3close
SET TERM OFF
--
SET FEEDBACK ON
start nm3close.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3jobs
SET TERM OFF
--
SET FEEDBACK ON
start nm3jobs.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3sdo
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3web
SET TERM OFF
--
SET FEEDBACK ON
start nm3web.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm0575
SET TERM OFF
--
SET FEEDBACK ON
start nm0575.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdo_lrs
SET TERM OFF
--
SET FEEDBACK ON
start sdo_lrs.pkw
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Procedures
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Procedure register_aggr_theme
SET TERM OFF
--
SET FEEDBACK ON
start register_aggr_theme.prw
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Triggers for nm_inv_items
SET TERM OFF
--
SET FEEDBACK ON
start nm_inv_items.trg
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4800_fix1.sql'
				,p_remarks        => 'NET 4800 FIX 1 (Build 1)'
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
