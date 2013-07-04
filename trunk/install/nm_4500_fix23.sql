--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4500_fix23.sql-arc   1.1   Jul 04 2013 13:47:50   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4500_fix23.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:47:50  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:24  $
--       PVCS Version     : $Revision:   1.1  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
define logfile1='nm_4500_fix23_&log_extension'
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
SET TERM ON 
PROMPT mv_highlight_index.sql
SET TERM OFF
--
SET FEEDBACK ON
start mv_highlight_index.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT New view to simplify admin unit hierarchy in forms and reports - v_nm_admin_units_tree
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_admin_units_tree.vw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT v_doc_gateway_resolve
SET TERM OFF
--
SET FEEDBACK ON
start v_doc_gateway_resolve.vw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT v_nm_rebuild_all_inv_sdo_join
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_rebuild_all_inv_sdo_join.vw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT v_nm_rebuild_all_nat_sdo_join
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
PROMPT nm3homo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3homo.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3pla.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3pla.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3nwad.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3nwad.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3api_inv.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3api_inv.pkw
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
PROMPT nm3sde.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sde.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3rsc.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3rsc.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3mapcapture_ins_inv.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mapcapture_ins_inv.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3extent.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3extent.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT invsec.pkw
SET TERM OFF
--
SET FEEDBACK ON
start invsec.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3inv.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv.pkw
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
PROMPT nm3sdm.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdm.pkw
SET FEEDBACK OFF
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
PROMPT doc_bundle_loader.pkw
SET TERM OFF
--
SET FEEDBACK ON
start doc_bundle_loader.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Trigger
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm_inv_items.trg	
SET TERM OFF
--
SET FEEDBACK ON
start nm_inv_items.trg
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Grants etc.
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT grants on oracle types
SET TERM OFF
--
SET FEEDBACK ON
start grant_execute_any_type.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4500_fix23.sql 
--
SET FEEDBACK ON
start log_nm_4500_fix23.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
