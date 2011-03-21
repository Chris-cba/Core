--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4200_fix38.sql-arc   3.1   Mar 21 2011 16:07:24   Mike.Alexander  $
--       Module Name      : $Workfile:   nm_4200_fix38.sql  $
--       Date into PVCS   : $Date:   Mar 21 2011 16:07:24  $
--       Date fetched Out : $Modtime:   Mar 21 2011 16:07:24  $
--       PVCS Version     : $Revision:   3.1  $
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
define logfile1='nm_4200_fix38_1_&log_extension'
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

BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;

 --
 -- Check that HIG has been installed @ v4.2.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.2.0.0'
                                );

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
PROMPT nm3inv_security.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_security.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3inv_security.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_security.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3nwval.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3nwval.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3reclass.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3reclass.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4200_fix38.sql 
--
SET FEEDBACK ON
start log_nm_4200_fix38.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--