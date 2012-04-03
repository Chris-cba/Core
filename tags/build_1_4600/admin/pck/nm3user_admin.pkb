Create Or Replace Package Body Nm3User_Admin
As
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3user_admin.pkb-arc   3.1   Apr 03 2012 13:23:46   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3user_admin.pkb  $
--       Date into PVCS   : $Date:   Apr 03 2012 13:23:46  $
--       Date fetched Out : $Modtime:   Apr 03 2012 13:12:30  $
--       Version          : $Revision:   3.1  $
-------------------------------------------------------------------------
--   Author : Steven Cooper
--
--   NM3 user Admin package
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------

  gc_Body_Version  Constant  Varchar2(100) := '$Revision:   3.1  $';

  gc_Package_Name  Constant  Varchar2(30)  := 'nm3User_Admin';
 
--
-----------------------------------------------------------------------------
--
Function Get_Version Return Varchar2 Is
Begin
   Return gc_Header_Version;
End Get_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Body_Version Return Varchar2 Is
Begin
   Return gc_Body_Version;
End Get_Body_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Default_User_Tablesp_Quota (
                                        p_User    In    Dba_Users.Username%Type
                                        ) Return Dba_Ts_Quotas.Max_Bytes%Type
Is
  l_Quota   Dba_Ts_Quotas.Max_Bytes%Type;
Begin
  Begin
    Select  dtq.Max_Bytes
    Into    l_Quota
    From    Dba_Ts_Quotas   dtq,
            Dba_Users       du
    Where   du.Username           =   p_User
    And     du.Username           =   dtq.Username
    And     du.Default_Tablespace =   dtq.Tablespace_Name;
  Exception
    When No_Data_Found Then
      Raise_Application_Error(-20001,'User ' || p_User || ' has no quota on their default tablespace.');
  End;
  Return(l_Quota);
End Get_Default_User_Tablesp_Quota;
--
-----------------------------------------------------------------------------
--
Function  Valid_User (
                     p_User  in  Dba_Users.Username%Type
                     ) Return Boolean
Is
  l_Dummy   Varchar2(1);
  l_Retval  Boolean;  
Begin
  Nm_Debug.Debug('nm3User_Admin.Valid_User - Called');
  Nm_Debug.Debug('Parameter - p_User = ' || p_User);
  Begin
    Select  Null
    Into    l_Dummy
    From    Dba_Users   du
    Where   du.Username   =   Upper(p_User);
    l_Retval:=True;
  Exception
    When No_Data_Found Then
      l_Retval:=False;
  End;
  Nm_Debug.Debug('nm3User_Admin.Valid_User - Finished - Returning :' || (Case When l_Retval Then 'True' Else 'False' End));
  Return (l_Retval);
End Valid_User;
--
-----------------------------------------------------------------------------
--
Function  Valid_Tablespace  (
                            p_Default_Tablespace_Name   In  Dba_Tablespaces.Tablespace_Name%Type
                            ) Return Boolean
Is
  l_Dummy   Varchar2(1);
  l_Retval  Boolean;  
Begin
  Nm_Debug.Debug('nm3User_Admin.Valid_Tablespace - Called');
  Nm_Debug.Debug('Parameter - p_Default_Tablespace_Name = ' || p_Default_Tablespace_Name);
  Begin
    Select  Null
    Into    l_Dummy
    From    Dba_Tablespaces  dt
    Where   dt.Tablespace_Name   =   Upper(p_Default_Tablespace_Name);
    l_Retval:=True;
  Exception
    When No_Data_Found Then
      l_Retval:=False;
  End;
  Nm_Debug.Debug('nm3User_Admin.Valid_Tablespace - Finished - Returning :' || (Case When l_Retval Then 'True' Else 'False' End));
  Return (l_Retval);
End Valid_Tablespace;
--
-----------------------------------------------------------------------------
--
Function User_Exists  (
                      p_User    In    All_Users.Username%Type
                      ) Return Boolean
Is
  l_Dummy   Varchar2(1);
  l_Retval  Boolean;
Begin
  Begin
    Select  Null
    Into    l_Dummy
    From    All_Users   au
    Where   au.Username = p_User;
    l_Retval:=True;
  Exception
    When No_Data_Found Then
      l_Retval:=False;
  End;
  Return(l_Retval);
End User_Exists;

Procedure Set_Default_Tablespace  (
                                  p_User                      In  Dba_Users.Username%Type,
                                  p_Default_Tablespace_Name   In  Dba_Users.Default_Tablespace%Type,
                                  p_Quota                     In  Dba_Ts_Quotas.Max_Bytes%Type,
                                  p_Quota_Size_Type           In  Varchar2 Default Null
                                  )
Is
  l_Username  Dba_Users.Username%Type;
Begin
  Nm_Debug.Debug('nm3User_Admin.Set_Default_Tablespace - Called');
  Nm_Debug.Debug('Parameter - p_User = '                    || p_User);
  Nm_Debug.Debug('Parameter - p_Default_Tablespace_Name = ' || p_Default_Tablespace_Name);
  Nm_Debug.Debug('Parameter - p_Quota = '                   || To_Char(p_Quota));
  Nm_Debug.Debug('Parameter - p_Quota_Size_Type = '         || p_Quota_Size_Type);
 
  If            Valid_User(p_User => p_User) 
      And       Valid_Tablespace(p_Default_Tablespace_Name =>  p_Default_Tablespace_Name) 
      And       p_Quota >= -1
      And   (   p_Quota_Size_Type Is Null 
            Or  p_Quota_Size_Type In ('K','M','G','T','P')
            ) Then
    
    Execute Immediate ('Alter User ' || p_User || ' Default Tablespace '  || p_Default_Tablespace_Name || 
                                                  ' Quota ' || (Case When p_Quota = -1 Then 'Unlimited' Else To_Char (p_Quota) || p_Quota_Size_Type End) || ' On ' || p_Default_Tablespace_Name);
   
  Else
    Raise_Application_Error(-20001,'Invalid Username, Tablespace or Quota size/Quota size type provided in call to Set_Default_Tablespace.');
  End If;

  Nm_Debug.Debug('nm3User_Admin.Set_Default_Tablespace - Finished');
End Set_Default_Tablespace;
--
-----------------------------------------------------------------------------
--
Function Valid_Profile  (
                        p_Profile   In  Dba_Users.Profile%Type
                        ) Return Boolean
Is
  l_Retval  Boolean :=True;
  l_Dummy   Varchar2(1);
Begin
  Nm_Debug.Debug('nm3User_Admin.Valid_Profile - Called');
  Nm_Debug.Debug('Parameter - p_Profile = ' || p_Profile);
  Begin
    Select  Null
    Into    l_Dummy
    From    Dba_Profiles
    Where   Rownum  = 1;
  Exception
    When No_Data_Found Then
      l_Retval:=False;  
  End;
  Nm_Debug.Debug('nm3User_Admin.Valid_Profile - Finished - Returning:' || (Case When l_Retval Then 'True' Else 'False' End));
  
  Return(l_Retval);  
End Valid_Profile; 
--
-----------------------------------------------------------------------------
--
Procedure Set_User_Profile  (
                            p_User      In   Dba_Users.Username%Type,
                            p_Profile   In   Dba_Users.Profile%Type
                            )
Is

Begin
  Nm_Debug.Debug('nm3User_Admin.Set_User_Profile - Called');
  Nm_Debug.Debug('Parameter - p_User = '    || p_User);
  Nm_Debug.Debug('Parameter - p_Profile = ' || p_Profile);
  If        Valid_Profile  ( p_Profile => p_Profile) 
      And   Valid_User(p_User => p_User) Then
    Execute Immediate ('Alter User ' || p_User || ' Profile '  || p_Profile);
    Nm_Debug.Debug('Profile Set.');
  Else
    Raise_Application_Error(-20001,'Invalid Username or Profile Name in call to Set_User_Profile.');
  End If;
  Nm_Debug.Debug('nm3User_Admin.Set_User_Profile - Finished');  
End Set_User_Profile;
--
-----------------------------------------------------------------------------
--
Procedure Set_User_Password (
                            p_User        In  Dba_Users.Username%Type,
                            p_Password    In  Varchar2
                            )
Is
 --This is running in an invokers rights package so only inf the invoker has permission to alter user will this work, otherwise an Insufficient Privilege error will be raised.
 
  p_Reason              Varchar2(2000);
  Invalid_Char          Exception;
  Missing_Option        Exception;
  End_Of_Sql            Exception;
  Missing_Pass          Exception;
  Zero_Len_Identifier   Exception;
  Bad_Comments          Exception;
  
  Pragma Exception_Init(Invalid_Char,-911);
  Pragma Exception_Init(End_Of_Sql,-921);
  Pragma Exception_Init(Missing_Option,-922);
  Pragma Exception_Init(Missing_Pass,-988);
  Pragma Exception_Init(Zero_Len_Identifier,-1741);
  Pragma Exception_Init(Bad_Comments,-1742);  
  
Begin
  Nm_Debug.Debug('nm3User_Admin.Set_User_Password - Called');
  If  Valid_User(p_User => p_User)  Then   
    If  nm3flx.Is_String_Valid_For_Password (
                                            pi_Password   =>  p_Password,
                                            po_Reason     =>  p_Reason
                                            ) Then 
      Begin
        Execute Immediate ('Alter User ' || p_User || ' Identified By '  || p_Password);
      Exception
        When Invalid_Char Or Missing_Option Or End_Of_Sql Or Zero_Len_Identifier Or Missing_Pass Or Bad_Comments Then
          Raise_Application_Error(-20002,'Invalid Password in call to Set_User_Password.');
      End;
    Else
      Raise_Application_Error(-20002,'Invalid Password in call to Set_User_Password. :' || p_Reason);
    End If;
  Else
    Raise_Application_Error(-20001,'Invalid Username in call to Set_User_Password. ');
  End If;
  Nm_Debug.Debug('nm3User_Admin.Set_User_Password - Finished');  
End Set_User_Password;                              

--
-----------------------------------------------------------------------------
--

End Nm3User_Admin;
/
