----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix53.sql-arc   1.2   Dec 18 2017 10:36:16   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix53.sql  $ 
--       Date into PVCS   : $Date:   Dec 18 2017 10:36:16  $
--       Date fetched Out : $Modtime:   Dec 18 2017 10:34:58  $
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
DEFINE logfile1='nm_4700_fix53_&log_extension'
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
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body nm3mail.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3mail.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- HIG_OPTION_LIST
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding new product option AUTHMAIL into HIG_OPTION_LIST
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
SELECT 'AUTHMAIL'
      ,'NET'
      ,'Email Authentication'
      ,'Defines whether SMTP Server requires Username/Password authentication.'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'AUTHMAIL'
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
PROMPT Adding option values to HIG_OPTION_VALUES for AUTHMAIL
SET TERM OFF
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'AUTHMAIL'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'AUTHMAIL'
                 )
/
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix53.sql'
				,p_remarks        => 'NET 4700 FIX 53 (Build 1)'
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
