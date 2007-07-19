-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/inv_term.sql-arc   2.0   Jul 19 2007 08:26:00   gjohnson  $
--       Module Name      : $Workfile:   inv_term.sql  $
--       Date into PVCS   : $Date:   Jul 19 2007 08:26:00  $
--       Date fetched Out : $Modtime:   Jul 18 2007 15:46:24  $
--       Version          : $Revision:   2.0  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------

undefine leave_it
col leave_it new_value leave_it noprint
set term on
prompt
prompt &exor_base was specified as the exor base location.
prompt
prompt Value entered for exor base does not end with a recognised directory
prompt terminator. 
prompt
prompt Please re-run the installation script and enter a valid exor base value.
prompt
prompt
prompt
accept leave_it prompt "Press RETURN to exit SQL*PLUS"
prompt
exit;
