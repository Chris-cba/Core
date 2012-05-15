--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4500_fix1.sql-arc   3.2   May 15 2012 11:00:56   Steve.Cooper  $
--       Module Name      : $Workfile:   nm_4500_fix1.sql  $
--       Date into PVCS   : $Date:   May 15 2012 11:00:56  $
--       Date fetched Out : $Modtime:   May 15 2012 10:59:56  $
--       PVCS Version     : $Revision:   3.2  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
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
define logfile1='nm_4500_fix1_&log_extension'
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
-- DDL Changes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT extent_fk_cascade.sql
SET TERM OFF
--
SET FEEDBACK ON
start extent_fk_cascade.sql
SET FEEDBACK OFF
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
--
SET TERM ON 
PROMPT nm3pla.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3pla.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3nwad.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3nwad.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3api_inv.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3api_inv.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET FEEDBACK ON
start v_nm_admin_units_tree.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4500_fix1.sql 
--
SET FEEDBACK ON
start log_nm_4500_fix1.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--
