--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/regen.sql-arc   3.0   Sep 16 2011 10:38:18   Mike.Alexander  $
--       Module Name      : $Workfile:   regen.sql  $
--       Date into PVCS   : $Date:   Sep 16 2011 10:38:18  $
--       Date fetched Out : $Modtime:   Sep 16 2011 10:26:50  $
--       Version          : $Revision:   3.0  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
Begin
  Nm3sdm.Rebuild_All_Inv_Sdo_Join_View;
  Nm3sdm.Rebuild_All_Nat_Sdo_Join_View;
  Nm3sdm.Rebuild_All_Nlt_Sdo_Join_Views;
End;  
/

Declare
  l_tab_view_name              nm3type.tab_varchar32767;
  l_tab_view_source            nm3type.tab_varchar32767;
Begin
--
  Select      uv.View_Name,
              uv.Text
  Bulk Collect
  Into        l_Tab_View_Name,
              l_Tab_View_Source 
  From        User_Views    uv,
              User_Objects  uo
  Where       uo.Status       =     'INVALID'
  And         View_Name       =     uo.Object_Name
  And         Exists          (     Select  Null
                                    From    User_Dependencies   ud
                                    Where   ud.Name              =     uv.View_Name
                                    And     ud.Referenced_Name   =    'NM3CONTEXT'
                                    );
  --
  For i In 1..l_Tab_View_Name.Count
  Loop
    l_Tab_View_Source(i) := Replace ( Upper(l_Tab_View_Source(i)), 'NM3CONTEXT.GET_EFFECTIVE_DATE' , 'to_date(sys_context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
    --
    Execute Immediate 'CREATE OR REPLACE FORCE VIEW '|| l_Tab_View_Name(i)||' As '|| l_Tab_View_Source(i);
  End Loop;
--
End;
/

Begin
  For x In  (
            Select  nita.Nit_Inv_Type,
                    ut.Trigger_Name
            From    User_Triggers       ut,
                    Nm_Inv_Types_All    nita
            Where   ut.Base_Object_Type   =   'VIEW'
            And     ut.Table_Name         =   'V_NM_'|| nita.Nit_Inv_Type||'_NW'
            )
  Loop
    Nm3Inv_View.Create_Inv_Nw_Trigger(pi_Inv_Type =>  x.Nit_Inv_Type);
  End Loop;
  --
  For x In  (
            Select  nita.Nit_Inv_Type
            From    User_Objects      uo,
                    Nm_Inv_Types_All  nita
            Where   uo.Object_Name    Like  '%API%'
            And     uo.Object_Type    =     'PACKAGE'
            And     uo.Object_Name    =     'NM3API_INV_'|| nita.Nit_Inv_Type
            )
  Loop
    Nm3Inv_Api_Gen.Build_One(p_Inv_Type => x.Nit_Inv_Type );
  End Loop; 

End;
/

Declare
  user_not_found Exception;
  Pragma Exception_Init (user_not_found, -20493);
  compilation_error Exception;
  Pragma Exception_Init (compilation_error, -24344);
Begin
  For x In (
            Select hu.hus_username
            From   hig_users hu
            Where  hu.hus_username <> Sys_Context('NM3_SECURITY_CTX', 'USERNAME')
           )
  Loop
    dbms_output.put_line('User: '||x.hus_username);
    Begin
      nm3context.create_instantiate_user_trig( pi_new_trigger_owner => x.hus_username);
    Exception
    When user_not_found Then
      dbms_output.put_line('User: '||x.hus_username||' is NOT a Database user, but is listed in hig_users.');
    When compilation_error Then
      dbms_output.put_line(x.hus_username||'. Instantiate_User - Failed to Compile.');
    End;
  End Loop;
End;
/ 