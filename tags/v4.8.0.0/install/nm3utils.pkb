Create or Replace Package Body Exor_Core.Nm3Utils
As  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm3utils.pkb-arc   1.2   Apr 18 2018 16:09:48   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm3utils.pkb  $
--       Date into PVCS   : $Date:   Apr 18 2018 16:09:48  $
--       Date fetched Out : $Modtime:   Apr 18 2018 16:02:10  $
--       Version          : $Revision:   1.2  $
--       Based on SCCS version :
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  gc_Body_Sccsid              Constant  Varchar2(2000)                  :=  '$Revision:   1.2  $';
    

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
