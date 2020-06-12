----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix72.sql-arc   1.0   Jun 12 2020 11:28:20   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix72.sql  $ 
--       Date into PVCS   : $Date:   Jun 12 2020 11:28:20  $
--       Date fetched Out : $Modtime:   Jun 12 2020 10:13:46  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
SET SERVEROUTPUT ON
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
DEFINE logfile1='nm_4700_fix72_&log_extension'
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
-- HIG_OPTION_LIST
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_option_list
SET TERM OFF

INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVADTM'
      ,'HIG'
      ,'Datum Type ID'
      ,'Datum Type ID on which the Materialized views used in shape file production are based'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVADTM'
                 )
/
--
--------------------------------------------------------------------------------
-- HIG_OPTION_VALUES
--------------------------------------------------------------------------------
--
--
SET TERM ON
PROMPT hig_option_values
SET TERM OFF


INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'SHPJAVADTM'
      ,'5'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'SHPJAVADTM'
                 )
/

--
-- Set context values to allow for Materialized View to create
--
BEGIN
  NM3CTX.SET_CONTEXT('MV_ROUTE_TYPE', hig.get_sysopt('SHPJAVARTE'));
  NM3CTX.SET_CONTEXT('MV_DATUM_NLT_ID', hig.get_sysopt('SHPJAVADTM'));
END;
/

--------------------------------------------------------------------------------
-- Materialized View
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Materialized View v_obj_on_route
SET TERM OFF
--
SET FEEDBACK ON
start v_obj_on_route.vw
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Package Body lb_aggr
SET TERM OFF
--
SET FEEDBACK ON
start lb_aggr.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'nm_4700_fix72.sql'
				,p_remarks        => 'NET 4700 FIX 72 (Build 1)'
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
