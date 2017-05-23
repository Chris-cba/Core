----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix46.sql-arc   1.0   May 23 2017 08:41:40   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix46.sql  $ 
--       Date into PVCS   : $Date:   May 23 2017 08:41:40  $
--       Date fetched Out : $Modtime:   May 19 2017 13:51:00  $
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
DEFINE logfile1='nm_4700_fix46_&log_extension'
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
-- HIG_MODULES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT HIG_MODULES 
SET TERM OFF
--
UPDATE hig_modules
   SET hmo_title = 'My Standard Text Usage'
 WHERE hmo_module = 'HIG4025';
--
--------------------------------------------------------------------------------
-- HIG_PRODUCTS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT HIG_PRODUCTS 
SET TERM OFF

INSERT INTO HIG_PRODUCTS
       (HPR_PRODUCT
       ,HPR_PRODUCT_NAME
       ,HPR_VERSION
       ,HPR_PATH_NAME
       ,HPR_KEY
       ,HPR_SEQUENCE
       ,HPR_IMAGE
       ,HPR_USER_MENU
       ,HPR_LAUNCHPAD_ICON
       ,HPR_IMAGE_TYPE
       )
SELECT 
        'MAS'
       ,'Managed Service Changes'
       ,'4.0.2.0'
       ,''
       ,null
       ,null
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PRODUCTS
                   WHERE HPR_PRODUCT = 'MAS');

INSERT INTO HIG_PRODUCTS
       (HPR_PRODUCT
       ,HPR_PRODUCT_NAME
       ,HPR_VERSION
       ,HPR_PATH_NAME
       ,HPR_KEY
       ,HPR_SEQUENCE
       ,HPR_IMAGE
       ,HPR_USER_MENU
       ,HPR_LAUNCHPAD_ICON
       ,HPR_IMAGE_TYPE
       )
SELECT 
        'PS '
       ,'Professional Services Changes'
       ,'4.0.2.0'
       ,''
       ,null
       ,null
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PRODUCTS
                   WHERE HPR_PRODUCT = 'PS');
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Header nm3file.pkh
SET TERM OFF
--
SET FEEDBACK ON
START nm3file.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body nm3wrap.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3wrap.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3file.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3file.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix46.sql'
				,p_remarks        => 'NET 4700 FIX 46 (Build 2)'
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
