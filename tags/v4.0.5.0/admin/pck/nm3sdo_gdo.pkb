CREATE OR REPLACE PACKAGE BODY nm3sdo_gdo
IS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_gdo.pkb-arc   3.0   Jan 29 2008 11:41:38   smarshall  $
--       Module Name      : $Workfile:   nm3sdo_gdo.pkb  $
--       Date into PVCS   : $Date:   Jan 29 2008 11:41:38  $
--       Date fetched Out : $Modtime:   Jan 29 2008 11:38:06  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   3.0  $"';
  g_package_name CONSTANT varchar2(30)   := 'nm3sdo_gdo';

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
  FUNCTION get_geom_from_xys (pi_tab_xys IN tab_xys)
  RETURN sdo_geometry
    -----------------------------------------------------------
    --  Return an SDO geometry for a collection of XY coords
    --
    --  Always return as a 2002 simple line geometry
    -----------------------------------------------------------
  IS
    l_ord    sdo_ordinate_array := sdo_ordinate_array(NULL);
    retval sdo_geometry;
  BEGIN
  --
    IF pi_tab_xys.COUNT = 0
    THEN
      RAISE_APPLICATION_ERROR (-20101,'List of XYs is empty!');
    END IF;
  --
    FOR i IN 1..pi_tab_xys.COUNT LOOP

      IF i > 1 THEN

         l_ord.EXTEND;
         l_ord(l_ord.LAST) := pi_tab_xys(i).x_coord;

      ELSE

         l_ord(l_ord.LAST) := pi_tab_xys(i).x_coord;

      END IF;

      l_ord.EXTEND;
      l_ord(l_ord.LAST) := pi_tab_xys(i).y_coord;

    END LOOP;
  --
    RETURN mdsys.sdo_geometry( 2002,
                               NULL,
                               NULL, mdsys.sdo_elem_info_array( 1, 2, 1),
                               l_ord);
  --
  END get_geom_from_xys;
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
    SELECT gdo_seq_no, gdo_x_val, gdo_y_val BULK COLLECT INTO l_tab_xys
      FROM gis_data_objects
     WHERE gdo_session_id = pi_gdo_session_id
     ORDER BY gdo_seq_no;
  --
    IF l_tab_xys.COUNT = 0
    THEN
      RAISE ex_no_data;
    END IF;
  --
    retval := get_geom_from_xys ( l_tab_xys );
  --
    RETURN retval;
  --
  EXCEPTION
    WHEN ex_no_data
    THEN
      RAISE_APPLICATION_ERROR (-20101,'No data found for session id = '||pi_gdo_session_id);
  --
  END get_shape_from_gdo;
--
--------------------------------------------------------------------------------
--
END nm3sdo_gdo;
/
