CREATE OR REPLACE PACKAGE BODY nm3sdo_gdo
IS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_gdo.pkb-arc   3.6   Jul 04 2013 16:29:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3sdo_gdo.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:29:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:27:28  $
--       PVCS Version     : $Revision:   3.6  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) :='"$Revision:   3.6  $"';
  g_package_name CONSTANT VARCHAR2(30)   := 'nm3sdo_gdo';
  g_srid                  NUMBER ;
  b_srid_set              BOOLEAN := FALSE;
  g_gtype                 nm_theme_gtypes.ntg_gtype%TYPE;
  g_diminfo               mdsys.sdo_dim_array;
  g_tol                   NUMBER := 0.005;
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
--------------------------------------------------------------------------------
--
  PROCEDURE set_srid IS
  BEGIN
    IF NOT b_srid_set
    THEN
      nm3sdo.set_diminfo_and_srid( nm3sdo.get_nw_themes, g_diminfo, g_srid );
      b_srid_set := TRUE;
    END IF;
  END set_srid;
--
--------------------------------------------------------------------------------
--
  PROCEDURE set_gtype ( pi_gtype IN nm_theme_gtypes.ntg_gtype%TYPE )
  IS
  BEGIN
    IF pi_gtype IS NOT NULL
    THEN
      g_gtype := pi_gtype;
    END IF;
  END set_gtype;
--
--------------------------------------------------------------------------------
--
  FUNCTION validate_polygon ( pi_geometry IN mdsys.sdo_geometry )
  RETURN nm3type.max_varchar2
  IS
  --
  BEGIN
    RETURN sdo_geom.validate_geometry_with_context (pi_geometry
                                                 --, g_diminfo);
                                                   ,g_tol );
  --
  END validate_polygon;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_geom_from_xys (pi_tab_xys IN tab_xys)
  RETURN sdo_geometry
    -----------------------------------------------------------
    --  Return an SDO geometry for a collection of XY coords
    --
    -----------------------------------------------------------
  IS
    retval   mdsys.sdo_geometry;
    l_gtype  nm_theme_gtypes.ntg_gtype%TYPE;
    l_error  nm3type.max_varchar2;
  --
  BEGIN
  --
  -- Set the SRID global
    set_srid;
  --
    IF pi_tab_xys.COUNT = 0
    THEN
    -- No coordinates passed so bomb out
      RAISE_APPLICATION_ERROR (-20101,'List of XYs is empty!');
    END IF;
  --
    IF g_gtype IS NULL
    THEN
    --
    -- This is the path TMA takes - we'll always return a 2002 Line geometry
    --  
--        l_ord := wrap_geom ( pi_tab_xys => pi_tab_xys );
--    --
--        retval := mdsys.sdo_geometry( 2002,
--                                      g_srid,
--                                      NULL, 
--                                      mdsys.sdo_elem_info_array( 1, 2, 1), -- line
--                                      l_ord);
        retval := nm3sdo_geom.get_geom_from_xys ( p_tab_xys => pi_tab_xys
                                                , p_gtype   => 2002);
    ELSE
    --
    -- POINT SHAPE - 2001
    --
      IF g_gtype = 2001
      THEN
        IF pi_tab_xys.COUNT > 1 -- more than one pair of ordinates
        THEN
        --
          RAISE_APPLICATION_ERROR (-20102,'Too many ordinates passed for a 2001 Point');
        ELSE
        --
          retval := nm3sdo.get_2d_pt(pi_tab_xys(1).x_coord,
                                     pi_tab_xys(1).y_coord);
        END IF;
      --
      -- LINE SHAPE - 2002
      --
      ELSIF g_gtype = 2002
      THEN
        IF pi_tab_xys.COUNT < 2 -- less than two pairs of ordinates
        THEN
          RAISE_APPLICATION_ERROR (-20103,'Not enough ordinates passed for a 2002 Line');
        ELSE
        --
--          l_ord := wrap_geom ( pi_tab_xys => pi_tab_xys );
--        --
--          retval := mdsys.sdo_geometry( g_gtype,
--                                        g_srid,
--                                        NULL,
--                                        mdsys.sdo_elem_info_array( 1, 2, 1), -- line
--                                        l_ord);
            retval := nm3sdo_geom.get_geom_from_xys ( p_tab_xys => pi_tab_xys
                                                    , p_gtype   => 2002);
        -- remove any duplicate coords
          retval := sdo_util.remove_duplicate_vertices
                        ( retval
                        , 0.0001);
        END IF;
      --
      -- POLYGON - 2003
      --
      ELSIF g_gtype = 2003
      THEN
      --
        IF pi_tab_xys.COUNT < 3 -- less than 3 pairs of ordinates
        THEN
        --
          RAISE_APPLICATION_ERROR (-20104,'Not enough ordinates passed for a 2003 Polygon');
        ELSE
        --
--          l_ord := wrap_geom ( pi_tab_xys => pi_tab_xys 
--                             , pi_close   => TRUE ); -- make sure it closes the polygon
--        --
--          retval := mdsys.sdo_geometry( g_gtype,
--                                        g_srid,
--                                        NULL, 
--                                        mdsys.sdo_elem_info_array( 1, 1003, 1), -- external ring
--                                        l_ord);
        --
          retval := nm3sdo_geom.get_geom_from_xys ( p_tab_xys => pi_tab_xys
                                                  , p_gtype   => 2003);
          l_error := validate_polygon (retval);
        --
        -- Check for polygon orentation
        --  The exterior rings are oriented counterclockwise 
        -- and the interior rings are oriented clockwise.
        -- Ignore other errors for now
        --
          IF SUBSTR (l_error,0,5) = '13367'
          THEN
        --   raise_application_error(-20201,'Wrong orientation for exterior ring - must be anti-clockwise');
           --  retval := reverse_polygon (retval);
           retval :=  sdo_util.rectify_geometry
                       (sdo_util.remove_duplicate_vertices
                         ( retval
                          , 0.0001)
                       , 0.0001);
          ELSIF SUBSTR(l_error,0,5) = '13349'
          THEN
            raise_application_error(-20202,'Polygon boundary crosses itself');
          END IF;
        --
        END IF;
      --
      ELSE
        raise_application_error (-20199,'Geometry Type ['||g_gtype||'] is currently not supported');
      END IF;
    --
    END IF;
  --
    RETURN retval;
  --
  END get_geom_from_xys;
  --
--
--------------------------------------------------------------------------------
--
  FUNCTION get_shape_from_gdo ( pi_gdo_session_id IN gis_data_objects.gdo_session_id%TYPE
                              , pi_geometry_type  IN nm_theme_gtypes.ntg_gtype%TYPE DEFAULT 2002 )
    RETURN sdo_geometry
  IS
    l_ord              mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array(NULL);
    retval             sdo_geometry;
    l_rec_nth          nm_themes_all%ROWTYPE;
    l_tab_xys          tab_xys;
    ex_no_data         EXCEPTION;
  --
  BEGIN
  --
    g_gtype := NULL;
  --
    SELECT gdo_seq_no, gdo_x_val, gdo_y_val 
      BULK COLLECT INTO l_tab_xys
      FROM gis_data_objects
     WHERE gdo_session_id = pi_gdo_session_id
       AND (gdo_x_val IS NOT NULL AND gdo_y_val IS NOT NULL)
     ORDER BY gdo_seq_no DESC ;
  --
    IF l_tab_xys.COUNT = 0
    THEN
      RAISE ex_no_data;
    END IF;
  --
  -- Set the global gtype if it's been passed in
  --
    g_gtype := pi_geometry_type;
  --
  -- Return the geometry
  --
    RETURN get_geom_from_xys ( l_tab_xys );
  --
  EXCEPTION
    WHEN ex_no_data
    THEN
      RAISE_APPLICATION_ERROR (-20198,'No data or ordinates found for session id = '||pi_gdo_session_id);
  --
  END get_shape_from_gdo;
--
--------------------------------------------------------------------------------
--
procedure insert_gdo_from_theme_array ( pi_session_id in number,
                                                          pi_theme_name in varchar2,
                                                          pi_list in nm_theme_list ) is
begin 
  execute immediate 'insert into gis_data_objects (gdo_session_id, gdo_theme_name, gdo_pk_id )'||
                    ' select :session_id, :theme_name, a.ntd_pk_id '||
                    ' from table ( :list.ntl_theme_list ) a '||
                    ' group by a.ntd_pk_id ' using pi_session_id, pi_theme_name, pi_list;
end;                    

--
--------------------------------------------------------------------------------
--

procedure insert_gdo_from_buffer ( pi_session_id in number,
                                                     pi_theme_name in varchar2,
                                                     pi_geometry in mdsys.sdo_geometry,
                                                     pi_buffer in number,
                                                     pi_sub_select_session in integer ) is
l_list   nm_theme_list;
l_nth  nm_themes_all%rowtype;
begin
  l_nth := NM3GET.GET_NTH(pi_theme_name);
  l_list :=  nm3sdo.get_objects_in_buffer( p_nth_id =>  l_nth.nth_theme_id
                                                          , p_geometry => pi_geometry
                                                          , p_buffer => pi_buffer
                                                          , p_gdo_session_id => pi_sub_select_session  );
  
  insert_gdo_from_theme_array( pi_session_id,pi_theme_name, l_list ); 

  commit;

end;
       
          
BEGIN
-- instantiate global srid
  set_srid;
--
END nm3sdo_gdo;
/
