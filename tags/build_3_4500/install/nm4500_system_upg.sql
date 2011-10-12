--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4500_system_upg.sql-arc   1.0   Oct 12 2011 14:29:30   Steve.Cooper  $
--       Module Name      : $Workfile:   nm4500_system_upg.sql  $
--       Date into PVCS   : $Date:   Oct 12 2011 14:29:30  $
--       Date fetched Out : $Modtime:   Oct 12 2011 14:27:18  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
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
