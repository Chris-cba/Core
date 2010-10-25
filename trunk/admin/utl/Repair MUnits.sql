--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/Repair MUnits.sql-arc   1.1   Oct 25 2010 08:40:06   ade.edwards  $
--       Module Name      : $Workfile:   Repair MUnits.sql  $
--       Date into PVCS   : $Date:   Oct 25 2010 08:40:06  $
--       Date fetched Out : $Modtime:   Oct 25 2010 08:38:46  $
--       PVCS Version     : $Revision:   1.1  $
--
--------------------------------------------------------------------------------
--

SET SERVEROUTPUT ON
SET TIMING ON
DECLARE
--
  l_total_records  NUMBER := 0;
--
  CURSOR get_srids IS
  WITH all_data AS (
    SELECT UNIQUE a.srid 
         , munits old_value
         , nt_length_unit
      FROM sde.spatial_references a
         , sde.layers b
         , nm_themes_all
         , v_nm_net_themes_all
         , nm_types
     WHERE a.srid = b.srid
       AND table_name = nth_feature_table
       AND spatial_column = nth_feature_shape_column
       AND vnnt_nth_theme_id = nth_theme_id
       AND vnnt_lr_type IN ('D','G')
       AND nt_type = vnnt_nt_type
     )
      SELECT srid
           , old_value
           , POWER ( 10
                   , nm3unit.get_rounding(nm3unit.get_tol_from_unit_mask(nt_length_unit))
                   ) new_value
       FROM all_data
      WHERE old_value != POWER ( 10
                      , nm3unit.get_rounding(nm3unit.get_tol_from_unit_mask(nt_length_unit)));
--
BEGIN
  dbms_output.enable(1000000);
  dbms_output.put_line('================================================================================'); 
  dbms_output.put_line ('# Correcting Spatial Reference data'); 
  dbms_output.put_line('================================================================================'); 
  FOR a IN get_srids LOOP
    dbms_output.put_line ('## > Updating Spatial Reference '||a.srid||' : setting MUnits from '||a.old_value||' to '||a.new_value); 
    UPDATE sde.spatial_references
       SET munits = a.new_value
     WHERE srid = a.srid;
    l_total_records := l_total_records + 1;
  END LOOP;
  dbms_output.put_line('================================================================================'); 
  dbms_output.put_line ('# Correcting Spatial Reference data - '||l_total_records||' rows updated');
  dbms_output.put_line ('# Correcting Spatial Reference data finished successfully'||CASE WHEN l_total_records > 0 THEN ' : Please issue a COMMIT' ELSE NULL END);
  dbms_output.put_line('================================================================================'); 
END;
/
SET SERVEROUTPUT OFF
SET TIMING OFF