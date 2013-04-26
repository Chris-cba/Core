CREATE OR REPLACE PACKAGE BODY nm3nwausec AS 
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/NM3NWAUSEC.pkb-arc   1.4   Apr 26 2013 15:05:14   Rob.Coupe  $
--       Module Name      : $Workfile:   NM3NWAUSEC.pkb  $
--       Date into SCCS   : $Date:   Apr 26 2013 15:05:14  $
--       Date fetched Out : $Modtime:   Apr 26 2013 15:04:06  $
--       SCCS Version     : $Revision:   1.4  $
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley Systems 2012
-----------------------------------------------------------------------------


g_body_sccsid     CONSTANT VARCHAR2(2000) := '"$Revision:   1.4  $"';

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

 FUNCTION get_string (p_au_col_name  IN varchar2 ) RETURN varchar2 IS 
 l_retval varchar2(2000); 
 BEGIN 
  l_retval := 'exists (SELECT  1 '||CHR(10)|| 
              'FROM  HIG_ADMIN_GROUPS '||CHR(10)||
              'WHERE  HAG_PARENT_ADMIN_UNIT  = Sys_Context('||''''||'NM3CORE'||''''||','||''''||'USER_ADMIN_UNIT'||''''||')'||CHR(10)|| 
              '  AND   HAG_CHILD_ADMIN_UNIT = '||p_au_col_name||CHR(10)|| 
              ' ) '||CHR(10); 
    RETURN l_retval; 
 END get_string; 
 
 FUNCTION get_up_string (p_au_col_name  IN varchar2 ) RETURN varchar2 IS 
 l_retval varchar2(2000); 
 BEGIN 
  l_retval := 'exists (SELECT  1 '||CHR(10)|| 
              'FROM  HIG_ADMIN_GROUPS '||CHR(10)||
              'WHERE  HAG_CHILD_ADMIN_UNIT  = Sys_Context('||''''||'NM3CORE'||''''||','||''''||'USER_ADMIN_UNIT'||''''||')'||CHR(10)|| 
              '  AND   HAG_PARENT_ADMIN_UNIT = '||p_au_col_name||CHR(10)|| 
              ' ) '||CHR(10); 
    RETURN l_retval; 
 END get_up_string; 
 FUNCTION get_parent_string (p_au_col_name  IN varchar2 ) RETURN varchar2 IS 
 l_retval varchar2(2000); 
 BEGIN 
  l_retval := 'exists (SELECT  1 '||CHR(10)|| 
              'FROM  HIG_ADMIN_GROUPS '||CHR(10)||
              'WHERE  HAG_CHILD_ADMIN_UNIT  = Sys_Context('||''''||'NM3CORE'||''''||','||''''||'USER_ADMIN_UNIT'||''''||')'||CHR(10)|| 
              '  AND   HAG_PARENT_ADMIN_UNIT = '||p_au_col_name||CHR(10)|| 
              ' and ( hag_direct_link = '||''''||'Y'||''''||' OR HAG_PARENT_ADMIN_UNIT = ) Sys_Context('||''''||'NM3CORE'||''''||','||''''||'USER_ADMIN_UNIT'||''''||')'; 
    RETURN l_retval;
 END get_parent_string;     
 
 FUNCTION get_au_list return int_array_type is 
 begin 
   return au_list.ia; 
 end; 
--
function HPA_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN 'EXISTS (SELECT 1 from HIG_PROCESSES where hpal_process_id = hp_process_id )'; 
    END IF; 
 END; 

function DOC_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN   ' ( ( '||CHR(10)||
                ' doc_dlc_id is null'||CHR(10)|| 
                ' or exists ( select 1 from doc_locations '||CHR(10)||
                '    where doc_dlc_id = dlc_id '||CHR(10)||
                '    and   dlc_location_type != '||''''||'ORACLE_DIRECTORY'||''''||chr(10)||
                '              or ( dlc_location_type   =  '||''''||'ORACLE_DIRECTORY'||''''||chr(10)||
                '                   and doc_dlc_id = dlc_id '||CHR(10)||
                '  and exists (select 1 from hig_directory_roles, hig_user_roles '||CHR(10)||
                '             where hdr_name = dlc_location_name '||CHR(10)||
                '             and hur_role = hdr_role '||CHR(10)||
                '             and hur_username = Sys_Context('||''''||'NM3_SECURITY_CTX'||''''||','||''''||'USERNAME'||''''||') '||chr(10)||
                '            )) ) ' ||chr(10)||
                '              ) ' ||chr(10)||
                ' and ( doc_admin_unit is null OR '||chr(10)||
                ' exists (SELECT  1  '||CHR(10)||
                ' FROM  HIG_ADMIN_GROUPS  '||CHR(10)||
                ' WHERE  HAG_PARENT_ADMIN_UNIT  = Sys_Context('||''''||'NM3CORE'||''''||','||''''||'USER_ADMIN_UNIT'||''''||')'||CHR(10)|| 
                '  AND   HAG_CHILD_ADMIN_UNIT = DOC_ADMIN_UNIT '||chr(10)||
                ' ) ) '||CHR(10)||
                ' ) '; 
    END IF; 
END; 


function SEC_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN get_string('SEC_ADMIN_UNIT'); 
    END IF; 
 END; 

function HFC_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN get_string('HFC_NAU_ADMIN_UNIT'); 
    END IF; 
 END; 

--
function NAU_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS 
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN get_string('NAU_ADMIN_UNIT')||' OR '||get_up_string('NAU_ADMIN_UNIT');
    END IF; 
 END; 
function NAU_predicate_DML( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN get_string('NAU_ADMIN_UNIT');
    END IF; 
 END; 

-- 
FUNCTION NE_predicate_READ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN get_string('ne_admin_unit')||' OR '||get_up_string('ne_admin_unit');--||' OR exists ( select 1 from nm_admin_units where nau_admin_unit = ne_admin_unit and nau_level = 1 )';
    END IF; 
 END;

FUNCTION NE_predicate_DML( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN get_string('ne_admin_unit');--||' OR exists ( select 1 from nm_admin_units where nau_admin_unit = ne_admin_unit and nau_level = 1 )';
    END IF; 
 END;

FUNCTION NM_predicate_READ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN '('||get_string('nm_admin_unit')||' OR '||get_up_string('nm_admin_unit')||')'||' AND exists ( select 1 from nm_elements_all where ne_id = nm_ne_id_of )';
    END IF; 
 END;

FUNCTION NM_predicate_DML( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN '( '||get_string('nm_admin_unit')|| ' OR '||get_up_string('nm_admin_unit')||
--       
--       ' AND '||get_parent_string('nm_admin_unit')||
       ') AND '||
             get_string('(select ne_admin_unit from nm_elements_all where ne_id = nm_ne_id_of )');
    END IF; 
 END;
-- 
function HDIR_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN 
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN ' ( exists ( '||chr(10)||
              ' select 1 from hig_directory_roles, hig_user_roles '||chr(10)||
              ' where hur_role = hdr_role '||chr(10)||
              ' and   hdr_name = hdir_name '||chr(10)||
              ' and   hur_username = Sys_Context('||''''||'NM3_SECURITY_CTX'||''''||','||''''||'USERNAME'||''''||')) ) ';
    END IF; 
 END;


function DLC_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
begin
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME') 
     THEN 
       RETURN NULL; 
    ELSE 
       RETURN ' ( dlc_location_type != '||''''||'ORACLE_DIRECTORY'||''''||chr(10)||
              ' or ( dlc_location_type   =  '||''''||'ORACLE_DIRECTORY'||''''||chr(10)||
              ' and exists (select 1 from hig_directory_roles, hig_user_roles '||chr(10)||
              '       where hdr_name = dlc_location_name '||chr(10)||
              '       and   hur_role = hdr_role '||CHR(10)||
              '       and   hur_username = Sys_Context('||''''||'NM3_SECURITY_CTX'||''''||','||''''||'USERNAME'||''''||') '||chr(10)||
              '          )) )';
    END IF; 
end;

--  
 begin 
   declare
     luser_au number;
   begin
     select hus_admin_unit into luser_au
     from hig_users where hus_user_id =  sys_context('NM3CORE', 'USER_ID');
     NM3CTX.SET_CORE_CONTEXT('USER_ADMIN_UNIT', luser_au );
     NM3CTX.SET_CONTEXT('CONSECMODE', hig.get_sysopt('CONSECMODE') ); 
   end;
   select nua_admin_unit 
   bulk collect into au_list.ia 
   from nm_user_aus 
   where nua_user_id = sys_context('NM3CORE', 'USER_ID');
 END nm3nwausec;
/


