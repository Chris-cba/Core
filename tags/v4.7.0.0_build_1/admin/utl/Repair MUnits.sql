--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/Repair MUnits.sql-arc   1.3   Jul 04 2013 10:30:12   James.Wadsworth  $
--       Module Name      : $Workfile:   Repair MUnits.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:26:30  $
--       PVCS Version     : $Revision:   1.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
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
       AND nt_length_unit IS NOT NULL
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
