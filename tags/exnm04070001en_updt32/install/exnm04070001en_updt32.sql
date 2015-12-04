-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/exnm04070001en_updt32.sql-arc   1.0   Nov 30 2015 09:06:24   Steve.Cooper  $
--       Module Name      : $Workfile:   exnm04070001en_updt32.sql  $
--       Date into PVCS   : $Date:   Nov 30 2015 09:06:24  $
--       Date fetched Out : $Modtime:   Nov 30 2015 08:55:46  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
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
SET TERM ON
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='exnm04070001en_uptd32_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');
--
--------------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT

BEGIN
   --
   -- Check that the user isn't sys or system
   --
   --
   IF USER IN ('SYS','SYSTEM')
   THEN
     RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
   END IF;

   --
   -- Check that NET has been installed @ v4.7.0.0
   --
   hig2.product_exists_at_version (p_product        => 'NET'
                                  ,p_VERSION        => '4.7.0.0'
                                  );
--
END;
/
--
Declare
  n  Varchar2(1);
Begin
  Select  Null
  Into    n
  From    Hig_Upgrades
  Where   Hup_Product     =   'NET'
  And     From_Version    =   '4.7.0.1'
  And     Upgrade_Script  =   'log_nm_4700_fix13.sql'
  And     rownum          =   1;
Exception 
  When No_Data_Found
Then
  RAISE_APPLICATION_ERROR(-20000,'Please install NM 4700 Fix 13 before proceding.');
End;
/
--
--
WHENEVER SQLERROR CONTINUE   
--
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
--
SET TERM ON 
PROMPT nm3close.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3close.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3merge.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3merge.pkw
SET FEEDBACK OFF
SET TERM ON 
PROMPT nm3replace.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3replace.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3split.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3split.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3undo.pkw
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
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'exnm04070001en_updt32.sql'
              ,p_remarks        => 'NET 4700 FIX 32'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/


SPOOL OFF
EXIT
--
--
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************