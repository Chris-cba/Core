Create or Replace Package Body Exor_Core.Nm3Utils
As  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3utils.pkb-arc   1.1   Jul 04 2013 14:09:34   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3utils.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:34  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:40:52  $
--       Version          : $Revision:   1.1  $
--       Based on SCCS version :
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  gc_Body_Sccsid              Constant  Varchar2(2000)                  :=  '$Revision:   1.1  $';
    

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
