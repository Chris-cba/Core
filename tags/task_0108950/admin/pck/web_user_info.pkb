Create Or Replace Package Body  Web_User_Info

As
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/web_user_info.pkb-arc   3.0   May 28 2012 14:49:04   Steve.Cooper  $
--       Module Name      : $Workfile:   web_user_info.pkb  $
--       Date into PVCS   : $Date:   May 28 2012 14:49:04  $
--       Date fetched Out : $Modtime:   May 28 2012 14:48:08  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version :
-------------------------------------------------------------------------

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_Body_Sccsid               Constant  Varchar2(2000)                      :=  '$Revision:   3.0  $';

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
Procedure Set_User  (
                    p_Name  In  Varchar2
                    )
As
Begin    
   Nm3Security.Set_User(p_Name);     
End Set_User;
--
-----------------------------------------------------------------------------
--
Procedure Clear_User
As
Begin
  --Reset back to Actual User, in case they are different.
   Nm3Security.Set_User;
End Clear_User;
--
-----------------------------------------------------------------------------
--
Function Get_User Return Varchar2
As
Begin
  Return Sys_Context('NM3_SECURITY_CTX','USERNAME');
End Get_User;

--
-----------------------------------------------------------------------------
--
End  Web_User_Info;
/         

