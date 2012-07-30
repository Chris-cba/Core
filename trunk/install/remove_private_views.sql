PROMPT Drop redundant objects from sub users

--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/remove_private_views.sql-arc   1.0   Jul 30 2012 12:48:20   Steve.Cooper  $
--       Module Name      : $Workfile:   remove_private_views.sql  $
--       Date into PVCS   : $Date:   Jul 30 2012 12:48:20  $
--       Date fetched Out : $Modtime:   Jul 30 2012 12:46:28  $
--       Version          : $Revision:   1.0  $
--
--   Script to remove private views and their related synonyms.
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
-

Declare
  l_Missing_Privs   Boolean:=False;
Begin
  Dbms_Output.Put_Line('Dropping Sub-User Views and Synonyms - Called');
  For x In  (
            Select  Name
            From    System_Privilege_Map
            Where   Name In  ('DROP ANY SYNONYM','DROP PUBLIC SYNONYM','DROP ANY VIEW')
            Minus
            Select  Privilege
            From    User_Sys_Privs
            Where   Privilege In  ('DROP ANY SYNONYM','DROP PUBLIC SYNONYM','DROP ANY VIEW')
            )
  Loop
    Dbms_Output.Put_Line('Privilege missing:' || x.Name);
    l_Missing_Privs:=True;
  End Loop;
  If NOT l_Missing_Privs Then
    For obj In  (
                With Check_For_Geom
                As
                (
                Select  dtc.Owner,
                        dtc.Table_Name        
                From    Dba_Tab_Columns   dtc
                Where   dtc.Data_Type   =   'SDO_GEOMETRY'
                )
                Select  y.Owner,
                        y.Name,
                        y.Type,
                        (
                        Case
                          When    y.Owner = 'PUBLIC' 
                              And y.Type  = 'SYNONYM' Then 'Drop Public Synonym ' || y.Name                                  
                          Else
                            'Drop ' || y.Type || ' ' || y.Owner || '.' || y.Name
                        End
                        )   Drop_DDL,
                        y.Sub_View_Owner,
                        y.Sub_View_Name,
                        y.Sub_View_Type,  
                        y.Sub_View_Geom,                           
                        (
                        Case
                          When  y.Sub_View_Owner Is Not Null Then
                            'Drop ' || y.Sub_View_Type || ' ' || y.Sub_View_Owner || '.' || y.Sub_View_Name
                          Else
                            Null
                        End
                        ) Sub_View_Drop_DDL,
                        y.Time_Stamp
                From    (        
                        Select  x.Owner,
                                x.Name,
                                x.Type,
                                x.Sub_View_Owner,
                                x.Sub_View_Name,
                                x.Sub_View_Type,  
                                x.Sub_View_Geom,
                                Sysdate Time_Stamp
                        From    (
                                Select      dd.Owner,
                                            dd.Name,
                                            dd.Type,
                                            dd2.Owner   Sub_View_Owner,
                                            dd2.Name    Sub_View_Name,
                                            dd2.Type    Sub_View_Type,
                                            Nvl((
                                            Select  'Y'
                                            From    Dba_Objects   dob
                                            Where   dob.Owner         =     Sys_Context('NM3CORE','APPLICATION_OWNER')
                                            And     dob.Object_Name   =     dd2.Name
                                            And     Exists            (
                                                                      Select  Null
                                                                      From    Check_For_Geom      cfg
                                                                      Where   cfg.Owner       =   dob.Owner
                                                                      And     cfg.Table_Name  =   dob.Object_Name
                                                                      )
                                            ),'N') Sub_View_Geom
                                From        Dba_Dependencies    dd,
                                            Dba_Dependencies    dd2
                                Where       dd.Referenced_Owner   =       Sys_Context('NM3CORE','APPLICATION_OWNER')
                                And         dd.Owner              <>      Sys_Context('NM3CORE','APPLICATION_OWNER')
                                And         dd.Type               In      ('VIEW')
                                And         dd.Referenced_Type    In      ('VIEW','TABLE')
                                And         Exists                (       Select  Null
                                                                          From    Check_For_Geom      cfg
                                                                          Where   cfg.Owner       =   dd.Owner
                                                                          And     cfg.Table_Name  =   dd.Name
                                                                  )
                                And         dd.Owner              =       dd2.Referenced_Owner(+)
                                And         dd.Name               =       dd2.Referenced_Name(+)
                                And         dd.Type               =       dd2.Referenced_Type(+)
                                ) x
                        Where       (   x.Sub_View_Owner  Is Null
                                    Or  x.Sub_View_Geom   = 'Y'
                                    )        
                        Union All
                        Select      dd.Owner,
                                    dd.Name,
                                    dd.Type,
                                    Null,
                                    Null,
                                    Null,
                                    Null,
                                    Sysdate
                        From        Dba_Dependencies    dd
                        Where       dd.Referenced_Owner   =       Sys_Context('NM3CORE','APPLICATION_OWNER')
                        And         dd.Owner              <>      Sys_Context('NM3CORE','APPLICATION_OWNER')
                        And         dd.Type               In      ('SYNONYM')
                        And         dd.Referenced_Type    In      ('VIEW','TABLE')
                        ) y
                )
    Loop
      Execute Immediate(obj.Drop_Ddl);
      If obj.Sub_View_Drop_DDL Is Not Null And  obj.Sub_View_Geom = 'Y' Then
        Execute Immediate(obj.Sub_View_Drop_DDL); 
      End If;
    End Loop;
  Else
    Raise_Application_Error(-20001,'Missing privileges whilst trying to drop redundant objects.' );
  End If;  
  Dbms_Output.Put_Line('Dropping Sub-User Views and Synonyms - Finished');
End;
/