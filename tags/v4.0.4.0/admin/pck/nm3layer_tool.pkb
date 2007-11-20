CREATE OR REPLACE PACKAGE BODY nm3layer_tool
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3layer_tool.pkb-arc   2.4   Nov 20 2007 09:17:26   aedwards  $
--       Module Name      : $Workfile:   nm3layer_tool.pkb  $
--       Date into PVCS   : $Date:   Nov 20 2007 09:17:26  $
--       Date fetched Out : $Modtime:   Nov 20 2007 09:17:04  $
--       Version          : $Revision:   2.4  $
--       Based on SCCS version : 1.11
-------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid    CONSTANT VARCHAR2 (2000)       := '$Revision:   2.4  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name   CONSTANT VARCHAR2 (30)         := 'NM3LAYER_TOOL';
   lf                        VARCHAR2 (5)          := CHR (10);
   g_tab_usm                 tab_msv_maps;
   g_tab_ust                 tab_msv_themes;
   g_tab_ustd                tab_msv_theme_details;
   g_xml_header              VARCHAR2 (40)
                                  := '<?xml version="1.0" standalone="yes"?>';
   g_user_key                VARCHAR2 (50);
   g_cancel_flag             VARCHAR2 (1)          := 'N';
   
   g_global_boolean          BOOLEAN;
   
--
-----------------------------------------------------------------------------
--
 /*
   PRIVATE CURSORS
 */
   CURSOR get_datum_layers (cp_nt_type IN nm_types.nt_type%TYPE)
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE EXISTS (
                  SELECT 1
                    FROM nm_nw_themes
                   WHERE nnth_nth_theme_id = nth_theme_id
                     AND EXISTS (
                            SELECT 1
                              FROM nm_linear_types
                             WHERE nlt_id = nnth_nlt_id
                               AND nlt_nt_type = cp_nt_type
                               AND nlt_g_i_d = 'D'))
      ORDER BY 1;

--
   CURSOR get_group_layers (cp_gty_type IN nm_group_types.ngt_group_type%TYPE)
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE EXISTS (
                  SELECT 1
                    FROM nm_nw_themes
                   WHERE nnth_nth_theme_id = nth_theme_id
                     AND EXISTS (
                            SELECT 1
                              FROM nm_linear_types
                             WHERE nlt_id = nnth_nlt_id
                               AND nlt_gty_type = cp_gty_type
                               AND nlt_g_i_d = 'G'))
            OR EXISTS (
                  SELECT 1
                    FROM nm_area_themes
                   WHERE nath_nth_theme_id = nth_theme_id
                     AND EXISTS (
                            SELECT 1
                              FROM nm_area_types
                             WHERE nat_id = nath_nat_id
                               AND nat_gty_group_type = cp_gty_type))
      ORDER BY 1;

--
   CURSOR get_node_layers (cp_node_type IN nm_node_types.nnt_type%TYPE)
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_table_name LIKE 'V_NM_NO_' || UPPER (cp_node_type)
                                   || '_SDO'
      ORDER BY 1;

--
   CURSOR get_inv_layers (cp_inv_type IN nm_inv_types.nit_inv_type%TYPE)
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE EXISTS (
                  SELECT 1
                    FROM nm_inv_themes
                   WHERE nith_nth_theme_id = nth_theme_id
                     AND nith_nit_id = cp_inv_type)
      ORDER BY 1;

--
   CURSOR get_defect_layers
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_table_name = 'DEFECTS' OR nth_pk_column LIKE '%DEFECT_ID%'
      ORDER BY 1;

--
   CURSOR get_enq_layers
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_table_name = 'DOCS'
            OR nth_pk_column like '%DOC%'
      ORDER BY 1;

--
   CURSOR get_acc_location_layers
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_table_name like '%ACC_LOC%'
            OR nth_pk_column = 'ALO_ACC_ID'
            OR nth_table_name like '%ACC_ITEM%'
            OR nth_pk_column = 'ACC_ID'
      ORDER BY 1;

--
   CURSOR get_str_layers
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_table_name like 'STR_ITEMS%'
            OR nth_pk_column = 'STR_ID'
      ORDER BY 1;

--
   CURSOR get_swr_layers
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_table_name like 'SWR%'
            OR nth_pk_column = 'SCO_GIS_ID'
      ORDER BY 1;

--
   CURSOR get_clm_layers
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_table_name like 'CLM%'
            OR nth_pk_column = 'UNI_ID'
      ORDER BY 1;

--
   CURSOR get_nsgn_layers
           ( cp_type  IN  nm_group_types.ngt_group_type%TYPE )
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE EXISTS
           (SELECT 1 FROM v_nm_net_themes_all
             WHERE vnnt_nt_type = 'NSGN'
               AND vnnt_gty_type = cp_type
               AND vnnt_nth_theme_id = nth_theme_id)
      ORDER BY 1;
--
   CURSOR get_nsgn_asd_layers
           ( cp_type  IN  nm_group_types.ngt_group_type%TYPE )
   IS
      SELECT   *
          FROM nm_themes_all
         WHERE nth_feature_table like '%NM_NIT_'||upper(cp_type)||'%'
      ORDER BY 1;
--
   CURSOR get_spatial_index_details (cp_table_name IN VARCHAR2)
   IS
      SELECT a.sdo_index_owner sdo_idx_owner, a.sdo_index_type sdo_idx_type
           , a.sdo_index_table sdo_idx_mrtable, a.sdo_index_name sdo_idx_name
           , REPLACE (a.sdo_column_name, '"', '') sdo_idx_column
           , a.sdo_index_status sdo_idx_status, b.table_name sdo_idx_table
        FROM MDSYS.sdo_index_metadata_table a, user_indexes b
       WHERE sdo_index_name = index_name
         AND table_name = cp_table_name
         AND index_type = 'DOMAIN';

--
-----------------------------------------------------------------------------
--
 /*
   FUNCTIONS
 */
   PROCEDURE is_an_asset_theme (
      pi_theme_id    IN   nm_themes_all.nth_theme_id%TYPE
    , pi_new_theme   IN   nm_themes_all.nth_theme_id%TYPE
   );

--
   PROCEDURE is_an_area_theme (
      pi_theme_id    IN   nm_themes_all.nth_theme_id%TYPE
    , pi_new_theme   IN   nm_themes_all.nth_theme_id%TYPE
   );

--
   PROCEDURE is_a_linear_theme (
      pi_theme_id    IN   nm_themes_all.nth_theme_id%TYPE
    , pi_new_theme   IN   nm_themes_all.nth_theme_id%TYPE
   );

--
-----------------------------------------------------------------------------
--
   FUNCTION get_x_column
      RETURN user_tab_columns.column_name%TYPE
   IS
   BEGIN
      RETURN g_x_column;
   END get_x_column;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_y_column
      RETURN user_tab_columns.column_name%TYPE
   IS
   BEGIN
      RETURN g_y_column;
   END get_y_column;

--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
  /*
    FUNCTIONS
  */
   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      nm_debug.proc_start (g_package_name, 'get_version');
      RETURN g_sccsid;
      nm_debug.proc_end (g_package_name, 'get_version');
   END get_version;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      nm_debug.proc_start (g_package_name, 'get_body_version');
      RETURN g_body_sccsid;
      nm_debug.proc_end (g_package_name, 'get_body_version');
   END get_body_version;


  PROCEDURE set_global_boolean ( pi_value IN BOOLEAN) IS
  BEGIN
   g_global_boolean := pi_value;
  END set_global_boolean;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_global_boolean RETURN BOOLEAN IS
  
  BEGIN
  
    RETURN(g_global_boolean);
  
  END get_global_boolean;
--
-----------------------------------------------------------------------------
--
   FUNCTION get_last_analysed_date (
      pi_table_name   IN   user_tables.table_name%TYPE
   )
      RETURN DATE
   IS
      retval   DATE;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_last_analysed_date');

      --
      SELECT last_analyzed
        INTO retval
        FROM user_tables
       WHERE table_name = pi_table_name;

      RETURN retval;
      --
      nm_debug.proc_end (g_package_name, 'get_last_analysed_date');
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_last_analysed_date;

--
-----------------------------------------------------------------------------
--
-- used to send layer navigation tree to gis0020
   PROCEDURE deliver_tree (
      po_tab_initial_state   IN OUT   nm3type.tab_number
    , po_tab_depth           IN OUT   nm3type.tab_number
    , po_tab_label           IN OUT   nm3type.tab_varchar80
    , po_tab_icon            IN OUT   nm3type.tab_varchar30
    , po_tab_data            IN OUT   nm3type.tab_varchar30
    , po_tab_parent          IN OUT   nm3type.tab_varchar30
   )
   IS
      CURSOR c_branches
      IS
         SELECT nltr_child c_branch, NULL c_depth, NULL c_type, nltr_order
           FROM nm_layer_tree
          WHERE nltr_parent = 'ROOT'
            AND exists
              (select 1 from hig_products
                 where hpr_product = nltr_child
                   and hpr_key IS NOT NULL)
          UNION
         SELECT nltr_child c_branch, NULL c_depth, NULL c_type, nltr_order
           FROM nm_layer_tree
          WHERE nltr_parent = 'ROOT'
            AND nltr_child =  'CUS'
          ORDER by nltr_order;

      l_tab_order_by        nm3type.tab_number;
      l_tab_initial_state   nm3type.tab_number;
      l_tab_depth           nm3type.tab_number;
      l_tab_label           nm3type.tab_varchar80;
      l_tab_icon            nm3type.tab_varchar30;
      l_tab_data            nm3type.tab_varchar30;
      l_tab_parent          nm3type.tab_varchar30;

      --
      PROCEDURE get_root_of_tree (
         po_tab_initial_state   IN OUT   nm3type.tab_number
       , po_tab_depth           IN OUT   nm3type.tab_number
       , po_tab_label           IN OUT   nm3type.tab_varchar80
       , po_tab_icon            IN OUT   nm3type.tab_varchar30
       , po_tab_data            IN OUT   nm3type.tab_varchar30
       , po_tab_parent          IN OUT   nm3type.tab_varchar30
      )
      IS
      --
      BEGIN
         --
         SELECT 1 initial_state, 1 DEPTH, nltr_descr label
              , DECODE (nltr_type, 'M', 'exormini', 'fdrclose') icon
              , nltr_child DATA, nltr_parent PARENT
         BULK COLLECT INTO po_tab_initial_state, po_tab_depth, po_tab_label
              , po_tab_icon
              , po_tab_data, po_tab_parent
           FROM nm_layer_tree
          WHERE nltr_parent = 'TOP';
      --
      END get_root_of_tree;

      --
      PROCEDURE get_favs_for_branch (
         pi_start_with          IN       hig_standard_favourites.hstf_parent%TYPE
       , po_tab_initial_state   IN OUT   nm3type.tab_number
       , po_tab_depth           IN OUT   nm3type.tab_number
       , po_tab_label           IN OUT   nm3type.tab_varchar80
       , po_tab_icon            IN OUT   nm3type.tab_varchar30
       , po_tab_data            IN OUT   nm3type.tab_varchar30
       , po_tab_parent          IN OUT   nm3type.tab_varchar30
       , po_tab_order_by        IN OUT   nm3type.tab_number
      )
      IS
         l_tab_order_by   nm3type.tab_number;
      BEGIN
         SELECT 1 initial_state, DEPTH + 1 DEPTH, nltr_descr label
              , DECODE (nltr_type, 'M', 'exormini', 'fdrclose') icon
              , nltr_child DATA, nltr_parent PARENT, nltr_order order_by
         BULK COLLECT INTO po_tab_initial_state, po_tab_depth, po_tab_label
              , po_tab_icon
              , po_tab_data, po_tab_parent, po_tab_order_by
           FROM (SELECT     nltr_child, nltr_type, nltr_descr, LEVEL DEPTH
                          , nltr_parent, nltr_order
                       FROM nm_layer_tree
                 CONNECT BY PRIOR nltr_child = nltr_parent
                 START WITH nltr_child = pi_start_with
                   ORDER SIBLINGS BY nltr_order ASC);
      END get_favs_for_branch;

      --
      PROCEDURE append
      IS
         l_nextrec   PLS_INTEGER;
      BEGIN
         FOR v_nodes IN 1 .. l_tab_initial_state.COUNT
         LOOP
            l_nextrec := po_tab_initial_state.COUNT + 1;
            po_tab_initial_state (l_nextrec) := l_tab_initial_state (v_nodes);
            po_tab_depth (l_nextrec) := l_tab_depth (v_nodes);
            po_tab_label (l_nextrec) := l_tab_label (v_nodes);
            po_tab_icon (l_nextrec) := l_tab_icon (v_nodes);
            po_tab_data (l_nextrec) := l_tab_data (v_nodes);
            po_tab_parent (l_nextrec) := l_tab_parent (v_nodes);
         END LOOP;                                                  -- v_nodes
      END append;
   --
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'deliver_tree');
--
  ---------------------------
  -- Get the root of the menu
  ---------------------------
      get_root_of_tree (po_tab_initial_state      => po_tab_initial_state
                      , po_tab_depth              => po_tab_depth
                      , po_tab_label              => po_tab_label
                      , po_tab_icon               => po_tab_icon
                      , po_tab_data               => po_tab_data
                      , po_tab_parent             => po_tab_parent
                       );

      FOR v_recs IN c_branches
      LOOP
         get_favs_for_branch (pi_start_with             => v_recs.c_branch
                            , po_tab_initial_state      => l_tab_initial_state
                            , po_tab_depth              => l_tab_depth
                            , po_tab_label              => l_tab_label
                            , po_tab_icon               => l_tab_icon
                            , po_tab_data               => l_tab_data
                            , po_tab_parent             => l_tab_parent
                            , po_tab_order_by           => l_tab_order_by
                             );
         append;
      END LOOP;

      --
      nm_debug.proc_end (g_package_name, 'deliver_tree');
   --
   END deliver_tree;

--
-----------------------------------------------------------------------------
--
-- returns theme details for a given layer type
-- i.e.       B   =   Base Datum Layer
--            G   =   Group Layer
--            N   =   Node Layer
--            I   =   Asset Layer
--            D   =   Defects Layer
--            E   =   Enquiries Layer
--            AL  =   Accident Locations
--            ST  =   Structures
--            SW  =   Streetworks Sites
--            C   =   Streetlights
--            NSG =   NSGN Streets

   PROCEDURE get_theme_details (
      pi_layer_type   IN       VARCHAR2
    , pi_type         IN       VARCHAR2
    , po_results      IN OUT   tab_theme_results
   )
   IS
      l_tab_nth            tab_nth;
      l_tab_usgm           tab_usgm;
      l_results            tab_theme_results;
      b_is_key_preserved   BOOLEAN;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_theme_details');
      --
      l_tab_nth.DELETE;
      l_tab_usgm.DELETE;

      --
      IF pi_layer_type = 'B'
      THEN
         -- Base Datum Layers
         OPEN get_datum_layers (pi_type);
         FETCH get_datum_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_datum_layers;

      ELSIF pi_layer_type = 'G'
      -- Group Layers
      THEN
         OPEN get_group_layers (pi_type);
         FETCH get_group_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_group_layers;

      ELSIF pi_layer_type = 'N'
      -- Node Layers
      THEN
         OPEN get_node_layers (pi_type);
         FETCH get_node_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_node_layers;

      ELSIF pi_layer_type = 'I'
      -- Asset Layers
      THEN
         OPEN get_inv_layers (pi_type);
         FETCH get_inv_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_inv_layers;

      ELSIF pi_layer_type = 'D'
      -- Defect Layers
      THEN
         OPEN get_defect_layers;
         FETCH get_defect_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_defect_layers;

      ELSIF pi_layer_type = 'E'
      -- Enquiries Layers
      THEN
         OPEN get_enq_layers;
         FETCH get_enq_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_enq_layers;

      ELSIF pi_layer_type = 'A'
      -- Accident Layers
      THEN
         OPEN get_acc_location_layers;
         FETCH get_acc_location_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_acc_location_layers;

      ELSIF pi_layer_type = 'ST'
      -- Structures Layers
      THEN
         OPEN get_str_layers;
         FETCH get_str_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_str_layers;

      ELSIF pi_layer_type = 'SW'
      -- Structures Layers
      THEN
         OPEN get_swr_layers;
         FETCH get_swr_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_swr_layers;

      ELSIF pi_layer_type = 'C'
      -- Streetlighting Layers
      THEN
         OPEN get_clm_layers;
         FETCH get_clm_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_clm_layers;

      ELSIF pi_layer_type = 'NSG'
      -- NSGN Street Layers
      THEN
         OPEN get_nsgn_layers ( cp_type => pi_type );
         FETCH get_nsgn_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_nsgn_layers;

      ELSIF pi_layer_type = 'ASD'
      -- NSGN Street Layers
      THEN
         OPEN get_nsgn_asd_layers ( cp_type => pi_type );
         FETCH get_nsgn_asd_layers
         BULK COLLECT INTO l_tab_nth;
         CLOSE get_nsgn_asd_layers;

      ELSIF pi_layer_type = 'STP'
      AND hig.is_product_licensed ('STP')
      -- STP Scheme layers
      -- This is executed dynamically because it relies on the link table
      -- STP_SCHEME_THEMES which only exists if STP is installed
      THEN
      --
        BEGIN
          EXECUTE IMMEDIATE
            '  SELECT * '||lf||
            '    FROM nm_themes_all '||lf||
            '   WHERE EXISTS '||lf||
            '     (SELECT 1 FROM stp_scheme_themes '||lf||
            '       WHERE sst_nth_theme_id = nth_theme_id '||lf||
            '         AND sst_njt_type = :pi_job_type)'
          BULK COLLECT INTO l_tab_nth
          USING IN pi_type;
        --
        END;
      END IF;

      --
      FOR i IN 1 .. l_tab_nth.COUNT
      LOOP
         --
         -- [ Populate Theme details ]
         l_results (i).c_nth_theme_id             :=  l_tab_nth (i).nth_theme_id;
         l_results (i).c_nth_theme_name           :=  l_tab_nth (i).nth_theme_name;
         l_results (i).c_nth_table_name           :=  l_tab_nth (i).nth_table_name;
         l_results (i).c_nth_where                :=  l_tab_nth (i).nth_where;
         l_results (i).c_nth_pk_column            :=  l_tab_nth (i).nth_pk_column;
         l_results (i).c_nth_label_column         :=  l_tab_nth (i).nth_label_column;
         l_results (i).c_nth_rse_table_name       :=  l_tab_nth (i).nth_rse_table_name;
         l_results (i).c_nth_rse_fk_column        :=  l_tab_nth (i).nth_rse_fk_column;
         l_results (i).c_nth_st_chain_column      :=  l_tab_nth (i).nth_st_chain_column;
         l_results (i).c_nth_end_chain_column     :=  l_tab_nth (i).nth_end_chain_column;
         l_results (i).c_nth_x_column             :=  l_tab_nth (i).nth_x_column;
         l_results (i).c_nth_y_column             :=  l_tab_nth (i).nth_y_column;
         l_results (i).c_nth_offset_field         :=  l_tab_nth (i).nth_offset_field;
         l_results (i).c_nth_feature_table        :=  l_tab_nth (i).nth_feature_table;
         l_results (i).c_nth_ft_last_analysed     :=  get_last_analysed_date (l_tab_nth (i).nth_feature_table);
         l_results (i).c_nth_feature_pk_column    :=  l_tab_nth (i).nth_feature_pk_column;
         l_results (i).c_nth_feature_fk_column    :=  l_tab_nth (i).nth_feature_fk_column;
         l_results (i).c_nth_xsp_column           :=  l_tab_nth (i).nth_xsp_column;
         l_results (i).c_nth_feature_shape_column :=  l_tab_nth (i).nth_feature_shape_column;
         l_results (i).c_nth_hpr_product          :=  l_tab_nth (i).nth_hpr_product;
         l_results (i).c_nth_location_updatable   :=  l_tab_nth (i).nth_location_updatable;
         l_results (i).c_nth_theme_type           :=  l_tab_nth (i).nth_theme_type;
--      l_results(i).c_nth_base_theme             :=  l_tab_nth(i).nth_base_theme;
         l_results (i).c_nth_dependency           :=  l_tab_nth (i).nth_dependency;
         l_results (i).c_nth_storage              :=  l_tab_nth (i).nth_storage;
         l_results (i).c_nth_update_on_edit       :=  l_tab_nth (i).nth_update_on_edit;
         l_results (i).c_nth_use_history          :=  l_tab_nth (i).nth_use_history;
         l_results (i).c_nth_start_date_column    :=  l_tab_nth (i).nth_start_date_column;
         l_results (i).c_nth_end_date_column      :=  l_tab_nth (i).nth_end_date_column;
         l_results (i).c_nth_base_table_theme     :=  l_tab_nth (i).nth_base_table_theme;
         l_results (i).c_nth_sequence_name        :=  l_tab_nth (i).nth_sequence_name;
         l_results (i).c_nth_snap_to_theme        :=  l_tab_nth (i).nth_snap_to_theme;
         l_results (i).c_nth_lref_mandatory       :=  l_tab_nth (i).nth_lref_mandatory;
         l_results (i).c_nth_tolerance            :=  l_tab_nth (i).nth_tolerance;
         l_results (i).c_nth_tol_units            :=  l_tab_nth (i).nth_tol_units;

         --
         -- [ Get Theme GType details ]
         BEGIN
            SELECT ntg_gtype
                 , hco_meaning
              INTO l_results (i).c_ntg_gtype
                 , l_results (i).c_ntg_gtype_meaning
              FROM nm_theme_gtypes, hig_codes
             WHERE hco_domain = 'GEOMETRY_TYPE'
               AND hco_code = ntg_gtype
               AND ntg_theme_id = l_tab_nth (i).nth_theme_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_results (i).c_ntg_gtype := NULL;
               l_results (i).c_ntg_gtype_meaning := NULL;
            WHEN OTHERS
            THEN
               RAISE;
         END;

         --
         IF l_results (i).c_nth_feature_table IS NOT NULL
         THEN
            b_is_key_preserved :=
                         is_key_preserved (l_results (i).c_nth_feature_table);

            IF b_is_key_preserved
            THEN
               l_results (i).c_key_preserved := 'Y';
            ELSE
               l_results (i).c_key_preserved := 'N';
            END IF;
         END IF;

         --
         l_results (i).c_object_status :=
                           is_object_valid (l_results (i).c_nth_feature_table);
      --
      END LOOP;

      --
      po_results := l_results;
      --
      nm_debug.proc_end (g_package_name, 'get_theme_details');
   --
   END get_theme_details;

--
-----------------------------------------------------------------------------
--
-- returns SDO metadata for a given Theme ID
   PROCEDURE get_sdo_details (
      pi_nth_theme_id   IN       nm_themes_all.nth_theme_id%TYPE
    , po_results        IN OUT   tab_sdo_results
   )
   IS
      l_rec_nth    rec_nth;
      l_rec_usgm   rec_usgm;
      l_results    tab_sdo_results;
      l_gtype      nm_theme_gtypes.ntg_gtype%TYPE;
      i            NUMBER                           := 1;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_sdo_details');
      --
      l_results.DELETE;
      --
      l_rec_nth :=
         nm3get.get_nth (pi_nth_theme_id         => pi_nth_theme_id
                       , pi_raise_not_found      => FALSE
                        );

      --
      IF l_rec_nth.nth_theme_id IS NULL
      THEN
         RETURN;
      END IF;

      --
      l_gtype :=
         nm3get.get_ntg (pi_ntg_theme_id         => pi_nth_theme_id
                       , pi_raise_not_found      => FALSE
                        ).ntg_gtype;

      --
      -- [ Get USER_SDO_GEOM_METADATA ]
      BEGIN
         SELECT *
           INTO l_rec_usgm
           FROM user_sdo_geom_metadata
          WHERE table_name = l_rec_nth.nth_feature_table
            AND column_name = l_rec_nth.nth_feature_shape_column;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN OTHERS
         THEN
            RAISE;
      END;

      --
      --
      BEGIN
         l_results (i).c_usgm_table_name  := l_rec_usgm.table_name;
         l_results (i).c_usgm_column_name := l_rec_usgm.column_name;
         l_results (i).c_usgm_x_label     := l_rec_usgm.diminfo (1).sdo_dimname;
         l_results (i).c_usgm_y_label     := l_rec_usgm.diminfo (2).sdo_dimname;
         l_results (i).c_usgm_x_tolerance := l_rec_usgm.diminfo (1).sdo_tolerance;
         l_results (i).c_usgm_y_tolerance := l_rec_usgm.diminfo (2).sdo_tolerance;
         l_results (i).c_usgm_max_x       := l_rec_usgm.diminfo (1).sdo_ub;
         l_results (i).c_usgm_max_y       := l_rec_usgm.diminfo (2).sdo_ub;
         l_results (i).c_usgm_min_x       := l_rec_usgm.diminfo (1).sdo_lb;
         l_results (i).c_usgm_min_y       := l_rec_usgm.diminfo (2).sdo_lb;
         l_results (i).c_usgm_srid        := l_rec_usgm.srid;

         --
         IF l_gtype LIKE '3%'
         THEN
            BEGIN
               l_results (i).c_usgm_z_label     := l_rec_usgm.diminfo (3).sdo_dimname;
               l_results (i).c_usgm_z_tolerance := l_rec_usgm.diminfo (3).sdo_tolerance;
               l_results (i).c_usgm_max_z       := l_rec_usgm.diminfo (3).sdo_ub;
               l_results (i).c_usgm_min_z       := l_rec_usgm.diminfo (3).sdo_lb;
            EXCEPTION
               -- Something wrong with number of dims compared to Gtype.
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      -- This is a catch all, because we'll end up getting subscript errors
      -- when refering to elements that don't exists (l_rec_usgm.diminfo(1) etc).
      -- If the feature table doesn't exist, then all this will fail.
      END;

      --
        --
        -- [ Get SRID Meaning Text ]
      IF l_rec_usgm.srid IS NOT NULL
      THEN
         BEGIN
            SELECT wktext
              INTO l_results (i).c_usgm_srid_meaning
              FROM MDSYS.cs_srs
             WHERE srid = l_rec_usgm.srid;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               BEGIN
                  SELECT wktext
                    INTO l_results (i).c_usgm_srid_meaning
                    FROM MDSYS.cs_srs
                   WHERE srid = l_rec_usgm.srid;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
         END;
      END IF;

      --

      -- [ get spatial index details ]
      OPEN get_spatial_index_details
                                 (cp_table_name      => l_rec_nth.nth_feature_table);

      FETCH get_spatial_index_details
       INTO l_results (i).c_sdo_index_owner, l_results (i).c_sdo_index_type
          , l_results (i).c_sdo_index_mrtable, l_results (i).c_sdo_index_name
          , l_results (i).c_sdo_column_name, l_results (i).c_sdo_index_status
          , l_results (i).c_sdo_index_table;

      CLOSE get_spatial_index_details;

      --
      po_results := l_results;
      --
      nm_debug.proc_end (g_package_name, 'get_sdo_details');
   --
   END get_sdo_details;

--
-----------------------------------------------------------------------------
--
-- returns SDE metadata for a given theme
-- anything relating to nm3sde/SDE schema object must remain dynamic to stop
-- unnecessary dependencies
   PROCEDURE get_sde_details (
      pi_nth_theme_id   IN       nm_themes_all.nth_theme_id%TYPE
    , po_results        IN OUT   tab_sde_results
   )
   IS
      l_rec_nth   rec_nth;
      l_results   tab_sde_results;
      i           NUMBER          := 1;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_sde_details');
      --
      l_rec_nth :=
         nm3get.get_nth (pi_nth_theme_id         => pi_nth_theme_id
                       , pi_raise_not_found      => FALSE
                        );

      --
      IF l_rec_nth.nth_theme_id IS NULL
      THEN
         RETURN;
      END IF;

      -- [ Check for SDE metadata ]
      IF hig.get_sysopt ('REGSDELAY') = 'Y'
      THEN
         DECLARE
            l_sql    nm3type.max_varchar2;
            l_bool   BOOLEAN;
         BEGIN
            nm_debug.DEBUG ('IN SDE DATA FETCH');
      --
      -- [ Get all SDE metadata ]
--         BEGIN
-- --          EXECUTE IMMEDIATE
--          l_sql:=
--             'BEGIN '                          ||lf||
--             '  SELECT release ,description'   ||lf||
--             '    INTO :tab_sde_version,'      ||lf||
--             '         :tab_sde_descr'         ||lf||
--             '    FROM sde.version;'           ||lf||
--             'END;';
--           nm_debug.debug(l_sql);
--           EXECUTE IMMEDIATE l_sql
--           USING OUT l_results(i).c_sde_version
--               , OUT l_results(i).c_sde_version_descr;
--         EXCEPTION
--           WHEN NO_DATA_FOUND
--             THEN NULL;
--           WHEN OTHERS
--             THEN RAISE;
--         END;
   --     nm_debug.debug('SDE Version = '||l_results(i).c_sde_version||'-'||l_results(i).c_sde_version_descr);
            nm_debug.DEBUG ('Collected SDE Version');

            --
            BEGIN
               EXECUTE IMMEDIATE    'BEGIN '
                                 || lf
                                 || '  SELECT layer_id, description '
                                 || lf
                                 || '       , database_name, owner '
                                 || lf
                                 || '       , table_name, spatial_column '
                                 || lf
                                 || '       , eflags, layer_mask, gsize1 '
                                 || lf
                                 || '       , gsize2, gsize3, minx, miny '
                                 || lf
                                 || '       , maxx, maxy, cdate '
                                 || lf
                                 || '       , layer_config '
                                 || lf
                                 || '       , optimal_array_size '
                                 || lf
                                 || '       , stats_date, minimum_id, srid '
                                 || lf
                                 || '       , base_layer_id '
                                 || lf
                                 || '   INTO '
                                 || lf
                                 || '        :tab_layer_id'
                                 || lf
                                 || '       ,:tab_layer_name'
                                 || lf
                                 || '       ,:tab_database_name'
                                 || lf
                                 || '       ,:tab_owner'
                                 || lf
                                 || '       ,:tab_table_name'
                                 || lf
                                 || '       ,:tab_spatial_column'
                                 || lf
                                 || '       ,:tab_eflags'
                                 || lf
                                 || '       ,:tab_layer_mask'
                                 || lf
                                 || '       ,:tab_gsize1'
                                 || lf
                                 || '       ,:tab_gsize2'
                                 || lf
                                 || '       ,:tab_gsize3'
                                 || lf
                                 || '       ,:tab_minx'
                                 || lf
                                 || '       ,:tab_miny'
                                 || lf
                                 || '       ,:tab_maxx'
                                 || lf
                                 || '       ,:tab_maxy'
                                 || lf
                                 || '       ,:tab_cdate'
                                 || lf
                                 || '       ,:tab_layer_config'
                                 || lf
                                 || '       ,:tab_optimal_array_size'
                                 || lf
                                 || '       ,:tab_stats_date'
                                 || lf
                                 || '       ,:tab_minimum_id'
                                 || lf
                                 || '       ,:tab_srid'
                                 || lf
                                 || '       ,:tab_base_layer_id'
                                 || lf
                                 || '    FROM sde.layers'
                                 || lf
                                 || '   WHERE owner = user '
                                 || lf
                                 || '     AND table_name = '
                                 || nm3flx.STRING (l_rec_nth.nth_feature_table)
                                 || CHR (10)
                                 || '     AND spatial_column = '
                                 || nm3flx.STRING
                                           (l_rec_nth.nth_feature_shape_column)
                                 || ';'
                                 || CHR (10)
                                 || 'END;'
                           USING
                                    OUT l_results (i).c_sdelay_layer_id
                               , OUT l_results (i).c_sdelay_layer_name
                               , OUT l_results (i).c_sdelay_database_name
                               , OUT l_results (i).c_sdelay_owner
                               , OUT l_results (i).c_sdelay_table_name
                               , OUT l_results (i).c_sdelay_spatial_column
                               , OUT l_results (i).c_sdelay_eflags
                               , OUT l_results (i).c_sdelay_layer_mask
                               , OUT l_results (i).c_sdelay_gsize1
                               , OUT l_results (i).c_sdelay_gsize2
                               , OUT l_results (i).c_sdelay_gsize3
                               , OUT l_results (i).c_sdelay_minx
                               , OUT l_results (i).c_sdelay_miny
                               , OUT l_results (i).c_sdelay_maxx
                               , OUT l_results (i).c_sdelay_maxy
                               , OUT l_results (i).c_sdelay_cdate
                               , OUT l_results (i).c_sdelay_layer_config
                               , OUT l_results (i).c_sdelay_optimal_array_size
                               , OUT l_results (i).c_sdelay_stats_date
                               , OUT l_results (i).c_sdelay_minimum_id
                               , OUT l_results (i).c_sdelay_srid
                               , OUT l_results (i).c_sdelay_base_layer_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  RAISE;
            END;

            nm_debug.DEBUG ('Collected SDE Layers');

            --
              -- [ sde.table_registry ]
            BEGIN
               EXECUTE IMMEDIATE    'BEGIN '
                                 || CHR (10)
                                 || '  SELECT registration_id, table_name '
                                 || lf
                                 || '       , owner, rowid_column '
                                 || lf
                                 || '       , description, object_flags '
                                 || lf
                                 || '       , registration_date '
                                 || lf
                                 || '       , config_keyword, minimum_id '
                                 || lf
                                 || '       , imv_view_name'
                                 || lf
                                 || '    INTO '
                                 || lf
                                 || '         :tab_registration_id'
                                 || lf
                                 || '       , :tab_table_name'
                                 || lf
                                 || '       , :tab__owner'
                                 || lf
                                 || '       , :tab_rowid_column'
                                 || lf
                                 || '       , :tab_description'
                                 || lf
                                 || '       , :tab_object_flags'
                                 || lf
                                 || '       , :tab_registration_date'
                                 || lf
                                 || '       , :tab_config_keyword'
                                 || lf
                                 || '       , :tab_minimum_id'
                                 || lf
                                 || '       , :tab_imv_view_name'
                                 || lf
                                 || '    FROM sde.table_registry'
                                 || lf
                                 || '   WHERE owner = user '
                                 || lf
                                 || '     AND table_name = '
                                 || nm3flx.STRING (l_rec_nth.nth_feature_table)
                                 || CHR (10)
                                 || ';'
                                 || CHR (10)
                                 || 'END;'
                           USING OUT l_results (i).c_sdetab_registration_id
                               , OUT l_results (i).c_sdetab_table_name
                               , OUT l_results (i).c_sdetab_owner
                               , OUT l_results (i).c_sdetab_rowid_column
                               , OUT l_results (i).c_sdetab_description
                               , OUT l_results (i).c_sdetab_object_flags
                               , OUT l_results (i).c_sdetab_registration_date
                               , OUT l_results (i).c_sdetab_config_keyword
                               , OUT l_results (i).c_sdetab_minimum_id
                               , OUT l_results (i).c_sdetab_imv_view_name;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  RAISE;
            END;

            --
            nm_debug.DEBUG ('Collected SDE TReg');

            --
              -- [ sde.geometry_columns ]
            BEGIN
               EXECUTE IMMEDIATE    'BEGIN '
                                 || lf
                                 || '  SELECT f_table_catalog '
                                 || lf
                                 || '       , f_table_schema '
                                 || lf
                                 || '       , f_table_name '
                                 || lf
                                 || '       , f_geometry_column '
                                 || lf
                                 || '       , g_table_catalog '
                                 || lf
                                 || '       , g_table_schema '
                                 || lf
                                 || '       , g_table_name '
                                 || lf
                                 || '       , storage_type '
                                 || lf
                                 || '       , geometry_type '
                                 || lf
                                 || '       , coord_dimension '
                                 || lf
                                 || '       , max_ppr '
                                 || lf
                                 || '       , srid '
                                 || lf
                                 || '    INTO'
                                 || lf
                                 || '      :tab_f_table_catalog'
                                 || lf
                                 || '     ,:tab_f_table_schema'
                                 || lf
                                 || '     ,:tab_f_table_name'
                                 || lf
                                 || '     ,:tab_f_geometry_column'
                                 || lf
                                 || '    , :tab_g_table_catalog'
                                 || lf
                                 || '    , :tab_g_table_schema'
                                 || lf
                                 || '    , :tab_g_table_name'
                                 || lf
                                 || '    , :tab_storage_type'
                                 || lf
                                 || '    , :tab_geometry_type'
                                 || lf
                                 || '    , :tab_coord_dimension'
                                 || lf
                                 || '    , :tab_max_ppr'
                                 || lf
                                 || '    , :tab_srid'
                                 || lf
                                 || '    FROM sde.geometry_columns'
                                 || lf
                                 || '   WHERE f_table_schema = user '
                                 || lf
                                 || '     AND f_table_name =      '
                                 || nm3flx.STRING (l_rec_nth.nth_feature_table)
                                 || lf
                                 || '     AND f_geometry_column = '
                                 || nm3flx.STRING
                                           (l_rec_nth.nth_feature_shape_column)
                                 || ';'
                                 || lf
                                 || 'END;'
                           USING OUT l_results (i).c_sdegeo_f_table_catalog
                               , OUT l_results (i).c_sdegeo_f_table_schema
                               , OUT l_results (i).c_sdegeo_f_table_name
                               , OUT l_results (i).c_sdegeo_f_geometry_column
                               , OUT l_results (i).c_sdegeo_g_table_catalog
                               , OUT l_results (i).c_sdegeo_g_table_schema
                               , OUT l_results (i).c_sdegeo_g_table_name
                               , OUT l_results (i).c_sdegeo_storage_type
                               , OUT l_results (i).c_sdegeo_geometry_type
                               , OUT l_results (i).c_sdegeo_coord_dimension
                               , OUT l_results (i).c_sdegeo_max_ppr
                               , OUT l_results (i).c_sdegeo_srid;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  RAISE;
            END;

            nm_debug.DEBUG ('Collected SDE Geocol');

            -- [ sde.spatial_references ]
            BEGIN
               IF l_results (i).c_sdelay_srid IS NOT NULL
               THEN
                  BEGIN
                     EXECUTE IMMEDIATE    'BEGIN '
                                       || lf
                                       || '  SELECT srid, description '
                                       || lf
                                       || '       , auth_name, auth_srid '
                                       || lf
                                       || '       , falsex, falsey, xyunits '
                                       || lf
                                       || '       , falsez, zunits, falsem '
                                       || lf
                                       || '       , munits '
                                       || lf
                                       || '       , srtext '
                                       || lf
                                       || '    INTO'
                                       || lf
                                       || '      :tab_srid'
                                       || lf
                                       || '    , :tab_description'
                                       || lf
                                       || '    , :tab_auth_name'
                                       || lf
                                       || '    , :tab_auth_srid'
                                       || lf
                                       || '    , :tab_falsex'
                                       || lf
                                       || '    , :tab_falsey'
                                       || lf
                                       || '    , :tab_xyunits'
                                       || lf
                                       || '    , :tab_falsez'
                                       || lf
                                       || '    , :tab_zunits'
                                       || lf
                                       || '    , :tab_falsem'
                                       || lf
                                       || '    , :tab_munits'
                                       || lf
                                       || '    , :tab_srtext'
                                       || lf
                                       || '    FROM sde.spatial_references'
                                       || lf
                                       || '   WHERE srid = '
                                       || l_results (i).c_sdelay_srid
                                       || ';'
                                       || lf
                                       || 'END;'
                                 USING OUT l_results (i).c_sdesrd_srid
                                     , OUT l_results (i).c_sdesrd_description
                                     , OUT l_results (i).c_sdesrd_auth_name
                                     , OUT l_results (i).c_sdesrd_auth_srid
                                     , OUT l_results (i).c_sdesrd_falsex
                                     , OUT l_results (i).c_sdesrd_falsey
                                     , OUT l_results (i).c_sdesrd_xyunits
                                     , OUT l_results (i).c_sdesrd_falsez
                                     , OUT l_results (i).c_sdesrd_zunits
                                     , OUT l_results (i).c_sdesrd_falsem
                                     , OUT l_results (i).c_sdesrd_munits
                                     , OUT l_results (i).c_sdesrd_srtext;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;
                     WHEN OTHERS
                     THEN
                        RAISE;
                  END;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            --
            nm_debug.DEBUG ('Collected SDE SRID');
         --
         END;
      --
      END IF;

      --
      po_results := l_results;
      --
      nm_debug.proc_end (g_package_name, 'get_sde_details');
   --
   END get_sde_details;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_sde_version
      RETURN VARCHAR2
   IS
      l_sql       nm3type.max_varchar2;
      l_version   NUMBER;
      l_descr     VARCHAR2 (500);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_sde_version');
      --
      l_sql :=
            'BEGIN '
         || lf
         || ' SELECT release, description '
         || lf
         || '   INTO :l_version, :l_descr '
         || lf
         || '   FROM sde.version '
         || lf
         || '  WHERE release = (SELECT max(release) FROM sde.version);'
         || lf
         || 'END;';

      --
      EXECUTE IMMEDIATE l_sql
                  USING OUT l_version, OUT l_descr;

      --
      RETURN 'SDE Version = ' || l_version || lf || l_descr;
      --
      nm_debug.proc_end (g_package_name, 'get_sde_version');
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         nm_debug.DEBUG ('Failed to get version - ' || SQLERRM);
         RETURN NULL;
   END get_sde_version;

--
-----------------------------------------------------------------------------
--
  /************************************
     START OF MAPVIEWER QUERY/DDL CODE
  ************************************/
--
-----------------------------------------------------------------------------
--
   PROCEDURE populate_msv_tables
   IS
      --
      l_tmp_tab_msvm            tab_msv_maps;
      l_tmp_tab_msvt            tab_msv_themes;
      l_tab_msv_theme_details   tab_msv_theme_details;
   --
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'populate_msv_tables');
  --
--    nm_debug.debug_on;
  --
--     get_msv_usm
--       ( pi_table_name => NULL
--       , po_results    => l_tmp_tab_msvm);
--     --
--     FOR i IN l_tmp_tab_msvm.FIRST..l_tmp_tab_msvm.LAST
--     LOOP
--       --
--       INSERT INTO nm_msv_maps
--       VALUES l_tmp_tab_msvm(i);
--
--       get_msv_ust
--         ( pi_map_name   => l_tmp_tab_msvm(i).c_map_name
--         , po_results    => l_tmp_tab_msvt);
--
--       FOR j IN l_tmp_tab_msvt.FIRST..l_tmp_tab_msvt.LAST
--       LOOP
--       --
--         INSERT INTO nm_msv_map_themes
--           ( msvmt_map_name
--           , msvmt_theme_name
--           , msvmt_theme_min_scale
--           , msvmt_theme_max_scale )
--         VALUES
--           ( l_tmp_tab_msvm(i).c_map_name
--           , l_tmp_tab_msvt(j).c_theme_name
--           , l_tmp_tab_msvt(j).c_theme_min_scale
--           , l_tmp_tab_msvt(j).c_theme_max_scale);
--       --
--         get_msv_ustd
--           ( pi_theme_name   => l_tmp_tab_msvt(j).c_theme_name
--           , po_results      => l_tab_msv_theme_details );
--
--          FOR k IN l_tab_msv_theme_details.FIRST..l_tab_msv_theme_details.LAST
--          LOOP
--          --
--            INSERT INTO nm_msv_theme_details
--             ( msvt_theme_name
--             , msvt_base_table
--             , msvt_geometry_column
--             , msvt_rule_column
--             , msvt_feature_style
--             , msvt_label_column
--             , msvt_label_style )
--            VALUES
--             ( l_tmp_tab_msvt(j).c_theme_name
--             , l_tab_msv_theme_details(k).c_base_table
--             , l_tab_msv_theme_details(k).c_geometry_column
--             , l_tab_msv_theme_details(k).c_rule_column
--             , l_tab_msv_theme_details(k).c_feature_style
--             , l_tab_msv_theme_details(k).c_label_column
--             , l_tab_msv_theme_details(k).c_label_style );
--          END LOOP;-- nm_msv_theme_details
--       END LOOP;-- nm_msv_map_themes
--     END LOOP;-- nm_msv_maps
  --
      nm_debug.proc_end (g_package_name, 'populate_msv_tables');
   --
   END populate_msv_tables;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_msv_maps
   IS
   BEGIN
      NULL;
--   rec_msv_maps
--   IS RECORD --user_sdo_maps
--             (
--               c_map_name                   VARCHAR2(32)
--             , c_map_description            VARCHAR2(4000)
--             , c_theme_name                 VARCHAR2(250)
--             , c_theme_min_scale            VARCHAR2(100)
--             , c_theme_max_scale            VARCHAR2(100)
--             );
   END get_msv_maps;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_usm_attributes (pi_doc xmldom.domdocument, pi_index NUMBER)
   IS
      nl         xmldom.domnodelist;
      len1       NUMBER;
      len2       NUMBER;
      n          xmldom.domnode;
      e          xmldom.domelement;
      nnm        xmldom.domnamednodemap;
      attrname   VARCHAR2 (100);
      attrval    VARCHAR2 (100);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_usm_attributes');
      --
        -- get all elements
      nl := xmldom.getelementsbytagname (pi_doc, '*');
      len1 := xmldom.getlength (nl);

      -- loop through elements
      FOR j IN 0 .. len1 - 1
      LOOP
         n := xmldom.item (nl, j);
         e := xmldom.makeelement (n);
         DBMS_OUTPUT.put_line (xmldom.gettagname (e) || ':');
         -- get all attributes of element
         nnm := xmldom.getattributes (n);

         IF (xmldom.isnull (nnm) = FALSE)
         THEN
            len2 := xmldom.getlength (nnm);

            -- loop through attributes
            FOR i IN 0 .. len2 - 1
            LOOP
               n := xmldom.item (nnm, i);
               attrname := xmldom.getnodename (n);
               attrval := xmldom.getnodevalue (n);
--           IF attrname = 'name'
--             THEN
--             g_tab_usm(pi_index).c_theme_name := attrval;
--           ELSIF attrname = 'min_scale'
--             THEN
--             g_tab_usm(pi_index).c_theme_min_scale := attrval;
--           ELSIF attrname = 'max_scale'
--             THEN
--             g_tab_usm(pi_index).c_theme_max_scale := attrval;
--           END IF;
            END LOOP;
         END IF;
      END LOOP;

      --
      nm_debug.proc_end (g_package_name, 'get_usm_attributes');
   --
   END get_usm_attributes;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_ust_attributes (pi_doc xmldom.domdocument, pi_index NUMBER)
   IS
      nl         xmldom.domnodelist;
      len1       NUMBER;
      len2       NUMBER;
      n          xmldom.domnode;
      e          xmldom.domelement;
      nnm        xmldom.domnamednodemap;
      attrname   VARCHAR2 (100);
      attrval    VARCHAR2 (100);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_ust_attributes');
      --

      -- get all elements
      nl := xmldom.getelementsbytagname (pi_doc, '*');
      len1 := xmldom.getlength (nl);

      -- loop through elements
      FOR j IN 0 .. len1 - 1
      LOOP
         n := xmldom.item (nl, j);
         e := xmldom.makeelement (n);
--      DBMS_OUTPUT.put_line (xmldom.gettagname (e) || ':');

         -- get all attributes of element
         nnm := xmldom.getattributes (n);

         IF (xmldom.isnull (nnm) = FALSE)
         THEN
            len2 := xmldom.getlength (nnm);

            -- loop through attributes
            FOR i IN 0 .. len2 - 1
            LOOP
               n := xmldom.item (nnm, i);
               attrname := xmldom.getnodename (n);
               attrval := xmldom.getnodevalue (n);

               IF attrname = 'name'
               THEN
                  g_tab_ust (j).c_theme_name := attrval;
               ELSIF attrname = 'min_scale'
               THEN
                  g_tab_ust (j).c_theme_min_scale := attrval;
               ELSIF attrname = 'max_scale'
               THEN
                  g_tab_ust (j).c_theme_max_scale := attrval;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      --
      nm_debug.proc_end (g_package_name, 'get_ust_attributes');
   --
   END get_ust_attributes;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_ustd_attributes (pi_doc xmldom.domdocument, pi_index NUMBER)
   IS
      nl         xmldom.domnodelist;
      len1       NUMBER;
      len2       NUMBER;
      n          xmldom.domnode;
      e          xmldom.domelement;
      nnm        xmldom.domnamednodemap;
      attrname   VARCHAR2 (100);
      attrval    VARCHAR2 (100);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_ustd_attributes');
    --
--    Nm_Debug.debug_on;
      nm_debug.DEBUG ('# in get_ustd_attributes ');
      -- get all elements
      nl := xmldom.getelementsbytagname (pi_doc, '*');
      len1 := xmldom.getlength (nl);

      -- loop through elements
      FOR j IN 0 .. len1 - 1
      LOOP
         n := xmldom.item (nl, j);
         e := xmldom.makeelement (n);
--      DBMS_OUTPUT.put_line (xmldom.gettagname (e) || ':');
         nm_debug.DEBUG ('## Tag Name  = ' || xmldom.gettagname (e));
         nm_debug.DEBUG ('## loop indx (j) = ' || j);
         -- get all attributes of element
         nnm := xmldom.getattributes (n);

         IF (xmldom.isnull (nnm) = FALSE)
         THEN
            len2 := xmldom.getlength (nnm);

            -- loop through attributes
            FOR i IN 0 .. len2 - 1
            LOOP
--   <?xml version="1.0" standalone="yes"?>
-- <styling_rules >
--   <rule column="*" >
--     <features style="IAMS:M.CRASH">  </features>
--     <label column="ALO_ACC_ID" style="IAMS:T.STREET NAME"> 0 </label>
--   </rule>
-- </styling_rules>
               n := xmldom.item (nnm, i);
               attrname := xmldom.getnodename (n);
               attrval := xmldom.getnodevalue (n);
               nm_debug.DEBUG (   '### Attribute =  '
                               || attrname
                               || ' - val = '
                               || attrval
                              );
               nm_debug.DEBUG ('### loop indx (i) =  ' || i);

               IF xmldom.gettagname (e) = 'rule'
               THEN
                  IF attrname = 'column'
                  THEN
                     g_tab_ustd (i).c_rule_column := attrval;
                  END IF;
               ELSIF xmldom.gettagname (e) = 'features'
               THEN
                  IF attrname = 'style'
                  THEN
                     g_tab_ustd (i).c_feature_style := attrval;
                  END IF;
               ELSIF xmldom.gettagname (e) = 'label'
               THEN
                  IF attrname = 'column'
                  THEN
                     g_tab_ustd (i).c_label_column := attrval;
                  END IF;

                  IF attrname = 'style'
                  THEN
                     g_tab_ustd (i).c_label_style := attrval;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      --
      nm_debug.proc_end (g_package_name, 'get_ustd_attributes');
   --
   END get_ustd_attributes;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_msv_usm (
      pi_table_name   IN       VARCHAR2
    , po_results      IN OUT   tab_msv_maps
   )
   IS
      --
      l_domdoc   xmldom.domdocument;
      l_clob     CLOB;
      l_index    NUMBER;

      CURSOR c_maps
      IS
         SELECT *
           FROM user_sdo_maps
          WHERE NAME = 'ADE2';
   --
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_msv_usm');
      --
      g_tab_usm.DELETE;

      --
      FOR i IN c_maps
      LOOP
         l_index := g_tab_usm.COUNT + 1;
         l_clob := i.definition;
         g_tab_usm (l_index).c_map_name := i.NAME;
         g_tab_usm (l_index).c_map_description := i.description;
         --
         l_domdoc := hig_hd_insert.read_xml_clob (p_clob => l_clob);
         get_usm_attributes (pi_doc => l_domdoc, pi_index => NULL);
      END LOOP;

      --
      po_results := g_tab_usm;
      --
      nm_debug.proc_end (g_package_name, 'get_msv_usm');
   --
   END get_msv_usm;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_msv_ust (
      pi_map_name   IN       VARCHAR2
    , po_results    IN OUT   tab_msv_themes
   )
   IS
      --
      l_domdoc   xmldom.domdocument;
      l_clob     CLOB;
      l_index    NUMBER;

      CURSOR c_maps
      IS
         SELECT definition
           FROM user_sdo_maps
          WHERE NAME = pi_map_name;
   --
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_msv_ust');
      --
      g_tab_ust.DELETE;

      --
      FOR i IN c_maps
      LOOP
         l_index := g_tab_ust.COUNT + 1;
         l_clob := i.definition;
         g_tab_ust (l_index).c_map_name := pi_map_name;
         --
         l_domdoc := hig_hd_insert.read_xml_clob (p_clob => l_clob);
         get_ust_attributes (pi_doc => l_domdoc, pi_index => l_index);
      END LOOP;

      --
      po_results := g_tab_ust;
      --
      nm_debug.proc_end (g_package_name, 'get_msv_ust');
   --
   END get_msv_ust;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_msv_ustd (
      pi_theme_name   IN       VARCHAR2
    , po_results      IN OUT   tab_msv_theme_details
   )
   IS
      --
      l_domdoc   xmldom.domdocument;
      l_clob     CLOB;
      l_index    NUMBER;

      CURSOR c_themes
      IS
         SELECT *
           FROM user_sdo_themes
          WHERE NAME = pi_theme_name;
   --
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_msv_ustd');
      --
      g_tab_ustd.DELETE;
      --
      FOR i IN c_themes
      LOOP
         l_index := g_tab_ustd.COUNT + 1;
         l_clob := i.styling_rules;
         g_tab_ustd (l_index).c_theme_name := pi_theme_name;
         g_tab_ustd (l_index).c_base_table := i.base_table;
         g_tab_ustd (l_index).c_geometry_column := i.geometry_column;
         --
         l_domdoc := hig_hd_insert.read_xml_clob (p_clob => l_clob);
         get_ustd_attributes (pi_doc => l_domdoc, pi_index => l_index);
      END LOOP;

      --
      po_results := g_tab_ustd;
      --
      nm_debug.proc_end (g_package_name, 'get_msv_ustd');
   --
   END get_msv_ustd;

--
-----------------------------------------------------------------------------
-- user_sdo_themes
   PROCEDURE insert_usm (
      pi_map_name         IN   VARCHAR2
    , pi_description      IN   VARCHAR2
    , pi_tab_theme_name   IN   nm3type.tab_varchar80
    , pi_tab_min_scale    IN   nm3type.tab_varchar80
    , pi_tab_max_scale    IN   nm3type.tab_varchar80
   )
   IS
      e_no_map_name        EXCEPTION;
      e_no_styling_rules   EXCEPTION;
      l_xml_string         user_sdo_maps.definition%TYPE;
      l_rec_usm            user_sdo_maps%ROWTYPE;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'insert_usm');

      --
      IF pi_map_name IS NULL
      THEN
         RAISE e_no_map_name;
      END IF;

      IF pi_tab_theme_name.COUNT < 1
      THEN
         RAISE e_no_styling_rules;
      END IF;

      --
      l_xml_string := g_xml_header || lf || '<map_definition>' || lf;

      --
      FOR i IN pi_tab_theme_name.FIRST .. pi_tab_theme_name.LAST
      LOOP
         l_xml_string :=
            l_xml_string || '  <theme name="' || pi_tab_theme_name (i)
            || '" ';

         IF pi_tab_min_scale (i) IS NOT NULL
         THEN
            l_xml_string :=
                 l_xml_string || 'min_scale="' || pi_tab_min_scale (i)
                 || '" ';
         END IF;

         IF pi_tab_max_scale (i) IS NOT NULL
         THEN
            l_xml_string :=
                 l_xml_string || 'max_scale="' || pi_tab_max_scale (i)
                 || '" ';
         END IF;

         l_xml_string := l_xml_string || '/>' || lf;
      END LOOP;

      --
      l_xml_string := l_xml_string || '</map_definition>';
      --
      l_rec_usm.NAME := pi_map_name;
      l_rec_usm.description := pi_description;
      l_rec_usm.definition := l_xml_string;

      --
      BEGIN
         INSERT INTO user_sdo_maps
              VALUES l_rec_usm;
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
      END;

      --
      nm_debug.proc_end (g_package_name, 'insert_usm');
   --
   EXCEPTION
      WHEN e_no_map_name
      THEN
         raise_application_error (-20401, 'Please specify a Map Name');
      WHEN e_no_styling_rules
      THEN
         raise_application_error (-20402
                                , 'Please specify at least one Theme');
      WHEN OTHERS
      THEN
         RAISE;
   END insert_usm;

--
-----------------------------------------------------------------------------
--
   PROCEDURE insert_ust
                        --user_sdo_themes
   (
      pi_theme_name          IN   VARCHAR2
    , pi_description         IN   VARCHAR2
    , pi_base_table          IN   VARCHAR2
    , pi_geometry_column     IN   VARCHAR2
    , pi_tab_rule_column     IN   nm3type.tab_varchar80
    , pi_tab_feature_style   IN   nm3type.tab_varchar80
    , pi_tab_label_column    IN   nm3type.tab_varchar80
    , pi_tab_label_style     IN   nm3type.tab_varchar80
   )
   IS
      --
      e_no_theme_name        EXCEPTION;
      e_no_base_table        EXCEPTION;
      e_no_geom_column       EXCEPTION;
      e_base_tab_not_found   EXCEPTION;
      e_no_styles            EXCEPTION;
      l_xml_string           user_sdo_themes.styling_rules%TYPE;
  --
-- <styling_rules >
--   <rule column="*" >
--     <features style="IAMS:M.CRASH">  </features>
--     <label column="ALO_ACC_ID" style="IAMS:T.STREET NAME"> 0 </label>
--   </rule>
--   <rule >
--     <features style="IAMS:C.BLACK">  </features>
--     <label column="ALO_ACC_ID" style="IAMS:T.CITY NAME"> 0 </label>
--   </rule>
-- </styling_rules>
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'insert_ust');

      --
      IF pi_theme_name IS NULL
      THEN
         RAISE e_no_theme_name;
      END IF;

      IF pi_base_table IS NULL
      THEN
         RAISE e_no_base_table;
      END IF;

      IF pi_geometry_column IS NULL
      THEN
         RAISE e_no_geom_column;
      END IF;

      --
      IF NOT nm3ddl.does_object_exist (pi_base_table)
      THEN
         RAISE e_base_tab_not_found;
      END IF;

      --
      IF pi_tab_rule_column.COUNT < 1
      THEN
         RAISE e_no_styles;
      END IF;

      --
      l_xml_string := g_xml_header || lf || '<styling_rules >' || lf;
  --
--    l_xml_string
  --
      nm_debug.proc_end (g_package_name, 'insert_ust');
   --
   EXCEPTION
      WHEN e_no_theme_name
      THEN
         raise_application_error (-20501, 'Please define a theme name');
      WHEN e_no_base_table
      THEN
         raise_application_error (-20502, 'Please define a feature table');
      WHEN e_no_geom_column
      THEN
         raise_application_error (-20503, 'Please define a feature column');
      WHEN e_base_tab_not_found
      THEN
         raise_application_error
                             (-20504
                            ,    pi_base_table
                              || ' does not exists or user does not have access'
                             );
      WHEN e_no_styles
      THEN
         raise_application_error (-20505
                                , 'Please define at least one styling rule'
                                 );
      WHEN OTHERS
      THEN
         RAISE;
   END insert_ust;

--
-----------------------------------------------------------------------------
--
  /**********************************************
     END OF MAPVIEW CODE
  **********************************************/
--
-----------------------------------------------------------------------------
--
   PROCEDURE make_layer_where (
      pi_base_theme     IN   nm_themes_all.nth_theme_id%TYPE
    , pi_where_clause   IN   nm_themes_all.nth_where%TYPE
    , pi_view_name      IN   nm_themes_all.nth_table_name%TYPE
   )
   IS
      l_rec_nth_base   nm_themes_all%ROWTYPE;
      l_rec_nth_new    nm_themes_all%ROWTYPE;
      l_view_sql       VARCHAR2 (1000);
      l_where          VARCHAR2 (5000);

      --
      TYPE tab_nthr IS TABLE OF nm_theme_roles%ROWTYPE
         INDEX BY BINARY_INTEGER;

      TYPE tab_ntg IS TABLE OF nm_theme_gtypes%ROWTYPE
         INDEX BY BINARY_INTEGER;
   --
      l_tab_nthr               tab_nthr;
      l_tab_ntg                tab_ntg;
      l_rec_usgm               user_sdo_geom_metadata%ROWTYPE;
      l_nth_base_table_theme   nm_themes_all.nth_base_table_theme%TYPE;
   --
   BEGIN
--      nm_debug.debug_on;
      nm_debug.debug('Where clause = '||pi_where_clause);
      --
      l_rec_nth_base := nm3get.get_nth (pi_nth_theme_id => pi_base_theme);
      --
      l_where := LTRIM (pi_where_clause);
      --
      IF SUBSTR(l_where,1,5) = nm3type.c_where
      THEN
        l_where := replace(l_where,nm3type.c_where,' ');
      ELSIF SUBSTR(l_where,1,5) = nm3type.c_and_operator
      THEN
        l_where := replace(l_where,nm3type.c_and_operator,' ');
      END IF;
      --
      --nm_debug.debug('Processed Where clause = '||l_where);
      --
      l_view_sql :=
              'CREATE OR REPLACE FORCE VIEW '
           || pi_view_name
           || lf
           || ' AS '
           || lf
           || ' SELECT a.* '
           || lf
           || '   FROM '
           || l_rec_nth_base.nth_feature_table
           || ' a '
           || lf
           || ' WHERE '||l_where;--replace(l_where,nm3type.c_and_operator,' ');
--      nm_debug.debug(l_view_sql);
      --
      EXECUTE IMMEDIATE l_view_sql;

      --
      l_rec_nth_new                       := l_rec_nth_base;
      l_rec_nth_new.nth_feature_table     := pi_view_name;
      l_rec_nth_new.nth_theme_name        := pi_view_name;
      l_rec_nth_new.nth_where             := pi_where_clause;
      l_rec_nth_new.nth_base_table_theme  := nvl(l_rec_nth_base.nth_base_table_theme
                                                ,pi_base_theme);
      l_rec_nth_new.nth_theme_id          := nm3seq.next_nth_theme_id_seq;
      --
      -- Create New theme
      nm3ins.ins_nth (l_rec_nth_new);

      --
      BEGIN
         SELECT *
         BULK COLLECT INTO l_tab_nthr
           FROM nm_theme_roles
          WHERE nthr_theme_id = pi_base_theme;

         --
         FOR i IN 1 .. l_tab_nthr.COUNT
         LOOP
            -- Copy theme roles from base theme
            INSERT INTO nm_theme_roles
                 VALUES (l_rec_nth_new.nth_theme_id
                       , l_tab_nthr (i).nthr_role, l_tab_nthr (i).nthr_mode);
         END LOOP;
      --
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --
      BEGIN
         SELECT *
         BULK COLLECT INTO l_tab_ntg
           FROM nm_theme_gtypes
          WHERE ntg_theme_id = pi_base_theme;

         --
         FOR i IN 1 .. l_tab_ntg.COUNT
         LOOP
            -- Copy gtypes from base theme
            INSERT INTO nm_theme_gtypes
                 VALUES (l_rec_nth_new.nth_theme_id, l_tab_ntg (i).ntg_gtype
                       , l_tab_ntg (i).ntg_seq_no, l_tab_ntg (i).ntg_xml_url);
         END LOOP;
      --
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --
      BEGIN
         SELECT *
           INTO l_rec_usgm
           FROM user_sdo_geom_metadata
          WHERE table_name = l_rec_nth_base.nth_feature_table
            AND column_name = l_rec_nth_base.nth_feature_shape_column;

         --
         l_rec_usgm.table_name := l_rec_nth_new.nth_feature_table;
         --
           -- Clone User_SDO_Geom_metadata from base theme
         nm3sdo.ins_usgm (l_rec_usgm);
      --
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --
      --------------------------------------------------------------
      -- Register layer in SDE if appropriate
      --------------------------------------------------------------
      --
      IF Hig.get_sysopt ('REGSDELAY') = 'Y'
      THEN
         EXECUTE IMMEDIATE
           ( ' begin  '
           ||'    nm3sde.register_sde_layer '||
                   '( p_theme_id => '||TO_CHAR( l_rec_nth_new.nth_theme_id )||');'
           ||' end;'
           );
      END IF;

      --
      -- Populate link tables for Assets, Groups
      is_an_asset_theme (pi_base_theme, l_rec_nth_new.nth_theme_id);
      is_an_area_theme  (pi_base_theme, l_rec_nth_new.nth_theme_id);
      is_a_linear_theme (pi_base_theme, l_rec_nth_new.nth_theme_id);
   --
   END make_layer_where;

--
-----------------------------------------------------------------------------
--
   FUNCTION parse_where_clause (
      pi_base_theme     IN   nm_themes_all.nth_theme_id%TYPE
    , pi_where_clause   IN   nm_themes_all.nth_where%TYPE
   )
      RETURN BOOLEAN
   IS
      l_rec_nth_base   nm_themes_all%ROWTYPE;
      l_sql            VARCHAR2 (10000);
      l_where          VARCHAR2 (5000);
   BEGIN
   --
      l_rec_nth_base := nm3get.get_nth (pi_nth_theme_id => pi_base_theme);
      --
      l_where := LTRIM (pi_where_clause);
      --
      IF SUBSTR(l_where,1,5) = nm3type.c_where
      THEN
        l_where := replace(l_where,nm3type.c_where,' ');
      ELSIF SUBSTR(l_where,1,5) = nm3type.c_and_operator
      THEN
        l_where := replace(l_where,nm3type.c_and_operator,' ');
      END IF;
      --
        l_sql :=
              ' SELECT a.* '
           || lf
           || '   FROM '
           || l_rec_nth_base.nth_feature_table
           || ' a '
           || lf
           || ' WHERE '||(l_where);

--      nm_debug.DEBUG (l_sql);
      --
      IF nm3flx.is_select_statement_valid (l_sql)
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
  --
   END parse_where_clause;

--
-----------------------------------------------------------------------------
--
   PROCEDURE drop_theme (pi_table_name IN nm_themes_all.nth_table_name%TYPE)
   IS
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'drop_theme');

      --
      BEGIN
         -- delete THEME
         EXECUTE IMMEDIATE    'DELETE nm_themes_all'
                           || lf
                           || ' WHERE nth_table_name = '
                           || nm3flx.STRING (pi_table_name);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      --
      nm_debug.proc_end (g_package_name, 'drop_theme');
   --
   END drop_theme;

--
-----------------------------------------------------------------------------
--
   PROCEDURE drop_usgm (
      pi_feature_table    IN   user_tables.table_name%TYPE
    , pi_feature_column   IN   user_tab_cols.column_name%TYPE
   )
   IS
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'drop_usgm');

      --
      BEGIN
         -- delete USGM metadata
         EXECUTE IMMEDIATE    'DELETE user_sdo_geom_metadata'
                           || lf
                           || ' WHERE table_name = '
                           || nm3flx.STRING (pi_feature_table)
                           || lf
                           || '   AND column_name = '
                           || nm3flx.STRING (pi_feature_column);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      --
      nm_debug.proc_end (g_package_name, 'drop_usgm');
   --
   END drop_usgm;

--
-----------------------------------------------------------------------------
--
   PROCEDURE drop_sde_layer (
      pi_feature_table    IN   user_tables.table_name%TYPE
    , pi_feature_column   IN   user_tab_cols.column_name%TYPE
    , pi_owner            IN   VARCHAR2 DEFAULT NULL
   )
   IS
      l_owner   VARCHAR2 (30)    := NVL (pi_owner, hig.get_application_owner);
      l_sql     nm3type.max_varchar2;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'drop_sde_layer');

      --
      BEGIN
         -- drop SDE layers (if necessary)
         l_sql :=
               'DECLARE '
            || lf
            || ' CURSOR get_layer(cp_table_name  IN varchar2'
            || lf
            || '                , cp_column_name IN varchar2'
            || lf
            || '                , cp_owner       IN varchar2)'
            || lf
            || ' IS '
            || lf
            || '   SELECT layer_id FROM sde.layers'
            || lf
            || '    WHERE table_name = cp_table_name AND spatial_column = cp_column_name'
            || lf
            || '       AND owner = cp_owner; '
            || lf
            || '  l_layer_id NUMBER;'
            || lf
            || 'BEGIN'
            || lf
            || '  OPEN get_layer('
            || nm3flx.STRING (pi_feature_table)
            || ','
            || nm3flx.STRING (pi_feature_column)
            || ','
            || nm3flx.STRING (l_owner)
            || ');'
            || lf
            || ' FETCH get_layer INTO l_layer_id; '
            || lf
            || ' CLOSE get_layer; '
            || lf
            || ' IF l_layer_id IS NOT NULL'
            || lf
            || '  THEN'
            || lf
            || '   nm3sde.drop_layer(l_layer_id);'
            || lf
            || ' END IF;'
            || lf
            || 'END;';

--      nm_debug.debug(l_sql);
         EXECUTE IMMEDIATE l_sql;
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
      END;

      --
      nm_debug.proc_end (g_package_name, 'drop_sde_layer');
   --
   END drop_sde_layer;

--
-----------------------------------------------------------------------------
--
/*
   **************************
     NET RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
   FUNCTION does_group_layer_exist (
      pi_group_type   IN   nm_group_types.ngt_group_type%TYPE
   )
      RETURN BOOLEAN
   IS
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'does_node_layer_exist');
      --
      NULL;
      --
      nm_debug.proc_start (g_package_name, 'does_node_layer_exist');
   --
   END does_group_layer_exist;

--
-----------------------------------------------------------------------------
--
   FUNCTION how_many_elements (
      pi_nt_type      IN   nm_group_types.ngt_nt_type%TYPE
    , pi_group_type   IN   nm_group_types.ngt_group_type%TYPE
   )
      RETURN NUMBER
   IS
      l_sql      nm3type.max_varchar2;
      l_result   NUMBER;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'does_node_layer_exist');
      --
      l_sql :=
            'BEGIN '
         || lf
         || ' SELECT count(*) INTO :l FROM nm_elements '
         || lf
         || '  WHERE ne_nt_type = '
         || nm3flx.STRING (pi_nt_type);

      IF pi_group_type IS NOT NULL
      THEN
         l_sql :=
               l_sql
            || lf
            || ' AND ne_gty_group_type = '
            || nm3flx.STRING (pi_group_type);
      END IF;

      l_sql := l_sql || lf || ' ; END ;';

  --
--    nm_debug.debug_on;
--    nm_debug.debug(l_sql);
  --
      EXECUTE IMMEDIATE l_sql
                  USING OUT l_result;

      --
      RETURN l_result;
      --
      nm_debug.proc_start (g_package_name, 'does_node_layer_exist');
   --
   EXCEPTION
      WHEN OTHERS
--   THEN RETURN 0;
      THEN
         RAISE;
   END how_many_elements;

--
-----------------------------------------------------------------------------
--
   FUNCTION does_node_layer_exist (
      pi_node_type   IN   nm_node_types.nnt_type%TYPE
   )
      RETURN BOOLEAN
   IS
      CURSOR c1 (cp_table_name IN VARCHAR2)
      IS
         SELECT 1
           FROM nm_themes_all
          WHERE nth_table_name = cp_table_name
            AND EXISTS (
                   SELECT 1
                     FROM user_sdo_geom_metadata
                    WHERE table_name = cp_table_name
                      AND column_name = 'GEOLOC'
                      AND table_name = nth_table_name);

      l_dummy   PLS_INTEGER;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'does_node_layer_exist');

      --
      OPEN c1 ('V_NM_NO_' || UPPER (pi_node_type) || '_SDO');

      FETCH c1
       INTO l_dummy;

      CLOSE c1;

      IF l_dummy = 1
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;

      --
      nm_debug.proc_end (g_package_name, 'does_node_layer_exist');
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END does_node_layer_exist;

--
-----------------------------------------------------------------------------
--
   PROCEDURE drop_node_layer (pi_node_type IN nm_node_types.nnt_type%TYPE)
   IS
      l_view_name     user_views.view_name%TYPE
                               := 'V_NM_NO_' || UPPER (pi_node_type)
                                  || '_SDO';
      l_column_name   user_tab_columns.column_name%TYPE   := 'GEOLOC';
      l_rec_nth       nm_themes_all%ROWTYPE;
      l_sql           nm3type.max_varchar2;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'drop_node_layer');

      --
      BEGIN
         -- drop view
         EXECUTE IMMEDIATE 'DROP VIEW ' || l_view_name;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      --
      BEGIN
         -- delete USGM metadata
         drop_usgm (l_view_name, l_column_name);
      END;

      --
      BEGIN
         -- drop SDE layers (if necessary)
         drop_sde_layer (l_view_name, l_column_name);
      END;

      --
      BEGIN
         -- delete THEME
         drop_theme (l_view_name);
      END;

      --
      nm_debug.proc_end (g_package_name, 'drop_node_layer');
   --
   END drop_node_layer;

--
-----------------------------------------------------------------------------
--
   PROCEDURE create_node_layer (pi_node_type IN nm_node_types.nnt_type%TYPE)
   IS
      l_dummy   PLS_INTEGER;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_node_layer');
      --
      l_dummy := nm3sdm.create_node_metadata (pi_node_type);
      --
      nm_debug.proc_end (g_package_name, 'create_node_layer');
   --
   END create_node_layer;

--
-----------------------------------------------------------------------------
--
/*
   **************************
     ASSET RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
-- Used to disable create/drop layer buttons in gis0020
   FUNCTION does_asset_layer_exist (
      pi_asset_type   IN   nm_inv_types.nit_inv_type%TYPE
   )
      RETURN BOOLEAN
   IS
      CURSOR c1
      IS
         SELECT 1
           FROM nm_inv_themes
          WHERE nith_nit_id = pi_asset_type AND ROWNUM = 1;

      l_dummy   PLS_INTEGER;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'does_asset_layer_exist');

      --
      OPEN c1;

      FETCH c1
       INTO l_dummy;

      CLOSE c1;

      IF l_dummy = 1
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;

      --
      nm_debug.proc_end (g_package_name, 'does_asset_layer_exist');
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END does_asset_layer_exist;

--
-----------------------------------------------------------------------------
--
-- used to return a count for a given Asset type - displayed in gis0020
   FUNCTION how_many_assets (pi_asset_type IN nm_inv_types.nit_inv_type%TYPE)
      RETURN NUMBER
   IS
      l_count            NUMBER                 := 0;
      l_rec_nit          nm_inv_types%ROWTYPE
                                            := nm3get.get_nit (pi_asset_type);
      b_external_asset   BOOLEAN      := l_rec_nit.nit_table_name IS NOT NULL;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'how_many_assets');

      --
      IF b_external_asset
      -- Foreign Table
      THEN
         BEGIN
            EXECUTE IMMEDIATE    'BEGIN '
                              || 'SELECT count(*) count INTO :l_count '
                              || '  FROM '
                              || l_rec_nit.nit_table_name
                              || ';'
                              || 'END;'
                        USING OUT l_count;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN 0;
            WHEN OTHERS
            THEN
               RAISE;
         END;
      ELSE
         -- Normal NM3 Asset
         SELECT COUNT (*)
           INTO l_count
           FROM nm_inv_items
          WHERE iit_inv_type = pi_asset_type;
      END IF;

      --
      RETURN l_count;
      --
      nm_debug.proc_end (g_package_name, 'how_many_assets');
   --
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
      WHEN OTHERS
      THEN
         RAISE;
   END how_many_assets;

--
-----------------------------------------------------------------------------
--
-- returns network details related to a given asset type
   PROCEDURE get_networks_for_asset_type (
      pi_asset_type   IN       nm_inv_types.nit_inv_type%TYPE
    , po_results      IN OUT   tab_nwinv
   )
   IS
      l_results   tab_nwinv;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_networks_for_asset_type');

      --
      SELECT nt_type
           , nt_descr
           , un_unit_name
      BULK COLLECT INTO l_results
        FROM nm_inv_nw, nm_types, nm_units
       WHERE nin_nit_inv_code = pi_asset_type
         AND nin_nw_type = nt_type
         AND nt_length_unit = un_unit_id;

      po_results := l_results;
      --
      nm_debug.proc_end (g_package_name, 'get_networks_for_asset_type');
   --
   END;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_asset_type (
      pi_asset_type   IN       nm_inv_types.nit_inv_type%TYPE
    , po_results      IN OUT   tab_nit
   )
   IS
      l_results   tab_nit;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_asset_type');

      --
      SELECT nit_inv_type
           , nit_pnt_or_cont
           , nit_x_sect_allow_flag
           , nit_elec_drain_carr
           , nit_contiguous
           , nit_replaceable
           , nit_exclusive
           , nit_category
           , nit_descr
           , nit_linear
           , nit_use_xy
           , nit_multiple_allowed
           , nit_end_loc_only
           , nit_screen_seq
           , nit_view_name
           , nit_start_date
           , nit_end_date
           , nit_short_descr
           , nit_flex_item_flag
           , nit_table_name
           , nit_lr_ne_column_name
           , nit_lr_st_chain
           , nit_lr_end_chain
           , nit_admin_type
           , nit_icon_name
           , nit_top
           , nit_foreign_pk_column
           , nit_update_allowed
           , nit_notes
      BULK COLLECT INTO l_results
        FROM nm_inv_types
       WHERE nit_inv_type = pi_asset_type;

      --
      po_results := l_results;
      --
      nm_debug.proc_end (g_package_name, 'get_asset_type');
   --
   END get_asset_type;

--
-----------------------------------------------------------------------------
--
/*
   **************************
     ACC RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
-- wrapper for calling mai.make_defect_spatial_layer
   PROCEDURE create_acc_layer (
      pi_theme_name     IN   nm_themes_all.nth_theme_name%TYPE
    , pi_asset_type     IN   nm_inv_types.nit_inv_type%TYPE
    , pi_asset_descr    IN   nm_inv_types.nit_descr%TYPE
    , pi_x_column       IN   user_tab_columns.column_name%TYPE
    , pi_y_column       IN   user_tab_columns.column_name%TYPE
    , pi_lr_ne_column   IN   user_tab_columns.column_name%TYPE
    , pi_lr_st_chain    IN   user_tab_columns.column_name%TYPE
   )
   IS
      l_sql   VARCHAR2 (10000);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_acc_layer');

      --
      IF hig.is_product_licensed (nm3type.c_acc)
      THEN
         --
         IF pi_x_column IS NOT NULL AND pi_y_column IS NOT NULL
         THEN
            l_sql :=
                  ' BEGIN '
               || lf
               || 'acc_sdo_util.make_base_sdo_layer'
               || lf
               || '( pi_theme_name    => :pi_theme_name'
               || lf
               || ', pi_asset_type    => :pi_asset_type'
               || lf
               || ', pi_asset_descr   => :pi_asset_descr'
               || lf
               || ', pi_x_column      => :pi_x_column'
               || lf
               || ', pi_y_column      => :pi_y_column'
               || lf
               || ', pi_lr_ne_column  => NULL'
               || lf
               || ', pi_lr_st_chain   => NULL'
               || lf
               || ' );'
               || lf
               || ' END;';
--        nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_theme_name
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_x_column
                            , pi_y_column;
         ELSE
            l_sql :=
                  ' BEGIN '
               || lf
               || 'acc_sdo_util.make_base_sdo_layer'
               || lf
               || '( pi_theme_name    => :pi_theme_name'
               || lf
               || ', pi_asset_type    => :pi_asset_type'
               || lf
               || ', pi_asset_descr   => :pi_asset_descr'
               || lf
               || ', pi_x_column      => NULL'
               || lf
               || ', pi_y_column      => NULL'
               || lf
               || ', pi_lr_ne_column  => :pi_lr_ne_column'
               || lf
               || ', pi_lr_st_chain   => :pi_lr_st_chain'
               || lf
               || ' );'
               || lf
               || ' END;';
            --       nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_theme_name
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_lr_ne_column
                            , pi_lr_st_chain;
         END IF;
--        nm_debug.debug_on;
--       nm_debug.debug(l_sql);
      END IF;

      --
      nm_debug.proc_end (g_package_name, 'create_acc_layer');
   --
   END create_acc_layer;

--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
/*
   **************************
     MAI RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
-- wrapper for calling mai.make_defect_spatial_layer
   PROCEDURE create_defect_layer (
      pi_theme_name      IN   nm_themes_all.nth_theme_name%TYPE
    , pi_asset_type      IN   nm_inv_types.nit_inv_type%TYPE
    , pi_asset_descr     IN   nm_inv_types.nit_descr%TYPE
    , pi_x_column        IN   user_tab_columns.column_name%TYPE
    , pi_y_column        IN   user_tab_columns.column_name%TYPE
    , pi_lr_ne_column    IN   user_tab_columns.column_name%TYPE
    , pi_lr_st_chain     IN   user_tab_columns.column_name%TYPE
    , pi_snapping_trig   IN   VARCHAR2 DEFAULT 'TRUE'
   )
   IS
      l_sql   VARCHAR2 (10000);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_defect_layer');

      --
      IF hig.is_product_licensed (nm3type.c_mai)
      THEN
         --
         IF pi_x_column IS NOT NULL AND pi_y_column IS NOT NULL
         THEN
            l_sql :=
                  ' BEGIN '
               || lf
               || 'mai_sdo_util.make_base_sdo_layer'
               || lf
               || '( pi_theme_name    => :pi_theme_name'
               || lf
               || ', pi_asset_type    => :pi_asset_type'
               || lf
               || ', pi_asset_descr   => :pi_asset_descr'
               || lf
               || ', pi_x_column      => :pi_x_column'
               || lf
               || ', pi_y_column      => :pi_y_column'
               || lf
               || ', pi_lr_ne_column  => NULL'
               || lf
               || ', pi_lr_st_chain   => NULL'
               || lf
               || ', pi_snapping_trig => :pi_snapping_trig'
               || lf
               || ' );'
               || lf
               || ' END;';
--        nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_theme_name
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_x_column
                            , pi_y_column
                            , pi_snapping_trig;
         ELSE
            l_sql :=
                  ' BEGIN '
               || lf
               || 'mai_sdo_util.make_base_sdo_layer'
               || lf
               || '( pi_theme_name    => :pi_theme_name'
               || lf
               || ', pi_asset_type    => :pi_asset_type'
               || lf
               || ', pi_asset_descr   => :pi_asset_descr'
               || lf
               || ', pi_x_column      => NULL'
               || lf
               || ', pi_y_column      => NULL'
               || lf
               || ', pi_lr_ne_column  => :pi_lr_ne_column'
               || lf
               || ', pi_lr_st_chain   => :pi_lr_st_chain'
               || lf
               || ', pi_snapping_trig => :pi_snapping_trig'
               || lf
               || ' );'
               || lf
               || ' END;';
            --       nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_theme_name
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_lr_ne_column
                            , pi_lr_st_chain
                            , pi_snapping_trig;
         END IF;
--        nm_debug.debug_on;
--       nm_debug.debug(l_sql);
      END IF;

      --
      nm_debug.proc_end (g_package_name, 'create_defect_layer');
   --
   END create_defect_layer;

--
-----------------------------------------------------------------------------
--
/*
   **************************
     ENQ RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
   PROCEDURE create_enq_layer (
      pi_theme_name      IN   nm_themes_all.nth_theme_name%TYPE
    , pi_asset_type      IN   nm_inv_types.nit_inv_type%TYPE
    , pi_asset_descr     IN   nm_inv_types.nit_descr%TYPE
    , pi_x_column        IN   user_tab_columns.column_name%TYPE
    , pi_y_column        IN   user_tab_columns.column_name%TYPE
    , pi_lr_ne_column    IN   user_tab_columns.column_name%TYPE
    , pi_lr_st_chain     IN   user_tab_columns.column_name%TYPE
    , pi_snapping_trig   IN   VARCHAR2 DEFAULT 'TRUE'
   )
   IS
      l_sql   VARCHAR2 (10000);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_enq_layer');

      --  hig_products
      IF hig.is_product_licensed ('ENQ')
      THEN
         --
         IF pi_x_column IS NOT NULL AND pi_y_column IS NOT NULL
         THEN
            l_sql :=
                  ' BEGIN '
               || lf
               || 'enq_sdo_util.make_base_sdo_layer'
               || lf
               || '( pi_theme_name    => :pi_theme_name'
               || lf
               || ', pi_asset_type    => :pi_asset_type'
               || lf
               || ', pi_asset_descr   => :pi_asset_descr'
               || lf
               || ', pi_x_column      => :pi_x_column'
               || lf
               || ', pi_y_column      => :pi_y_column'
               || lf
               || ', pi_lr_ne_column  => NULL'
               || lf
               || ', pi_lr_st_chain   => NULL'
               || lf
               || ', pi_snapping_trig => :pi_snapping_trig'
               || lf
               || ' );'
               || lf
               || ' END;';
--            nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_theme_name
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_x_column
                            , pi_y_column
                            , (pi_snapping_trig);
         END IF;
      END IF;
   END create_enq_layer;

--
-----------------------------------------------------------------------------
--
   PROCEDURE drop_enq_layer (
      pi_nth_theme_id   IN   nm_themes_all.nth_theme_id%TYPE
   )
   IS
      l_rec_nth   nm_themes_all%ROWTYPE   := nm3get.get_nth (pi_nth_theme_id);
      l_sql       nm3type.max_varchar2;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'drop_enq_layer');

      --
      BEGIN
         -- delete USGM metadata
         drop_usgm (l_rec_nth.nth_feature_table
                  , l_rec_nth.nth_feature_shape_column
                   );
      END;

      --
      BEGIN
         -- drop SDE layers (if necessary)
         drop_sde_layer (l_rec_nth.nth_feature_table
                       , l_rec_nth.nth_feature_shape_column
                        );
      END;

      --
      BEGIN
         -- delete THEME
         nm3del.del_nth (pi_nth_theme_id => l_rec_nth.nth_theme_id);
      END;

      --
      nm_debug.proc_end (g_package_name, 'drop_enq_layer');
   --
   END drop_enq_layer;

--
-----------------------------------------------------------------------------
--
/*
   **************************
     CLM RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
   PROCEDURE create_clm_layer (
      pi_theme_name      IN   nm_themes_all.nth_theme_name%TYPE
    , pi_asset_type      IN   nm_inv_types.nit_inv_type%TYPE
    , pi_asset_descr     IN   nm_inv_types.nit_descr%TYPE
    , pi_x_column        IN   user_tab_columns.column_name%TYPE
    , pi_y_column        IN   user_tab_columns.column_name%TYPE
    , pi_lr_ne_column    IN   user_tab_columns.column_name%TYPE
    , pi_lr_st_chain     IN   user_tab_columns.column_name%TYPE
    , pi_snapping_trig   IN   VARCHAR2 DEFAULT 'TRUE'
   )
   IS
      l_sql   VARCHAR2 (10000);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_clm_layer');

      --  hig_products
      IF hig.is_product_licensed ('CLM')
      THEN
         --
         IF pi_x_column IS NOT NULL AND pi_y_column IS NOT NULL
         THEN
            l_sql :=
                  ' BEGIN '
               || lf
               || 'clm_sdo_util.make_base_sdo_layer'
               || lf
               || '( pi_theme_name    => :pi_theme_name'
               || lf
               || ', pi_asset_type    => :pi_asset_type'
               || lf
               || ', pi_asset_descr   => :pi_asset_descr'
               || lf
               || ', pi_x_column      => :pi_x_column'
               || lf
               || ', pi_y_column      => :pi_y_column'
               || lf
               || ', pi_lr_ne_column  => NULL'
               || lf
               || ', pi_lr_st_chain   => NULL'
               || lf
               || ', pi_snapping_trig => :pi_snapping_trig'
               || lf
               || ' );'
               || lf
               || ' END;';
            --       nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_theme_name
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_x_column
                            , pi_y_column
                            , (pi_snapping_trig);
         END IF;
      END IF;
   END create_clm_layer;
--
-----------------------------------------------------------------------------
--
   PROCEDURE create_swr_layer (
      pi_theme_name      IN   nm_themes_all.nth_theme_name%TYPE
    , pi_asset_type      IN   nm_inv_types.nit_inv_type%TYPE
    , pi_asset_descr     IN   nm_inv_types.nit_descr%TYPE
    , pi_x_column        IN   user_tab_columns.column_name%TYPE
    , pi_y_column        IN   user_tab_columns.column_name%TYPE
    , pi_lr_ne_column    IN   user_tab_columns.column_name%TYPE
    , pi_lr_st_chain     IN   user_tab_columns.column_name%TYPE
    , pi_snapping_trig   IN   VARCHAR2 DEFAULT 'TRUE'
   )
   IS
      l_sql   VARCHAR2 (10000);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_swr_layer');

      --  hig_products
      IF hig.is_product_licensed ('SWR')
      THEN
         --
         l_sql :=
               ' BEGIN '
            || lf
            || 'swr_sdo_util.make_base_sdo_layer'
            || lf
            || '( pi_theme_name    => :pi_theme_name'
            || lf
            || ', pi_asset_type    => :pi_asset_type'
            || lf
            || ', pi_asset_descr   => :pi_asset_descr'
            || lf
            || ', pi_x_column      => :pi_x_column'
            || lf
            || ', pi_y_column      => :pi_y_column'
            || lf
            || ', pi_lr_ne_column  => NULL'
            || lf
            || ', pi_lr_st_chain   => NULL'
            || lf
            || ', pi_snapping_trig => :pi_snapping_trig'
            || lf
            || ' );'
            || lf
            || ' END;';
         --       nm_debug.debug_on;
         nm_debug.DEBUG (l_sql);

         EXECUTE IMMEDIATE l_sql
                     USING pi_theme_name
                         , pi_asset_type
                         , pi_asset_descr
                         , pi_x_column
                         , pi_y_column
                         , pi_snapping_trig;
      END IF;
   END create_swr_layer;

--
-----------------------------------------------------------------------------
--
/*
   **************************
     STR RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
   PROCEDURE create_str_layer (
      pi_theme_name      IN   nm_themes_all.nth_theme_name%TYPE
    , pi_asset_type      IN   nm_inv_types.nit_inv_type%TYPE
    , pi_asset_descr     IN   nm_inv_types.nit_descr%TYPE
    , pi_x_column        IN   user_tab_columns.column_name%TYPE
    , pi_y_column        IN   user_tab_columns.column_name%TYPE
    , pi_lr_ne_column    IN   user_tab_columns.column_name%TYPE
    , pi_lr_st_chain     IN   user_tab_columns.column_name%TYPE
    , pi_snapping_trig   IN   VARCHAR2 DEFAULT 'TRUE'
   )
   IS
      l_sql   VARCHAR2 (10000);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_str_layer');

      --  hig_products
      IF hig.is_product_licensed ('STR')
      THEN
         --
         IF pi_x_column IS NOT NULL AND pi_y_column IS NOT NULL
         THEN
            l_sql :=
                  ' BEGIN '
               || lf
               || 'str_sdo_util.make_base_sdo_layer'
               || lf
               || '( pi_theme_name    => :pi_theme_name'
               || lf
               || ', pi_asset_type    => :pi_asset_type'
               || lf
               || ', pi_asset_descr   => :pi_asset_descr'
               || lf
               || ', pi_x_column      => :pi_x_column'
               || lf
               || ', pi_y_column      => :pi_y_column'
               || lf
               || ', pi_lr_ne_column  => NULL'
               || lf
               || ', pi_lr_st_chain   => NULL'
               || lf
               || ', pi_snapping_trig => :pi_snapping_trig'
               || lf
               || ' );'
               || lf
               || ' END;';
            --       nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_theme_name
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_x_column
                            , pi_y_column
                            , (pi_snapping_trig);
         END IF;
      END IF;
   END create_str_layer;
--
-----------------------------------------------------------------------------
--
/*
   **************************
     STP RELATED FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
--
   PROCEDURE create_stp_layer (
      pi_scheme_type     IN   nm_job_types.njt_type%TYPE
    , pi_asset_type      IN   nm_inv_types.nit_inv_type%TYPE
    , pi_asset_descr     IN   nm_inv_types.nit_descr%TYPE
    , pi_snapping_trig   IN   VARCHAR2 DEFAULT 'TRUE'
   )
   IS
      l_sql   VARCHAR2 (10000);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'create_stp_layer');

      --  hig_products
      IF hig.is_product_licensed ('STP')
      THEN
         --
         IF pi_scheme_type IS NOT NULL
         THEN
            l_sql :=
                  ' BEGIN '
                    || lf
                    || 'stp_sdo_util.make_base_sdo_layer'
                    || lf
                    || '( pi_scheme_type   => :pi_scheme_type'
                    || lf
                    || ', pi_asset_type    => :pi_asset_type'
                    || lf
                    || ', pi_asset_descr   => :pi_asset_descr'
                    || lf
                    || ', pi_snapping_trig => :pi_snapping_trig'
                    || lf
                    || ' );'
                    || lf
               || ' END;';
            --       nm_debug.debug_on;
            nm_debug.DEBUG (l_sql);

            EXECUTE IMMEDIATE l_sql
                        USING pi_scheme_type
                            , pi_asset_type
                            , pi_asset_descr
                            , pi_snapping_trig;
         END IF;
         --
      END IF;
      --
      nm_debug.proc_end (g_package_name, 'create_stp_layer');
      --
   END create_stp_layer;
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
-- Drop Enquiries SDO layer
  PROCEDURE drop_str_layer
              ( pi_nth_theme_id        IN     NM_THEMES_ALL.nth_theme_id%TYPE)
  IS
  BEGIN
    NULL;
  END drop_str_layer;
--
-----------------------------------------------------------------------------
--
  PROCEDURE update_nsg_themes (pi_gty_type IN nm_group_types.ngt_group_type%TYPE)
  IS
    l_theme_name   nm_themes_all.nth_theme_name%TYPE;
    l_theme_ft     nm_themes_all.nth_Feature_table%TYPE;
    l_theme_label  nm_themes_all.nth_label_column%TYPE  :=  'NE_DESCR';
  BEGIN
    IF pi_gty_type IN ('OFFN','RDNM','UOFF')
    THEN
    --
        IF pi_gty_type = 'OFFN'
        THEN
        --
          l_theme_name := 'TYPE 1 AND 2 STREETS';
          l_theme_ft   := 'V_NM_NAT_NSGN_OFFN_SDO_DT';
        --
        ELSIF pi_gty_type = 'RDNM'
        THEN
        --
          l_theme_name := 'TYPE 3 STREETS';
          l_theme_ft   := 'V_NM_NAT_NSGN_RDNM_SDO_DT';
        --
        ELSIF pi_gty_type = 'UOFF'
        THEN
        --
          l_theme_name := 'TYPE 4 STREETS';
          l_theme_ft   := 'V_NM_NAT_NSGN_UOFF_SDO_DT';
        --
        END IF;
        --
        UPDATE nm_themes_all
           SET nth_theme_name = l_theme_name
             , nth_label_column = l_theme_label
         WHERE nth_feature_table = l_theme_ft;
        --
        DELETE nm_theme_functions_all
         WHERE EXISTS
           ( SELECT 1 FROM nm_themes_all
               WHERE nth_feature_table = l_theme_ft
                 AND ntf_nth_theme_id = nth_theme_id )
           AND ntf_hmo_module in ('NM0105','NM0110');
        --
        INSERT INTO nm_theme_functions_all
        SELECT nth_theme_id, 'NSG0010','GIS_SESSION_ID','STREET DETAILS','Y'
          FROM nm_themes_all
         WHERE nth_feature_table = l_theme_ft;
     
        IF pi_gty_type = 'OFFN' THEN    
                --
                -- for OFFN layer, allow a Streetworks Works to be created from the map
                -- if the actual supporting module exists
                --
                INSERT INTO nm_theme_functions_all(ntf_nth_theme_id
                                                 , ntf_hmo_module
                                                 , ntf_parameter
                                                 , ntf_menu_option
                                                 , ntf_seen_in_gis)
                   SELECT nth_theme_id
                       ,  hmo_module
                       , 'GIS_SESSION_ID_STR_NSG_REF'
                       , 'CREATE WORKS FROM MAP'
                       , 'Y'
                     FROM nm_themes_all
                        , hig_modules
                    WHERE nth_feature_table = l_theme_ft
                    AND   hmo_module = 'SWR1190';
            
        END IF;
            
                --
        -- Give both SWR and NSG standard roles to the theme 
        -- 
        INSERT INTO nm_theme_roles(nthr_theme_id, nthr_role, nthr_mode)
        SELECT            nth_theme_id
                         ,hro_role
                         ,'NORMAL'
        FROM nm_themes_all
           , hig_roles -- join to hig_roles to ensure only those roles implemented are used
        WHERE nth_theme_name = l_theme_name
        AND  hro_role IN( 'SWR_USER'
                        , 'SWR_OWNER'
                        , 'NSG_USER'
                        , 'NSG_ADMIN');            
    
    END IF;
    
  END update_nsg_themes;
--
-----------------------------------------------------------------------------
--
  PROCEDURE create_nsgn_layer
              ( pi_street_type   IN  nm_group_types.ngt_group_type%TYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'create_nsgn_layer');

      --  hig_products
      IF hig.is_product_licensed ('NSG')
      THEN
        EXECUTE IMMEDIATE
          'BEGIN '||lf||
          ' nm3sdm.make_group_layer (:pi_nt_type, :pi_gty_type);'||lf||
          'END;'
        USING
          'NSGN', pi_street_type;

        update_nsg_themes (pi_gty_type => pi_street_type);

      END IF;

    nm_debug.proc_end (g_package_name, 'create_nsgn_layer');
  --
  END create_nsgn_layer;
--
-----------------------------------------------------------------------------
--
  PROCEDURE create_nsgn_asd_layer
              ( pi_type    IN  nm_inv_types.nit_inv_type%TYPE )
  IS
    l_asset_type nm_inv_types.nit_inv_type%TYPE ;
  BEGIN
  --
  IF hig.is_product_licensed ('NSG') THEN
    --
    
        EXECUTE IMMEDIATE
          'BEGIN '||lf||
          ' IF nm3nsgasd.asd_record_type_in_use(pi_type => :pi_type) THEN'||lf||
          '   nm3nsgasd.Make_Asd_Spatial_Layer (p_inv_type => :pi_type );'||lf||
          ' END IF;'||lf||
          'END;' USING pi_type;
      
  END IF;
  
  END create_nsgn_asd_layer;
--
-----------------------------------------------------------------------------
--  
  FUNCTION england_wales_asd_in_use RETURN BOOLEAN IS
  
  BEGIN

  IF hig.is_product_licensed ('NSG') THEN
    --
     EXECUTE IMMEDIATE    
          'BEGIN '||lf||
          ' nm3layer_tool.set_global_boolean(nm3nsgasd.england_wales_asd_in_use);'||lf||
          'END;';
          
          RETURN(get_global_boolean);
  ELSE
    RETURN False;
  END IF;
  
  END england_wales_asd_in_use;
--
-----------------------------------------------------------------------------
--  
  FUNCTION scotland_asd_in_use RETURN BOOLEAN IS
  
  BEGIN

  IF hig.is_product_licensed ('NSG') THEN
    --
     EXECUTE IMMEDIATE    
          'BEGIN '||lf||
          ' nm3layer_tool.set_global_boolean(nm3nsgasd.scotland_asd_in_use);'||lf||
          'END;';
          
          RETURN(get_global_boolean);
  ELSE
    RETURN False;
  END IF;
  
  END scotland_asd_in_use;
  
--
-----------------------------------------------------------------------------
--
/*
   **************************
     GENERAL PROCS/FUNCTIONS
   **************************
*/
--
-----------------------------------------------------------------------------
-- Check to see if object is key preserved for compatability with MSV
   FUNCTION is_key_preserved (pi_object_name IN VARCHAR2)
      RETURN BOOLEAN
   IS
      e_not_key_preserved   EXCEPTION;
      e_not_found           EXCEPTION;
      e_has_errors          EXCEPTION;
      PRAGMA EXCEPTION_INIT (e_not_key_preserved, -01445);
      PRAGMA EXCEPTION_INIT (e_not_found, -00942);
      PRAGMA EXCEPTION_INIT (e_has_errors, -04063);
      l_dummy               ROWID;
      l_sql                 nm3type.max_varchar2;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'is_key_preserved');

      --
      IF nm3ddl.does_object_exist (pi_object_name)
      THEN
         l_sql :=
               'BEGIN '
            || lf
            || 'SELECT ROWID INTO :l_dummy FROM '
            || (pi_object_name)
            || ' WHERE ROWNUM = 1;'
            || lf
            || 'END;';
--      nm_debug.debug_on;
--      nm_debug.debug(l_sql);
         nm3flx.is_select_statement_valid (l_sql);

         EXECUTE IMMEDIATE l_sql
                     USING OUT l_dummy;

         --
         RETURN TRUE;
      --
      ELSE
         RETURN FALSE;
      END IF;

      --
      nm_debug.proc_end (g_package_name, 'is_key_preserved');
   --
   EXCEPTION
      -- Non key preserved - return false
      WHEN e_not_key_preserved
      THEN
         RETURN FALSE;

      -- Cannot find table - unfortunately this doesn't seem to catch it
      -- hence the DDL Check at the top
      WHEN e_not_found
      THEN
         RETURN FALSE;

      -- In the order of events, if the view is empty, it'll fail with
      -- 'cannot select from a nonkey preserved...' BEFORE you get NO_DATA_FOUND
      -- So it's safe to assume if you get NO_DATA_FOUND, the view IS keypreserved
      WHEN NO_DATA_FOUND
      THEN
         RETURN TRUE;

      WHEN OTHERS
      THEN
         -- This error (NET0121) is raised from nm3flx.is_sql_statement_valid
         -- Supress the error and return FALSE
         IF hig.check_last_ner (pi_appl => nm3type.c_net, pi_id => 121)
         THEN
            RETURN FALSE;
         ELSE
            RAISE;
         END IF;
   END is_key_preserved;
--
-----------------------------------------------------------------------------
--
   FUNCTION is_object_valid (pi_object_name IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_result   user_objects.status%TYPE;
   BEGIN
      SELECT status
        INTO l_result
        FROM user_objects
       WHERE object_name = pi_object_name;

      --
      RETURN l_result;
   --
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN '';
      WHEN OTHERS
      THEN
         RAISE;
   --
   END is_object_valid;

--
-----------------------------------------------------------------------------
--
   PROCEDURE is_an_asset_theme (
      pi_theme_id    IN   nm_themes_all.nth_theme_id%TYPE
    , pi_new_theme   IN   nm_themes_all.nth_theme_id%TYPE
   )
   IS
      TYPE tab_nith IS TABLE OF nm_inv_themes%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tab_nith   tab_nith;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_tab_nith
        FROM nm_inv_themes
       WHERE nith_nth_theme_id = pi_theme_id;

      --
      INSERT INTO nm_inv_themes
                  (nith_nit_id, nith_nth_theme_id
                  )
           VALUES (l_tab_nith (1).nith_nit_id, pi_new_theme
                  );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN;
   END is_an_asset_theme;

--
-----------------------------------------------------------------------------
--
   PROCEDURE is_an_area_theme (
      pi_theme_id    IN   nm_themes_all.nth_theme_id%TYPE
    , pi_new_theme   IN   nm_themes_all.nth_theme_id%TYPE
   )
   IS
      TYPE tab_nath IS TABLE OF nm_area_themes%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tab_nath   tab_nath;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_tab_nath
        FROM nm_area_themes
       WHERE nath_nth_theme_id = pi_theme_id;

      --
      INSERT INTO nm_area_themes
                  (nath_nat_id, nath_nth_theme_id
                  )
           VALUES (l_tab_nath (1).nath_nat_id, pi_new_theme
                  );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN;
   END is_an_area_theme;

--
-----------------------------------------------------------------------------
--
   PROCEDURE is_a_linear_theme (
      pi_theme_id    IN   nm_themes_all.nth_theme_id%TYPE
    , pi_new_theme   IN   nm_themes_all.nth_theme_id%TYPE
   )
   IS
      TYPE tab_nnth IS TABLE OF nm_nw_themes%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tab_nnth   tab_nnth;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_tab_nnth
        FROM nm_nw_themes
       WHERE nnth_nth_theme_id = pi_theme_id;

      --
      INSERT INTO nm_nw_themes
                  (nnth_nlt_id, nnth_nth_theme_id
                  )
           VALUES (l_tab_nnth (1).nnth_nlt_id, pi_new_theme
                  );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN;
   END is_a_linear_theme;

--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
   PROCEDURE drop_spatial_index (
      pi_index_name        IN   user_indexes.index_name%TYPE
    , pi_raise_not_found   IN   BOOLEAN DEFAULT FALSE
   )
   IS
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'drop_spatial_index');

      --
      BEGIN
         EXECUTE IMMEDIATE 'DROP INDEX ' || pi_index_name;
      EXCEPTION
         WHEN OTHERS
         THEN
            IF pi_raise_not_found
            THEN
               RAISE;
            END IF;
      END;

      --
      nm_debug.proc_end (g_package_name, 'drop_spatial_index');
   --
   END drop_spatial_index;

--
-----------------------------------------------------------------------------
--
   PROCEDURE rebuild_spatial_index (
      pi_index_name    IN   user_indexes.index_name%TYPE
    , pi_table_name    IN   user_tables.table_name%TYPE
    , pi_column_name   IN   user_tab_columns.column_name%TYPE
    , pi_index_type    IN   VARCHAR2 DEFAULT 'RTREE'
   )
   IS
      cur_string          VARCHAR2 (2000);
      l_index_name        VARCHAR2 (32);

      CURSOR try_and_find_index (cp_table_name IN VARCHAR2)
      IS
         SELECT a.sdo_index_name sdo_idx_name
           FROM MDSYS.sdo_index_metadata_table a, user_indexes b
          WHERE sdo_index_name = index_name
            AND table_name = cp_table_name
            AND index_type = 'DOMAIN';

      l_dummy_indx_name   VARCHAR2 (32);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'rebuild_spatial_index');

      --
      IF pi_index_type = 'RTREE'
      THEN
         l_index_name :=
                NVL (pi_index_name, SUBSTR (pi_table_name, 1, 24) || '_spidx');
      ELSIF pi_index_type = 'QTREE'
      THEN
         l_index_name :=
                NVL (pi_index_name, SUBSTR (pi_table_name, 1, 24) || '_qtidx');
      END IF;

      --
      BEGIN
         EXECUTE IMMEDIATE 'alter session set sort_area_size = 20000000';
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      --
      BEGIN
         EXECUTE IMMEDIATE 'DROP INDEX ' || l_index_name;
      EXCEPTION
         WHEN OTHERS
         THEN
            BEGIN
               OPEN try_and_find_index (cp_table_name => pi_table_name);

               FETCH try_and_find_index
                INTO l_dummy_indx_name;

               CLOSE try_and_find_index;

               IF l_dummy_indx_name IS NOT NULL
               THEN
                  EXECUTE IMMEDIATE 'DROP INDEX ' || l_dummy_indx_name;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  RAISE_APPLICATION_ERROR (-20101
                                         , 'Cannot drop ' || pi_index_name
                                          );
            END;
      END;

      --
      IF pi_index_type = 'QTREE'
      THEN
         cur_string :=
               'create index '
            || l_index_name
            || ' on '
            || pi_table_name
            || ' ( '
            || pi_column_name
            || ' ) indextype is mdsys.spatial_index'
            || ' parameters  ( '
            || ''''
            || 'sdo_level=6'
            || ''''
            || ')';
      ELSIF pi_index_type = 'RTREE'
      THEN
         cur_string :=
               'create index '
            || l_index_name
            || ' on '
            || pi_table_name
            || ' ( '
            || pi_column_name
            || ' ) indextype is mdsys.spatial_index'
            || ' parameters  ( '
            || ''''
            || 'sdo_indx_dims=2'
            || ''''
            || ')';
      END IF;

      --
      EXECUTE IMMEDIATE cur_string;

      --
      nm_debug.proc_end (g_package_name, 'rebuild_spatial_index');
   --
   END rebuild_spatial_index;

--
-----------------------------------------------------------------------------
--
   PROCEDURE set_cancel_flag (pi_value IN VARCHAR2, pi_user_key IN VARCHAR2)
   IS
   BEGIN
      --
      --  g_cancel_flag := pi_value;
      --
      --  IF pi_value = 'Y' THEN
      --    UPDATE NM_LAYER_LOG
      --    SET    nll_descr = 'CANCELLED'
      --    WHERE  nll_id    = pi_user_key;
      --    COMMIT;
      --  END IF;
      NULL;
   --
   END set_cancel_flag;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_user_key
      RETURN VARCHAR2
   IS
      CURSOR c_get_user_key
      IS
         SELECT    SUBSTR (USER, 1, 25)
                || TO_CHAR (CURRENT_TIMESTAMP, 'DDMMYYYYHH24MISSXFF')
           FROM DUAL;
   BEGIN
      OPEN c_get_user_key;

      FETCH c_get_user_key
       INTO g_user_key;

      CLOSE c_get_user_key;

      RETURN g_user_key;
   END get_user_key;

--
-----------------------------------------------------------------------------
--
   PROCEDURE cleardown_log_table
   IS
   BEGIN
      --EXECUTE IMMEDIATE 'truncate table nm_layer_log';
      NULL;
   END cleardown_log_table;

--
-----------------------------------------------------------------------------
--
-- Associates all linear network themes with given theme id
   PROCEDURE associate_base_linear_themes (
      pi_nth_theme_id   IN   nm_themes_all.nth_theme_id%TYPE
   )
   IS
      CURSOR get_linear_networks
      IS
         SELECT *
           FROM v_nm_net_themes
          WHERE vnnt_type = 'L';
      l_priority   NUMBER := 0;
   BEGIN
      FOR i IN get_linear_networks
      LOOP
        --
         l_priority := l_priority + 1;
        --
         INSERT INTO nm_base_themes
                     (nbth_theme_id, nbth_base_theme
                     )
              VALUES (pi_nth_theme_id, i.vnnt_nth_theme_id
                     );
        --
         INSERT INTO nm_theme_snaps
                     (nts_theme_id, nts_snap_to, nts_priority
                     )
              VALUES (pi_nth_theme_id, i.vnnt_nth_theme_id, l_priority
                     );
        --
      END LOOP;
   END associate_base_linear_themes;
--
-----------------------------------------------------------------------------
--
  PROCEDURE create_msv_feature_views
                ( pi_username  IN   hig_users.hus_username%TYPE DEFAULT NULL)
  IS
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'create_msv_feature_views');
  --
    nm3sdm.create_msv_feature_views (pi_username);
  --
    nm_debug.proc_end   (g_package_name, 'create_msv_feature_views');
  --
  END create_msv_feature_views;
--
-----------------------------------------------------------------------------
--
--<PROC NAME="BUILD_NPL_DATA">
-- Build the nm_point_locations data
  PROCEDURE build_npl_data
  IS
  --
    CURSOR get_srid
    IS
      SELECT distinct(srid)
      FROM user_sdo_geom_metadata;
  --
    l_srid   number;
    l_spdix  user_indexes.index_name%TYPE
                := nm3sdo.get_spatial_index ('NM_POINT_LOCATIONS','NPL_LOCATION');
  --
  BEGIN
  --
  -- get srid from existing data - if any are set.
    OPEN get_srid;
    FETCH get_srid INTO l_srid;
    CLOSE get_srid;
  --
  -- drop existing spatial index
    BEGIN
      EXECUTE IMMEDIATE 'DROP INDEX '||l_spdix;
    EXCEPTION
      WHEN OTHERS
      THEN NULL;
    END;

  -- Create npl data
    INSERT INTO nm_point_locations
      ( npl_id, npl_location )
    SELECT np_id
         , mdsys.sdo_geometry
            (2001
          ,l_srid
          , mdsys.sdo_point_type
              ( np_grid_east
              , np_grid_north, NULL)
         ,NULL
         ,NULL)
     FROM nm_points
    WHERE np_grid_east  IS NOT NULL
      AND np_grid_north IS NOT NULL
      AND NOT EXISTS
        (SELECT 1 FROM nm_point_locations
          WHERE npl_id = np_id);
  --
  -- Register table in user_sdo_geom_metadata
    nm3sdo.register_table
       ( p_table             => 'NM_POINT_LOCATIONS'
       , p_shape_col         => 'NPL_LOCATION'
       , p_cre_idx           => 'Y'
       , p_tol               => NULL
       , p_estimate_new_tol  => 'Y'
       , p_override_sdo_meta => 'Y');
  --
  -- Create spatial index
    BEGIN
      nm3sdo.create_spatial_idx ('NM_POINT_LOCATIONS', 'NPL_LOCATION');
    EXCEPTION
      WHEN OTHERS
      THEN NULL;
    END;

  --
  -- Analyse table
    BEGIN
      nm3ddl.analyse_table ('NM_POINT_LOCATIONS');
    END;
  --
  END build_npl_data;
--
-----------------------------------------------------------------------------
--
END nm3layer_tool;
/
