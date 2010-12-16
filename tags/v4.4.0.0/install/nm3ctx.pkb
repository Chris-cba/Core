Create Or Replace Package Body Exor_Core.Nm3Ctx
As
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3ctx.pkb-arc   3.0   Dec 16 2010 10:10:34   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3ctx.pkb  $
--       Date into PVCS   : $Date:   Dec 16 2010 10:10:34  $
--       Date fetched Out : $Modtime:   Dec 16 2010 10:10:14  $
--       Version          : $Revision:   3.0  $
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
  G_Body_Sccsid  Constant Varchar2(2000) := '$Revision:   3.0  $';
  
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
End Nm3Ctx;
/
