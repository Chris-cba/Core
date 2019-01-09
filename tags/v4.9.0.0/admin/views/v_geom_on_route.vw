-- 
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_geom_on_route.vw-arc   1.9   Jan 09 2019 09:21:08   Chris.Baugh  $
--       Module Name      : $Workfile:   v_geom_on_route.vw  $
--       Date into PVCS   : $Date:   Jan 09 2019 09:21:08  $
--       Date fetched Out : $Modtime:   Jan 09 2019 09:20:28  $
--       Version          : $Revision:   1.9  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

DECLARE
  --
  route_table_name        VARCHAR2(30);
  lv_ne_nt_type           nm_elements.ne_nt_type%TYPE;
  lv_ne_gty_group_type    nm_elements.ne_gty_group_type%TYPE;
  lv_str                  VARCHAR2(3000);
BEGIN
  --
  BEGIN
    --
    SELECT ne_nt_type
          ,ne_gty_group_type
      INTO lv_ne_nt_type,
           lv_ne_gty_group_type
      FROM nm_elements, (SELECT rse_he_id FROM road_sections WHERE ROWNUM = 1 )
     WHERE ne_id = rse_he_id;
	 --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
	WHEN OTHERS THEN
	  RAISE;
  END;
  --
  IF lv_ne_gty_group_type IS NOT NULL
  THEN
    --
    -- Create Materialized view
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
    --
    route_table_name := 'NM_NLT_'||lv_ne_nt_type||'_'||lv_ne_gty_group_type||'_SDO';
    --
    lv_str := 'CREATE MATERIALIZED VIEW V_GEOM_ON_ROUTE '||
              '  ( '||
              '  REFNT, '||
              '  OBJ_ID, '||
              '  OBJ_TYPE, '||
              '  NM_BEGIN_MP, '||
              '  NM_END_MP, '||
              '  GEOLOC '||
              '  ) '||
              '  BUILD IMMEDIATE  '||
              '  REFRESH FORCE '||
              '          ON DEMAND '||
              '          WITH PRIMARY KEY  '||
              'AS  '||
              'SELECT * '||
              '  FROM (SELECT refnt,  '||
              '               obj_id, '||
              '               obj_type, '||
              '               nm_begin_mp, '||
              '               nm_end_mp, '||
              '              SDO_LRS.clip_geom_segment (geoloc, '||
              '                                         nm_begin_mp, '||
              '                                         nm_end_mp, '||
              '                                         0.05) '||
              '                 geoloc '||
              '         FROM v_obj_on_route, '||route_table_name||
              '        WHERE     refnt = ne_id '||
              '              AND end_date IS NULL  '||
              '              AND obj_type IN (SELECT nit_inv_type '||
              '                                 FROM nm_themes_all, '||
              '                                      nm_inv_themes, '||
              '                                      nm_inv_types '||
              '                                WHERE     nith_nth_theme_id = nth_theme_id '||
              '                                      AND nith_nit_id = nit_inv_type '||
             '                                       AND obj_type = nit_inv_type '||
             '                                       AND nth_base_table_theme IS NULL '||
             '                                       AND nth_dependency = '||''''||'D'||''''||
             '                                       AND nth_feature_table NOT LIKE '||''''||'V_MCP_%'||''''||
             '                                       AND nit_table_name IS NULL)) '||
             ' WHERE geoloc IS NOT NULL ';
             
   EXECUTE IMMEDIATE lv_str;
   --
   lv_str := 'COMMENT ON MATERIALIZED VIEW V_GEOM_ON_ROUTE IS ''Snapshot of assets on route with aggregated geometry''';
   --
   EXECUTE IMMEDIATE lv_str;
   --
   lv_str := 'CREATE INDEX VGOR_OBJ_IDX ON V_GEOM_ON_ROUTE '||
             '(OBJ_TYPE, OBJ_ID)';
   --
   EXECUTE IMMEDIATE lv_str;
   --
   DECLARE
     l_diminfo mdsys.sdo_dim_array;
     l_srid    integer;
     data_exists  EXCEPTION;
     pragma exception_init(data_exists,-13223);
   BEGIN
     nm3sdo.set_diminfo_and_srid(nm3sdo.get_nw_themes, l_diminfo, l_srid);
     --
     INSERT into USER_SDO_GEOM_METADATA
       ( table_name, column_name, diminfo, srid )
       values ('V_GEOM_ON_ROUTE', 'GEOLOC', l_diminfo, l_srid );
   EXCEPTION
     WHEN data_exists THEN
       NULL;
     WHEN OTHERS THEN
       RAISE;
   END;
   --
   lv_str := 'CREATE INDEX VGOR_SPIDX ON V_GEOM_ON_ROUTE '||
             '(GEOLOC) indextype is mdsys.spatial_index';
   --
   EXECUTE IMMEDIATE lv_str;
   --
   lv_str := 'CREATE INDEX VGOR_NE_IDX ON V_GEOM_ON_ROUTE(REFNT)';
   --
   EXECUTE IMMEDIATE lv_str;

 END IF;
 --
END;
/
