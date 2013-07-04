PROMPT Drop redundant objects from sub users

--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/remove_private_views.sql-arc   1.3   Jul 04 2013 14:17:18   James.Wadsworth  $
--       Module Name      : $Workfile:   remove_private_views.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:17:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:42:20  $
--       Version          : $Revision:   1.3  $
--
--   Script to remove private views and their related synonyms.
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--

Declare
  l_Missing_Privs   Boolean:=False;
Begin
  Dbms_Output.Put_Line('Dropping Sub-User Views and Synonyms - Called');
--  
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
        WITH Check_For_Geom
             AS (SELECT dtc.Owner, dtc.Table_Name
                   FROM Dba_Tab_Columns dtc
                  WHERE     dtc.Data_Type = 'SDO_GEOMETRY'
                        AND dtc.Table_name NOT LIKE 'V_MCP%')
        SELECT y.Owner,
               y.Name,
               y.TYPE,
               ('Drop ' || y.TYPE || ' ' || y.Owner || '.' || y.Name) Drop_DDL,
               y.Sub_View_Owner,
               y.Sub_View_Name,
               y.Sub_View_Type,
               y.Sub_View_Geom,
               (CASE
                   WHEN y.Sub_View_Owner IS NOT NULL
                   THEN
                         'Drop '
                      || y.Sub_View_Type
                      || ' '
                      || y.Sub_View_Owner
                      || '.'
                      || y.Sub_View_Name
                   ELSE
                      NULL
                END)
                  Sub_View_Drop_DDL,
               y.Time_Stamp
          FROM (SELECT x.Owner,
                       x.Name,
                       x.TYPE,
                       x.Sub_View_Owner,
                       x.Sub_View_Name,
                       x.Sub_View_Type,
                       x.Sub_View_Geom,
                       SYSDATE Time_Stamp
                  FROM (SELECT dd.Owner,
                               dd.Name,
                               dd.TYPE,
                               dd2.Owner Sub_View_Owner,
                               dd2.Name Sub_View_Name,
                               dd2.TYPE Sub_View_Type,
                               NVL (
                                  (SELECT 'Y'
                                     FROM Dba_Objects dob
                                    WHERE     dob.Owner = nvl(Sys_Context('NM3CORE','APPLICATION_OWNER'), user)
                                          AND dob.Object_Name = dd2.Name
                                          AND EXISTS
                                                 (SELECT NULL
                                                    FROM Check_For_Geom cfg
                                                   WHERE     cfg.Owner = dob.Owner
                                                         AND cfg.Table_Name =
                                                                dob.Object_Name)),
                                  'N')
                                  Sub_View_Geom
                          FROM Dba_Dependencies dd, Dba_Dependencies dd2
                         WHERE     dd.Referenced_Owner = nvl(Sys_Context('NM3CORE','APPLICATION_OWNER'), user )
                               AND dd.Owner <> nvl(Sys_Context('NM3CORE','APPLICATION_OWNER'), user)
                               AND dd.TYPE IN ('VIEW')
                               AND dd.Referenced_Type IN ('VIEW', 'TABLE')
                               AND EXISTS
                                      (SELECT NULL
                                         FROM Check_For_Geom cfg
                                        WHERE     cfg.Owner = dd.Owner
                                              AND cfg.Table_Name = dd.Name)
                               AND dd.Owner = dd2.Referenced_Owner(+)
                               AND dd.Name = dd2.Referenced_Name(+)
                               AND dd.TYPE = dd2.Referenced_Type(+)) x
                 WHERE (x.Sub_View_Owner IS NULL OR x.Sub_View_Geom = 'Y')) y
         WHERE EXISTS
                  (SELECT 1
                     FROM dba_objects
                    WHERE     owner = USER
                          AND name = object_name
                          AND object_type IN ('VIEW', 'TABLE'))
                        )
    Loop
      begin
        Execute Immediate(obj.Drop_Ddl);
      exception
        when others then
          nm_debug.debug_on;
          nm_debug.debug('RPV - '||sqlerrm );
          nm_debug.debug(obj.Drop_Ddl);
      end;
--      
      If obj.Sub_View_Drop_DDL Is Not Null And  obj.Sub_View_Geom = 'Y' Then
      begin
        Execute Immediate(obj.Sub_View_Drop_DDL); 
      exception
        when others then
          nm_debug.debug_on;
          nm_debug.debug('RPV - '||sqlerrm );
          nm_debug.debug(obj.Sub_View_Drop_DDL);
      end;
--
      End If;
    End Loop;
  Else
    Raise_Application_Error(-20001,'Missing privileges whilst trying to drop redundant objects.' );
  End If;  
  Dbms_Output.Put_Line('Dropping Sub-User Views and Synonyms - Finished');
End;
/
