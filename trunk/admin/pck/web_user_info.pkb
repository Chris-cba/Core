Create Or Replace Package Body  Web_User_Info

As
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/web_user_info.pkb-arc   3.2   Aug 12 2014 09:37:32   Linesh.Sorathia  $
--       Module Name      : $Workfile:   web_user_info.pkb  $
--       Date into PVCS   : $Date:   Aug 12 2014 09:37:32  $
--       Date fetched Out : $Modtime:   Aug 09 2014 12:40:52  $
--       Version          : $Revision:   3.2  $
--       Based on SCCS version :
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_Body_Sccsid               Constant  Varchar2(2000)                      :=  '$Revision:   3.2  $';

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
Function Get_Hig_Owner Return Hig_Users.Hus_Username%Type
Is   
  l_Hig_Owner   Hig_Users.Hus_Username%Type;
Begin
  Begin
    Select  hu.Hus_Username
    Into    l_Hig_Owner
    From    Hig_Users   hu
    Where   hu.Hus_Is_Hig_Owner_Flag   = 'Y';
  Exception
    When No_Data_Found 
    Then
        Return(Null);
    End;
    Return(l_Hig_Owner);
End Get_Hig_Owner;
-----------------------------------------------------------------------------
--
Procedure set_context(pi_user_id In hig_users.hus_user_id%Type)
Is
--
   l_user_au      Number;
   l_unrestricted Varchar2(1);
   l_end_date     Date;
   l_name         hig_users.hus_name%Type;
   l_status       Varchar2(100); 
   l_db_user      Varchar2(100);  
   CURSOR c_get_account_status (c_useraccount VARCHAR2)  
   IS
   
   SELECT account_status
        
   FROM   dba_users 
   WHERE  username = c_useraccount;
--
Begin
--
   Begin
   --
      Select  hus_admin_unit 
             ,hus_unrestricted  
             ,hus_end_date
             ,hus_name
             ,hus_username
      Into    l_user_au
             ,l_unrestricted
             ,l_end_date
             ,l_name
             ,l_db_user
      From    hig_users 
      Where   hus_user_id =  pi_user_id ;
      
      If l_unrestricted = 'Y'
      Then
          Raise_Application_Error (-21201,'Cannot set context for unrestricted user ');     
      End If ;
      If l_end_date Is Not Null
      Then        
           Raise_Application_Error(-21202,'Exor hig user ('||l_name||') is end dated');
      End If ;  

      OPEN  c_get_account_status(l_db_user);
      FETCH c_get_account_status INTO l_status;

      CLOSE c_get_account_status;        
        
      If l_status != 'OPEN'
      Then        
          Raise_Application_Error(-21202,'Exor db user '||l_db_user||' is not open');
      End If ;          
   --
   Exception
      When No_Data_Found
      Then
          Raise_Application_Error (-21204,'Given hig user id ('||pi_user_id||') is not found ');     

   End ;
     
   Nm3Security.Set_Hig_Owner(true);
   Nm3Security.Set_User(NM3USER.GET_USERNAME(pi_user_id)); 
   nm3ctx.Set_Core_Context (p_Attribute => 'USER_ID'          ,p_Value => pi_user_id);
   nm3ctx.Set_Core_Context (p_Attribute => 'APPLICATION_OWNER',p_Value => Get_Hig_Owner);
   nm3ctx.Set_Core_Context (p_Attribute => 'EFFECTIVE_DATE'   ,p_Value => To_Char(Trunc(Sysdate),'DD-MON-YYYY'));
   nm3ctx.set_core_context (p_Attribute => 'USER_ADMIN_UNIT'  ,p_Value => l_user_au );
--
End set_context;
--
-----------------------------------------------------------------------------
--
End  Web_User_Info;
/         

