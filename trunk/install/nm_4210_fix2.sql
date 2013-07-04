--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4210_fix2.sql-arc   3.3   Jul 04 2013 13:46:56   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4210_fix2.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:46:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       PVCS Version     : $Revision:   3.3  $
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
define logfile1='nm_4210_fix2_1_&log_extension'
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
-- Check that HIG has been installed @ v4.2.1.0
--
BEGIN
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.2.1.0'
                                );
END;
/

WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Packages
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3invval.pkh 
--
SET FEEDBACK ON
start nm3invval.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3invval.pkw 
--
SET FEEDBACK ON
start nm3invval.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_process_api.pkw 
--
SET FEEDBACK ON
start hig_process_api.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3reclass.pkw 
--
SET FEEDBACK ON
start nm3reclass.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3sdo.pkw 
--
SET FEEDBACK ON
start nm3sdo.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3undo.pkw 
--
SET FEEDBACK ON
start nm3undo.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3inv.pkw 
--
SET FEEDBACK ON
start nm3inv.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm_inv_items_all_excl_a_stm.trg 
--
SET FEEDBACK ON
start nm_inv_items_all_excl_a_stm.trg
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm_inv_items_all_excl_b_row.trg 
--
SET FEEDBACK ON
start nm_inv_items_all_excl_b_row.trg
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Compile Schema
--------------------------------------------------------------------------------
--
SET TERM ON
Prompt Compiling Schema
SET TERM OFF
--
SPOOL OFF
--
SET DEFINE ON
SET FEEDBACK ON
start compile_schema.sql
SET FEEDBACK OFF
--
-- SPOOL to Logfile
--
DEFINE logfile='nm_4210_fix2_2_&log_extension'
SPOOL &logfile
--
--
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version details
FROM v$instance;
--
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version details
FROM hig_products
WHERE hpr_product IN ('HIG','NET');
--
--
START compile_all.sql
--
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm_4210_fix2_metadata_upg.sql 
--
SET FEEDBACK ON
start nm_4210_fix2_metadata_upg.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4210_fix2.sql 
--
SET FEEDBACK ON
start log_nm_4210_fix2.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--
