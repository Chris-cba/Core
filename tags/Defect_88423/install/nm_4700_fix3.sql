--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4700_fix3.sql-arc   1.0   Apr 24 2014 10:15:44   Upendra.Hukeri  $
--       Module Name      : $Workfile:   nm_4700_fix3.sql  $ 
--       Date into PVCS   : $Date:   Apr 24 2014 10:15:44  $
--       Date fetched Out : $Modtime:   Apr 23 2014 16:28:14  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
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
define logfile1='nm_4700_fix3_&log_extension'
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
WHERE hpr_product IN ('HIG','WMP');

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
 -- Check that WMP has been installed @ v4.7.0.x
 --
 hig2.product_exists_at_version (p_product        => 'WMP'
                                ,p_VERSION        => '4.7.0.1'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT mapviewer.pkh
SET TERM OFF
--
SET FEEDBACK ON
start mapviewer.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT mapviewer.pkw
SET TERM OFF
--
SET FEEDBACK ON
start mapviewer.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4700_fix3.sql
--
SET FEEDBACK ON
start log_nm_4700_fix3.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--