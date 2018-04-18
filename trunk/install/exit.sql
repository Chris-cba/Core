-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/exit.sql-arc   2.2   Apr 18 2018 15:42:32   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   exit.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 15:42:32  $
--       Date fetched Out : $Modtime:   Apr 18 2018 15:41:30  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
