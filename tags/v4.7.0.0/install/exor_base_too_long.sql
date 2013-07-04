--
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exor_base_too_long.sql-arc   2.1   Jul 04 2013 13:45:14   James.Wadsworth  $
--       Module Name      : $Workfile:   exor_base_too_long.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:59:22  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
