--------------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3130_addb_upg.sql	1.2 09/22/04
--       Module Name      : nm3130_addb_upg.sql
--       Date into SCCS   : 04/09/22 16:51:41
--       Date fetched Out : 07/06/13 13:57:54
--       SCCS Version     : 1.2
--------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
--
undefine log_extension
col         log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
---------------------------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile='nm3130_addb_1_&log_extension'
spool &logfile
--
select 'Upgrade Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

WHENEVER SQLERROR CONTINUE
---------------------------------------------------------------------------------------------------
--                        ****************   PACKAGES   *******************
--
SET TERM ON
Prompt Packages...
SET TERM OFF
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3asset.pkh' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF

SET TERM OFF
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3asset.pkw' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   COMPILE SCHEMA   *******************
SET TERM ON
Prompt Creating Compiling Schema Script...
SET TERM OFF
SPOOL OFF

SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'utl'||'&terminator'||'compile_schema.sql' run_file
FROM dual
/
START '&run_file'

define logfile='nm3130_addb_2_&log_extension'
spool &logfile

START compile_all.sql
--
---------------------------------------------------------------------------------------------------
--
COMMIT;

spool off
exit;
