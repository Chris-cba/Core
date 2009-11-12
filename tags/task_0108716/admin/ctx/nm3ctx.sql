-------------------------------------------------------------------------
--------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/ctx/nm3ctx.sql-arc   2.1   Nov 12 2009 12:13:44   cstrettle  $
--       Module Name      : $Workfile:   nm3ctx.sql  $
--       Date into PVCS   : $Date:   Nov 12 2009 12:13:44  $
--       Date fetched Out : $Modtime:   Nov 12 2009 12:07:10  $
--       Version          : $Revision:   2.1  $
--       Based on SCCS version : 2.0
--------------------------------------------------------------------
-- SCCS ID -- Do NOT remove -----
define sccsid = '$Revision:   2.1  $'
-------------------------------------------------------------------------
--	Copyright (c) 1997 exor corporation.
--
--	It should be executed during upgrades and new installations.
--
-------------------------------------------------------------------------

set echo off

col run_file new_value run_file noprint

set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'drop_policy.sql' run_file
from dual
/
start '&run_file'
--
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'add_policy.sql' run_file
from dual
/
start '&run_file'
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
set define on
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'nm_sql_context.sql' run_file
from dual
/
start '&run_file'
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
