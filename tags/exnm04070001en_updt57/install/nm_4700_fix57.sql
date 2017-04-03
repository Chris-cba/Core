----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix57.sql-arc   1.0   Apr 03 2017 10:18:38   Upendra.Hukeri  $   
--       Module Name      : $Workfile:   nm_4700_fix57.sql  $ 
--       Date into PVCS   : $Date:   Apr 03 2017 10:18:38  $
--       Date fetched Out : $Modtime:   Apr 03 2017 10:15:48  $
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
-- Spool to Logfile
--------------------------------------------------------------------------------
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
WHERE hpr_product IN ('HIG', 'NET', 'AST');
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
		WHERE  hup_product = 'NET'
		AND    remarks = 'NET 4700 FIX 42 (Build 1)';
	--
	l_dummy_c1 VARCHAR2(1);
BEGIN
	--
	-- Check that the user isn't SYS or SYSTEM
	--
	IF USER IN ('SYS', 'SYSTEM') THEN
		RAISE_APPLICATION_ERROR(-20000, 'You cannot install this product as ' || USER);
	END IF;
	--
	-- Check that HIG has been installed @ v4.7.0.x
	--
	hig2.product_exists_at_version  (p_product        => 'HIG'
									,p_VERSION        => '4.7.0.1'
									);
	--
        --
	-- 	Check that NET 4700 FIX 42 (Build 1) has already been applied
	--
	OPEN  c1;
	FETCH c1 INTO l_dummy_c1;
	CLOSE c1;
	--
	IF l_dummy_c1 IS NULL THEN
		RAISE_APPLICATION_ERROR(-20001,'NET 4700 FIX 42 (Build 1) must be applied before proceeding - contact exor support for further information');
	END IF;
	--
END;
/
--
WHENEVER SQLERROR CONTINUE
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Compiling nm3_doc_man.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3_doc_man.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Compiling nm3_doc_man.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3_doc_man.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT log_nm_4700_fix57.sql
SET TERM OFF
--
SET FEEDBACK ON
START log_nm_4700_fix57.sql
SET FEEDBACK OFF
--
SPOOL OFF
--
EXIT