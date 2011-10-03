--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4500_sys_upg.sql-arc   1.0   Oct 03 2011 10:23:36   Steve.Cooper  $
--       Module Name      : $Workfile:   nm4500_sys_upg.sql  $
--       Date into PVCS   : $Date:   Oct 03 2011 10:23:36  $
--       Date fetched Out : $Modtime:   Oct 03 2011 10:21:12  $
--       PVCS Version     : $Revision:   1.0  $
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
    EXECUTE IMMEDIATE 'Grant Select on Sys.Dba_Scheduler_Jobs To Exor_Core';
  Else
    Raise_Application_Error(-20000, 'This script must be run as SYS');
  End If;
--
End;
/

