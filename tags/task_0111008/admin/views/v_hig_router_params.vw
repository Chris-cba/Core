Create Or Replace Force View V_Hig_Router_Params
(
Router_Id,
Param_Name,
Param_Value
)
As
Select  
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_hig_router_params.vw-arc   1.1   Nov 21 2011 11:08:14   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_hig_router_params.vw  $
          --       Date into PVCS   : $Date:   Nov 21 2011 11:08:14  $
          --       Date fetched Out : $Modtime:   Nov 21 2011 10:46:24  $
          --       Version          : $Revision:   1.1  $
          --
          --
          -------------------------------------------------------------------------
          hrp.Hrp_Router_Id,
          hrp.Hrp_Param_Name,
          (
          Case
            --Columns are mutually exclusive.
            When hrp.Hrp_Param_Value_Varchar  Is Not Null Then hrp.Hrp_Param_Value_Varchar 
            When hrp.Hrp_Param_Value_Number   Is Not Null Then To_Char(hrp.Hrp_Param_Value_Number)
            When hrp.Hrp_Param_Value_Date     Is Not Null Then To_Char(hrp.Hrp_Param_Value_Date,'DD-MM-YYYY HH24:MI.SS')
          End
          ) Param_Value
From      Hig_Router_Params hrp
Where     hrp.Hrp_Param_Name    Is  Not Null
Order By  hrp.Hrp_Router_Id Asc,
          hrp.Hrp_Param_Name Asc
With Read Only
/

Comment on Table V_Hig_Router_Params Is 'Provides the parameters that were used for a particular routed forms call.'
/

Comment on Column V_Hig_Router_Params.Router_Id Is 'The unique id of the routed forms session.'
/

Comment on Column V_Hig_Router_Params.Param_Name Is 'The name of the parameter.'
/

Comment on Column V_Hig_Router_Params.Param_Value Is 'The value of the parameter in varchar2 format.'
/


