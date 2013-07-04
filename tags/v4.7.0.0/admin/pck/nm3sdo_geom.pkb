CREATE OR REPLACE PACKAGE BODY nm3sdo_geom 
AS
--
--------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_geom.pkb-arc   1.8   Jul 04 2013 16:29:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3sdo_geom.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:29:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:28:48  $
--       PVCS Version     : $Revision:   1.8  $
--       Based on
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
  g_body_sccsid    CONSTANT VARCHAR2(30) :='"$Revision:   1.8  $"';
  g_tab_xys                 nm3sdo_gdo.tab_xys;
 -- g_tab_nm_coords           nm_coords_array := NEW nm_coords_array();
--
--------------------------------------------------------------------------------
--
  CURSOR get_ords_from_gdo ( c_gdo_id in number ) 
  IS
    SELECT CAST (COLLECT (gdo_x_val) AS mdsys.sdo_ordinate_array ) 
      FROM ( SELECT gdo_x_val 
               FROM ( WITH gdo AS 
                      ( SELECT a.gdo_x_val
                             , a.gdo_y_val
                             , a.gdo_seq_no
                          FROM gis_data_objects a
                         WHERE gdo_session_id = c_gdo_id 
                           AND gdo_x_val IS NOT NULL
                           AND gdo_y_val IS NOT NULL)
                     SELECT 1 dim, gdo.gdo_x_val, gdo_seq_no 
                       FROM gdo
                      UNION ALL
                     SELECT 2 dim, gdo.gdo_y_val, gdo_seq_no 
                       FROM gdo )
                   ORDER BY gdo_seq_no, dim);
--
--------------------------------------------------------------------------------
--
function  get_tol_from_gdo(p_session_id in gis_data_objects.gdo_session_id%type) return number;

  FUNCTION get_version RETURN VARCHAR2 
  IS
  BEGIN
    RETURN g_sccsid;
  END get_version;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN VARCHAR2 
  IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_nw_srids RETURN NUMBER;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_feature_type ( p_geom IN mdsys.sdo_geometry ) 
    RETURN NUMBER 
  IS
    l_dim number;
    l_lrs number;
  BEGIN
  --  l_dim := p_geom.get_dims;
  --  l_lrs := p_geom.get_lrs_dim;
    RETURN p_geom.get_gtype; 
  END get_feature_type;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_area ( p_geom      IN mdsys.sdo_geometry
                    , p_tolerance IN NUMBER DEFAULT g_tolerance
                    , p_unit      IN nm_units.un_unit_id%TYPE DEFAULT 1 ) 
    RETURN NUMBER 
  IS
    l_valid VARCHAR2(10);
    unitstr VARCHAR2(100);
  BEGIN
  -- Validate geometry
    l_valid := sdo_geom.validate_geometry_with_context( p_geom, p_tolerance );
  --
    IF l_valid = 'TRUE' 
    THEN
      IF get_feature_type( p_geom ) = 3 
      THEN
      -- Task 0108550
      -- Make sure the data is returned in Meters for Mapviewer consistency
      -- if a SRID is set
        IF p_geom.sdo_srid is NULL 
         THEN 
           unitstr := NULL;
        ELSE
           unitstr := 'UNIT=SQ_METER';
        END IF;
      --
        RETURN nm3unit.get_formatted_value(sdo_geom.sdo_area( p_geom, p_tolerance, unitstr ), 1 );
      --
      ELSE
      --
        raise_application_error( -20001, 'Geometry is not a polygon' );
      --
      END IF;
    ELSE
      raise_application_error( -20002, 'Geometry is invalid' );
    END IF;
  --
    RETURN 0;
  --
  EXCEPTION
    WHEN OTHERS 
    THEN 
      RETURN -1;  
  END get_area;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_length ( p_geom      IN mdsys.sdo_geometry
                      , p_tolerance IN NUMBER DEFAULT g_tolerance
                      , p_unit      IN nm_units.un_unit_id%TYPE DEFAULT 1 ) 
    RETURN NUMBER 
  IS
    l_valid VARCHAR2(10);
    l_type  NUMBER;
    unitstr VARCHAR2(100);
  BEGIN
  -- Validate geometry
    l_valid := sdo_geom.validate_geometry_with_context( p_geom, p_tolerance );
  --
    IF l_valid = 'TRUE' 
    THEN
    --
      l_type := get_feature_type( p_geom );
    --
    -- Task 0108550
    -- Make sure the data is returned in Meters for Mapviewer consistency
    -- if a SRID is set
      IF p_geom.sdo_srid is NULL 
      THEN 
        unitstr := NULL;
      ELSE
        unitstr := 'UNIT=METER';
      END IF;
    --
      IF l_type = 3 
      THEN
      --
        RETURN nm3unit.get_formatted_value(sdo_geom.sdo_length(sdo_util.polygontoline(p_geom), p_tolerance, unitstr ), 1);
      -- 
      ELSIF l_type = 2 
      THEN
      --
        RETURN nm3unit.get_formatted_value(sdo_geom.sdo_length(p_geom, p_tolerance, unitstr ), 1);
      --
      ELSE
        raise_application_error( -20003, 'Geometry is not of an appropriate type' );
      END IF;
  --
    ELSE
  --
      raise_application_error( -20002, 'Geometry is invalid' );
    END IF;
  --
    RETURN 0;
  --
  EXCEPTION
    WHEN OTHERS 
    THEN 
      RETURN -1;    
  END get_length;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_geom_from_xys ( p_tab_xys IN nm3sdo_gdo.tab_xys
                             , p_gtype   IN VARCHAR2 ) 
    RETURN mdsys.sdo_geometry
  IS
    retval mdsys.sdo_geometry;
  BEGIN
    g_tab_xys.DELETE;
    --g_tab_nm_coords.DELETE;
    g_tab_xys := p_tab_xys;
    --nm_debug.debug_on;
    RETURN get_geom_from_gdo( p_gdo_session_id => -999999
                            , p_gtype          => p_gtype );
  END get_geom_from_xys;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_ords_from_xys RETURN mdsys.sdo_ordinate_array
  IS
  --
    retval mdsys.sdo_ordinate_array := NEW mdsys.sdo_ordinate_array();
  --
  BEGIN
  --
    retval.EXTEND;
  --
    FOR i IN 1..g_tab_xys.COUNT 
    LOOP
      retval(retval.COUNT) := g_tab_xys(i).x_coord;
      retval.EXTEND;
      retval(retval.COUNT) := g_tab_xys(i).y_coord;
      IF i != g_tab_xys.COUNT
      THEN
        retval.EXTEND;
      END IF;
    END LOOP;
  --
    RETURN retval; 
  --
  END get_ords_from_xys;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_geom_from_gdo( p_gdo_session_id IN NUMBER
                            , p_gtype          IN NUMBER )
    RETURN mdsys.sdo_geometry 
  IS
  -- 
    l_ords        mdsys.sdo_ordinate_array;  
    l_elem        mdsys.sdo_elem_info_array;
    l_x           NUMBER;
    l_y           NUMBER;
    l_ord_count   NUMBER;
  --
    l_tol  NUMBER;
  --
    ex_no_coords               EXCEPTION;
    ex_invalid_gtype_for_gdo   EXCEPTION;
    ex_unsupported_gtype       EXCEPTION;
  --
  BEGIN
  --
    IF p_gdo_session_id != -999999
    THEN
      OPEN  get_ords_from_gdo (p_gdo_session_id);
      FETCH get_ords_from_gdo INTO l_ords;
      CLOSE get_ords_from_gdo;
    ELSE
      l_ords := get_ords_from_xys;
    END IF;
  --
    l_ord_count := l_ords.COUNT;
  --
    IF l_ord_count = 0
    THEN RAISE ex_no_coords;
    END IF;
  --
  /*
  ||  POINT Geometry
  */
    IF p_gtype = 2001
    THEN
      IF l_ord_count != 2
      THEN
        RAISE ex_invalid_gtype_for_gdo;
      ELSE
        l_x := l_ords(1);
        l_y := l_ords(2);
      --
      -- This causes Oracle to disconnect!
      --  RETURN nm3sdo.get_2d_pt(l_ords(1),l_ords(2));
        RETURN nm3sdo.get_2d_pt(l_x,l_y);
      --
      END IF;
  --
    ELSE
    --
    /*
    ||  LINE Geometry
    */
      IF p_gtype = 2002 
      THEN
    --
        IF l_ord_count < 4
        THEN
          RAISE ex_invalid_gtype_for_gdo;
        ELSE
          l_elem := mdsys.sdo_elem_info_array( 1, 2, 1 );
        END IF;
    --
    /*
    ||  POLYGON Geometry
    */
      ELSIF p_gtype = 2003 
      THEN
        IF l_ord_count < 6
        THEN
          RAISE ex_invalid_gtype_for_gdo;
        ELSE
          l_elem := mdsys.sdo_elem_info_array( 1, 1003, 1 );
          IF l_ords(l_ords.LAST) != l_ords(2)
          AND l_ords(l_ords.LAST-1) != l_ords(1)
          THEN
            l_ords.EXTEND(2);
            l_ords(l_ords.LAST-1) := l_ords(1);
            l_ords(l_ords.LAST)   := l_ords(2);
          END IF;
        END IF;
      ELSE
        RAISE ex_unsupported_gtype;
      END IF;
    --
     l_tol := get_tol_from_gdo( p_gdo_session_id );
    --
      RETURN sdo_util.rectify_geometry
             ( sdo_util.remove_duplicate_vertices
                ( mdsys.sdo_geometry( p_gtype
                                    , g_srid
                                    , NULL
                                    , l_elem
                                    , l_ords )
                , l_tol)
             , l_tol);

    END IF;  
  --
  EXCEPTION
    WHEN ex_invalid_gtype_for_gdo
    THEN
      RAISE_APPLICATION_ERROR (-20101
                              ,'Invalid feature type ['||p_gtype||'] for '||
                               'the number of ordinates stored ['||l_ord_count||
                               '] in GDO ['||p_gdo_session_id||']');
    WHEN ex_unsupported_gtype
    THEN
      RAISE_APPLICATION_ERROR (-20102
                              ,'Geometry is not of an appropriate type ['||p_gtype||']' );
    WHEN ex_no_coords
    THEN
      RAISE_APPLICATION_ERROR (-20103
                              ,'No coordinates found for GDO ['||p_gdo_session_id||']' );
  END get_geom_from_gdo;  
--
--------------------------------------------------------------------------------
--
  FUNCTION get_geom_from_gdo ( p_gdo_session_id IN NUMBER
                             , p_feature_type   IN VARCHAR2 ) 
    RETURN mdsys.sdo_geometry 
  IS
  BEGIN
    IF p_feature_type = 'LINE' 
    THEN
      RETURN get_geom_from_gdo(p_gdo_session_id, 2002);
    ELSIF p_feature_type = 'POLYGON' 
    THEN
      RETURN get_geom_from_gdo(p_gdo_session_id, 2003);
    ELSE
      raise_application_error( -20003, 'Geometry is not of an appropriate type' );
    END IF;
  END get_geom_from_gdo;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_nw_srids 
    RETURN NUMBER 
  IS
    CURSOR c1 
    IS
      SELECT sdo_srid
        FROM mdsys.sdo_geom_metadata_table
           , nm_nw_themes
           , nm_linear_types
           , nm_themes_all
       WHERE nnth_nlt_id = nlt_id
         AND nlt_g_i_d   = 'D'
         AND nnth_nth_theme_id = nth_theme_id
         AND nth_feature_table = sdo_table_name
         AND nth_feature_shape_column = sdo_column_name
         AND sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER');
  --
    l_srid NUMBER;
  --
  BEGIN
  --
    OPEN c1;
    FETCH c1 INTO l_srid;
    CLOSE c1;
  --
    RETURN l_srid;
  --
  END get_nw_srids;
--
--------------------------------------------------------------------------------
--
function get_tol_from_gdo( p_session_id in gis_data_objects.gdo_session_id%type ) return number is
 cursor c1 ( c_session_id in gis_data_objects.gdo_session_id%type ) is
   select a.diminfo
    from user_sdo_geom_metadata a, gis_data_objects, nm_themes_all
    where gdo_session_id = c_session_id
    and gdo_theme_name = nth_theme_name
    and table_name = nth_feature_table;
diminfo mdsys.sdo_dim_array;    
retval number;    
 begin
  open c1( p_session_id );
  fetch c1 into diminfo;
  close c1;
  retval := diminfo(1).sdo_tolerance ;
  
  if retval is null then
    retval := g_tolerance;
  end if;
  return retval;
exception
 when no_data_found then
   return g_tolerance;
 when others then    
   return g_tolerance;
 end;
--------------------------------------------------------------------------------
--
 
BEGIN
  g_srid := get_nw_srids;
END nm3sdo_geom;
/
