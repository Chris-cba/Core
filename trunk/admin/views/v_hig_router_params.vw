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
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_hig_router_params.vw-arc   1.0   Nov 16 2011 15:26:18   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_hig_router_params.vw  $
          --       Date into PVCS   : $Date:   Nov 16 2011 15:26:18  $
          --       Date fetched Out : $Modtime:   Nov 16 2011 10:18:50  $
          --       Version          : $Revision:   1.0  $
          --
          --
          -------------------------------------------------------------------------
          hrp.Router_Id,
          hrp.Param_Name,
          (
          Case
            --Columns are mutually exclusive.
            When hrp.Param_Value_Varchar  Is Not Null Then hrp.Param_Value_Varchar 
            When hrp.Param_Value_Number   Is Not Null Then To_Char(hrp.Param_Value_Number)
            When hrp.Param_Value_Date     Is Not Null Then To_Char(hrp.Param_Value_Date,'DD-MM-YYYY HH24:MI.SS')
          End
          ) Param_Value
From      Hig_Router_Params hrp
Where     hrp.Param_Name    Is  Not Null
Order By  hrp.Router_Id Asc,
          hrp.Param_Name Asc
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


