--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4300_fix8.sql-arc   3.0   Feb 10 2011 14:26:08   mike.alexander  $
--       Module Name      : $Workfile:   nm_4300_fix8.sql  $
--       Date into PVCS   : $Date:   Feb 10 2011 14:26:08  $
--       Date fetched Out : $Modtime:   Feb 10 2011 14:25:44  $
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
define logfile1='nm_4300_fix8_1_&log_extension'
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

--
-- Check that the user isn't sys or system
--
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
      END IF;
END;
/

--
-- Check that HIG has been installed @ v4.3.0.0
--
BEGIN
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.3.0.0'
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
PROMPT nm3sdo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4300_fix8.sql 
--
SET FEEDBACK ON
start log_nm_4300_fix8.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--