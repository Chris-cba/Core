   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/utl/compile_lb_objects2.sql-arc   1.1   Aug 11 2017 14:32:54   Rob.Coupe  $
   --       Module Name      : $Workfile:   compile_lb_objects2.sql  $
   --       Date into PVCS   : $Date:   Aug 11 2017 14:32:54  $
   --       Date fetched Out : $Modtime:   Aug 11 2017 13:35:40  $
   --       PVCS Version     : $Revision:   1.1  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge - script for compilation in dependency order
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------


declare
  subtype obj_rec  is user_objects%rowtype;
  type object_tab is table of obj_rec;
  l_object_tab  object_tab;
--
begin
  dbms_output.enable(buffer_size => NULL);
  
  select o.* 
  bulk collect into l_object_tab
  from user_objects o, lb_dependency_order d
  where  d.object_name = o.object_name
  and d.object_type = o.object_type
  and o.object_type not in ('TABLE', 'SEQUENCE')
  order by d.DEP_SEQUENCE;
--
  for i in 1..l_object_tab.count loop
  dbms_output.put_line('Compiling '||l_object_tab(i).object_type||' '||l_object_tab(i).object_name);
    begin
      if l_object_tab(i).object_type = 'PACKAGE BODY' then
        execute immediate 'alter PACKAGE '||l_object_tab(i).object_name||' compile body'; 
      elsif l_object_tab(i).object_type = 'TYPE BODY' then     
        execute immediate 'alter TYPE '||l_object_tab(i).object_name||' compile body'; 
      else
        execute immediate 'alter '||l_object_tab(i).object_type||' '||l_object_tab(i).object_name||' compile ';
      end if;
    exception
      when others then dbms_output.put_line('Failure on '||l_object_tab(i).object_type||','||l_object_tab(i).object_name||' - '||sqlerrm );
    end;
  end loop;
end;   
/
