Create or Replace Package Body Exor_Core.Nm3Security
As  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3security.pkb-arc   3.0   Jul 15 2011 09:05:54   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3security.pkb  $
--       Date into PVCS   : $Date:   Jul 15 2011 09:05:54  $
--       Date fetched Out : $Modtime:   Jul 15 2011 08:57:06  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version :
-------------------------------------------------------------------------

  gc_Body_Sccsid              Constant  Varchar2(2000)                  :=  '$Revision:   3.0  $';
  
  --This is the context that should be used when the context and attribute name are fixed and not set via the call.
  --  this is more secure if the context attribute/value does not need to be secure then use nm3ctx.Set_Context 
  gc_Security_Context_Name    Constant  Session_Context.Namespace%Type  :=  'NM3_SECURITY_CTX';
  
  --This username could actually be another user proxing as this user 
  gc_Username_Name            Constant  Session_Context.Attribute%Type  :=  'USERNAME';
  --This is the actual user that is logged on the database
  gc_Actual_Username_Name     Constant  Session_Context.Attribute%Type  :=  'ACTUAL_USERNAME';  
  
  gc_Effective_Date           Constant  Session_Context.Attribute%Type  :=  'EFFECTIVE_DATE';
  gc_Hig_Owner                Constant  Session_Context.Attribute%Type  :=  'HIG_OWNER';
  gc_Enforce_Ready_Only       Constant  Session_Context.Attribute%Type  :=  'ENFORCE_READONLY_CTX';

Function Get_Version Return Varchar2
Is
Begin
   Return gc_Sccsid;
End Get_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Body_Version Return Varchar2
Is
Begin
   Return gc_Body_Sccsid;
End Get_Body_Version;

Function Allowed_To_Proxy Return Boolean 
Is
Begin
  Return(Sys_Context(gc_Security_Context_Name,gc_Hig_Owner) = 'Y' );
End;

Procedure Set_User  (
                    p_Username    In    Varchar2  Default Null
                    )
Is
  l_Username   User_Users.Username%Type:=User;
Begin
  Dbms_Application_Info.Set_Action('Set_User');
  Dbms_Application_Info.Set_Client_Info('p_Username:' || p_Username);
  If Allowed_To_Proxy And  p_Username Is Not Null Then
    l_Username:=p_Username;
  End If;
  Dbms_Session.Set_Context(gc_Security_Context_Name,gc_Username_Name,l_Username);
  --Keeps a context to hold the actual user that is logged on
  Dbms_Session.Set_Context(gc_Security_Context_Name,gc_Actual_Username_Name,User);
  Dbms_Application_Info.Set_Action(Null);
End Set_User;

Procedure Set_Effective_Date    (
                                p_Effective_Date   In    Date  Default Sysdate
                                )
Is
Begin
  Dbms_Application_Info.Set_Action('Set_Effective_Date');
  Dbms_Application_Info.Set_Client_Info('p_Effective_Date:' || To_Char(p_Effective_Date,'dd-mm-yyyy'));
  If p_Effective_Date Is Not Null Then
    Dbms_Session.Set_Context(gc_Security_Context_Name,gc_Effective_Date,To_Char(p_Effective_Date,'dd-mm-yyyy'));
  Else
    Dbms_Session.Set_Context(gc_Security_Context_Name,gc_Effective_Date,To_Char(Sysdate,'dd-mm-yyyy'));
  End If;
  Dbms_Application_Info.Set_Action(Null);
End Set_Effective_Date;                                

Procedure Set_Hig_Owner   (
                          p_Is_Hig_Owner    In    Boolean
                          )
Is

Begin
  Dbms_Application_Info.Set_Action('Set_Hig_Owner');
  Dbms_Application_Info.Set_Client_Info('p_Is_Hig_Owner:' || (Case When p_Is_Hig_Owner Then 'True' Else 'False' End) );
  --Makes sure it is not already set.  This should be called once from the on_logon trigger to set the flag.
  --  The reason this is restricted to one call is because the user could call this from any prompt, but the first firing of it will be on the logon 
  -- trigger before they even have chance to set it manually.  Any other attempts to set it after the initial one, will be ignored.  This is to stop 
  --  the user restting it and gaining the privilege to proxy user.  
  If Sys_Context(gc_Security_Context_Name,gc_Hig_Owner) Is Null Then
    If p_Is_Hig_Owner Then
      Dbms_Session.Set_Context(gc_Security_Context_Name,gc_Hig_Owner,'Y');
    Else
      Dbms_Session.Set_Context(gc_Security_Context_Name,gc_Hig_Owner,'N');
    End If;
  End If;
  Dbms_Application_Info.Set_Action(Null);
End Set_Hig_Owner;

--Once this is called then the core context controlled by nm3ctx will start to check to see if individual attributes can be changed 
-- before the context attributes value can be amened
Procedure Lock_Core_Context
Is

Begin
  -- Can only be set to yes and onlyif it was previously null
  If Sys_Context(gc_Security_Context_Name,gc_Enforce_Ready_Only) Is Null Then
    Dbms_Session.Set_Context(gc_Security_Context_Name,gc_Enforce_Ready_Only,'YES');
  End If;
End Lock_Core_Context;

Begin
  Dbms_Application_Info.Set_Module(gc_Security_Context_Name,'');

End NM3Security;
/
