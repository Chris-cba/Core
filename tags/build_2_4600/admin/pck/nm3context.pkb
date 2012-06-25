Create Or Replace Package Body Nm3Context 
As
--
-----------------------------------------------------------------------------
--
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/pck/nm3context.pkb-arc   2.7   Jun 25 2012 09:12:52   Steve.Cooper  $
-- Module Name : $Workfile:   nm3context.pkb  $
-- Date into PVCS : $Date:   Jun 25 2012 09:12:52  $
-- Date fetched Out : $Modtime:   Oct 12 2011 16:23:34  $
-- PVCS Version : $Revision:   2.7  $
-- Based on SCCS version : 
--
--
--   Author : Jonathan Mills
--
--   Package for setting/retrieving context values
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
  g_Body_Sccsid       Constant  Varchar2(2000)  :='"$Revision:   2.7  $"';

  c_True              Constant  Varchar2(5)     := 'TRUE';
  c_False             Constant  Varchar2(5)     := 'FALSE';
--
  g_Context_Exception           Exception;
  g_Context_Exc_Code            Number;
  g_Context_Exc_Msg             Varchar2(4000);

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
Function Get_User_Sysopt  (
                          p_Sysopt  In  Hig_Option_Values.Hov_Id%Type           Default Null,
                          p_Userid  In  Hig_User_Options.Huo_Hus_User_Id%Type   Default Null,
                          p_Useopt  In  Hig_User_Options.Huo_Id%Type            Default Null,
                          p_Default In  Varchar2                                Default Null
                          ) Return Hig_Option_Values.Hov_Value%Type
Is
  l_Retval  Hig_Option_Values.Hov_Value%Type;
--
Begin 
  Begin
    Select  huo.Huo_Value
    Into    l_Retval
    From    Hig_User_Options      huo
    Where   huo.Huo_Hus_User_Id   =   p_Userid
    And     huo.Huo_Id            =   p_Useopt;
  Exception 
    When No_Data_Found Then
      Begin
        Select  hov.Hov_Value
        Into    l_Retval
        From    Hig_Option_Values hov
        Where   hov.Hov_Id        =     p_Sysopt;
      Exception
        When No_Data_Found Then
          l_Retval := p_Default;        
      End;   
  End;
  
  Return(l_Retval);

End Get_User_Sysopt;
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
    When No_Data_Found Then
      Begin  
        --Just see if we have any users at all.
        Select  Null
        Into    l_Hig_Owner   
        From    Hig_Users   hu
        Where   Rownum    =   1;
        --If we have any users then the old logic said, this should not happen and didn't do anything.
      Exception
        When No_Data_Found Then
          -- If there is no record found and there are no records in hig_users
          --  therefore the only time this can happen is
          --  when this runs are part of the install, so the application
          --  owner will be the current user
          l_Hig_Owner:=Sys_Context('NM3_SECURITY_CTX','USERNAME');
      End;
  End;
  Return(l_Hig_Owner);
End Get_Hig_Owner;
--
-----------------------------------------------------------------------------
--
Procedure Initialise_Context 
Is
   l_User_Id            Hig_Users.Hus_User_Id%Type;
   l_Unrestricted_Inv   Varchar2(5);
   l_Unrestricted_Acc   Varchar2(5);
   l_Instance           V$Instance.Instance_Name%Type;
   l_Host               V$Instance.Host_Name%Type;
   l_Db_Version         V$Instance.Version%Type;
   l_Enterprise_Edn     Varchar2(5);

Begin
  Begin
    Select  Hus_User_Id,
            Decode(Hur_Role,Null,C_False,C_True) Unrestricted_Acc,
            Decode(Hus_Unrestricted,'Y',C_True,C_False)          
    Into    l_User_Id,
            l_Unrestricted_Acc,
            l_Unrestricted_Inv
    From    Hig_Users         hu,
            Hig_User_Roles    hur
    Where   hu.Hus_Username     =   Sys_Context('NM3_SECURITY_CTX','USERNAME') 
    And     hu.Hus_Username     =   hur.Hur_Username (+)
    And     'ACC_ADMIN'         =   hur.Hur_Role (+);
  Exception
    When No_Data_Found Then
      Raise_Application_Error(-20001,'User not found in HIG_USERS');
  End;

  --
  Begin
    Select  c_True            
    Into    l_Enterprise_Edn
    From    V$Version
    Where   (   Instr(Banner,'Enterprise Edition')  > 0
            Or  Instr(Banner,'Personal')            > 0
            );
  Exception
    When  No_Data_Found Then
      l_Enterprise_Edn:=c_False;
  End;

  Select  Instance_Name,
          Host_Name,
          Version
  Into    l_Instance,
          l_Host,
          l_Db_Version         
  From    V$Instance;

  nm3ctx.Set_Core_Context (
                          p_Attribute => 'EFFECTIVE_DATE',
                          p_Value     => To_Char(Trunc(Sysdate),'DD-MON-YYYY')
                          );
               
  nm3ctx.Set_Core_Context (
                          p_Attribute => 'USER_LENGTH_UNITS',
                          p_Value     => get_user_sysopt  (
                                                          p_Sysopt   =>  'DEFUNITID',
                                                          p_Userid   =>  l_User_Id,
                                                          p_Useopt   =>  'PREFUNITS',
                                                          p_Default  =>  '1'
                                                          )
                          );               

  nm3ctx.Set_Core_Context (
                          p_Attribute => 'USER_DATE_MASK',
                          p_Value     => get_user_sysopt  (
                                                          p_Userid  =>  l_User_Id,
                                                          p_Useopt  =>  'DATE_MASK',
                                                          p_Default =>  'DD-MON-YYYY'
                                                          )
                          );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'DEFAULT_LENGTH_MASK',
                            p_Value     => '9999990.00'
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'USER_LENGTH_MASK',
                            p_Value     => '9999990.00'
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'USER_ID',
                            p_Value     => Ltrim(To_Char(l_user_id))
                            );
               
   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'UNRESTRICTED_INVENTORY',
                            p_Value     => l_unrestricted_inv
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'APPLICATION_OWNER',
                            p_Value     => Get_Hig_Owner
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'UNRESTRICTED_ACCIDENTS',
                            p_Value     => l_unrestricted_acc
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'ENTERPRISE_EDITION',
                            p_Value     => l_enterprise_edn
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'INSTANCE_NAME',
                            p_Value     => l_instance
                            );
  
   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'HOST_NAME',
                            p_Value     => l_host
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'DB_VERSION',
                            p_Value     => l_db_version
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'PREFERRED_LRM',
                            p_Value     => get_user_sysopt  (
                                                            p_Sysopt  => 'PREFLRM',
                                                            p_Userid  => l_user_id,
                                                            p_Useopt  => 'PREFLRM'
                                                            )
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'ROI_ID',
                            p_Value     => get_user_sysopt  (
                                                            p_Sysopt  => NULL,
                                                            p_Userid  => l_user_id,
                                                            p_Useopt  => 'ROI_ID'
                                                            )
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'ROI_TYPE',
                            p_Value     => get_user_sysopt  (
                                                            p_Sysopt  => NULL,
                                                            p_Userid  => l_user_id,
                                                            p_Useopt  => 'ROI_TYPE'
                                                            )
                            );

   nm3ctx.Set_Core_Context  (
                            p_Attribute => 'DEFAULT_INV_ATTR_SET',
                            p_Value     => get_user_sysopt  (
                                                            p_Sysopt  => NULL,
                                                            p_Userid  => l_user_id,
                                                            p_Useopt  => 'DEFATTRSET'
                                                            )
                            );
   
  nm3Security.Set_Hig_Owner (
                            p_Is_Hig_Owner  =>  Sys_Context('NM3CORE','APPLICATION_OWNER') = Sys_Context('NM3_SECURITY_CTX','USERNAME')
                            );
                            
  --Lock down the core contexts from being changed where they are flagged as readonly.
  Nm3Security.Lock_Core_Context;

Exception
--
   When Others
    Then
      Nm3Security.Lock_Core_Context;
      Raise;
--
End Initialise_Context;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_instantiate_user_trig (pi_new_trigger_owner IN varchar2) IS
--
   CURSOR cs_trigger (p_owner        varchar2
                     ,p_trigger_name varchar2
                     ) IS
   SELECT trigger_body
    FROM  all_triggers
   WHERE  owner        = p_owner
    AND   trigger_name = p_trigger_name;
--
   CURSOR cs_user (p_username varchar2) IS
   SELECT 'x'
    FROM  all_users
   WHERE  username = p_username;
--
   l_dummy              varchar2(1);
--
   l_application_owner  varchar2(30)  := Sys_Context ('NM3CORE','APPLICATION_OWNER');
   c_inst_user CONSTANT varchar2(30) := 'INSTANTIATE_USER';
--
   l_rec_at             all_triggers%ROWTYPE;
--
   l_trigger_sql        varchar2(32767);
   l_trigger_body       varchar2(32767);
--
BEGIN
--
   OPEN  cs_user (pi_new_trigger_owner);
   FETCH cs_user INTO l_dummy;
   IF cs_user%NOTFOUND
    THEN
      CLOSE cs_user;
      g_context_exc_code := -20493;
      g_context_exc_msg  := 'User '||l_application_owner||' not found';
      RAISE g_context_exception;
   END IF;
   CLOSE cs_user;
--
   OPEN  cs_trigger (l_application_owner, c_inst_user);
   FETCH cs_trigger INTO l_trigger_body;
   IF cs_trigger%NOTFOUND
    THEN
      CLOSE cs_trigger;
      g_context_exc_code := -20491;
      g_context_exc_msg  := 'Trigger '||l_application_owner||'.'||c_inst_user||' not found';
      RAISE g_context_exception;
   END IF;
--
   CLOSE cs_trigger;
--
   l_trigger_sql := 'CREATE OR REPLACE TRIGGER '||pi_new_trigger_owner||'.'||c_inst_user;
   l_trigger_sql := l_trigger_sql||CHR(10)||' AFTER LOGON ON '||pi_new_trigger_owner||'.SCHEMA';
   l_trigger_sql := l_trigger_sql||CHR(10)||l_trigger_body;
--
   EXECUTE IMMEDIATE l_trigger_sql;
--
EXCEPTION
--
   WHEN value_error
    THEN
      IF cs_trigger%isopen
       THEN
         CLOSE cs_trigger;
      END IF;
      g_context_exc_code := -20492;
      g_context_exc_msg  := 'Trigger '||l_application_owner||'.'||c_inst_user||' body too long (>32K)';
      RAISE g_context_exception;
   WHEN g_context_exception
    THEN
      RAISE_APPLICATION_ERROR(g_context_exc_code,g_context_exc_msg);
--
End Create_Instantiate_User_Trig;


--
-----------------------------------------------------------------------------
--
Procedure Set_Context (
                      pi_Namespace    In  Varchar2 Default Null,
                      pi_Attribute    In  Varchar2,
                      pi_Value        In  Date
                      )
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   
    --pi_namespace is ignored, it's hardcoded to be NM3SQL

    nm3ctx.Set_Context  (
                        p_Attribute => pi_Attribute,
                        p_Value     => To_Char(Trunc(pi_Value),'DD-MON-YYYY')
                        );
--
End Set_Context;
--
-----------------------------------------------------------------------------
--
Procedure Set_Context (
                      pi_Namespace  In  Varchar2 Default Null,
                      pi_Attribute  In  Varchar2,
                      pi_Value      In  Number
                      )
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   
    --pi_namespace is ignored, it's hardcoded to be NM3SQL
  
  nm3ctx.Set_Context  (
                      p_Attribute => pi_Attribute,
                      p_Value     => To_Char(pi_Value)
                      );
--
End Set_Context;
--
-----------------------------------------------------------------------------
--
Procedure Set_Context (
                      pi_Namespace In Varchar2 Default Null,
                      pi_Attribute In Varchar2,
                      pi_Value     In Varchar2
                      )
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   
  --pi_namespace is ignored, it's hardcoded to be NM3SQL
  
  nm3ctx.Set_Context  (
                      p_Attribute => pi_Attribute,
                      p_Value     => pi_Value
                      );
End Set_Context;

Function Get_Namespace Return Varchar2
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
  
  --This is the static namespace from 4500 for most core related atributes
   Return 'NM3SQL';
End Get_Namespace;

Function Get_Context  (
                      pi_Namespace In Varchar2 Default Null,
                      pi_Attribute In Varchar2
                      ) Return Varchar2
Is

Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
  
  --This is the static namespace from 4500 for most core related atributes
  
  Return (Sys_Context(Get_Namespace,pi_Attribute));
  
End Get_Context; 
--
-----------------------------------------------------------------------------
--
Function Get_Effective_Date Return Date
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
  
  --This is the static namespace from 4500 for most core related atributes
   Return (To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') );
--
End Get_Effective_Date;
--
-----------------------------------------------------------------------------
--

Procedure Instantiate_Data
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
  Null;
End Instantiate_Data;
--
-----------------------------------------------------------------------------
--
Procedure Show_All_Context  (
                            pi_Namespace  In  Varchar2 Default Null
                            )
Is
--
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.release.
  For x In  (
            Select    rpad(sc.Namespace,30,' ') || rpad(sc.Attribute,30,' ') || sc.Value Output_Line
            From      Session_Context   sc
            Where     sc.Namespace  =   Nvl(pi_Namespace,sc.Namespace)
            Order By  sc.Namespace,
                      sc.Attribute
            )
  Loop
    Dbms_Output.Put_Line(x.Output_Line);
  End Loop;
--
End Show_All_Context;
--
-----------------------------------------------------------------------------
--
Procedure Show_Context Is
--
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   Show_All_Context;
End Show_Context;
--
-----------------------------------------------------------------------------
--
Procedure Show_Context  (
                        pi_Namespace In Varchar2 Default Null,
                        pi_Attribute In Varchar2
                        )
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   DBMS_OUTPUT.PUT_LINE(pi_Namespace||'.'||pi_attribute||' : '  || Sys_Context(pi_Namespace,pi_Attribute));
End Show_Context; 



--
End Nm3Context;
/
