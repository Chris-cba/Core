--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4600_fix1.sql-arc   1.0   Nov 29 2012 10:04:44   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4600_fix1.sql  $
--       Date into PVCS   : $Date:   Nov 29 2012 10:04:44  $
--       Date fetched Out : $Modtime:   Nov 28 2012 17:59:36  $
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
define logfile1='nm_4600_fix1_&log_extension'
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
start drop_nm3nwausec_policy.sql
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
SET TERM ON 
PROMPT nm3ausec.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3ausec.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Synonyms for packages
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating synonym for nm3nwausec
SET TERM OFF
--
SET FEEDBACK ON
begin
  nm3ddl.create_synonym_for_object('NM3NWAUSEC');
end;  
/
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
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4600_fix1.sql 
--
SET FEEDBACK ON
start log_nm_4600_fix1.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--