Create Or Replace Force View Hig_Processes_All_V
(
Hp_Process_Id,
Hp_Formatted_Process_Id,
Hp_Process_Type_Id,
Hp_Process_Type_Name,
Hp_Process_Limit,
Hp_Initiated_By_Username,
Hp_Initiated_Date,
Hp_Initiators_Ref,
Hp_Job_Name,
Hp_Job_Owner,
Hp_Full_Job_Name,
Hp_Frequency_Id,
Max_Runs,
Max_Failures,
Hp_Success_Flag,
Hp_Success_Flag_Meaning,
Hp_What_To_Call,
Hp_Polling_Flag,
Hp_Area_Type,
Hp_Area_Type_Description,
Hp_Area_Id,
Hp_Area_Meaning,
Hpj_Job_Action,
Hpj_Schedule_Type,
Hpj_Repeat_Interval,
Hpj_Job_State,
Hpj_Run_Count,
Hpj_Run_Failure_Count,
Hpj_Last_Run_Date,
Hpj_Next_Run_Date,
Hp_Requires_Attention_Flag,
Hp_Internal_Module,
Hp_Internal_Module_Title,
Hp_Internal_Module_Param
)
As
Select  --
        --
        -------------------------------------------------------------------------
        --   PVCS Identifiers :-
        --
        --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_processes_all_v.vw-arc   3.2   Jul 04 2013 11:20:06   James.Wadsworth  $
        --       Module Name      : $Workfile:   hig_processes_all_v.vw  $
        --       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
        --       Date fetched Out : $Modtime:   Jul 04 2013 10:55:54  $
        --       Version          : $Revision:   3.2  $
        -----------------------------------------------------------------------------
        --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
        -----------------------------------------------------------------------------
        --
        hp.Hp_Process_Id                                                            Hp_Process_Id,
        Hig_Process_Framework_Utils.Formatted_Process_Id (hp.Hp_Process_Id)         Hp_Formatted_Process_Id,
        hp.Hp_Process_Type_Id                                                       Hp_Process_Type_Id,
        hptv.Hpt_Name                                                               Hp_Process_Type_Name,
        hptv.Hpt_Process_Limit                                                      Hp_Process_Limit,
        hp.Hp_Initiated_By_Username                                                 Hp_Initiated_By_Username,
        hp.Hp_Initiated_Date                                                        Hp_Initiated_Date,
        hp.Hp_Initiators_Ref                                                        Hp_Initiators_Ref,
        hp.Hp_Job_Name                                                              Hp_Job_Name,
        hp.Hp_Job_Owner                                                             Hp_Job_Owner,
        hp.Hp_Job_Owner || '.' || hp.Hp_Job_Name                                    Hp_Full_Job_Name,
        hp.Hp_Frequency_Id                                                          Hp_Frequency_Id,
        dsj.Max_Runs                                                                Max_Runs,
        dsj.Max_Failures                                                            Max_Failures,
        hp.Hp_Success_Flag                                                          Hp_Success_Flag,
        (
        Select  hc.Hco_Meaning
        From    Hig_Codes       hc
        Where   hc.Hco_Domain   =   'PROCESS_SUCCESS_FLAG'
        And     hc.Hco_Code     =   hp.Hp_Success_Flag
        )                                                                           Hp_Success_Flag_Meaning,
        hp.Hp_What_To_Call                                                          Hp_What_To_Call,
        hp.Hp_Polling_Flag                                                          Hp_Polling_Flag,
        hp.Hp_Area_Type                                                             Hp_Area_Type,
        (
        Select    hpa.Hpa_Description
        From      Hig_Process_Areas     hpa
        Where     hpa.Hpa_Area_Type     =     hp.Hp_Area_Type
        )                                                                           Hp_Area_Type_Description,
        hp.Hp_Area_Id                                                               Hp_Area_Id,
        hp.Hp_Area_Meaning                                                          Hp_Area_Meaning,
        dsj.Job_Action                                                              Hpj_Job_Action,
        dsj.Schedule_Type                                                           Hpj_Schedule_Type,
        dsj.Repeat_Interval                                                         Hpj_Repeat_Interval,
        Decode (dsj.State,  'SUCCEEDED',  'Completed',
                            Null,         'Missing Job',
                            Initcap (dsj.State)
               )                                                                    Hpj_Job_State,
        (        
        Select    Count (hpjr.Hpjr_Process_Id)
        From      Hig_Process_Job_Runs    hpjr
        Where     hpjr.Hpjr_Process_Id    =     hp.Hp_Process_Id
        )                                                                           Hpj_Run_Count,
        (
        Select    Count (hpjr.Hpjr_Process_Id)
        From      Hig_Process_Job_Runs      hpjr
        Where     hpjr.Hpjr_Process_Id      =   hp.Hp_Process_Id
        And       hpjr.Hpjr_Success_Flag    =   'N'
        )                                                                           Hpj_Run_Failure_Count,
        Cast(Cast (dsj.Last_Start_Date As Timestamp With Local Time Zone) As Date)  Hpj_Last_Run_Date,
        (
        Case
          When dsj.State = 'SCHEDULED' Then
            Cast (Cast (dsj.Next_Run_Date As Timestamp With Local Time Zone) As Date)
             Else
                Null
          End
        )                                                                           Hpj_Next_Run_Date,
        (
        Case
          When    dsj.State In ('SCHEDULED', 'SUCCEEDED', 'DISABLED')
            And   (
                  Select    Count (hpjr.Hpjr_Process_Id)
                  From      Hig_Process_Job_Runs hpjr
                  Where     hpjr.Hpjr_Process_Id    = hp.Hp_Process_Id
                  And       hpjr.Hpjr_Success_Flag  = 'N'
                  )  = 0 Then 'N'
             Else 'Y'
        End
        )                                                                           Hp_Requires_Attention_Flag,
        hptv.Hpt_Internal_Module                                                    Hp_Internal_Module,
        hptv.Hpt_Internal_Module_Title                                              Hp_Internal_Module_Title,
        hptv.Hpt_Internal_Module_Param                                              Hp_Internal_Module_Param
From    Dba_Scheduler_Jobs          dsj,
        Hig_Users                   hu,
        Hig_Processes               hp,
        Hig_Process_Types_V         hptv
Where   hptv.Hpt_Process_Type_Id    =     hp.Hp_Process_Type_Id
And     hp.Hp_Job_Name              =     dsj.Job_Name(+)
And     dsj.Owner                   =     hu.Hus_Username(+)     
/

Comment On Table Hig_Processes_All_V Is 'Exor Process Framework view.  Show process and job details for all processes'
/


