--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/gtype_3306_update.sql-arc   1.2   Oct 29 2012 09:10:44   Rob.Coupe  $
--       Module Name      : $Workfile:   gtype_3306_update.sql  $
--       Date into PVCS   : $Date:   Oct 29 2012 09:10:44  $
--       Date fetched Out : $Modtime:   Oct 29 2012 09:02:56  $
--       PVCS Version     : $Revision:   1.2  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
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
