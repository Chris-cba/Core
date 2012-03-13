--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4301_fix14.sql-arc   3.0   Mar 13 2012 11:09:26   Mike.Alexander  $
--       Module Name      : $Workfile:   nm_4301_fix14.sql  $
--       Date into PVCS   : $Date:   Mar 13 2012 11:09:26  $
--       Date fetched Out : $Modtime:   Mar 13 2012 11:03:42  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
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
define logfile1='nm_4301_fix14_1_&log_extension'
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
END;
/

--
-- Check that HIG has been installed @ v4.3.0.0 or v4.3.0.1
--
Declare
   l_rec_hpr    hig_products%Rowtype;
Begin
  --
  -- get row from hig products for product you are checking 
  l_rec_hpr := nm3get.get_hpr( pi_hpr_product     => 'HIG'--p_product
                             , pi_raise_not_found => TRUE
                             );
  --
  If l_rec_hpr.hpr_version Not In ('4.3.0.1','4.3.0.0')
  Or l_rec_hpr.hpr_key Is Null 
  Then
    RAISE_APPLICATION_ERROR(-20000,'Installation terminated: "HIG" version 4.3.0.1 or 4.3.0.0 must be installed and licensed');
  End If;
End;
/
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3gaz_qry.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3gaz_qry.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4301_fix14.sql 
--
SET FEEDBACK ON
start log_nm_4301_fix14.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--