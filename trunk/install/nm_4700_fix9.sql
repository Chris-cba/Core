--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4700_fix9.sql-arc   1.0   Nov 05 2014 14:00:52   Upendra.Hukeri  $
--       Module Name      : $Workfile:   nm_4700_fix9.sql  $ 
--       Date into PVCS   : $Date:   Nov 05 2014 14:00:52  $
--       Date fetched Out : $Modtime:   Nov 05 2014 13:58:08  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
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
SELECT  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
--
-- Spool to Logfile
--
DEFINE logfile1='nm_4700_fix9_&log_extension'
SPOOL &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(sysdate, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;
--
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','WMP');
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
		AND    remarks = 'NET 4700 FIX 8';
--
	l_dummy_c1 VARCHAR2(1);
--
BEGIN
--
-- 	Check that the user isn't sys or system
--
	IF USER IN ('SYS','SYSTEM')
	THEN
		RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
	END IF;
--
-- 	Check that WMP has been installed @ v4.7.0.x
--
	HIG2.PRODUCT_EXISTS_AT_VERSION  (p_product        => 'WMP'
									,p_VERSION        => '4.7.0.1'
									);
--
-- 	Check that NET 4700 FIX 8 has already been applied
--
	OPEN  c1;
	FETCH c1 INTO l_dummy_c1;
	CLOSE c1;
--
	IF l_dummy_c1 IS NULL THEN
		RAISE_APPLICATION_ERROR(-20001,'NET 4700 FIX 8 must be applied before proceeding - contact exor support for further information');
	END IF;
--
END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4700_fix9.sql
--
SET FEEDBACK ON
start log_nm_4700_fix9.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--