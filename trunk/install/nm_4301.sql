--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4301.sql-arc   3.3   Jul 04 2013 13:47:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4301.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:47:12  $
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
define logfile1='nm_4301_1_&log_extension'
define logfile2='nm_4301_2_&log_extension'
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
-- Check that HIG has been installed @ v4.3.0.0
--
BEGIN
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.3.0.0'
                                );
END;
/

WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- DDL
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT mv_highlight_index.sql
SET TERM OFF
--
SET FEEDBACK ON
start mv_highlight_index.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT ntifix.sql
SET TERM OFF
--
SET FEEDBACK ON
start ntifix.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_process_api.pkw
SET TERM OFF
--
SET FEEDBACK ON
start hig_process_api.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT mapviewer.pkw
SET TERM OFF
--
SET FEEDBACK ON
start mapviewer.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3asset.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3asset.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3bulk_mrg.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3bulk_mrg.pkw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3ftp.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3ftp.pkw
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
PROMPT nm3layer_tool.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3layer_tool.pkw
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
PROMPT nm3sdo_check.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_check.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- set version number
--------------------------------------------------------------------------------
--
SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF
BEGIN
      hig2.upgrade('HIG','nm_4301.sql','Upgrade from 4.3.0.0 to 4.3.0.1','4.3.0.1');
      hig2.upgrade('NET','nm_4301.sql','Upgrade from 4.3.0.0 to 4.3.0.1','4.3.0.1');
      hig2.upgrade('DOC','nm_4301.sql','Upgrade from 4.3.0.0 to 4.3.0.1','4.3.0.1');
      hig2.upgrade('AST','nm_4301.sql','Upgrade from 4.3.0.0 to 4.3.0.1','4.3.0.1');
      hig2.upgrade('WMP','nm_4301.sql','Upgrade from 4.3.0.0 to 4.3.0.1','4.3.0.1');
END;
/
COMMIT;

--
---------------------------------------------------------------------------------------------------
--                        ****************   COMPILE SCHEMA   *******************
SET TERM ON
Prompt Creating Compiling Schema Script...
SET TERM OFF
SPOOL OFF
start compile_schema.sql
spool &logfile2
SET TERM ON
start compile_all.sql
--
alter view network_node compile;
--
alter synonym road_seg_membs_partial compile;
--
SPOOL OFF
EXIT
--
--
