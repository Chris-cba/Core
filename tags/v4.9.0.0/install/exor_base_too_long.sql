--
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/exor_base_too_long.sql-arc   2.2   Apr 18 2018 15:47:20   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   exor_base_too_long.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 15:47:20  $
--       Date fetched Out : $Modtime:   Apr 18 2018 15:46:12  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
undefine leave_it
col leave_it new_value leave_it noprint
set term on
prompt
prompt &exor_base was specified as the exor base location.
prompt
prompt Value entered for exor base is greater than the permitted length of 30 characters
prompt
prompt Please re-run the script and enter a valid exor base value.
prompt
prompt
prompt
accept leave_it prompt "Press RETURN to exit SQL*PLUS"
prompt
exit;
