------------------------------------------------------------------
-- nm4400_nm4500_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4400_nm4500_ddl_upg.sql-arc   3.3   Jul 04 2013 14:16:28   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4400_nm4500_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:28  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       Version          : $Revision:   3.3  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add drop any view privilege
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
-- Allows the hig owner to drop sub user views.
-- 
------------------------------------------------------------------
Begin
  EXECUTE IMMEDIATE 'GRANT DROP ANY VIEW TO  ' || User;
End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New synonym exemption table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Creates new table to log which objects are exempt from synonym creation.
-- 
------------------------------------------------------------------
Declare
  Object_Already_Exists Exception;
  Pragma Exception_Init (Object_Already_Exists,-955);
Begin
  Execute Immediate (
                    'Create Table Nm_Syn_Exempt '                                           							                                    || Chr(10) ||
                    '('                                                                     							                                    || Chr(10) ||
                    'Nsyn_Object_Name   Varchar2(128) Constraint Nsyn_Obj_Name_Upp_Chk Check (Nsyn_Object_Name = Upper(Nsyn_Object_Name)),'   || Chr(10) ||
                    'Nsyn_Object_Type   Varchar2(19)  Constraint Nsyn_Obj_Type_Upp_Chk Check (Nsyn_Object_Type = Upper(Nsyn_Object_Type)),'   || Chr(10) ||
                    'Constraint Nsyn_Pk Primary Key  (Nsyn_Object_Name,Nsyn_Object_Type)'   							                                    || Chr(10) ||
                    ')'                                                                    						 	                                      || Chr(10) ||
                    'Organization Index'
                    );
Exception
  When Object_Already_Exists Then
    Dbms_Output.Put_Line('Already Exists');
    Null;  
End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Changed default values from User to new Application Context values.
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Changed default values from User to new Application Context values.
-- 
------------------------------------------------------------------
Alter Table Nm_Element_History Modify Neh_Actioned_By  Default Sys_Context('NM3_SECURITY_CTX','USERNAME')
/

Alter Table Hig_Processes Modify Hp_Job_Owner Default Sys_Context('NM3_SECURITY_CTX','USERNAME')
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

