--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4400_fix1.sql-arc   3.0   Aug 03 2011 10:30:56   Mike.Alexander  $
--       Module Name      : $Workfile:   nm_4400_fix1.sql  $
--       Date into PVCS   : $Date:   Aug 03 2011 10:30:56  $
--       Date fetched Out : $Modtime:   Aug 03 2011 10:30:30  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) Bentley Systems Incorporated, 2011
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
define logfile1='nm_4400_fix1_1_&log_extension'
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
 -- Check that HIG has been installed @ v4.4.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.4.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_audits_vw.vw
SET TERM OFF
--
SET FEEDBACK ON
start hig_audits_vw.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT imf_hig_audits.vw
SET TERM OFF
--
SET FEEDBACK ON
start imf_hig_audits.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_audit.pkh
SET TERM OFF
--
SET FEEDBACK ON
start hig_audit.pkh
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3sdo_util.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_util.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_alert.pkw
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT hig_audit.pkw
SET TERM OFF
--
SET FEEDBACK ON
start hig_audit.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3extent.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3extent.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3gaz_qry.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3gaz_qry.pkw
SET FEEDBACK OFF
--
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
PROMPT nm3mail.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mail.pkw
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
--
SET TERM ON 
PROMPT nm3sdo_edit.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_edit.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3sdo_util.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_util.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm0575.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm0575.pkw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Compile Schema (there are some invalid objects)
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
DEFINE logfile='nm_4400_fix1_2_&log_extension'
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
--
alter view network_node compile;
--
alter synonym road_seg_membs_partial compile;
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4400_fix1.sql 
--
SET FEEDBACK ON
start log_nm_4400_fix1.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--