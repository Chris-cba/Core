--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix26.sql-arc   1.0   Jul 16 2015 14:34:52   Vikas.Mhetre  $
--       Module Name      : $Workfile:   nm_4700_fix26.sql  $
--       Date into PVCS   : $Date:   Jul 16 2015 14:34:52  $
--       Date fetched Out : $Modtime:   Jul 16 2015 11:29:34  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
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
DEFINE logfile1='nm_4700_fix26_&log_extension'
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
WHERE hpr_product IN ('HIG','NET');
--
--------------------------------------------------------------------------------
--      Check(s)
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
    AND    remarks = 'NET 4700 FIX 22';
--
    l_dummy_c1 VARCHAR2(1);
--
BEGIN
--
--  Check that the user isn't sys or system
--
    IF USER IN ('SYS','SYSTEM')
    THEN
      RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
    END IF;
--
--  Check that HIG has been installed @ v4.7.0.x
--
    HIG2.PRODUCT_EXISTS_AT_VERSION  (p_product        => 'HIG'
                                    ,p_VERSION        => '4.7.0.0'
                                    );
--
--
--  Check that NET 4700 FIX 22 has already been applied
--
    OPEN  c1;
    FETCH c1 INTO l_dummy_c1;
    CLOSE c1;
--
    IF l_dummy_c1 IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'NET 4700 FIX 22 must be applied before proceeding - contact exor support for further information');
    END IF;
--
END;
/
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3homo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3homo.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4700_fix26.sql
--
SET FEEDBACK ON
start log_nm_4700_fix26.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--