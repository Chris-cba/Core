------------------------------------------------------------------
-- nm4400_nm4500_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4400_nm4500_ddl_upg.sql-arc   3.2   Sep 13 2011 11:42:24   Mike.Alexander  $
--       Module Name      : $Workfile:   nm4400_nm4500_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Sep 13 2011 11:42:24  $
--       Date fetched Out : $Modtime:   Sep 13 2011 11:38:48  $
--       Version          : $Revision:   3.2  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011

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

