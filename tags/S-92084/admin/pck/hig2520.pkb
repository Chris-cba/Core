Create Or Replace
Package Body  hig2520

As
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig2520.pkb-arc   1.0   Feb 07 2013 14:45:20   Steve.Cooper  $
--       Module Name      : $Workfile:   hig2520.pkb  $
--       Date into PVCS   : $Date:   Feb 07 2013 14:45:20  $
--       Date fetched Out : $Modtime:   Feb 07 2013 14:24:56  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version :
-------------------------------------------------------------------------

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_Body_Sccsid               Constant  Varchar2(2000)                      :=  '$Revision:   1.0  $';

--
-----------------------------------------------------------------------------
--
Function Get_Version Return Varchar2 
Is
Begin
   Return g_Sccsid;
End Get_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Body_Version Return Varchar2
Is
Begin
   Return g_Body_Sccsid;
End Get_Body_Version;
--
-----------------------------------------------------------------------------
--
Procedure Delete_Processes  (
                            p_Delete_Tab      In        t_Delete_Tab,
                            p_Exceptions_Tab      Out   t_Bulk_Exceptions_Tab
                            )
Is
  Dml_Errors  Exception;
  Pragma Exception_Init(Dml_Errors, -24381);
  
  Job_Not_Found Exception;
  Pragma Exception_Init(Job_Not_Found, -27475);
  
  l_Idx         Pls_Integer;
  l_Ptr         Pls_Integer;

Begin
  Nm_Debug.Debug('Hig2520.Delete_Processes - Called');
  l_Idx:=p_Delete_Tab.First;
  While l_Idx Is Not Null
  Loop
    Begin
      Nm_Debug.Debug('Idx:' || To_Char(l_Idx));
      Nm_Debug.Debug('About to Drop Job: ' || p_Delete_Tab(l_Idx).Job_Owner || '.' || p_Delete_Tab(l_Idx).Job_Name);
      Begin
        Dbms_Scheduler.Drop_Job (
                                    Job_Name  =>  p_Delete_Tab(l_Idx).Job_Owner || '.' || p_Delete_Tab(l_Idx).Job_Name,
                                    Force     =>  True
                                    );
        Nm_Debug.Debug('Job Dropped');
      Exception
        When Job_Not_Found Then
          Nm_Debug.Debug('Job Not Found :' || p_Delete_Tab(l_Idx).Job_Owner || '.' || p_Delete_Tab(l_Idx).Job_Name);
          --Do Nothing, since they wanted it dropping anyway.
      End;

      Delete
      From    Hig_Processes hp          
      Where   hp.Hp_Process_Id                  =       p_Delete_Tab(l_Idx).Process_Id    
      --Only Delete if the job got removed from the scheduler.
      And     (hp.Hp_Job_Owner,hp.Hp_Job_Name)  Not In  (
                                                        Select  dsj.Owner,
                                                                dsj.Job_Name
                                                        From    Dba_Scheduler_Jobs  dsj
                                                        );
      Commit;
    Exception
      When Others Then
        Nm_Debug.Debug('Exception :' || Sqlcode || ' For Job :' ||p_Delete_Tab(l_Idx).Job_Owner || '.' || p_Delete_Tab(l_Idx).Job_Name);
        p_Exceptions_Tab(l_Idx).Error_Code:=Sqlcode;
    End;
    l_Idx:=p_Delete_Tab.Next(l_Idx);
  End Loop;
  
  Commit;
  Nm_Debug.Debug('Hig2520.Delete_Processes - Finished');
   
End Delete_Processes;
--
-----------------------------------------------------------------------------
--
End  Hig2520;
/         

