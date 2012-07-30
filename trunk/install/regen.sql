--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/regen.sql-arc   3.6   Jul 30 2012 15:05:20   Steve.Cooper  $
--       Module Name      : $Workfile:   regen.sql  $
--       Date into PVCS   : $Date:   Jul 30 2012 15:05:20  $
--       Date fetched Out : $Modtime:   Jul 30 2012 15:02:52  $
--       Version          : $Revision:   3.6  $
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
  l_View_Text  Clob;
Begin
  for y In  (
            Select      uv.View_Name 
            From        User_Views    uv,
                        User_Objects  uo
            Where       View_Name       =     uo.Object_Name
            And         Exists          (     Select  Null
                                              From    User_Dependencies   ud
                                              Where   ud.Name              =     uv.View_Name
                                              And     ud.Referenced_Name   =    'NM3CONTEXT'
                                        )
            And     Not Exists          (
                                              Select  Null
                                              From    User_Triggers
                                              Where   Table_Name            =   uv.View_Name
                                              And     Table_Owner           =   User
                                        )
            And         Exists          (
                                              Select  Null
                                              From    User_Tab_Columns
                                              Where   Table_Name            =   uv.View_Name
                                        )
            )
  Loop
    l_View_Text:=DBMS_METADATA.GET_DDL('VIEW',y.View_Name);
      If Instr(Upper(l_View_Text),'NM3CONTEXT.GET_EFFECTIVE_DATE')  > 0 Then           
        l_View_Text:= Replace ( Upper(l_View_Text), 'NM3CONTEXT.GET_EFFECTIVE_DATE' , 'to_date(sys_context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
      Begin
        Execute Immediate l_View_Text;
      Exception When Others Then
        Dbms_output.put_line(y.View_Name ||' - Creation Failed.');
      End;
    End If;
  End Loop;
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
    Begin
      Nm3Inv_View.Create_Inv_Nw_Trigger(pi_Inv_Type =>  x.Nit_Inv_Type);
    Exception When Others 
    Then
      dbms_output.put_line('Failed to create trigger for inv type: '||x.Nit_Inv_Type);
    End;
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
    Begin
      Nm3Inv_Api_Gen.Build_One(p_Inv_Type => x.Nit_Inv_Type );
    Exception When Others
    Then
      dbms_output.put_line('Failed to create package for inv type: '||x.Nit_Inv_Type);
    End;
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

Begin
  Hig2.Upgrade  (
                p_Product        => 'NET',
                p_Upgrade_Script => 'regen.sql',
                p_Remarks        => 'NET 4500 FIX 20',
                p_To_Version     => Null
                );
  Commit;
Exception
  When Others Then 
    Null;
End;
/