--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/install/4800_spatial_indexes.sql-arc   1.1   Jul 18 2019 10:35:38   Chris.Baugh  $
--       Module Name      : $Workfile:   4800_spatial_indexes.sql  $
--       Date into PVCS   : $Date:   Jul 18 2019 10:35:38  $
--       Date fetched Out : $Modtime:   Jul 18 2019 10:34:34  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe
--
--   Interim DDL script to clear out metadata
--
-----------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT

DECLARE
  --
  CURSOR C1 IS
    SELECT 1
      FROM TABLE (NM3SDO.GET_NW_THEMES ().nta_theme_array)  t,
           nm_themes_all,
           user_sdo_geom_metadata
     WHERE nth_feature_table = table_name
       AND nth_feature_shape_column = column_name
       AND nth_theme_id = nthe_id
       AND ROWNUM = 1;
    --
    lv_dummy       PLS_INTEGER;
    lv_row_found   BOOLEAN;
    --
BEGIN
  --
  OPEN C1;
  FETCH C1 INTO lv_dummy;
  lv_row_found := C1%FOUND;
  CLOSE C1;
  --
  IF NOT lv_row_found 
  THEN
    --
    raise_application_error( -20001, 'No Network themes configured' );
  END IF;
  --
  
  --
END;
/
--
-- Create Spatial Indexes
--
INSERT INTO user_sdo_geom_metadata (table_name,
                                    column_name,
                                    diminfo,
                                    srid)
    SELECT 'NM_LOCATION_GEOMETRY',
           'NLG_GEOMETRY',
           SDO_LRS.convert_to_std_dim_array (nm3sdo.coalesce_nw_diminfo),
           srid
      FROM TABLE (NM3SDO.GET_NW_THEMES ().nta_theme_array)  t,
           nm_themes_all,
           user_sdo_geom_metadata
     WHERE     nth_feature_table = table_name
           AND nth_feature_shape_column = column_name
           AND nth_theme_id = nthe_id
           AND ROWNUM = 1
/

PROMPT Creating Index NLG_SPIDX on NM_LOCATION_GEOMETRY

CREATE INDEX NLG_SPIDX
    ON NM_LOCATION_GEOMETRY (NLG_GEOMETRY)
    INDEXTYPE IS MDSYS.SPATIAL_INDEX
/

INSERT INTO user_sdo_geom_metadata (table_name,
                                    column_name,
                                    diminfo,
                                    srid)
    SELECT 'NM_ASSET_GEOMETRY_ALL',
           'NAG_GEOMETRY',
           SDO_LRS.convert_to_std_dim_array (nm3sdo.coalesce_nw_diminfo),
           srid
      FROM TABLE (NM3SDO.GET_NW_THEMES ().nta_theme_array)  t,
           nm_themes_all,
           user_sdo_geom_metadata
     WHERE     nth_feature_table = table_name
           AND nth_feature_shape_column = column_name
           AND nth_theme_id = nthe_id
           AND ROWNUM = 1
/

PROMPT Creating Index NAG_SPIDX on NM_ASSET_GEOMETRY_ALL

CREATE INDEX NAG_SPIDX ON NM_ASSET_GEOMETRY_ALL
(NAG_GEOMETRY)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
/

Prompt Spatial metadata

declare
  duplicate_SDO_data exception;
  pragma exception_init( duplicate_SDO_data, -13223); -- duplicate entry for NM_INV_GEOMETRY_ALL.SHAPE in SDO_GEOM_METADATA
begin  
   insert into user_sdo_geom_metadata
   select 'NM_INV_GEOMETRY_ALL', 'SHAPE', diminfo, srid
   from user_sdo_geom_metadata where table_name = 'NM_POINT_LOCATIONS';
exception
   when duplicate_SDO_data 
     then NULL;
end;
/

Prompt Spatial Index

create index nig_spidx on nm_inv_geometry_all
(shape) indextype is mdsys.spatial_index
/
