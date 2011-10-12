------------------------------------------------------------------
-- nm4400_nm4500_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4400_nm4500_metadata_upg.sql-arc   3.2   Oct 12 2011 15:37:16   Mike.Alexander  $
--       Module Name      : $Workfile:   nm4400_nm4500_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Oct 12 2011 15:37:16  $
--       Date fetched Out : $Modtime:   Oct 12 2011 15:29:00  $
--       Version          : $Revision:   3.2  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
 Null;
END;
/

BEGIN
  nm_debug.debug_off;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Error Messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110847
-- 
-- TASK DETAILS
-- Previously a number of network edits would only be available to unrestricted users. The security has been modified to allow restricted users that can see all the network to make edits also. This included areas such as Closing Elements, Unclosing Elements, Reclassify, Closing of Group of Group and Group of Sections.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- All new or modified error messages for the 4500 release.
-- 
------------------------------------------------------------------
UPDATE nm_errors
SET ner_descr = 'User does not have access to all assets on the element'
WHERE ner_appl = 'NET'
AND ner_id = 172
/

INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 556
     , 'Update is not possible. This inventory and network type combination has child records.'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 556)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Load the Synonym exemption table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Loads the synonym exemption table with the default exemptions.
-- 
------------------------------------------------------------------
Insert Into
Nm_Syn_Exempt
(
Nsyn_Object_Name,
Nsyn_Object_Type
)
Select    'V_MCP_EXTRACT%',
          'VIEW'
From      Dual
Where     Not Exists  (
                      Select  Null
                      From    Nm_Syn_Exempt
                      Where   Nsyn_Object_Name    =   'V_MCP_EXTRACT%'
                      And     Nsyn_Object_Type    =   'VIEW'
                      )          
/

Insert Into
Nm_Syn_Exempt
(
Nsyn_Object_Name,
Nsyn_Object_Type
)
Select    'V_MCP_UPLOAD%',
          'VIEW'
From      Dual
Where     Not Exists  (
                      Select  Null
                      From    Nm_Syn_Exempt
                      Where   Nsyn_Object_Name    =   'V_MCP_UPLOAD%'
                      And     Nsyn_Object_Type    =   'VIEW'
                      )
/           

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop redundant objects from sub users
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 111403
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- One time only ddl drop script that needs to be ran after most objects have been created.  Do not include this in the metadata account.
-- 
------------------------------------------------------------------
Declare
  l_Missing_Privs   Boolean:=False;
  Procedure w (p_line In  Varchar2)
  Is
  Begin
    Nm_Debug.Debug(p_line);
    Dbms_Output.Put_Line(p_line);
  End w;
Begin
  Nm_Debug.Debug_On;
  w('Dropping Sub-User Views and Synonyms - Called');
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
    w('Privilege missing:' || x.Name);
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
      w('About to drop :' || obj.Type  || ' - ' || obj.Owner || '.' || obj.Name || ', Using:' || obj.Drop_Ddl);
      Execute Immediate(obj.Drop_Ddl);
      If obj.Sub_View_Drop_DDL Is Not Null And  obj.Sub_View_Geom = 'Y' Then
        w('About to drop sub object :' || obj.Sub_View_Type  || ' - ' ||obj.Sub_View_Owner || '.' || obj.Sub_View_Name || ', Using:' || obj.Drop_Ddl);
        Execute Immediate(obj.Sub_View_Drop_DDL); 
      End If;
    End Loop;
  Else
    Raise_Application_Error(-20001,'Missing privileges whilst trying to drop redundant objects.' );
  End If;  
  w('Dropping Sub-User Views and Synonyms - Finished');
End;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New messages for Hig1832
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- new messages to support hig1832
-- 
------------------------------------------------------------------
Begin
  Insert Into Nm_Errors 
  (
  Ner_Appl,
  Ner_Id,
  Ner_Descr
  )
  Values
  (
  'NET',
  557,
  'The user you are trying to disable has active job(s), do you want to disable these jobs?'
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

Begin
  Insert Into Nm_Errors 
  (
  Ner_Appl,
  Ner_Id,
  Ner_Descr
  )
  Values
  (
  'NET',
  558,
  'The user has no quota on their default tablespace.'
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

