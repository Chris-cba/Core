-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix73.sql-arc   1.0   Oct 05 2020 14:02:58   Chris.Baugh  $
--       Date into PVCS   : $Date:   Oct 05 2020 14:02:58  $
--       Module Name      : $Workfile:   nm_4700_fix73.sql  $
--       Date fetched Out : $Modtime:   Sep 28 2020 11:44:04  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2019 Bentley Systems Incorporated.  All rights reserved.
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
define logfile1='nm_4700_fix73_&log_extension'
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
WHERE hpr_product IN ('HIG','NET','MCP');

WHENEVER SQLERROR EXIT

DECLARE
  not_licensed   EXCEPTION;
  PRAGMA EXCEPTION_INIT (not_licensed, -20000);
BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;
 --
 -- Check that MCP has been installed @ v4.7.0.0
 --
 hig2.product_exists_at_version  (
                                 p_product        => 'MCP',
                                 p_version        => '4.7.0.1'
                                 );
EXCEPTION
  WHEN not_licensed THEN
     Hig2.Upgrade  (
                   p_Product        => 'NET', 
                   p_Upgrade_Script => 'nm_4700_fix73.sql', 
                   p_Remarks        => 'NET 4700 FIX 73 (Build 1)', 
                   p_To_Version     => Null 
                   );
     --
     Commit;
	 --
     RAISE_APPLICATION_ERROR(-20000,CHR(10)||'MCP is not a licensed product at 4.7.0.0, this fix can be ignored'||CHR(10));
	 --
  WHEN OTHERS THEN
     RAISE;
END;
/
--
Declare
  n  Varchar2(1);
Begin
  Select  Null
  Into    n
  From    Hig_Upgrades
  Where   Hup_Product     =   'MCP'
  And     From_Version    =   '4.7.0.1'
  And     Upgrade_Script  =   'exmc04070003en_updt6.sql'
  And     rownum          =   1;
Exception 
  When No_Data_Found
Then
  RAISE_APPLICATION_ERROR(-20000,'Please install MCP 4700 Fix 6 before proceding.');
End;
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
PROMPT Compiling nm3mcp_process_insert.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_process_insert.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_sde.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_sde.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
Begin
  --
  Hig2.Upgrade  (
                p_Product        => 'NET', 
                p_Upgrade_Script => 'nm_4700_fix73.sql', 
                p_Remarks        => 'NET 4700 FIX 73 (Build 1)', 
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
