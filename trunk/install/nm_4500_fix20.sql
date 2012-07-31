--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4500_fix20.sql-arc   1.0   Jul 31 2012 10:00:12   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4500_fix20.sql  $
--       Date into PVCS   : $Date:   Jul 31 2012 10:00:12  $
--       Date fetched Out : $Modtime:   Jul 31 2012 09:59:00  $
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
define logfile1='nm_4500_fix20_&log_extension'
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
-- View Definitions
--------------------------------------------------------------------------------
--
--SET TERM ON 
PROMPT v_nm_rebuild_all_inv_sdo_join.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_rebuild_all_inv_sdo_join.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT v_nm_rebuild_all_nat_sdo_join.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_rebuild_all_nat_sdo_join.vw
SET FEEDBACK OFF

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
--------------------------------------------------------------------------------
-- Upgrade 
--       first remove any extraneous subordinate user private views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT remove_private_views.sql
SET TERM OFF
--
SET FEEDBACK ON
start remove_private_views.sql
SET FEEDBACK OFF

--------------------------------------------------------------------------------
--       now run the regen.sql file to rebuild basic sdo views from standard product
--       run catch-all to trap first level dependencies
--       then inv type views and APIs and triggers
--       tidy up synonyms etc
--       also set the upgrade text
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT regen.sql
SET TERM OFF
--
SET FEEDBACK ON
start regen.sql
SET FEEDBACK OFF
--
-----------------------------------------------------------------------------------------------------
--                        ****************   SYNONYMS   *******************
SET TERM ON
Prompt Refreshing synonyms
SET TERM OFF
EXECUTE nm3ddl.refresh_all_synonyms;
--
--
SPOOL OFF
EXIT
--
--