----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix27.sql-arc   1.0   Jul 20 2015 17:26:54   Upendra.Hukeri  $
--       Module Name      : $Workfile:   nm_4700_fix27.sql  $ 
--       Date into PVCS   : $Date:   Jul 20 2015 17:26:54  $
--       Date fetched Out : $Modtime:   Jul 20 2015 17:25:54  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
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
-- Spool to Logfile
--------------------------------------------------------------------------------
--
DEFINE logfile1='nm_4700_fix27_&log_extension'
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
WHERE hpr_product IN ('HIG', 'NET', 'WMP');
--
--------------------------------------------------------------------------------
-- 	Check(s)
--------------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT
--
DECLARE
	--
	CURSOR c1 is
		SELECT 'Y'
		FROM   hig_upgrades
		WHERE  hup_product 	= 'NET'
		AND    remarks 		= 'NET 4700 FIX 8';
	--
	CURSOR c2 is
		SELECT 'Y'
		FROM   hig_upgrades
		WHERE  hup_product 	= 'NET'
		AND    remarks 		= 'NET 4700 FIX 25';
	--
	l_dummy_c VARCHAR2(1);
	--
BEGIN
	--
	-- Check that the user isn't SYS or SYSTEM
	--
	IF USER IN ('SYS', 'SYSTEM') THEN
		RAISE_APPLICATION_ERROR(-20000, 'You cannot install this product as ' || USER);
	END IF;
	--
	-- Check that WMP has been installed @ v4.7.0.x
	--
	hig2.product_exists_at_version  (p_product        => 'WMP'
									,p_VERSION        => '4.7.0.1'
									);
	--
	-- 	Check that NET 4700 FIX 8 has already been applied
	--
	OPEN  c1;
	FETCH c1 INTO l_dummy_c;
	CLOSE c1;
	--
	IF l_dummy_c IS NULL THEN
		RAISE_APPLICATION_ERROR(-20001, 'NET 4700 FIX 8 must be applied before proceeding - contact exor support for further information');
	END IF;
	--
	-- 	Check that NET 4700 FIX 25 has already been applied
	--
	l_dummy_c := NULL;
	--
	OPEN  c2;
	FETCH c2 INTO l_dummy_c;
	CLOSE c2;
	--
	IF l_dummy_c IS NULL THEN
		RAISE_APPLICATION_ERROR(-20002, 'NET 4700 FIX 25 must be applied before proceeding - contact exor support for further information');
	END IF;
END;
/
--
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Type
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Type nm_msv_style_size
SET TERM OFF
--
SET FEEDBACK ON
start nm_msv_style_size.tyh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Header nm3_msv_util
SET TERM OFF
--
SET FEEDBACK ON
start nm3_msv_util.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body nm3_msv_util
SET TERM OFF
--
SET FEEDBACK ON
start nm3_msv_util.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating Package Body nm3ddl
SET TERM OFF
--
SET FEEDBACK ON
start nm3ddl.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- View
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating View v_nm_msv_styles.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_msv_styles.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- DML Changes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Performing DML changes for Product Options - WEBMAPPRDS and WEBMAPDSRC
SET TERM OFF 
--
DELETE FROM hig_option_list 
WHERE hol_id = 'WEBMAPPRDS';
--
UPDATE hig_option_list 
SET hol_user_option = 'N' 
WHERE hol_id = 'WEBMAPDSRC';
--
DELETE FROM hig_user_options 
WHERE huo_id IN ('WEBMAPPRDS', 'WEBMAPDSRC');
--
COMMIT;
--
--------------------------------------------------------------------------------
-- DDL Changes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Performing DDL changes for ALL_SDO_STYLES View for Highways Owner/s and sub-user/s
SET TERM OFF 
--
BEGIN
	nm3ddl.create_all_styles_view;
END;
/
--
START nm_4700_fix27_ddl.sql;
--
--------------------------------------------------------------------------------
-- Synonyms
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Synonyms
SET TERM OFF
--
SET FEEDBACK ON
--
BEGIN
	nm3ddl.refresh_all_synonyms;
END;
/
--
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix27.sql
SET TERM OFF
--
SET FEEDBACK ON
START log_nm_4700_fix27.sql
SET FEEDBACK OFF
--
SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--