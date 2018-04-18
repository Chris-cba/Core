--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm3data_install.sql-arc   2.2   Apr 18 2018 16:09:48   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm3data_install.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 16:09:48  $
--       Date fetched Out : $Modtime:   Apr 18 2018 16:02:10  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)nm3data_install.sql	1.6 01/31/06

set echo off
set linesize 120
set heading off
set feedback off

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
     Null;
END;
/
--
--
----------------------------------------------------------------------------
--Call a proc in nm_debug to instantiate it before calling metadata scripts.
--
--If this is not done any inserts into hig_option_values may fail due to
-- mutating trigger when nm_debug checks DEBUGAUTON.
----------------------------------------------------------------------------
BEGIN
  nm_debug.debug_off;
END;
/
--
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running nm3data1 ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data1' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running nm3data2 ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data2' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running nm3data3 ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data3' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running nm3data4 ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data4' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running nm3data5 ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data5' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running nm3data6 ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data6' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
-- nm3data7 not ran on install
--
SET TERM ON
prompt Running nm3data_help ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data_help.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
-- nm3data8 only runs if oracle spatial installed
--
SET TERM ON
prompt Running nm3data8 (only if Oracle Spatial installed on database instance)...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data8' run_file
from dual
where exists (select 1 from all_users where username = 'MDSYS')
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
from dual
where not exists (select 1 from all_users where username = 'MDSYS')
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running nm_themes_all_metadata ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm_themes_all_metadata.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
--
-------------------------------------------------------------------------------------------
--

