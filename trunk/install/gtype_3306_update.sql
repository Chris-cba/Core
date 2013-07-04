--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/gtype_3306_update.sql-arc   1.3   Jul 04 2013 13:45:30   James.Wadsworth  $
--       Module Name      : $Workfile:   gtype_3306_update.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:08  $
--       PVCS Version     : $Revision:   1.3  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
--
-- gtype_3306_update.sql - script to update multi-part lrs features to 3306
--

declare
  cursor c1 is 
    select nth_feature_table, nth_feature_shape_column
    from nm_themes_all, nm_nw_themes, nm_linear_types
    where nth_theme_id = nnth_nth_theme_id
    and nnth_nlt_id = nlt_id
    and nth_base_table_theme is null
    and nlt_gty_type is not null;   
--
begin
  for irec in c1 loop
    begin
      execute immediate 'update '||irec.nth_feature_table||' a '||
                        ' set a.'||irec.nth_feature_shape_column||'.sdo_gtype = 3306 '||
                        ' where objectid in (select objectid from ( '||
                        '       select objectid, t.* from '||irec.nth_feature_table||' b, table (b.'||irec.nth_feature_shape_column||'.sdo_elem_info) t ) '||
                        '       group by objectid having count(*) > 3)';
	exception
	  when others then 
	    dbms_output.put_line('Error in changing gtype on table '||irec.nth_feature_table||'-'||sqlerrm );
	end;
  end loop;
  commit;
end;
/
