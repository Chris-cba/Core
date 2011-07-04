CREATE OR REPLACE PACKAGE BODY Nm3sdm
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdm.pkb-arc   2.47   Jul 04 2011 16:51:38   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3sdm.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2011 16:51:38  $
--       Date fetched Out : $Modtime:   Jul 04 2011 16:13:14  $
--       PVCS Version     : $Revision:   2.47  $
--
--   Author : R.A. Coupe
--
--   Spatial Data Manager specific package body
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT VARCHAR2 (2000) := '"$Revision:   2.47  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT VARCHAR2 (30)   := 'NM3SDM';
--
   l_dummy_package_variable   NUMBER;
--
   qq                         CHAR (1)        := CHR (39);

-- nw modules - use 1 for all, 2 for GoG and 3 for GoS
   g_network_modules  ptr_vc_array := ptr_vc_array ( ptr_vc_array_type(
                                           ptr_vc( 1, 'NM0105' ) -- elements
                                          ,ptr_vc( 2, 'NM0115' ) -- GOG
                                          ,ptr_vc( 3, 'NM0110' ) -- GOS
                                          ,ptr_vc( 1, 'NM1100' ) -- Gazetteer
                                          ));

-- inv modules - use 1 for all, 2 where not applicable to FT
   g_asset_modules    ptr_vc_array := ptr_vc_array ( ptr_vc_array_type(
                                           ptr_vc( 2, 'NM0510' ) -- assets
                                          ,ptr_vc( 2, 'NM0570' ) -- find asset
                                          ,ptr_vc( 2, 'NM0572' ) -- Locator
                                          ,ptr_vc( 2, 'NM0535' ) -- BAU
                                          ,ptr_vc( 2, 'NM0590' ) -- Asset Maintenance
                                          ,ptr_vc( 2, 'NM0560' ) -- Assets on a Route -- AE 4053
                                          ,ptr_vc( 2, 'NM0573' ) -- Asset Grid - AE 4100
));

--
  e_not_unrestricted EXCEPTION;
  e_no_analyse_privs EXCEPTION;
--
-----------------------------------------------------------------------------
-- <PRIVATE FUNCTIONS>
   FUNCTION get_nlt_descr (p_nlt_id IN NUMBER)
      RETURN VARCHAR2;

--
   FUNCTION create_inv_sdo_join_view (
      p_nit               IN   nm_inv_types.nit_inv_type%TYPE,
      p_table             IN   VARCHAR2
    , p_start_date_column IN VARCHAR2 DEFAULT NULL
    , p_end_date_column   IN VARCHAR2 DEFAULT NULL
   )
      RETURN VARCHAR2;

--
   FUNCTION get_nlt_spatial_table (p_nlt IN NM_LINEAR_TYPES%ROWTYPE)
      RETURN VARCHAR2;

--
   FUNCTION get_nt_spatial_table (
      p_nt_type    IN   NM_TYPES.nt_type%TYPE,
      p_gty_type   IN   nm_group_types.ngt_group_type%TYPE DEFAULT NULL
   )
      RETURN VARCHAR2;

--
   FUNCTION get_nt_view_name (
      p_nt_type    IN   NM_TYPES.nt_type%TYPE,
      p_gty_type   IN   nm_group_types.ngt_group_type%TYPE
   )
      RETURN VARCHAR2;

--
   FUNCTION create_nlt_sdo_join_view (
      p_nlt     IN   NM_LINEAR_TYPES%ROWTYPE,
      p_table   IN   VARCHAR2
   )
      RETURN VARCHAR2;

--
   FUNCTION get_nlt_id_from_gty (
      pi_gty   IN   nm_group_types.ngt_group_type%TYPE
   )
      RETURN NM_LINEAR_TYPES.nlt_id%TYPE;

--
   FUNCTION get_nat_id_from_gty (
      pi_gty   IN   nm_group_types.ngt_group_type%TYPE
   )
      RETURN NM_AREA_TYPES.nat_id%TYPE;

--
   FUNCTION get_object_type (p_object IN VARCHAR2)
      RETURN VARCHAR2;
--

   FUNCTION get_nlt_base_themes ( p_nlt_id IN NM_LINEAR_TYPES.nlt_id%TYPE )
     RETURN nm_theme_array;
--

   FUNCTION Get_Inv_Base_Themes ( p_inv_type IN nm_inv_nw.nin_nit_inv_code%TYPE )
     RETURN nm_theme_array;
--

   FUNCTION get_nat_base_themes ( p_nt_type  IN NM_AREA_TYPES.NAT_NT_TYPE%TYPE,
                                  p_gty_type IN NM_AREA_TYPES.NAT_GTY_GROUP_TYPE%TYPE )
     RETURN nm_theme_array;

   FUNCTION get_asset_modules RETURN ptr_vc_array;

   PROCEDURE create_theme_functions( p_theme IN NUMBER, p_pa IN ptr_vc_array, p_exclude IN NUMBER );

   PROCEDURE drop_trigger_by_theme_id ( p_nth_id IN nm_themes_all.nth_theme_id%TYPE );

--
-----------------------------------------------------------------------------
-- <PRIVATE PROCEDURES>
   PROCEDURE create_spatial_table (
      p_table               IN   VARCHAR2,
      p_mp_flag             IN   BOOLEAN DEFAULT FALSE,
      p_start_date_column   IN   VARCHAR2 DEFAULT NULL,
      p_end_date_column     IN   VARCHAR2 DEFAULT NULL
   );

--
   PROCEDURE create_spatial_date_view (
      p_table            IN   VARCHAR2,
      p_start_date_col   IN   VARCHAR2 DEFAULT NULL,
      p_end_date_col     IN   VARCHAR2 DEFAULT NULL
   );

--
   PROCEDURE create_inv_spatial_idx (
      p_nit     IN   nm_inv_types.nit_inv_type%TYPE,
      p_table   IN   VARCHAR2
   );

--
   PROCEDURE create_ona_spatial_idx (
      p_nit     IN   nm_inv_types.nit_inv_type%TYPE,
      p_table   IN   VARCHAR2
   );
--
   PROCEDURE create_nlt_spatial_idx (
      p_nlt     IN   NM_LINEAR_TYPES%ROWTYPE,
      p_table   IN   VARCHAR2
   );

--
   PROCEDURE ins_usgm (pi_rec_usgm IN OUT user_sdo_geom_metadata%ROWTYPE);

--
   PROCEDURE  split_element_at_xy (p_layer IN NUMBER,
                                   p_ne_id  IN NUMBER,
                                   p_measure IN NUMBER,
                                   p_x IN NUMBER,
                                   p_y IN NUMBER,
                                   p_ne_id_1 IN NUMBER,
                                   p_ne_id_2 IN NUMBER,
                                   p_geom_1  OUT mdsys.sdo_geometry,
                                   p_geom_2  OUT mdsys.sdo_geometry );



--
   PROCEDURE create_base_themes(
      p_theme_id    IN NUMBER,
   p_base        IN nm_theme_array );
--
   FUNCTION user_is_unrestricted RETURN BOOLEAN;
--
   FUNCTION user_is_unrestricted RETURN BOOLEAN IS
   BEGIN
     RETURN Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE';
   END;
--
   FUNCTION get_asset_modules RETURN ptr_vc_array IS
   BEGIN
     RETURN g_asset_modules;
   END;

   PROCEDURE create_theme_functions( p_theme IN NUMBER, p_pa IN ptr_vc_array, p_exclude IN NUMBER ) IS
   CURSOR c1 ( c_theme IN NUMBER, c_pa IN ptr_vc_array, c_excl IN NUMBER ) IS
     SELECT f.ptr_value module, hmo_title
     FROM HIG_MODULES, TABLE ( c_pa.pa ) f
     WHERE f.ptr_value = hmo_module
  AND   NVL(c_excl, -999) != DECODE( c_excl, NULL, 0, f.ptr_id );

   BEGIN
--    failure of 9i to perform insert in an efficient way using ptrs - needs simple loop

      FOR ntf IN c1( p_theme, p_pa, p_exclude ) LOOP

        INSERT INTO NM_THEME_FUNCTIONS_ALL (
           NTF_NTH_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER,
           NTF_MENU_OPTION, NTF_SEEN_IN_GIS)
        VALUES
          ( p_theme, ntf.module, 'GIS_SESSION_ID'
          , ntf.hmo_title, DECODE( ntf.module, 'NM0572', 'N', 'Y' ));

      END LOOP;

   END;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_base_themes( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
   RETURN nm_theme_array IS
     retval nm_theme_array := Nm3array.init_nm_theme_array;
     CURSOR c_nbth ( c_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE) IS
       SELECT nm_theme_entry( nbth_base_theme )
         FROM NM_BASE_THEMES
        WHERE nbth_theme_id = c_theme_id;
   BEGIN
     OPEN c_nbth( p_theme_id );
     FETCH c_nbth BULK COLLECT INTO retval.nta_theme_array;
     CLOSE c_nbth;
     RETURN retval;
   END;

--
-----------------------------------------------------------------------------
--

   FUNCTION get_theme_nt (p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
      RETURN VARCHAR2
   IS
      CURSOR c1 (c_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
      IS
         SELECT nlt_nt_type
           FROM NM_THEMES_ALL, NM_NW_THEMES, NM_LINEAR_TYPES
          WHERE nlt_id = nnth_nlt_id
            AND nnth_nth_theme_id = nth_theme_id
            AND nth_theme_id = c_theme_id
            AND nth_theme_type = 'SDO';

      retval   NM_TYPES.nt_type%TYPE;
   BEGIN
      OPEN c1 (p_theme_id);
      FETCH c1
       INTO retval;
      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 192,
                        pi_sqlcode      => -20001
                       );
      --    raise_application_error(-20001,'Theme is not related to a network');
      END IF;

      CLOSE c1;

      RETURN retval;
   END get_theme_nt;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_node_table (p_node_type IN NM_NODE_TYPES.nnt_type%TYPE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'V_NM_NO_' || p_node_type || '_SDO';
   END get_node_table;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_node_type (p_nt_type IN NM_TYPES.nt_type%TYPE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN Nm3get.get_nt (pi_nt_type => p_nt_type).nt_node_type;
   END get_node_type;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_node_type (p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN get_node_type
                         (p_nt_type      => get_theme_nt
                                                     (p_theme_id      => p_theme_id)
                         );
   END get_node_type;

--
-----------------------------------------------------------------------------
--
/*
   FUNCTION create_9i_node_metadata (
      p_node_type   IN   nm_node_types.nnt_type%TYPE
   )
      RETURN NUMBER
   IS
      cur_string   VARCHAR2 (4000);
      l_rec_usgm   rec_usgm;
   BEGIN
      --create node view based on points - this assumes that the points are either
      --held as a geo-enabled column or through the use of Oracle 9i function based index
      --this work on 8i but it will not register in the metadata
      cur_string :=
            'create or replace view v_nm_no_'
         || p_node_type
         || '_sdo '
         || ' as select n.*, p.np_grid_east, p.np_grid_north, '
         || ' nm3sdo.get_sdo_pt( 1, p.np_grid_east, p.np_grid_north) geoloc '
         || 'from nm_nodes n, nm_points p '
         || 'where n.NO_NP_ID = p.NP_ID '
         || 'and   n.no_node_type = '
         || ''''
         || p_node_type
         || '''';
      nm3ddl.create_object_and_syns ('V_NM_NO_' || p_node_type || '_SDO',
                                     cur_string
                                    );

      --  execute immediate cur_string;
      INSERT INTO user_sdo_geom_metadata
                  (table_name, column_name, diminfo, srid)
         SELECT 'V_NM_NO_' || p_node_type || '_SDO', 'GEOLOC', diminfo, srid
           FROM user_sdo_geom_metadata
          WHERE table_name = 'NM_POINTS';

      --create theme info for nodes? and return theme id
      RETURN 1;
   END create_9i_node_metadata;
*/
--
-----------------------------------------------------------------------------
--
   FUNCTION create_node_metadata (p_node_type IN NM_NODE_TYPES.nnt_type%TYPE)
      RETURN NUMBER
   IS
      cur_string    VARCHAR2 (4000);
      l_node_view   VARCHAR2 (30);
      retval        NUMBER;
   BEGIN
    -- AE check to make sure user is unrestricted
      IF NOT user_is_unrestricted
      THEN
        RAISE e_not_unrestricted;
      END IF;
      --create node view based on points - this assumes that the points are either
      --held as a geo-enabled column this work on 8i by cloning the point-locations table
      --
      l_node_view := get_node_table (p_node_type);
      cur_string :=
            'create or replace view '
         || l_node_view
         || ' as select /*+INDEX( NM_NODES_ALL,NN_NP_FK_IND)*/ p.npl_id, n.*, p.npl_location geoloc '
         || 'from nm_nodes n, nm_point_locations p '
         || 'where n.NO_NP_ID = p.NPL_ID '
         || 'and   n.no_node_type = '
         || ''''
         || p_node_type
         || '''';

--         Nm_Debug.debug_on;
--         Nm_Debug.DEBUG( cur_string );

      --Nm3ddl.create_object_and_syns( l_node_view, cur_string );

      -- AE 23-SEP-2008
      -- We will now use views instead of synonyms to provide subordinate user access
      -- to spatial objects
      --nm3ddl.create_object_and_views (l_node_view, cur_string);
      -- CWS 0108742 Change back to using synonyms
      Nm3ddl.create_object_and_syns( l_node_view, cur_string );
--    EXECUTE IMMEDIATE cur_string;

      INSERT INTO mdsys.sdo_geom_metadata_table
                  (sdo_table_name, sdo_column_name, sdo_diminfo, sdo_srid, sdo_owner)
         SELECT l_node_view, 'GEOLOC', sdo_diminfo, sdo_srid, Sys_Context('NM3CORE','APPLICATION_OWNER')
           FROM mdsys.sdo_geom_metadata_table
          WHERE sdo_table_name = 'NM_POINT_LOCATIONS'
            AND sdo_column_name = 'NPL_LOCATION'
            AND sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER');

      retval := register_node_theme (p_node_type, l_node_view, 'GEOLOC');
      RETURN retval;

   END create_node_metadata;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_details (
      p_theme_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE,
      p_ne_id      IN   NUMBER
   )
      RETURN CLOB
   IS
   BEGIN
      RETURN Nm3xmlqry.get_theme_details_as_xml_clob (p_theme_id, p_ne_id);
   END get_details;

-----------------------------------------------------------------------------
--
   FUNCTION get_details (p_ne_id IN NUMBER)
      RETURN CLOB
   IS
   BEGIN
      RETURN Nm3xmlqry.get_obj_details_as_xml_clob (p_ne_id);
   END get_details;

--
-----------------------------------------------------------------------------
--
PROCEDURE make_nt_spatial_layer
            ( pi_nlt_id   IN   NM_LINEAR_TYPES.nlt_id%TYPE,
              p_gen_pt    IN   NUMBER DEFAULT 0,
              p_gen_tol   IN   NUMBER DEFAULT 0,
              p_job_id    IN   NUMBER DEFAULT NULL )
   IS
      /*
      ** not expected to be used for datum layers
      */
      l_geom               MDSYS.SDO_GEOMETRY;
      lcur                 Nm3type.ref_cursor;
      l_nlt                NM_LINEAR_TYPES%ROWTYPE     := Nm3get.get_nlt (pi_nlt_id);
      l_nlt_seq            VARCHAR2(30);
      l_base_themes        nm_theme_array;
      l_theme_id           NM_THEMES_ALL.nth_theme_id%TYPE;
      l_theme_name         NM_THEMES_ALL.nth_theme_name%TYPE;
      l_base_table_theme   NM_THEMES_ALL.nth_theme_id%TYPE;
      l_ne                 nm_elements.ne_id%TYPE;
      l_objectid           NUMBER;
      l_dummy              NUMBER;
      cur_string1          VARCHAR2 (4000);
      cur_string2          VARCHAR2 (4000);
      l_tab                VARCHAR2 (30);
      l_view               VARCHAR2 (30);
      l_effective_date     DATE                 := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
      l_usgm               user_sdo_geom_metadata%ROWTYPE;
      l_diminfo            mdsys.sdo_dim_array;
      l_srid               NUMBER;
   --
   BEGIN
     -- AE check to make sure user is unrestricted
     IF NOT user_is_unrestricted
     THEN
       RAISE e_not_unrestricted;
     END IF;
--
-----------------------------------------------------------------------
-- Table name is the is derived based on nt/gty
-----------------------------------------------------------------------

      l_tab := Nm3sdm.get_nlt_spatial_table (l_nlt);

-----------------------------------------------------------------------
-- Will always be a group according to Linear types..
-----------------------------------------------------------------------
      IF l_nlt.nlt_g_i_d = 'G'
      THEN
         l_base_themes := get_nlt_base_themes( pi_nlt_id );
      END IF;

      IF l_base_themes.nta_theme_array(1).nthe_id IS NULL THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 266,
                        pi_sqlcode      => -20001
                       );

--      raise_application_error(-2001, 'No base themes for this route type');
      END IF;

-----------------------------------------------------------------------
-- Create the nt view if not already there
-----------------------------------------------------------------------
      IF NOT Nm3ddl.does_object_exist (l_view, 'VIEW')
      THEN
         Nm3inv_View.create_view_for_nt_type (l_nlt.nlt_nt_type);
      END IF;

-----------------------------------------------------------------------
-- Create spatial data in table + create date tracked view
-----------------------------------------------------------------------
      create_spatial_table (l_tab, TRUE, 'START_DATE', 'END_DATE');
      create_spatial_date_view (l_tab);
-----------------------------------------------------------------------
-- Clone SDO metadata from it's base layer
-----------------------------------------------------------------------
      Nm3sdo.set_diminfo_and_srid( l_base_themes, l_diminfo, l_srid );

      l_diminfo(3).sdo_tolerance := NM3UNIT.GET_TOL_FROM_UNIT_MASK(NM3NET.GET_NT_UNITS(l_nlt.nlt_nt_type));
      l_usgm.table_name  := l_tab;
      l_usgm.column_name := 'GEOLOC';
      l_usgm.diminfo     := l_diminfo;
      l_usgm.srid        := l_srid;

      Nm3sdo.ins_usgm ( l_usgm );

      l_usgm.table_name := 'V_'|| l_tab;

      Nm3sdo.ins_usgm ( l_usgm );

-----------------------------------------------------------------------
-- Register Theme for table
-----------------------------------------------------------------------
      l_theme_name := SUBSTR (l_nlt.nlt_descr, 1, 26);


      l_theme_id :=
         Nm3sdm.register_lrm_theme (p_nlt_id           => pi_nlt_id,
                             p_base             => l_base_themes,
                             p_table_name       => l_tab,
                             p_column_name      => 'GEOLOC',
                             p_name             => l_theme_name || '_TAB'
                            );
      l_base_table_theme := l_theme_id;

      l_nlt_seq := Nm3sdo.create_spatial_seq (l_theme_id);

-----------------------------------------------------------------------
-- Register Theme for date view
-----------------------------------------------------------------------

      l_theme_id :=
            register_lrm_theme (p_nlt_id              => pi_nlt_id,
                                p_base                => l_base_themes,
                                p_table_name          => 'V_' || l_tab,
                                p_column_name         => 'GEOLOC',
                                p_name                => l_theme_name,
                                p_view_flag           => 'Y',
                                p_base_table_nth      => l_base_table_theme
                               );

-----------------------------------------------------------------------
-- Need a join view between spatial table and NT view
-----------------------------------------------------------------------

      l_view := create_nlt_sdo_join_view (l_nlt, l_tab);

-----------------------------------------------------------------------
-- Create the spatial data
-----------------------------------------------------------------------

      Nm3sdo.create_nt_data( Nm3get.get_nth(l_base_table_theme), pi_nlt_id, l_base_themes, p_job_id );

-----------------------------------------------------------------------
-- Table needs a spatial index
-----------------------------------------------------------------------

      Nm3sdm.create_nlt_spatial_idx (l_nlt, l_tab);

-----------------------------------------------------------------------
-- Register theme for _DT attribute view
-----------------------------------------------------------------------

      IF g_date_views = 'Y'
      THEN

        l_usgm.table_name := l_view;

        Nm3sdo.ins_usgm ( l_usgm );

        l_theme_name := SUBSTR (l_nlt.nlt_descr, 1, 27) || '_DT';
        l_theme_id := Nm3sdm.register_lrm_theme
                          (p_nlt_id              => pi_nlt_id,
                           p_base                => l_base_themes,
                           p_table_name          => l_view,
                           p_column_name         => 'GEOLOC',
                           p_name                => l_theme_name,
                           p_view_flag           => 'Y',
                           p_base_table_nth      => l_base_table_theme
                          );
      END IF;

    -----------------------------------------------------------------------
    -- Analyse table
    -----------------------------------------------------------------------
      BEGIN
--    EXECUTE IMMEDIATE 'analyze table '||l_tab||' compute statistics';
        Nm3ddl.analyse_table (pi_table_name          => l_tab
                            , pi_schema              => Sys_Context('NM3CORE','APPLICATION_OWNER')
                            , pi_estimate_percentage => NULL
                            , pi_auto_sample_size    => FALSE);
      EXCEPTION
        WHEN OTHERS
        THEN
          RAISE e_no_analyse_privs;
      END;
      --
      Nm_Debug.proc_end (g_package_name, 'make_nt_spatial_layer');
   --
  EXCEPTION
    WHEN e_not_unrestricted
    THEN
      RAISE_APPLICATION_ERROR (-20777,'Restricted users are not permitted to create SDO layers');
    WHEN e_no_analyse_privs
    THEN
      RAISE_APPLICATION_ERROR (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                      'Please ensure the correct role/privs are applied to the user');

   END;
--
-----------------------------------------------------------------------------
--
  --temp function until the DB design is finished and the gets can be
  --generated
   FUNCTION get_nlt (pi_nlt_id IN NM_LINEAR_TYPES.nlt_id%TYPE)
      RETURN NM_LINEAR_TYPES%ROWTYPE
   IS
      CURSOR c1 (c_nlt_id IN NM_LINEAR_TYPES.nlt_id%TYPE)
      IS
         SELECT *
           FROM NM_LINEAR_TYPES
          WHERE nlt_id = c_nlt_id;

      retval   NM_LINEAR_TYPES%ROWTYPE;
   BEGIN
      OPEN c1 (pi_nlt_id);
      FETCH c1
       INTO retval;
      CLOSE c1;
      RETURN retval;
   END get_nlt;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_nth (pi_nth_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
      RETURN NM_THEMES_ALL%ROWTYPE
   IS
      CURSOR c1 (c_nth_theme_id NM_THEMES_ALL.nth_theme_id%TYPE)
      IS
         SELECT *
           FROM NM_THEMES_ALL
          WHERE nth_theme_id = pi_nth_theme_id;

      retval   NM_THEMES_ALL%ROWTYPE;
   BEGIN
      OPEN c1 (pi_nth_theme_id);
      FETCH c1
       INTO retval;
      CLOSE c1;
      RETURN retval;
   END get_nth;

--
-----------------------------------------------------------------------------
--
   PROCEDURE create_element_shape_from_xml (
      p_layer   IN   NUMBER,
      p_ne_id   IN   nm_elements.ne_id%TYPE,
      p_xml     IN   CLOB
   )
   IS
      l_geom   MDSYS.SDO_GEOMETRY;
   BEGIN
      ----   nm_debug.debug_on;
      ----   nm_debug.delete_debug(TRUE);

      ----   nm_debug.DEBUG_CLOB( P_CLOB => p_xml );
      l_geom := Nm3sdo_Xml.load_shape (p_xml            => p_xml,
                                       p_file_type      => 'datum');
      Nm3sdo.insert_element_shape (p_layer      => p_layer,
                                   p_ne_id      => p_ne_id,
                                   p_geom       => l_geom
                                  );
   END;

--
-----------------------------------------------------------------------------
--Note that this is temporary - theoretically, the function needs to be
--able to return all themes for a NT - its a many to many when you include
--schematics etc.
--Also, for now it assumes it is a base datum for use in the split/merge routines
--
   FUNCTION get_nt_theme (
      p_nt   IN   NM_TYPES.nt_type%TYPE,
      p_gt   IN   nm_group_types.ngt_group_type%TYPE DEFAULT NULL
   )
      RETURN NM_THEMES_ALL.nth_theme_id%TYPE
   IS
      CURSOR c1 (
         c_nt   NM_TYPES.nt_type%TYPE,
         c_gt   nm_group_types.ngt_group_type%TYPE
      )
      IS
         SELECT nth_theme_id
           FROM NM_THEMES_ALL, NM_NW_THEMES, NM_LINEAR_TYPES
          WHERE nlt_id = nnth_nlt_id
            AND nnth_nth_theme_id = nth_theme_id
            AND nlt_nt_type = c_nt
            AND nth_theme_type = 'SDO'
            AND nth_base_table_theme IS NULL
            AND NOT EXISTS ( SELECT 1 FROM NM_BASE_THEMES
                              WHERE nbth_theme_id = nth_theme_id );

      retval   NM_THEMES_ALL.nth_theme_id%TYPE;
   BEGIN
      OPEN c1 (p_nt, p_gt);
      FETCH c1
       INTO retval;
      CLOSE c1;
      RETURN retval;
   END get_nt_theme;

--
-----------------------------------------------------------------------------
--

   PROCEDURE  split_element_at_xy (p_layer IN NUMBER,
                                   p_ne_id  IN NUMBER,
                                   p_measure IN NUMBER,
                                   p_x IN NUMBER,
                                   p_y IN NUMBER,
                                   p_ne_id_1 IN NUMBER,
                                   p_ne_id_2 IN NUMBER,
                                   p_geom_1  OUT mdsys.sdo_geometry,
                                   p_geom_2  OUT mdsys.sdo_geometry ) IS

      l_geom    mdsys.sdo_geometry := Nm3sdo.Get_Layer_Element_Geometry( p_layer, p_ne_id );

      l_geom_1 mdsys.sdo_geometry;
      l_geom_2 mdsys.sdo_geometry;
      l_measure NUMBER;
      l_usgm   user_sdo_geom_metadata%ROWTYPE;
      l_end    NUMBER;

    BEGIN

      l_usgm := Nm3sdo.get_theme_metadata( p_layer );

      IF Nm3sdo.element_has_shape( p_layer, p_ne_id ) = 'TRUE'
      THEN

        l_measure := Nm3sdo.get_measure ( p_layer, p_ne_id, p_x, p_y ).lr_offset;

        sdo_lrs.split_geom_segment( l_geom, l_usgm.diminfo, l_measure, p_geom_1, p_geom_2 );

        if p_measure is not null then
          l_measure := p_measure;
        end if;

        p_geom_1 := sdo_lrs.scale_geom_segment
                       ( geom_segment  => p_geom_1
                       , dim_array     => l_usgm.diminfo
                       , start_measure => 0
                       , end_measure   => l_measure
                       , shift_measure => 0 );

        l_end   := Nm3net.get_datum_element_length( p_ne_id ) - l_measure;

        p_geom_2 := sdo_lrs.scale_geom_segment
                       ( geom_segment  => p_geom_2
                       , dim_array     => l_usgm.diminfo
                       , start_measure => 0
                       , end_measure   => l_end
                       , shift_measure => 0 );
      ELSE

        p_geom_1 := NULL;
        p_geom_2 := NULL;

      END IF;

    END;

--
-----------------------------------------------------------------------------
--
  PROCEDURE split_element_shapes (
      p_ne_id     IN   nm_elements.ne_id%TYPE,
      p_measure   IN   NUMBER,
      p_ne_id_1   IN   nm_elements.ne_id%TYPE,
      p_ne_id_2   IN   nm_elements.ne_id%TYPE,
      p_x         IN   NUMBER DEFAULT NULL,
      p_y         IN   NUMBER DEFAULT NULL
   )
   IS
      l_layer   NUMBER;
      l_geom1   MDSYS.SDO_GEOMETRY;
      l_geom2   MDSYS.SDO_GEOMETRY;
   BEGIN

--     nm_debug.debug_on;
--     Nm_Debug.DEBUG('Split element shapes');

      l_layer := Nm3sdm.get_nt_theme (Nm3get.get_ne (p_ne_id).ne_nt_type);

      IF Nm3sdo.element_has_shape (l_layer, p_ne_id) = 'TRUE'
      THEN
--        Nm_Debug.DEBUG('element has shape');

         IF p_x IS NULL AND p_y IS NULL THEN

--           Nm_Debug.DEBUG(' and no xy - use measure of '||p_measure);

            Nm3sdo.split_element_at_measure (p_layer        => l_layer,
                                             p_ne_id        => p_ne_id,
                                             p_measure      => p_measure,
                                             p_ne_id_1      => p_ne_id_1,
                                             p_ne_id_2      => p_ne_id_2,
                                             p_geom1        => l_geom1,
                                             p_geom2        => l_geom2
                                            );
         ELSIF p_x IS NOT NULL
           AND p_y IS NOT NULL
         THEN

--           Nm_Debug.DEBUG(' and xy - use  '||p_x||','||p_y);

            split_element_at_xy (  p_layer        => l_layer,
                                   p_ne_id        => p_ne_id,
                                   p_measure      => p_measure,
                                   p_x            => p_x,
                                   p_y            => p_y,
                                   p_ne_id_1      => p_ne_id_1,
                                   p_ne_id_2      => p_ne_id_2,
                                   p_geom_1        => l_geom1,
                                   p_geom_2        => l_geom2 );

         ELSE

           RAISE_APPLICATION_ERROR(-20001, 'Incompatible values');

         END IF;

         Nm3sdo.insert_element_shape (p_layer      => l_layer,
                                      p_ne_id      => p_ne_id_1,
                                      p_geom       => l_geom1
                                     );
         Nm3sdo.insert_element_shape (p_layer      => l_layer,
                                      p_ne_id      => p_ne_id_2,
                                      p_geom       => l_geom2
                                     );
      END IF;

   END;
--
-----------------------------------------------------------------------------
--
   PROCEDURE ins_usgm (pi_rec_usgm IN OUT user_sdo_geom_metadata%ROWTYPE)
   IS
   BEGIN
      --
      Nm_Debug.proc_start (g_package_name, 'ins_usgm');

      --
      INSERT INTO mdsys.sdo_geom_metadata_table
                  (sdo_table_name, sdo_column_name,
                   sdo_diminfo, sdo_srid, sdo_owner
                  )
           VALUES (pi_rec_usgm.table_name, pi_rec_usgm.column_name,
                   pi_rec_usgm.diminfo, pi_rec_usgm.srid, Sys_Context('NM3CORE','APPLICATION_OWNER')
                  )
        RETURNING sdo_table_name, sdo_column_name,
                  sdo_diminfo, sdo_srid
             INTO pi_rec_usgm.table_name, pi_rec_usgm.column_name,
                  pi_rec_usgm.diminfo, pi_rec_usgm.srid;

      --
      Nm_Debug.proc_end (g_package_name, 'ins_usgm');
   --
   END ins_usgm;

--
-----------------------------------------------------------------------------
--
   PROCEDURE merge_element_shapes (
      p_ne_id           IN   nm_elements.ne_id%TYPE,
      p_ne_id_1         IN   nm_elements.ne_id%TYPE,
      p_ne_id_2         IN   nm_elements.ne_id%TYPE,
      p_ne_id_to_flip   IN   nm_elements.ne_id%TYPE
   )
   IS
      l_layer   NUMBER;
      l_geom    MDSYS.SDO_GEOMETRY;
   BEGIN
      l_layer := get_nt_theme (Nm3get.get_ne (p_ne_id).ne_nt_type);

      IF     Nm3sdo.element_has_shape (l_layer, p_ne_id_1) = 'TRUE'
         AND Nm3sdo.element_has_shape (l_layer, p_ne_id_2) = 'TRUE'
      THEN
         Nm3sdo.merge_element_shapes (p_layer              => l_layer,
                                      p_ne_id_1            => p_ne_id_1,
                                      p_ne_id_2            => p_ne_id_2,
                                      p_ne_id_to_flip      => p_ne_id_to_flip,
                                      p_geom               => l_geom
                                     );

         IF l_geom IS NOT NULL
         THEN
            Nm3sdo.insert_element_shape (p_layer      => l_layer,
                                         p_ne_id      => p_ne_id,
                                         p_geom       => l_geom
                                        );
         END IF;
      END IF;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE replace_element_shape (
      p_ne_id_old   IN   nm_elements.ne_id%TYPE,
      p_ne_id_new   IN   nm_elements.ne_id%TYPE
   )
   IS
      l_layer_old   NUMBER;
      l_layer_new   NUMBER;
      l_geom        MDSYS.SDO_GEOMETRY;
   BEGIN

--    nm_debug.debug('Replace shape for '||to_char(p_ne_id_old)||' into '||to_char(p_ne_id_new));

      l_layer_old := get_nt_theme (Nm3get.get_ne_all (p_ne_id_old).ne_nt_type);
      l_layer_new := get_nt_theme (Nm3get.get_ne (p_ne_id_new).ne_nt_type);

      IF Nm3sdo.element_has_shape (l_layer_old, p_ne_id_old) = 'TRUE' AND l_layer_new IS NOT NULL
      THEN
         l_geom := Nm3sdo.get_layer_element_geometry (l_layer_old, p_ne_id_old);
         --  The old element shape must be end-dated
         --  The new one must be created
         --  All affected shapes inside asset layers must be regenerated
         Nm3sdo.insert_element_shape (p_layer      => l_layer_new,
                                      p_ne_id      => p_ne_id_new,
                                      p_geom       => l_geom
                                     );
      END IF;
   --
   END;

--
-----------------------------------------------------------------------------
--
--

   PROCEDURE reshape_element (
      p_ne_id   IN   nm_elements.ne_id%TYPE,
      p_geom    IN   MDSYS.SDO_GEOMETRY
   )
   IS
      l_layer    NUMBER;
      l_old_geom mdsys.sdo_geometry;
      l_new_geom mdsys.sdo_geometry;
      l_length   NUMBER;
      l_usgm     user_sdo_geom_metadata%ROWTYPE;
      l_rec_nth  nm_themes_all%ROWTYPE;
   BEGIN
      --nm_debug.debug_on;
      --nm_debug.debug('changing shapes');
      l_layer := get_nt_theme (Nm3get.get_ne (p_ne_id).ne_nt_type);
      l_rec_nth := nm3get.get_nth(l_layer);

      IF Nm3sdo.element_has_shape (l_layer, p_ne_id) = 'TRUE'
      THEN

         -- AE 09-FEB-2009
         -- Brought across the code from 2.10.1.1 branch into the mainstream
         -- version so that the SRID is set on the reshape

         l_old_geom := nm3sdo.get_layer_element_geometry( l_layer, p_ne_id );

         l_new_geom := p_geom;

         IF NVL(l_old_geom.sdo_srid, -9999)  != NVL( l_new_geom.sdo_srid, -9999)
         THEN
           l_new_geom.sdo_srid := l_old_geom.sdo_srid;
         END IF;
      --
      -- Task 0110101
      -- Bring code across from NM3SDO insert_element_shape to validate the
      -- length of the geometry being passed into this procedure
      --
         l_usgm := nm3sdo.get_usgm ( pi_table_name  => l_rec_nth.nth_feature_table
                                   , pi_column_name => l_rec_nth.nth_feature_shape_column );
      --
         l_length := nm3net.get_ne_length ( p_ne_id );
      --
         IF NVL(sdo_lrs.geom_segment_end_measure ( l_new_geom, l_usgm.diminfo ), -9999) != l_length 
         THEN
            sdo_lrs.redefine_geom_segment ( l_new_geom, l_usgm.diminfo, 0, l_length );
         END IF;
      --
         IF sdo_lrs.geom_segment_end_measure ( l_new_geom, l_usgm.diminfo ) != l_length
         THEN
           hig.raise_ner(pi_appl    => nm3type.c_hig
                        ,pi_id      => 204
                        ,pi_sqlcode => -20001 );
         END IF;
      --
      -- Task 0110101 Done
      --
         nm3sdo_edit.reshape ( l_layer, p_ne_id, l_new_geom );
      --
         nm3sdo.change_affected_shapes (p_layer      => l_layer,
                                        p_ne_id      => p_ne_id);
      ELSE
         nm3sdo.insert_element_shape (p_layer      => l_layer,
                                      p_ne_id      => p_ne_id,
                                      p_geom       => p_geom
                                     );
         nm3sdo.change_affected_shapes (p_layer      => l_layer,
                                        p_ne_id      => p_ne_id);
      END IF;

   END;
--
-----------------------------------------------------------------------------
--
   PROCEDURE move_node (
      p_no_node_id   IN   nm_nodes.no_node_id%TYPE,
      p_x            IN   NUMBER,
      p_y            IN   NUMBER
   )
   IS
      l_np_id   NM_POINTS.np_id%TYPE;
   BEGIN
      l_np_id := Nm3get.get_no (pi_no_node_id => p_no_node_id).no_np_id;
      UPDATE NM_POINTS np
         SET np.np_grid_east = p_x,
             np.np_grid_north = p_y
       WHERE np.np_id = l_np_id;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE reverse_element_shape (
      p_ne_id_old   IN   nm_elements.ne_id%TYPE,
      p_ne_id_new   IN   nm_elements.ne_id%TYPE
   )
   IS
      l_layer   NUMBER;
      l_geom    MDSYS.SDO_GEOMETRY;
   BEGIN
      l_layer := get_nt_theme (Nm3get.get_ne_all (p_ne_id_old).ne_nt_type);

      IF Nm3sdo.element_has_shape (l_layer, p_ne_id_old) = 'TRUE'
      THEN
         l_geom := Nm3sdo.get_layer_element_geometry (l_layer, p_ne_id_old);
         l_geom := Nm3sdo.reverse_geometry (p_geom => l_geom);
         Nm3sdo.insert_element_shape (p_layer      => l_layer,
                                      p_ne_id      => p_ne_id_new,
                                      p_geom       => l_geom
                                     );
      END IF;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE recalibrate_element_shape (
      p_ne_id               IN   nm_elements.ne_id%TYPE,
      p_measure             IN   NUMBER,
      p_new_length_to_end   IN   nm_elements.ne_length%TYPE
   )
   IS
      l_layer     NUMBER;
      l_pt_geom   MDSYS.SDO_GEOMETRY;
      l_geom      MDSYS.SDO_GEOMETRY;
   BEGIN
      ----   nm_debug.delete_debug(true);
      ----   nm_debug.debug_on;
      l_layer := get_nt_theme (Nm3get.get_ne (p_ne_id).ne_nt_type);

      IF Nm3sdo.element_has_shape (l_layer, p_ne_id) = 'TRUE'
      THEN
         ----   nm_debug.debug('get old geometry');
         l_geom := Nm3sdo.get_layer_element_geometry (l_layer, p_ne_id);
         --  nm_debug.debug('recalibrate');
         l_geom :=
            Nm3sdo.recalibrate_geometry
                                      (p_layer              => l_layer,
                                       p_ne_id              => p_ne_id,
                                       p_geom               => l_geom,
                                       p_measure            => p_measure,
                                       p_length_to_end      => p_new_length_to_end
                                      );
         --  nm_debug.debug('Remove old shape');
         Nm3sdo.delete_layer_shape (p_layer => l_layer, p_ne_id => p_ne_id);
         --  nm_debug.debug('Insert new shape');
         Nm3sdo.insert_element_shape (p_layer      => l_layer,
                                      p_ne_id      => p_ne_id,
                                      p_geom       => l_geom
                                     );
      --  The measures on the routes will be affected
      --  However, the nm_true will be out of step - this should be done on a resequence

      --  The other layers are also affected, but since the calling process will affect the members, best left to
      --  the trigger to deal with it.
      END IF;

   END;

--
-------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE shift_asset_shapes (
      p_ne_id               IN   nm_elements.ne_id%TYPE,
      p_measure             IN   NUMBER,
      p_new_length_to_end   IN   nm_elements.ne_length%TYPE
   )
   IS
      --
      --NOT finished!!!
      --
      l_layer     NUMBER;
      l_pt_geom   MDSYS.SDO_GEOMETRY;
      l_geom      MDSYS.SDO_GEOMETRY;
   BEGIN
      l_layer := get_nt_theme (Nm3get.get_ne (p_ne_id).ne_nt_type);

      IF Nm3sdo.element_has_shape (l_layer, p_ne_id) = 'TRUE'
      THEN
         --  nm_debug.debug('get old geometry');

         --  remove all existing shapes - they will move with the shift
         Nm3sdo.add_new_inv_shapes (p_layer      => l_layer,
                                    p_ne_id      => p_ne_id,
                                    p_geom       => l_geom
                                   );
      END IF;
   END;

--
----------------------------------------------------------------------------------------
--
-- The registration of a node theme depends on the existence of the nm_point_locations registry entry
-- If it is not present, then register this first.
-- RAC December 2005

   FUNCTION register_node_theme (
      p_node_type     IN   VARCHAR2,
      p_table_name    IN   VARCHAR2,
      p_column_name   IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      retval      NUMBER;
      l_nth       NM_THEMES_ALL%ROWTYPE;
      l_rec_ntg   NM_THEME_GTYPES%ROWTYPE;
   BEGIN
      retval := Higgis.next_theme_id;

      l_nth.nth_base_table_theme := get_theme_from_feature_table ('NM_POINT_LOCATIONS'
                                                                , 'NM_POINT_LOCATIONS' );
      IF l_nth.nth_base_table_theme IS NULL
      THEN
        --
        register_npl_theme;
        -- raise_application_error(-20001, 'register the nm_point_locations table first');

      END IF;

      l_nth.nth_theme_id := retval;
      l_nth.nth_theme_name := 'NODE_' || p_node_type;
      l_nth.nth_table_name := p_table_name;
      l_nth.nth_where := NULL;
      l_nth.nth_pk_column := 'NO_NODE_ID';
      l_nth.nth_label_column := 'NO_NODE_NAME';
      l_nth.nth_rse_table_name := 'NM_ELEMENTS';
      l_nth.nth_rse_fk_column := NULL;
      l_nth.nth_st_chain_column := NULL;
      l_nth.nth_end_chain_column := NULL;
--    l_nth.nth_x_column := 'NO_GRID_EAST';
--    l_nth.nth_y_column := 'NO_GRID_NORTH';
      l_nth.nth_offset_field := NULL;
      l_nth.nth_feature_table := 'V_NM_NO_'||p_node_type||'_SDO';
      l_nth.nth_feature_pk_column := 'NPL_ID';
      l_nth.nth_feature_fk_column := NULL;
      l_nth.nth_xsp_column := NULL;
      l_nth.nth_feature_shape_column := 'GEOLOC';
      l_nth.nth_hpr_product := 'NET';
      l_nth.nth_location_updatable := 'N';
      l_nth.nth_theme_type := 'SDO';
--    l_nth.nth_base_theme := NULL;
      l_nth.nth_dependency := 'I';
      l_nth.nth_storage := 'S';
      l_nth.nth_update_on_edit := 'N';
      l_nth.nth_use_history := 'N';
      l_nth.nth_lref_mandatory := 'N';
      l_nth.nth_tolerance := 10;
      l_nth.nth_tol_units := 1;

      Nm3ins.ins_nth (l_nth);
      --
      --  Build theme gtype rowtype
      l_rec_ntg.ntg_theme_id := l_nth.nth_theme_id;
      l_rec_ntg.ntg_seq_no := 1;
      l_rec_ntg.ntg_xml_url := NULL;
      l_rec_ntg.ntg_gtype := '2001';

      Nm3ins.ins_ntg (p_rec_ntg => l_rec_ntg);

   COMMIT;

      IF Hig.get_sysopt ('REGSDELAY') = 'Y'
      THEN
         EXECUTE IMMEDIATE (   ' begin  '
                            || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_nth.nth_theme_id )||')'
                            || '; end;'
                           );
      --  place exception into dynamic sql ananymous block. This is dynamic sql to avoid compilation probs
      END IF;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 193,
                        pi_sqlcode      => -20003
                       );
   --    raise_application_error( -20003, 'Point location data not found - clone is not possible');
   END;

--
---------------------------------------------------------------------------------------------------
--
  PROCEDURE register_npl_theme
  IS
    l_rec_nth NM_THEMES_ALL%ROWTYPE;
    l_rec_ntg NM_THEME_GTYPES%ROWTYPE;
  BEGIN
    l_rec_nth.nth_theme_id             := Nm3seq.next_nth_theme_id_seq;
    l_rec_nth.nth_theme_name           := 'POINT_LOCATIONS';
    l_rec_nth.nth_table_name           := 'NM_POINT_LOCATIONS';
    l_rec_nth.nth_pk_column            := 'NPL_ID';
    l_rec_nth.nth_label_column         := 'NPL_ID';
    l_rec_nth.nth_feature_table        := 'NM_POINT_LOCATIONS';
    l_rec_nth.nth_feature_shape_column := 'NPL_LOCATION';
    l_rec_nth.nth_feature_pk_column    := 'NPL_ID';
    l_rec_nth.nth_use_history          := 'N';
    l_rec_nth.nth_hpr_product          := 'NET';
    l_rec_nth.nth_theme_type           := 'SDO';
    l_rec_nth.nth_location_updatable   := 'N';
    l_rec_nth.nth_dependency           := 'I';
    l_rec_nth.nth_storage              := 'S';
    l_rec_nth.nth_update_on_edit       := 'N';
    l_rec_nth.nth_use_history          := 'N';
    l_rec_nth.nth_snap_to_theme        := 'N';
    l_rec_nth.nth_lref_mandatory       := 'N';
    l_rec_nth.nth_tolerance            := 10;
    l_rec_nth.nth_tol_units            := 1;
    l_rec_nth.nth_dynamic_theme        := 'N';
    Nm3ins.ins_nth(l_rec_nth);
    --
    l_rec_ntg.ntg_theme_id := l_rec_nth.nth_theme_id;
    l_rec_ntg.ntg_seq_no := 1;
    l_rec_ntg.ntg_xml_url := NULL;
    l_rec_ntg.ntg_gtype := '2001';
    Nm3ins.ins_ntg (p_rec_ntg => l_rec_ntg);
    --
    IF Hig.get_sysopt ('REGSDELAY') = 'Y'
    THEN
       EXECUTE IMMEDIATE
         (   ' begin  '
          || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_rec_nth.nth_theme_id)||')'
          || '; end;'
          );
    END IF;
  END register_npl_theme;
--
---------------------------------------------------------------------------------------------------
--

   FUNCTION get_nlt_base_themes ( p_nlt_id IN NM_LINEAR_TYPES.nlt_id%TYPE ) RETURN nm_theme_array IS

      retval nm_theme_array := Nm3array.init_nm_theme_array;

      CURSOR c_nth ( c_nlt_id IN nm_linear_types.nlt_id%TYPE ) IS
        SELECT nm_theme_entry(nnth_nth_theme_id)
          FROM nm_nw_themes d
              ,nm_linear_types dl
              ,nm_nt_groupings g
              ,nm_linear_types gl
              ,nm_themes_all
         WHERE gl.nlt_id = c_nlt_id
           AND dl.nlt_id = nnth_nlt_id
           AND g.nng_group_type = gl.nlt_gty_type
           AND g.nng_nt_type = dl.nlt_nt_type
           AND nth_theme_id = nnth_nth_theme_id
           AND nth_base_table_theme IS NULL
           AND dl.nlt_g_i_d = 'D';

   BEGIN

     OPEN c_nth ( p_nlt_id );
     FETCH c_nth BULK COLLECT INTO retval.nta_theme_array;
     CLOSE c_nth;

     IF retval.nta_theme_array.LAST IS NULL
     THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 267,
                        pi_sqlcode      => -20003,
                        pi_supplementary_info => TO_CHAR( p_nlt_id )
                       );
--    raise_application_error (-20001, 'No themes for linear type '||to_char( p_nlt_id ));
     ELSE
       RETURN retval;
     END IF;

   END;
--
---------------------------------------------------------------------------------------------------
--

  PROCEDURE create_base_themes ( p_theme_id    IN NUMBER
                                ,p_base        IN nm_theme_array ) IS
  BEGIN
--  Nm_Debug.debug_on;
    IF p_base.nta_theme_array(1).nthe_id IS NULL THEN
      NULL;
    ELSE
 /*
      FOR i IN 1..p_base.nta_theme_array.LAST LOOP
        Nm_Debug.DEBUG('Base '||TO_CHAR( p_base.nta_theme_array(i).nthe_id ));
      END LOOP;

      insert into nm_base_themes
      ( nbth_theme_id, nbth_base_theme )
      select p_theme_id, t.nthe_id
   from table ( p_base.nta_theme_array ) t;
*/

      FOR i IN 1..p_base.nta_theme_array.LAST LOOP

        INSERT INTO NM_BASE_THEMES
            ( nbth_theme_id, nbth_base_theme )
        VALUES ( p_theme_id, p_base.nta_theme_array(i).nthe_id );
      END LOOP;

    END IF;
  END;


---------------------------------------------------------------------------------------------------
--


   FUNCTION register_lrm_theme (
      p_nlt_id           IN   NUMBER,
      p_base             IN   nm_theme_array,
      p_table_name       IN   VARCHAR2,
      p_column_name      IN   VARCHAR2,
      p_name             IN   VARCHAR2 DEFAULT NULL,
      p_view_flag        IN   VARCHAR2 DEFAULT 'N',
      p_base_table_nth   IN   NM_THEMES_ALL.nth_theme_id%TYPE DEFAULT NULL
   )
      RETURN NUMBER
   IS
      retval        NUMBER;
      l_d_or_s      VARCHAR2 (1);
      l_view_name   VARCHAR2 (30);
      l_pk_col      VARCHAR2 (30)                       := 'NE_ID';
      l_nth         NM_THEMES_ALL%ROWTYPE;
      l_nlt         NM_LINEAR_TYPES%ROWTYPE;
      l_name        NM_THEMES_ALL.nth_theme_name%TYPE   := UPPER (p_name);
      l_rec_nnth    NM_NW_THEMES%ROWTYPE;
      l_rec_ntg     NM_THEME_GTYPES%ROWTYPE;
      l_mp_gtype    NUMBER := TO_NUMBER(NVL(Hig.get_sysopt('SDOMPGTYPE'),'3302'));

   BEGIN

      l_nlt := get_nlt (p_nlt_id);
      g_units := Nm3net.get_nt_units( l_nlt.nlt_nt_type);

      IF g_units = 1 THEN
        g_unit_conv := 1;
      ELSE
        g_unit_conv := Nm3get.get_uc ( g_units, 1).uc_conversion_factor;
      END IF;

      IF l_name IS NULL
      THEN
         l_name := UPPER (SUBSTR (l_nlt.nlt_descr, 1, 30));
      END IF;

      IF Nm3sdo.use_surrogate_key = 'Y'
      THEN
         l_pk_col := 'OBJECTID';
         --  to make sm work we need to use NE_ID
         l_pk_col := 'NE_ID';
      END IF;

      retval := Higgis.next_theme_id;
      l_nth.nth_theme_id := retval;
      l_nth.nth_theme_name := l_name;
      l_nth.nth_table_name := p_table_name;
      l_nth.nth_where := NULL;
      l_nth.nth_pk_column := 'NE_ID';
    --
    -- Task ID 0107889 - Set Label Column to NE_ID for Group layer base table themes
    -- 05/10/09 AE Further restrict on the non DT theme 
    --
      IF p_base_table_nth IS NULL
      OR l_nth.nth_theme_name NOT LIKE '%DT'
      THEN
        l_nth.nth_label_column := 'NE_ID';
      ELSE
        l_nth.nth_label_column := 'NE_UNIQUE';
      END IF;
    --
      l_nth.nth_rse_table_name := 'NM_ELEMENTS';
      l_nth.nth_rse_fk_column := 'NE_ID';
      l_nth.nth_st_chain_column := NULL;
      l_nth.nth_end_chain_column := NULL;
      l_nth.nth_x_column := NULL;
      l_nth.nth_y_column := NULL;
      l_nth.nth_offset_field := NULL;
      l_nth.nth_feature_table := p_table_name;
      l_nth.nth_feature_pk_column := l_pk_col;
      l_nth.nth_feature_fk_column := 'NE_ID';
      l_nth.nth_xsp_column := NULL;
      l_nth.nth_feature_shape_column := 'GEOLOC';
      l_nth.nth_hpr_product := 'NET';
      l_nth.nth_location_updatable := 'N';
      l_nth.nth_theme_type := 'SDO';
      l_nth.nth_dependency := 'D';
      l_nth.nth_storage := 'S';
      l_nth.nth_update_on_edit := 'D';
      l_nth.nth_use_history := 'Y';
      l_nth.nth_start_date_column := 'START_DATE';
      l_nth.nth_end_date_column := 'END_DATE';
      l_nth.nth_base_table_theme := p_base_table_nth;
      l_nth.nth_sequence_name := 'NTH_' || NVL(p_base_table_nth,retval) || '_SEQ';
      l_nth.nth_snap_to_theme := 'N';
      l_nth.nth_lref_mandatory := 'N';
      l_nth.nth_tolerance := 10;
      l_nth.nth_tol_units := 1;

      Nm3ins.ins_nth (l_nth);

      l_rec_nnth.nnth_nlt_id := p_nlt_id;
      l_rec_nnth.nnth_nth_theme_id := retval;

      Nm3ins.ins_nnth (l_rec_nnth);
      --
      --  Build theme gtype rowtype
      l_rec_ntg.ntg_theme_id := retval;
      l_rec_ntg.ntg_seq_no   := 1;
      l_rec_ntg.ntg_xml_url  := NULL;
      l_rec_ntg.ntg_gtype    := l_mp_gtype;

      Nm3ins.ins_ntg (p_rec_ntg => l_rec_ntg);

      --  Build the base themes

      create_base_themes( retval, p_base );

      --
      IF Hig.get_sysopt ('REGSDELAY') = 'Y'
      THEN
         EXECUTE IMMEDIATE (   ' begin  '
                            || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_nth.nth_theme_id )||');'
                            || ' end;'
                           );
      END IF;

      IF p_view_flag = 'Y'
      THEN
         DECLARE
            l_role   VARCHAR2 (30);
         BEGIN
            l_role := Hig.get_sysopt ('SDONETROLE');

            IF l_role IS NOT NULL
            THEN
               INSERT INTO NM_THEME_ROLES
                           (nthr_theme_id, nthr_role, nthr_mode
                           )
                    VALUES (retval, l_role, 'NORMAL'
                           );
            END IF;
         END;
      END IF;
--
-- create the theme functions - exclude gog
--
      create_theme_functions( p_theme => l_nth.nth_theme_id, p_pa => g_network_modules, p_exclude => 2 );

      RETURN retval;

   END register_lrm_theme;

--
---------------------------------------------------------------------------------------------------
--

   FUNCTION Get_Inv_Base_Themes ( p_inv_type IN nm_inv_nw.nin_nit_inv_code%TYPE ) RETURN nm_theme_array IS

      retval nm_theme_array := Nm3array.init_nm_theme_array;

      CURSOR c_nth ( c_inv_type IN nm_inv_nw.nin_nit_inv_code%TYPE ) IS
        SELECT nm_theme_entry(nth_theme_id)
        FROM NM_NW_THEMES
            ,NM_THEMES_ALL
            ,NM_LINEAR_TYPES
            ,nm_inv_nw
        WHERE nin_nit_inv_code = c_inv_type
          AND nin_nw_type = nlt_nt_type
          AND nlt_id = nnth_nlt_id
          AND nth_base_table_theme IS NULL
          AND nnth_nth_theme_id = nth_theme_id
          AND NOT EXISTS ( SELECT 1 FROM NM_BASE_THEMES
                            WHERE nth_theme_id = nbth_theme_id );

   BEGIN

       OPEN c_nth ( p_inv_type );
      FETCH c_nth BULK COLLECT INTO retval.nta_theme_array;
      CLOSE c_nth;

      IF retval.nta_theme_array.LAST IS NULL
      THEN
        -- no base theme availible
        Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                       pi_id           => 194,
                       pi_sqlcode      => -20001
                      );
      ELSE
        RETURN retval;
      END IF;

   END;

--
---------------------------------------------------------------------------------------------------
--

   FUNCTION register_inv_theme (
      pi_nit             IN   nm_inv_types%ROWTYPE,
      p_base_themes      IN   NM_THEME_ARRAY,
      p_table_name       IN   VARCHAR2,
      p_spatial_column   IN   VARCHAR2 DEFAULT 'GEOLOC',
      p_fk_column        IN   VARCHAR2 DEFAULT 'NE_ID',
      p_name             IN   VARCHAR2 DEFAULT NULL,
      p_view_flag        IN   VARCHAR2 DEFAULT 'N',
      p_pk_column        IN   VARCHAR2 DEFAULT 'NE_ID',
      p_base_table_nth   IN   NM_THEMES_ALL.nth_theme_id%TYPE DEFAULT NULL
   )
      RETURN NUMBER
   IS
      l_immediate_or_deferred   VARCHAR2 (1)              := 'I';
      l_fk_column               VARCHAR2 (30)             := 'NE_ID';
      l_f_fk_column             VARCHAR2 (30)             := 'NE_ID';
      l_pk_column               VARCHAR2 (30);
      l_name                    VARCHAR2 (30);
      l_t_pk_column             VARCHAR2 (30);
      l_t_fk_column             VARCHAR2 (30);
      l_t_uk_column             VARCHAR2 (30);
      l_t_begin_col             VARCHAR2 (30);
      l_t_end_col               VARCHAR2 (30);
      l_tab                     VARCHAR2 (30);
      l_end_mp                  VARCHAR2 (30)             := NULL;
      retval                    NUMBER;
      l_nth                     NM_THEMES_ALL%ROWTYPE;
      l_rec_nith                NM_INV_THEMES%ROWTYPE;
      l_rec_ntg                 NM_THEME_GTYPES%ROWTYPE;
      l_base_themes             nm_theme_array;
   BEGIN
      l_name := UPPER (p_name);

      IF l_name IS NULL
      THEN
         l_name :=
            UPPER (NVL (pi_nit.nit_short_descr,
                        SUBSTR (pi_nit.nit_inv_type || '-' || pi_nit.nit_descr,
                                1,
                                30
                               )
                       )
                  );
      END IF;

      l_immediate_or_deferred := 'D';

      IF p_view_flag = 'Y'
      THEN
         l_immediate_or_deferred := 'N';
         l_f_fk_column := NULL;
      END IF;

      l_pk_column := p_fk_column;

      IF Nm3sdo.use_surrogate_key = 'Y'
      THEN
         l_pk_column := 'OBJECTID';
         --  to make SM work for now we have to put the NE_ID in!
         l_pk_column := 'NE_ID';

         IF p_pk_column IS NOT NULL
         THEN
            l_pk_column := p_pk_column;
         END IF;
      END IF;

      retval := Higgis.next_theme_id;

      IF pi_nit.nit_pnt_or_cont = 'C'
      THEN
         l_end_mp := 'NM_END_MP';
      END IF;

      IF pi_nit.nit_table_name IS NOT NULL
      THEN
         --  Foreign table
         l_tab := pi_nit.nit_table_name;
         l_t_pk_column := pi_nit.nit_foreign_pk_column;
         l_t_fk_column := pi_nit.nit_lr_ne_column_name;
         l_t_uk_column := pi_nit.nit_foreign_pk_column;
         l_t_begin_col := pi_nit.nit_lr_st_chain;

         IF pi_nit.nit_pnt_or_cont = 'C'
         THEN
            l_end_mp := pi_nit.nit_lr_end_chain;
         END IF;
      ELSE
         l_tab :=
                Nm3inv_View.work_out_inv_type_view_name (pi_nit.nit_inv_type);
         l_t_pk_column := 'IIT_NE_ID';
         l_t_fk_column := 'NE_ID_OF';
         l_t_uk_column := 'IIT_PRIMARY_KEY';
         l_t_begin_col := 'NM_BEGIN_MP';

         IF pi_nit.nit_pnt_or_cont = 'C'
         THEN
            l_end_mp := 'NM_END_MP';
         END IF;
      END IF;

--  Build theme rowtype
      l_nth.nth_theme_id               := retval;
      l_nth.nth_theme_name             := l_name;
      l_nth.nth_table_name             := l_tab;
      l_nth.nth_where                  := NULL;
      l_nth.nth_pk_column              := l_t_pk_column;
      l_nth.nth_label_column           := l_t_uk_column;
      l_nth.nth_rse_table_name         := 'NM_ELEMENTS';
      l_nth.nth_rse_fk_column          := l_t_fk_column;
      l_nth.nth_st_chain_column        := l_t_begin_col;
      l_nth.nth_end_chain_column       := l_end_mp;
      l_nth.nth_x_column               := NULL;
      l_nth.nth_y_column               := NULL;
      l_nth.nth_offset_field           := NULL;
      l_nth.nth_feature_table          := p_table_name;
      l_nth.nth_feature_pk_column      := l_pk_column;
      l_nth.nth_feature_fk_column      := l_f_fk_column;
      l_nth.nth_xsp_column             := NULL;
      l_nth.nth_feature_shape_column   := p_spatial_column;
      l_nth.nth_hpr_product            := 'NET';
      l_nth.nth_location_updatable     := 'N';
      l_nth.nth_theme_type             := 'SDO';
--    l_nth.nth_base_theme             := p_base_theme;
      l_nth.nth_dependency             := 'D';
      l_nth.nth_storage                := 'S';
      l_nth.nth_update_on_edit         := l_immediate_or_deferred;
      l_nth.nth_use_history            := 'Y';
      l_nth.nth_start_date_column      := 'START_DATE';
      l_nth.nth_end_date_column        := 'END_DATE';
      l_nth.nth_base_table_theme       := p_base_table_nth;
      l_nth.nth_sequence_name          := 'NTH_' || NVL(p_base_table_nth,retval) || '_SEQ';
      l_nth.nth_snap_to_theme          := 'N';
      l_nth.nth_lref_mandatory         := 'N';
      l_nth.nth_tolerance              := 10;
      l_nth.nth_tol_units              := 1;
      --
      Nm3ins.ins_nth (l_nth);
      --  Build inv theme link
      l_rec_nith.nith_nit_id := pi_nit.nit_inv_type;
      l_rec_nith.nith_nth_theme_id := retval;
      --
      Nm3ins.ins_nith (l_rec_nith);
      --  Build theme gtype rowtype
      l_rec_ntg.ntg_theme_id := l_nth.nth_theme_id;
      l_rec_ntg.ntg_seq_no := 1;
      l_rec_ntg.ntg_xml_url := NULL;

      IF pi_nit.nit_pnt_or_cont = 'P'
      THEN
         l_rec_ntg.ntg_gtype := '2001';
      ELSIF pi_nit.nit_pnt_or_cont = 'C'
      THEN
         l_rec_ntg.ntg_gtype := 3302;
      END IF;

      Nm3ins.ins_ntg (p_rec_ntg => l_rec_ntg);

      create_base_themes( retval, p_base_themes );
--
      IF Hig.get_sysopt ('REGSDELAY') = 'Y'
      THEN
         EXECUTE IMMEDIATE (   'begin '
                            || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_nth.nth_theme_id )||')'
                            || '; end;'
                           );
      END IF;

      IF p_view_flag = 'Y'
      THEN
         INSERT INTO NM_THEME_ROLES
                     (nthr_theme_id, nthr_role, nthr_mode)
            SELECT retval, itr_hro_role, itr_mode
              FROM NM_INV_TYPE_ROLES
             WHERE itr_inv_type = pi_nit.nit_inv_type;
      END IF;
--
-- register the theme functions
--

      IF pi_nit.nit_table_name IS NULL THEN

        create_theme_functions( p_theme => l_nth.nth_theme_id, p_pa => g_asset_modules, p_exclude => NULL );

      ELSE
--      FT exclude data with a 2
        create_theme_functions( p_theme => l_nth.nth_theme_id, p_pa => g_asset_modules, p_exclude => 2 );

      END IF;

      RETURN retval;
   END register_inv_theme;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION register_ona_theme (
      pi_nit             IN   nm_inv_types%ROWTYPE,
      p_table_name       IN   VARCHAR2,
      p_spatial_column   IN   VARCHAR2 DEFAULT 'GEOLOC',
      p_fk_column        IN   VARCHAR2 DEFAULT 'NE_ID',
      p_name             IN   VARCHAR2 DEFAULT NULL,
      p_view_flag        IN   VARCHAR2 DEFAULT 'N',
      p_pk_column        IN   VARCHAR2 DEFAULT 'NE_ID',
      p_base_table_nth   IN   NM_THEMES_ALL.nth_theme_id%TYPE DEFAULT NULL
   )
      RETURN NUMBER
   IS
      l_immediate_or_deferred   VARCHAR2 (1)                           := 'N';
--    l_fk_column             VARCHAR2(30) := 'NE_ID';
--    l_f_fk_column           VARCHAR2(30) := 'NE_ID';
      l_pk_column               VARCHAR2 (30);
      l_name                    VARCHAR2 (30);
      l_t_pk_column             VARCHAR2 (30);
      l_t_fk_column             VARCHAR2 (30);
      l_t_uk_column             VARCHAR2 (30);
      l_t_begin_col             VARCHAR2 (30);
      l_t_end_col               VARCHAR2 (30);
      l_t_x_col                 VARCHAR2 (30);
      l_t_y_col                 VARCHAR2 (30);
      --
      l_tab                     VARCHAR2 (30);
      l_end_mp                  VARCHAR2 (10)                         := NULL;
      retval                    NUMBER;
      l_nth                     NM_THEMES_ALL%ROWTYPE;
      l_rec_base_nth            NM_THEMES_ALL%ROWTYPE;
      l_rec_nith                NM_INV_THEMES%ROWTYPE;
      l_rec_ntg                 NM_THEME_GTYPES%ROWTYPE;
      l_nth_start_date_column   NM_THEMES_ALL.nth_start_date_column%TYPE;
      l_nth_end_date_column     NM_THEMES_ALL.nth_end_date_column%TYPE;
      l_nth_base_table_theme    NM_THEMES_ALL.nth_base_table_theme%TYPE;
      l_nth_sequence_name       NM_THEMES_ALL.nth_sequence_name%TYPE;
      l_nth_snap_to_theme       NM_THEMES_ALL.nth_snap_to_theme%TYPE;
      l_nth_lref_mandatory      NM_THEMES_ALL.nth_lref_mandatory%TYPE;
      l_nth_tolerance           NM_THEMES_ALL.nth_tolerance%TYPE;
      l_nth_tol_units           NM_THEMES_ALL.nth_tol_units%TYPE;
      e_dup_nth                 EXCEPTION;
      e_dup_nith                EXCEPTION;
      e_dup_ntg                 EXCEPTION;

      --
      FUNCTION get_base_gtype (cp_theme_id IN NUMBER)
         RETURN NUMBER
      IS
         retval   NUMBER;
      BEGIN
         SELECT MAX (ntg_gtype)
           INTO retval
           FROM NM_THEME_GTYPES
          WHERE ntg_theme_id = cp_theme_id;

         RETURN retval;
      EXCEPTION
         WHEN OTHERS
         THEN
            Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                           pi_id           => 268,
                           pi_sqlcode      => -20001
                          );

--          raise_application_error (-20001,  'Cannot derive Gtype from base theme'  );
      END get_base_gtype;
   --
   BEGIN
      --
      Nm_Debug.proc_start (g_package_name, 'register_ona_theme');
      --
      l_name := UPPER (p_name);

      IF l_name IS NULL
      THEN
         l_name :=
            UPPER (NVL (pi_nit.nit_short_descr,
                        SUBSTR (pi_nit.nit_inv_type || '-' || pi_nit.nit_descr,
                                1,
                                30
                               )
                       )
                  );
      END IF;

      IF pi_nit.nit_table_name IS NOT NULL
      THEN
         l_pk_column := pi_nit.nit_foreign_pk_column;
      ELSE
         l_pk_column := 'IIT_NE_ID';
      END IF;
--
      IF Nm3sdo.use_surrogate_key = 'Y'
      THEN
         l_pk_column := 'OBJECTID';
         --  to make SM work for now we have to put the NE_ID in!
         --  l_pk_column := 'NE_ID';
         l_pk_column := 'IIT_NE_ID';
      END IF;
--
      retval := Higgis.next_theme_id;

      IF pi_nit.nit_table_name IS NOT NULL
      THEN
         --  Foreign table
         l_tab := pi_nit.nit_table_name;
         l_t_pk_column := pi_nit.nit_foreign_pk_column;
         l_t_uk_column := pi_nit.nit_foreign_pk_column;
      ELSE
         l_tab := Nm3inv_View.work_out_inv_type_view_name (pi_nit.nit_inv_type);
         l_t_pk_column := 'IIT_NE_ID';
         l_t_uk_column := 'IIT_PRIMARY_KEY';

         IF pi_nit.nit_use_xy = 'Y'
         THEN
            l_t_x_col := 'IIT_X';
            l_t_y_col := 'IIT_Y';
         END IF;
      END IF;

      --
      IF p_base_table_nth IS NOT NULL
      THEN
         l_rec_base_nth :=  Nm3get.get_nth (pi_nth_theme_id => p_base_table_nth);
      END IF;

      --
      l_nth.nth_theme_id               := retval;
      l_nth.nth_theme_name             := l_name;
      l_nth.nth_table_name             := l_tab;
      l_nth.nth_where                  := NULL;
      l_nth.nth_pk_column              := l_t_pk_column;
      l_nth.nth_label_column           := l_t_uk_column;
      l_nth.nth_x_column               := l_t_x_col;
      l_nth.nth_y_column               := l_t_y_col;
      l_nth.nth_feature_table          := p_table_name;
      l_nth.nth_feature_pk_column      := NVL (p_pk_column,l_rec_base_nth.nth_feature_pk_column);
      l_nth.nth_feature_shape_column   := p_spatial_column;
      l_nth.nth_hpr_product            := 'NET';
      l_nth.nth_location_updatable     := NVL (l_rec_base_nth.nth_location_updatable, 'N');
      l_nth.nth_theme_type             := 'SDO';
      l_nth.nth_dependency             := 'I';
      l_nth.nth_storage                := 'S';
      l_nth.nth_update_on_edit         := l_immediate_or_deferred;
      l_nth.nth_use_history            := 'Y';
      l_nth.nth_start_date_column      := NVL (l_rec_base_nth.nth_start_date_column, 'START_DATE');
      l_nth.nth_end_date_column        := NVL (l_rec_base_nth.nth_end_date_column, 'END_DATE');
      l_nth.nth_base_table_theme       := p_base_table_nth;
      l_nth.nth_sequence_name          := NVL (l_rec_base_nth.nth_sequence_name, 'NTH_' || retval || '_SEQ');
      l_nth.nth_snap_to_theme          := NVL (l_rec_base_nth.nth_snap_to_theme, 'N');
      l_nth.nth_lref_mandatory         := NVL (l_rec_base_nth.nth_lref_mandatory, 'N');
      l_nth.nth_tolerance              := NVL (l_rec_base_nth.nth_tolerance, 10);
      l_nth.nth_tol_units              := 1;
      --
--      Nm_Debug.DEBUG ('Creating NTH');
      BEGIN
         Nm3ins.ins_nth (l_nth);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RAISE e_dup_nth;
         WHEN OTHERS
         THEN
            RAISE;
      END;

      --
      l_rec_nith.nith_nit_id := pi_nit.nit_inv_type;
      l_rec_nith.nith_nth_theme_id := retval;
      --
--      Nm_Debug.DEBUG ('Creating NITH');

      BEGIN
         Nm3ins.ins_nith (l_rec_nith);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RAISE e_dup_nith;
         WHEN OTHERS
         THEN
            RAISE;
      END;

      --
/*
      Nm_Debug.DEBUG (   'Creating GType Link - '
                      || l_nth.nth_feature_table
                      || ' - '
                      || l_nth.nth_feature_shape_column
                     );
*/
      -- Create GTYPE record
      --l_rec_ntg.ntg_gtype    := Nm3sdo.get_table_gtype (l_nth.nth_feature_table,l_nth.nth_feature_shape_column);
      l_rec_ntg.ntg_gtype := get_base_gtype (l_rec_base_nth.nth_theme_id);

      IF l_rec_ntg.ntg_gtype IS NOT NULL
      THEN
         l_rec_ntg.ntg_theme_id := l_nth.nth_theme_id;
         l_rec_ntg.ntg_seq_no := 1;
--     ELSIF pi_nit.nit_pnt_or_cont = 'P'
--     THEN
--       Nm_Debug.DEBUG ('Creating GType Link - POINT');
--       l_rec_ntg.ntg_gtype    := '2001';
--       l_rec_ntg.ntg_theme_id := l_nth.nth_theme_id;
--       l_rec_ntg.ntg_seq_no   := 1;
--     ELSIF pi_nit.nit_pnt_or_cont = 'C'
--     THEN
--       l_rec_ntg.ntg_gtype    := '3002';
--       l_rec_ntg.ntg_theme_id := l_nth.nth_theme_id;
--       l_rec_ntg.ntg_seq_no   := 1;
      END IF;

      --
      BEGIN
         Nm3ins.ins_ntg (p_rec_ntg => l_rec_ntg);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RAISE e_dup_ntg;
         WHEN OTHERS
         THEN
            RAISE;
      END;

      --
--      Nm_Debug.DEBUG ('Creating GType - DONE');

--     IF Hig.get_sysopt('REGSDELAY') = 'Y'
--     THEN
--
--       EXECUTE IMMEDIATE
--           ( 'begin '||
--   --        '  nm_debug.debug_on;'||
--             '  nm3sde.clone_sde_layer( p_theme_id   => '||TO_CHAR(retval)||
--                                     ', p_pnt_or_cnt => '||''''||pi_nit.nit_pnt_or_cont||''''||
--                                     ' );'||
--             'end;' );
--
--     END IF;
      IF p_view_flag = 'Y'
      THEN
         INSERT INTO NM_THEME_ROLES
                     (nthr_theme_id, nthr_role, nthr_mode)
            SELECT retval, itr_hro_role, itr_mode
              FROM NM_INV_TYPE_ROLES
             WHERE itr_inv_type = pi_nit.nit_inv_type;
      END IF;

--
-- create the theme functions
--
      IF pi_nit.nit_table_name IS NULL THEN

        create_theme_functions( p_theme => l_nth.nth_theme_id, p_pa => g_asset_modules, p_exclude => NULL );

      ELSE

        create_theme_functions( p_theme => l_nth.nth_theme_id, p_pa => g_asset_modules, p_exclude => 2 );

      END IF;

      --
      RETURN retval;
      --
      Nm_Debug.proc_end (g_package_name, 'register_ona_theme');
   --
   EXCEPTION
      WHEN e_dup_nth
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 269,
                        pi_sqlcode      => -20001
                       );

--         raise_application_error (-20101, 'Duplicate Theme or Theme Name Found'  );
      WHEN e_dup_nith
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 270,
                        pi_sqlcode      => -20001
                       );
--       raise_application_error (-20102, 'Theme is already registered');
      WHEN e_dup_ntg
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 271,
                        pi_sqlcode      => -20001
                       );
--       raise_application_error (-20103, 'Error associating Geometry Type with Theme' );
      WHEN OTHERS
      THEN
         RAISE;
   END register_ona_theme;

--
---------------------------------------------------------------------------------------------------
--

   FUNCTION get_nat_base_themes ( p_nt_type  IN NM_AREA_TYPES.NAT_NT_TYPE%TYPE,
                                  p_gty_type IN NM_AREA_TYPES.NAT_GTY_GROUP_TYPE%TYPE )
     RETURN nm_theme_array IS
      retval nm_theme_array := Nm3array.init_nm_theme_array;

      CURSOR c_nth ( c_gty_type  IN nm_area_types.nat_gty_group_type%TYPE ) IS
        SELECT nm_theme_entry(nth_theme_id)
          FROM nm_nw_themes
              ,nm_linear_types
              ,nm_themes_all
              ,nm_nt_groupings
         WHERE nng_group_type = c_gty_type
           AND nng_nt_type = nlt_nt_type
           AND nlt_g_i_d = 'D'
           AND nth_base_table_theme IS NULL
           AND nlt_gty_type IS NULL
           AND nlt_id = nnth_nlt_id
           AND nnth_nth_theme_id = nth_theme_id
           AND NOT EXISTS ( SELECT 1 FROM nm_base_themes
                             WHERE nth_theme_id = nbth_theme_id );

   BEGIN

     OPEN c_nth ( p_gty_type );
     FETCH c_nth BULK COLLECT INTO retval.nta_theme_array;
     CLOSE c_nth;

     IF retval.nta_theme_array.LAST IS NULL THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 272,
                        pi_sqlcode      => -20001,
                        pi_supplementary_info => p_gty_type
                       );
 --  raise_application_error (-20001, 'No themes for linear type '||p_gty_type);
     ELSE
       RETURN retval;
     END IF;
   END;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION register_nat_theme (
      p_nt_type          IN   NM_TYPES.nt_type%TYPE,
      p_gty_type         IN   nm_group_types.ngt_group_type%TYPE,
      p_base_themes      IN   nm_theme_array,
      p_table_name       IN   VARCHAR2,
      p_spatial_column   IN   VARCHAR2 DEFAULT 'GEOLOC',
      p_fk_column        IN   VARCHAR2 DEFAULT 'NE_ID',
      p_name             IN   VARCHAR2 DEFAULT NULL,
      p_view_flag        IN   VARCHAR2 DEFAULT 'N',
      p_base_table_nth   IN   NM_THEMES_ALL.nth_theme_id%TYPE DEFAULT NULL
   )
      RETURN NUMBER
   IS
      retval                    NUMBER;
      l_nat_id                  NUMBER;
      l_effective_date          DATE            := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
      l_name                    VARCHAR2 (30)   := NVL (p_name, p_table_name);
      l_immediate_or_deferred   VARCHAR2 (1)                      := 'I';
      l_fk_column               VARCHAR2 (30)                     := 'NE_ID';
      l_pk_column               VARCHAR2 (30);
      l_nat                     NM_AREA_TYPES%ROWTYPE;
      l_nth_id                  NM_THEMES_ALL.nth_theme_id%TYPE;
      l_nth                     NM_THEMES_ALL%ROWTYPE;
      l_rec_ntg                 NM_THEME_GTYPES%ROWTYPE;
      l_base_themes             nm_theme_array;

   BEGIN

      IF p_view_flag = 'Y'
      THEN
         l_immediate_or_deferred := 'N';                --no update for views
      END IF;

      SELECT nat_id_seq.NEXTVAL
        INTO l_nat_id
        FROM DUAL;

      l_nat.nat_id := l_nat_id;
      l_nat.nat_nt_type := p_nt_type;
      l_nat.nat_gty_group_type := p_gty_type;
      l_nat.nat_descr := 'Spatial Representation of ' || p_gty_type || ' Groups';
      l_nat.nat_seq_no := 1;
      l_nat.nat_start_date := l_effective_date;
      l_nat.nat_end_date := NULL;
      l_nat.nat_shape_type := 'TRACED';

      BEGIN
         INSERT INTO NM_AREA_TYPES
                     (nat_id, nat_nt_type,
                      nat_gty_group_type, nat_descr,
                      nat_seq_no, nat_start_date,
                      nat_end_date, nat_shape_type
                     )
              VALUES (l_nat.nat_id, l_nat.nat_nt_type,
                      l_nat.nat_gty_group_type, l_nat.nat_descr,
                      l_nat.nat_seq_no, l_nat.nat_start_date,
                      l_nat.nat_end_date, l_nat.nat_shape_type
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            SELECT nat_id
              INTO l_nat_id
              FROM NM_AREA_TYPES
             WHERE nat_nt_type = p_nt_type AND nat_gty_group_type = p_gty_type;
      END;


      retval := Nm3seq.next_nth_theme_id_seq;
      -- generate the theme
      l_nth_id := retval;
      l_nth.nth_theme_id := l_nth_id;
      l_nth.nth_theme_name := l_name;
      l_nth.nth_table_name := p_table_name;
      l_nth.nth_where := NULL;
      l_nth.nth_pk_column := 'NE_ID';
    --
    -- Task ID 0107889 - Set Label Column to NE_ID for Group layer base table themes
    -- 05/10/09 AE Further restrict on the non DT theme 
    --
      IF p_base_table_nth IS NULL
      OR l_nth.nth_theme_name NOT LIKE '%DT'
      THEN
        l_nth.nth_label_column := 'NE_ID';
      ELSE
        l_nth.nth_label_column := 'NE_UNIQUE';
      END IF;
    --
      l_nth.nth_rse_table_name := 'NM_ELEMENTS';
      l_nth.nth_rse_fk_column := NULL;
      l_nth.nth_st_chain_column := NULL;
      l_nth.nth_end_chain_column := NULL;
      l_nth.nth_x_column := NULL;
      l_nth.nth_y_column := NULL;
      l_nth.nth_offset_field := NULL;
      l_nth.nth_feature_table := p_table_name;
      l_nth.nth_feature_pk_column := 'NE_ID';
      l_nth.nth_feature_fk_column := p_fk_column;
      l_nth.nth_xsp_column := NULL;
      l_nth.nth_feature_shape_column := p_spatial_column;
      l_nth.nth_hpr_product := 'NET';
      l_nth.nth_location_updatable := 'N';
      l_nth.nth_theme_type := 'SDO';
      l_nth.nth_dependency := 'D';
      l_nth.nth_storage := 'S';
      l_nth.nth_update_on_edit := l_immediate_or_deferred;
      l_nth.nth_use_history := 'Y';
      l_nth.nth_start_date_column := 'START_DATE';
      l_nth.nth_end_date_column := 'END_DATE';
      l_nth.nth_base_table_theme := p_base_table_nth;
      l_nth.nth_sequence_name := 'NTH_' || NVL(p_base_table_nth,retval) || '_SEQ';
      l_nth.nth_snap_to_theme := 'N';
      l_nth.nth_lref_mandatory := 'N';
      l_nth.nth_tolerance := 10;
      l_nth.nth_tol_units := 1;
      Nm3ins.ins_nth (l_nth);
      --
      --  Build theme gtype rowtype
      l_rec_ntg.ntg_theme_id := l_nth_id;
      l_rec_ntg.ntg_seq_no := 1;
      l_rec_ntg.ntg_xml_url := NULL;
      l_rec_ntg.ntg_gtype := '2002';
      Nm3ins.ins_ntg (p_rec_ntg => l_rec_ntg);

      -- generate the link
      INSERT INTO NM_AREA_THEMES
                  (nath_nat_id, nath_nth_theme_id
                  )
           VALUES (l_nat_id, l_nth_id
                  );
      create_base_themes( l_nth_id, p_base_themes );
--


      IF Hig.get_sysopt ('REGSDELAY') = 'Y'
      THEN
--         nm_debug.debug_on;
--         nm_debug.debug('** Creating SDE Layer for - '||l_nth.nth_theme_id);
         EXECUTE IMMEDIATE (   'begin '
                            || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_nth.nth_theme_id )||');'
                            || 'end;'
                           );
--         nm_debug.debug('** Done creating SDE Layer for - '||l_nth.nth_theme_id);
      END IF;

      IF p_view_flag = 'N'
      THEN
         DECLARE
            l_role   VARCHAR2 (30);
         BEGIN
            l_role := Hig.get_sysopt ('SDONETROLE');

            IF l_role IS NOT NULL
            THEN
               INSERT INTO NM_THEME_ROLES
                           (nthr_theme_id, nthr_role, nthr_mode
                           )
                    VALUES (l_nth_id, l_role, 'NORMAL'
                           );
            END IF;
         END;
      END IF;

      DECLARE
        l_type NUMBER;
      BEGIN
        IF Nm3net.get_gty_sub_group_allowed( p_gty_type ) = 'Y'
        THEN
          l_type := 3;
        ELSE
          l_type := 2;
        END IF;
        create_theme_functions( p_theme => l_nth.nth_theme_id, p_pa => g_network_modules, p_exclude => l_type );
      END;

      RETURN l_nth_id;
   END register_nat_theme;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION get_nlt_descr (p_nlt_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR c1 (c_nlt_id NUMBER)
      IS
         SELECT nlt_descr
           FROM NM_LINEAR_TYPES
          WHERE nlt_id = c_nlt_id;
      retval   NM_LINEAR_TYPES.nlt_descr%TYPE;
   BEGIN
      OPEN c1 (p_nlt_id);
      FETCH c1
       INTO retval;
      CLOSE c1;
      RETURN retval;
   END;
--
-----------------------------------------------------------------------------
--
-- Task 0108731
-- 
  FUNCTION register_ona_base_theme 
    ( pi_asset_type IN nm_inv_types.nit_inv_type%TYPE
    , pi_gtype      IN nm_theme_gtypes.ntg_gtype%TYPE
    , pi_s_date_col IN user_tab_columns.column_name%TYPE DEFAULT NULL
    , pi_e_date_col IN user_tab_columns.column_name%TYPE DEFAULT NULL)
  RETURN nm_themes_all%ROWTYPE
  IS
    l_rec_nit    nm_inv_types%ROWTYPE;
    l_rec_nth    nm_themes_all%ROWTYPE;
    l_rec_nthr   nm_theme_roles%ROWTYPE;
    l_rec_ntg    nm_theme_gtypes%ROWTYPE;
  --
    FUNCTION derive_shape_col
             ( pi_table_name IN user_tab_cols.table_name%TYPE )
    RETURN user_tab_cols.column_name%TYPE
    IS
      l_retval user_tab_cols.column_name%TYPE;
    BEGIN
     SELECT column_name INTO l_retval
        FROM user_tab_cols
       WHERE table_name = pi_table_name
         AND data_type = 'SDO_GEOMETRY';
      RETURN l_retval;
    EXCEPTION
     WHEN OTHERS
     THEN RETURN 'UNKNOWN';
    END derive_shape_col;
  --
  BEGIN
  --
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_asset_type);
  --
    l_rec_nth.nth_theme_id   := nm3seq.next_nth_theme_id_seq;
    l_rec_nth.nth_theme_name := UPPER(SUBSTR(l_rec_nit.nit_inv_type||'-'
                                ||l_rec_nit.nit_descr, 1, 26)||'_TAB');
  --
    IF l_rec_nit.nit_category = 'F'
     THEN
     -- foreign table asset type
      l_rec_nth.nth_table_name             := l_rec_nit.nit_table_name;
      l_rec_nth.nth_pk_column              := l_rec_nit.nit_foreign_pk_column;
      l_rec_nth.nth_label_column           := l_rec_nit.nit_foreign_pk_column;
      l_rec_nth.nth_feature_table          := l_rec_nit.nit_table_name;
      l_rec_nth.nth_feature_pk_column      := l_rec_nit.nit_foreign_pk_column;
      l_rec_nth.nth_feature_shape_column   := derive_shape_col (l_rec_nit.nit_table_name);
    ELSE
     -- nm_inv_items_all asset type
     l_rec_nth.nth_table_name             := l_rec_nit.nit_view_name;
     l_rec_nth.nth_pk_column              := 'IIT_NE_ID';
     l_rec_nth.nth_label_column           := 'IIT_NE_ID';
     l_rec_nth.nth_feature_table          := nm3sdm.get_ona_spatial_table (l_rec_nit.nit_inv_type);
     l_rec_nth.nth_feature_pk_column      := 'NE_ID';
     l_rec_nth.nth_feature_shape_column   := 'GEOLOC';
    END IF;
  --
    l_rec_nth.nth_dependency               := 'I';
    l_rec_nth.nth_update_on_edit           := 'N';
  --
    IF l_rec_nit.nit_use_xy = 'Y'
     THEN
    l_rec_nth.nth_x_column               := 'IIT_X';
    l_rec_nth.nth_y_column               := 'IIT_Y';
    END IF;
  --
    l_rec_nth.nth_hpr_product              := 'NET';
    l_rec_nth.nth_storage                  := 'S';
    l_rec_nth.nth_location_updatable       := 'Y';
    l_rec_nth.nth_tolerance                := 10;
    l_rec_nth.nth_tol_units                := 1;
    l_rec_nth.nth_snap_to_theme            := 'N';
    l_rec_nth.nth_lref_mandatory           := 'N';
    l_rec_nth.nth_theme_type               := 'SDO';
  -- 
    IF l_rec_nit.nit_table_name IS NULL
      THEN
      l_rec_nth.nth_use_history            := 'Y';
      l_rec_nth.nth_start_date_column      := NVL(pi_s_date_col,'START_DATE');
      l_rec_nth.nth_end_date_column        := NVL(pi_e_date_col,'END_DATE');
    ELSE
      IF (pi_s_date_col IS NOT NULL
        AND pi_e_date_col IS NOT NULL)
      THEN
        l_rec_nth.nth_use_history            := 'Y';
        l_rec_nth.nth_start_date_column      := pi_s_date_col;
        l_rec_nth.nth_end_date_column        := pi_e_date_col;
      ELSE
        l_rec_nth.nth_use_history            := 'N';
        l_rec_nth.nth_start_date_column      := NULL;
        l_rec_nth.nth_end_date_column        := NULL;
      END IF;
    END IF;
  -- Insert new theme
    nm3ins.ins_nth (l_rec_nth);
  -- Insert theme gtype
    l_rec_ntg.ntg_theme_id                 := l_rec_nth.nth_theme_id;
    l_rec_ntg.ntg_gtype                    := pi_gtype;
    l_rec_ntg.ntg_seq_no                   := 1;
    nm3ins.ins_ntg (l_rec_ntg);
  --
    RETURN l_rec_nth;
  --
  END register_ona_base_theme;
--
---------------------------------------------------------------------------------------------------
--
-- Task 0108731
--
  PROCEDURE make_ona_inv_spatial_layer (
      pi_nit_inv_type   IN nm_inv_types.nit_inv_type%TYPE,
      pi_nth_gtype      IN nm_theme_gtypes.ntg_gtype%TYPE    DEFAULT NULL,
      pi_s_date_col     IN user_tab_columns.column_name%TYPE DEFAULT NULL,
      pi_e_date_col     IN user_tab_columns.column_name%TYPE DEFAULT NULL)
   IS
   BEGIN
   --
     make_ona_inv_spatial_layer 
        ( pi_nit_inv_type => pi_nit_inv_type
        , pi_nth_theme_id => register_ona_base_theme
                               ( pi_nit_inv_type
                                ,pi_nth_gtype
                                ,pi_s_date_col
                                ,pi_e_date_col).nth_theme_id
        , pi_nth_gtype    => pi_nth_gtype );
   --
   END make_ona_inv_spatial_layer;
--
---------------------------------------------------------------------------------------------------
--
   PROCEDURE make_ona_inv_spatial_layer (
      pi_nit_inv_type   IN   nm_inv_types.nit_inv_type%TYPE,
      pi_nth_theme_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE DEFAULT NULL,
      pi_create_flag    IN   VARCHAR2 DEFAULT 'TRUE',
      pi_nth_gtype      IN   NM_THEME_GTYPES.ntg_gtype%TYPE DEFAULT NULL
   )
   /*
      Create a non-dynsegged SDO Spatial Layer for a given
        pi_nit_inv_type   => Asset Type
        pi_create_flag    => Create Asset SDO feature table
   */
   IS
      l_nit              nm_inv_types%ROWTYPE;
      l_rec_nith         NM_INV_THEMES%ROWTYPE;
      l_rec_nth          NM_THEMES_ALL%ROWTYPE;
      l_tab              VARCHAR2 (30);
      b_create_tab       BOOLEAN                   := pi_create_flag = 'TRUE';
      l_theme_id         NM_THEMES_ALL.nth_theme_id%TYPE;
      l_theme_name       NM_THEMES_ALL.nth_theme_name%TYPE;
      l_inv_seq          VARCHAR2 (30);
      l_dummy            NUMBER;
      l_base_table_nth   NM_THEMES_ALL.nth_theme_id%TYPE;
      l_rec_nth_base     NM_THEMES_ALL%ROWTYPE;
      l_start_date_col   VARCHAR2 (30);
      l_end_date_col     VARCHAR2 (30);
      l_view             VARCHAR2 (30);
      l_dt_view_pk_col   VARCHAR2 (30);
      l_base_themes      nm_theme_array;
      has_network        BOOLEAN;
      --
      FUNCTION has_nin RETURN BOOLEAN
      IS
        l_dummy VARCHAR2(10);
      BEGIN
        SELECT 'exists' INTO l_dummy FROM nm_inv_nw
         WHERE nin_nit_inv_code = pi_nit_inv_type
           AND ROWNUM = 1;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND
        THEN RETURN FALSE;
      END has_nin;
      --
      PROCEDURE create_objectid_trigger (
         pi_table_name   IN   NM_THEMES_ALL.nth_feature_table%TYPE,
         pi_theme_id     IN   NM_THEMES_ALL.nth_theme_id%TYPE
      )
      IS
         nl       VARCHAR2 (10) := CHR (10);

         CURSOR check_for_objectid (cp_table_name IN VARCHAR2)
         IS
            SELECT 'x'
              FROM user_tab_cols
             WHERE table_name = cp_table_name AND column_name = 'OBJECTID';

         l_temp   VARCHAR2 (1);
      --
      BEGIN
         --
         OPEN check_for_objectid (pi_table_name);
         FETCH check_for_objectid
          INTO l_temp;
         CLOSE check_for_objectid;

         IF l_temp IS NOT NULL
         THEN

            EXECUTE IMMEDIATE
               'CREATE OR REPLACE TRIGGER '|| pi_table_name|| '_BI_TRG'|| nl
             || 'BEFORE INSERT ON '|| pi_table_name                       || nl
             || 'FOR EACH ROW '                                           || nl
             || 'DECLARE '                                                || nl
             || '  CURSOR get_objectid '                                  || nl
             || '  IS '                                                   || nl
             || '  SELECT NTH_'|| pi_theme_id|| '_SEQ.NEXTVAL FROM DUAL; '|| nl
             || '  l_temp NUMBER; '                                       || nl
             || 'BEGIN '                                                  || nl
             || '  OPEN  get_objectid; '                                  || nl
             || '  FETCH get_objectid INTO l_temp; '                      || nl
             || '  CLOSE get_objectid; '                                  || nl
             || '  :NEW.objectid := l_temp; '                             || nl
             || 'END '||pi_table_name|| '_BI_TRG;';
         END IF;

      END create_objectid_trigger;
      --
      PROCEDURE populate_xy_sdo_data
         ( pi_asset_type IN nm_inv_types.nit_inv_type%TYPE )
      IS
--         l_rec_iit nm_inv_items%ROWTYPE;
--      BEGIN
--        FOR i IN (SELECT * FROM nm_inv_items
--                  WHERE iit_inv_type = pi_asset_type)
--        LOOP
--          BEGIN
--            Nm3sdo_Edit.process_inv_xy_update (i);
--          EXCEPTION WHEN OTHERS THEN NULL;
--          END;
--        END LOOP;
      BEGIN
        -- Task 0108731
        -- Populate the XY data using the Asset type rather than 
        -- row by row
        nm3sdo_edit.process_inv_xy_update(pi_inv_type=>pi_asset_type);
      END populate_xy_sdo_data;
      --
      PROCEDURE populate_nm_base_themes
                  (pi_nth_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
      IS
      BEGIN
        FOR i IN 1..l_base_themes.nta_theme_array.LAST
        LOOP
          INSERT INTO NM_BASE_THEMES
            (NBTH_THEME_ID, NBTH_BASE_THEME)
          VALUES
            (pi_nth_theme_id, l_base_themes.nta_theme_array(i).nthe_id);
        END LOOP;
      END populate_nm_base_themes;
      --
   --
   BEGIN
       -- AE check to make sure user is unrestricted
      IF NOT user_is_unrestricted
      THEN
        RAISE e_not_unrestricted;
      END IF;
      --
      Nm_Debug.proc_start (g_package_name, 'make_ona_inv_spatial_layer');
      --
      l_rec_nth := Nm3get.get_nth (pi_nth_theme_id => pi_nth_theme_id);
      --
      -- Task 0108890 - GIS0020 - Error when creating ONA layer
      -- Ensure the Asset views are in place
      DECLARE
        view_name user_views.view_name%TYPE;
      BEGIN
        nm3inv_view.create_inv_view(pi_nit_inv_type,TRUE,view_name);
      END;
  --
  --  Nm_Debug.debug_on;
    ---------------------------------------------------------------
    -- Validate asset type
    ---------------------------------------------------------------
      l_nit := Nm3get.get_nit (pi_nit_inv_type => pi_nit_inv_type);
    ---------------------------------------------------------------
    -- Set has network associated flag
    ---------------------------------------------------------------
      has_network := has_nin;
      IF has_network
      THEN
        l_base_themes := Get_Inv_Base_Themes ( pi_nit_inv_type );
      END IF;
---------------------------------------------------------------
-- Derive SDO table name
---------------------------------------------------------------
      IF b_create_tab
      THEN
--         Nm_Debug.DEBUG ('create table for ' || l_nit.nit_inv_type);
         l_tab := get_ona_spatial_table (l_nit.nit_inv_type);

         --
         IF     l_rec_nth.nth_use_history = 'Y'
            AND l_rec_nth.nth_start_date_column IS NOT NULL
            AND l_rec_nth.nth_end_date_column IS NOT NULL
         THEN
            l_start_date_col := l_rec_nth.nth_start_date_column;
            l_end_date_col := l_rec_nth.nth_end_date_column;
         END IF;

         --
           -- mp flag set
         create_spatial_table (l_tab, TRUE, l_start_date_col, l_end_date_col);

         -- if gtype is provided, then use it to register SDO metadata
         -- TOLERANCE???
         IF pi_nth_gtype IS NOT NULL
         THEN
--            Nm_Debug.DEBUG ('create sdo layer');
            l_dummy :=
               Nm3sdo.create_sdo_layer (pi_table_name       => l_tab,
                                        pi_column_name      => 'GEOLOC',
                                        pi_gtype            => pi_nth_gtype
                                       );
         END IF;

---------------------------------------------------------------
-- Table needs a spatial index
---------------------------------------------------------------
         create_ona_spatial_idx (pi_nit_inv_type, l_tab);
      -- Table already exists - check to see if it's registered
      ELSE
         IF pi_nth_theme_id IS NOT NULL AND pi_nth_gtype IS NOT NULL
         THEN
            IF NOT Nm3sdo.is_table_regd
                             (p_feature_table      => l_rec_nth.nth_feature_table,
                              p_col                => l_rec_nth.nth_feature_shape_column
                             )
            THEN
               l_dummy :=
                  Nm3sdo.create_sdo_layer
                       (pi_table_name       => l_rec_nth.nth_feature_table,
                        pi_column_name      => l_rec_nth.nth_feature_shape_column,
                        pi_gtype            => pi_nth_gtype
                       );
            END IF;
         END IF;
      END IF;

      --
      IF Hig.get_sysopt ('REGSDELAY') = 'Y'
      THEN
         BEGIN
         EXECUTE IMMEDIATE (   'begin '
                            || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( pi_nth_theme_id )||');'
                            || 'end;'
                           );
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;
      --
---------------------------------------------------------------
-- Populate base themes for current theme
---------------------------------------------------------------
      IF has_network
      THEN
        populate_nm_base_themes
         ( pi_nth_theme_id => pi_nth_theme_id);
      END IF;
      --
      IF pi_nth_theme_id IS NULL
      THEN
--         Nm_Debug.DEBUG ('creating theme for base table');
---------------------------------------------------------------
-- Derive theme name
---------------------------------------------------------------
         l_theme_name :=
            NVL (l_nit.nit_short_descr,
                    SUBSTR (l_nit.nit_inv_type || '-' || l_nit.nit_descr,
                            1,
                            30
                           )
                 || '_TAB'
                );
---------------------------------------------------------------
-- Create the theme for table
-- ( NM_NIT_<ASSET_TYPE>_SDO )
---------------------------------------------------------------
         l_theme_id :=
            register_ona_theme (l_nit,
                                l_tab,
                                'GEOLOC',
                                NULL,
                                SUBSTR (l_theme_name, 1, 26) || '_TAB'
                               );

         BEGIN
            IF Nm3sdo.use_surrogate_key = 'Y'
            THEN
               l_inv_seq := Nm3sdo.create_spatial_seq (pi_nth_theme_id);
               create_objectid_trigger (pi_table_name      => l_tab,
                                        pi_theme_id        => pi_nth_theme_id
                                       );
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 273,
                        pi_sqlcode      => -20001,
                        pi_supplementary_info => 'NTH_'||TO_CHAR(l_theme_id)||'_SEQ'
                       );
--             raise_application_error  (-20009, 'Error creating spatial sequence NTH_'|| l_theme_id|| '_SEQ ');
         END;
      ELSE
--         Nm_Debug.DEBUG ('base table theme exists');
--         Nm_Debug.DEBUG ('create nith');
         -- Just link the theme to the inv type
         l_rec_nith.nith_nit_id := l_nit.nit_inv_type;
         l_rec_nith.nith_nth_theme_id := pi_nth_theme_id;
         Nm3ins.ins_nith (l_rec_nith);

---------------------------------------------------------------
-- Create surrogate key sequence if needed
---------------------------------------------------------------
         BEGIN
            IF Nm3sdo.use_surrogate_key = 'Y'
            THEN
               l_inv_seq := Nm3sdo.create_spatial_seq (pi_nth_theme_id);
               create_objectid_trigger (pi_table_name      => l_tab,
                                        pi_theme_id        => pi_nth_theme_id
                                       );
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 273,
                        pi_sqlcode      => -20001
                       );
--             raise_application_error (-20009,  'Error creating spatial sequence NTH_'|| pi_nth_theme_id|| '_SEQ ' );
         END;
      END IF;

      --
      IF     l_rec_nth.nth_use_history = 'Y'
         AND l_rec_nth.nth_start_date_column IS NOT NULL
         AND l_rec_nth.nth_end_date_column IS NOT NULL
      THEN
---------------------------------------------------------------
-- Create spatial date view
---------------------------------------------------------------
--         Nm_Debug.DEBUG ('create date view');
         create_spatial_date_view (l_rec_nth.nth_feature_table,
                                   l_rec_nth.nth_start_date_column,
                                   l_rec_nth.nth_end_date_column
                                  );
---------------------------------------------------------------
-- Get rowtype of the base theme
---------------------------------------------------------------
         l_rec_nth_base := Nm3get.get_nth (pi_nth_theme_id      => pi_nth_theme_id);
---------------------------------------------------------------
-- Create theme for View
-- ( V_NM_ONA_<ASSET_TYPE>_SDO )
---------------------------------------------------------------
--         Nm_Debug.DEBUG ('create theme for date view');
         l_theme_id :=
            register_ona_theme
                 (pi_nit                => l_nit,
                  p_table_name          => 'V_'||l_rec_nth_base.nth_feature_table,
                  p_spatial_column      => l_rec_nth_base.nth_feature_shape_column,
                  p_fk_column           => l_rec_nth_base.nth_feature_pk_column,
                  p_view_flag           => 'Y',
                  p_pk_column           => l_rec_nth_base.nth_feature_pk_column,
                  p_base_table_nth      => l_rec_nth_base.nth_theme_id );

         IF NOT Nm3sdo.is_table_regd
                  (p_feature_table      =>    'V_'|| l_rec_nth_base.nth_feature_table,
                   p_col                => l_rec_nth_base.nth_feature_shape_column )
         THEN
            l_dummy :=
               Nm3sdo.create_sdo_layer
                  (pi_table_name       => 'V_'|| l_rec_nth_base.nth_feature_table,
                   pi_column_name      => l_rec_nth_base.nth_feature_shape_column,
                   pi_gtype            => pi_nth_gtype );
         END IF;

         --
         IF Hig.get_sysopt ('REGSDELAY') = 'Y'
         THEN
            BEGIN
         EXECUTE IMMEDIATE (   ' begin  '
                            || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_theme_id )||')'
                            || '; end;'
                           );
            EXCEPTION
               WHEN OTHERS
               THEN NULL;
            END;
         END IF;
      --
      END IF;

---------------------------------------------------------------
-- Populate base themes for current theme
---------------------------------------------------------------
--       IF has_network
--       THEN
--         populate_nm_base_themes
--          ( pi_nth_theme_id => l_theme_id);
--       END IF;

      IF g_date_views = 'Y'
      AND l_rec_nth.nth_use_history = 'Y'
      AND l_rec_nth.nth_start_date_column IS NOT NULL
      AND l_rec_nth.nth_end_date_column IS NOT NULL
      ---------------------------------------------------------------
      -- Create _DT view for attributes for Asset type
      ---------------------------------------------------------------
      THEN
--        Nm_Debug.DEBUG('Create inv sdo join view');
        l_view := create_inv_sdo_join_view
                 ( p_nit               => pi_nit_inv_type
                 , p_table             => l_rec_nth_base.nth_feature_table
                 , p_start_date_column => l_rec_nth_base.nth_start_date_column
                 , p_end_date_column   => l_rec_nth_base.nth_end_date_column);

        IF l_nit.nit_table_name IS NULL
        THEN
          l_dt_view_pk_col := 'IIT_NE_ID';
        ELSE
          l_dt_view_pk_col := l_rec_nth_base.nth_feature_pk_column;
        END IF;
--        Nm_Debug.DEBUG('Register joined view');
        l_theme_id := register_ona_theme
                      ( pi_nit             => l_nit
                      , p_table_name       => l_view
                      , p_spatial_column   => l_rec_nth_base.nth_feature_shape_column
                      , p_fk_column        => l_rec_nth_base.nth_feature_fk_column
                      , p_name             => RTRIM(l_rec_nth_base.nth_theme_name,'_TAB')||'_DT'
                      , p_view_flag        => 'Y'
                      , p_pk_column        => l_dt_view_pk_col
                      , p_base_table_nth   => l_rec_nth_base.nth_theme_id ) ;

         IF NOT Nm3sdo.is_table_regd
                   (p_feature_table => l_view,
                    p_col           => l_rec_nth_base.nth_feature_shape_column)
         THEN
--            Nm_Debug.DEBUG('Register joined view in SDO');
            l_dummy :=
               Nm3sdo.create_sdo_layer
                  (pi_table_name       => l_view,
                   pi_column_name      => l_rec_nth_base.nth_feature_shape_column,
                   pi_gtype            => pi_nth_gtype );
         END IF;

         --
         IF Hig.get_sysopt ('REGSDELAY') = 'Y'
         THEN
            BEGIN
                EXECUTE IMMEDIATE (   ' begin  '
                                   || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_theme_id )||');'
                                   || ' end;'
                                  );
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
---------------------------------------------------------------
-- Populate base themes for current theme
---------------------------------------------------------------
         IF has_network
         THEN
           populate_nm_base_themes
            ( pi_nth_theme_id => l_theme_id);
         END IF;
      --
      END IF;
      --
---------------------------------------------------------------
-- Populate Layer table (if any data availible)
---------------------------------------------------------------
      IF l_nit.nit_use_xy = 'Y'
      THEN
        -- Task 0108731
        -- Populate the XY data using the Asset type rather than 
        -- row by row
        populate_xy_sdo_data ( pi_asset_type => l_nit.nit_inv_type );
      END IF;

---------------------------------------------------------------
-- Create nm_base_theme entries
---------------------------------------------------------------
--       INSERT INTO nm_base_themes
--         ( nbth_theme_id, nbth_base_theme )
--       SELECT 1, t.nthe_id
--         FROM TABLE ( get_inv_base_themes ( l_nit.nit_inv_type ).nta_theme_array ) t;

---------------------------------------------------------------
-- Analyze spatial table
---------------------------------------------------------------
      BEGIN
        Nm3ddl.analyse_table (pi_table_name          => l_rec_nth.nth_feature_table
                            , pi_schema              => Sys_Context('NM3CORE','APPLICATION_OWNER')
                            , pi_estimate_percentage => NULL
                            , pi_auto_sample_size    => FALSE);
      EXCEPTION
        WHEN OTHERS
        THEN
          RAISE e_no_analyse_privs;
      END;
      --
      Nm_Debug.proc_end (g_package_name, 'make_ona_inv_spatial_layer');
   --
  EXCEPTION
    WHEN e_not_unrestricted
    THEN
      RAISE_APPLICATION_ERROR (-20777,'Restricted users are not permitted to create SDO layers');
    WHEN e_no_analyse_privs
    THEN
      RAISE_APPLICATION_ERROR (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                      'Please ensure the correct role/privs are applied to the user');
   --
   END make_ona_inv_spatial_layer;
--
---------------------------------------------------------------------------------------------------
--
   PROCEDURE make_inv_spatial_layer
                                    /*
                                        Create a dynsegged SDO Spatial layer for a given
                                          pi_nit_inv_type  => Asset type
                                          pi_create_flag   => Create Asset SDO feature table flag
                                          pi_base_layer    => Layer to dynseg to
                                    */
   (
      pi_nit_inv_type   IN   nm_inv_types.nit_inv_type%TYPE,
      pi_create_flag    IN   VARCHAR2 DEFAULT 'TRUE',
      p_job_id          IN   NUMBER DEFAULT NULL
   )
   IS
      l_nit                nm_inv_types%ROWTYPE;
      lcur                 Nm3type.ref_cursor;
      l_base               NM_THEMES_ALL.nth_theme_id%TYPE;
      l_tab                VARCHAR2 (30);
      l_base_table         VARCHAR2 (30);
      l_view               VARCHAR2 (30);
      l_inv_seq            VARCHAR2 (30);
      l_base_table_theme   NM_THEMES_ALL.nth_theme_id%TYPE;
      l_geom               MDSYS.SDO_GEOMETRY;
      l_ne                 nm_elements.ne_id%TYPE;
      l_theme_id           NM_THEMES_ALL.nth_theme_id%TYPE;
      l_base_themes        nm_theme_array;
      l_theme_name         NM_THEMES_ALL.nth_theme_name%TYPE;
      l_diminfo            mdsys.sdo_dim_array;
      l_srid               NUMBER;
      l_usgm               user_sdo_geom_metadata%ROWTYPE;
      l_themes             int_array := NM3ARRAY.INIT_INT_ARRAY;
      l_inv_view_name      VARCHAR2(30);

   BEGIN
  -- AE check to make sure user is unrestricted
    IF NOT user_is_unrestricted
    THEN
      RAISE e_not_unrestricted;
    END IF;
---------------------------------------------------------------
-- Validate asset type
---------------------------------------------------------------
      l_nit := Nm3get.get_nit (pi_nit_inv_type => pi_nit_inv_type);
---------------------------------------------------------------
-- Derive SDO table name
---------------------------------------------------------------
      l_tab := get_inv_spatial_table (l_nit.nit_inv_type);

---------------------------------------------------------------
-- Derive base layers to dynseg and Validate base layer
---------------------------------------------------------------

      l_base_themes := Get_Inv_Base_Themes( pi_nit_inv_type );

      Nm3sdo.set_diminfo_and_srid( l_base_themes, l_diminfo, l_srid );

      IF l_nit.nit_pnt_or_cont = 'P' THEN

        l_diminfo := sdo_lrs.convert_to_std_dim_array(l_diminfo);

      END IF;

      IF NOT nm3ddl.does_object_exist( nm3inv_view.derive_inv_type_view_name(pi_nit_inv_type)
                                     , 'VIEW'
                                     , Sys_Context('NM3CORE','APPLICATION_OWNER') )
      THEN
        Nm3inv_View.create_inv_view(pi_nit_inv_type, FALSE, l_inv_view_name);
      END IF;


---------------------------------------------------------------
-- Create the table and history view
---------------------------------------------------------------
      IF pi_create_flag = 'TRUE'
      THEN
         IF l_nit.nit_table_name IS NOT NULL
         THEN
--          create_spatial_table (l_tab, TRUE, 'START_DATE', 'END_DATE');
            create_spatial_table (l_tab, FALSE, 'START_DATE', 'END_DATE');
         ELSE
            create_spatial_table (l_tab, FALSE, 'START_DATE', 'END_DATE');
         END IF;
      END IF;

---------------------------------------------------------------
-- Create spatial date view
---------------------------------------------------------------
      create_spatial_date_view (l_tab);
---------------------------------------------------------------
-- Derive theme name
---------------------------------------------------------------
      l_theme_name :=
         NVL (l_nit.nit_short_descr,
              SUBSTR (l_nit.nit_inv_type || '-' || l_nit.nit_descr, 1, 30)
             );

---------------------------------------------------------------
-- Set the registration of metadata
---------------------------------------------------------------
      l_usgm.table_name  := l_tab;
   l_usgm.column_name := 'GEOLOC';
   l_usgm.diminfo     := l_diminfo;
   l_usgm.srid        := l_srid;

   Nm3sdo.ins_usgm ( l_usgm );


---------------------------------------------------------------
-- Create the theme for table
-- ( NM_NIT_<ASSET_TYPE>_SDO )
---------------------------------------------------------------
      l_theme_id :=
         register_inv_theme (pi_nit                => l_nit,
                             p_base_themes         => l_base_themes,
                             p_table_name          => l_tab,
                             p_spatial_column      => 'GEOLOC',
                             p_fk_column           => 'NE_ID',
                             p_name                =>    SUBSTR (l_theme_name,
                                                                 1,
                                                                 26
                                                                )
                                                      || '_TAB'
                            );
      l_base_table_theme := l_theme_id;
    
      l_themes.ia(1) := l_theme_id;

---------------------------------------------------------------
-- Create surrogate key sequence if needed
---------------------------------------------------------------
      IF Nm3sdo.use_surrogate_key = 'Y'
      THEN
         l_inv_seq := Nm3sdo.create_spatial_seq (l_theme_id);
      END IF;

---------------------------------------------------------------
-- Create theme for View
-- ( V_NM_NIT_<ASSET_TYPE>_SDO )
---------------------------------------------------------------
      l_theme_id := Nm3sdo.clone_layer (l_base_table_theme, 'V_' || l_tab, 'GEOLOC');

      l_theme_id :=
         register_inv_theme (pi_nit                => l_nit,
                             p_base_themes         => l_base_themes,
                             p_table_name          => 'V_' || l_tab,
                             p_spatial_column      => 'GEOLOC',
                             p_fk_column           => 'NE_ID',
                             p_name                => l_theme_name,
                             p_view_flag           => 'Y',
                             p_base_table_nth      => l_base_table_theme
                            );

      l_themes := l_themes.add_element( l_theme_id );

---------------------------------------------------------------
-- Need a join view between spatial table history view and Inv view
---------------------------------------------------------------
      l_view := create_inv_sdo_join_view (pi_nit_inv_type, l_tab);

---------------------------------------------------------------
-- Create SDO metadata for the attribute joined view
--  ( V_NM_NIT_<ASSET_TYPE>_SDO_DT )
---------------------------------------------------------------
      l_theme_id := Nm3sdo.clone_layer (l_base_table_theme, l_view, 'GEOLOC');
---------------------------------------------------------------
-- For now, register both the join view and the base layer
---------------------------------------------------------------
      l_theme_name :=
            SUBSTR (NVL (l_nit.nit_short_descr,
                         l_nit.nit_inv_type || '-' || l_nit.nit_descr
                        ),
                    1,
                    27
                   )
         || '_DT';

---------------------------------------------------------------
-- Make the view layer dependent on the parent asset shape
---------------------------------------------------------------
      IF g_date_views = 'Y'
      THEN
         l_theme_id :=
            register_inv_theme (pi_nit                => l_nit,
                                p_base_themes         => l_base_themes,
                                p_table_name          => l_view,
                                p_spatial_column      => 'GEOLOC',
                                p_fk_column           => 'IIT_NE_ID',
                                p_name                => l_theme_name,
                                p_view_flag           => 'Y',
                                p_pk_column           => 'IIT_NE_ID',
                                p_base_table_nth      => l_base_table_theme
                               );

                 l_themes := l_themes.add_element( l_theme_id );
                 
      END IF;
---------------------------------------------------------------
-- Populate the SDO table and create (clone) the SDO metadata
-- for table and date tracked view
--   (   NM_NIT_<ASSET_TYPE>_SDO )
--   ( V_NM_NIT_<ASSET_TYPE>_SDO )
---------------------------------------------------------------

      IF pi_create_flag = 'TRUE'
      THEN
         Nm3sdo.create_inv_data (p_table_name      => l_tab,
                                 p_inv_type        => pi_nit_inv_type,
                                 p_seq_name        => l_inv_seq,
         p_pnt_or_cont     => l_nit.nit_pnt_or_cont,
         p_job_id          => p_job_id
                                        );

      END IF;
---------------------------------------------------------------
-- Table needs a spatial index
---------------------------------------------------------------
      create_inv_spatial_idx (pi_nit_inv_type, l_tab);
---------------------------------------------------------------
-- Analyze spatial table
---------------------------------------------------------------
--    EXECUTE IMMEDIATE 'analyze table ' || l_tab || ' compute statistics';
      BEGIN
        Nm3ddl.analyse_table (pi_table_name          => l_tab
                            , pi_schema              => Sys_Context('NM3CORE','APPLICATION_OWNER')
                            , pi_estimate_percentage => NULL
                            , pi_auto_sample_size    => FALSE);
      EXCEPTION
        WHEN OTHERS
        THEN
          RAISE e_no_analyse_privs;
      END;

    /*  IF NM3SDO_DYNSEG.G_USE_OFFSET then
        update nm_themes_all
        set nth_xsp_column = 'IIT_X_SECT'
        where nth_theme_id in ( select column_value from table ( l_themes.ia ) );
        
        NM3SDO_DYNSEG.SET_OFFSET_FLAG_OFF;
        
      END IF;*/
    
      --
      Nm_Debug.proc_end (g_package_name, 'make_ona_inv_spatial_layer');
   --
  EXCEPTION
    WHEN e_not_unrestricted
    THEN
      RAISE_APPLICATION_ERROR (-20777,'Restricted users are not permitted to create SDO layers');
    WHEN e_no_analyse_privs
    THEN
      RAISE_APPLICATION_ERROR (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                      'Please ensure the correct role/privs are applied to the user');

   END make_inv_spatial_layer;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION get_datum_layer_from_gty (
      p_gty   IN   NM_LINEAR_TYPES.nlt_gty_type%TYPE
   )
      RETURN nm_theme_array
   IS
      retval   nm_theme_array := Nm3array.INIT_NM_THEME_ARRAY;

      CURSOR c1 (c_gty NM_LINEAR_TYPES.nlt_gty_type%TYPE)
      IS
         SELECT nm_theme_entry(nnth_nth_theme_id)
           FROM NM_NW_THEMES nnt,
                NM_LINEAR_TYPES nlt,
                NM_NT_GROUPINGS_ALL nng
          WHERE nlt.nlt_id = nnt.nnth_nlt_id
            AND nlt.nlt_nt_type = nng.nng_nt_type
            AND nng.nng_group_type = c_gty;
   BEGIN
      OPEN c1 (p_gty);

      FETCH c1 BULK COLLECT INTO retval.nta_theme_array;

      CLOSE c1;

      IF retval.nta_theme_array(1).nthe_id IS NULL THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 195,
                        pi_sqlcode      => -20001
                       );
      --    raise_application_error( -20001, 'No datum theme found');
      END IF;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------
--
  PROCEDURE make_datum_layer_dt
                                ( pi_nth_theme_id       IN NM_THEMES_ALL.nth_theme_id%TYPE
                                , pi_new_feature_table  IN NM_THEMES_ALL.nth_feature_table%TYPE DEFAULT NULL)
  IS
    ---------------------------------------------------------------------------
   /* This procedure is designed to create a date tracked view of a given Datum
      SDO layer.
      It creates the view, metadata, theme. Renames base table to _TABLE.
      This is required so that MSV can display current shapes, as it is unable
      to perform a join back to nm_elements
   */
    ---------------------------------------------------------------------------
  --
    e_not_datum_layer       EXCEPTION;
    e_new_ft_exists         EXCEPTION;
    e_already_base_theme    EXCEPTION;
    e_used_as_base_theme    EXCEPTION;
  --
    lf                      VARCHAR2(5) := CHR(10);
    l_new_table_name        NM_THEMES_ALL.nth_feature_table%TYPE;
    l_view_sql              Nm3type.max_varchar2;
    l_rec_nth               NM_THEMES_ALL%ROWTYPE;
    l_rec_new_nth           NM_THEMES_ALL%ROWTYPE;
    l_rec_nthr              NM_THEME_ROLES%ROWTYPE;
  --
    FUNCTION is_datum_layer
               ( pi_nth_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE ) RETURN BOOLEAN
    IS
      l_dummy PLS_INTEGER;
    BEGIN
    --
      SELECT nth_theme_id INTO l_dummy FROM NM_THEMES_ALL
       WHERE EXISTS
         (SELECT 1 FROM NM_NW_THEMES
           WHERE nth_theme_id = nnth_nth_theme_id
             AND EXISTS
            (SELECT 1 FROM NM_LINEAR_TYPES
              WHERE nlt_id = nnth_nlt_id
                AND nlt_g_i_d = 'D'))
         AND nth_theme_id = pi_nth_theme_id;
    --
      RETURN TRUE;
    --
    EXCEPTION
      WHEN NO_DATA_FOUND
        THEN RETURN FALSE;
      WHEN OTHERS
        THEN RAISE;
    END is_datum_layer;
  --
    FUNCTION used_as_a_base_theme (pi_theme_id IN nm_themes_all.nth_theme_id%TYPE)
    RETURN BOOLEAN
    IS
      l_dummy NUMBER;
    BEGIN
      SELECT count(*) INTO l_dummy FROM nm_themes_all
       WHERE nth_base_table_theme = pi_theme_id;
      IF l_dummy > 0
        THEN RETURN TRUE;
        ELSE RETURN FALSE;
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN RETURN FALSE;
    END used_as_a_base_theme;
  --
  BEGIN
    ---------------------------------------------------------------------------
    -- Check to make sure user is unrestricted
    ---------------------------------------------------------------------------
    IF NOT user_is_unrestricted
    THEN
      RAISE e_not_unrestricted;
    END IF;

    ---------------------------------------------------------------------------
    -- Make sure theme passed in is a datum layer
    ---------------------------------------------------------------------------
    l_rec_nth := Nm3get.get_nth ( pi_nth_theme_id => pi_nth_theme_id );

    IF NOT is_datum_layer ( pi_nth_theme_id )
    THEN
      RAISE e_not_datum_layer;
    END IF;

    ---------------------------------------------------------------------------
    -- Check to make sure the Theme passed in a view based theme!
    ---------------------------------------------------------------------------
    IF l_rec_nth.nth_base_table_theme IS NOT NULL
    THEN
      RAISE e_already_base_theme;
    END IF;

    IF used_as_a_base_theme ( pi_nth_theme_id )
    THEN
      RAISE e_used_as_base_theme;
    END IF;
  --
    ---------------------------------------------------------------------------
    -- Rename datum table
    ---------------------------------------------------------------------------
    l_new_table_name := NVL( pi_new_feature_table, UPPER(l_rec_nth.nth_feature_table)||'_TABLE');

    IF Nm3ddl.does_object_exist (l_new_table_name)
    THEN
      RAISE e_new_ft_exists;
    END IF;

    EXECUTE IMMEDIATE
      'RENAME '||l_rec_nth.nth_feature_table||' TO '||l_new_table_name;

    ---------------------------------------------------------------------------
    --Create SDO metadata for renamed feature table
    ---------------------------------------------------------------------------
    EXECUTE IMMEDIATE
      'INSERT INTO user_sdo_geom_metadata'||lf||
      ' (SELECT '||Nm3flx.string(l_new_table_name)||lf||
      '       , column_name, diminfo, srid '||lf||
      '    FROM user_sdo_geom_metadata '||lf||
      '   WHERE table_name  = '||Nm3flx.string(l_rec_nth.nth_feature_table)||lf||
      '     AND column_name = '||Nm3flx.string(l_rec_nth.nth_feature_shape_column)||')';

    ---------------------------------------------------------------------------
    -- Create date based view
    ---------------------------------------------------------------------------
    l_view_sql :=
      'CREATE OR REPLACE FORCE VIEW '||l_rec_nth.nth_feature_table||lf||
      'AS'||lf||
      'SELECT sdo.*'||lf||
      '  FROM '||l_new_table_name||' sdo '||lf||
      ' WHERE EXISTS ( SELECT 1 FROM nm_elements ne '||lf||
                      ' WHERE ne.ne_id = sdo.'||l_rec_nth.nth_feature_pk_column||')';

    --Nm3ddl.create_object_and_syns( l_rec_nth.nth_feature_table, l_view_sql);
    EXECUTE IMMEDIATE l_view_sql;

    ---------------------------------------------------------------------------
    -- Create new theme - but to maintain foreign keys, we need to update the old one
    -- so that it points to the new feature table using base theme
    ---------------------------------------------------------------------------

    l_rec_new_nth                    := l_rec_nth;
    l_rec_new_nth.nth_theme_id       := Nm3seq.next_nth_theme_id_seq;
    l_rec_new_nth.nth_theme_name     := l_rec_new_nth.nth_theme_name||'_TAB';
    l_rec_new_nth.nth_feature_table  := l_new_table_name;

    Nm3ins.ins_nth(l_rec_new_nth);

    INSERT INTO NM_NW_THEMES
      ( nnth_nlt_id, nnth_nth_theme_id )
    SELECT nnth_nlt_id, l_rec_new_nth.nth_theme_id
      FROM nm_nw_themes
     WHERE nnth_nth_theme_id = l_rec_nth.nth_theme_id;

    ---------------------------------------------------------------------------
    -- Update (now the) view theme to point to new table
    ---------------------------------------------------------------------------
    BEGIN
      UPDATE NM_THEMES_ALL
         SET nth_base_table_theme = l_rec_new_nth.nth_theme_id
       WHERE nth_theme_id = pi_nth_theme_id;
    EXCEPTION
      WHEN OTHERS
        THEN RAISE;
    END;

    ---------------------------------------------------------------------------
    --  Update the NM_BASE_THEME record to point at the base table theme
    --  where the base theme is incorrectly set to a view based theme
    ---------------------------------------------------------------------------
    UPDATE nm_base_themes
       SET nbth_base_theme =(SELECT nth_base_table_theme
                               FROM nm_themes_all
                              WHERE nth_theme_id = nbth_base_theme)
     WHERE EXISTS
      (SELECT 1 FROM nm_themes_all
        WHERE nth_theme_id = nbth_base_theme
          AND nth_base_table_theme IS NOT NULL);

    ---------------------------------------------------------------------------
    -- Create SDE layer if needed
    ---------------------------------------------------------------------------
    IF Hig.get_user_or_sys_opt('REGSDELAY') = 'Y'
    THEN
         EXECUTE IMMEDIATE (   ' begin  '
                            || '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR( l_rec_new_nth.nth_theme_id )||')'
                            || '; end;'
                           );
    END IF;

    ---------------------------------------------------------------------------
    -- Touch the nm_theme_roles to action creation of subuser views + metadata
    ---------------------------------------------------------------------------
    UPDATE nm_theme_roles
       SET nthr_role = nthr_role
     WHERE nthr_theme_id = pi_nth_theme_id;

  --
  EXCEPTION
    WHEN e_not_datum_layer
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 274,
                        pi_sqlcode      => -20001,
                        pi_supplementary_info => l_rec_nth.nth_theme_name
                       );
    WHEN e_new_ft_exists
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 275,
                        pi_sqlcode      => -20001,
                        pi_supplementary_info => l_new_table_name
                       );
    WHEN e_already_base_theme
      THEN
       RAISE_APPLICATION_ERROR(-20101 ,l_rec_nth.nth_Theme_name||' is not a base table theme');

    WHEN e_used_as_base_theme
      THEN
      RAISE_APPLICATION_ERROR(-20102 ,pi_nth_theme_id||' is already setup as a base table theme');

    WHEN OTHERS
      THEN

      BEGIN
        EXECUTE IMMEDIATE
         'RENAME '||l_new_table_name||' to '||l_rec_nth.nth_feature_table;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    --
      BEGIN
        EXECUTE IMMEDIATE
         'DROP VIEW '||l_rec_nth.nth_feature_table;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    --
      BEGIN
        DELETE FROM user_sdo_geom_metadata
         WHERE table_name = l_new_table_name
           AND column_name = l_rec_nth.nth_feature_shape_column;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    --
      RAISE;
  --
  END make_datum_layer_dt;
--
---------------------------------------------------------------------------------------------------
--
  PROCEDURE make_all_datum_layers_dt
  IS
  BEGIN
    FOR i IN (SELECT *
                FROM NM_THEMES_ALL a
               WHERE EXISTS
               (SELECT 1 FROM NM_NW_THEMES
                 WHERE a.nth_theme_id = nnth_nth_theme_id
                   AND EXISTS
                  (SELECT 1 FROM NM_LINEAR_TYPES
                    WHERE nlt_id = nnth_nlt_id
                      AND nlt_g_i_d = 'D'))
                 AND a.nth_base_table_theme IS NULL
                 -- AE
                 -- Make sure we don't pick up themes that are already
                 -- used as base table themes - i.e. they don't need this
                 -- running again !
                 AND NOT EXISTS
                   (SELECT 1 FROM nm_themes_all z
                     WHERE a.nth_theme_id = z.nth_base_table_theme)
              )
    LOOP
      make_datum_layer_dt ( pi_nth_theme_id => i.nth_theme_id );
    END LOOP;
  END make_all_datum_layers_dt;
--
---------------------------------------------------------------------------------------------------
--
   FUNCTION get_datum_layer_from_route (p_ne_id IN nm_elements.ne_id%TYPE)
      RETURN nm_theme_array
   IS
   BEGIN
      RETURN get_datum_layer_from_gty
                                    (Nm3get.get_ne (p_ne_id).ne_gty_group_type
                                    );
   END;

-----------------------------------------------------------------------------
   FUNCTION get_datum_layer_from_nlt (p_nlt_id IN NM_LINEAR_TYPES.nlt_id%TYPE)
      RETURN nm_theme_array
   IS
      nltrow   NM_LINEAR_TYPES%ROWTYPE   := Nm3get.get_nlt (p_nlt_id);
   BEGIN
      RETURN get_datum_layer_from_gty (nltrow.nlt_gty_type);
   END;

-----------------------------------------------------------------------------
   FUNCTION element_exists_in_theme (
      p_ne_id               IN   nm_elements.ne_id%TYPE,
      p_feature_table       IN   VARCHAR2,
      p_feature_fk_column   IN   VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION element_exists_in_theme (
      p_ne_id               IN   nm_elements.ne_id%TYPE,
      p_feature_table       IN   VARCHAR2,
      p_feature_fk_column   IN   VARCHAR2
   )
      RETURN BOOLEAN
   IS
      TYPE curtyp IS REF CURSOR;

      in_theme     curtyp;
      cur_string   VARCHAR2 (2000)
         :=    'select 1 from '
            || p_feature_table
            || ' where '
            || p_feature_fk_column
            || ' = :c_ne_id';
      l_dummy      NUMBER;
      retval       BOOLEAN;
   BEGIN
      OPEN in_theme FOR cur_string USING p_ne_id;

      FETCH in_theme
       INTO l_dummy;

      retval := in_theme%FOUND;

      CLOSE in_theme;

      RETURN retval;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION prevent_operation (p_ne_id IN nm_elements.ne_id%TYPE)
      RETURN BOOLEAN
   IS
      retval   BOOLEAN := FALSE;

      -- look for an independent SDE theme for this network type
      CURSOR c2 (c_ne_id IN nm_elements.ne_id%TYPE)
      IS
         SELECT nth.nth_theme_id, nth.nth_feature_table,
                nth.nth_feature_fk_column
           FROM NM_NW_THEMES nwt,
                NM_ELEMENTS_ALL ne,
                NM_THEMES_ALL nth,
                NM_LINEAR_TYPES nlt
          WHERE ne.ne_id = c_ne_id
            AND nwt.nnth_nlt_id = nlt.nlt_id
            AND nwt.nnth_nth_theme_id = nth.nth_theme_id
            AND nlt.nlt_nt_type = ne.ne_nt_type
            AND DECODE (nlt.nlt_g_i_d,
                        'D', 'NOT_USED',
                        'G', ne.ne_gty_group_type
                       ) =
                   DECODE (nlt.nlt_g_i_d,
                           'D', 'NOT_USED',
                           'G', nlt.nlt_gty_type
                          )
            AND nth.nth_theme_type = 'SDE'
            AND nth.nth_storage = 'S'
            AND nth.nth_dependency = 'I';
   --
   BEGIN
      FOR irec IN c2 (p_ne_id)
      LOOP
         IF element_exists_in_theme
                           (p_ne_id                  => p_ne_id,
                            p_feature_table          => irec.nth_feature_table,
                            p_feature_fk_column      => irec.nth_feature_fk_column
                           )
         THEN
            retval := TRUE;
            EXIT;
         END IF;
      END LOOP;

      RETURN retval;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE remove_element_shapes (p_ne_id IN nm_elements.ne_id%TYPE)
   IS
      --
      CURSOR get_theme (c_ne_id IN nm_elements.ne_id%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column
           FROM NM_THEMES_ALL, NM_NW_THEMES, NM_LINEAR_TYPES, nm_elements
          WHERE nlt_id = nnth_nlt_id
            AND nth_theme_id = nnth_nth_theme_id
            AND nlt_nt_type = ne_nt_type
            AND NVL (nlt_gty_type, Nm3type.get_nvl) =
                                      NVL (ne_gty_group_type, Nm3type.get_nvl)
            AND ne_id = c_ne_id;
   --
   BEGIN
      --
      FOR irec IN get_theme (p_ne_id)
      LOOP
         --
         EXECUTE IMMEDIATE    'DELETE FROM '
                           || irec.nth_feature_table
                           || ' WHERE '
                           || irec.nth_feature_pk_column
                           || ' = :ne_id'
                     USING p_ne_id;
      END LOOP;
   --
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE regenerate_affected_shapes (
      p_nm_type       IN   nm_members.nm_type%TYPE,
      p_nm_obj_type   IN   nm_members.nm_obj_type%TYPE,
      p_ne_id         IN   nm_elements.ne_id%TYPE
   )
   IS
      CURSOR c_inv_layers (c_nm_obj_type IN nm_members.nm_obj_type%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_shape_column,
                nth_feature_fk_column
           FROM NM_INV_THEMES, NM_THEMES_ALL
          WHERE nith_nth_theme_id = nth_theme_id
            AND nith_nit_id = c_nm_obj_type;

      CURSOR c_nw_layers (c_nm_obj_type IN nm_members.nm_obj_type%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_shape_column,
                nth_feature_fk_column
           FROM NM_NW_THEMES, NM_THEMES_ALL, NM_LINEAR_TYPES
          WHERE nnth_nth_theme_id = nth_theme_id
            AND nlt_id = nnth_nlt_id
            AND nlt_gty_type = c_nm_obj_type;

      inv_upd   VARCHAR2 (2000)
         :=    'update :table_name '
            || 'set :shape_col = nm3sdm.get_shape_from_ne( :ne_id ) '
            || 'where :ne_col = :ne_id';
      nw_upd    VARCHAR2 (2000)
         :=    'update :table_name '
            || 'set :shape_col = nm3sdm.get_route_shape( :ne_id ) '
            || 'where :ne_col = :ne_id';
   BEGIN
      IF p_nm_type = 'I'
      THEN
         FOR irec IN c_inv_layers (p_nm_obj_type)
         LOOP
            EXECUTE IMMEDIATE inv_upd
                        USING irec.nth_feature_table,
                              irec.nth_feature_shape_column,
                              p_ne_id,
                              irec.nth_feature_fk_column,
                              p_ne_id;
         END LOOP;
      ELSE
         FOR irec IN c_nw_layers (p_nm_obj_type)
         LOOP
            EXECUTE IMMEDIATE nw_upd
                        USING irec.nth_feature_table,
                              irec.nth_feature_shape_column,
                              p_ne_id,
                              irec.nth_feature_fk_column,
                              p_ne_id;
         END LOOP;
      END IF;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION get_ona_spatial_table (p_nit IN nm_inv_types.nit_inv_type%TYPE)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (30) := 'NM_ONA_' || p_nit || '_SDO';
   BEGIN
      RETURN retval;
   END;

--
-------------------------------------------------------------------------------------------------------
--
   FUNCTION get_inv_spatial_table (p_nit IN nm_inv_types.nit_inv_type%TYPE)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (30) := 'NM_NIT_' || p_nit || '_SDO';
   BEGIN
      RETURN retval;
   END;

--
-------------------------------------------------------------------------------------------------------
--
/*
function get_inv_spatial_seq( p_nit in nm_inv_types.nit_inv_type%type ) return varchar2 is
retval varchar2(30) := 'NM_NIT_'||p_nit||'_SDO_SEQ';
begin
  return retval;
end;

-------------------------------------------------------------------------------------------------------

function get_nlt_spatial_seq( p_nlt_id in nm_linear_types.nlt_id%type )return varchar2 is
l_nlt  nm_linear_types%rowtype;
retval varchar2(30);
begin
  l_nlt := nm3get.get_nlt( p_nlt_id );
  retval :=  'NM_NLT_'||l_nlt.nlt_nt_type||'_'||l_nlt.nlt_gty_type||'_SDO_SEQ';
  return retval;
end;
*/
-------------------------------------------------------------------------------------------------------
   PROCEDURE create_spatial_table (
      p_table               IN   VARCHAR2,
      p_mp_flag             IN   BOOLEAN DEFAULT FALSE,
      p_start_date_column   IN   VARCHAR2 DEFAULT NULL,
      p_end_date_column     IN   VARCHAR2 DEFAULT NULL
   )
   IS
      cur_string            VARCHAR2 (2000);
      con_string            VARCHAR2 (2000);
      uk_string             VARCHAR2 (2000);
      l_start_date_column   VARCHAR2 (30);
      l_end_date_column     VARCHAR2 (30);
      b_use_history         BOOLEAN;
   BEGIN
      --
      IF p_start_date_column IS NOT NULL
      THEN
         l_start_date_column := p_start_date_column;
      END IF;

      --
      IF p_end_date_column IS NOT NULL
      THEN
         l_end_date_column := p_end_date_column;
      END IF;

      --
--      Nm_Debug.DEBUG ('In create spatial table');
      --
      b_use_history :=
             l_start_date_column IS NOT NULL AND l_end_date_column IS NOT NULL;

      IF p_mp_flag
      THEN
         IF Nm3sdo.use_surrogate_key = 'N'
         THEN
            IF b_use_history
            THEN
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( ne_id number(38) not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   '
                  || l_start_date_column
                  || ' date, '
                  || l_end_date_column
                  || ' date, '
                  || 'date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
               con_string :=
                     'alter table '
                  || p_table
                  || ' ADD CONSTRAINT '
                  || p_table
                  || '_PK PRIMARY KEY '
                  || ' ( ne_id, '
                  || l_start_date_column
                  || ' start_date )';
            ELSE
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( ne_id number(38) not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
               con_string :=
                     'alter table '
                  || p_table
                  || ' ADD CONSTRAINT '
                  || p_table
                  || '_PK PRIMARY KEY '
                  || ' ( ne_id )';
            END IF;

            EXECUTE IMMEDIATE cur_string;

            EXECUTE IMMEDIATE con_string;
         ELSE   -- surrogate key = Y
            IF b_use_history
            THEN
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( objectid number(38) not null, '
                  || '   ne_id number(38) not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   '
                  || l_start_date_column
                  || ' date, '
                  || '   '
                  || l_end_date_column
                  || ' date, date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
               con_string :=
                     'alter table '
                  || p_table
                  || ' ADD CONSTRAINT '
                  || p_table
                  || '_PK PRIMARY KEY '
                  || ' ( ne_id, '
                  || l_start_date_column
                  || ' )';
            ELSE  -- no history
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( objectid number(38) not null, '
                  || '   ne_id number(38) not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
               con_string :=
                     'alter table '
                  || p_table
                  || ' ADD CONSTRAINT '
                  || p_table
                  || '_PK PRIMARY KEY '
                  || ' ( ne_id )';
            END IF; -- history

            uk_string :=
                  'alter table '
               || p_table
               || ' ADD ( CONSTRAINT '
               || p_table
               || '_UK UNIQUE '
               || ' (objectid))';
--            Nm_Debug.DEBUG (cur_string);
--            Nm_Debug.DEBUG (con_string);
--            Nm_Debug.DEBUG (uk_string);

            EXECUTE IMMEDIATE cur_string;

            EXECUTE IMMEDIATE con_string;

--          EXECUTE IMMEDIATE uk_string;
         END IF;
      ELSE --single part - assumed multi-row
         IF Nm3sdo.use_surrogate_key = 'N'
         THEN
            IF b_use_history
            THEN
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( ne_id number(38) not null, '
                  || '   ne_id_of number(9) not null, '
                  || '   nm_begin_mp number not null, '
                  || '   nm_end_mp number not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   '
                  || l_start_date_column
                  || ' date, '
                  || l_end_date_column
                  || ' date, date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
            ELSE -- no history
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( ne_id number(38) not null, '
                  || '   ne_id_of number(9) not null, '
                  || '   nm_begin_mp number not null, '
                  || '   nm_end_mp number not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
            END IF; --history

            EXECUTE IMMEDIATE cur_string;
         ELSE -- surrogate key = Y
            IF b_use_history
            THEN
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( objectid number(38) not null, '
                  || '   ne_id number(38) not null, '
                  || '   ne_id_of number(9) not null, '
                  || '   nm_begin_mp number not null, '
                  || '   nm_end_mp number not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   '
                  || l_start_date_column
                  || ' date, '
                  || l_end_date_column
                  || ' date, date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
            ELSE --no history
               cur_string :=
                     'create table '
                  || p_table
                  || ' ( objectid number(38) not null, '
                  || '   ne_id number(38) not null, '
                  || '   ne_id_of number(9) not null, '
                  || '   nm_begin_mp number not null, '
                  || '   nm_end_mp number not null, '
                  || '   geoloc mdsys.sdo_geometry not null,'
                  || '   date_created date, date_modified date,'
                  || '   modified_by varchar2(30), created_by varchar2(30) )';
            END IF; --history

            EXECUTE IMMEDIATE cur_string;
         END IF; -- surrogate key

         IF b_use_history
         THEN
            cur_string :=
                  'alter table '
               || p_table
               || ' ADD CONSTRAINT '
               || p_table
               || '_PK PRIMARY KEY '
               || ' ( ne_id, ne_id_of, nm_begin_mp, '
               || l_start_date_column
               || ' )';
         ELSE
            cur_string :=
                  'alter table '
               || p_table
               || ' ADD CONSTRAINT '
               || p_table
               || '_PK PRIMARY KEY '
               || ' ( ne_id, ne_id_of, nm_begin_mp )';
         END IF;

         EXECUTE IMMEDIATE cur_string;

         IF Nm3sdo.use_surrogate_key = 'Y'
         THEN
            cur_string :=
                  'alter table '
               || p_table
               || ' ADD ( CONSTRAINT '
               || p_table
               || '_UK UNIQUE '
               || ' ( objectid ))';

          EXECUTE IMMEDIATE cur_string;

         END IF; -- surrogate key

         cur_string := 'create index '|| p_table
                    || '_NW_IDX'|| ' on '|| p_table|| ' ( ne_id_of, nm_begin_mp )';

         EXECUTE IMMEDIATE cur_string;

      END IF; --single-part or multi-part
   --
   END create_spatial_table;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE create_spatial_date_view (
      p_table            IN   VARCHAR2,
      p_start_date_col   IN   VARCHAR2 DEFAULT NULL,
      p_end_date_col     IN   VARCHAR2 DEFAULT NULL
   )
   IS
      cur_string         VARCHAR2 (2000);
      l_start_date_col   VARCHAR2 (30)   := 'start_date';
      l_end_date_col     VARCHAR2 (30)   := 'end_date';
   BEGIN
      --
      IF p_start_date_col IS NOT NULL
      THEN
         l_start_date_col := p_start_date_col;
      END IF;

      IF p_end_date_col IS NOT NULL
      THEN
         l_end_date_col := p_end_date_col;
      END IF;

      --
      cur_string :=
            'create or replace force view v_'
         || p_table
         || ' as select * from '
         || p_table
         || ' where  '
         || l_start_date_col
         || ' <= (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) '
         || ' and  NVL('
         || l_end_date_col
         || ',TO_DATE('
         || qq
         || '99991231'
         || qq
         || ','
         || qq
         || 'YYYYMMDD'
         || qq
         || ')) > (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual)';
      --
      -- AE 23-SEP-2008
      -- We will now use views instead of synonyms to provide subordinate user access
      -- to spatial objects
      -- CWS 0108742 Change back to using synonyms
      Nm3ddl.create_object_and_syns( 'V_'||p_table, cur_string );
      --nm3ddl.create_object_and_views ('V_'||p_table, cur_string);
   --
   EXCEPTION
      WHEN OTHERS
      THEN
--         Nm_Debug.DEBUG (cur_string);
         RAISE;
   --RAISE_APPLICATION_ERROR (-20201,'Error creating spatial date view '||p_table);
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE create_inv_spatial_idx (
      p_nit     IN   nm_inv_types.nit_inv_type%TYPE,
      p_table   IN   VARCHAR2
   )
   IS
--bug in oracle 8 - spatial index name can only be 18 chars
      cur_string   VARCHAR2 (2000);
   BEGIN
      cur_string :=
            'create index NIT_'
         || p_nit
         || '_spidx on '
         || p_table
         || ' ( geoloc ) indextype is mdsys.spatial_index'
         || ' parameters ('
         || ''''
         || 'sdo_indx_dims=2'
         || ''''
         || ')';

/*
  if substr(nm3context.get_context(nm3context.get_namespace, 'DB_VERSION'), 1, 1 ) = '8' then
    cur_string := cur_string||' parameters ('||''''||'sdo_level=6'||''''||')';
  end if;
*/
--  nm_debug.debug_on;
--  nm_debug.debug( cur_string );
--  nm_debug.debug_off;

      EXECUTE IMMEDIATE cur_string;
   END;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE create_ona_spatial_idx (
      p_nit     IN   nm_inv_types.nit_inv_type%TYPE,
      p_table   IN   VARCHAR2
   )
   IS
--bug in oracle 8 - spatial index name can only be 18 chars
      cur_string   VARCHAR2 (2000);
   BEGIN
      cur_string :=
            'create index ONA_'
         || p_nit
         || '_spidx on '
         || p_table
         || ' ( geoloc ) indextype is mdsys.spatial_index'
         || ' parameters ('
         || ''''
         || 'sdo_indx_dims=2'
         || ''''
         || ')';
      EXECUTE IMMEDIATE cur_string;
   END;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION create_inv_sdo_join_view (
      p_nit               IN   nm_inv_types.nit_inv_type%TYPE,
      p_table             IN   VARCHAR2
    , p_start_date_column IN VARCHAR2 DEFAULT NULL
    , p_end_date_column   IN VARCHAR2 DEFAULT NULL

   )
      RETURN VARCHAR2
   IS
      cur_string   VARCHAR2 (2000);
      l_inv        VARCHAR2 (30);
      l_nit        nm_inv_types%ROWTYPE   := Nm3get.get_nit (p_nit);
      l_obj        VARCHAR2 (30);
      s_col_list   VARCHAR2 (100)         := 's.geoloc';
      l_start_date_column VARCHAR2(30)    := NVL(p_start_date_column,'start_date');
      l_end_date_column   VARCHAR2(30)    := NVL(p_end_date_column,'end_date');
   BEGIN
    --
      IF Nm3sdo.use_surrogate_key = 'Y'
      THEN
         s_col_list := 's.objectid, s.geoloc';
      END IF;

      IF Nm3sdo.single_shape_inv = 'Y' OR l_nit.nit_table_name IS NOT NULL
      THEN
         IF l_nit.nit_table_name IS NULL
         THEN
            l_inv :=
                 Nm3inv_View.derive_inv_type_view_name (pi_inv_type      => p_nit);
            cur_string :=
                  'create or replace view v_'
               || p_table
               || '_DT as select i.*, '
               || s_col_list
               || '  from '
               || l_inv
               || ' i,'
               || p_table
               || ' s where i.iit_ne_id = s.ne_id '
               || ' and s.'||l_start_date_column||' <= (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) '
               || ' and  NVL(s.'||l_end_date_column||',TO_DATE('
               || qq
               || '99991231'
               || qq
               || ','
               || qq
               || 'YYYYMMDD'
               || qq
               || ')) > (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) ';
         ELSE
            l_inv := l_nit.nit_table_name;
            cur_string :=
                  'create or replace view v_'
               || p_table
               || '_DT as select i.*, '
               || s_col_list
               || ' from '
               || l_inv
               || ' i,'
               || p_table
               || ' s where i.'
               || l_nit.nit_foreign_pk_column
               || ' = s.ne_id '
               || ' and s.'||l_start_date_column||' <= (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) '
               || ' and  NVL(s.'||l_end_date_column||',TO_DATE('
               || qq
               || '99991231'
               || qq
               || ','
               || qq
               || 'YYYYMMDD'
               || qq
               || ')) > (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) ';
         END IF;
      ELSE
         -- AE
         -- Remove the use of Network joined Inventory view as this is NOT keypreserved.
         -- This causes problems in Oracle Mapviewer, where it expects a keypreserved object registered
         -- as an SDO layer. This fix would involve joining to the non-network attribute inventory view.
         -- Downside is, we loose the extra Route attributes

         --      l_inv := nm3inv_view.DERIVE_NW_INV_TYPE_VIEW_NAME( PI_INV_TYPE=>p_nit);
--
--      cur_string := 'create or replace view v_'||p_table||'_DT as select i.*, '||s_col_list||' from '||
--                     l_inv||' i,'||
--                     p_table||' s where i.iit_ne_id = s.ne_id '||
--                     ' and i.ne_id_of = s.ne_id_of '||
--                     ' and i.nm_begin_mp = s.nm_begin_mp '||
--                     ' and s.start_date <= nm3context.get_effective_date '||
--                     ' and  NVL(s.end_date,TO_DATE('||qq||'99991231'||qq||
--                            ','||qq||'YYYYMMDD'||qq||')) > nm3context.get_effective_date';
         l_inv :=  Nm3inv_View.derive_inv_type_view_name (pi_inv_type      => p_nit);
         cur_string :=
               'create or replace view v_'
            || p_table
            || '_DT as select i.*, '
            || s_col_list
            || '  from '
            || l_inv
            || ' i,'
            || p_table
            || ' s where i.iit_ne_id = s.ne_id '
            || ' and s.'||l_start_date_column||' <= (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) '
            || ' and  NVL(s.'||l_end_date_column||',TO_DATE('
            || qq
            || '99991231'
            || qq
            || ','
            || qq
            || 'YYYYMMDD'
            || qq
            || ')) > (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual)';
      END IF;

--    execute immediate cur_string;

      --Nm3ddl.create_object_and_syns ('V_' || p_table || '_DT', cur_string);

      -- AE 23-SEP-2008
      -- We will now use views instead of synonyms to provide subordinate user access
      -- to spatial objects
      --nm3ddl.create_object_and_views ('V_'||p_table||'_DT', cur_string);
      -- CWS 0108742 Change back to using synonyms
      Nm3ddl.create_object_and_syns( 'V_'||p_table||'_DT', cur_string );
      
      RETURN 'V_' || p_table || '_DT';

   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION get_nlt_spatial_table (p_nlt IN NM_LINEAR_TYPES%ROWTYPE)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (30);
   BEGIN
      retval := 'NM_NLT_' || p_nlt.nlt_nt_type;

      IF p_nlt.nlt_gty_type IS NOT NULL
      THEN
         retval := retval || '_' || p_nlt.nlt_gty_type;
      END IF;

      retval := retval || '_SDO';
      RETURN retval;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION get_nt_spatial_table (
      p_nt_type    IN   NM_TYPES.nt_type%TYPE,
      p_gty_type   IN   nm_group_types.ngt_group_type%TYPE DEFAULT NULL
   )
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (30);
   BEGIN
      retval := 'NM_NLT_' || p_nt_type;

      IF p_gty_type IS NOT NULL
      THEN
         retval := retval || '_' || p_gty_type;
      END IF;

      retval := retval || '_SDO';
      RETURN retval;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION get_nt_view_name (
      p_nt_type    IN   NM_TYPES.nt_type%TYPE,
      p_gty_type   IN   nm_group_types.ngt_group_type%TYPE
   )
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_gty_type IS NOT NULL
      THEN
        RETURN 'V_NM_' || p_nt_type ||'_'|| p_gty_type|| '_NT';
      ELSE
        RETURN 'V_NM_' || p_nt_type || '_NT';
      END IF;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE create_nlt_spatial_idx (
      p_nlt     IN   NM_LINEAR_TYPES%ROWTYPE,
      p_table   IN   VARCHAR2
   )
   IS
--bug in oracle 8 - spatial index name can only be 18 chars
--best kept to a quadtree in Oracle 8, Rtree in 9i
      cur_string   VARCHAR2 (2000);
   BEGIN
      cur_string :=
            'create index NLT_'
         || p_nlt.nlt_nt_type
         || '_'
         || p_nlt.nlt_gty_type
         || '_spidx on '
         || p_table
         || ' ( geoloc ) indextype is mdsys.spatial_index';               --||

--                ' parameters ('||''''||'sdo_level=6'||''''||')';

      /*
  if substr(nm3context.get_context(nm3context.get_namespace, 'DB_VERSION'), 1, 1 ) = '8' then
    cur_string := cur_string||' parameters ('||''''||'sdo_level=6'||''''||')';
  end if;
*/
      EXECUTE IMMEDIATE cur_string;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
      FUNCTION create_nlt_sdo_join_view (
      p_nlt     IN   NM_LINEAR_TYPES%ROWTYPE,
      p_table   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      cur_string   VARCHAR2 (2000);
      s_col_list   VARCHAR2 (100)  := 's.geoloc';
   BEGIN
      IF Nm3sdo.use_surrogate_key = 'Y'
      THEN
         s_col_list := 's.objectid, s.geoloc';
      END IF;

      cur_string :=
            'create or replace view v_'
         || p_table
         || '_DT as select n.*, '
         || s_col_list
         || ' from '
         || ' V_NM_'
         || p_nlt.nlt_nt_type
         || '_'
         || p_nlt.nlt_gty_type
         || '_NT'
         || ' n,'
         || p_table
         || ' s where n.ne_id = s.ne_id '
         || ' and s.start_date <= (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) '
         || ' and  NVL(s.end_date,TO_DATE('
         || qq
         || '99991231'
         || qq
         || ','
         || qq
         || 'YYYYMMDD'
         || qq
         || ')) > (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual)';

--      IF p_nlt.nlt_gty_type IS NOT NULL
--      THEN
--         cur_string :=
--               cur_string
--            || ' and n.ne_gty_group_type = '
--            || ''''
--            || p_nlt.nlt_gty_type
--            || '''';
--      END IF;

--         Nm_Debug.debug_on;
--         Nm_Debug.DEBUG( cur_string );
--      Nm3ddl.create_object_and_syns ('V_' || p_table || '_DT', cur_string);

      -- AE 23-SEP-2008
      -- We will now use views instead of synonyms to provide subordinate user access
      -- to spatial objects
      --nm3ddl.create_object_and_views ('V_'||p_table||'_DT', cur_string);
      -- CWS 0108742 Change back to using synonyms
      Nm3ddl.create_object_and_syns( 'V_'||p_table||'_DT', cur_string );
--  execute immediate cur_string;
  --   nm_debug.debug_off;
      RETURN 'V_' || p_table || '_DT';
   END;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION inv_has_shape (
      p_ne_id      IN   nm_elements.ne_id%TYPE,
      p_obj_type   IN   nm_members.nm_obj_type%TYPE
   )
      RETURN BOOLEAN
   IS
      CURSOR c_inv (c_nit_type IN nm_inv_types.nit_inv_type%TYPE)
      IS
         SELECT a.nith_nth_theme_id nth_theme_id
           FROM NM_INV_THEMES a
          WHERE a.nith_nit_id = c_nit_type;

      nthrec       NM_THEMES_ALL%ROWTYPE;
      rcur         Nm3type.ref_cursor;
      cur_string   VARCHAR2 (2000);
      dummy        INTEGER;
      retval       BOOLEAN                 := FALSE;
   BEGIN
      FOR irec IN c_inv (p_obj_type)
      LOOP
         nthrec := get_nth (irec.nth_theme_id);

         IF Nm3ddl.does_object_exist
                                   (p_object_name      => nthrec.nth_feature_table)
         THEN
            cur_string :=
                  'select 1 from '
               || nthrec.nth_feature_table
               || ' where '
               || nthrec.nth_feature_pk_column
               || ' = :ne_val';

            OPEN rcur FOR cur_string USING p_ne_id;

            FETCH rcur
             INTO dummy;

            IF rcur%FOUND
            THEN
               retval := TRUE;
               EXIT;
            END IF;
         END IF;
      END LOOP;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION nlt_has_shape (
      p_ne_id    IN   nm_elements.ne_id%TYPE,
      p_nlt_id   IN   NM_LINEAR_TYPES.nlt_id%TYPE
   )
      RETURN BOOLEAN
   IS
      CURSOR c_nlt (c_nlt_id IN NM_LINEAR_TYPES.nlt_id%TYPE)
      IS
         SELECT nnth.nnth_nth_theme_id nth_theme_id
           FROM NM_NW_THEMES nnth
          WHERE nnth.nnth_nlt_id = c_nlt_id;

      nthrec       NM_THEMES_ALL%ROWTYPE;
      rcur         Nm3type.ref_cursor;
      cur_string   VARCHAR2 (2000);
      dummy        INTEGER;
      retval       BOOLEAN                 := FALSE;
   BEGIN
      FOR irec IN c_nlt (p_nlt_id)
      LOOP
         nthrec := get_nth (irec.nth_theme_id);

         IF Nm3ddl.does_object_exist
                                   (p_object_name      => nthrec.nth_feature_table)
         THEN
            cur_string :=
                  'select 1 from '
               || nthrec.nth_feature_table
               || ' where '
               || nthrec.nth_feature_pk_column
               || ' = :ne_val';

            OPEN rcur FOR cur_string USING p_ne_id;

            FETCH rcur
             INTO dummy;

            IF rcur%FOUND
            THEN
               retval := TRUE;
               EXIT;
            END IF;
         END IF;
      END LOOP;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION area_has_shape (
      p_ne_id    IN   nm_elements.ne_id%TYPE,
      p_nat_id   IN   NM_AREA_TYPES.nat_id%TYPE
   )
      RETURN BOOLEAN
   IS
      CURSOR c_nat (c_nat_id IN NM_AREA_TYPES.nat_id%TYPE)
      IS
         SELECT nath.nath_nth_theme_id nth_theme_id
           FROM NM_AREA_THEMES nath
          WHERE nath.nath_nat_id = c_nat_id;

      nthrec       NM_THEMES_ALL%ROWTYPE;
      rcur         Nm3type.ref_cursor;
      cur_string   VARCHAR2 (2000);
      dummy        INTEGER;
      retval       BOOLEAN                 := FALSE;
   BEGIN
      FOR irec IN c_nat (p_nat_id)
      LOOP
         nthrec := get_nth (irec.nth_theme_id);

         IF Nm3ddl.does_object_exist
                                   (p_object_name      => nthrec.nth_feature_table)
         THEN
            cur_string :=
                  'select 1 from '
               || nthrec.nth_feature_table
               || ' where '
               || nthrec.nth_feature_pk_column
               || ' = :ne_val';

            OPEN rcur FOR cur_string USING p_ne_id;

            FETCH rcur
             INTO dummy;

            IF rcur%FOUND
            THEN
               retval := TRUE;
               EXIT;
            END IF;
         END IF;
      END LOOP;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION datum_has_shape (p_ne_id IN nm_elements.ne_id%TYPE)
      RETURN BOOLEAN
   IS
      lnerec       nm_elements%ROWTYPE     := Nm3get.get_ne (p_ne_id);

      CURSOR c_nlt (c_ne_nt_type IN NM_TYPES.nt_type%TYPE)
      IS
         SELECT nnth.nnth_nth_theme_id nth_theme_id
           FROM NM_NW_THEMES nnth, NM_LINEAR_TYPES
          WHERE nnth.nnth_nlt_id = nlt_id AND nlt_nt_type = c_ne_nt_type;

      nthrec       NM_THEMES_ALL%ROWTYPE;
      rcur         Nm3type.ref_cursor;
      cur_string   VARCHAR2 (2000);
      dummy        INTEGER;
      retval       BOOLEAN                 := FALSE;
   BEGIN
      FOR irec IN c_nlt (lnerec.ne_nt_type)
      LOOP
         nthrec := get_nth (irec.nth_theme_id);

         IF Nm3ddl.does_object_exist
                                   (p_object_name      => nthrec.nth_feature_table)
         THEN
            cur_string :=
                  'select 1 from '
               || nthrec.nth_feature_table
               || ' where '
               || nthrec.nth_feature_pk_column
               || ' = :ne_val';

            OPEN rcur FOR cur_string USING p_ne_id;

            FETCH rcur
             INTO dummy;

            IF rcur%FOUND
            THEN
               retval := TRUE;
               EXIT;
            END IF;
         END IF;
      END LOOP;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION has_shape (
      p_ne_id      IN   nm_elements.ne_id%TYPE,
      p_obj_type   IN   nm_members.nm_obj_type%TYPE,
      p_type       IN   nm_members.nm_type%TYPE DEFAULT 'I'
   )
      RETURN BOOLEAN
   IS
      l_nlt_id   NM_LINEAR_TYPES.nlt_id%TYPE;
      l_nat_id   NM_AREA_TYPES.nat_id%TYPE;
      retval     BOOLEAN                       := FALSE;
   BEGIN
      IF p_type = 'I'
      THEN
         retval := inv_has_shape (p_ne_id, p_obj_type);
      ELSIF p_type = 'G'
      THEN
         l_nlt_id := get_nlt_id_from_gty (p_obj_type);

         IF l_nlt_id IS NOT NULL
         THEN
            retval := nlt_has_shape (p_ne_id, l_nlt_id);
         ELSE
            l_nat_id := get_nat_id_from_gty (p_obj_type);

            IF l_nat_id IS NOT NULL
            THEN
               retval := area_has_shape (p_ne_id, l_nat_id);
            END IF;
         END IF;
      ELSIF p_type = 'G' OR p_type = 'P'
      THEN   -- just a group of elements or group of groups - could be an area
         NULL;
      ELSIF p_type = 'D'
      THEN                                                            -- datum
         retval := datum_has_shape (p_ne_id);
      END IF;

      RETURN retval;
   END;
--
---------------------------------------------------------------------------------------------------
--
   PROCEDURE set_obj_shape_end_date (
      p_obj_type   IN   nm_members.nm_obj_type%TYPE,
      p_ne_id      IN   nm_members.nm_ne_id_in%TYPE,
      p_end_date   IN   nm_members.nm_start_date%TYPE
   )
   IS
      cur_string   VARCHAR2 (2000);
   BEGIN
      cur_string :=
            'update '
         || get_inv_spatial_table (p_obj_type)
         || ' set end_date = :p_end_date '
         || ' where ne_id = :ne ';

      EXECUTE IMMEDIATE cur_string
                  USING p_end_date, p_ne_id;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE insert_obj_shape (
      p_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_ne_id        IN   nm_members.nm_ne_id_in%TYPE,
      p_start_date   IN   nm_members.nm_start_date%TYPE,
      p_end_date     IN   nm_members.nm_start_date%TYPE DEFAULT NULL,
      p_geom         IN   MDSYS.SDO_GEOMETRY
   )
   IS
      cur_string   VARCHAR2 (2000);
   BEGIN
      cur_string :=
            'insert into '
         || get_inv_spatial_table (p_obj_type)
         || ' ( ne_id, geoloc, start_date, end_date )'
         || ' values ( :p_ne_id, :p_geom, :p_start_date, :p_end_date )';

      EXECUTE IMMEDIATE cur_string
                  USING p_ne_id, p_geom, p_start_date, p_end_date;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         cur_string :=
               'delete from '
            || get_inv_spatial_table (p_obj_type)
            || ' where ne_id = :p_ne_id and start_date = :p_start_date';

         EXECUTE IMMEDIATE cur_string
                     USING p_ne_id, p_start_date;

         cur_string :=
               'insert into '
            || get_inv_spatial_table (p_obj_type)
            || ' ( ne_id, geoloc, start_date, end_date )'
            || ' values ( :p_ne_id, :p_geom, :p_start_date, :p_end_date )';

         EXECUTE IMMEDIATE cur_string
                     USING p_ne_id, p_geom, p_start_date, p_end_date;
   END;

--
---------------------------------------------------------------------------------------------------
--
/*
   PROCEDURE process_inv_sdo_data_ne (
      p_ne_id   IN   nm_members.nm_ne_id_of%TYPE,
      p_date    IN   DATE
   )
   IS
-- This process is designed to handle all asset changes after re-shape
--
      CURSOR c1 (c_ne_id IN nm_members.nm_ne_id_of%TYPE)
      IS                 --cursor to retrieve all affected inventory objects
         SELECT nm_ne_id_in, nm_obj_type, nit_pnt_or_cont, nm_begin_mp
           FROM nm_members_all, nm_inv_types, nm_inv_themes
          WHERE nm_obj_type = nit_inv_type
            AND nit_inv_type = nith_nit_id
            AND nm_ne_id_of = c_ne_id;

      CURSOR c2 (c_obj_type nm_members.nm_obj_type%TYPE)
      IS
         SELECT nth_base_theme
           FROM nm_themes_all, nm_inv_themes a
          WHERE a.nith_nth_theme_id = nth_theme_id
            AND a.nith_nit_id = c_obj_type
            AND nth_feature_table = get_inv_spatial_table (c_obj_type);

      l_effective_date   DATE               := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
      l_geom             MDSYS.SDO_GEOMETRY;
   BEGIN
      --   nm_debug.debug_on;
      --   nm_debug.delete_debug(true);
      --   nm_debug.debug('Processing the sdo data');
      FOR irec IN c1 (p_ne_id)
      LOOP
--   nm3user.set_effective_date( irec.nm_start_date );

         --   the object has changed by date or by location - end date the shape

         --   nm_debug.debug('End-date the previous shape');
         set_obj_shape_end_date (irec.nm_obj_type, irec.nm_ne_id_in, p_date);

         --   nm_debug.debug('Affected object '||irec.nm_obj_type||' Id - '||to_char(irec.nm_ne_id_in) );
         FOR jrec IN c2 (irec.nm_obj_type)
         LOOP
            --   nm_debug.debug('get new object shape'||irec.nm_obj_type||' Id - '||to_char(irec.nm_ne_id_in) );
            IF irec.nit_pnt_or_cont = 'P'
            THEN
               l_geom :=
                  nm3sdo.get_pt_shape_from_ne (jrec.nth_base_theme,
                                               irec.nm_ne_id_in,
                                               p_ne_id,
                                               irec.nm_begin_mp
                                              );
            ELSE
               l_geom :=
                  nm3sdo.get_shape_from_ne (jrec.nth_base_theme,
                                            irec.nm_ne_id_in
                                           );
            END IF;

            IF l_geom IS NOT NULL
            THEN
               --   nm_debug.debug('Insert new object shape'||irec.nm_obj_type||' Id - '||to_char(irec.nm_ne_id_in) );
               insert_obj_shape (irec.nm_obj_type,
                                 irec.nm_ne_id_in,
                                 p_date,
                                 NULL,
                                 l_geom
                                );
            END IF;
         END LOOP;
      END LOOP;
   END;
*/
--
-----------------------------------------------------------------------------
--
   FUNCTION get_nlt_id_from_gty (pi_gty IN nm_group_types.ngt_group_type%TYPE)
      RETURN NM_LINEAR_TYPES.nlt_id%TYPE
   IS
      CURSOR c1 (c_gty IN nm_group_types.ngt_group_type%TYPE)
      IS
         SELECT nlt_id
           FROM NM_LINEAR_TYPES
          WHERE nlt_gty_type = c_gty;

      retval   NM_LINEAR_TYPES.nlt_id%TYPE;
   BEGIN
      OPEN c1 (pi_gty);
      FETCH c1
       INTO retval;

      IF c1%NOTFOUND
      THEN
         CLOSE c1;
         retval := NULL;
      ELSE
         CLOSE c1;
      END IF;

      RETURN retval;
   END get_nlt_id_from_gty;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_nat_id_from_gty (pi_gty IN nm_group_types.ngt_group_type%TYPE)
      RETURN NM_AREA_TYPES.nat_id%TYPE
   IS
      CURSOR c1 (c_gty IN nm_group_types.ngt_group_type%TYPE)
      IS
         SELECT nat_id
           FROM NM_AREA_TYPES
          WHERE nat_gty_group_type = c_gty;

      retval   NM_AREA_TYPES.nat_id%TYPE;
   BEGIN
      OPEN c1 (pi_gty);
      FETCH c1
       INTO retval;

      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         retval := NULL;
      ELSE
         CLOSE c1;
      END IF;

      RETURN retval;
   END get_nat_id_from_gty;

--
-----------------------------------------------------------------------------
--
   PROCEDURE update_member_shape (
      p_nm_ne_id_in      IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of      IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type      IN   nm_members.nm_obj_type%TYPE,
      p_old_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_new_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp        IN   nm_members.nm_end_mp%TYPE,
      p_old_start_date   IN   nm_members.nm_start_date%TYPE,
      p_new_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date      IN   nm_members.nm_end_date%TYPE,
      p_nm_type          IN   nm_members.nm_type%TYPE
   )
   IS
   BEGIN
      IF p_nm_type = 'I'
      THEN
         update_inv_shape (p_nm_ne_id_in         => p_nm_ne_id_in,
                           p_nm_ne_id_of         => p_nm_ne_id_of,
                           p_nm_obj_type         => p_nm_obj_type,
                           p_old_begin_mp        => p_old_begin_mp,
                           p_new_begin_mp        => p_new_begin_mp,
                           p_nm_end_mp           => p_nm_end_mp,
                           p_old_start_date      => p_old_start_date,
                           p_new_start_date      => p_new_start_date,
                           p_nm_end_date         => p_nm_end_date
                          );
      ELSIF p_nm_type = 'G'
      THEN
         update_gty_shape (p_nm_ne_id_in         => p_nm_ne_id_in,
                           p_nm_ne_id_of         => p_nm_ne_id_of,
                           p_nm_obj_type         => p_nm_obj_type,
                           p_old_begin_mp        => p_old_begin_mp,
                           p_new_begin_mp        => p_new_begin_mp,
                           p_nm_end_mp           => p_nm_end_mp,
                           p_old_start_date      => p_old_start_date,
                           p_new_start_date      => p_new_start_date,
                           p_nm_end_date         => p_nm_end_date
                          );
      END IF;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE update_inv_shape (
      p_nm_ne_id_in      IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of      IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type      IN   nm_members.nm_obj_type%TYPE,
      p_old_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_new_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp        IN   nm_members.nm_end_mp%TYPE,
      p_old_start_date   IN   nm_members.nm_start_date%TYPE,
      p_new_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date      IN   nm_members.nm_end_date%TYPE
   )
   IS
      CURSOR c_inv_tab (c_inv_type nm_inv_types.nit_inv_type%TYPE,
                        c_ne_id    nm_elements.ne_id%TYPE
                        )  IS
         SELECT nth_feature_table, nth_feature_pk_column, nth_feature_fk_column, nbth_base_theme, nth_xsp_column
         FROM NM_THEMES_ALL, NM_INV_THEMES, NM_BASE_THEMES, NM_NW_THEMES, nm_elements, NM_LINEAR_TYPES
         WHERE nth_theme_id = nith_nth_theme_id
         AND nth_theme_id = nbth_theme_id
         AND nith_nit_id = c_inv_type
         AND nth_update_on_edit = 'I'
         AND ne_id = c_ne_id
         AND ne_nt_type = nlt_nt_type
         AND nnth_nth_theme_id = nbth_base_theme
         AND nlt_id = nnth_nlt_id;

--     allow for many layers of the same asset type

      upd_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
      l_nit        nm_inv_types%ROWTYPE   := Nm3get.get_nit (p_nm_obj_type);
   BEGIN
--  nm_debug.debug('Updating shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--    ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of ));
      FOR irec IN c_inv_tab (p_nm_obj_type, p_nm_ne_id_of )
      LOOP
         upd_string :=
               'update '
            || irec.nth_feature_table
            || ' set geoloc = :newshape, '
            || '     nm_begin_mp = :new_begin_mp,'
            || '     nm_end_mp   = :new_end_mp, '
            || '     start_date = :new_start_date, '
            || '     end_date   = :new_end_date '
            || '  where ne_id = :ne_id'
            || ' and ne_id_of = :ne_id_of '
            || ' and nm_begin_mp = :nm_begin_mp '
            || ' and start_date  = :old_start_date ';

         IF l_nit.nit_pnt_or_cont = 'P'
         THEN
            l_geom :=
               Nm3sdo.get_pt_shape_from_ne (irec.nbth_base_theme,
                                            p_nm_ne_id_of,
                                            p_new_begin_mp
                                           );
         ELSE
            l_geom :=
               Nm3sdo.get_shape_from_nm (irec.nbth_base_theme,
                                         p_nm_ne_id_in,
                                         p_nm_ne_id_of,
                                         p_new_begin_mp,
                                         p_nm_end_mp
                                        );
         END IF;
         
         -- CWS Lateral Offset change.
         if irec.nth_xsp_column is not null
         and NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'-- check prod opt  
         then

           l_geom := nm3sdo_dynseg.get_shape( irec.nbth_base_theme, p_nm_ne_id_in, p_nm_ne_id_of, p_new_begin_mp, p_nm_end_mp );

         end if;

         EXECUTE IMMEDIATE upd_string
                     USING l_geom,
                           p_new_begin_mp,
                           p_nm_end_mp,
                           p_new_start_date,
                           p_nm_end_date,
                           p_nm_ne_id_in,
                           p_nm_ne_id_of,
                           p_old_begin_mp,
                           p_old_start_date;
      END LOOP;
   END;


--
-----------------------------------------------------------------------------
--
   PROCEDURE update_gty_shape (
      p_nm_ne_id_in      IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of      IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type      IN   nm_members.nm_obj_type%TYPE,
      p_old_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_new_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp        IN   nm_members.nm_end_mp%TYPE,
      p_old_start_date   IN   nm_members.nm_start_date%TYPE,
      p_new_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date      IN   nm_members.nm_end_date%TYPE
   )
   IS

      CURSOR c_gty_tab (c_gty_type nm_group_types.ngt_group_type%TYPE,
                        c_ne_id IN nm_elements.ne_id%TYPE,
                        c_nm_ne_id_in in nm_members.nm_ne_id_in%type )
      IS
         SELECT nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column, nbth_base_theme, 'G' I_or_G, c_gty_type obj_type
           FROM NM_THEMES_ALL, NM_AREA_TYPES, NM_AREA_THEMES, NM_BASE_THEMES, NM_NW_THEMES, nm_elements, NM_LINEAR_TYPES
          WHERE nth_theme_id = nath_nth_theme_id
            AND nth_theme_id = nbth_theme_id
            AND nath_nat_id = nat_id
            AND nat_gty_group_type = c_gty_type
            AND nth_theme_type = 'SDO'
            AND ne_id = c_ne_id
            AND ne_nt_type = nlt_nt_type
            AND nnth_nth_theme_id = nbth_base_theme
            AND nlt_id = nnth_nlt_id
            AND nth_update_on_edit = 'I'
         UNION
         SELECT nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column, nbth_base_theme, 'I', nad_inv_type
           FROM NM_THEMES_ALL, NM_INV_THEMES, NM_BASE_THEMES, NM_NW_THEMES, nm_elements, NM_LINEAR_TYPES, nm_nw_ad_types
          WHERE nth_theme_id = nith_nth_theme_id
            AND nth_theme_id = nbth_theme_id
            AND nad_gty_type = c_gty_type
            and nad_inv_type = nith_nit_id
--          and nad_ne_id = c_nm_ne_id_in
            AND nth_theme_type = 'SDO'
            AND ne_id = c_ne_id
            AND ne_nt_type = nlt_nt_type
            AND nnth_nth_theme_id = nbth_base_theme
            AND nlt_id = nnth_nlt_id
            AND nth_update_on_edit = 'I';

--allow for many layers of the same gty type
      upd_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
   BEGIN
--  nm_debug.debug('Updating shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--    ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of ));
      FOR irec IN c_gty_tab (p_nm_obj_type, p_nm_ne_id_of, p_nm_ne_id_in )
      LOOP
         if irec.i_or_g = 'G' then
           upd_string :=
               'update '
            || irec.nth_feature_table
            || ' set geoloc = :newshape, '
            || '     nm_begin_mp = :new_begin_mp,'
            || '     nm_end_mp   = :new_end_mp '
            || '  where ne_id = :ne_id'
            || ' and ne_id_of = :ne_id_of '
            || ' and nm_begin_mp = :nm_begin_mp '
            || ' and end_date is null';
           l_geom :=
            sdo_lrs.convert_to_std_geom( Nm3sdo.get_shape_from_nm (irec.nbth_base_theme,
                                        p_nm_ne_id_in,
                                        p_nm_ne_id_of,
                                        p_new_begin_mp,
                                        p_nm_end_mp
                                       ));
           EXECUTE IMMEDIATE upd_string
                     USING l_geom,
                           p_new_begin_mp,
                           p_nm_end_mp,
                           p_nm_ne_id_in,
                           p_nm_ne_id_of,
                           p_old_begin_mp;
        else
           upd_string :=
               'update '
            || irec.nth_feature_table
            || ' set geoloc = :newshape, '
            || '     nm_begin_mp = :new_begin_mp,'
            || '     nm_end_mp   = :new_end_mp '
            || '  where ne_id in ( select nad_iit_ne_id '
            ||                   ' from nm_nw_ad_link '
            ||                   ' where nad_ne_id = :ne_id'
            ||                   ' and nad_gty_type =  :gty_type '
            ||                   ' and nad_inv_type =  :obj_type '
            ||                   ' and nad_whole_road = :whole_road  ) '
            || ' and ne_id_of = :ne_id_of '
            || ' and nm_begin_mp = :nm_begin_mp '
            || ' and end_date is null';

        -- AE set l_geom
        -- 4054

        l_geom :=
            Nm3sdo.get_shape_from_nm (irec.nbth_base_theme,
                                      p_nm_ne_id_in,
                                      p_nm_ne_id_of,
                                      p_new_begin_mp,
                                      p_nm_end_mp
                                     );

           EXECUTE IMMEDIATE upd_string
                     USING l_geom,
                           p_new_begin_mp,
                           p_nm_end_mp,
                           p_nm_ne_id_in,
                           p_nm_obj_type,
                           irec.obj_type,
                           '1',
                           p_nm_ne_id_of,
                           p_old_begin_mp;
        end if;
      END LOOP;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE end_member_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE,
      p_nm_type         IN   nm_members.nm_type%TYPE
   )
   IS
   BEGIN
      IF p_nm_type = 'I'
      THEN
         end_inv_shape (p_nm_ne_id_in        => p_nm_ne_id_in,
                        p_nm_ne_id_of        => p_nm_ne_id_of,
                        p_nm_obj_type        => p_nm_obj_type,
                        p_nm_begin_mp        => p_nm_begin_mp,
                        p_nm_end_mp          => p_nm_end_mp,
                        p_nm_start_date      => p_nm_start_date,
                        p_nm_end_date        => p_nm_end_date
                       );
      ELSIF p_nm_type = 'G'
      THEN
         end_gty_shape (p_nm_ne_id_in        => p_nm_ne_id_in,
                        p_nm_ne_id_of        => p_nm_ne_id_of,
                        p_nm_obj_type        => p_nm_obj_type,
                        p_nm_begin_mp        => p_nm_begin_mp,
                        p_nm_end_mp          => p_nm_end_mp,
                        p_nm_start_date      => p_nm_start_date,
                        p_nm_end_date        => p_nm_end_date
                       );
      END IF;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE end_inv_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE
   )
   IS
      CURSOR c_inv_tab (c_inv_type nm_inv_types.nit_inv_type%TYPE)
      IS
         SELECT nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column
           FROM NM_THEMES_ALL, NM_INV_THEMES
          WHERE nth_theme_id = nith_nth_theme_id
            AND nith_nit_id = c_inv_type
            AND nth_update_on_edit = 'I';

--allow for many layers of the same asset type
      upd_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
   BEGIN
--  nm_debug.debug('Ending shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--    ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of ));
      FOR irec IN c_inv_tab (p_nm_obj_type)
      LOOP
        -- AE - 718333
        -- Include begin_mp and only operate on open shapes
        --
        -- Later change (30-MAR-09) remove the end_date check because this procedure
        -- is used for un-endating too
         upd_string :=
               'update '
            || irec.nth_feature_table
            || '  set end_date    = :end_date '
            || 'where ne_id       = :ne_id '
            || '  and ne_id_of    = :ne_id_of '
            || '  and nm_begin_mp = :nm_begin_mp ';

--            || '  and end_date IS NULL';

        -- AE - 718333
        -- Include begin_mp and only operate on open shapes
        -- End of changes
        --
		--RAC - Task 0111157 - the update string must update the shape end date on the basis
		--      of the actual start-date for the specific mamber that is targetted.
		--      Without this, the end-date of an asset  (hence members) will update the end-date on
		--      all shape records that have the same begin-mp - including those that are already ended.
		
        if p_nm_end_date is not null then
           upd_string := upd_string ||' and end_date is null and start_date = :start_date';
        else
           upd_string := upd_string ||' and start_date = :start_date';
        end if;
		
--    nm_debug.debug('End date string '||upd_string);
         EXECUTE IMMEDIATE upd_string
                     USING p_nm_end_date, p_nm_ne_id_in, p_nm_ne_id_of, p_nm_begin_mp, p_nm_start_date;
      END LOOP;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE end_gty_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE
   )
   IS
      CURSOR c_gty_tab (c_gty_type nm_group_types.ngt_group_type%TYPE)
      IS
         SELECT nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column, 'G' g_or_i, p_nm_obj_type obj_type
           FROM NM_THEMES_ALL, NM_AREA_TYPES, NM_AREA_THEMES
          WHERE nth_theme_id = nath_nth_theme_id
            AND nath_nat_id = nat_id
            AND nat_gty_group_type = c_gty_type
            AND nth_theme_type = 'SDO'
            AND nth_update_on_edit = 'I'
         UNION
         SELECT nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column, 'I' g_or_i, nith_nit_id
           FROM NM_THEMES_ALL, nm_nw_ad_types, nm_inv_themes
          WHERE nth_theme_id = nith_nth_theme_id
            AND nith_nit_id = nad_inv_type
            AND nad_gty_type = c_gty_type
            AND nth_update_on_edit = 'I';

--allow for many layers of the same asset type
      upd_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
      l_ne_id      number;
   BEGIN
--   nm_debug.debug_on;
--   nm_debug.debug('Ending shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--                  ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of ));
      FOR irec IN c_gty_tab (p_nm_obj_type)
      LOOP
         IF irec.g_or_i = 'G'
         THEN
      --
      -- AE - 718333
      -- Include begin_mp and only operate on open shapes
      --
      -- Later change (30-MAR-09) remove the end_date check because this procedure
      -- is used for un-endating too
      --
           upd_string :=
               'update '|| irec.nth_feature_table
            || '  set end_date    = :end_date '
            || 'where ne_id       = :ne_id '
            || '  and ne_id_of    = :ne_id_of '
            || '  and nm_begin_mp = :nm_begin_mp ';

--            || '  and end_date IS NULL';

      -- AE - 718333
      -- Include begin_mp and only operate on open shapes
      -- End of changes

		--RAC - Task 0111157 - the update string must update the shape end date on the basis
		--      of the actual start-date for the specific mamber that is targetted.
		--      Without this, the end-date of an asset  (hence members) will update the end-date on
		--      all shape records that have the same begin-mp - including those that are already ended.
		
           if p_nm_end_date is not null then
             upd_string := upd_string ||' and end_date is null and start_date = :start_date';
           else
             upd_string := upd_string ||' and start_date = :start_date';
           end if;
		
--         nm_debug.debug('End date string '||upd_string);
           EXECUTE IMMEDIATE upd_string
                     USING p_nm_end_date, p_nm_ne_id_in, p_nm_ne_id_of, p_nm_begin_mp, p_nm_start_date;
	  
      --
         ELSE
      --
      -- Later change (30-MAR-09) remove the end_date check because this procedure
      -- is used for un-endating too

          upd_string :=
               'update '|| irec.nth_feature_table
            || '   set end_date = :end_date '
            || ' where ne_id_of = :ne_id_of '
            ||   ' and nm_begin_mp = :nm_begin_mp '
          --||   ' and end_date IS NULL '
            ||   ' and ne_id in ( select nad_iit_ne_id '
                               || ' from nm_nw_ad_link '
                               ||' where nad_gty_type   = :p_gty_type '
                                || ' and nad_inv_type   = :obj_type '
                                || ' and nad_ne_id      = :nm_ne_id_in '
                                || ' and nad_whole_road = :whole_road )';
      --
      -- AE 27-MAR-2009
      -- Pass in nm_begin_mp !!
      --

      --RAC - Task 0111157 - the update string must update the shape end date on the basis
      --      of the actual start-date for the specific mamber that is targetted.
      --      Without this, the end-date of an asset  (hence members) will update the end-date on
      --      all shape records that have the same begin-mp - including those that are already ended.
        
           if p_nm_end_date is not null then
             upd_string := upd_string ||' and end_date is null and start_date = :start_date';
           else
             upd_string := upd_string ||' and start_date = :start_date';
           end if;
        
--         nm_debug.debug('End date string '||upd_string);

           EXECUTE IMMEDIATE upd_string
                    USING p_nm_end_date, p_nm_ne_id_of, p_nm_begin_mp, p_nm_obj_type, irec.obj_type, p_nm_ne_id_in, '1', p_nm_start_date;
      --
         END IF;
      --
      END LOOP;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE add_member_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE,
      p_nm_type         IN   nm_members.nm_type%TYPE
   )
   IS
   BEGIN
      IF p_nm_type = 'I'
      THEN
         add_inv_shape (p_nm_ne_id_in        => p_nm_ne_id_in,
                        p_nm_ne_id_of        => p_nm_ne_id_of,
                        p_nm_obj_type        => p_nm_obj_type,
                        p_nm_begin_mp        => p_nm_begin_mp,
                        p_nm_end_mp          => p_nm_end_mp,
                        p_nm_start_date      => p_nm_start_date,
                        p_nm_end_date        => p_nm_end_date
                       );
      ELSIF p_nm_type = 'G'
      THEN
         add_gty_shape (p_nm_ne_id_in        => p_nm_ne_id_in,
                        p_nm_ne_id_of        => p_nm_ne_id_of,
                        p_nm_obj_type        => p_nm_obj_type,
                        p_nm_begin_mp        => p_nm_begin_mp,
                        p_nm_end_mp          => p_nm_end_mp,
                        p_nm_start_date      => p_nm_start_date,
                        p_nm_end_date        => p_nm_end_date
                       );
      END IF;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE remove_member_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE,
      p_nm_type         IN   nm_members.nm_type%TYPE
   )
   IS
   BEGIN
      IF p_nm_type = 'I'
      THEN
         remove_inv_shape (p_nm_ne_id_in        => p_nm_ne_id_in,
                           p_nm_ne_id_of        => p_nm_ne_id_of,
                           p_nm_obj_type        => p_nm_obj_type,
                           p_nm_begin_mp        => p_nm_begin_mp,
                           p_nm_end_mp          => p_nm_end_mp,
                           p_nm_start_date      => p_nm_start_date,
                           p_nm_end_date        => p_nm_end_date
                          );
      ELSIF p_nm_type = 'G'
      THEN
         remove_gty_shape (p_nm_ne_id_in        => p_nm_ne_id_in,
                           p_nm_ne_id_of        => p_nm_ne_id_of,
                           p_nm_obj_type        => p_nm_obj_type,
                           p_nm_begin_mp        => p_nm_begin_mp,
                           p_nm_end_mp          => p_nm_end_mp,
                           p_nm_start_date      => p_nm_start_date,
                           p_nm_end_date        => p_nm_end_date
                          );
      END IF;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE add_inv_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE
   )
   IS
      CURSOR c_inv_tab (c_inv_type nm_inv_types.nit_inv_type%TYPE,
                        c_ne_id    nm_elements.ne_id%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column
                nth_feature_fk_column, nbth_base_theme, nth_xsp_column
           FROM NM_THEMES_ALL, NM_INV_THEMES, NM_BASE_THEMES, NM_NW_THEMES, nm_elements, NM_LINEAR_TYPES
          WHERE nth_theme_id = nith_nth_theme_id
            AND nth_theme_id = nbth_theme_id
            AND nith_nit_id = c_inv_type
            AND nth_update_on_edit = 'I'
            AND ne_id = c_ne_id
            AND ne_nt_type = nlt_nt_type
            AND nnth_nth_theme_id = nbth_base_theme
            AND nlt_id = nnth_nlt_id;


--allow for many layers of the same asset type, only deal with immediate themes
      ins_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
      l_nit        nm_inv_types%ROWTYPE   := Nm3get.get_nit (p_nm_obj_type);
      l_objid      NUMBER;
   BEGIN
--  nm_debug.debug('Adding shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--    ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of )||' start @ '||
--    to_char( p_nm_start_date, 'DD-MON-YYYY')||' end @ '||to_char( p_nm_end_date, 'DD-MON-YYYY'));
      FOR irec IN c_inv_tab (p_nm_obj_type, p_nm_ne_id_of )
      LOOP
--    nm_debug.debug('insert - '||irec.nth_feature_table);
         IF Nm3sdo.use_surrogate_key = 'N'
         THEN
            ins_string :=
                  'insert into '
               || irec.nth_feature_table
               || ' ( ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
               || ' values (:ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

            IF l_nit.nit_pnt_or_cont = 'P'
            THEN
               l_geom :=
                  Nm3sdo.get_pt_shape_from_ne (irec.nbth_base_theme,
                                               p_nm_ne_id_of,
                                               p_nm_begin_mp
                                              );
            ELSE
               l_geom :=
                  Nm3sdo.get_shape_from_nm (irec.nbth_base_theme,
                                            p_nm_ne_id_in,
                                            p_nm_ne_id_of,
                                            p_nm_begin_mp,
                                            p_nm_end_mp
                                           );
            END IF;

            -- CWS Lateral Offset change
            IF irec.nth_xsp_column IS NOT NULL 
            AND NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'-- check prod opt
            THEN

               l_geom := nm3sdo_dynseg.get_shape( irec.nbth_base_theme, p_nm_ne_id_in, p_nm_ne_id_of, p_nm_begin_mp, p_nm_end_mp );
           
            END IF;

            IF l_geom IS NOT NULL
            THEN
               EXECUTE IMMEDIATE ins_string
                           USING p_nm_ne_id_in,
                                 p_nm_ne_id_of,
                                 p_nm_begin_mp,
                                 p_nm_end_mp,
                                 l_geom,
                                 p_nm_start_date,
                                 p_nm_end_date;
            END IF;
         ELSE
            EXECUTE IMMEDIATE    'select '
                              || Nm3sdo.get_spatial_seq (irec.nth_theme_id)
                              || '.nextval from dual'
                         INTO l_objid;

            ins_string :=
                  'insert into '
               || irec.nth_feature_table
               || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
               || ' values (:objectid, :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

            IF l_nit.nit_pnt_or_cont = 'P'
            THEN
               l_geom :=
                  Nm3sdo.get_pt_shape_from_ne (irec.nbth_base_theme,
                                               p_nm_ne_id_of,
                                               p_nm_begin_mp
                                              );
            ELSE
               l_geom :=
                  Nm3sdo.get_shape_from_nm (irec.nbth_base_theme,
                                            p_nm_ne_id_in,
                                            p_nm_ne_id_of,
                                            p_nm_begin_mp,
                                            p_nm_end_mp
                                           );
            END IF;

            -- CWS Lateral Offset Change
            IF irec.nth_xsp_column IS NOT NULL 
            AND NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'-- check prod opt  
            THEN
               IF l_nit.nit_pnt_or_cont = 'P' 
               THEN
                 l_geom := sdo_lrs.convert_to_std_geom(nm3sdo_dynseg.get_shape( irec.nbth_base_theme, p_nm_ne_id_in, p_nm_ne_id_of, p_nm_begin_mp, p_nm_end_mp ));
               ELSE
                 l_geom := nm3sdo_dynseg.get_shape( irec.nbth_base_theme, p_nm_ne_id_in, p_nm_ne_id_of, p_nm_begin_mp, p_nm_end_mp );
               END IF;
            END IF;

            IF l_geom IS NOT NULL
            THEN
               EXECUTE IMMEDIATE ins_string
                           USING l_objid,
                                 p_nm_ne_id_in,
                                 p_nm_ne_id_of,
                                 p_nm_begin_mp,
                                 p_nm_end_mp,
                                 l_geom,
                                 p_nm_start_date,
                                 p_nm_end_date;
            END IF;
         END IF;
      END LOOP;
   END;

--
---------------------------------------------------------------------------------------------------
--
   PROCEDURE remove_inv_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE
   )
   IS
      CURSOR c_inv_tab (c_inv_type nm_inv_types.nit_inv_type%TYPE)
      IS
         SELECT nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column
           FROM NM_THEMES_ALL, NM_INV_THEMES
          WHERE nth_theme_id = nith_nth_theme_id
            AND nith_nit_id = c_inv_type
            AND nth_update_on_edit = 'I';

--allow for many layers of the same asset type, only address immediate themes
      del_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
      l_nit        nm_inv_types%ROWTYPE   := Nm3get.get_nit (p_nm_obj_type);
   BEGIN
--  nm_debug.debug('Removing shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--    ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of ));
      FOR irec IN c_inv_tab (p_nm_obj_type)
      LOOP
--  nm_debug.debug('delete - '||irec.nth_feature_table);
         del_string :=
               'delete from '
            || irec.nth_feature_table
            || ' where ne_id = :ne_id'
            || ' and ne_id_of = :ne_id_of '
            || ' and nm_begin_mp = :ne_begin_mp '
            || ' and start_date = :start_date';

-- nm_debug.debug( del_string );
         EXECUTE IMMEDIATE del_string
                     USING p_nm_ne_id_in,
                           p_nm_ne_id_of,
                           p_nm_begin_mp,
                           p_nm_start_date;
      END LOOP;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE add_gty_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE
   )
   IS
      CURSOR c_gty_tab (c_gty_type nm_inv_types.nit_inv_type%TYPE,
                        c_ne_id IN nm_elements.ne_id%TYPE,
                        c_nm_ne_id_in in nm_members.nm_ne_id_in%type )
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column, nth_feature_shape_column,
                nth_feature_fk_column, nbth_base_theme, 'G' G_or_I, c_gty_type OBJ_TYPE
           FROM NM_THEMES_ALL, NM_AREA_THEMES, NM_AREA_TYPES, NM_BASE_THEMES, NM_NW_THEMES, nm_elements, NM_LINEAR_TYPES
          WHERE nth_theme_id = nath_nth_theme_id
            AND nth_theme_id = nbth_theme_id
            AND nath_nat_id = nat_id
            AND nat_gty_group_type = c_gty_type
            AND nth_update_on_edit = 'I'
            AND ne_id = c_ne_id
            AND ne_nt_type = nlt_nt_type
            AND nnth_nth_theme_id = nbth_base_theme
            AND nlt_id = nnth_nlt_id
         UNION
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column, nth_feature_shape_column,
                nth_feature_fk_column, nbth_base_theme, 'I', nad_inv_type
           FROM NM_THEMES_ALL, NM_INV_THEMES, NM_BASE_THEMES, NM_NW_THEMES, NM_ELEMENTS, NM_LINEAR_TYPES, NM_NW_AD_LINK
          WHERE nth_theme_id = nith_nth_theme_id
            AND nth_theme_id = nbth_theme_id
            and nad_inv_type = nith_nit_id
            AND nad_gty_type = c_gty_type
            AND nth_update_on_edit = 'I'
            AND ne_id = c_ne_id
            AND ne_nt_type = nlt_nt_type
            AND nnth_nth_theme_id = nbth_base_theme
            AND nlt_id = nnth_nlt_id
            and nad_ne_id = c_nm_ne_id_in;


--allow for many layers of the same group type, only deal with immediate themes
      ins_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
      l_objid      NUMBER;
      l_seq_name   varchar2(30);
   BEGIN
--      nm_debug.debug('Adding shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--      ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of )||' start @ '||
--      to_char( p_nm_start_date, 'DD-MON-YYYY')||' end @ '||to_char( p_nm_end_date, 'DD-MON-YYYY'));

      FOR irec IN c_gty_tab (p_nm_obj_type, p_nm_ne_id_of, p_nm_ne_id_in)
      LOOP
--      nm_debug.debug('insert - '||irec.nth_feature_table);
        if irec.g_or_i = 'G' then

          EXECUTE IMMEDIATE    'select '
                              || Nm3sdo.get_spatial_seq (irec.nth_theme_id)
                              || '.nextval FROM DUAL'
                         INTO l_objid;

          ins_string :=
                  'insert into '
               || irec.nth_feature_table
               || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
               || ' values (:objectid, :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

          l_geom :=
               sdo_lrs.convert_to_std_geom
                               (Nm3sdo.get_shape_from_nm (irec.nbth_base_theme,
                                                          p_nm_ne_id_in,
                                                          p_nm_ne_id_of,
                                                          p_nm_begin_mp,
                                                          p_nm_end_mp
                                                         )
                               );

          --
          -- Task 0108237
          -- AE don't process this insert if the shape is null
          --

          IF l_geom IS NOT NULL
          THEN
            EXECUTE IMMEDIATE ins_string
                        USING l_objid,
                              p_nm_ne_id_in,
                              p_nm_ne_id_of,
                              p_nm_begin_mp,
                              p_nm_end_mp,
                              l_geom,
                              p_nm_start_date,
                              p_nm_end_date;
          END IF;


        ELSE

          l_seq_name := Nm3sdo.get_spatial_seq (irec.nth_theme_id);

          ins_string := 'insert into '
              || irec.nth_feature_table
              ||' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
              ||' select '||l_seq_name||'.nextval, nad_iit_ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, '
              ||' Nm3sdo.get_shape_from_nm ('||to_char(irec.nbth_base_theme)||', '
              ||' :group_ne_id, '
              ||' :ne_id_of, '
              ||' :nm_begin_mp, '
              ||' :nm_end_mp ), :start_date, :end_date '
              ||' from nm_nw_ad_link where nad_ne_id = :group_ne_id '
              ||' and nad_inv_type = :obj_type '
              ||' and nad_whole_road = '||''''||'1'||'''';

          EXECUTE IMMEDIATE ins_string
                           USING p_nm_ne_id_of,
                                 p_nm_begin_mp,
                                 p_nm_end_mp,
                                 p_nm_ne_id_in,
                                 p_nm_ne_id_of,
                                 p_nm_begin_mp,
                                 p_nm_end_mp,
                                 p_nm_start_date,
                                 p_nm_end_date,
                                 p_nm_ne_id_in,
                                 irec.obj_type;



        END IF;

      END LOOP;
   END;

--
---------------------------------------------------------------------------------------------------
--
   PROCEDURE remove_gty_shape (
      p_nm_ne_id_in     IN   nm_members.nm_ne_id_in%TYPE,
      p_nm_ne_id_of     IN   nm_members.nm_ne_id_of%TYPE,
      p_nm_obj_type     IN   nm_members.nm_obj_type%TYPE,
      p_nm_begin_mp     IN   nm_members.nm_begin_mp%TYPE,
      p_nm_end_mp       IN   nm_members.nm_end_mp%TYPE,
      p_nm_start_date   IN   nm_members.nm_start_date%TYPE,
      p_nm_end_date     IN   nm_members.nm_end_date%TYPE
   )
   IS
      CURSOR c_gty_tab (c_gty_type nm_inv_types.nit_inv_type%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column
           FROM NM_THEMES_ALL, NM_AREA_THEMES, NM_AREA_TYPES
          WHERE nth_theme_id = nath_nth_theme_id
            AND nath_nat_id = nat_id
            AND nat_gty_group_type = c_gty_type
            AND nth_update_on_edit = 'I'
         UNION
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column
           FROM NM_THEMES_ALL, nm_nw_ad_types, nm_inv_themes
          WHERE nth_theme_id = nith_nth_theme_id
            AND nith_nit_id = nad_inv_type
            AND nad_gty_type = c_gty_type
            AND nth_update_on_edit = 'I';

--
      del_string   VARCHAR2 (2000);
      l_geom       MDSYS.SDO_GEOMETRY;
   BEGIN
--  nm_debug.debug('Removing shape of '||p_nm_obj_type||' between '||to_char(p_nm_begin_mp)||
--    ' and '||to_char(p_nm_end_mp)|| ' on '||nm3net.get_ne_unique( p_nm_ne_id_of ));
      FOR irec IN c_gty_tab (p_nm_obj_type)
      LOOP
--  nm_debug.debug('delete - '||irec.nth_feature_table);
         del_string :=
               'delete from '
            || irec.nth_feature_table
            || ' where ne_id = :ne_id'
            || ' and ne_id_of = :ne_id_of '
            || ' and nm_begin_mp = :ne_begin_mp '
            || ' and start_date = :start_date';

--nm_debug.debug( del_string );
         EXECUTE IMMEDIATE del_string
                     USING p_nm_ne_id_in,
                           p_nm_ne_id_of,
                           p_nm_begin_mp,
                           p_nm_start_date;
      END LOOP;
   END;

--
---------------------------------------------------------------------------------------------------
--
   PROCEDURE reshape_route (
      pi_ne_id            IN   nm_elements.ne_id%TYPE,
      pi_effective_date   IN   DATE,
      pi_use_history      IN   VARCHAR2
   )
   IS
      CURSOR c_route_tab (c_ne_id IN nm_elements.ne_id%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column, nth_feature_shape_column
      FROM NM_THEMES_ALL,
                NM_NW_THEMES,
                user_tables,
                NM_LINEAR_TYPES,
                NM_ELEMENTS_ALL
          WHERE nth_theme_id = nnth_nth_theme_id
            AND table_name = nth_feature_table
            AND nnth_nlt_id = nlt_id
            AND nlt_gty_type = ne_gty_group_type
            AND nlt_nt_type = ne_nt_type
            AND ne_id = c_ne_id;

      l_nlt_id     NM_LINEAR_TYPES.nlt_id%TYPE;
      l_nlt        NM_LINEAR_TYPES%ROWTYPE;
      cur_string   VARCHAR2 (2000);
      l_base_nth   NM_THEMES_ALL%ROWTYPE;
      l_count      NUMBER;
      l_shape      MDSYS.SDO_GEOMETRY;
      l_next       NUMBER;
      l_date       DATE;

--------------------
      FUNCTION get_shape_start_date (
         p_table    IN   VARCHAR2,
         p_column   IN   VARCHAR2,
         p_value    IN   NUMBER
      )
         RETURN DATE
      IS
         retval   DATE;
      BEGIN
         EXECUTE IMMEDIATE    'select start_date from '
                           || p_table
                           || ' where '
                           || p_column
                           || ' = :ne_id '
                           || ' and end_date is null'
                      INTO retval
                     USING p_value;

         RETURN retval;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
      END;

--------------------
      PROCEDURE end_shape (
         p_table       IN       VARCHAR2,
         p_column      IN       VARCHAR2,
         p_value       IN       NUMBER,
         p_effective   IN       DATE,
         p_count       OUT      NUMBER
      )
      IS
      BEGIN
         EXECUTE IMMEDIATE    'update '
                           || p_table
                           || ' set end_date = :effective '
                           || ' where '
                           || p_column
                           || ' = :ne_id'
                           || ' and end_date is null'
                     USING p_effective, p_value;

         p_count := SQL%ROWCOUNT;
      END;

--------------------
      FUNCTION get_next_theme_seq (p_theme IN NUMBER)
         RETURN NUMBER
      IS
         retval   NUMBER;
      BEGIN
         EXECUTE IMMEDIATE    'select '
                           || Nm3sdo.get_spatial_seq (p_theme)
                           || '.nextval from dual'
                      INTO retval;

         RETURN retval;
      END;

--------------------
      PROCEDURE update_shape (
         p_table          IN       VARCHAR2,
         p_column         IN       VARCHAR2,
         p_value          IN       NUMBER,
         p_shape_column   IN       VARCHAR2,
         p_shape          IN       MDSYS.SDO_GEOMETRY,
         p_count          OUT      NUMBER
      )
      IS
      BEGIN
         EXECUTE IMMEDIATE    'update '
                           || p_table
                           || ' set '
                           || p_shape_column
                           || ' = :shape '
                           || ' where '
                           || p_column
                           || ' = :ne_id'
                           || ' and end_date is null'
                     USING p_shape, p_value;

         p_count := SQL%ROWCOUNT;
      END;

--------------------
      PROCEDURE delete_shape (
         p_table    IN       VARCHAR2,
         p_column   IN       VARCHAR2,
         p_value    IN       NUMBER,
         p_count    OUT      NUMBER
      )
      IS
      BEGIN
         EXECUTE IMMEDIATE    'delete from '
                           || p_table
                           || ' where '
                           || p_column
                           || ' = :ne_id'
                           || ' and end_date is null'
                     USING p_value;

         p_count := SQL%ROWCOUNT;
      END;

--------------------
      PROCEDURE insert_shape (
         p_table          IN       VARCHAR2,
         p_column         IN       VARCHAR2,
         p_value          IN       NUMBER,
         p_shape_column   IN       VARCHAR2,
         p_shape          IN       MDSYS.SDO_GEOMETRY,
         p_seq_no         IN       NUMBER,
         p_effective      IN       DATE,
         p_count          OUT      NUMBER
      )
      IS
      BEGIN
         IF Nm3sdo.use_surrogate_key = 'N'
         THEN
            EXECUTE IMMEDIATE    'insert into '
                              || p_table
                              || '( '
                              || p_column
                              || ','
                              || p_shape_column
                              || ','
                              || 'start_date )'
                              || ' values (:ne_id, :shape, :start_date) '
                        USING p_value, p_shape, p_effective;

            p_count := SQL%ROWCOUNT;
         ELSE
            EXECUTE IMMEDIATE    'insert into '
                              || p_table
                              || '( objectid, '
                              || p_column
                              || ','
                              || p_shape_column
                              || ','
                              || 'start_date )'
                              || ' values (:objectid, :ne_id, :shape, :start_date) '
                        USING p_seq_no, p_value, p_shape, p_effective;

            p_count := SQL%ROWCOUNT;
         END IF;
      END;
---------------------
   BEGIN
--nm_debug.debug_on;
      FOR irec IN c_route_tab (pi_ne_id)
      LOOP
--  only operate on base table data
         l_shape := Nm3sdo.get_route_shape (pi_ne_id);

--  nm_debug.debug('Table - '||irec.nth_feature_table );
         IF pi_use_history = 'Y'
         THEN
--    nm_debug.debug('using history');

            --    first check the start date of the current shape if one exists.
            l_date :=
               get_shape_start_date (irec.nth_feature_table,
                                     irec.nth_feature_pk_column,
                                     pi_ne_id
                                    );

            IF l_shape IS NOT NULL AND l_date = pi_effective_date
            THEN
--      nm_debug.debug(' Not null shape and l_date is effective date');
--      this will violate the pk - we must update without history (sorry - no way past this)
               update_shape (irec.nth_feature_table,
                             irec.nth_feature_pk_column,
                             pi_ne_id,
                             irec.nth_feature_shape_column,
                             l_shape,
                             l_count
                            );
            ELSE
--      nm_debug.debug(' Either null shape or l_date is not effective date');
               IF l_date IS NOT NULL
               THEN
--        nm_debug.debug(' End shape');
                  end_shape (irec.nth_feature_table,
                             irec.nth_feature_pk_column,
                             pi_ne_id,
                             pi_effective_date,
                             l_count
                            );
               END IF;

               IF l_shape IS NOT NULL
               THEN
--        nm_debug.debug('Creating new shape, if it is null then just end-date the old');
                  IF Nm3sdo.use_surrogate_key = 'Y'
                  THEN
                     l_next := get_next_theme_seq (irec.nth_theme_id);
                  END IF;

                  insert_shape (irec.nth_feature_table,
                                irec.nth_feature_pk_column,
                                pi_ne_id,
                                irec.nth_feature_shape_column,
                                l_shape,
                                l_next,
                                pi_effective_date,
                                l_count
                               );
               END IF;
            END IF;
         ELSE
--    nm_debug.debug('Not using history');
            IF l_shape IS NOT NULL
            THEN
               update_shape (irec.nth_feature_table,
                             irec.nth_feature_pk_column,
                             pi_ne_id,
                             irec.nth_feature_shape_column,
                             l_shape,
                             l_count
                            );

               IF l_count = 0
               THEN
--        nm_debug.debug('Update no good - Creating new shape');
                  IF Nm3sdo.use_surrogate_key = 'Y'
                  THEN
                     l_next := get_next_theme_seq (irec.nth_theme_id);
                  END IF;

                  insert_shape (irec.nth_feature_table,
                                irec.nth_feature_pk_column,
                                pi_ne_id,
                                irec.nth_feature_shape_column,
                                l_shape,
                                l_next,
                                pi_effective_date,
                                l_count
                               );
               END IF;
            ELSE
--       nm_debug.debug('Delete shape');
               delete_shape (irec.nth_feature_table,
                             irec.nth_feature_pk_column,
                             pi_ne_id,
                             l_count
                            );
            END IF;                            -- null shape or not null shape
         END IF;                                                    -- history
      END LOOP;
   END reshape_route;

--
-----------------------------------------------------------------------------
--
   PROCEDURE delete_route_shape (p_ne_id IN NUMBER)
   IS
      CURSOR c_route_tab (c_ne_id IN nm_elements.ne_id%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column, nth_feature_shape_column
           FROM NM_THEMES_ALL,
                NM_NW_THEMES,
                user_tables,
                NM_LINEAR_TYPES,
                nm_elements
          WHERE nth_theme_id = nnth_nth_theme_id
            AND table_name = nth_feature_table
            AND nnth_nlt_id = nlt_id
            AND nlt_gty_type = ne_gty_group_type
            AND nlt_nt_type = ne_nt_type
            AND ne_id = c_ne_id;
   BEGIN
      FOR irec IN c_route_tab (p_ne_id)
      LOOP
         EXECUTE IMMEDIATE    'delete from '
                           || irec.nth_feature_table
                           || ' where '
                           || irec.nth_feature_pk_column
                           || ' = :ne_id'
                     USING p_ne_id;
      END LOOP;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE restore_route_shape (p_ne_id IN NUMBER, p_date IN DATE)
   IS
      CURSOR c_route_tab (c_ne_id IN nm_elements.ne_id%TYPE)
      IS
         SELECT nth_theme_id, nth_feature_table, nth_feature_pk_column,
                nth_feature_fk_column, nth_feature_shape_column
           FROM NM_THEMES_ALL,
                NM_NW_THEMES,
                user_tables,
                NM_LINEAR_TYPES,
                nm_elements
          WHERE nth_theme_id = nnth_nth_theme_id
            AND table_name = nth_feature_table
            AND nnth_nlt_id = nlt_id
            AND nlt_gty_type = ne_gty_group_type
            AND nlt_nt_type = ne_nt_type
            AND ne_id = c_ne_id;

      c_str   VARCHAR2 (2000);
   BEGIN
      FOR irec IN c_route_tab (p_ne_id)
      LOOP
         c_str :=
               'update '
            || irec.nth_feature_table
            || ' set end_date = null where '
            || irec.nth_feature_pk_column
            || ' = :ne_id and end_date = :end_date '
            || ' and start_date = ( select max (start_date) '
            || '  from '
            || irec.nth_feature_table
            || ' where ne_id = :ne_id '
            || '  and end_date = :end_date ) ';

/*
--    nm_debug.debug_on;
    nm_debug.delete_debug(true);
    nm_debug.debug(c_str);
*/
         EXECUTE IMMEDIATE c_str
                     USING p_ne_id, p_date, p_ne_id, p_date;
      END LOOP;
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE refresh_nt_views
   IS
      CURSOR c1
      IS
         SELECT nt_type
           FROM NM_TYPES;
   BEGIN
      FOR irec IN c1
      LOOP
         Nm3inv_View.create_view_for_nt_type (pi_nt_type => irec.nt_type);
      END LOOP;
   END;


--
-----------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE make_group_layer (
      p_nt_type              IN   NM_TYPES.nt_type%TYPE,
      p_gty_type             IN   nm_group_types.ngt_group_type%TYPE,
      linear_flag_override   IN   VARCHAR2   DEFAULT 'N',
   p_job_id               IN   NUMBER     DEFAULT NULL
   )
   AS
      l_nlt    NM_LINEAR_TYPES.nlt_id%TYPE;
      l_view   VARCHAR2 (30)      := get_nt_view_name (p_nt_type, p_gty_type);
   BEGIN
     -- AE check to make sure user is unrestricted
      IF NOT user_is_unrestricted
      THEN
        RAISE e_not_unrestricted;
      END IF;

      IF NOT Nm3ddl.does_object_exist (l_view, 'VIEW')
      THEN
         nm3inv_view.create_view_for_nt_type (p_nt_type);
         nm3inv_view.create_ft_inv_for_nt_type (pi_nt_type                  => p_gty_type
                                               ,pi_inv_type                 => NULL
                                               ,pi_delete_existing_inv_type => TRUE
                                               );
      END IF;

      IF Nm3net.is_gty_linear (p_gty_type) = 'Y'
         AND linear_flag_override = 'N'
      THEN
         l_nlt := get_nlt_id_from_gty (p_gty_type);
         make_nt_spatial_layer (pi_nlt_id =>l_nlt, p_job_id => p_job_id );
      ELSE
         create_non_linear_group_layer (p_nt_type => p_nt_type, p_gty_type => p_gty_type, p_job_id => p_job_id );
      END IF;
  EXCEPTION
    WHEN e_not_unrestricted
    THEN
      RAISE_APPLICATION_ERROR (-20777,'Restricted users are not permitted to create SDO layers');
   END;

--
-----------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE create_non_linear_group_layer (
      p_nt_type    IN   NM_TYPES.nt_type%TYPE,
      p_gty_type   IN   nm_group_types.ngt_group_type%TYPE,
   p_job_id     IN   NUMBER DEFAULT NULL
   )
   AS
-- l_gty    nm_group_types%rowtype := nm3get.get_gty( p_gty_type );
      l_tab              NM_THEMES_ALL.nth_feature_table%TYPE;
      l_view             NM_THEMES_ALL.nth_table_name%TYPE;
      l_seq              VARCHAR2 (30);

      l_base_themes      NM_THEME_ARRAY;
   l_diminfo          MDSYS.SDO_DIM_ARRAY;
   l_srid             NUMBER;

   l_usgm             user_sdo_geom_metadata%ROWTYPE;

      lcur               Nm3type.ref_cursor;
      cur_string1        VARCHAR2 (2000);
      cur_string2        VARCHAR2 (2000);
      l_geom             MDSYS.SDO_GEOMETRY;
      l_ne               nm_elements.ne_id%TYPE;
      l_theme_id         NM_THEMES_ALL.nth_theme_id%TYPE;
      l_v_theme_id       NM_THEMES_ALL.nth_theme_id%TYPE;
      l_objectid         NUMBER;
      l_ne_id_of         nm_elements.ne_id%TYPE;
      l_begin_mp         nm_members.nm_begin_mp%TYPE;
      l_end_mp           nm_members.nm_begin_mp%TYPE;
      l_start_date       nm_members.nm_start_date%TYPE;
      l_effective_date   DATE                   := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
      qq                 CHAR (1)                               := CHR (39);
      l_dummy            NUMBER;

-----------------------------------------------------------------------------------------------------------------
      FUNCTION get_nat_feature_table_name (
         p_nt_type    IN   NM_TYPES.nt_type%TYPE,
         p_gty_type   IN   nm_group_types.ngt_group_type%TYPE
      )
         RETURN VARCHAR2
      IS
      BEGIN
         RETURN 'NM_NAT_' || p_nt_type || '_' || p_gty_type || '_SDO';
      END;

-----------------------------------------------------------------------------------------------------------------
      FUNCTION create_sdo_join_view (
         p_nt_type    IN   NM_TYPES.nt_type%TYPE,
         p_gty_type   IN   nm_group_types.ngt_group_type%TYPE,
         p_table      IN   VARCHAR2,
         p_singshp    IN   VARCHAR2 DEFAULT 'N'
      )
         RETURN VARCHAR2
      IS
         cur_string   VARCHAR2 (2000);
         s_col_list   VARCHAR2 (100);
      BEGIN
         IF p_singshp = 'Y'
         THEN
            s_col_list := 's.geoloc';
         ELSE
            s_col_list := 's.ne_id_of, s.nm_begin_mp, s.nm_end_mp, s.geoloc';
         END IF;

         IF Nm3sdo.use_surrogate_key = 'Y'
         THEN
            s_col_list := 's.objectid, ' || s_col_list;
         END IF;

         cur_string :=
               'create or replace view v_'
            || p_table
            || '_DT as select n.*, '
            || s_col_list
            || ' from '
            || ' V_NM_'
            || p_nt_type
            || '_'
            || p_gty_type
            || '_NT'
            || ' n,'
            || p_table
            || ' s where n.ne_id = s.ne_id '
            || ' and s.start_date <= (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual) '
            || ' and  NVL(s.end_date,TO_DATE('
            || qq
            || '99991231'
            || qq
            || ','
            || qq
            || 'YYYYMMDD'
            || qq
            || ')) > (select Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') from dual)';
          --  || ' and n.ne_gty_group_type = '
          --  || ''''
          --  || p_gty_type
          --  || '''';
         --Nm3ddl.create_object_and_syns ('V_' || p_table || '_DT', cur_string);

          -- AE 23-SEP-2008
          -- We will now use views instead of synonyms to provide subordinate user access
          -- to spatial objects
          --nm3ddl.create_object_and_views ('V_'||p_table||'_DT', cur_string);
          -- CWS 0108742 Change back to using synonyms
          Nm3ddl.create_object_and_syns( 'V_'||p_table||'_DT', cur_string );

         RETURN 'V_' || p_table || '_DT';
     END;
-----------------------------------------------------------------------------------------------------------------
   BEGIN

--    Nm_Debug.debug_on;

      l_tab := get_nat_feature_table_name (p_nt_type, p_gty_type);
      l_view := get_nt_view_name (p_nt_type, p_gty_type);

      l_base_themes := get_nat_base_themes( p_nt_type, p_gty_type);

--    Nm_Debug.DEBUG('base themes found, get diminfo ');

     Nm3sdo.set_diminfo_and_srid( l_base_themes, l_diminfo, l_srid );

      l_diminfo := sdo_lrs.convert_to_std_dim_array(l_diminfo);


--     check tha the effective date is today - otherwise the layer will be out of step already!

      -- generate the area type

      --
--    Nm_Debug.DEBUG('create spatial table');
      Nm3sdm.create_spatial_table (l_tab, FALSE, 'START_DATE', 'END_DATE');
                                                                  --, TRUE );
---------------------------------------------------------------
-- Set the registration of metadata
---------------------------------------------------------------
      l_usgm.table_name  := l_tab;
      l_usgm.column_name := 'GEOLOC';
      l_usgm.diminfo     := l_diminfo;
      l_usgm.srid        := l_srid;

      Nm3sdo.ins_usgm ( l_usgm );

      l_theme_id := register_nat_theme (p_nt_type,
                                        p_gty_type,
                                        l_base_themes,
                                        l_tab,
                                        'GEOLOC',
                                        'NE_ID',
                                        NULL,
                                        'N'
                                       );

--    Nm_Debug.DEBUG('Theme = '||TO_CHAR(l_theme_id));

      l_seq := Nm3sdo.create_spatial_seq (l_theme_id);

      IF NOT Nm3ddl.does_object_exist (l_view, 'VIEW')
      THEN
         Nm3inv_View.create_view_for_nt_type (p_nt_type, p_gty_type);
      END IF;

--    Nm_Debug.DEBUG('Create spatial view');

      create_spatial_date_view (l_tab);

--    Nm_Debug.DEBUG('reg the view');

      l_usgm.table_name  := 'V_' || l_tab;
      Nm3sdo.ins_usgm ( l_usgm );

--    Nm_Debug.DEBUG('reg the view theme');

      l_v_theme_id := register_nat_theme (p_nt_type,
                                          p_gty_type,
                                          l_base_themes,
                                          'V_' || l_tab,
                                          'GEOLOC',
                                          'NE_ID',
                                          NULL,
                                          'Y', l_theme_id
                                         );

--    Nm_Debug.DEBUG('Create the data');

      Nm3sdo.create_non_linear_data ( p_table_name    => l_tab,
                                      p_gty_type      => p_gty_type,
                                      p_seq_name      => l_seq,
                                      p_job_id        => p_job_id );


--table needs a spatial index

      Nm3sdo.create_spatial_idx (l_tab);

--need a join view between spatial table and NT view

      l_view := create_sdo_join_view (p_nt_type,
                                      p_gty_type,
                                      l_tab,
                                      Nm3sdo.single_shape_inv );

      l_usgm.table_name  := l_view;

      Nm3sdo.ins_usgm ( l_usgm );

      IF g_date_views = 'Y'
      THEN
         l_v_theme_id :=
            register_nat_theme (p_nt_type,
                                p_gty_type,
                                l_base_themes,
                                l_view,
                                'GEOLOC',
                                'NE_ID',
                                NULL,
                                'Y', l_theme_id
                               );


      END IF;


      BEGIN
--   EXECUTE IMMEDIATE 'analyze table ' || l_tab || ' compute statistics';
        Nm3ddl.analyse_table (pi_table_name          => l_tab
                            , pi_schema              => Sys_Context('NM3CORE','APPLICATION_OWNER')
                            , pi_estimate_percentage => NULL
                            , pi_auto_sample_size    => FALSE);
      EXCEPTION
        WHEN OTHERS
        THEN
          RAISE e_no_analyse_privs;
      END;
      --
      Nm_Debug.proc_end (g_package_name, 'make_ona_inv_spatial_layer');
   --
  EXCEPTION
    WHEN e_not_unrestricted
    THEN
      RAISE_APPLICATION_ERROR (-20777,'Restricted users are not permitted to create SDO layers');
    WHEN e_no_analyse_privs
    THEN
      RAISE_APPLICATION_ERROR (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                      'Please ensure the correct role/privs are applied to the user');

   END create_non_linear_group_layer;

--
----------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION get_theme_from_feature_table (
      p_table   IN   NM_THEMES_ALL.nth_feature_table%TYPE
   )
      RETURN NUMBER
   IS
      CURSOR c1 (c_tab IN VARCHAR2)
      IS
         SELECT nth_theme_id
           FROM NM_THEMES_ALL
          WHERE nth_feature_table = c_tab;

      retval   NUMBER;
   BEGIN
      OPEN c1 (p_table);
      FETCH c1
       INTO retval;
      IF c1%NOTFOUND
      THEN
         retval := NULL;
      END IF;
      CLOSE c1;
      RETURN retval;
   END get_theme_from_feature_table;
   ------------------------------------------------------------------------
   FUNCTION get_theme_from_feature_table (
      p_table         IN   NM_THEMES_ALL.nth_feature_table%TYPE
     ,p_theme_table   IN   NM_THEMES_ALL.nth_table_name%TYPE
   )
     RETURN NUMBER
   IS
      CURSOR c1 (c_feature_tab IN VARCHAR2
                ,c_theme_tab IN VARCHAR )
      IS
         SELECT nth_theme_id
           FROM NM_THEMES_ALL
          WHERE nth_feature_table = c_feature_tab
            AND nth_table_name    = c_theme_tab;

      retval   NUMBER;
   BEGIN
      OPEN c1 (p_table, p_theme_table);
      FETCH c1
       INTO retval;
      IF c1%NOTFOUND
      THEN
         retval := NULL;
      END IF;
      CLOSE c1;
      RETURN retval;
   END get_theme_from_feature_table;
--
----------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE drop_unused_sequences
   AS
      CURSOR c1
      IS
         SELECT sequence_name
           FROM user_sequences
          WHERE sequence_name LIKE 'NTH%'
            AND NOT EXISTS (
                   SELECT 1
                     FROM NM_THEMES_ALL
                    WHERE TO_CHAR (nth_theme_id) =
                             SUBSTR (sequence_name,
                                     5,
                                     INSTR (SUBSTR (sequence_name, 5), '_')
                                     - 1
                                    ))
            AND sequence_name != 'NTH_THEME_ID_SEQ';
   BEGIN
      FOR irec IN c1
      LOOP
         Nm3ddl.drop_synonym_for_object (irec.sequence_name);
         EXECUTE IMMEDIATE 'drop sequence ' || irec.sequence_name;
      END LOOP;
   END;

--
----------------------------------------------------------------------------------------------------------------------------------
--
-- When updating members, test to see if a theme is immediate - not appropriate to linear layers
--
   FUNCTION get_update_flag (
      p_type          IN   VARCHAR2,
      p_obj_type      IN   VARCHAR2,
      p_update_flag   IN   VARCHAR2 DEFAULT NULL
   )
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (1) := 'N';

      CURSOR c_inv (c_obj_type IN VARCHAR2, c_flag IN VARCHAR2)
      IS
         SELECT nth_update_on_edit
           FROM NM_THEMES_ALL, NM_INV_THEMES
          WHERE nth_theme_id = nith_nth_theme_id
            AND nith_nit_id = c_obj_type
            AND nth_update_on_edit =
                             DECODE (c_flag,
                                     NULL, nth_update_on_edit,
                                     c_flag
                                    );

      CURSOR c_area (c_obj_type IN VARCHAR2, c_flag IN VARCHAR2)
      IS
         SELECT nth_update_on_edit
           FROM NM_THEMES_ALL, NM_AREA_THEMES, NM_AREA_TYPES
          WHERE nth_theme_id = nath_nth_theme_id
            AND nath_nat_id = nat_id
            AND nat_gty_group_type = c_obj_type
            AND nth_update_on_edit =
                             DECODE (c_flag,
                                     NULL, nth_update_on_edit,
                                     c_flag
                                    );
   BEGIN
      IF p_type = 'I'
      THEN
         OPEN c_inv (p_obj_type, p_update_flag);

         FETCH c_inv
          INTO retval;

         IF c_inv%NOTFOUND
         THEN
            retval := 'N';
         END IF;

         CLOSE c_inv;
      ELSIF p_type = 'G'
      THEN
         OPEN c_area (p_obj_type, p_update_flag);

         FETCH c_area
          INTO retval;

         IF c_area%NOTFOUND
         THEN
            retval := 'N';
         END IF;

         CLOSE c_area;
      END IF;

      RETURN retval;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE attach_theme_to_ft (p_nth_id IN NUMBER, p_ft_nit IN VARCHAR2)
   IS
      l_nth   NM_THEMES_ALL%ROWTYPE;
      l_nit   nm_inv_types%ROWTYPE;
   BEGIN
      l_nth := Nm3get.get_nth (p_nth_id);
      l_nit := Nm3get.get_nit (p_ft_nit);

      IF l_nth.nth_table_name != l_nit.nit_table_name
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 249,
                        pi_sqlcode      => -20001
                       );
--  raise_application_error(-20001,'FT and theme do not match');
      ELSE
         INSERT INTO NM_INV_THEMES
                     (nith_nit_id, nith_nth_theme_id
                     )
              VALUES (l_nit.nit_inv_type, l_nth.nth_theme_id
                     );
      END IF;
   END;

--
-------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE register_sdo_table_as_ft_theme (
      p_nit_type           IN   nm_inv_types.nit_inv_type%TYPE,
      p_shape_col          IN   VARCHAR2,
      p_tol                IN   NUMBER DEFAULT 0.005,
      p_cre_idx            IN   VARCHAR2 DEFAULT 'N',
      p_estimate_new_tol   IN   VARCHAR2 DEFAULT 'N'
   )
   IS
      l_nit      nm_inv_types%ROWTYPE;
      l_nth_id   NUMBER;
   BEGIN
      l_nit := Nm3get.get_nit (p_nit_type);

      IF l_nit.nit_table_name IS NULL
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 250,
                        pi_sqlcode      => -20001
                       );
--  raise_application_error( -20001, 'Inventory type is not a foreign table');
      END IF;

      Nm3sdo.register_sdo_table_as_theme (l_nit.nit_table_name,
                                          l_nit.nit_foreign_pk_column,
                                          l_nit.nit_foreign_pk_column,
                                          p_shape_col,
                                          p_tol,
                                          p_cre_idx,
                                          p_estimate_new_tol
                                         );
      l_nth_id := get_theme_from_feature_table (l_nit.nit_table_name);
      attach_theme_to_ft (l_nth_id, l_nit.nit_inv_type);
   END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE Drop_Layer (
      p_nth_id               IN   NM_THEMES_ALL.nth_theme_id%TYPE,
      p_keep_theme_data      IN   VARCHAR2 DEFAULT 'N',
      p_keep_feature_table   IN   VARCHAR2 DEFAULT 'N'
   )
   IS
      l_nth         NM_THEMES_ALL%ROWTYPE;
      l_seq         VARCHAR2 (30);
--
   BEGIN
      l_nth := Nm3get.get_nth (p_nth_id);

      drop_trigger_by_theme_id( p_nth_id );

      IF l_nth.nth_feature_table IS NOT NULL
      THEN
         IF Hig.get_sysopt ('REGSDELAY') = 'Y'
         THEN
            DECLARE
               not_there   EXCEPTION;
               PRAGMA EXCEPTION_INIT (not_there, -20001);
            BEGIN
               EXECUTE IMMEDIATE (   'begin '
                                  || '   nm3sde.drop_layer_by_theme( p_theme_id => '
                                  || TO_CHAR (l_nth.nth_theme_id)
                                  || ');'
                                  || 'end;'
                                 );
            EXCEPTION
               WHEN not_there
               THEN
                  NULL;
            END;
         END IF;

         IF p_keep_feature_table = 'N'
         THEN
            BEGIN
               --Nm3ddl.drop_synonym_for_object (l_nth.nth_feature_table);

               -- AE 23-SEP-2008
               -- Drop views instead of synonyms
               Nm3ddl.drop_views_for_object (l_nth.nth_feature_table);

            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            --    problem in privileges on the development schema - dropping synonyms failed - needs further investigation.
            END;

            BEGIN
               --cws
               Nm3ddl.drop_synonym_for_object (l_nth.nth_feature_table);

            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            --    problem in privileges on the development schema - dropping synonyms failed - needs further investigation.
            END;

            drop_object (l_nth.nth_feature_table);
            Nm3sdo.drop_metadata (l_nth.nth_feature_table);

            IF Nm3sdo.use_surrogate_key = 'Y'
            THEN
               l_seq := Nm3sdo.get_spatial_seq (p_nth_id);

               IF Nm3ddl.does_object_exist (l_seq)
               THEN
                  BEGIN
                     Nm3ddl.drop_synonym_for_object (l_seq);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;

                  drop_object (l_seq);
               END IF;
            END IF;
         -- keep feature table end if
         END IF;
      END IF;
--
      IF p_keep_theme_data = 'N'
      THEN
         DELETE FROM NM_THEMES_ALL
               WHERE nth_theme_id = p_nth_id;
      END IF;
--
   END Drop_Layer;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE drop_object (p_object_name IN VARCHAR2)
   IS
      l_obj_type   VARCHAR2 (30);
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      IF Nm3ddl.does_object_exist (p_object_name)
      THEN
         l_obj_type := get_object_type (p_object_name);

         EXECUTE IMMEDIATE 'drop ' || l_obj_type || ' ' || p_object_name;
      END IF;
   END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION get_object_type (p_object IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_owner   VARCHAR2 (30) := Sys_Context('NM3CORE','APPLICATION_OWNER');

      CURSOR c1 (c_object IN VARCHAR2, c_owner IN VARCHAR2)
      IS
         SELECT object_type
           FROM all_objects
          WHERE owner = c_owner AND object_name = c_object;

      retval    VARCHAR2 (30);
   BEGIN
      OPEN c1 (p_object, l_owner);

      FETCH c1
       INTO retval;

      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 257,
                        pi_sqlcode      => -20001
                       );
      END IF;

      CLOSE c1;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE drop_trigger_by_theme_id ( p_nth_id IN nm_themes_all.nth_theme_id%TYPE ) IS
   
    -- CWS 0110345 Trigger changed to ignore nm_themes_all. Table nm_themes_all 
    -- is no longer referenced in cursor and any exception raised by dynamic sql
    -- will be caught. 
   CURSOR c_trig (c_nth_id IN nm_themes_all.nth_theme_id%TYPE ) IS
     SELECT trigger_name
     FROM user_triggers
     WHERE trigger_name LIKE 'NM_NTH_' || TO_CHAR(c_nth_id) || '_SDO%';
   --
   BEGIN
     
     FOR irec IN c_trig( p_nth_id ) LOOP
       BEGIN
         EXECUTE IMMEDIATE 'DROP TRIGGER '||irec.trigger_name;
       EXCEPTION
       WHEN OTHERS THEN
         NULL;
       END;
     END LOOP;
   END;
--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE drop_layers_by_inv_type (
      p_nit_id       IN   nm_inv_types.nit_inv_type%TYPE,
      p_keep_table   IN   BOOLEAN DEFAULT FALSE
   )
   IS
      CURSOR c1 (c_nit IN nm_inv_types.nit_inv_type%TYPE)
      IS
         SELECT nith_nth_theme_id
           FROM NM_INV_THEMES, NM_THEMES_ALL
          WHERE nith_nit_id = c_nit
    AND   nth_theme_id = nith_nth_theme_id
    ORDER BY DECODE(nth_base_table_theme, NULL, 'B', 'A') ;

      l_tab_nth_id   Nm3type.tab_number;
      l_keep_table   VARCHAR2 (1);
   BEGIN
      IF p_keep_table
      THEN
         l_keep_table := 'Y';
      ELSE
         l_keep_table := 'N';
      END IF;

      OPEN c1 (p_nit_id);

      FETCH c1
      BULK COLLECT INTO l_tab_nth_id;

      CLOSE c1;

--   Nm_Debug.debug_on;
         FOR i IN 1 .. l_tab_nth_id.COUNT
      LOOP
--Nm_Debug.DEBUG('drop '||TO_CHAR(l_tab_nth_id (i)));
         Nm3sdm.Drop_Layer (p_nth_id                  => l_tab_nth_id (i),
                            p_keep_feature_table      => l_keep_table
                           );
      END LOOP;
   END drop_layers_by_inv_type;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE drop_layers_by_gty_type (
      p_gty   IN   nm_group_types.ngt_group_type%TYPE
   )
   IS
      CURSOR c1 (c_gty IN nm_group_types.ngt_group_type%TYPE)
      IS
         SELECT nnth_nth_theme_id, DECODE(nth_base_table_theme, NULL, 'A', 'B')
           FROM NM_NW_THEMES, NM_LINEAR_TYPES, NM_THEMES_ALL
          WHERE nnth_nlt_id = nlt_id
            AND nlt_gty_type = c_gty
            AND nnth_nth_theme_id = nth_theme_id
         UNION
         SELECT nath_nth_theme_id, DECODE(nth_base_table_theme, NULL, 'A', 'B')
           FROM NM_AREA_THEMES, NM_AREA_TYPES, NM_THEMES_ALL
          WHERE nath_nat_id = nat_id
            AND nat_gty_group_type = c_gty
            AND nath_nth_theme_id = nth_theme_id
          ORDER BY 2 DESC;
 --
   l_tab_nth_id   Nm3type.tab_number;
   l_tab_order    Nm3type.tab_varchar1;
 --
   BEGIN
      OPEN c1 (p_gty);
      FETCH c1
      BULK COLLECT INTO l_tab_nth_id, l_tab_order;
      CLOSE c1;
      FOR i IN 1 .. l_tab_nth_id.COUNT
      LOOP
         Nm3sdm.Drop_Layer (p_nth_id => l_tab_nth_id (i));
      END LOOP;
   END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION type_has_shape (p_type IN VARCHAR2)
      RETURN BOOLEAN
   IS
      CURSOR c1 (c_type IN VARCHAR2)
      IS
         SELECT 1
           FROM DUAL
          WHERE EXISTS (
                   SELECT 1
                     FROM NM_AREA_TYPES
                    WHERE nat_gty_group_type = c_type
                   UNION
                   SELECT 1
                     FROM NM_INV_THEMES
                    WHERE nith_nit_id = c_type);

      retval   BOOLEAN;
      dummy    NUMBER;
   BEGIN
      OPEN c1 (p_type);

      FETCH c1
       INTO dummy;

      retval := c1%FOUND;

      CLOSE c1;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   FUNCTION theme_is_ft (p_nth_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
      RETURN BOOLEAN
   IS
      CURSOR c1 (c_nth IN NM_THEMES_ALL.nth_theme_id%TYPE)
      IS
         SELECT nth_theme_id
           FROM NM_THEMES_ALL, NM_INV_THEMES, nm_inv_types
          WHERE nth_theme_id = nith_nth_theme_id
            AND nith_nit_id = nit_inv_type
            AND nit_table_name IS NOT NULL;

      retval    BOOLEAN := FALSE;
      l_dummy   NUMBER;
   BEGIN
      OPEN c1 (p_nth_theme_id);

      FETCH c1
       INTO l_dummy;

      retval := c1%FOUND;

      CLOSE c1;

      RETURN retval;
   END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE set_subuser_globals_nthr (
      pi_role       IN   NM_THEME_ROLES.nthr_role%TYPE,
      pi_theme_id   IN   NM_THEME_ROLES.nthr_theme_id%TYPE,
      pi_mode       IN   VARCHAR2
   )
   IS
   BEGIN
      Nm3sdm.g_role_array (Nm3sdm.g_role_idx) := pi_role;
      Nm3sdm.g_theme_role (Nm3sdm.g_role_idx) := pi_theme_id;
      Nm3sdm.g_role_op (Nm3sdm.g_role_idx)    := pi_mode;
   END set_subuser_globals_nthr;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE set_subuser_globals_hur (
      pi_role       IN   NM_THEME_ROLES.nthr_role%TYPE,
      pi_username   IN   HIG_USER_ROLES.hur_username%TYPE,
      pi_mode       IN   VARCHAR2
   )
   IS
   BEGIN
      Nm3sdm.g_role_array (Nm3sdm.g_role_idx)     := pi_role;
      Nm3sdm.g_username_array (Nm3sdm.g_role_idx) := pi_username;
      Nm3sdm.g_role_op (Nm3sdm.g_role_idx)        := pi_mode;
   END set_subuser_globals_hur;

--
---------------------------------------------------------------------------------------------------------------------------------
--
  PROCEDURE drop_feature_view (pi_owner IN VARCHAR2, pi_view_name IN VARCHAR2 )
  IS
    PRAGMA autonomous_transaction;
  BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'DROP VIEW '||pi_owner||'.'||pi_view_name;
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;

  BEGIN
    EXECUTE IMMEDIATE 'DROP SYNONYM '||pi_owner||'.'||pi_view_name;
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;
  END drop_feature_view;
--
---------------------------------------------------------------------------------------------------------------------------------
--
  PROCEDURE create_feature_view (pi_owner IN VARCHAR2, pi_view_name IN VARCHAR2 )
  IS
    PRAGMA autonomous_transaction;
  BEGIN
    BEGIN
      -- CWS
      --EXECUTE IMMEDIATE 'DROP SYNONYM '|| pi_owner||'.'|| pi_view_name;
      EXECUTE IMMEDIATE 'DROP VIEW '|| pi_owner||'.'|| pi_view_name;
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
    BEGIN
      -- CWS
      --EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW '||pi_owner||'.'||pi_view_name
      --                  ||' AS SELECT * FROM '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||pi_view_name;
      EXECUTE IMMEDIATE ('CREATE OR REPLACE SYNONYM '|| pi_owner ||'.'|| pi_view_name || ' FOR ' || Sys_Context('NM3CORE','APPLICATION_OWNER') || '.' || pi_view_name);
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END create_feature_view;
--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE process_subuser_nthr
/* Procedure to deal with creating subordinate user metadata triggered on
   nm_theme_roles data */
   IS
   --
      PROCEDURE create_sub_sdo_layer
                    ( pi_theme_id IN nm_themes_all.nth_theme_id%TYPE
                    , pi_role     IN nm_theme_roles.nthr_role%TYPE )
      IS
      BEGIN
      --
      -- Insert the USGM based on current theme and role
      --
        INSERT INTO MDSYS.sdo_geom_metadata_table g
          (sdo_owner, sdo_table_name, sdo_column_name, sdo_diminfo, sdo_srid)
        SELECT hus_username, nth_feature_table, nth_feature_shape_column, sdo_diminfo, sdo_srid
          FROM MDSYS.sdo_geom_metadata_table u,
               (SELECT hus_username, nth_feature_table, nth_feature_shape_column
                  FROM
                       -- Layers based on role - more than likely views
                       (SELECT hus_username,
                               a.nth_feature_table,
                               a.nth_feature_shape_column
                          FROM nm_themes_all a,
                               nm_theme_roles,
                               hig_user_roles,
                               hig_users,
                               all_users
                         WHERE nthr_theme_id = a.nth_theme_id
                           AND a.nth_theme_id = pi_theme_id
                           AND nthr_role    = hur_role
                           AND hur_role     = pi_role
                           AND hur_username = hus_username
                           AND hus_username = username
                           AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM MDSYS.sdo_geom_metadata_table g1
                                   WHERE g1.sdo_owner = hus_username
                                     AND g1.sdo_table_name = nth_feature_table
                                     AND g1.sdo_column_name = nth_feature_shape_column)
                        UNION ALL
                        -- Base table themes
                        SELECT hus_username,
                               b.nth_feature_table,
                               b.nth_feature_shape_column
                          FROM nm_themes_all a,
                               hig_users,
                               all_users,
                               nm_themes_all b
                         WHERE b.nth_theme_id = a.nth_base_table_theme
                           AND a.nth_theme_id = pi_theme_id
                           AND hus_username = username
                           AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM MDSYS.sdo_geom_metadata_table g1
                                   WHERE g1.sdo_owner = hus_username
                                     AND g1.sdo_table_name = b.nth_feature_table
                                     AND g1.sdo_column_name = b.nth_feature_shape_column))
                GROUP BY hus_username, nth_feature_table, nth_feature_shape_column)
         WHERE u.sdo_table_name = nth_feature_table
           AND u.sdo_column_name = nth_feature_shape_column
           AND u.sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER');

--         nm_debug.debug('Inserted '||SQL%ROWCOUNT||' SDO metadata rows');
      --
        FOR i IN
         (SELECT hus_username, nth_feature_table, nth_feature_shape_column
            FROM
             -- Layers based on role - more than likely views
             (SELECT hus_username, nth_feature_table,  nth_feature_shape_column
                FROM nm_themes_all a,
                     nm_theme_roles,
                     hig_user_roles,
                     hig_users,
                     all_users
               WHERE nthr_theme_id = a.nth_theme_id
                 AND a.nth_theme_id = pi_theme_id
                 AND nthr_role    = hur_role
                 AND hur_role     = pi_role
                 AND hur_username = hus_username
                 AND hus_username = username
                 AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
              UNION ALL
              -- Base table themes
              SELECT hus_username,
                     b.nth_feature_table,
                     b.nth_feature_shape_column
                FROM nm_themes_all a,
                     hig_users,
                     all_users,
                     nm_themes_all b
               WHERE b.nth_theme_id = a.nth_base_table_theme
                 AND a.nth_theme_id = pi_theme_id
                 AND hus_username = username
                 AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER'))
          GROUP BY hus_username, nth_feature_table, nth_feature_shape_column)
        LOOP
        --
          create_feature_view (i.hus_username, i.nth_feature_table);
          --
          --nm_debug.debug('SDE = '||TO_CHAR (nm3sdm.g_theme_role (i))||' - '||u.hus_username);
          IF hig.get_user_or_sys_opt('REGSDELAY') = 'Y'
            THEN
            BEGIN
              EXECUTE IMMEDIATE
                (' begin '||
                    'nm3sde.create_sub_sde_layer ( p_theme_id => '|| pi_theme_id
                                              || ',p_username => '''|| i.hus_username
                                           || ''');'||
                 ' end;');
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
          --
          END IF;
        --
        END LOOP;
    --
      END create_sub_sdo_layer;
    --
    --------------------------------------------------------------------------
    --
      PROCEDURE delete_sub_sdo_layer
                  ( pi_theme_id IN nm_themes_all.nth_theme_id%TYPE
                  , pi_role     IN nm_theme_roles.nthr_role%TYPE )
      IS
        l_tab_owner       nm3type.tab_varchar30;
        l_tab_table_name  nm3type.tab_varchar30;
        l_tab_column_name nm3type.tab_varchar30;

      --
      BEGIN
      --
        SELECT hus_username, nth_feature_table, nth_feature_shape_column
          BULK COLLECT INTO l_tab_owner, l_tab_table_name, l_tab_column_name
          FROM (SELECT hus_username, nth_feature_table, nth_feature_shape_column
                  FROM (SELECT hus_username,
                               a.nth_feature_table,
                               a.nth_feature_shape_column
                          FROM nm_themes_all a,
                               hig_user_roles,
                               hig_users,
                               all_users
                         WHERE a.nth_theme_id = pi_theme_id
                           AND hur_role     = pi_role
                           AND hur_username = hus_username
                           AND hus_username = username
                           AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
                           AND NOT EXISTS
                              (SELECT 1 FROM hig_user_roles, nm_theme_roles r
                                 WHERE hur_username = hus_username
                                   and hur_role    = nthr_role
                                   and nthr_theme_id = a.nth_theme_id
                                   AND hur_role    != pi_role)
                GROUP BY hus_username, nth_feature_table, nth_feature_shape_column)) layers;
      --
        IF l_tab_owner.COUNT > 0
        THEN
          FORALL i IN 1..l_tab_owner.COUNT
            DELETE mdsys.sdo_geom_metadata_table
             WHERE sdo_owner       = l_tab_owner(i)
               AND sdo_table_name  = l_tab_table_name(i)
               AND sdo_column_name = l_tab_column_name(i);

        -----------------------------------
        -- Drop subordinate feature views
        -----------------------------------

          FOR i IN 1..l_tab_owner.COUNT LOOP

            drop_feature_view (l_tab_owner(i), l_tab_table_name(i));

          -----------------------------------------
          -- Drop SDE layers for subordinate users
          -----------------------------------------

            IF hig.get_user_or_sys_opt('REGSDELAY') = 'Y'
            THEN
              BEGIN
                EXECUTE IMMEDIATE 'begin '||
                                     'nm3sde.drop_sub_layer_by_table( '
                                                ||Nm3flx.string(l_tab_table_name(i))||','
                                                ||Nm3flx.string(l_tab_column_name(i))||','
                                                ||Nm3flx.string(l_tab_owner(i))||');'
                               ||' end;';
            --
              EXCEPTION
                WHEN OTHERS THEN NULL;
              END;
            END IF;

          END LOOP;

        END IF;

--        nm_debug.debug('Deleted '||l_tab_owner.COUNT||' SDO metadata rows');
      --
      END delete_sub_sdo_layer;
  --
   BEGIN
  --
  --------------------------------------------------------------
  -- Loop through the rows being processed from nm_theme_roles
  --------------------------------------------------------------

    -----------
    -- INSERTS
    -----------

     FOR i IN 1 .. Nm3sdm.g_role_idx
     LOOP

       BEGIN
--         nm_debug.debug('Role op for '||i||' is '||Nm3sdm.g_role_op (i));

         IF Nm3sdm.g_role_op (i) = 'I'
         THEN

--           nm_debug.debug('Create '||nm3sdm.g_theme_role (i));

           create_sub_sdo_layer
              ( pi_theme_id => nm3sdm.g_theme_role (i)
              , pi_role     => nm3sdm.g_role_array (i) );
       --
       ----------
       -- DELETES
       ----------

         ELSIF Nm3sdm.g_role_op (i) = 'D'
         THEN
--           nm_debug.debug('Delete '||nm3sdm.g_theme_role (i));
           delete_sub_sdo_layer
              ( pi_theme_id =>  nm3sdm.g_theme_role (i)
              , pi_role     =>  nm3sdm.g_role_array (i) );
         --
         END IF;

       EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
       END;

     END LOOP;

   --
   EXCEPTION
     WHEN NO_DATA_FOUND THEN NULL;
   --
   END process_subuser_nthr;

--
---------------------------------------------------------------------------------------------------------------------------------
--
   PROCEDURE process_subuser_hur
/* Procedure to deal with creating subordinate user metadata triggered on
   nm_theme_roles data */
   IS
   --
     PROCEDURE create_sub_sdo_layers (pi_username IN hig_users.hus_username%TYPE
                                     ,pi_role     IN nm_theme_roles.nthr_role%TYPE )
     IS
       l_user hig_users.hus_username%TYPE := pi_username;
     BEGIN
     --
       INSERT INTO MDSYS.sdo_geom_metadata_table g
             (sdo_owner, sdo_table_name, sdo_column_name, sdo_diminfo, sdo_srid)
         SELECT l_user, nth_feature_table, nth_feature_shape_column, sdo_diminfo, sdo_srid
           FROM MDSYS.sdo_geom_metadata_table u,
                (SELECT nth_feature_table, nth_feature_shape_column
                   FROM
                        -- Layers based on role - more than likely views
                        (SELECT a.nth_feature_table,
                                a.nth_feature_shape_column
                           FROM nm_themes_all a,
                                nm_theme_roles
                          WHERE nthr_theme_id = a.nth_theme_id
                            AND nthr_role    = pi_role
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM MDSYS.sdo_geom_metadata_table g1
                                    WHERE g1.sdo_owner = l_user
                                      AND g1.sdo_table_name = nth_feature_table
                                      AND g1.sdo_column_name = nth_feature_shape_column)
                         UNION ALL
                         -- Base table themes
                         SELECT b.nth_feature_table,
                                b.nth_feature_shape_column
                           FROM nm_themes_all a,
                                nm_theme_roles,
                                nm_themes_all b
                          WHERE b.nth_theme_id = a.nth_base_table_theme
                            AND nthr_theme_id = a.nth_theme_id
                            AND nthr_role    = pi_role
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM MDSYS.sdo_geom_metadata_table g1
                                    WHERE g1.sdo_owner = l_user
                                      AND g1.sdo_table_name = b.nth_feature_table
                                      AND g1.sdo_column_name = b.nth_feature_shape_column))
                 GROUP BY nth_feature_table, nth_feature_shape_column)
          WHERE u.sdo_table_name = nth_feature_table
            AND u.sdo_column_name = nth_feature_shape_column
            AND u.sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER');
     --
--       nm_debug.debug('Inserted '||SQL%ROWCOUNT||' rows for role '||pi_role||' on user '||pi_username);
     --
       FOR i IN
         (SELECT * FROM
           (SELECT nth_theme_id, nth_feature_table, nth_feature_shape_column
             FROM
                  -- Layers based on role - more than likely views
                  (SELECT a.nth_theme_id, a.nth_feature_table,
                          a.nth_feature_shape_column
                     FROM nm_themes_all a,
                          nm_theme_roles
                    WHERE nthr_theme_id = a.nth_theme_id
                      AND nthr_role    = pi_role
                   UNION ALL
                   -- Base table themes
                   SELECT b.nth_theme_id, b.nth_feature_table,
                          b.nth_feature_shape_column
                     FROM nm_themes_all a,
                          nm_theme_roles,
                          nm_themes_all b
                    WHERE b.nth_theme_id = a.nth_base_table_theme
                      AND nthr_theme_id = a.nth_theme_id
                      AND nthr_role    = pi_role)
           GROUP BY nth_theme_id, nth_feature_table, nth_feature_shape_column))
       LOOP
       --
         create_feature_view (pi_username, i.nth_feature_table);
       --
         IF hig.get_user_or_sys_opt('REGSDELAY') = 'Y'
         THEN
         --
           BEGIN
             EXECUTE IMMEDIATE
               (' begin '||
                   'nm3sde.create_sub_sde_layer ( p_theme_id => '|| TO_CHAR (i.nth_theme_id)
                                             || ',p_username => '''|| pi_username
                                          || ''');'||
                ' end;');
           EXCEPTION
             WHEN OTHERS THEN NULL;
           END;
         END IF;
       END LOOP;
     EXCEPTION
       WHEN OTHERS
       THEN NULL;
     END create_sub_sdo_layers;
   --
     PROCEDURE delete_sdo_layers_by_role ( pi_username IN hig_users.hus_username%TYPE
                                         , pi_role     IN nm_theme_roles.nthr_role%TYPE )
     IS
        l_tab_owner       nm3type.tab_varchar30;
        l_tab_table_name  nm3type.tab_varchar30;
        l_tab_column_name nm3type.tab_varchar30;
     BEGIN
       SELECT hus_username, nth_feature_table, nth_feature_shape_column
          BULK COLLECT INTO l_tab_owner, l_tab_table_name, l_tab_column_name
          FROM (SELECT hus_username, nth_feature_table, nth_feature_shape_column
                  FROM (SELECT hus_username,
                               a.nth_feature_table,
                               a.nth_feature_shape_column
                          FROM nm_themes_all a,
                               nm_theme_roles,
                               hig_users,
                               all_users
                         WHERE nthr_theme_id = a.nth_theme_id
                           AND nthr_role     = pi_role
                           AND hus_username  = username
                           AND username      = pi_username
                           AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
                           AND NOT EXISTS
                              (SELECT 1 FROM hig_user_roles, nm_theme_roles r
                                 WHERE hur_username = pi_username
                                   and hur_role    = nthr_role
                                   and nthr_theme_id = a.nth_theme_id
                                   AND hur_role    != pi_role)
                GROUP BY hus_username, nth_feature_table, nth_feature_shape_column)) layers;
     --
        IF l_tab_owner.COUNT > 0
        THEN

          FORALL i IN 1..l_tab_owner.COUNT
            DELETE mdsys.sdo_geom_metadata_table
             WHERE sdo_owner       = l_tab_owner(i)
               AND sdo_table_name  = l_tab_table_name(i)
               AND sdo_column_name = l_tab_column_name(i);

        -----------------------------------
        -- Drop subordinate feature views
        -----------------------------------

          FOR i IN 1..l_tab_owner.COUNT LOOP

            drop_feature_view (l_tab_owner(i), l_tab_table_name(i));

        -----------------------------------------
        -- Drop SDE layers for subordinate users
        -----------------------------------------

            IF hig.get_user_or_sys_opt('REGSDELAY') = 'Y'
            THEN
             --
                 BEGIN
                   EXECUTE IMMEDIATE 'begin '||
                                        'nm3sde.drop_sub_layer_by_table( '
                                                   ||Nm3flx.string(l_tab_table_name(i))||','
                                                   ||Nm3flx.string(l_tab_column_name(i))||','
                                                   ||Nm3flx.string(l_tab_owner(i))||');'
                                  ||' end;';
               --
                 EXCEPTION
                   WHEN OTHERS THEN NULL;
                 END;
             --
            END IF;

          END LOOP;

        END IF;
     --
     END delete_sdo_layers_by_role;
  --
   BEGIN
  --
     FOR i IN 1 .. Nm3sdm.g_role_idx
     LOOP

       BEGIN
     --
     -- INSERTS
     --
          IF Nm3sdm.g_role_op (Nm3sdm.g_role_idx) = 'I'
          THEN
          --
            create_sub_sdo_layers
              ( pi_username => nm3sdm.g_username_array (i)
              , pi_role     => nm3sdm.g_role_array (i)  );

       --
       --
       -- DELETES
       --
          ELSIF Nm3sdm.g_role_op (Nm3sdm.g_role_idx) = 'D'
          THEN
          --
            delete_sdo_layers_by_role
              ( pi_username =>  nm3sdm.g_username_array (i)
              , pi_role     =>  nm3sdm.g_role_array (i) );
         --
         END IF;

       EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
       END;
     --
     END LOOP;
   --
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   --
   END process_subuser_hur;
--
---------------------------------------------------------------------------------------------------------------------------------
--

   PROCEDURE create_nth_sdo_trigger (p_nth_theme_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE
                                    ,p_restrict       IN   VARCHAR2 DEFAULT NULL
   )
   IS
      lf                    VARCHAR2 (1)                     := CHR (10);
      lq                    VARCHAR2 (1)                     := CHR (39);
      l_update_str          VARCHAR2 (2000);
      l_comma               VARCHAR2 (1)                     := NULL;
      l_srid                VARCHAR2 (10);
      l_trg_name            VARCHAR2 (30);
      l_tab_or_view         VARCHAR2 (5);
      l_date                VARCHAR2 (100);
      l_nth                 NM_THEMES_ALL%ROWTYPE;
      l_base_table_nth      NM_THEMES_ALL%ROWTYPE;
      l_sdo                 user_sdo_geom_metadata%ROWTYPE;
      l_tab_vc              Nm3type.tab_varchar32767;

      CURSOR c1 (objname IN VARCHAR2)
      IS
         SELECT object_type
           FROM user_objects
          WHERE object_name = objname;

      ex_invalid_sequence   EXCEPTION;

--
   --
   -- Function eventually needs to go into nm3sdo package
   --
      FUNCTION get_sdo_trg_name_a (
         p_nth_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE
      )
         RETURN VARCHAR2
      IS
      BEGIN
         RETURN ('NM_NTH_' || TO_CHAR (p_nth_id) || '_SDO_A_ROW_TRG');
      END get_sdo_trg_name_a;

--
   --
   -- Function eventually needs to go into nm3sdo package
   --
      FUNCTION get_sdo_trg_name_b (
         p_nth_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE
      )
         RETURN VARCHAR2
      IS
      BEGIN
         RETURN ('NM_NTH_' || TO_CHAR (p_nth_id) || '_SDO_B_ROW_TRG');
      END get_sdo_trg_name_b;

--
      PROCEDURE append (pi_text IN Nm3type.max_varchar2)
      IS
      BEGIN
         Nm3ddl.append_tab_varchar (l_tab_vc, pi_text);
      END append;
--
   BEGIN
--
  --
  -- Driving Theme
  --
      l_nth := Nm3get.get_nth (pi_nth_theme_id => p_nth_theme_id);

      --
      -- Base Table Theme
      --
      IF l_nth.nth_base_table_theme IS NULL
      THEN
         l_base_table_nth := l_nth;        -- base theme is the driving theme
      ELSE
         l_base_table_nth :=
               Nm3get.get_nth (pi_nth_theme_id      => l_nth.nth_base_table_theme);
      END IF;

      l_sdo := Nm3sdo.get_theme_metadata (l_base_table_nth.nth_theme_id);
      l_srid := NVL (TO_CHAR (l_sdo.srid), 'NULL');

      OPEN c1 (l_base_table_nth.nth_table_name);

      FETCH c1
       INTO l_tab_or_view;

      CLOSE c1;

      -- If the theme has an associated sequence then ensure that the sequence
      -- actually exists - cos we are about to reference it in our generated trigger
      --
      IF l_base_table_nth.nth_sequence_name IS NOT NULL
      THEN
         IF NOT Nm3ddl.does_object_exist
                        (p_object_name      => l_base_table_nth.nth_sequence_name,
                         p_object_type      => 'SEQUENCE'
                        )
         THEN
            RAISE ex_invalid_sequence;
         END IF;
      END IF;

--    we need to differentiate between join FT data and single table FT data. The first needs an after trigger the second should not be using this
--    approach - it just needs a theme trigger to set the column, no insert/update/delete.


      l_trg_name := get_sdo_trg_name_a (l_base_table_nth.nth_theme_id);

      IF l_base_table_nth.nth_rse_fk_column IS NOT NULL
      THEN
         l_update_str := l_base_table_nth.nth_rse_fk_column;
         l_comma := ',';
      END IF;

      IF l_base_table_nth.nth_st_chain_column IS NOT NULL
      THEN
         l_update_str :=
              l_update_str || l_comma || l_base_table_nth.nth_st_chain_column;
         l_comma := ',';
      END IF;

      IF l_base_table_nth.nth_end_chain_column IS NOT NULL
      THEN
         l_update_str :=
             l_update_str || l_comma || l_base_table_nth.nth_end_chain_column;
         l_comma := ',';
      END IF;

      -- if the x and y column are used as drivers, there should be no triggering
      -- when the element FK or offsets are changed.
      IF l_base_table_nth.nth_x_column IS NOT NULL
      THEN
         l_update_str := l_base_table_nth.nth_x_column;
         l_comma := ',';
      END IF;

      IF l_base_table_nth.nth_y_column IS NOT NULL
      THEN
         l_update_str :=
                     l_update_str || l_comma || l_base_table_nth.nth_y_column;
      END IF;

--
      l_tab_vc.DELETE;
-- This is the more common trigger - a theme by pure XY or by LRef.
-- The trigger is an after row trigger and will fire on either update
-- of XY or on update of LRef columns.
      append ('CREATE OR REPLACE TRIGGER ' || LOWER (l_trg_name));
      l_date := TO_CHAR (SYSDATE, 'DD-MON-YYYY HH:MI');
      append ('--');
      append
         ('--------------------------------------------------------------------------'
         );
      append ('--');
  /*    append ('--   SCCS Identifiers :- ');
      append ('--');
      append ('--       sccsid           : @(#)nm3sdm.pkb 1.25 06/10/05');
      append ('--       Module Name      : nm3sdm.pkb');
      append ('--       Date into SCCS   : 05/06/10 09:15:36');
      append ('--       Date fetched Out : 05/06/21 09:36:13');
      append ('--       SCCS Version     : 1.25');
      append ('--');
   */
   --   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdm.pkb-arc   2.47   Jul 04 2011 16:51:38   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3sdm.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2011 16:51:38  $
--       Date fetched Out : $Modtime:   Jul 04 2011 16:13:14  $
--       PVCS Version     : $Revision:   2.47  $

      append ('--   PVCS Identifiers :-');
      append ('--');
      append ('--       PVCS id          : $Header::   //vm_latest/archives/nm3/admin/pck/nm3sdm.pkb-arc   '|| get_body_version);
      append ('--       Module Name      : $Workfile:   nm3sdm.pkb  $');
      append ('--       Version          : ' || g_body_sccsid);
      append ('--');
      append ('-----------------------------------------------------------------------------');
      append ('--    Copyright (c) exor corporation ltd, 2010');
      append ('-----------------------------------------------------------------------------');
      append ('-- Author : R Coupe');
      append ('--          G Johnson / A Edwards');
      append ('--');
      append ('--  #################');
      append ('--  # DO NOT MODIFY #');
      append ('--  #################');
      append ('--');
      append (   '-- Trigger is built dynamically from the theme '
              || l_nth.nth_theme_id
              || ' on '
              || l_nth.nth_theme_name
             );
      append ('--');
      append ('-- Generated on ' || l_date);
      append ('--');
      append (' ');

-- Need to cater for views or tables
-- difficulty with views is that the update seldom occurs on the view!
      IF l_tab_or_view = 'TABLE'
      THEN
         append ('AFTER');
      ELSE
         append ('INSTEAD OF ');
      END IF;

      append ('DELETE OR INSERT OR UPDATE of ' || LOWER (l_update_str));
      append ('ON ' || l_base_table_nth.nth_table_name);
      append ('FOR EACH ROW');
      -- CWS task 0108359
    /*  IF p_restrict IS NOT NULL THEN
        append ('WHEN (OLD.' ||p_restrict || ' )');
      END IF;*/
      --
      append ('DECLARE' || lf);
      append (' l_geom mdsys.sdo_geometry;');
      append (' l_lref nm_lref;' || lf);
      append ('--');
      append
         ('--------------------------------------------------------------------------'
         );
      append ('--');
--
-- DELETE PROCEDURE
--
      append (' PROCEDURE del IS ');
      append (' BEGIN');
      append ('');
      append (   '    -- Delete from feature table '
              || LOWER (l_base_table_nth.nth_feature_table)
             );
      append ('    DELETE FROM ' || LOWER (l_base_table_nth.nth_feature_table));
      append (   '          WHERE '
              || LOWER (NVL(l_base_table_nth.nth_feature_fk_column, l_base_table_nth.nth_feature_pk_column))
              || ' = :OLD.'
              || LOWER (l_base_table_nth.nth_pk_column)
              || ';'
             );
      append (' ');
      append
         (' EXCEPTION -- when others to cater for attempted delete where no geom values supplied e.g. no x/y'
         );
      append ('     WHEN others THEN');
      append ('       Null;');
      append (' END del;');
      append ('--');
      append
         ('--------------------------------------------------------------------------'
         );
      append ('--');
--
-- INSERT PROCEDURE
--
      append (' PROCEDURE ins IS ');
      append (' BEGIN');
      append ('');
      append (   '   -- Insert into feature table '
              || LOWER (l_base_table_nth.nth_feature_table)
             );
      append ('    INSERT INTO ' || LOWER (l_base_table_nth.nth_feature_table));
      append ('    ( ' || LOWER (l_base_table_nth.nth_feature_pk_column));
      append ('    , ' || LOWER (l_base_table_nth.nth_feature_shape_column));

      IF l_base_table_nth.nth_sequence_name IS NOT NULL
      THEN
         append ('    , objectid');
      END IF;

      append ('    )');
      append ('    VALUES ');
      append ('    ( :NEW.' || LOWER (l_base_table_nth.nth_pk_column));

--------------------------------------------------------------------------------------
-- POINT X,Y ITEM
--------------------------------------------------------------------------------------
      IF     l_base_table_nth.nth_x_column IS NOT NULL
         AND l_base_table_nth.nth_y_column IS NOT NULL
      THEN
         append ('    , mdsys.sdo_geometry');
         append ('       ( 2001');
         append ('       , ' || l_srid);
         append ('       , mdsys.sdo_point_type');
         append ('          ( :NEW.' || LOWER (l_base_table_nth.nth_x_column));
         append ('           ,:NEW.' || LOWER (l_base_table_nth.nth_y_column));
         append ('           , NULL)');
         append ('       , NULL');
         append ('       , NULL) -- geometry derived from X,Y values');
--------------------------------------------------------------------------------------
-- POINT Linear Reference ITEM
--------------------------------------------------------------------------------------
      ELSIF     l_base_table_nth.nth_st_chain_column IS NOT NULL
            AND l_base_table_nth.nth_end_chain_column IS NULL
      THEN
         append (  ',nm3sdo.get_pt_shape_from_ne ( ');
         append (   '                                 :NEW.'
                 || LOWER (l_base_table_nth.nth_rse_fk_column)
                );
         append (   '                                 ,:NEW.'
                 || LOWER (l_base_table_nth.nth_st_chain_column)
                 || ') -- geometry derived from start chainage reference'
                );
--------------------------------------------------------------------------------------
-- CONTINUOUS Linear Reference ITEM
--------------------------------------------------------------------------------------
      ELSIF     l_base_table_nth.nth_st_chain_column IS NOT NULL
            AND l_base_table_nth.nth_end_chain_column IS NOT NULL
      THEN
         -- Assume that the XY are not populated and that the theme table is linearly referenced.
         append ('    , nm3sdo.get_placement_geometry');
         append (   '              ( ');
         append ('                 nm_placement ');
         append (   '                   ( :NEW.'
                 || LOWER (l_base_table_nth.nth_rse_fk_column)
                );
         append (   '                   , :NEW.'
                 || LOWER (l_base_table_nth.nth_st_chain_column)
                );
         append (   '                   , :NEW.'
                 || LOWER (l_base_table_nth.nth_end_chain_column)
                );
         append
             ('              , 0))  -- geometry derived from linear reference');
      END IF;

      IF l_base_table_nth.nth_sequence_name IS NOT NULL
      THEN
         append (   '    , '
                 || LOWER (l_base_table_nth.nth_sequence_name)
                 || '.NEXTVAL'
                );
      END IF;

      append ('    );');

-----------------------------------------------------------------------------------
-- If Start Chain and LR columns are defined too, then re-project xy onto
-- Road to work out LR NE ID and Offset values
-----------------------------------------------------------------------------------
      IF     l_base_table_nth.nth_x_column IS NOT NULL
         AND l_base_table_nth.nth_y_column IS NOT NULL
         AND l_base_table_nth.nth_st_chain_column IS NOT NULL
         AND l_base_table_nth.nth_rse_fk_column IS NOT NULL
         AND l_base_table_nth.nth_end_chain_column IS NULL
      THEN
         append
            (   lf
             || lf
             || '    -- Network and Chainage supplied - so derive LR from XY values and update'
             || lf
             || '    l_lref := nm3sdo.nm3sdo.get_nw_snaps_at_xy '
            );
         append ('               ( '||TO_CHAR(l_base_table_nth.nth_theme_id));
         append (   '               , :NEW.'
                 || LOWER (l_base_table_nth.nth_x_column)
                );
         append (   '               , :NEW.'
                 || LOWER (l_base_table_nth.nth_y_column)
                 || ');'
                );
         append (   lf
                 || '    :NEW.'
                 || LOWER (l_base_table_nth.nth_rse_fk_column)
                 || ' := l_lref.lr_ne_id;'
                 || lf
                );
         append (   '    :NEW.'
                 || LOWER (l_base_table_nth.nth_st_chain_column)
                 || ' := nm3unit.get_formatted_value '
                );
         append ('               ( l_lref.lr_offset');
         append
              ('               , nm3net.get_nt_units_from_ne(l_lref.lr_ne_id)');
         append ('               );');
      END IF;

      append (' ');
      append
         (' EXCEPTION -- when others to cater for attempted insert where no geom values supplied e.g. no x/y'
         );
      append ('    WHEN others THEN');
      append ('       Null;');
      append (' END ins;');
      append ('--');
      append
         ('--------------------------------------------------------------------------'
         );
      append ('--');
--
-- UPDATE PROCEDURE
--
      append (' PROCEDURE upd IS ');
      append (' BEGIN');
      append ('');
      append (   '    -- Update feature table '
              || LOWER (l_base_table_nth.nth_feature_table)
             );
    --
    --
    -- 04-FEB-2009
    -- AE Make sure the X and Y columns are not null before updating.. otherwise we'll delete
    --
      IF     l_base_table_nth.nth_x_column IS NOT NULL
         AND l_base_table_nth.nth_y_column IS NOT NULL
      THEN
    --
        append ('--');
        append (' IF :NEW.'||LOWER (l_base_table_nth.nth_x_column)|| ' IS NOT NULL');
        append ('    AND :NEW.'||LOWER (l_base_table_nth.nth_y_column)|| ' IS NOT NULL');
        append (' THEN ');
    --
      END IF;
    --
      append ('--');
      append ('    UPDATE ' || LOWER (l_base_table_nth.nth_feature_table));
      append (   '       SET '
              || LOWER (l_base_table_nth.nth_feature_pk_column)
              || ' = :NEW.'
              || LOWER (l_base_table_nth.nth_pk_column)
             );

--------------------------------------------------------------------------------------
-- POINT X,Y ITEM
--------------------------------------------------------------------------------------
      IF     l_base_table_nth.nth_x_column IS NOT NULL
         AND l_base_table_nth.nth_y_column IS NOT NULL
      THEN
         append (   '         , '
                 || LOWER (l_base_table_nth.nth_feature_shape_column)
                 || ' = mdsys.sdo_geometry'
                );
         append ('                          ( 2001 ');
         append ('                          , ' || l_srid || ' ');
         append ('                          , mdsys.sdo_point_type');
         append (   '                             ( :NEW.'
                 || LOWER (l_base_table_nth.nth_x_column)
                );
         append (   '                             , :NEW.'
                 || LOWER (l_base_table_nth.nth_y_column)
                );
         append ('                             ,  NULL)');
         append ('                          , NULL ');
         append
            ('                          , NULL)  -- geometry derived from X,Y values'
            );
--------------------------------------------------------------------------------------
-- POINT Linear Reference ITEM
--------------------------------------------------------------------------------------
      ELSIF     l_base_table_nth.nth_st_chain_column IS NOT NULL
            AND l_base_table_nth.nth_end_chain_column IS NULL
      THEN
         append (   '              ,'
                 || l_base_table_nth.nth_feature_shape_column
                 || '=nm3sdo.get_pt_shape_from_ne('
                 || ':new.'
                 || l_base_table_nth.nth_rse_fk_column
                 || ',:new.'
                 || l_base_table_nth.nth_st_chain_column
                 || ')'
                );
--------------------------------------------------------------------------------------
-- CONTINUOUS Linear Reference ITEM
--------------------------------------------------------------------------------------
      ELSIF     l_base_table_nth.nth_st_chain_column IS NOT NULL
            AND l_base_table_nth.nth_end_chain_column IS NOT NULL
      THEN
-- Assume that the XY are not populated and that the theme table is linearly referenced.
         append (   '         , '
                 || (   LOWER (l_base_table_nth.nth_feature_shape_column)
                     || ' = nm3sdo.get_placement_geometry ('
                    )
                );
         append ('                               ' || 'nm_placement');
         append (   '                                 ( :NEW.'
                 || LOWER (l_base_table_nth.nth_rse_fk_column)
                );
         append (   '                                 , :NEW.'
                 || LOWER (l_base_table_nth.nth_st_chain_column)
                );
         append (   '                                 , :NEW.'
                 || LOWER (l_base_table_nth.nth_end_chain_column)
                );
         append
            ('                             , 0)) -- geometry derived from linear reference'
            );
      END IF;

      append (   '     WHERE '
              || LOWER (l_base_table_nth.nth_feature_pk_column)
              || ' = :OLD.'
              || l_base_table_nth.nth_pk_column
              || ';'
              || lf
             );
      append ('    IF SQL%ROWCOUNT=0 THEN');
      append ('       ins;');

-----------------------------------------------------------------------------------
-- If Start Chain and LR columns are defined too, then re-project xy onto
-- Road to work out LR NE ID and Offset values
-----------------------------------------------------------------------------------
      IF     l_base_table_nth.nth_x_column IS NOT NULL
         AND l_base_table_nth.nth_y_column IS NOT NULL
         AND l_base_table_nth.nth_st_chain_column IS NOT NULL
         AND l_base_table_nth.nth_rse_fk_column IS NOT NULL
         AND l_base_table_nth.nth_end_chain_column IS NULL
      THEN
         append ('    ELSE');
         append
            (   '    -- Network and Chainage supplied - so derive LR from XY values and update'
             || lf
             || '       l_lref := nm3sdo.get_nw_snaps_at_xy ' );
         append ('                  '||TO_CHAR( l_base_table_nth.nth_theme_id));
         append (   '                  , :NEW.'
                 || LOWER (l_base_table_nth.nth_x_column)
                );
         append (   '                  , :NEW.'
                 || LOWER (l_base_table_nth.nth_y_column)
                 || ');'
                );
         append (   lf
                 || '       :NEW.'
                 || LOWER (l_base_table_nth.nth_rse_fk_column)
                 || ' := l_lref.lr_ne_id;'
                 || lf
                );
         append (   '       :NEW.'
                 || LOWER (l_base_table_nth.nth_st_chain_column)
                 || ' := nm3unit.get_formatted_value '
                );
         append ('                  ( l_lref.lr_offset');
         append
            ('                  , nm3net.get_nt_units_from_ne(l_lref.lr_ne_id)'
            );
         append ('                  );');
         append ('    END IF;' || lf);
      ELSE
         append ('    END IF;' || lf);
      END IF;

    -- 04-FEB-2009
    -- AE Make sure the X and Y columns are not null before updating.. otherwise we'll delete
    --
      IF     l_base_table_nth.nth_x_column IS NOT NULL
         AND l_base_table_nth.nth_y_column IS NOT NULL
      THEN
    --
        append ('--');
        append (' ELSE');
        append ('--');
        append ('    del; ');
        append ('--');
        append (' END IF; ');
    --
      END IF;

      append (' ');
      append
         (' EXCEPTION -- when others to cater for attempted update where no geom values supplied e.g. no x/y'
         );
      append ('     WHEN others THEN');
      append ('       Null;');
      append (' END upd;');
      append ('--');
      append
         ('--------------------------------------------------------------------------'
         );
      append ('--');
      append ('BEGIN' || lf);
      IF p_restrict IS NOT NULL THEN
        append ('IF ' ||p_restrict || ' THEN');
      END IF;
      
      append ('   IF DELETING THEN');
      append ('        del;');
      append ('   ELSIF INSERTING THEN');
      append ('        ins;');
      append ('   ELSIF UPDATING THEN');
      append ('        upd;');
      append ('   END IF;');
      IF p_restrict IS NOT NULL THEN
        append ('END IF;');
      END IF;
      append ('EXCEPTION');
      append ('   WHEN NO_DATA_FOUND THEN');
      append ('     NULL; -- no data in spatial table to update or delete');
      append ('   WHEN OTHERS THEN');
      append ('     RAISE;');
      append ('END ' || LOWER (l_trg_name) || ';');
      append ('--');
      append
         ('--------------------------------------------------------------------------'
         );
      append ('--');
      Nm3ddl.execute_tab_varchar (l_tab_vc);
   EXCEPTION
      WHEN ex_invalid_sequence
      THEN
         Hig.raise_ner
              (pi_appl                    => Nm3type.c_hig,
               pi_id                      => 257,
               pi_sqlcode                 => -20001,
               pi_supplementary_info      =>    l_base_table_nth.nth_sequence_name
                                             || CHR (10)
                                             || 'Please check your theme.'
              );
      WHEN OTHERS
      THEN
         RAISE;
   END Create_Nth_Sdo_Trigger;
--
-----------------------------------------------------------------------------
--
   PROCEDURE get_dynseg_nt_types (
      pi_asset_type   IN       nm_inv_types.nit_inv_type%TYPE,
      po_locations    IN OUT   tab_nin_sdo
   )
   IS
      l_tab_layer      Nm3type.tab_number;
      l_tab_location   Nm3type.tab_varchar4;
      l_retval         tab_nin_sdo;
   --
   BEGIN
      --
      Nm_Debug.proc_start (g_package_name, 'get_dynseg_nt_type');

      --  Nm_Debug.debug_on;
      --  Nm_Debug.DEBUG('Asset type = '||pi_asset_type);
      SELECT nlt_nt_type, b.nth_theme_id base_theme
      BULK COLLECT INTO l_tab_location, l_tab_layer
        FROM nm_inv_nw a, NM_THEMES_ALL b, NM_NW_THEMES, NM_LINEAR_TYPES
       WHERE nlt_id = nnth_nlt_id
         AND nnth_nth_theme_id = nth_theme_id
         AND nlt_nt_type = a.nin_nw_type
         AND b.nth_theme_type = 'SDO'
         AND a.nin_nit_inv_code = pi_asset_type;

      FOR i IN 1 .. l_tab_layer.COUNT
      LOOP
         --    Nm_Debug.DEBUG('In Loop - '||l_tab_location(i));
         l_retval (i).p_layer_id := l_tab_layer (i);
         l_retval (i).p_location := l_tab_location (i);
      END LOOP;

      po_locations := l_retval;
      Nm_Debug.proc_end (g_package_name, 'get_dynseg_nt_type');
   --
   EXCEPTION
      --
      WHEN NO_DATA_FOUND
      THEN
         po_locations := l_retval;
      WHEN OTHERS
      THEN
         RAISE;
   --
   END get_dynseg_nt_types;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_existing_themes_for_table (
      pi_theme_table   IN       NM_THEMES_ALL.nth_theme_name%TYPE,
      po_themes        IN OUT   tab_nth
   )
   IS
      l_retval   tab_nth;
   BEGIN
      Nm_Debug.proc_end (g_package_name, 'get_existing_themes_for_table');

      --
      SELECT *
      BULK COLLECT INTO l_retval
        FROM NM_THEMES_ALL
       WHERE nth_table_name = pi_theme_table AND nth_theme_type = 'SDO';

      po_themes := l_retval;
      --
      Nm_Debug.proc_end (g_package_name, 'get_existing_themes_for_table');
   --
   EXCEPTION
      --
      WHEN NO_DATA_FOUND
      THEN
         po_themes := l_retval;
      WHEN OTHERS
      THEN
         RAISE;
   --
   END get_existing_themes_for_table;

--
-----------------------------------------------------------------------------
--
--   PROCEDURE get_rouge_asset_metadata
--              ( pi_asset_type  IN      nm_inv_types.nit_inv_type%TYPE
--              , po_results     IN OUT  tab_r_asset)
--   IS
--    TYPE tab_nth            IS TABLE OF NM_THEMES_ALL%ROWTYPE
--                               INDEX BY BINARY_INTEGER;
--
--    TYPE tab_usgm           IS TABLE OF user_sdo_geom_metadata%ROWTYPE
--                               INDEX BY BINARY_INTEGER;
--
--    TYPE tab_ust            IS TABLE OF user_sdo_themes%ROWTYPE
--                               INDEX BY BINARY_INTEGER;
--
--    TYPE tab_layers         IS TABLE OF sde.layers%ROWTYPE
--                               INDEX BY BINARY_INTEGER;
--
--    TYPE tab_gcols          IS TABLE OF sde.geometry_columns%ROWTYPE
--                               INDEX BY BINARY_INTEGER;
--
--    TYPE tab_treg           IS TABLE OF sde.table_registry%ROWTYPE
--                               INDEX BY BINARY_INTEGER;
--
--    TYPE tab_seqs           IS TABLE OF USER_SEQUENCES%ROWTYPE
--                               INDEX BY BINARY_INTEGER;
--
--     l_tab_nth_results          tab_nth;
--     l_tab_usgm_results         tab_usgm;
--     l_tab_ust_results          tab_ust;
--     l_tab_layers_results       tab_layers;
--     l_tab_gcols_results        tab_gcols;
--     l_tab_treg_results         tab_treg;
--     l_tab_seqs_results         tab_seqs;
--     l_tab_results              tab_r_asset;
--
--     l_rec_nit                  nm_inv_types%ROWTYPE;
--
--     l_object_name              VARCHAR2(30);
--     l_string                   Nm3type.max_varchar2;
--     l_count                    PLS_INTEGER := 0;
--
--     b_ft_asset                 BOOLEAN;
--     b_use_sde                  BOOLEAN :=   Hig.get_sysopt('REGSDELAY') = 'Y';
--
--     e_invalid_asset_type       EXCEPTION;
--   --
--     PROCEDURE put_line (pi_entity IN VARCHAR2
--                        ,pi_pk     IN VARCHAR2
--                        ,pi_descr  IN VARCHAR2)
--     IS
--       l_ind   NUMBER   := l_tab_results.COUNT;
--     BEGIN
--       l_tab_results(l_ind+1).p_rownum := l_ind;
--       l_tab_results(l_ind+1).p_entity := pi_entity;
--       l_tab_results(l_ind+1).p_pk     := pi_pk;
--       l_tab_results(l_ind+1).p_descr  := pi_descr;
-- --       l_tmp :=       'BEGIN dbms_output.put_line ('
-- --        ||''''||(pi_entity)
-- --        ||' exists - '
-- --        ||pi_pk
-- --        ||' - '
-- --        ||pi_descr||''''||'); END;';
-- --      EXECUTE IMMEDIATE l_tmp;
--     END put_line;
--   --
--   -----------------------------------------------------------------------------
--   BEGIN
--   -----------------------------------------------------------------------------
--   --
--     Nm_Debug.delete_debug;
-- --    Nm_Debug.debug_on;
--     Nm_Debug.DEBUG('** STARTED ROUGE ASSET METADATA SEARCH **');
--   --
--     l_rec_nit := Nm3get.get_nit (pi_nit_inv_type => pi_asset_type);
--   --
--     IF l_rec_nit.nit_inv_type
--       IS NULL THEN
--         RAISE e_invalid_asset_type;
--     END IF;
--   --
--     IF l_rec_nit.nit_table_name IS NOT NULL
--     THEN
--       b_ft_asset := TRUE;
--     END IF;
--   --
--     /*
--      --------------------------------------------------------------------------
--        CHECK FOR OLD themes
--      --------------------------------------------------------------------------
--     */
--
-- --     IF b_ft_asset
-- --     THEN
-- --         l_object_name := nm3flx.string(l_rec_nit.nit_table_name);
-- --     ELSE
-- --       l_object_name := nm3flx.string('%_'||upper(pi_asset_type));
-- --     END IF;
-- --
-- --     l_string :=
-- --     'SELECT * FROM nm_themes_all WHERE nth_table_name like '||l_object_name;
-- --
-- --     EXECUTE IMMEDIATE l_string
-- --        BULK COLLECT INTO l_tab_nth_results;
-- --
-- --     FOR i IN 1..l_tab_nth_results.COUNT
-- --      LOOP
-- --        l_count := l_count + 1;
-- --        put_line('Theme',l_tab_nth_results(i).nth_theme_id
-- --                        ,l_tab_nth_results(i).nth_theme_name);
-- --     END LOOP;
--   --
--     /*
--      --------------------------------------------------------------------------
--        CHECK FOR OLD sdo metadata
--      --------------------------------------------------------------------------
--     */
--     IF b_ft_asset
--     THEN
--       l_object_name := Nm3flx.string(l_rec_nit.nit_table_name);
--     ELSE
--       l_object_name := Nm3flx.string('%_'||UPPER(pi_asset_type)||'_SDO%');
--     END IF;
--
--     l_string :=
--     'SELECT * FROM user_sdo_geom_metadata WHERE table_name like '||l_object_name;
--
--     EXECUTE IMMEDIATE l_string
--        BULK COLLECT INTO l_tab_usgm_results;
--
--     FOR i IN 1..l_tab_usgm_results.COUNT
--      LOOP
--        l_count := l_count + 1;
--        put_line(1
--                ,l_tab_usgm_results(i).table_name
--                ,l_tab_usgm_results(i).column_name);
--     END LOOP;
--   --
--       /*
--      --------------------------------------------------------------------------
--        CHECK FOR OLD sdo themes (Mapviewer)
--      --------------------------------------------------------------------------
--     */
--     IF b_ft_asset
--     THEN
--       l_object_name := Nm3flx.string(l_rec_nit.nit_table_name);
--     ELSE
--       l_object_name := Nm3flx.string('%_'||UPPER(pi_asset_type)||'_SDO%');
--     END IF;
--
--     l_string :=
--     'SELECT * FROM user_sdo_themes WHERE base_table like '||l_object_name;
--
--     EXECUTE IMMEDIATE l_string
--        BULK COLLECT INTO l_tab_ust_results;
--
--     FOR i IN 1..l_tab_ust_results.COUNT
--      LOOP
--        l_count := l_count + 1;
--        put_line(2
--                ,l_tab_ust_results(i).name
--                ,l_tab_ust_results(i).description);
--     END LOOP;
--   --
--     /*
--      --------------------------------------------------------------------------
--        CHECK FOR OLD sde layers
--      --------------------------------------------------------------------------
--     */
--     IF b_use_sde
--     THEN
--
--       IF b_ft_asset
--       THEN
--         l_object_name := Nm3flx.string(l_rec_nit.nit_table_name);
--       ELSE
--         l_object_name := Nm3flx.string('%_'||UPPER(pi_asset_type)||'_SDO%');
--       END IF;
--
--       l_string :=
--       'SELECT * FROM sde.layers WHERE owner = user '||
--       'and table_name like '||l_object_name;
--
--       EXECUTE IMMEDIATE l_string
--          BULK COLLECT INTO l_tab_layers_results;
--
--       FOR i IN 1..l_tab_layers_results.COUNT
--        LOOP
--          l_count := l_count + 1;
--          put_line(3
--                  ,l_tab_layers_results(i).layer_id
--                  ,NVL(l_tab_layers_results(i).description
--                  ,l_tab_layers_results(i).table_name));
--       END LOOP;
--     --
--       /*
--        --------------------------------------------------------------------------
--          CHECK FOR OLD sde geometry_columns
--        --------------------------------------------------------------------------
--       */
--       IF b_ft_asset
--       THEN
--         l_object_name := Nm3flx.string(l_rec_nit.nit_table_name);
--       ELSE
--         l_object_name := Nm3flx.string('%_'||UPPER(pi_asset_type)||'_SDO%');
--       END IF;
--
--       l_string :=
--       'SELECT * FROM sde.geometry_columns WHERE f_table_schema = user '||
--       'and f_table_name like '||l_object_name;
--
--       EXECUTE IMMEDIATE l_string
--          BULK COLLECT INTO l_tab_gcols_results;
--
--       FOR i IN 1..l_tab_gcols_results.COUNT
--        LOOP
--          l_count := l_count + 1;
--          put_line(4
--                  ,l_tab_gcols_results(i).f_table_name
--                  ,l_tab_gcols_results(i).f_geometry_column);
--       END LOOP;
--     --
--         /*
--        --------------------------------------------------------------------------
--          CHECK FOR OLD sde table_registry
--        --------------------------------------------------------------------------
--       */
--       IF b_ft_asset
--       THEN
--         l_object_name := Nm3flx.string(l_rec_nit.nit_table_name);
--       ELSE
--         l_object_name := Nm3flx.string('%_'||UPPER(pi_asset_type)||'_SDO%');
--       END IF;
--
--       l_string :=
--       'SELECT * FROM sde.table_registry WHERE owner = user '||
--       'and table_name like '||l_object_name;
--
--       --nm_debug.debug(l_string);
--       EXECUTE IMMEDIATE l_string
--          BULK COLLECT INTO l_tab_treg_results;
--
--       FOR i IN 1..l_tab_treg_results.COUNT
--        LOOP
--          l_count := l_count + 1;
--          put_line(5
--                  ,l_tab_treg_results(i).registration_id
--                  ,NVL(l_tab_treg_results(i).description
--                  ,l_tab_treg_results(i).table_name));
--       END LOOP;
--     --
--     END IF;
--     --
--       /*
--      --------------------------------------------------------------------------
--        CHECK FOR OLD sequences
--      --------------------------------------------------------------------------
--     */
--
--     IF l_tab_nth_Results.COUNT > 0
--     THEN
--       FOR i IN 1..l_tab_nth_results.COUNT
--        LOOP
--          l_string :=
--          'select * from user_sequences '||
--          ' where sequence_name like '||Nm3flx.string('NTH_%_SEQ')||
--          '   and sequence_name != '||Nm3flx.string('NTH_THEME_ID_SEQ')||
--          '   and substr(sequence_name,5,(instr(sequence_name,'
--            ||Nm3flx.string('_SEQ')||')-5)) = '||Nm3flx.string(l_tab_nth_results(i).nth_theme_id);
--          Nm_Debug.DEBUG(l_string);
--          EXECUTE IMMEDIATE l_string
--          BULK COLLECT INTO l_tab_seqs_results;
--
--          FOR i IN 1..l_tab_seqs_results.COUNT
--           LOOP
--            l_count := l_count + 1;
--            put_line(6
--                     ,l_tab_seqs_results(i).sequence_name
--                     ,l_tab_seqs_results(i).last_number);
--          END LOOP;
--
--       END LOOP;
--     END IF;
--   --
--     po_results := l_tab_results;
--   --
--     Nm_Debug.DEBUG('** COMPLETED ROUGE ASSET METADATA SEARCH **');
--     Nm_Debug.DEBUG('** '||l_count||' OBJECTS FOUND **');
--   --
--   EXCEPTION
--     WHEN e_invalid_asset_type
--     THEN
--       Nm_Debug.DEBUG('** INVALID ASSET TYPE '||pi_asset_type||' **');
--
--     WHEN OTHERS THEN RAISE;
--   END get_rouge_asset_metadata;
--
-----------------------------------------------------------------------------
--
   PROCEDURE get_nlt_block (
      pi_theme_id   IN       NM_THEMES_ALL.nth_theme_id%TYPE,
      po_results    IN OUT   tab_nlt_block
   )
   IS
      TYPE tab_nlt IS TABLE OF NM_LINEAR_TYPES%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tab_nlt      tab_nlt;
      l_retval       tab_nlt_block;
      l_unit_descr   NM_UNITS.un_unit_name%TYPE;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_tab_nlt
        FROM NM_LINEAR_TYPES
       WHERE nlt_id IN (SELECT nnth_nlt_id
                          FROM NM_NW_THEMES
                         WHERE nnth_nth_theme_id = pi_theme_id);

      FOR i IN 1 .. l_tab_nlt.COUNT
      LOOP
         l_unit_descr :=
            Nm3get.get_un (pi_un_unit_id           => l_tab_nlt (i).nlt_units,
                           pi_raise_not_found      => FALSE
                          ).un_unit_name;
         l_retval (i).nlt_nth_theme_id := pi_theme_id;
         l_retval (i).nlt_id := l_tab_nlt (i).nlt_id;
         l_retval (i).nlt_seq_no := l_tab_nlt (i).nlt_seq_no;
         l_retval (i).nlt_descr := l_tab_nlt (i).nlt_descr;
         l_retval (i).nlt_nt_type := l_tab_nlt (i).nlt_nt_type;
         l_retval (i).nlt_gty_type := l_tab_nlt (i).nlt_gty_type;
         l_retval (i).nlt_admin_type := l_tab_nlt (i).nlt_admin_type;
         l_retval (i).nlt_start_date := l_tab_nlt (i).nlt_start_date;
         l_retval (i).nlt_end_date := l_tab_nlt (i).nlt_end_date;
         l_retval (i).nlt_units := l_tab_nlt (i).nlt_units;
         l_retval (i).nlt_units_descr := l_unit_descr;
      END LOOP;

      po_results := l_retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         po_results := l_retval;
      WHEN OTHERS
      THEN
         RAISE;
   END get_nlt_block;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_nat_block (
      pi_theme_id   IN       NM_THEMES_ALL.nth_theme_id%TYPE,
      po_results    IN OUT   tab_nat_block
   )
   IS
      TYPE tab_nat IS TABLE OF NM_AREA_TYPES%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tab_nat   tab_nat;
      l_retval    tab_nat_block;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_tab_nat
        FROM NM_AREA_TYPES
       WHERE nat_id IN (SELECT nath_nat_id
                          FROM NM_AREA_THEMES
                         WHERE nath_nth_theme_id = pi_theme_id);

      FOR i IN 1 .. l_tab_nat.COUNT
      LOOP
         l_retval (i).nat_nth_theme_id := pi_theme_id;
         l_retval (i).nat_seq_no := l_tab_nat (i).nat_seq_no;
         l_retval (i).nat_descr := l_tab_nat (i).nat_descr;
         l_retval (i).nat_nt_type := l_tab_nat (i).nat_nt_type;
         l_retval (i).nat_gty_group_type := l_tab_nat (i).nat_gty_group_type;
         l_retval (i).nat_start_date := l_tab_nat (i).nat_start_date;
         l_retval (i).nat_end_date := l_tab_nat (i).nat_end_date;
         l_retval (i).nat_shape_type := l_tab_nat (i).nat_shape_type;
      END LOOP;

      po_results := l_retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         po_results := l_retval;
      WHEN OTHERS
      THEN
         RAISE;
   END get_nat_block;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_nit_block (
      pi_theme_id   IN       NM_THEMES_ALL.nth_theme_id%TYPE,
      po_results    IN OUT   tab_nit_block
   )
   IS
      TYPE tab_nit IS TABLE OF nm_inv_types%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tab_nit   tab_nit;
      l_retval    tab_nit_block;
   BEGIN
      SELECT nm_inv_types.*
      BULK COLLECT INTO l_tab_nit
        FROM nm_inv_types, NM_INV_THEMES
       WHERE nit_inv_type = nith_nit_id AND nith_nth_theme_id = pi_theme_id;

      FOR i IN 1 .. l_tab_nit.COUNT
      LOOP
         l_retval (i).nit_nth_theme_id := pi_theme_id;
         l_retval (i).nit_inv_type := l_tab_nit (i).nit_inv_type;
         l_retval (i).nit_descr := l_tab_nit (i).nit_descr;
         l_retval (i).nit_view_name := l_tab_nit (i).nit_view_name;
         l_retval (i).nit_use_xy := l_tab_nit (i).nit_use_xy;
         l_retval (i).nit_pnt_or_cont := l_tab_nit (i).nit_pnt_or_cont;
         l_retval (i).nit_linear := l_tab_nit (i).nit_linear;
         l_retval (i).nit_table_name := l_tab_nit (i).nit_table_name;
         l_retval (i).nit_lr_st_chain := l_tab_nit (i).nit_lr_st_chain;
         l_retval (i).nit_lr_end_chain := l_tab_nit (i).nit_lr_end_chain;
         l_retval (i).nit_lr_ne_column_name :=
                                          l_tab_nit (i).nit_lr_ne_column_name;
      END LOOP;

      po_results := l_retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         po_results := l_retval;
      WHEN OTHERS
      THEN
         RAISE;
   END get_nit_block;

--
-----------------------------------------------------------------------------
--
--   PROCEDURE validate_theme
--              ( pi_theme_id   IN     NM_THEMES_ALL.nth_theme_id%TYPE
--              , po_results    IN OUT tab_validate_theme)
--     /*
--        FOR a given theme, this PROCEDURE RETURN a TABLE OF results
--     */
--   IS
--   --
--     TYPE tab_nth            IS TABLE OF NM_THEMES_ALL%ROWTYPE
--                                INDEX BY BINARY_INTEGER;
--     TYPE tab_usgm           IS TABLE OF user_sdo_geom_metadata%ROWTYPE
--                                INDEX BY BINARY_INTEGER;
--     TYPE tab_ust            IS TABLE OF user_sdo_themes%ROWTYPE
--                                INDEX BY BINARY_INTEGER;
--     TYPE tab_layers         IS TABLE OF sde.layers%ROWTYPE
--                                INDEX BY BINARY_INTEGER;
--     TYPE tab_gcols          IS TABLE OF sde.geometry_columns%ROWTYPE
--                                INDEX BY BINARY_INTEGER;
--     TYPE tab_treg           IS TABLE OF sde.table_registry%ROWTYPE
--                                INDEX BY BINARY_INTEGER;
--     TYPE tab_seqs           IS TABLE OF USER_SEQUENCES%ROWTYPE
--                                INDEX BY BINARY_INTEGER;
--   --
--     l_tab_ust                  tab_ust;
--     l_rec_nth                  NM_THEMES_ALL%ROWTYPE;
--     l_base_table_nth           NM_THEMES_ALL%ROWTYPE;
--     l_rec_usgm                 user_sdo_geom_metadata%ROWTYPE;
--     l_rec_ut                   USER_TABLES%ROWTYPE;
--     l_var_output               VARCHAR2(32767);
--     l_tab_output               tab_validate_theme;
--   --
--     b_use_surkey               BOOLEAN  := Hig.get_user_or_sys_opt ('SDOSURKEY') = 'Y';
--     b_objectid_missing         BOOLEAN  := FALSE;
--     b_objectid_uk_missing      BOOLEAN  := FALSE;
--   --
--     e_not_sdo_theme            EXCEPTION;
--     e_no_feature_table         EXCEPTION;
--     e_feature_table_no_exist   EXCEPTION;
--     e_feature_shp_col_no_exist EXCEPTION;
--     e_no_feature_shape_col     EXCEPTION;
--   --
--     FUNCTION no_index_on_objectid
--       RETURN BOOLEAN
--     IS
--       l_temp PLS_INTEGER := NULL;
--     BEGIN
--       SELECT 1
--         INTO l_temp
--         FROM USER_IND_COLUMNS
--        WHERE index_name = l_rec_nth.nth_feature_table||'_UK'
--          AND table_name = l_rec_nth.nth_feature_table
--          AND column_name = 'OBJECTID';
--       RETURN TRUE;
--     EXCEPTION
--       WHEN OTHERS THEN RETURN FALSE;
--     END no_index_on_objectid;
--   --
--     PROCEDURE append (p_text IN VARCHAR2
--                      ,p_nl   IN BOOLEAN DEFAULT TRUE)
--     IS
-- --      l_i NUMBER := l_tab_output.COUNT;
--     BEGIN
--       Nm_Debug.debug_on;
--       Nm_Debug.DEBUG((l_var_output));
--       Nm_Debug.DEBUG(LENGTH(l_var_output));
--       IF p_nl
--       THEN
--         l_var_output := l_var_output||p_text||CHR(10);
--       ELSE
--         l_var_output := l_var_output||p_text;
--       END IF;
--     END append;
--   --
--   BEGIN
--   --
--     -- Validate theme
--     l_rec_nth := Nm3get.get_nth ( pi_nth_theme_id => pi_theme_id );
--
--     -- Base Table Theme
--     IF l_rec_nth.nth_base_table_theme IS NULL
--     THEN
--       l_base_table_nth := l_rec_nth; -- base theme is the driving theme
--     ELSE
--       l_base_table_nth :=  Nm3get.get_nth(pi_nth_theme_id => l_rec_nth.nth_base_table_theme);
--     END IF;
--
--     IF l_rec_nth.nth_theme_type != 'SDO'
--       THEN
--       RAISE e_not_sdo_theme;
--     ELSIF l_rec_nth.nth_feature_table IS NULL
--     THEN
--       RAISE e_no_feature_table;
--     ELSIF l_rec_nth.nth_feature_shape_column IS NULL
--     THEN
--       RAISE e_no_feature_shape_col;
--     ELSIF NOT Nm3ddl.does_object_exist(l_rec_nth.nth_feature_table)
--     THEN
--       RAISE e_feature_table_no_exist;
--     ELSIF Nm3ddl.get_column_details
--            ( p_column_name => l_rec_nth.nth_feature_shape_column
--            , p_table_name  => l_rec_nth.nth_feature_table ).column_name IS NULL
--     THEN
--       RAISE e_feature_shp_col_no_exist;
--     END IF;
--
--     -- Check for user_sdo_geom_metadata
--     BEGIN
--       SELECT *
--         INTO l_rec_usgm
--         FROM user_sdo_geom_metadata
--        WHERE table_name = l_rec_nth.nth_feature_table
--          AND column_name = l_rec_nth.nth_feature_shape_column;
--     EXCEPTION
--       WHEN NO_DATA_FOUND THEN NULL;
--       WHEN OTHERS        THEN RAISE;
--     END;
--
--     -- Check for user_sdo_themes (mapviewer metadata)
--     BEGIN
--       SELECT *
--         BULK COLLECT INTO l_tab_ust
--         FROM user_sdo_themes
--        WHERE BASE_TABLE = l_rec_nth.nth_feature_table;
--     EXCEPTION
--       WHEN NO_DATA_FOUND THEN NULL;
--       WHEN OTHERS        THEN RAISE;
--     END;
--
--     -- Check for surrogate key column and sequence (if applicable)
--     IF b_use_surkey
--     THEN
--       DECLARE
--         e_not_found EXCEPTION;
--         PRAGMA      EXCEPTION_INIT (e_not_found,-20200);
--       BEGIN
--         IF Nm3ddl.get_column_details
--              ( p_column_name => 'OBJECTID'
--              , p_table_name  => l_rec_nth.nth_feature_table ).column_name IS NOT NULL
--         THEN
--           NULL;
--         END IF;
--       EXCEPTION
--         WHEN e_not_found
--         THEN b_objectid_missing := TRUE;
--       END;
--
--       IF no_index_on_objectid
--       THEN
--         -- NO UK INDEX ON OBJECTID
--         b_objectid_uk_missing := TRUE;
--       END IF;
--
--     END IF;
--
--     -- Build output
--     append ('================================================');
--     append (''||To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'));
--     append ('');
--     append ('Validate Theme '||l_rec_nth.nth_theme_name);
--     append ('================================================');
--     append ('');
--     append ('');
--     append ('  ================================================');
--     append ('  SDO Metadata');
--     append ('  ================================================');
--     append ('  (user_sdo_geom_metadata)');
--     append ('');
--
--     IF l_rec_usgm.table_name IS NULL
--     THEN
--       append ('  ** No SDO Metadata Exists ! ** ');
--     ELSE
-- --      append ('   TABLE NAME        = '||l_rec_usgm.table_name);
--       append ('   GEOMETRY COLUMN   = '||l_rec_usgm.column_name);
-- --      append ('   DIMINFO       = '||l_rec_usgm.diminfo);
--       append ('   SRID              = '||NVL(l_rec_usgm.srid,'NOT SET'));
--     END IF;
--     append ('');
--     append ('');
--     append ('  ================================================');
--     append ('  SDO Themes Metadata');
--     append ('  ================================================');
--     append ('  (user_sdo_themes)');
--     append ('');
--
--     IF l_tab_ust.COUNT = 0
--     THEN
--       append ('  ** No SDO Theme Metadata Exists ! **');
--     ELSE
--       FOR i IN 1..l_tab_ust.COUNT
--       LOOP
--         append ('   THEME NAME       = '||l_tab_ust(i).name);
--         append ('   DESCRIPTION      = '||l_tab_ust(i).description);
--         append ('   BASE TABLE       = '||l_tab_ust(i).BASE_TABLE);
--         append ('   GEOMETRY COLUMN  = '||l_tab_ust(i).geometry_column);
--         append ('');
--       END LOOP;
--     END IF;
--
--     append ('');
--     append ('');
--     append ('  ================================================');
--     IF  b_use_surkey
--     THEN
--       append ('  System is using Surrogate Key option (SDOSURKEY)');
--       append ('  ================================================');
--
--       IF b_objectid_missing
--       THEN
--         append ('');
--         append ('   Surrogate Key Column (OBJECTID) is MISSING from ');
--         append ('    '||l_base_table_nth.nth_Feature_table);
--       ELSE
--         append ('');
--         append ('   Surrogate Key Column (OBJECTID) exists on ');
--         append ('    '||l_base_table_nth.nth_Feature_table);
--       END IF;
--
--       IF b_objectid_uk_missing
--       THEN
--         append ('');
--         append ('   Unique Index on Column (OBJECTID) is MISSING');
--       ELSE
--         append ('');
--         append ('   Unique Index on Column (OBJECTID) exists');
--       END IF;
--
--     ELSE
--       append ('  System is NOT using Surrogate Key option (SDOSURKEY)');
--       append ('  ================================================');
--     END IF;
--
--     Nm_Debug.DEBUG(l_tab_output(1).p_output);
--     l_tab_output(1).p_output := l_var_output;
--     po_results               := l_tab_output;
--
--   EXCEPTION
--     WHEN e_not_sdo_theme
--       THEN RAISE_APPLICATION_ERROR
--              (-20101, 'Theme '||l_rec_nth.nth_theme_name
--                               ||' is not an SDO theme');
--     WHEN e_no_feature_table
--       THEN RAISE_APPLICATION_ERROR
--              (-20102, 'Theme must have a feature table');
--     WHEN e_no_feature_shape_col
--       THEN RAISE_APPLICATION_ERROR
--              (-20103, 'Theme must have a feature shape column');
--     WHEN e_feature_table_no_exist
--       THEN RAISE_APPLICATION_ERROR
--              (-20104, 'Feature table '||l_rec_nth.nth_feature_table
--                                       ||' does not exist');
--     WHEN e_feature_shp_col_no_exist
--       THEN RAISE_APPLICATION_ERROR
--              (-20105, 'Feature shape column '||l_rec_nth.nth_feature_shape_column
--                                              ||' does not exist');
--     WHEN OTHERS
--       THEN RAISE;
--   END validate_theme;
--
-----------------------------------------------------------------------------
--
   PROCEDURE create_msv_themes
   AS
      l_rec_nth    NM_THEMES_ALL%ROWTYPE;
      l_rec_nthr   NM_THEME_ROLES%ROWTYPE;

      FUNCTION get_pk_column (pi_table_name IN VARCHAR2)
         RETURN VARCHAR2
      IS
         l_col   VARCHAR2 (30);
      BEGIN
         SELECT ucc.column_name
           INTO l_col
           FROM user_constraints uco, user_cons_columns ucc
          WHERE uco.owner = USER
            AND ucc.owner = USER
            AND uco.table_name = pi_table_name
            AND uco.constraint_type = 'P'
            AND uco.constraint_name = ucc.constraint_name
            AND uco.table_name = ucc.table_name;

         RETURN l_col;
      EXCEPTION
         WHEN OTHERS
         THEN
            -- couldn't find a column
--            Nm_Debug.DEBUG ('Couldnt derive PK column for ' || pi_table_name);
            RETURN 'UNKNOWN';
      END get_pk_column;
--
   BEGIN
--
--  Nm_Debug.debug_on;
--
      FOR i IN (SELECT *
                  FROM user_sdo_themes
                 WHERE NOT EXISTS (
                          SELECT 1
                            FROM NM_THEMES_ALL
                           WHERE nth_theme_name = NAME
                             AND nth_theme_type = 'SDO'))
      LOOP
         BEGIN
            l_rec_nth.nth_theme_id := Nm3seq.next_nth_theme_id_seq;
            l_rec_nth.nth_theme_name := i.NAME;
            l_rec_nth.nth_table_name := i.BASE_TABLE;
            l_rec_nth.nth_pk_column := get_pk_column (i.BASE_TABLE);
            l_rec_nth.nth_label_column := l_rec_nth.nth_pk_column;
            l_rec_nth.nth_hpr_product := Nm3type.c_net;
            l_rec_nth.nth_location_updatable := 'N';
            l_rec_nth.nth_dependency := 'I';
            l_rec_nth.nth_storage := 'S';
            l_rec_nth.nth_update_on_edit := 'N';
            l_rec_nth.nth_use_history := 'N';
            l_rec_nth.nth_snap_to_theme := 'N';
            l_rec_nth.nth_lref_mandatory := 'N';
            l_rec_nth.nth_tolerance := 10;
            l_rec_nth.nth_tol_units := 1;
            l_rec_nth.nth_theme_type := 'SDO';
            l_rec_nth.nth_feature_table := i.BASE_TABLE;
            l_rec_nth.nth_feature_shape_column := i.geometry_column;
            l_rec_nth.nth_feature_pk_column := l_rec_nth.nth_pk_column;
            Nm3ins.ins_nth (l_rec_nth);
--            Nm_Debug.DEBUG ('Created theme ' || i.NAME);
            l_rec_nthr.nthr_theme_id := l_rec_nth.nth_theme_id;
            l_rec_nthr.nthr_role := 'HIG_USER';
            l_rec_nthr.nthr_mode := 'NORMAL';
            Nm3ins.ins_nthr (l_rec_nthr);
--            Nm_Debug.DEBUG ('Created theme role ' || i.NAME);
         EXCEPTION
            WHEN OTHERS
            THEN
               Nm_Debug.DEBUG (   'Unable to create theme for '
                               || i.NAME
                               || ' - '
                               || SQLERRM
                              );
         END;
      END LOOP;

      --
--      Nm_Debug.debug_off;
   --
   END create_msv_themes;

--
------------------------------------------------------------------------------
--
PROCEDURE create_msv_feature_views
               ( pi_username  IN   hig_users.hus_username%TYPE DEFAULT NULL)
--
-- View created for subordinate users that need access to the Highways owner
-- SDO layers when using Mapviewer
--
-- This is due to Mapviewer requiring the object to exist as a view, rather
-- than access it via via synonyms
--
-- USER_SDO_GEOM_METADATA still needs to exist for each subordinate user
--
   AS
--
      l_higowner       VARCHAR2 (30)         := Sys_Context('NM3CORE','APPLICATION_OWNER');
      l_tab_username   Nm3type.tab_varchar30;
      l_tab_ftabs      Nm3type.tab_varchar30;
      l_nl             VARCHAR2 (10)         := CHR (10);
--
      FUNCTION is_priv_view (
         pi_view_name   IN   dba_views.view_name%TYPE,
         pi_owner      IN   dba_views.owner%TYPE
      )
         RETURN BOOLEAN
      IS
         l_var   VARCHAR2 (10);
      --
      BEGIN
         --
         SELECT 'exists'
           INTO l_var
           FROM dba_views
          WHERE view_name = pi_view_name AND owner = pi_owner;
         --
         RETURN TRUE;
      --
      EXCEPTION
         WHEN OTHERS THEN RETURN FALSE;
      --
      END is_priv_view;
--
   BEGIN
--
--  Nm_Debug.debug_on;
  -- Collect subordinate users (that actually exist)
      BEGIN
         SELECT hus_username
         BULK COLLECT INTO l_tab_username
           FROM HIG_USERS
          WHERE hus_is_hig_owner_flag = 'N'
            AND EXISTS (SELECT 1
                          FROM dba_users
                         WHERE username = hus_username
                           AND NVL(pi_username,'^$^') = NVL(hus_username,'^$^'));
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

--
  -- Find which feature tables we need to create views for
  -- We only need views for feature tables that contain SRIDS

  -- not longer the case - will create views for all feature tables
  --
      BEGIN
        SELECT nth_feature_table
          BULK COLLECT INTO l_tab_ftabs
          FROM nm_themes_all
         WHERE nth_theme_type = 'SDO'
           AND EXISTS
           (SELECT 1 FROM user_sdo_geom_metadata
             WHERE table_name = nth_feature_table);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;
--
      IF l_tab_username.COUNT > 0
      AND l_tab_ftabs.COUNT > 0
      THEN
  -- Create views for subordiate user(s)
        FOR i IN 1 .. l_tab_username.COUNT
        LOOP
          FOR t IN 1 .. l_tab_ftabs.COUNT
          LOOP
            IF is_priv_view (l_tab_ftabs (t), l_tab_username (i))
            THEN
              BEGIN

                EXECUTE IMMEDIATE    'DROP VIEW '
                                  || l_tab_username (i)
                                  || '.'
                                  || l_tab_ftabs (t);
              EXCEPTION
                 WHEN OTHERS THEN NULL;
              END;
            END IF;

            BEGIN
              EXECUTE IMMEDIATE ('CREATE OR REPLACE SYNONYM '||l_tab_username(i)||'.'||l_tab_ftabs (t) || 
                                 ' FOR ' || Sys_Context('NM3CORE','APPLICATION_OWNER') || '.' || l_tab_ftabs (t));
              /*EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW '
                                || l_tab_username (i)
                                || '.'
                                || l_tab_ftabs (t)
                                || l_nl
                                || 'AS'
                                || l_nl
                                || '  SELECT * FROM '
                                || l_higowner
                                || '.'
                                || l_tab_ftabs (t);*/

            EXCEPTION
               WHEN OTHERS
               THEN NULL;
            END;
          END LOOP;
        END LOOP;
      END IF;
--
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END create_msv_feature_views;

--
-----------------------------------------------------------------------------
--
-- Refreshes user_sdo_geom_metadata for a given subordinate user
--
   PROCEDURE refresh_usgm (
      pi_sub_username    IN   HIG_USERS.hus_username%TYPE,
      pi_role_restrict   IN   BOOLEAN DEFAULT TRUE
   )
   IS
      TYPE tab_usgm IS TABLE OF user_sdo_geom_metadata%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tab_usgm   tab_usgm;
      l_sql        Nm3type.max_varchar2;
      nl           VARCHAR2 (10)        := CHR (10);
      e_no_data    EXCEPTION;
   --
   BEGIN
      --
--      l_sql :=
--            'SELECT table_name, column_name, diminfo, srid '|| nl
--         || '  FROM all_sdo_geom_metadata '|| nl
--         || ' WHERE owner = Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') ';
--      --
--      IF pi_role_restrict
--      THEN
--         l_sql :=
--               l_sql
--            || nl
--            || '    AND EXISTS '|| nl
--            || '    (SELECT 1 ' || nl
--            || '       FROM gis_themes ' || nl
--            || '      WHERE gt_feature_table = table_name)';
--      END IF;

--      --
--      BEGIN
--         EXECUTE IMMEDIATE l_sql
--         BULK COLLECT INTO l_tab_usgm;
--      EXCEPTION
--         WHEN NO_DATA_FOUND
--         THEN
--            RAISE e_no_data;
--      END;

--      --
--      FOR i IN 1 .. l_tab_usgm.COUNT
--      LOOP
--         BEGIN
--            INSERT INTO mdsys.sdo_geom_metadata_table
--                        (sdo_owner, sdo_table_name,
--                         sdo_column_name, sdo_diminfo,
--                         sdo_srid
--                        )
--                 VALUES (pi_sub_username, l_tab_usgm (i).table_name,
--                         l_tab_usgm (i).column_name, l_tab_usgm (i).diminfo,
--                         l_tab_usgm (i).srid
--                        );
--         EXCEPTION
--            WHEN OTHERS
--            THEN
--               Nm_Debug.DEBUG (SQLERRM);
--         END;
--      END LOOP;
   --
     -- MJA 24-Sep_2007: using In causing bind errors
     l_sql :=
        'INSERT INTO mdsys.sdo_geom_metadata_table '||nl||
        '(sdo_owner, sdo_table_name, '||nl||
        ' sdo_column_name, sdo_diminfo, '||nl||
        ' sdo_srid ) '||nl||
        'SELECT '''||pi_sub_username||''', sdo_table_name, sdo_column_name, sdo_diminfo, sdo_srid '||nl||
        '  FROM mdsys.sdo_geom_metadata_table a'||nl||
        ' WHERE sdo_owner = Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') '||nl||
        '   AND NOT EXISTS '||nl||
        '     (SELECT 1 FROM mdsys.sdo_geom_metadata_table b '||nl||
        '       WHERE '''||pi_sub_username||'''  = b.sdo_owner '||nl||
        '         AND a.sdo_table_name  = b.sdo_table_name '||nl||
        '         AND a.sdo_column_name = b.sdo_column_name ) ';
       -- MJA 24-Sep_2007: using In causing bind errors
       /*'INSERT INTO mdsys.sdo_geom_metadata_table '||nl||
        '(sdo_owner, sdo_table_name, '||nl||
        ' sdo_column_name, sdo_diminfo, '||nl||
        ' sdo_srid ) '||nl||
        'SELECT :pi_sub_username, sdo_table_name, sdo_column_name, sdo_diminfo, sdo_srid '||nl||
        '  FROM mdsys.sdo_geom_metadata_table a'||nl||
        ' WHERE sdo_owner = Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') '||nl||
        '   AND NOT EXISTS '||nl||
        '     (SELECT 1 FROM mdsys.sdo_geom_metadata_table b '||nl||
        '       WHERE :pi_sub_username  = b.sdo_owner '||nl||
        '         AND a.sdo_table_name  = b.sdo_table_name '||nl||
        '         AND a.sdo_column_name = b.sdo_column_name ) ';*/
   --
      IF pi_role_restrict
      THEN
         l_sql :=
               l_sql
            || nl
            || 'AND EXISTS '|| nl
            || ' (SELECT 1 ' || nl
            || '    FROM gis_themes ' || nl
            || '   WHERE gt_feature_table = sdo_table_name)';
      END IF;
   --
--     nm_debug.debug_on;
--     nm_debug.debug(l_sql);
   --
     -- MJA 24-Sep_2007: using In causing bind errors
     EXECUTE IMMEDIATE l_sql; -- USING IN pi_sub_username;
     --EXECUTE IMMEDIATE l_sql USING IN pi_sub_username;
   --
   EXCEPTION
      WHEN e_no_data
      THEN
         Hig.raise_ner (pi_appl         => Nm3type.c_hig,
                        pi_id           => 279,
                        pi_sqlcode      => -20001
                       );
--       raise_application_error (-20101, 'No USGM data to process!');
      WHEN OTHERS
      THEN
         RAISE;
   END refresh_usgm;
--
--
-----------------------------------------------------------------------------
--
PROCEDURE get_datum_xy_from_measure (
      p_ne_id     IN       NUMBER,
      p_measure   IN       NUMBER,
      p_x         OUT      NUMBER,
      p_y         OUT      NUMBER
   )
   IS
BEGIN
  Nm3sdo.get_datum_xy_from_measure( p_ne_id, p_measure, p_x, p_y );
END;
-----------------------------------------------------------------------------
--

PROCEDURE create_theme_xy_view ( p_theme_id IN NUMBER ) IS
l_th       NM_THEMES_ALL%ROWTYPE;
l_vw       VARCHAR2(34);
l_ddl_text VARCHAR2(2000);
BEGIN
  l_th := Nm3get.get_nth( p_theme_id );
  IF SUBSTR(l_th.nth_feature_table, 1 ) = 'V' THEN
    l_vw := l_th.nth_feature_table||'_XY';
  ELSE
    l_vw := 'V_NM_'||l_th.nth_feature_table||'_XY';
  END IF;

  l_vw := SUBSTR( l_vw, 1, 30);

  l_ddl_text := 'create or replace view '||l_vw||' as select t.*, v.x, v.y, v.z '||
                ' from '||l_th.nth_feature_table||' t, table ( sdo_util.getvertices( t.'||l_th.nth_feature_shape_column||' ) ) v ';

--  Nm3ddl.create_object_and_syns(l_vw, l_ddl_text );

  -- AE 23-SEP-2008
  -- We will now use views instead of synonyms to provide subordinate user access
  -- to spatial objects
  --nm3ddl.create_object_and_views (l_vw, l_ddl_text);
  -- CWS 0108742 Change back to using synonyms
  Nm3ddl.create_object_and_syns( l_vw, l_ddl_text );


END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE drop_layers_by_node_type
            ( pi_node_type         IN NM_NODE_TYPES.nnt_type%TYPE )
  IS
    l_view_name    user_views.view_name%TYPE;
    l_nth_theme_id NM_THEMES_ALL.nth_theme_id%TYPE;
    l_column_name  user_tab_columns.column_name%TYPE := 'GEOLOC';
    l_rec_nth      NM_THEMES_ALL%ROWTYPE;
    l_sql          Nm3type.max_varchar2;
    lf             VARCHAR2(4)  := CHR(10);
  BEGIN
  --
    Nm_Debug.proc_start(g_package_name,'drop_layers_by_node_type');
  --
    l_view_name     := get_node_table(pi_node_type);
    l_nth_theme_id  := get_theme_from_feature_table(l_view_name);
    IF l_nth_theme_id IS NULL
    THEN
      -- If no theme exists by feature table (i.e. V_NM_NO_ROAD_<>) then
      -- try and derive by theme name.
      -- These might be old node layers (pre 3211) where feature table
      -- was set to nm_point_locations.
      l_nth_theme_id := Nm3get.get_nth
                          (pi_nth_theme_name  => 'NODE_'||pi_node_type
                          ,pi_raise_not_found => FALSE).nth_theme_id;
    END IF;
  --
    IF l_nth_theme_id IS NOT NULL
    THEN
      -- Theme exists, so use it
      l_rec_nth := Nm3get.get_nth (l_nth_theme_id);
      IF l_rec_nth.nth_feature_table = 'NM_POINT_LOCATIONS'
      THEN
        Drop_Layer
          ( p_nth_id             => l_rec_nth.nth_theme_id
          , p_keep_theme_data    => 'N'
          , p_keep_feature_table => 'Y' );
      ELSE
        Drop_Layer
          ( p_nth_id             => l_nth_theme_id);
      END IF;
    ELSE
      -- No theme, so attempt to clear up
      Nm3sdo.drop_metadata(l_view_name);

      BEGIN
        Nm3sdo.drop_sub_layer_by_table(l_view_name,'GEOLOC');
      EXCEPTION WHEN OTHERS THEN NULL;
      END;

      drop_object(l_view_name);

      DECLARE
        no_public_syn_exists EXCEPTION;
        PRAGMA EXCEPTION_INIT ( no_public_syn_exists, -20304 );
        no_private_syn_exists EXCEPTION;
        PRAGMA EXCEPTION_INIT ( no_private_syn_exists, -1434 );
      BEGIN
--        Nm3ddl.drop_synonym_for_object(l_view_name);

        -- AE 23-SEP-2008
        -- Drop views instead of synonyms
        Nm3ddl.drop_views_for_object (l_view_name);
      EXCEPTION
        WHEN no_public_syn_exists THEN
          NULL; -- we don't care - as long as it does not exist now.
        WHEN no_private_syn_exists THEN
          NULL; -- we don't care - as long as it does not exist now.
        WHEN OTHERS THEN
          RAISE;
      END;

      BEGIN
        EXECUTE IMMEDIATE
          'BEGIN '||CHR(10)||
          '  Nm3sde.drop_layer_by_table(l_view_name, '||Nm3flx.string('GEOLOC')||');'||CHR(10)||
          'END';
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    --
    END IF;
  --
    Nm_Debug.proc_end(g_package_name,'drop_layers_by_node_type');
  --
  END drop_layers_by_node_type;
--
-----------------------------------------------------------------------------
--
  PROCEDURE refresh_node_layers
  IS
    l_int           INTEGER;
    l_rec_nth       NM_THEMES_ALL%ROWTYPE;
    l_rec_npl_nth   NM_THEMES_ALL%ROWTYPE;
    l_theme_id      NM_THEMES_ALL.nth_theme_id%TYPE;
  BEGIN
  --
  -- Test for nm_point_locations theme
    l_theme_id := get_theme_from_feature_table ('NM_POINT_LOCATIONS'
                                              , 'NM_POINT_LOCATIONS' );
  --
    IF l_theme_id IS NULL
    THEN
      register_npl_theme;
    END IF;
  --
    FOR i IN
      (SELECT * FROM NM_NODE_TYPES)
      LOOP
        drop_layers_by_node_type (i.nnt_type);
        l_int := create_node_metadata (i.nnt_type);
    END LOOP;
  --
  END refresh_node_layers;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_global_unit_factor RETURN NUMBER IS
  BEGIN
    RETURN g_unit_conv;
  END;

--
------------------------------------------------------------------------------
-- AE Added new procedure to maintain visable themes
-- very basic version to start with, it doesn't deal with it on a user basis,
-- so changes affect all users
--
  PROCEDURE maintain_ntv
             ( pi_theme_id IN nm_themes_all.nth_theme_id%TYPE
             , pi_mode     IN VARCHAR2)
  IS
    l_default_vis VARCHAR2(1) := nvl(hig.get_user_or_sys_opt('DEFVISNTH'),'N');
  BEGIN
  --
    IF pi_mode = 'INSERTING'
    THEN
    --
      INSERT INTO nm_themes_visible (ntv_nth_theme_id,ntv_visible)
      VALUES (pi_theme_id, l_default_vis);
    --
    -- Delete maintained via FK
--    ELSIF pi_mode = 'DELETING'
--    THEN
--    --
--      DELETE nm_themes_visible
--      WHERE ntv_nth_theme_id = pi_theme_id;
    END IF;
  --
  END maintain_ntv;
--
------------------------------------------------------------------------------
--
END Nm3sdm;
/
