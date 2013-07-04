--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3tmp.pkb-arc   2.1   Jul 04 2013 16:35:52   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3tmp.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:34:46  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
create or replace package body nm3tmp as
--
----------------------------------------------------------------------------------------------
--
function get_units( p_unit_id in number ) return varchar2 is

  cursor c1 is
    select un_unit_name
    from   nm_units
    where  un_unit_id = p_unit_id;

  l_retval nm_units.un_unit_name%type;

begin
  open c1;
  fetch c1 into l_retval;
  close c1;

  return l_retval;
end;
--
----------------------------------------------------------------------------------------------
--
function get_nt_unique( p_type in varchar2 ) return varchar2 is

  cursor c1 is
    select nt_unique
    from   nm_types
    where nt_type = p_type;

  l_retval nm_types.nt_unique%type;
begin
  open c1;
  fetch c1 into l_retval;
  close c1;

  return l_retval;
end;
--
----------------------------------------------------------------------------------------------
--
function get_nit_descr( p_type in varchar2 ) return varchar2 is

  cursor c1 is
    select nit_descr
    from   nm_inv_types
    where  nit_inv_type = p_type;

  l_retval nm_inv_types.nit_descr%type;
begin
  open c1;
  fetch c1 into l_retval;
  close c1;

  return l_retval;
end;
--
----------------------------------------------------------------------------------------------
--
function get_top_item_type ( p_type in varchar2) return varchar2 is
cursor c1 is
  select b.itg_parent_inv_type
  from nm_inv_type_groupings b
    where not exists ( 
       select 'x' from nm_inv_type_groupings c 
       where c.itg_inv_type = b.itg_parent_inv_type )
  connect by prior itg_parent_inv_type = itg_inv_type
  start with itg_inv_type = p_type;

  l_retval nm_inv_types.nit_inv_type%type;
begin
  open c1;
  fetch c1 into l_retval;
  if c1%notfound then 
    l_retval := p_type;
  end if;
  close c1;
  return l_retval;
end;
--
----------------------------------------------------------------------------------------------
--
function get_inv_type_icon(p_inv_type in varchar2) return varchar2 is

  cursor c1 is
    select replace(upper(nit_icon_name), '.ICO', '')
    from   nm_inv_types
    where  nit_inv_type = p_inv_type;

  l_retval nm_inv_types.nit_icon_name%type;
begin
  open c1;
  fetch c1 into l_retval;
  close c1;

  return l_retval;
end;
--
----------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------
-- Start of functions and procedures required for inventory view creattion
-- via mai1400
--
Function View_Exists ( inv_view_name in nm_inv_types.nit_view_name%type ) return boolean is
-- 
   cursor user_view_exists is
   select 1
    from  all_objects
   where  object_name = inv_view_name
    and   object_type = 'VIEW'
    and   status      = 'VALID';
--
   v_exists integer;
--
   l_retval BOOLEAN;         
--
begin
--
   OPEN  user_view_exists;
--
   FETCH user_view_exists INTO v_exists;
--
   l_retval := user_view_exists%FOUND;
--
   CLOSE user_view_exists;
--
   RETURN l_retval;
--
end View_Exists;
--
----------------------------------------------------------------------------------------------
--
--   
-- Check if the existing view is in use within the database.
--
Function view_in_use ( p_view_name in nm_inv_types.nit_view_name%type ) return boolean IS
--
   exclusive_mode integer := 6;
   id             integer := 100;
--
   CURSOR in_use IS -- Dummy cursor for the present.
   SELECT 1
    FROM  dual;
--
   v_in_use INTEGER;
--
   l_retval BOOLEAN;
--
begin
--
   OPEN  in_use;
--
   FETCH in_use INTO v_in_use;
--
-- Reversed logic so that function
-- does not fail.
   l_retval := in_use%NOTFOUND;
--
   CLOSE in_use;
--
   RETURN l_retval;
--
end View_In_Use; 
--
----------------------------------------------------------------------------------------------
--
--  
Function Synonym_exists(synonym in nm_inv_types.nit_view_name%type) return boolean is
--
   CURSOR syn_exists IS
   SELECT 1
    FROM  all_synonyms
   WHERE  synonym_name = synonym
    AND   owner        = 'PUBLIC';
--
   v_exists INTEGER;
--
   l_retval BOOLEAN;
--
begin
--
   OPEN  syn_exists;
--
   FETCH syn_exists INTO v_exists;
--
   l_retval := syn_exists%FOUND;
--
   CLOSE syn_exists;
--
   RETURN l_retval;
--
end Synonym_Exists;
--
----------------------------------------------------------------------------------------------
--
--  
-- When called, this procedure should perform the actual creation of the 
-- specified inventory view. A return code should be provided if there were any
-- problems when creating the view object. ( Such as insufficient privelages ).
--
--   
Procedure Create_view (p_view_name       in nm_inv_types.nit_view_name%type
                      ,p_inventory_type  in nm_inv_types.nit_inv_type%type
                      ,p_join_to_network IN BOOLEAN DEFAULT FALSE
                      ) is
--
   l_create_view_sql      varchar2(32767); 
   l_synonym_sql          varchar2(32767); 
--
   l_p_or_c               nm_inv_types.nit_pnt_or_cont%type;
-- 
   invalid_item_type      exception;
--
-- get type of inventory item so end-chain can be included/excluded
--
   cursor get_p_or_c (p_nit_inv_type nm_inv_types.nit_inv_type%TYPE) is
   select nit_pnt_or_cont
    from  nm_inv_types 
   where  nit_inv_type = p_nit_inv_type;
-- 
   c_new_line CONSTANT varchar2(1) := CHR(10);
--
begin 
--
   OPEN  get_p_or_c (p_inventory_type);
   FETCH get_p_or_c INTO l_p_or_c;
--
   IF get_p_or_c%notfound
    THEN
      CLOSE get_p_or_c;
      RAISE invalid_item_type;
   END IF;
--
   CLOSE get_p_or_c;
--
   l_create_view_sql := 'CREATE OR REPLACE VIEW '||p_view_name||c_new_line||' AS '||
                        'SELECT '||c_new_line|| -- /* INDEX (INV_ITEMS_ALL IIT_INDEX_P2) */
                        '--'||c_new_line||
                        '-- View "'||p_view_name||'" for inv_type "'||p_inventory_type||
                        '" built '||TO_CHAR(sysdate,'HH24:MI:SS DD-MON-YYYY')||c_new_line||
                        '--'||c_new_line||
                        '       iit_ne_id'||c_new_line||
                        '      ,iit_inv_type'||c_new_line||
                        '      ,iit_primary_key'||c_new_line||
                        '      ,iit_start_date'||c_new_line||
                        '      ,iit_created_date'||c_new_line||
                        '      ,iit_last_updated_date'||c_new_line||
                        '      ,iit_admin_unit'||c_new_line||
                        '      ,iit_x_sect'||c_new_line||
                        '      ,iit_end_date'||c_new_line; -- ,iit_rse_he_id,iit_st_chain
   IF l_p_or_c <> 'P'
    THEN
      l_create_view_sql := l_create_view_sql; --||',iit_end_chain'; 
   END IF;
--
--
-- Obtain all specified inventory columns for the selected inventory 
-- type. 
--
   FOR each_attribute IN (SELECT ita_attrib_name
                                ,ita_view_col_name 
                                ,ita_dtp_code     
                           FROM  nm_inv_type_attribs 
                          WHERE  ita_inv_type = p_inventory_type 
                          ORDER BY ita_disp_seq_no
                         )
    LOOP
       l_create_view_sql := l_create_view_sql
                            ||'      ,'||LOWER(each_attribute.ita_attrib_name)||' '||each_attribute.ita_view_col_name||c_new_line; 
   END LOOP;
--
   IF p_join_to_network
    THEN
      l_create_view_sql := l_create_view_sql
                           ||'      -- Network members columns'||c_new_line
                           ||'      ,nm_ne_id_of ne_id_of'||c_new_line
                           ||'      ,nm_begin_mp ne_start'||c_new_line
                           ||'      ,nm_end_mp   ne_end'||c_new_line
                           ||'      ,nm_slk      ne_slk'||c_new_line;
   END IF;
--
   l_create_view_sql := l_create_view_sql||' FROM  nm_inv_items '||c_new_line;
--
   IF p_join_to_network
    THEN
      l_create_view_sql := l_create_view_sql||'      ,nm_members '||c_new_line;
   END IF;
--
   l_create_view_sql := l_create_view_sql||' WHERE iit_inv_type = '||CHR(39)||p_inventory_type||CHR(39)||c_new_line;
--
   IF p_join_to_network
    THEN
      l_create_view_sql := l_create_view_sql||'  AND  nm_ne_id_in  = iit_ne_id';
   END IF;
--
   EXECUTE IMMEDIATE l_create_view_sql;
--
   IF hig.get_sysopt('HIGPUBSYN') = 'Y'
    THEN
      IF synonym_exists(p_view_name)
       THEN
-- 
         l_synonym_sql := 'DROP PUBLIC SYNONYM '||p_view_name;
--
        EXECUTE IMMEDIATE l_synonym_sql;
--
      END IF;
      --
      -- Create the public synonym for the previouslry created view. 
      -- 
      l_synonym_sql := 'CREATE PUBLIC SYNONYM '|| 
                        p_view_name|| 
                       ' FOR '||user||'.'||p_view_name; 
--
      EXECUTE IMMEDIATE l_synonym_sql;
--
   END IF;
--  
EXCEPTION
--  
  WHEN invalid_item_type
   THEN
     RAISE_APPLICATION_ERROR( -20001, 'Invalid Item Type - View cannot be created');
--  
END create_view; 
--
----------------------------------------------------------------------------------------------
--
Procedure Create_inv_view (p_view_name       in nm_inv_types.nit_view_name%type
                          ,p_inventory_type  in nm_inv_types.nit_inv_type%type
                          ,p_join_to_network IN BOOLEAN DEFAULT FALSE
                          ) is
--
  Specified_View_In_Use exception;
  Pragma exception_init (Specified_View_In_Use,-20002);
--
Begin
    --    
    -- Logic : If the specified view doew NOT exist 
    --         then Create the specified view.
    --         else If the view is In-Use 
    --         then return and error indicating usage
    --         else Create the view.
    --
    IF NOT view_exists(p_view_name)
     THEN
       create_view(p_view_name,p_inventory_type,p_join_to_network);
    ELSIF  view_in_use(p_view_name)
     THEN
       RAISE_APPLICATION_ERROR( -20002,'Specified_View_In_Use');
    ELSE
       create_view(p_view_name,p_inventory_type,p_join_to_network);
    END IF;
--
EXCEPTION
--
    WHEN OTHERS
     THEN
       RAISE_APPLICATION_ERROR( -20002, sqlerrm );
--
end Create_inv_view;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE Create_all_inv_views IS
BEGIN
--
   dbms_output.enable(1000000);
--
   FOR cs_rec IN (SELECT nit_inv_type
                   FROM  nm_inv_types
                  ORDER BY nit_inv_type
                 )
    LOOP
      declare
         l_current_view_name user_views.view_name%TYPE;
         l_created_string    VARCHAR2(80) := 'Created ';
      begin
--
--       Create the inventory views
--
         l_current_view_name := derive_inv_type_view_name(cs_rec.nit_inv_type);
         l_created_string    := l_created_string||' - '||l_current_view_name;
--
         create_inv_view (l_current_view_name
                         ,cs_rec.nit_inv_type
                         ,FALSE
                         );
--
--       Create the inventory views joined to the network
--
         l_current_view_name := derive_nw_inv_type_view_name(cs_rec.nit_inv_type);
         l_created_string    := l_created_string||' - '||l_current_view_name;
--
         create_inv_view (l_current_view_name
                         ,cs_rec.nit_inv_type
                         ,TRUE
                         );
--
         dbms_output.put_line (l_created_string);
--
      exception
          when others
           then
--
             dbms_output.put_line ('ERROR '||l_current_view_name);
             dbms_output.put_line ('......'||substr(sqlerrm,1,74));
--
      end;
   END LOOP;
--
END Create_all_inv_views;
--
----------------------------------------------------------------------------------------------
--
FUNCTION derive_inv_type_view_name (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE)
 RETURN VARCHAR2 IS
BEGIN
--
   RETURN 'V_NM_'||pi_inv_type;
--
END derive_inv_type_view_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION derive_nw_inv_type_view_name (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE)
 RETURN VARCHAR2 IS
BEGIN
--
   RETURN derive_inv_type_view_name(pi_inv_type)||'_NW';
--
END derive_nw_inv_type_view_name;
--
----------------------------------------------------------------------------------------------
--
end;
/
