--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/Repair MUnits.sql-arc   1.0   Sep 02 2010 13:35:44   Ade.Edwards  $
--       Module Name      : $Workfile:   Repair MUnits.sql  $
--       Date into PVCS   : $Date:   Sep 02 2010 13:35:44  $
--       Date fetched Out : $Modtime:   Sep 02 2010 12:14:04  $
--       PVCS Version     : $Revision:   1.0  $
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
    SELECT UNIQUE a.srid 
         , POWER ( 10
                 , nm3unit.get_rounding(nm3unit.get_tol_from_unit_mask(nt_length_unit))
                 ) new_value
         , munits old_value
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
       AND munits != POWER ( 10
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
