--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4600_fix6.sql-arc   1.1   Jul 04 2013 13:48:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4600_fix6.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:48:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:24  $
--       PVCS Version     : $Revision:   1.1  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
define logfile1='nm_4600_fix6_&log_extension'
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
 -- Check that HIG has been installed @ v4.6.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.6.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Drop the security policies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Remove existing security policies
SET TERM OFF
--
SET FEEDBACK ON
start drop_nm3nwausec_policies.sql
SET FEEDBACK OFF



--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3nwausec.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3nwausec.pkh
SET FEEDBACK OFF


--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3nwausec.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3nwausec.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Apply the security policies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating security policies
SET TERM OFF
--
SET FEEDBACK ON
start add_nm3nwausec_policies.sql
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Trigger to prevent unhandled exception when folder no longer exists
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_directory_roles_a_iud_trg.trg
SET TERM OFF
--
SET FEEDBACK ON
start hig_directory_roles_a_iud_trg.trg
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4600_fix6.sql 
--
SET FEEDBACK ON
start log_nm_4600_fix6.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--
