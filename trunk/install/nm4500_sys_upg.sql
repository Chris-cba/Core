--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4500_sys_upg.sql-arc   1.3   Jul 04 2013 14:19:46   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4500_sys_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:19:46  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:19:16  $
--       PVCS Version     : $Revision:   1.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
PROMPT
PROMPT Highways SYS grants upgrade script
PROMPT Bentley Systems 2011
PROMPT
--
Begin
--
  If User = 'SYS' Then 
    EXECUTE IMMEDIATE 'Grant Select on Sys.Dba_Scheduler_Jobs To system with grant option';
  Else
    Raise_Application_Error(-20000, 'This script must be run as SYS');
  End If;
--
End;
/

