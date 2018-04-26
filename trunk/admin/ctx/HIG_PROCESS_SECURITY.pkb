CREATE OR REPLACE PACKAGE body hig_process_security AS 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/ctx/HIG_PROCESS_SECURITY.pkb-arc   1.2   Apr 26 2018 08:46:04   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   HIG_PROCESS_SECURITY.pkb  $
--       Date into SCCS   : $Date:   Apr 26 2018 08:46:04  $
--       Date fetched Out : $Modtime:   Apr 26 2018 08:44:16  $
--       SCCS Version     : $Revision:   1.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
g_body_sccsid     CONSTANT VARCHAR2(2000) := '"$Revision:   1.2  $"';

  FUNCTION get_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_sccsid;
  END get_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_body_sccsid;
  END get_body_version;
--
function HP_PREDICATE_READ( schema_in varchar2, name_in varchar2) RETURN varchar2 is
qq     varchar2(1) := chr(39);

CIM    constant varchar2(16) := qq||'CIM_CONTRACTOR'||qq;
CONT   constant varchar2(12) := qq||'CONTRACTOR'||qq;
usern  constant varchar2(43) := 'SYS_CONTEXT ('||qq||'NM3_SECURITY_CTX'||qq||','||qq||'USERNAME'||qq||')';
userid constant varchar2(33) := 'SYS_CONTEXT ('||qq||'NM3CORE'||qq||','||qq||'USER_ID'||qq||')';
au     constant varchar2(12) := qq||'ADMIN_UNIT'||qq;

retval varchar2(8000) := '((( hp_process_type_id IN '||
                          ' (SELECT hpt_process_type_id '||
                            '  FROM hig_process_types '||
                            ' WHERE hpt_area_type IN '||
                                      '('||CONT||', '||CIM||'))'||
                    ' AND (    EXISTS '||
                           ' (SELECT 1 '||
                                  ' FROM contractor_roles, hig_user_roles '||
                                  ' WHERE     cor_role = hur_role '||
                                       ' AND cor_oun_org_id = hp_area_id '||
                                       ' AND Sys_Context('||''''||'NM3SQL'||''''||','||''''||'CONSECMODE'||''''||') = '||''''||'A'||''''||
                                       ' AND hur_username = '||usern||')'||
                         ' OR EXISTS '||
                               ' (SELECT 1 '||
                                ' FROM contractor_users '||
                                 ' WHERE     cou_oun_org_id = hp_area_id '||
                                  ' AND Sys_Context('||''''||'NM3SQL'||''''||','||''''||'CONSECMODE'||''''||') = '||''''||'U'||''''||
                                  ' AND cou_hus_user_id = '||userid||'))'||
                 'OR     hp_process_type_id IN '||
                          ' (SELECT hpt_process_type_id '||
                           '   FROM hig_process_types '||
                            ' WHERE hpt_area_type IN ('||au||')) '||
                    ' AND hp_area_id IN '||
                          ' (SELECT hag_child_admin_unit from hig_admin_groups where hag_parent_admin_unit = '||
                                ' Sys_Context('||''''||'NM3CORE'||''''||','||''''||'USER_ADMIN_UNIT'||''''||')) '||
                          ' )'||
                 ' OR HP_INITIATED_BY_USERNAME = '||usern|| ')'||                            
            ' AND EXISTS '||
                  ' (SELECT 1 '||
                    '  FROM hig_process_type_roles, hig_user_roles '||
                    ' WHERE     hptr_process_type_id = hp_process_type_id '||
                    '       AND hur_username = '||usern||
                          ' AND hur_role = hptr_role) '||
               ' OR  hp_process_type_id IN (-1501, -1502, -1503, -1504, -1505, -1506)) ';

                                                                                                          
begin  
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
      return retval;
    end if;
end;     

function MILB_PREDICATE_READ( schema_in varchar2, name_in varchar2) RETURN varchar2 is
--
l_sec_string varchar2(2000) := ' exists ( select 1 from hig_processes where milb_hp_process_id = hp_process_id ) ';
begin
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
      return l_sec_string;
    end if;
end;

 begin 
   declare
     luser_au number;
   begin
     select hus_admin_unit into luser_au
     from hig_users where hus_user_id =  sys_context('NM3CORE', 'USER_ID');
     NM3CTX.SET_CORE_CONTEXT('USER_ADMIN_UNIT', luser_au );
     NM3CTX.SET_CONTEXT('CONSECMODE', hig.get_sysopt('CONSECMODE') ); 
   end;
--
end;
/

