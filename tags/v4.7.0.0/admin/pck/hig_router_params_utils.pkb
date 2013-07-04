--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_router_params_utils.pkb-arc   5.5   Jul 04 2013 14:57:02   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_router_params_utils.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:57:02  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:53:58  $
--       Version          : $Revision:   5.5  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
Create Or Replace Package Body Hig_Router_Params_Utils
Is
    
  --g_body_sccsid is the SCCS ID for the package body
  g_Body_Sccsid             Constant  Varchar2(2000)              :=  '$Revision:   5.5  $';
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
  Function  Get_New_Router_Id Return Hig_Router_Params.Hrp_Router_Id%Type
  Is
    l_Router_Id   Hig_Router_Params.Hrp_Router_Id%Type;
  Begin
    Nm_Debug.Debug('Hig_Router_Params_Utils.Get_New_Router_Id - Called');
    Select  Hig_Router_Params_Seq.Nextval
    Into    l_Router_Id
    From    Dual;
    Nm_Debug.Debug('Hig_Router_Params_Utils.Get_New_Router_Id - Finished - Returning :' || To_Char(l_Router_Id) );
    Return(l_Router_Id);
    
  End Get_New_Router_Id;
  --
  Procedure Add_Param (
                      p_Router_Id     In  Hig_Router_Params.Hrp_Router_Id%Type,
                      p_Param_Name    In  Hig_Router_Params.Hrp_Param_Name%Type,
                      p_Param_Value   In  Hig_Router_Params.Hrp_Param_Value_Varchar%Type
                      )
  Is
  Begin
    Nm_Debug.Debug('Hig_Router_Params_Utils.Add_Param - Called');
    Nm_Debug.Debug('Parameter - p_Router_Id :'    || To_Char(p_Router_Id));
    Nm_Debug.Debug('Parameter - p_Param_Name :'   || p_Param_Name);
    Nm_Debug.Debug('Parameter - p_Param_Value :'  || p_Param_Value);
    If p_Param_Name Is Not Null Then
      Insert Into Hig_Router_Params
      (
      Hrp_Router_Id,
      Hrp_Param_Name,
      Hrp_Param_Value_Varchar
      )
      Values
      (
      p_Router_Id,
      p_Param_Name,
      p_Param_Value
      );
      Commit;
      Nm_Debug.Debug('Inserted Parameter');
    End If;
    Nm_Debug.Debug('Hig_Router_Params_Utils.Add_Param - Finished');
  End Add_Param;
  --
  Procedure Add_Param (
                      p_Router_Id     In  Hig_Router_Params.Hrp_Router_Id%Type,
                      p_Param_Name    In  Hig_Router_Params.Hrp_Param_Name%Type,
                      p_Param_Value   In  Hig_Router_Params.Hrp_Param_Value_Number%Type
                      )
  Is
  Begin
    Nm_Debug.Debug('Hig_Router_Params_Utils.Add_Param (Overloaded (Number)) - Called');
    Nm_Debug.Debug('Parameter - p_Router_Id :'    || To_Char(p_Router_Id));
    Nm_Debug.Debug('Parameter - p_Param_Name :'   || p_Param_Name);
    Nm_Debug.Debug('Parameter - p_Param_Value :'  || To_Char(p_Param_Value));
    If p_Param_Name Is Not Null Then
      Insert Into Hig_Router_Params
      (
      Hrp_Router_Id,
      Hrp_Param_Name,
      Hrp_Param_Value_Number
      )
      Values
      (
      p_Router_Id,
      p_Param_Name,
      p_Param_Value
      );
      Commit;
      Nm_Debug.Debug('Inserted Parameter');
    End If;

    Nm_Debug.Debug('Hig_Router_Params_Utils.Add_Param (Overloaded (Number)) - Finished');              
  End Add_Param;                      
  --                      
  Procedure Add_Param (
                      p_Router_Id     In  Hig_Router_Params.Hrp_Router_Id%Type,
                      p_Param_Name    In  Hig_Router_Params.Hrp_Param_Name%Type,
                      p_Param_Value   In  Hig_Router_Params.Hrp_Param_Value_Date%Type
                      )
  Is
  Begin
    Nm_Debug.Debug('Hig_Router_Params_Utils.Add_Param (Overloaded (Date)) - Called');
    Nm_Debug.Debug('Parameter - p_Router_Id :'    || To_Char(p_Router_Id));
    Nm_Debug.Debug('Parameter - p_Param_Name :'   || p_Param_Name);
    Nm_Debug.Debug('Parameter - p_Param_Value :'  || To_Char(p_Param_Value,'DD-MM-YYYY HH24:MI.SS'));  
    If p_Param_Name Is Not Null Then
      Insert Into Hig_Router_Params
      (
      Hrp_Router_Id,
      Hrp_Param_Name,
      Hrp_Param_Value_Date
      )
      Values
      (
      p_Router_Id,
      p_Param_Name,
      p_Param_Value
      );
      Commit;
      Nm_Debug.Debug('Inserted Parameter');
    End If;
    Nm_Debug.Debug('Hig_Router_Params_Utils.Add_Param (Overloaded (Date)) - Finished');              
  End Add_Param;
  --
  Function Get_Params (
                      p_Router_Id   In  Hig_Router_Params.Hrp_Router_Id%Type
                      ) Return t_Param_Tab
  Is
  l_Param_Tab  t_Param_Tab;
  Begin
    Nm_Debug.Debug('Hig_Router_Params_Utils.Get_Params - Called');
    Select  Param_Name,
            Param_Value
    Bulk Collect 
    Into    l_Param_Tab
    From    V_Hig_Router_Params
    Where   Router_Id   = p_Router_Id;
    
    Nm_Debug.Debug('Rows retrieved :' || l_Param_Tab.Count);
    
    Nm_Debug.Debug('Hig_Router_Params_Utils.Get_Params - Finished');
        
    Return (l_Param_Tab);
    
  End Get_Params;
  
  Procedure Clear_Down_Old_Params (
                                  p_Clear_Down_Date   In  Date  Default Trunc(Sysdate-1)
                                  )
  Is
  Begin
    Nm_Debug.Debug('Hig_Router_Params_Utils.Clear_Down_Old_Params - Called');  
    Delete 
    From    Hig_Router_Params
    Where   Hrp_Param_Created < p_Clear_Down_Date;
    Nm_Debug.Debug('Parameters cleared :' || Sql%Rowcount);
    Nm_Debug.Debug('Hig_Router_Params_Utils.Clear_Down_Old_Params - Finished');
  End Clear_Down_Old_Params;
  
End Hig_Router_Params_Utils;
/
