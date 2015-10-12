   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/utl/compile_lb_objects2.sql-arc   1.0   Oct 12 2015 16:29:26   Rob.Coupe  $
   --       Module Name      : $Workfile:   compile_lb_objects2.sql  $
   --       Date into PVCS   : $Date:   Oct 12 2015 16:29:26  $
   --       Date fetched Out : $Modtime:   Oct 08 2015 08:59:44  $
   --       PVCS Version     : $Revision:   1.0  $
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
  select o.* 
  bulk collect into l_object_tab
  from user_objects o, lb_dependency_order d
  where  d.object_name = o.object_name
  and d.object_type = o.object_type
  and o.object_type != 'TABLE';
--
  for i in 1..l_object_tab.count loop
    begin
      if l_object_tab(i).object_type in ('PACKAGE BODY') then
        execute immediate 'alter package '||l_object_tab(i).object_name||' compile body';
      else
        execute immediate 'alter '||l_object_tab(i).object_type||' '||l_object_tab(i).object_name||' compile ';
      end if;
    exception
      when others then dbms_output.put_line('Failure on '||l_object_tab(i).object_type||','||l_object_tab(i).object_name );
    end;
  end loop;
end;   
/
