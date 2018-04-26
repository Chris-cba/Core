-------------------------------------------------------------------------
--------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/ctx/nm3ctx.sql-arc   2.6   Apr 26 2018 08:56:42   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm3ctx.sql  $
--       Date into PVCS   : $Date:   Apr 26 2018 08:56:42  $
--       Date fetched Out : $Modtime:   Apr 26 2018 08:50:48  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 2.0
--------------------------------------------------------------------
-- SCCS ID -- Do NOT remove -----
define sccsid = '$Revision:   2.6  $'
-------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--
--	It should be executed during upgrades and new installations.
--
-------------------------------------------------------------------------

set echo off

col run_file new_value run_file noprint

--set define on
--select '&exor_base'||'nm3'||'&terminator'||'admin'||
--         '&terminator'||'ctx'||'&terminator'||'drop_policy.sql' run_file
--from dual
--/
--start '&run_file'
--
--set define on
--select '&exor_base'||'nm3'||'&terminator'||'admin'||
--         '&terminator'||'ctx'||'&terminator'||'add_policy.sql' run_file
--from dual
--/
--start '&run_file'
--
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'invsec.pkh' run_file
from dual
/
start '&run_file'
--
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'invsec.pkw' run_file
from dual
/
start '&run_file'
--
--
-- MRGSEC package not used any more
--
--set define on
--select '&exor_base'||'nm3'||'&terminator'||'admin'||
--         '&terminator'||'ctx'||'&terminator'||'mrgsec.pkh' run_file
--from dual
--/
--start '&run_file'
--
--set define on
--select '&exor_base'||'nm3'||'&terminator'||'admin'||
--         '&terminator'||'ctx'||'&terminator'||'mrgsec.pkw' run_file
--from dual
--/
--start '&run_file'
--
--
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'HIG_PROCESS_SECURITY.pkh' run_file
from dual
/
start '&run_file'
--
--
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'HIG_PROCESS_SECURITY.pkw' run_file
from dual
/
start '&run_file'
--