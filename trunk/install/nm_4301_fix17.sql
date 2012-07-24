--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4301_fix17.sql-arc   1.0   Jul 24 2012 15:04:38   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4301_fix17.sql  $
--       Date into PVCS   : $Date:   Jul 24 2012 15:04:38  $
--       Date fetched Out : $Modtime:   Jul 24 2012 15:03:48  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
----------------------------------------------------------------------------
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
define logfile1='nm_4301_fix17_&log_extension'
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

BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;

 --
 -- Check that HIG has been installed @ v4.3.0.0 or v4.3.0.1
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.3.0.1'
                                );

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
PROMPT doc_bundle_loader.pkw
SET TERM OFF
--
SET FEEDBACK ON
start doc_bundle_loader.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- DML
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT doc_issued_century_repair
SET TERM OFF
--
SET FEEDBACK ON
start doc_issued_century_repair.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4301_fix17.sql 
--
SET FEEDBACK ON
start log_nm_4301_fix17.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--