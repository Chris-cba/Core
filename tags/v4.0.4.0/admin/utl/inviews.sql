rem **************************************************************************
rem	This script creates Inventory views based on entered inventory data
rem **************************************************************************

define sccsid = '@(#)inviews.sql	1.4 05/26/06';

set head off 
cl scr 
prompt Highways by Exor - Maintenance Manager
prompt =====================================
prompt .
prompt .
prompt Creating Inventory Views 
prompt ======================== 
prompt . 
prompt . 
prompt Working ... 
set serveroutput on 
-- 
declare 
-- 
cursor all_inv_types is
select ity_inv_code  item_type 
      ,ity_view_name view_name 
      ,ity_sys_flag  sys_flag
      ,ity_incl_road_segs road_segs
from   inv_item_types 
order by  
       ity_inv_code 
      ,ity_sys_flag; 

begin 
  dbms_output.enable (1000000); 
  -- 
  for each_inv_type in all_inv_types loop 
    -- 
    IF each_inv_type.view_name IS NULL THEN
       each_inv_type.view_name := mai.get_view_name(each_inv_type.item_type
                                                   ,each_inv_type.sys_flag);
       update inv_type_translations
       set ity_view_name = each_inv_type.view_name
       where ity_inv_code = each_inv_type.item_type
       and   ity_sys_flag = each_inv_type.sys_flag;
     
    END IF;
    begin
      mai.create_view(view_name      => each_inv_type.view_name
                   ,inventory_type => each_inv_type.item_type
                   ,sys_flag       => each_inv_type.sys_flag);
   -- 
      dbms_output.put_line('View Created : '||each_inv_type.view_name); 
    exception when others then
      dbms_output.put_line('View creation Failed : '||each_inv_type.view_name||' '||sqlerrm); 
    end;  
  end loop; 
end; 
/

