Create Or Replace Force View V_Nm_Gaz_Query_Attribs_Saved
(
Vngqas_Ngqa_Ngq_Id,
Vngqas_Ngqa_Operator,
Vngqas_Ngqa_Attrib_Name,
Vngqas_Ngqa_Pre_Bracket,
Vngqas_Ngqa_Condition,
Vngqvs_Ngqv_Value,
Vngqas_Post_Bracket
)
As
Select
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_gaz_query_attribs_saved.vw-arc   3.4   Apr 13 2018 11:47:24   Gaurav.Gaurkar  $
          --       Module Name      : $Workfile:   v_nm_gaz_query_attribs_saved.vw  $
          --       Date into PVCS   : $Date:   Apr 13 2018 11:47:24  $
          --       Date fetched Out : $Modtime:   Apr 13 2018 11:38:10  $
          --       Version          : $Revision:   3.4  $
          --       Based on SCCS version : 
          -----------------------------------------------------------------------------
          --    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          --
          qas.Ngqas_Ngq_Id              Vngqas_Ngqa_Ngq_Id,
          qas.Ngqas_Operator            Vngqas_Ngqa_Operator,
          qas.Ngqas_Attrib_Name         Vngqas_Ngqa_Attrib_Name,
          qas.Ngqas_Pre_Bracket         Vngqas_Ngqa_Pre_Bracket,
          qas.Ngqas_Condition           Vngqas_Ngqa_Condition,
          qvs.Ngqvs_Value               Vngqvs_Ngqv_Value,
          qas.Ngqas_Post_Bracket        Vngqas_Ngqa_Post_Bracket
From      Nm_Gaz_Query_Attribs_Saved    qas,
          Nm_Gaz_Query_Values_Saved     qvs,
          v_Nm_Gaz_Query_Saved          gqs        
Where     gqs.Vngqs_Ngqs_Ngq_Id   =   qas.Ngqas_Ngq_Id
And       qas.Ngqas_Ngq_Id        =   qvs.Ngqvs_Ngq_Id(+) 
And       qas.Ngqas_Ngqt_Seq_No   =   qvs.Ngqvs_Ngqt_Seq_No(+) 
And       qas.Ngqas_Seq_No        =   qvs.Ngqvs_Ngqa_Seq_No(+)
Order By  qas.Ngqas_Ngq_Id,
          qas.Ngqas_Ngqt_Seq_No,
          qas.Ngqas_Seq_No,
          qvs.ngqvs_Sequence
/
