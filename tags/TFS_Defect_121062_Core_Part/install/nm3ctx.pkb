Create Or Replace Package Body Exor_Core.Nm3Ctx
As
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm3ctx.pkb-arc   3.3   Jan 20 2015 07:18:18   Upendra.Hukeri  $
--       Module Name      : $Workfile:   nm3ctx.pkb  $
--       Date into PVCS   : $Date:   Jan 20 2015 07:18:18  $
--       Date fetched Out : $Modtime:   Jan 20 2015 06:43:44  $
--       Version          : $Revision:   3.3  $
--       Based on SCCS version : 
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here 
 
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  G_Body_Sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   3.3  $';
   
  Type Context_Tab Is Table Of Boolean Index By Varchar(30);
  
  g_Context_Tab Context_Tab;
  
  
--
-----------------------------------------------------------------------------
--
Function Get_Version Return Varchar2
Is
Begin
   Return G_Sccsid;
End Get_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Body_Version Return Varchar2
Is
Begin
   Return G_Body_Sccsid;
End Get_Body_Version;
--
-----------------------------------------------------------------------------
--

Procedure Initialise
Is

Begin
  g_Context_Tab.Delete;
  --Only set the ones that are readonly, if they don't exists that effectively means they areread/write.
  g_Context_Tab('USER_ID'):=TRUE;
  g_Context_Tab('UNRESTRICTED_INVENTORY'):=TRUE;
  g_Context_Tab('APPLICATION_OWNER'):=TRUE;
  g_Context_Tab('UNRESTRICTED_ACCIDENTS'):=TRUE;
  g_Context_Tab('ENTERPRISE_EDITION'):=TRUE;
  g_Context_Tab('INSTANCE_NAME'):=TRUE;
  g_Context_Tab('HOST_NAME'):=TRUE;
  g_Context_Tab('DB_VERSION'):=TRUE;
   
End Initialise;

Procedure Set_Context   (
                        p_Attribute   In  Varchar2,
                        p_Value       In  Varchar2
                        )
Is
--
Begin
--
   Dbms_Session.Set_Context('NM3SQL', p_Attribute, p_Value);
--
End Set_Context;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_core_context  (
                            p_attribute   IN  VARCHAR2,
                            p_value       IN  VARCHAR2
                            )
IS
--
BEGIN
    IF  SYS_CONTEXT('NM3_SECURITY_CTX','ENFORCE_READONLY_CTX') = 'YES' 
        AND g_context_tab.EXISTS(p_attribute) 
        AND SYS_CONTEXT('NM3_SECURITY_CTX', 'HIG_OWNER') != 'Y' 
    THEN
        RAISE_APPLICATION_ERROR(-20498,'Cannot set context values for read only attributes');  
    ELSE
        dbms_session.set_context('NM3CORE', p_attribute, p_value);
    END IF;
END set_core_context;                          
--
----------------------------------------------------------------------------- 
--
Begin
  Initialise;

End Nm3Ctx;
/
