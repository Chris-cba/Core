-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exit.sql-arc   2.0   Jul 19 2007 08:26:00   gjohnson  $
--       Module Name      : $Workfile:   exit.sql  $
--       Date into PVCS   : $Date:   Jul 19 2007 08:26:00  $
--       Date fetched Out : $Modtime:   Jul 18 2007 15:46:40  $
--       Version          : $Revision:   2.0  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
undefine leave_it
col leave_it new_value leave_it noprint
prompt
prompt
prompt
prompt Upgrade process aborted at user request.
prompt
prompt
prompt
accept leave_it prompt "Press RETURN to exit SQL*PLUS"
prompt
exit;
