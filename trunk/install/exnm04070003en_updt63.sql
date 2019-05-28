-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/exnm04070003en_updt63.sql-arc   1.0   May 28 2019 11:52:04   Steve.Cooper  $
--       Date into PVCS   : $Date:   May 28 2019 11:52:04  $
--       Module Name      : $Workfile:   exnm04070003en_updt63.sql  $
--       Date fetched Out : $Modtime:   May 28 2019 11:38:30  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
-----------------------------------------------------------------------------------
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
define logfile1='exnm04070003en_updt63_&log_extension'
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
 -- Check that NET has been installed @ v4.7.0.0
 --
 hig2.product_exists_at_version  (
                                 p_product        => 'NET',
                                 p_version        => '4.7.0.1'
                                 );
END;
/

WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Package Bodies
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling nm3merge.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3merge.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3replace.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3replace.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3split.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3split.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3undo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3undo.pkw
SET FEEDBACK OFF
--
--  
--
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
Begin
  --
  Hig2.Upgrade  (
                p_Product        => 'NET',
                p_Upgrade_Script => 'exnm04070003en_updt63.sql',
                p_Remarks        => 'NM 4700 FIX 63',
                p_To_Version     => Null
                );
  --
  Commit;
  --
Exception
  When Others Then Null;
End;
/


SPOOL OFF
--
EXIT
--
--
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
