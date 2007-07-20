-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/set_exor_base.sql-arc   2.0   Jul 20 2007 14:10:54   gjohnson  $
--       Module Name      : $Workfile:   set_exor_base.sql  $
--       Date into PVCS   : $Date:   Jul 20 2007 14:10:54  $
--       Date fetched Out : $Modtime:   Jul 20 2007 13:20:18  $
--       Version          : $Revision:   2.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
cl scr
undefine exor_base
undefine run_file
undefine terminator
col exor_base new_value exor_base noprint
col run_file new_value run_file noprint
col terminator new_value terminator noprint

set define on
set echo off
set feedback on

define terminator='\'
define exor_base='&1'
Prompt Done
define
