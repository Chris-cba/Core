-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exit.sql-arc   2.1   Jul 04 2013 13:45:14   James.Wadsworth  $
--       Module Name      : $Workfile:   exit.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:58:14  $
--       Version          : $Revision:   2.1  $
--       Based on SCCS version : 1.1
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
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
