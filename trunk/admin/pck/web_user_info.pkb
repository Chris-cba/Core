Create Or Replace Package Body  Web_User_Info

As
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/web_user_info.pkb-arc   3.5   Jan 30 2015 12:43:08   Rob.Coupe  $
--       Module Name      : $Workfile:   web_user_info.pkb  $
--       Date into PVCS   : $Date:   Jan 30 2015 12:43:08  $
--       Date fetched Out : $Modtime:   Jan 30 2015 12:41:54  $
--       Version          : $Revision:   3.5  $
--       Based on SCCS version :
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_Body_Sccsid CONSTANT  VARCHAR2(2000) :=  '$Revision:   3.5  $';

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
--
----------------------------------------------------------------------------------------------------
--
PROCEDURE set_context(pi_user_name IN hig_users.hus_username%TYPE, pi_error_msg OUT VARCHAR2)
IS
--
   l_user_id	hig_users.hus_user_id%TYPE;
   l_err_descr	nm_errors.ner_descr%TYPE;
	--
	CURSOR get_user_id IS 
		SELECT  hus_user_id
		FROM    hig_users 
		WHERE   hus_username =  UPPER(pi_user_name);
--
BEGIN
	OPEN get_user_id;
	FETCH get_user_id INTO l_user_id;
	--
	IF get_user_id%NOTFOUND THEN
		SELECT ner_descr INTO l_err_descr FROM nm_errors WHERE ner_appl = 'HIG' AND ner_id = 80;
		--
		pi_error_msg := 'HIG-0080: ' || l_err_descr;
	ELSE
		set_context(l_user_id);
	END IF;
	--
	CLOSE get_user_id;
--
EXCEPTION WHEN OTHERS THEN
	IF get_user_id%ISOPEN THEN
		CLOSE get_user_id;
	END IF;
	--
    pi_error_msg := SQLERRM;     
--
END set_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_context(pi_user_id IN hig_users.hus_user_id%TYPE)
Is
--
   l_user_au      NUMBER;
   l_unrestricted VARCHAR2(1);
   l_end_date     DATE;
   l_name         hig_users.hus_name%TYPE;
   l_status       VARCHAR2(100); 
   l_db_user      VARCHAR2(100);
   l_is_owner     VARCHAR2(1);
   CURSOR c_get_account_status (c_useraccount VARCHAR2)  
   IS
   
   SELECT account_status
        
   FROM   dba_users 
   WHERE  username = c_useraccount;
--
BEGIN
--
IF g_account_unrestricted = 'N' OR g_account_unrestricted IS NULL THEN
  raise_application_error(-20001, 'A restricted or unknown user cannot use this function');
END IF;
   BEGIN
   --
      SELECT  hus_admin_unit 
             ,hus_unrestricted  
             ,hus_end_date
             ,hus_name
             ,hus_username
             ,hus_is_hig_owner_flag
      INTO    l_user_au
             ,l_unrestricted
             ,l_end_date
             ,l_name
             ,l_db_user
             ,l_is_owner
      FROM    hig_users 
      WHERE   hus_user_id =  pi_user_id ;
      
--      If l_unrestricted = 'Y'
--      Then
--          Raise_Application_Error (-20201,'Cannot set context for unrestricted user ');     
--      End If ;
      If l_end_date Is Not Null
      Then        
           Raise_Application_Error(-20202,'Exor hig user ('||l_name||') is end dated');
      End If ;  

      OPEN  c_get_account_status(l_db_user);
      FETCH c_get_account_status INTO l_status;

      CLOSE c_get_account_status;        
        
      If l_status != 'OPEN'
      Then        
          Raise_Application_Error(-20202,'Exor db user '||l_db_user||' is not open');
      End If ;          
   --
   Exception
      When No_Data_Found
      Then
          Raise_Application_Error (-20204,'Given hig user id ('||pi_user_id||') is not found ');     

   End ;
     
   Nm3Security.Set_User(l_db_user); 
   nm3ctx.Set_Core_Context (p_Attribute => 'USER_ID'          ,p_Value => pi_user_id);
-- nm3ctx.Set_Core_Context (p_Attribute => 'APPLICATION_OWNER',p_Value => Get_Hig_Owner);
   nm3ctx.Set_Core_Context (p_Attribute => 'EFFECTIVE_DATE'   ,p_Value => To_Char(Trunc(Sysdate),'DD-MON-YYYY'));
   nm3ctx.set_core_context (p_Attribute => 'USER_ADMIN_UNIT'  ,p_Value => l_user_au );
   nm3ctx.set_core_context (p_Attribute => 'UNRESTRICTED_INVENTORY', p_Value => l_unrestricted );
   nm3ctx.set_core_context (p_attribute => 'HIG_OWNER',        p_value => l_is_owner );
--
End set_context;
--
-----------------------------------------------------------------------------
--
procedure clear_contexts is
begin
DBMS_SESSION.CLEAR_ALL_CONTEXT('NM3SQL');
DBMS_SESSION.CLEAR_ALL_CONTEXT('NM3CORE');
dbms_session.clear_all_context('NM3_SECURITY_CTX');
end;
--
-----------------------------------------------------------------------------
--
Begin
  select hus_user_id, hus_unrestricted, hus_is_hig_owner_flag
  into g_account_user_id, g_account_unrestricted, g_account_owner
  from hig_users
  where hus_username = user;
--
-----------------------------------------------------------------------------
--
End  Web_User_Info;
/         

