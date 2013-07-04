-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/set_exor_base.sql-arc   2.1   Jul 04 2013 14:17:18   James.Wadsworth  $
--       Module Name      : $Workfile:   set_exor_base.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:17:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:42:30  $
--       Version          : $Revision:   2.1  $
--       Based on SCCS version : 
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
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
