-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/set_exor_base.sql-arc   2.2   Apr 18 2018 16:09:56   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   set_exor_base.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 16:09:56  $
--       Date fetched Out : $Modtime:   Apr 18 2018 16:02:12  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
