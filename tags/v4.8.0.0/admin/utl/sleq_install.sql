--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/sleq_install.sql-arc   2.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   sleq_install.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:51:54  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
define sccsid = '@(#)sleq_install.sql	1.2 07/06/05'

set echo off
set linesize 120
set heading off
set feedback off
set verify off

--
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
---------------------------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='sleq_install_1_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;


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


WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--                        ****************   META-DATA  *******************
SET TERM ON
prompt Meta-Data...
SET TERM OFF
SET FEEDBACK ON
start sleqdata1.sql
SET FEEDBACK OFF
--
-------
--
SET TERM OFF
SET FEEDBACK ON
start sleqdata2.sql
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                            ****************   VIEWS  *******************
SET TERM ON
prompt Views...
SET TERM OFF
BEGIN
 nm3inv_view.create_view (p_inventory_type  => 'SLEQ'
                         ,p_join_to_network => FALSE);
END;
/
--
-----------------------
--
SET TERM OFF
SET FEEDBACK ON
start sleq_ao_energy_procurement_v.vw
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--
spool off
exit

