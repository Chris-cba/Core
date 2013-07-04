--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4500_system_upg.sql-arc   1.1   Jul 04 2013 14:19:46   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4500_system_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:19:46  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:19:28  $
--       PVCS Version     : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
PROMPT
PROMPT Highways SYSTEM grants upgrade script
PROMPT Bentley Systems 2011
PROMPT
--
Begin
--
  If User = 'SYSTEM' Then 
    EXECUTE IMMEDIATE 'Grant Select on Sys.Dba_Scheduler_Jobs To Exor_Core';
  Else
    Raise_Application_Error(-20000, 'This script must be run as SYSTEM');
  End If;
--
End;
/
