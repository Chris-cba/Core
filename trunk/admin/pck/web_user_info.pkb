Create Or Replace Package Body  Web_User_Info

As
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/web_user_info.pkb-arc   3.1   Jul 04 2013 16:45:36   James.Wadsworth  $
--       Module Name      : $Workfile:   web_user_info.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:45:36  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:44:18  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version :
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_Body_Sccsid               Constant  Varchar2(2000)                      :=  '$Revision:   3.1  $';

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

