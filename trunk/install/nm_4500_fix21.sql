--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4500_fix21.sql-arc   1.0   Aug 01 2012 13:25:00   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4500_fix21.sql  $
--       Date into PVCS   : $Date:   Aug 01 2012 13:25:00  $
--       Date fetched Out : $Modtime:   Aug 01 2012 11:39:44  $
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
define logfile1='nm_4500_fix21_&log_extension'
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
 -- Check that HIG has been installed @ v4.5.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.5.0.0'
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
PROMPT nm3sdm.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdm.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3sdo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3sdo_edit.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_edit.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3invval.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3invval.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3homo_gis.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3homo_gis.pkw
SET FEEDBACK OFF
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
PROMPT log_nm_4500_fix21.sql 
--
SET FEEDBACK ON
start log_nm_4500_fix21.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--