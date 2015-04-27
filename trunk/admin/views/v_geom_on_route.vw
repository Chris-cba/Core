--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_geom_on_route.vw-arc   1.4   Apr 27 2015 12:02:38   Chris.Baugh  $
--       Module Name      : $Workfile:   v_geom_on_route.vw  $
--       Date into PVCS   : $Date:   Apr 27 2015 12:02:38  $
--       Date fetched Out : $Modtime:   Apr 27 2015 12:00:26  $
--       Version          : $Revision:   1.4  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

DECLARE
  view_does_not_exist  EXCEPTION;
  pragma exception_init(view_does_not_exist,-12003);

BEGIN
  EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW V_GEOM_ON_ROUTE';
EXCEPTION
  WHEN view_does_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/

CREATE MATERIALIZED VIEW V_GEOM_ON_ROUTE
   (
   REFNT,
   OBJ_ID,
   OBJ_TYPE,
   NM_BEGIN_MP,
   NM_END_MP,
   GEOLOC
   )
   BUILD IMMEDIATE
   REFRESH FORCE
           ON DEMAND
           WITH PRIMARY KEY
AS
SELECT *
  FROM (SELECT refnt,
               obj_id,
               obj_type,
               nm_begin_mp,
               nm_end_mp,
               SDO_LRS.clip_geom_segment (geoloc,
                                          nm_begin_mp,
                                          nm_end_mp,
                                          0.05)
                  geoloc
          FROM v_obj_on_route, nm_nlt_sect_sect_sdo
         WHERE     refnt = ne_id
               AND end_date IS NULL
               AND obj_type IN (SELECT nit_inv_type
                                  FROM nm_themes_all,
                                       nm_inv_themes,
                                       nm_inv_types
                                 WHERE     nith_nth_theme_id = nth_theme_id
                                       AND nith_nit_id = nit_inv_type
                                       AND obj_type = nit_inv_type
                                       AND nth_base_table_theme IS NULL
                                       AND nth_dependency = 'D'
                                       AND nth_feature_table NOT LIKE
                                              'V_MCP_%'
                                       AND nit_table_name IS NULL))
 WHERE geoloc IS NOT NULL;


COMMENT ON MATERIALIZED VIEW V_GEOM_ON_ROUTE IS 'Snapshot of assets on route with aggregated geometry'
/

CREATE INDEX VGOR_OBJ_IDX ON V_GEOM_ON_ROUTE
(OBJ_TYPE, OBJ_ID)
/

DECLARE
  data_exists  EXCEPTION;
  pragma exception_init(data_exists,-13223);

BEGIN
  EXECUTE IMMEDIATE 'INSERT INTO user_sdo_geom_metadata '||
                    'SELECT ''V_GEOM_ON_ROUTE'','||
                            '''GEOLOC'','||
                            'diminfo,'||
                            'srid '||
                      'FROM user_sdo_geom_metadata '||
                     'WHERE table_name = ''NM_NSG_ESU_SHAPES_TABLE''';
EXCEPTION
  WHEN data_exists THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/

CREATE INDEX VGOR_SPIDX ON V_GEOM_ON_ROUTE
(GEOLOC) indextype is mdsys.spatial_index
/

CREATE INDEX VGOR_NE_IDX ON V_GEOM_ON_ROUTE
(REFNT)
/

BEGIN
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('V_GEOM_ON_ROUTE');
END;
/