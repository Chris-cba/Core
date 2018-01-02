----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix54.sql-arc   1.3   Jan 02 2018 14:53:38   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix54.sql  $ 
--       Date into PVCS   : $Date:   Jan 02 2018 14:53:38  $
--       Date fetched Out : $Modtime:   Jan 02 2018 14:51:06  $
--       Version     	  : $Revision:   1.3  $
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
DEFINE logfile1='nm_4700_fix54_&log_extension'
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
-- Table constraint
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding constraint XSR_FK_NIT to NM_XSP_RESTRAINTS
SET TERM OFF
--
DECLARE
  constraint_exists Exception;
  Pragma Exception_Init(constraint_exists, -2275); 
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_XSP_RESTRAINTS ADD (
                     CONSTRAINT XSR_FK_NIT 
                     FOREIGN KEY (XSR_ITY_INV_CODE) 
                     REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
                     ENABLE VALIDATE)';
EXCEPTION
WHEN constraint_exists
THEN 
  Null;
END;
/
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body nm_inv_sdo_aggr.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm_inv_sdo_aggr.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3pla.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3pla.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3homo.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3homo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3sdo_edit.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3sdo_edit.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- HIG_OPTION_LIST
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding new product option NMGENPK into HIG_OPTION_LIST
SET TERM OFF
--
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
SELECT 'NMGENPK'
      ,'NET'
      ,'Generate asset Primary Key'
      ,'Defines whether the Primary Key value is automatically generated for an asset, where the Primary Key is defined as an asset attribute.'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NMGENPK'
                 )
/
--
SET TERM ON 
PROMPT Adding new product option THMEROLOVR into HIG_OPTION_LIST
SET TERM OFF
--
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
SELECT 'THMEROLOVR'
      ,'NET'
      ,'Override Theme Role'
      ,'Allow Assets to be created when the Asset Role is defined as NORMAL, but the associated theme Role is defined as READONLY'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'THMEROLOVR'
                 )
/
--
--
--
--------------------------------------------------------------------------------
-- HIG_OPTION_VALUES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding option values to HIG_OPTION_VALUES for NMGENPK
SET TERM OFF
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'NMGENPK'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NMGENPK'
                 )
/
--
SET TERM ON 
PROMPT Adding option values to HIG_OPTION_VALUES for THMEROLOVR
SET TERM OFF
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'THMEROLOVR'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'THMEROLOVR'
                 )
/
--
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix54.sql'
				,p_remarks        => 'NET 4700 FIX 54 (Build 4)'
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
