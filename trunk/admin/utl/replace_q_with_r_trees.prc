CREATE OR REPLACE procedure replace_Q_with_R_trees 
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/replace_q_with_r_trees.prc-arc   3.1   Jul 04 2013 10:30:14   James.Wadsworth  $
--       Module Name      : $Workfile:   replace_q_with_r_trees.prc  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:26:54  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
as
  cursor get_qts is
    select nth_theme_id, nth_feature_table, nth_feature_shape_column, index_name, sdo_index_type
    from nm_themes_all, user_tables t, user_indexes a, user_sdo_index_metadata
    where exists ( select 1 from user_ind_columns b
                   where a.table_name = nth_feature_table
                   and a.table_name = b.table_name
                   and b.column_name = nth_feature_shape_column
                   and index_type = 'DOMAIN' )
    and nth_base_table_theme is null
    and nth_feature_table = t.table_name
    and t.table_name = a.table_name
    and sdo_index_name = a.index_name
--    and rownum = 1
    and sdo_index_type = 'QTREE';
    
  l_nth_theme_id              nm3type.tab_number; 
  l_nth_feature_table         nm3type.tab_varchar30; 
  l_nth_feature_shape_column  nm3type.tab_varchar30;
  l_index_name                nm3type.tab_varchar30;
  l_sdo_index_type            nm3type.tab_varchar30;
  
  progress nm3type.tab_varchar2000; 

  idx binary_integer := 0;

procedure set_progress( str in varchar2 ) is
begin
  idx := idx + 1;
  progress( idx ) := str;
end;
 
procedure dump_progress is
begin
  dbms_output.ENABLE(20000);
  for i in 1..idx loop
    dbms_output.put_line(progress( i ));
  end loop;
end;
 
begin

  if hig.GET_APPLICATION_OWNER_ID = nm3user.GET_USER_ID then

    begin
      insert into hig_option_values
      (hov_id, hov_value )
      values 
      ('SDOUSEQT', 'N' );
    exception
      when dup_val_on_index then
        update hig_option_values
        set hov_value = 'N'
        where hov_id = 'SDOUSEQT';
    end;
    
    commit;

    set_progress('Start of process to drop Quad Trees and re-instate Rtree indexes');
    
    open get_qts;
    fetch get_qts bulk collect into l_nth_theme_id, l_nth_feature_table, l_nth_feature_shape_column, l_index_name, l_sdo_index_type;
    close get_qts;

    set_progress('Collected '||to_char(l_nth_theme_id.count)||' indexes ');    

    if l_nth_theme_id.count > 0 then
    
      for i in 1..l_nth_theme_id.count loop
      
        set_progress('Drop index '||l_index_name(i));
        
        begin
          execute immediate 'drop index '||l_index_name(i);
        exception
          when others then
            null;
        end;
        
        begin
          set_progress('Create Rtree on  '||l_nth_feature_table(i));
          nm3sdo.CREATE_SPATIAL_IDX(l_nth_feature_table(i), l_nth_feature_shape_column(i));
        exception
          when others then
            set_progress( 'Fail - '||l_index_name(i)||' - '||sqlerrm );
        end;
        
      end loop;
      
      set_progress('End of Qtree replacement process');
      
    end if;    
  else
      raise_application_error ( -20001, 'You must run this as the application owner' );
  end if;

  dump_progress;
    
end;
/
