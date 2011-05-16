CREATE OR REPLACE PACKAGE BODY hig_std_text
AS
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/tma/admin/pck/hig_std_text.pkb-arc   3.4   May 16 2011 14:42:20   Steve.Cooper  $
--       Module Name      : $Workfile:   hig_std_text.pkb  $
--       Date into SCCS   : $Date:   May 16 2011 14:42:20  $
--       Date fetched Out : $Modtime:   May 03 2011 11:01:10  $
--       SCCS Version     : $Revision:   3.4  $
--       Based on 
--
--
--  Author : B O'Driscoll
--
--  Package of functions and or procedures required to support
--  the implementation of the Projects model.
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.4  $';
   g_package_name CONSTANT varchar2(30) := 'tma_fpns_api';

--sccsid constant varchar2(30) :='"$Revision:   3.4  $"';
--   g_body_sccsid is the SCCS ID for the package body
--
--------------------------------------------------------------------------------
--
  FUNCTION is_allowed 
            ( pi_module_name  IN hig_module_items.hmi_module_name%TYPE
            , pi_module_block IN hig_module_items.hmi_block_name%TYPE
            , pi_module_item  IN hig_module_items.hmi_item_name%TYPE)
  RETURN BOOLEAN IS
    l_dummy VARCHAR2(10);
  BEGIN
    SELECT 'allowed' INTO l_dummy FROM hig_module_items
     WHERE hmi_module_name  = pi_module_name
       AND hmi_block_name = pi_module_block
       and hmi_item_name  = pi_module_item;
    RETURN TRUE;     
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
      RETURN FALSE;
END is_allowed;
--
--------------------------------------------------------------------------------
--
--<PROC NAME="GET_HST_TEXT_ID">
-- get hst_text_id_seq.nexval --
FUNCTION get_hst_text_id 
  RETURN hig_standard_text.hst_text_id%TYPE IS 
--
  cursor c_seq Is
  select hst_text_id_seq.nextval
  from   dual;
  --
  l_hst_text_id  hig_standard_text.hst_text_id%TYPE;
  --
Begin
  --
  open  c_seq;
  fetch c_seq Into l_hst_text_id;
  close c_seq;
  --
  Return l_hst_text_id;
  --
END get_hst_text_id;

--</PROC>
--
-----------------------------------------------------------------------------
-- 
--<PROC NAME="GET_USER_TEXT">
-- get get standard text chosen by user --
PROCEDURE get_user_text(p_hstu_user_id       in hig_standard_text_usage.hstu_user_id%type,
                        p_hst_text_id        in hig_standard_text.hst_text_id%type,
                        p_hst_module_item_id in hig_standard_text.hst_module_item_id%type,
                        p_text          out hig_standard_text.hst_text%type,
                        p_top_ranking   out hig_standard_text_usage.hstu_top_ranking%type) IS

cursor get_text is
   select  hst_text, hstu_top_ranking
    from   hig_standard_text_usage, hig_standard_text
    where  hst_text_id = p_hst_text_id
    and    hst_text_id = hstu_text_id
    and    hst_module_item_id = p_hst_module_item_id
    and    hst_module_item_id = hstu_module_item_id
    and    hstu_user_id = p_hstu_user_id;
    --order by hst_test desc;
        

begin
  
  open get_text;
     fetch get_text into p_text, p_top_ranking;
  close get_text;    
  
  
end;                          
--</PROC>
--
-----------------------------------------------------------------------------
-- 
--<PROC NAME="INSERT_INTO_HSTU">
-- INSERT INTO HIG_STANDARD_TEXT_USAGE --
PROCEDURE insert_into_hstu(p_hst_text_id        in hig_standard_text.hst_text_id%type,
                           p_hst_module_item_id in hig_standard_text.hst_module_item_id%type,
                           p_hstu_user_id       in hig_standard_text_usage.hstu_user_id%type) IS
begin
 
   if p_hst_text_id is not null
    and p_hst_module_item_id is not null
    and p_hstu_user_id is not null then
  
      insert into hig_standard_text_usage
        (hstu_user_id, hstu_module_item_id, hstu_text_id, hstu_top_ranking)
      values 
        (p_hstu_user_id, p_hst_module_item_id, p_hst_text_id, 'N');
  end if;


end;

                          
--</PROC>
--
-----------------------------------------------------------------------------
--
PROCEDURE get_standard_text(po_textab  out textab) IS

cursor get_text is
   select hst_text
   from   hig_standard_text 
   order by hst_text asc;

ind    number;

begin

   ind := 1;

   for crec in get_text loop
  
     po_textab(ind).hst_text := crec.hst_text;
          
     ind := ind + 1;
     
   end loop;   

END; 
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_STANDARD_TEXT"> bod
-- get standard text chosen by user --
PROCEDURE get_std_text(p_user_id         in hig_users.hus_user_id%type,
                       p_hmi_module_name in hig_module_items.hmi_module_name%type,
                       p_hmi_block_name  in hig_module_items.hmi_block_name%type,
                       p_hmi_item_name   in hig_module_items.hmi_item_name%type,
                       p_stdtab          in out stdtab) is

ind         number;
l_user_id   number;

cursor get_text is                             
   select hmi_field_desc, hst_text, hstu_top_ranking
   from   hig_module_items,
          hig_standard_text_usage, hig_standard_text
   where  hmi_module_name = p_hmi_module_name
   and    hmi_block_name = p_hmi_block_name
   and    hmi_item_name  = p_hmi_item_name
   and    hmi_module_item_id = hst_module_item_id
   and    hst_text_id = hstu_text_id 
   and    hstu_user_id = l_user_id
   order by hstu_top_ranking desc, hst_text asc;


begin

   select hus_user_id into l_user_id 
   from hig_users where hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME'); 
   
   ind := 1;

   for crec in get_text loop  

     p_stdtab(ind).hmi_field_desc := crec.hmi_field_desc;
     p_stdtab(ind).hst_text := crec.hst_text;
     p_stdtab(ind).hstu_top_ranking := crec.hstu_top_ranking;
          
     ind := ind + 1;
     
   end loop;   
                       

end;                          
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_FIELD_DESC">
-- get field description when no standard text exists --
FUNCTION get_field_desc(p_hmi_module_name in hig_module_items.hmi_module_name%type,
                        p_hmi_block_name  in hig_module_items.hmi_block_name%type,
                        p_hmi_item_name   in hig_module_items.hmi_item_name%type) RETURN hig_module_items.hmi_field_desc%type IS
  
                     
cursor get_desc is                             
   select hmi_field_desc
   from   hig_module_items
   where  upper(hmi_module_name) = upper(p_hmi_module_name)
   and    upper(hmi_block_name) = upper(p_hmi_block_name)
   and    upper(hmi_item_name)  = upper(p_hmi_item_name);
   
   l_ret  hig_module_items.hmi_field_desc%type;
                       
BEGIN


   open get_desc;
  
      fetch get_desc into l_ret;
              
   close get_desc;   

   return l_ret;
  

END;                                                                     
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="set_append_std_text">
--
PROCEDURE set_append_std_text(p_std_text  IN  hig_standard_text.hst_text%type) IS
BEGIN
    g_append_std_text := p_std_text;
END set_append_std_text;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<FUNC NAME="get_append_std_text">
--
FUNCTION get_append_std_text RETURN varchar2 IS
BEGIN
  RETURN g_append_std_text;
END get_append_std_text;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="set_std_text">
--
PROCEDURE set_std_text(p_std_text  IN  hig_standard_text.hst_text%type) IS
BEGIN
    g_std_text := p_std_text;
END set_std_text;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<FUNC NAME="get_std_text">
--
FUNCTION get_std_text RETURN varchar2 IS
BEGIN
  RETURN g_std_text;
END get_std_text;
--</PROC>
--
------------------------------------------------------------------------------
--<FUNC NAME="get_user_id">
--
FUNCTION get_user_id(p_username   in hig_users.hus_username%type) RETURN number IS
  
  cursor c_user_id is
  select hus_user_id
  from   hig_users
  where  hus_username = p_username;
  --
  l_user_id  hig_users.hus_user_id%TYPE;
  --
Begin
  --
  open  c_user_id;
  fetch c_user_id Into l_user_id;
  close c_user_id;
  --
  Return l_user_id;
  --
END get_user_id;


--</PROC>
--
------------------------------------------------------------------------------
--<PROC NAME="add_all_tect_to_user">
--
PROCEDURE add_all_text_to_user(p_user_id  in hig_users.hus_user_id%type,
                               p_hst_module_item_id in hig_standard_text.hst_module_item_id%type)
                               IS
 
  l_hst_text_id    hig_standard_text.HST_TEXT_ID%type;
   
  Cursor c_hst_text_id Is
   Select hst_text_id
   From   hig_standard_text
   where  hst_module_item_id = p_hst_module_item_id
   and    hst_text_id not in (select hstu_text_id 
                              from hig_standard_text_usage                 
                              where hstu_user_id = p_user_id)
   order by hst_text_id;    
Begin
    --
  for crec in c_hst_text_id loop 
  
     l_hst_text_id := crec.hst_text_id; 
        
     Insert Into hig_standard_text_usage
            (hstu_user_id, hstu_module_item_id, hstu_text_id, hstu_top_ranking)
     Values (p_user_id, p_hst_module_item_id,l_hst_text_id,'N' );
     
     --commit;
      
  end loop;  
  --
  
End add_all_text_to_user;                                                         
--</PROC>
--
------------------------------------------------------------------------------
--<PROC NAME="DELETE_FROM_HSTU">
-- DELETE FROM HIG_STANDARD_TEXT_USAGE --
PROCEDURE delete_from_hstu(p_hst_text_id    in hig_standard_text.hst_text_id%type,
                           p_hst_module_item_id in hig_standard_text.hst_module_item_id%type,
                           p_hstu_user_id   in hig_standard_text_usage.hstu_user_id%type) IS                               

begin
 
   if p_hst_text_id is not null
      and p_hst_module_item_id is not null
      and p_hstu_user_id is not null then

      delete from hig_standard_text_usage
      where hstu_text_id = p_hst_text_id
      and   hstu_module_item_id = p_hst_module_item_id
      and   hstu_user_id = p_hstu_user_id;
        
  end if;
  NULL;


end;

                          
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="DELETE_FROM_HSTU">
-- DELETE FROM HIG_STANDARD_TEXT_USAGE --
PROCEDURE copy_std_text_list(p_user_id1  in hig_users.hus_user_id%type,
                             p_user_id2  in hig_users.hus_user_id%type) IS                                                 

l_cnt   number;

cursor get_text is
  select hstu_module_item_id, hstu_text_id, hstu_top_ranking
  from   hig_standard_text_usage
  where  hstu_user_id = p_user_id1;

cursor check_exists is
  select count(*)
  from   hig_standard_text_usage
  where  hstu_user_id = p_user_id2;
  
begin
 
  open check_exists;
    fetch check_exists into l_cnt;
  close check_exists;  
  
  if l_cnt > 0 then
     delete from hig_standard_text_usage
     where hstu_user_id = p_user_id2;
  end if;

  --insert new required records--
  for crec in get_text loop 
      
     Insert Into hig_standard_text_usage
       (hstu_user_id, hstu_module_item_id, hstu_text_id, hstu_top_ranking)
     Values 
       (p_user_id2, crec.hstu_module_item_id, crec.hstu_text_id, crec.hstu_top_ranking);
     
     commit;
      
  end loop;  


end;

                          
--</PROC>
--
-----------------------------------------------------------------------------
--
--<FUNC NAME="GET_STD_TEXT_MAX_LENGTH">
-- GET STANDARD TEXT MAX LENGTH --
FUNCTION get_std_text_max_length
    (p_hmi_module_item_id in hig_module_items.hmi_module_item_id%type) return number is

 cursor get_tab_dets is
    select hmi_table_name, hmi_column_name
    from   hig_module_items
    where  hmi_module_item_id = p_hmi_module_item_id; 

 l_ret  number;
 l_tab_name varchar2(30);
 l_col_name varchar2(30);

Begin

    open get_tab_dets;
      fetch get_tab_dets into l_tab_name, l_col_name;
    close get_tab_dets;      

    select data_length
    into   l_ret
    from   all_tab_cols
    where  table_name  = l_tab_name
    And    column_name = l_col_name
    AND    owner = Sys_Context('NM3CORE','APPLICATION_OWNER');

    return l_ret;

End;                                                           
--</PROC>
--
-----------------------------------------------------------------------------
--
--<FUNC NAME="GET_TEXT_BY_ID">
-- GET STANDARD TEXT BY ID --
FUNCTION get_text_by_id(p_hst_text_id in hig_standard_text.hst_text_id%type)
                                 return varchar2 IS
  cursor get_text is
    select hst_text
    from  hig_standard_text
    where hst_text_id = p_hst_text_id;
 
 --
  l_text  hig_standard_text.hst_text%TYPE;
  --
Begin
  --
  open  get_text;
  fetch get_text Into l_text;
  close get_text;
  --
  Return l_text;
  --
END;                                                                                    
--</FUNC>
--
-----------------------------------------------------------------------------
--
END hig_std_text; 
/
