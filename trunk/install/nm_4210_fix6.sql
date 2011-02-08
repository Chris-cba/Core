--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4210_fix6.sql-arc   3.0   Feb 08 2011 14:00:52   mike.alexander  $
--       Module Name      : $Workfile:   nm_4210_fix6.sql  $
--       Date into PVCS   : $Date:   Feb 08 2011 14:00:52  $
--       Date fetched Out : $Modtime:   Feb 08 2011 14:00:30  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2011
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
define logfile1='nm_4210_fix6_1_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Fix Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

WHENEVER SQLERROR EXIT

DECLARE
 CURSOR c1 IS
 SELECT 'Y'
 FROM   hig_upgrades
 WHERE  hup_product = 'NET'
 AND    remarks = 'NET 4210 FIX 2';
 
 l_dummy VARCHAR2(1);

BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;

 --
 -- Check that HIG has been installed @ v4.2.1.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.2.1.0'
                                );

 OPEN c1;
 FETCH c1 INTO l_dummy;
 CLOSE c1;
  
 IF l_dummy IS NULL THEN
   RAISE_APPLICATION_ERROR(-20001,'"Network Manager 4210 Fix 2" must be applied before proceeding - contact exor support for further information');
 END IF;

END;
/
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT doc_bundle_loader.pkh
SET TERM OFF
--
SET FEEDBACK ON
start doc_bundle_loader.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT doc_bundle_loader.pkw
SET TERM OFF
--
SET FEEDBACK ON
start doc_bundle_loader.pkw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT doc_bundle_files_v.vw
SET TERM OFF
--
SET FEEDBACK ON
start doc_bundle_files_v.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4210_fix6.sql 
--
SET FEEDBACK ON
start log_nm_4210_fix6.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--