-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/exnm04070002en_updt67.sql-arc   1.0   Dec 03 2019 06:18:48   Upendra.Hukeri  $
--       Date into PVCS   : $Date:   Dec 03 2019 06:18:48  $
--       Module Name      : $Workfile:   exnm04070002en_updt67.sql  $
--       Date fetched Out : $Modtime:   Dec 03 2019 06:17:02  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2019 Bentley Systems Incorporated.  All rights reserved.
-----------------------------------------------------------------------------------
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
SELECT TO_CHAR(SYSDATE,'DDMONYYYY_HH24MISS')||'.LOG' log_extension 
  FROM DUAL
/
--
SET TERM ON
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
DEFINE logfile1='exnm04070002en_updt67_&log_extension'
SPOOL &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') 
  FROM DUAL;

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
	-- Check that the user isn't sys or system
	--
	IF USER IN ('SYS', 'SYSTEM') THEN
		RAISE_APPLICATION_ERROR(-20000, 'You cannot install this product as ' || USER);
	END IF;
	--
	-- Check that NET has been installed @ v4.7.0.0
	--
	hig2.product_exists_at_version(p_product => 'NET'
                                  ,p_version => '4.7.0.1'
                                  );
END;
/
--
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Package Headers
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling nm3_java_utils.pkh
SET TERM OFF
--
SET FEEDBACK ON
START nm3_java_utils.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Package Bodies
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling nm3_java_utils.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3_java_utils.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Roles
--------------------------------------------------------------------------------
--
DECLARE
	role_already_exists EXCEPTION;
	PRAGMA EXCEPTION_INIT(role_already_exists, -1921);
BEGIN
	EXECUTE IMMEDIATE ('CREATE ROLE extract_shape_file');
EXCEPTION
	WHEN role_already_exists THEN
		NULL;
END;  
/
--
DECLARE
	role_already_exists EXCEPTION;
	PRAGMA EXCEPTION_INIT(role_already_exists, -1921);
BEGIN
	EXECUTE IMMEDIATE ('CREATE ROLE upload_shape_file');
EXCEPTION
	WHEN role_already_exists THEN
		NULL;
END;  
/
--
DECLARE
	role_already_exists EXCEPTION;
	PRAGMA EXCEPTION_INIT(role_already_exists, -1921);
BEGIN
	EXECUTE IMMEDIATE ('CREATE ROLE check_xss');
EXCEPTION
	WHEN role_already_exists THEN
		NULL;
END;  
/
--
--------------------------------------------------------------------------------
-- Roles
--------------------------------------------------------------------------------
--
INSERT INTO hig_roles (hro_role, hro_product, hro_descr) 
SELECT 'EXTRACT_SHAPE_FILE' hro_role, 'MCP' hro_product, 'Role that allows extracting Shapefiles' hro_descr 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM hig_roles WHERE hro_role = 'EXTRACT_SHAPE_FILE'); 
--
INSERT INTO hig_roles (hro_role, hro_product, hro_descr) 
SELECT 'UPLOAD_SHAPE_FILE' hro_role, 'MCP' hro_product, 'Role that allows uploading Shapefiles' hro_descr 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM hig_roles WHERE hro_role = 'UPLOAD_SHAPE_FILE'); 
--
INSERT INTO hig_roles (hro_role, hro_product, hro_descr) 
SELECT 'CHECK_XSS' hro_role, 'TIG' hro_product, 'Role that allows identifying XSS vulnerable URLs' hro_descr 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM hig_roles WHERE hro_role = 'CHECK_XSS'); 
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with Fix ID
--------------------------------------------------------------------------------
--
BEGIN
	hig2.upgrade(p_product        => 'NET'
                ,p_upgrade_script => 'exnm04070002en_updt67.sql'
                ,p_remarks        => 'NM 4700 FIX 67 (Build 2)'
                ,p_to_version     => NULL
                );
  --
  COMMIT;
EXCEPTION
	WHEN OTHERS THEN 
		NULL;
END;
/
--
SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************

