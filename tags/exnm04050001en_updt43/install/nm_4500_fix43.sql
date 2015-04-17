--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4500_fix43.sql-arc   1.0   Apr 17 2015 10:13:20   Vikas.Mhetre  $
--       Module Name      : $Workfile:   nm_4500_fix43.sql  $
--       Date into PVCS   : $Date:   Apr 17 2015 10:13:20  $
--       Date fetched Out : $Modtime:   Apr 17 2015 08:41:58  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file name
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='nm_4500_fix43_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Fix Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

WHENEVER SQLERROR EXIT

DECLARE
--
  CURSOR c1 is
     SELECT 'Y'
     FROM   hig_upgrades
     WHERE  hup_product = 'NET'
     AND    remarks = 'NET 4500 FIX 23';
--
     l_dummy_c1 VARCHAR2(1);
--
BEGIN

 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;

 --
 -- Check that HIG has been installed @ v4.5.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.5.0.0'
                                );
--
--  Check that NET 4500 FIX 23 has already been applied
--
  OPEN  c1;
  FETCH c1 INTO l_dummy_c1;
  CLOSE c1;
--
  IF l_dummy_c1 IS NULL THEN
     RAISE_APPLICATION_ERROR(-20001,'NET 4500 FIX 23 must be applied before proceeding - contact exor support for further information');
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
PROMPT log_nm_4500_fix43.sql 
--
SET FEEDBACK ON
start log_nm_4500_fix43.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT