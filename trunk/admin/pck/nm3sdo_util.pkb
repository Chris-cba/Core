CREATE OR REPLACE PACKAGE BODY nm3sdo_util
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_util.pkb-arc   1.7   Jul 04 2013 16:32:56   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3sdo_util.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:32:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:31:16  $
--       Version          : $Revision:   1.7  $
--       Based on SCCS version :
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   1.7  $';

  g_package_name CONSTANT varchar2(30) := 'nm3sdo_util';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE reshape_route (
   gis_session_id IN gis_data_objects.gdo_session_id%TYPE)
IS
   l_ne   NUMBER;
BEGIN
   SELECT ne_id
     INTO l_ne
     FROM nm_elements_all, gis_data_objects
    WHERE ne_id = gdo_pk_id AND gdo_session_id = gis_session_id;

   BEGIN
      NM3SDM.RESHAPE_ROUTE (l_ne, To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'), 'Y');
   END;
END reshape_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE reverse_datum (
   gis_session_id IN gis_data_objects.gdo_session_id%TYPE)
IS
   l_ne       nm_elements.ne_id%TYPE;
   l_length   NUMBER;
   l_shape    MDSYS.sdo_geometry;
   feature_table NM_THEMES_ALL.NTH_FEATURE_TABLE%type;
   pk_column  NM_THEMES_ALL.NTH_FEATURE_PK_COLUMN%type;
   theme_id   nm_themes_all.nth_theme_id%type;
   l_shape_column NM_THEMES_ALL.NTH_FEATURE_SHAPE_COLUMN%type;

   CURSOR c1 is
   select distinct nth_feature_table, nth_feature_pk_column, nth_theme_id, nth_feature_shape_column
    from gis_data_objects, nm_themes_all, nm_nw_themes, nm_linear_types, nm_elements
    where gdo_session_id = gis_session_id
    and nlt_g_i_d = 'D'
    and nlt_id = nnth_nlt_id
    and nnth_nth_theme_id = nth_theme_id
    and nlt_nt_type = ne_nt_type
    and gdo_pk_id   = ne_id
    and nth_base_table_theme is null;

BEGIN

    OPEN c1;
    FETCH c1 INTO feature_table, pk_column, theme_id, l_shape_column;
    CLOSE c1;

EXECUTE IMMEDIATE
     'SELECT e.ne_id, e.ne_length, s.'||l_shape_column ||' '||
     'FROM gis_data_objects, nm_elements e, ' || feature_table || ' s ' ||
     'WHERE gdo_session_id = '|| gis_session_id  ||
     'AND e.ne_id = gdo_pk_id ' ||
     'AND s.'||pk_column||' = e.ne_id ' INTO l_ne, l_length, l_shape;


EXECUTE IMMEDIATE
    'UPDATE ' || feature_table || ' ' ||
    'SET '||l_shape_column||' = NM3SDO.REVERSE_GEOMETRY (:l_shape, 0) ' ||
    'WHERE ' || pk_column || ' = :l_ne ' using l_shape, l_ne;

   NM3SDO.CHANGE_AFFECTED_SHAPES (theme_id, l_ne);
END reverse_datum;
--
-----------------------------------------------------------------------------
--
PROCEDURE datum_start_end (gis_session_id IN gis_data_objects.gdo_session_id%TYPE)
IS
   l_ne          nm3type.tab_number;
   l_start_np_id NUMBER;
   l_end_np_id   NUMBER;
   e_no_point    EXCEPTION;
   --
  CURSOR coords_cur (p_gis_sess_id gis_data_objects.gdo_session_id%TYPE) IS
  SELECT a.ne_id
       , a.st_geom.sdo_point.x st_x
       , a.st_geom.sdo_point.y st_y
       , a.end_geom.sdo_point.x end_x
       , a.end_geom.sdo_point.y end_y
       , ne.ne_no_start
       , ne.ne_no_end
       , ls.npl_id start_npl_id
       , le.npl_id end_npl_id
       , s.no_np_id start_np_id
       , e.no_np_id end_np_id
   FROM 
  (
  SELECT ne_id
       , nm3sdo.get_2d_pt(sdo_lrs.geom_segment_start_pt(shape)) st_geom 
       , nm3sdo.get_2d_pt(sdo_lrs.geom_segment_end_pt(shape)) end_geom 
  FROM (SELECT gdo_pk_id ne_id
             , nm3sdo.get_layer_element_geometry(gdo_pk_id) shape 
          FROM gis_data_objects
         WHERE gdo_session_id = p_gis_sess_id)
  ) a
  , nm_elements ne
  , nm_nodes s
  , nm_point_locations ls
  , nm_nodes e
  , nm_point_locations le
  WHERE ne.ne_id = a.ne_id
  and s.no_node_id = ne.ne_no_start
  and s.no_np_id = ls.npl_id(+)
  and e.no_node_id = ne.ne_no_end
  and e.no_np_id = le.npl_id(+);
--  
BEGIN
--
FOR coords_rec in coords_cur(p_gis_sess_id => gis_session_id) LOOP
    --
    IF coords_rec.st_x IS NOT NULL 
    AND coords_rec.st_y IS NOT NULL
    THEN
      --
      UPDATE NM_POINTS
      SET np_grid_east  = coords_rec.st_x
        , np_grid_north = coords_rec.st_y
      WHERE np_id = coords_rec.start_np_id;
      --
     -- IF SQL%NOTFOUND THEN
     --   RAISE e_no_point;
     -- END IF;
      --
      IF coords_rec.start_npl_id IS NULL THEN
        INSERT INTO nm_point_locations (npl_id, npl_location)
        VALUES (coords_rec.start_np_id, nm3sdo.get_2d_pt(coords_rec.st_x, coords_rec.st_y));
      END IF;
    --
    END IF;
    --
    IF coords_rec.end_x IS NOT NULL 
    AND coords_rec.end_y IS NOT NULL
    THEN
    --
      UPDATE nm_points
      SET    np_grid_east  = coords_rec.end_x
           , np_grid_north = coords_rec.end_y
      WHERE  np_id = coords_rec.end_np_id;
    --
     -- IF SQL%NOTFOUND THEN
     --   RAISE e_no_point;
     -- END IF;
      
      IF coords_rec.end_npl_id IS NULL THEN
        INSERT INTO nm_point_locations (npl_id, npl_location)
        VALUES (coords_rec.END_NP_ID, NM3SDO.GET_2D_PT(coords_rec.end_x, coords_rec.end_y));
      END IF;
    --
    END IF;
    --
END LOOP;
--
  COMMIT;
--
EXCEPTION
WHEN e_no_point
THEN
  raise_application_error (-20001, 'Could not find point to update.');
END datum_start_end;
--
-----------------------------------------------------------------------------
--
END nm3sdo_util;
/

