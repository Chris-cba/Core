Create Or Replace Package Body Exor_Core.Nm3Ctx
As
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3ctx.pkb-arc   3.1   May 17 2011 08:33:20   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3ctx.pkb  $
--       Date into PVCS   : $Date:   May 17 2011 08:33:20  $
--       Date fetched Out : $Modtime:   Mar 29 2011 16:11:16  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-------------------------------------------------------------------------
--
--all global package variables here 
 
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  G_Body_Sccsid  Constant Varchar2(2000) := '$Revision:   3.1  $';
   
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
Procedure Set_Core_Context  (
                            p_Attribute   In  Varchar2,
                            p_Value       In  Varchar2
                            )
Is

Begin
  If Sys_Context('NM3_SECURITY_CTX','ENFORCE_READONLY_CTX') = 'YES' And g_Context_Tab.exists(p_Attribute) Then    
    Raise_Application_Error(-20498,'Cannot set context values for read only attributes');  
  Else
    Dbms_Session.Set_Context('NM3CORE', p_Attribute, p_Value);
  End If;
End Set_Core_Context;                            


--
----------------------------------------------------------------------------- 
--
Begin
  Initialise;

End Nm3Ctx;
/
