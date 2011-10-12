--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4500_sys_upg.sql-arc   1.2   Oct 12 2011 14:28:40   Steve.Cooper  $
--       Module Name      : $Workfile:   nm4500_sys_upg.sql  $
--       Date into PVCS   : $Date:   Oct 12 2011 14:28:40  $
--       Date fetched Out : $Modtime:   Oct 12 2011 14:26:26  $
--       PVCS Version     : $Revision:   1.2  $
--
--------------------------------------------------------------------------------
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

