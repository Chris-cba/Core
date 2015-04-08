--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_geom_on_route.vw-arc   1.0   Apr 08 2015 10:24:54   Chris.Baugh  $
--       Module Name      : $Workfile:   v_geom_on_route.vw  $
--       Date into PVCS   : $Date:   Apr 08 2015 10:24:54  $
--       Date fetched Out : $Modtime:   Apr 07 2015 09:14:46  $
--       Version          : $Revision:   1.0  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

DROP MATERIALIZED VIEW V_GEOM_ON_ROUTE
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
/

COMMENT ON MATERIALIZED VIEW V_GEOM_ON_ROUTE IS 'Snapshot of assets on route with aggregated geometry'
/

CREATE INDEX VGOR_OBJ_IDX ON V_GEOM_ON_ROUTE
(OBJ_TYPE, OBJ_ID)
/

INSERT INTO user_sdo_geom_metadata
   SELECT 'V_GEOM_ON_ROUTE',
          'GEOLOC',
          diminfo,
          srid
     FROM user_sdo_geom_metadata
    WHERE table_name = 'NM_NSG_ESU_SHAPES_TABLE'
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
