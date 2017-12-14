----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4500_fix53.sql-arc   1.1   Dec 14 2017 09:50:52   Upendra.Hukeri  $
--       Module Name      : $Workfile:   nm_4500_fix53.sql  $ 
--       Date into PVCS   : $Date:   Dec 14 2017 09:50:52  $
--       Date fetched Out : $Modtime:   Dec 14 2017 09:50:32  $
--       Version     	  : $Revision:   1.1  $
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
DEFINE logfile1='nm_4500_fix53_&log_extension'
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
		AND    remarks 		= 'NET 4500 FIX 45';
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
	-- Check that NET has been installed @ v4.5.0.0
	--
	hig2.product_exists_at_version  (p_product        => 'NET'
									,p_VERSION        => '4.5.0.0'
									);
	--
	--
	-- 	Check that NET 4500 FIX 45 has already been applied
	--
	l_dummy_c := NULL;
	--
	OPEN  c1;
	FETCH c1 INTO l_dummy_c;
	CLOSE c1;
	--
	IF l_dummy_c IS NULL THEN
		RAISE_APPLICATION_ERROR(-20002, 'NET 4500 FIX 45 must be applied before proceeding - contact exor support for further information');
		--
		NULL;
	END IF;
	--
END;
/
--
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body web_user_info
SET TERM OFF
--
SET FEEDBACK ON
start web_user_info.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4500_fix53.sql
SET TERM OFF
--
SET FEEDBACK ON
START log_nm_4500_fix53.sql
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