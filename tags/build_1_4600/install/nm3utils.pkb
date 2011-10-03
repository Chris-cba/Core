Create or Replace Package Body Exor_Core.Nm3Utils
As  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3utils.pkb-arc   1.0   Oct 03 2011 09:33:38   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3utils.pkb  $
--       Date into PVCS   : $Date:   Oct 03 2011 09:33:38  $
--       Date fetched Out : $Modtime:   Sep 19 2011 10:17:34  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version :
-------------------------------------------------------------------------

  gc_Body_Sccsid              Constant  Varchar2(2000)                  :=  '$Revision:   1.0  $';
    

Function Get_Version Return Varchar2
Is
Begin
   Return gc_Sccsid;
End Get_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Body_Version Return Varchar2
Is
Begin
   Return gc_Body_Sccsid;
End Get_Body_Version;
--
-----------------------------------------------------------------------------
--
Procedure Disable_All_User_Schd_Jobs  (
                                      p_User    In  Dba_Scheduler_Jobs.Job_Creator%Type
                                      )
Is
Begin
  Dbms_Output.Put_Line('Disable_All_User_Schd_Jobs - Called');
  Dbms_Output.Put_Line('Parameter - p_User:' || p_User);
  For x In  ( 
            Select  dsj.Job_Name
            From    Dba_Scheduler_Jobs    dsj
            Where   dsj.Job_Creator   =     p_User
            And     dsj.State         <>    'DISABLED'
            )
  Loop
    Dbms_Output.Put_Line('Job Found :' || x.Job_Name);
    Dbms_Scheduler.Disable(Name => p_User || '.' ||  x.Job_Name, Force => True);
  End Loop;
  Dbms_Output.Put_Line('Disable_All_User_Schd_Jobs - Finished');
End Disable_All_User_Schd_Jobs;
--
-----------------------------------------------------------------------------
--
Function  User_Has_Active_Jobs  (
                                p_User    In  Dba_Scheduler_Jobs.Job_Creator%Type
                                ) Return Binary_Integer
Is
  l_Job_Count   Binary_Integer;
Begin
  Select  Count(*)
  Into    l_Job_Count
  From    Dba_Scheduler_Jobs      dsj
  Where   dsj.Job_Creator   =     p_User
  And     dsj.State         <>    'DISABLED';

  Return(l_Job_Count);

End User_Has_Active_Jobs;
--
-----------------------------------------------------------------------------
--
End Nm3Utils;
/