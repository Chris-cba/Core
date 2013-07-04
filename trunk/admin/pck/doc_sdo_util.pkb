CREATE OR REPLACE PACKAGE BODY doc_sdo_util
IS
  -----------------------------------------------------------------------------
  --
  --
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/doc_sdo_util.pkb-arc   2.9   Jul 04 2013 14:31:26   James.Wadsworth  $
  --       Module Name      : $Workfile:   doc_sdo_util.pkb  $
  --       Date into PVCS   : $Date:   Jul 04 2013 14:31:26  $
  --       Date fetched Out : $Modtime:   Jul 04 2013 14:29:24  $
  --       Version          : $Revision:   2.9  $
  --
  --   Author : Christopher Strettle
  --
  ------------------------------------------------------------------
  --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid          CONSTANT VARCHAR2(2000) := '$Revision:   2.9  $';
  g_package_name         CONSTANT VARCHAR2(30) := 'DOC_SDO_UTIL';
  nl                     CONSTANT VARCHAR2(5) := chr(10);

  --
  TYPE tab_ntf IS TABLE OF nm_theme_functions_all%ROWTYPE
                    INDEX BY BINARY_INTEGER;

  --
  g_theme_name           nm3type.tab_varchar30;
  g_theme_functions      tab_ntf;
  --g_theme_feature_views  nm3type.tab_varchar30;

  --
  --   g_prod_option          CONSTANT hig_option_values.hov_id%TYPE     := 'SDOPEMNTH';
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
/*  FUNCTION is_default_theme_name(p_theme_name nm_themes_all.nth_theme_name%TYPE )
  RETURN BOOLEAN
  IS
  BEGIN
    RETURN g_view_theme_name = p_theme_name;
  END is_default_theme_name;*/
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_theme_functions
  IS
  BEGIN
    -- nm_theme_functions_all
    -- locator
    g_theme_functions(1).ntf_hmo_module    := 'NM0572';
    g_theme_functions(1).ntf_parameter     := 'GIS_SESSION_ID';
    g_theme_functions(1).ntf_menu_option   := 'Locator';
    --
    -- public enquiries
    g_theme_functions(2).ntf_hmo_module    := 'DOC0100';
    g_theme_functions(2).ntf_parameter     := 'EDIT_SESSION_ID';
    g_theme_functions(2).ntf_menu_option   := 'Edit Document';
    --
    g_theme_functions(3).ntf_hmo_module    := 'DOC0100';
    g_theme_functions(3).ntf_parameter     := 'GIS_SESSION_ID';
    g_theme_functions(3).ntf_menu_option   := 'Display Document';
  --
  END set_theme_functions;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE register_metadata(
    p_table_name      user_sdo_geom_metadata.table_name%TYPE
   ,p_geometry_col    user_sdo_geom_metadata.column_name%TYPE)
  IS
    l_dims      MDSYS.sdo_dim_array;
    l_rec_usgm  user_sdo_geom_metadata%ROWTYPE;
  BEGIN
    -- checks if the function will cause an error before proceeding.
    BEGIN
      l_dims   := nm3sdo.coalesce_nw_diminfo;
    EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(
          -20101
         ,
          'One or more Network layers are not registered in USER_SDO_GEOM_METADATA'
          || ' - ' || sqlerrm);
    END;

    --
    IF nm3sdo.
       get_usgm(pi_table_name    => p_table_name
               ,pi_column_name   => p_geometry_col).table_name
         IS NULL THEN
      -- checks if the function will cause an error before proceeding.
      BEGIN
        l_dims   := nm3sdo.coalesce_nw_diminfo;
      EXCEPTION
        WHEN OTHERS THEN
          raise_application_error(
            -20101
           ,
            'One or more Network layers are not registered in USER_SDO_GEOM_METADATA'
            || ' - ' || sqlerrm);
      END;

      l_rec_usgm.table_name    := upper(p_table_name);
      l_rec_usgm.column_name   := upper(p_geometry_col);
      l_rec_usgm.diminfo       :=
        SDO_LRS.convert_to_std_dim_array(nm3sdo.coalesce_nw_diminfo);
      l_rec_usgm.srid          := NULL;
      --
      nm3sdo.ins_usgm(l_rec_usgm);
    END IF;
  --
  END register_metadata;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE make_base_sdo_layer(
    pi_theme_name      IN nm_themes_all.nth_theme_name%TYPE
   ,pi_asset_type      IN nm_inv_types.nit_inv_type%TYPE
   ,pi_asset_descr     IN nm_inv_types.nit_descr%TYPE
   ,pi_lr_ne_column    IN user_tab_columns.column_name%TYPE
   ,pi_lr_st_chain     IN user_tab_columns.column_name%TYPE
   ,pi_snapping_trig   IN VARCHAR2 DEFAULT 'TRUE')
  IS
    l_rec_nth              nm_themes_all%ROWTYPE;
    l_rec_ntg              nm_theme_gtypes%ROWTYPE;
    l_rec_nth_v            nm_themes_all%ROWTYPE;
    l_rec_ntg_v            nm_theme_gtypes%ROWTYPE;
    l_rec_nthr             nm_theme_roles%ROWTYPE;
    l_rec_nith             nm_inv_themes%ROWTYPE;
    l_rec_ntf              nm_theme_functions_all%ROWTYPE;
    l_theme_id             NUMBER := nm3seq.next_nth_theme_id_seq;
    l_view_theme_id        NUMBER := nm3seq.next_nth_theme_id_seq;
    l_dummy                NUMBER;
    l_doc_sdo_view_sql     nm3type.max_varchar2;
      
    CURSOR enq_version_cur IS
    SELECT 1
      FROM hig_products
     WHERE hpr_product = 'ENQ'
       AND ((REPLACE(hpr_version,'.',NULL) >= 4300 AND LENGTH(REPLACE(hpr_version,'.',NULL)) = 4)
        OR  (REPLACE(hpr_version,'.',NULL) >= 43   AND LENGTH(REPLACE(hpr_version,'.',NULL)) = 2));

  BEGIN
    --
    IF pi_snapping_trig = 'TRUE' 
    AND hig.is_product_licensed('HIG') THEN
    --
      OPEN enq_version_cur;
      FETCH enq_version_cur INTO l_dummy;
      IF enq_version_cur%NOTFOUND THEN
        CLOSE enq_version_cur;
        hig.raise_ner('HIG', 549);
      END IF;
      CLOSE enq_version_cur;
    --
    END IF;
    
    -- set arrays of predetermined theme names and theme functions
    set_theme_functions;

    --
    IF nm3get.get_nit(pi_nit_inv_type => pi_asset_type, pi_raise_not_found => FALSE).
       nit_inv_type
         IS NULL THEN
      nm3inv.create_ft_asset_from_table(pi_table_name     => g_view_name
                                       ,pi_pk_column      => g_pk_column
                                       ,pi_asset_type     => pi_asset_type
                                       ,pi_asset_descr    => pi_asset_descr
                                       ,pi_pnt_or_cont    => 'P'
                                       ,pi_use_xy         => 'N'
                                       ,pi_x_column       => g_x_column
                                       ,pi_y_column       => g_y_column
                                       ,pi_lr_ne_column   => pi_lr_ne_column
                                       ,pi_lr_st_chain    => pi_lr_st_chain
                                       ,pi_lr_end_chain   => NULL
                                       ,pi_attrib_ltrim   => 4);
    END IF;

    --
    --
    --------------------------------------------------------------
    -- *********************************************************
    -- Build the base table DOC theme
    -- *********************************************************
    --------------------------------------------------------------
    --
    l_rec_nth.nth_theme_id               := l_theme_id;
    l_rec_nth.nth_theme_name             := substr(pi_theme_name, 0, 26) || '_TAB';
    l_rec_nth.nth_table_name             := g_table_name;
    --
    l_rec_nth.nth_where                  :=
      g_x_column || ' IS NOT NULL ' || 'AND ' || g_y_column ||
      ' IS NOT NULL ';

   IF nm3ddl.does_object_exist(g_feature_tab) THEN
      raise_application_error(-20110, g_feature_tab ||
                                      ' exists - please drop or rename');
    END IF;

    --
    l_rec_nth.nth_pk_column              := g_pk_column;
    l_rec_nth.nth_label_column           := g_pk_column;
    l_rec_nth.nth_rse_table_name         := 'NM_ELEMENTS';
    l_rec_nth.nth_rse_fk_column          := pi_lr_ne_column;
    l_rec_nth.nth_st_chain_column        := pi_lr_st_chain;
    l_rec_nth.nth_end_chain_column       := NULL;
    l_rec_nth.nth_x_column               := g_x_column;
    l_rec_nth.nth_y_column               := g_y_column;
    l_rec_nth.nth_offset_field           := NULL;
    l_rec_nth.nth_feature_table          := g_feature_tab;
    l_rec_nth.nth_feature_pk_column      := g_pk_column;
    l_rec_nth.nth_feature_fk_column      := NULL;
    l_rec_nth.nth_xsp_column             := NULL;
    l_rec_nth.nth_feature_shape_column   := g_shape_col;
    l_rec_nth.nth_hpr_product            := 'DOC';
    l_rec_nth.nth_location_updatable     := 'Y';
    l_rec_nth.nth_theme_type             := 'LOCL';
    l_rec_nth.nth_dependency             := 'I';
    l_rec_nth.nth_storage                := 'S';
    l_rec_nth.nth_update_on_edit         := 'N';
    l_rec_nth.nth_use_history            := 'N';
    l_rec_nth.nth_start_date_column      := NULL;
    l_rec_nth.nth_end_date_column        := NULL;
    l_rec_nth.nth_base_table_theme       := NULL;
    l_rec_nth.nth_snap_to_theme          := 'S';
    l_rec_nth.nth_lref_mandatory         := 'N';
    l_rec_nth.nth_tolerance              := 10;
    l_rec_nth.nth_tol_units              := 1;
    l_rec_nth.nth_dynamic_theme          := 'N';
    l_rec_nth.nth_where                  :=
      'doc_compl_east is not null and doc_compl_north is not null and doc_dtp_code in ( select dtp_code from doc_types where dtp_allow_comments = ''N'' and dtp_allow_complaints = ''N'' and sysdate between nvl(dtp_start_date, sysdate) and nvl(dtp_end_date, sysdate))';
    --l_rec_nth.nth_where                   := 'doc_compl_east is not null and doc_compl_north is not null and doc_dcl_code IS NULL';
    --
    l_rec_ntg.ntg_theme_id               := l_theme_id;
    l_rec_ntg.ntg_gtype                  := '2001';
    l_rec_ntg.ntg_seq_no                 := 1;
    l_rec_ntg.ntg_xml_url                := NULL;
    --
    --------------------------------------------------------------
    -- Insert the Theme and associated GType
    --------------------------------------------------------------
    --
    nm3ins.ins_nth(p_rec_nth => l_rec_nth);
    nm3ins.ins_ntg(p_rec_ntg => l_rec_ntg);
    --
    --------------------------------------------------------------
    -- Create the SDO layer
    --------------------------------------------------------------
    --
    nm3sdo.create_sdo_layer_from_locl(p_nth_id => l_theme_id);
    --
    --
    --------------------------------------------------------------
    -- Create a spatial joined view
    --------------------------------------------------------------
    --
    l_doc_sdo_view_sql                   :=
      ' CREATE OR REPLACE FORCE VIEW ' || g_theme_feature_views || nl ||
      ' AS ' || nl || '   SELECT ' || nl || nm3ddl.get_sccs_comments(
      pi_sccs_id => g_body_sccsid) || nl || '          a.* ' || nl ||
      '        , b.' || g_shape_col || ', b.objectid ' || nl ||
      '     FROM ' || g_view_name || ' a ' || nl || '        , ' ||
      l_rec_nth.nth_feature_table || ' b ' || nl || '    WHERE a.' ||
      g_view_pk_col || ' = b.' || l_rec_nth.nth_feature_pk_column;

    --
    ---------------------------------------------------------------
    -- Create themes for the view
    ---------------------------------------------------------------

    BEGIN
      EXECUTE IMMEDIATE l_doc_sdo_view_sql;

      nm3ddl.create_synonym_for_object(g_theme_feature_views);
    EXCEPTION
      WHEN OTHERS THEN
        NULL; --RAISE ;
    END;

    l_rec_nth_v                          := l_rec_nth;
    --
    l_rec_nth_v.nth_theme_id             := l_view_theme_id;
    l_rec_nth_v.nth_theme_name           := pi_theme_name;
    l_rec_nth_v.nth_table_name           := g_view_name;
    l_rec_nth_v.nth_pk_column            := g_view_pk_col;
    l_rec_nth_v.nth_label_column         := g_view_pk_col;
    l_rec_nth_v.nth_feature_table        := g_theme_feature_views;
    l_rec_nth_v.nth_feature_pk_column    := g_view_pk_col;
    l_rec_nth_v.nth_theme_type           := 'SDO';
    l_rec_nth_v.nth_base_table_theme     := l_theme_id;
    l_rec_nth_v.nth_where                := NULL;
    --
    l_rec_ntg_v.ntg_theme_id             := l_view_theme_id;
    l_rec_ntg_v.ntg_gtype                := '2001';
    l_rec_ntg_v.ntg_seq_no               := 1;

    --
    BEGIN
      nm3ins.ins_nth(l_rec_nth_v);
      nm3ins.ins_ntg(l_rec_ntg_v);
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
    END;

    --------------------------------------------------------------
    -- Create NM_INV_THEME record to link asset to theme
    --------------------------------------------------------------
    --
    l_rec_nith.nith_nit_id               := pi_asset_type;
    l_rec_nith.nith_nth_theme_id         := l_view_theme_id;
    --
    nm3ins.ins_nith(l_rec_nith);
    --
    ---------------------------------------------------------------
    -- Create a theme role - this will copy metadata to subordinate
    -- users if SDMREGULAY is set, and users have the ENQ_USER role
    ----------------------------------------------------------------
    --
    l_rec_nthr.nthr_theme_id             := l_view_theme_id;
    l_rec_nthr.nthr_role                 := 'DOC_USER';
    l_rec_nthr.nthr_mode                 := 'NORMAL';
    --
    nm3ins.ins_nthr(l_rec_nthr);
    --
    l_rec_nthr.nthr_role                 := 'HIG_USER';
    --
    nm3ins.ins_nthr(l_rec_nthr);

    --------------------------------------------------------------
    -- Create theme functions
    --------------------------------------------------------------
    --
    FOR i IN 1 .. g_theme_functions.count
    LOOP
      -- nm_theme_functions_all
      l_rec_ntf                    := g_theme_functions(i);
      l_rec_ntf.ntf_nth_theme_id   := l_view_theme_id;

      nm3ins.ins_ntf(l_rec_ntf);
    --
    END LOOP;
    ---------------------------------------------------------------
    -- Create SDO metadata for view themes
    --
    ---------------------------------------------------------------
    BEGIN
      l_dummy := Nm3sdo.create_sdo_layer
                 ( pi_table_name   => l_rec_nth_v.nth_feature_table
                 , pi_column_name  => l_rec_nth_v.nth_feature_shape_column
                 , pi_gtype        => l_rec_ntg_v.ntg_gtype);
    EXCEPTION
      WHEN OTHERS
        THEN RAISE;
    END;
    --------------------------------------------------------------
    -- Create the SDE layer
    --------------------------------------------------------------
    IF Hig.get_sysopt('REGSDELAY') = 'Y'
    THEN
       EXECUTE IMMEDIATE
         ( ' BEGIN  '
         ||'    nm3sde.register_sde_layer( p_theme_id => '
         ||TO_CHAR( l_rec_nth_v.nth_theme_id )||');'
         ||' END;'
         );
    END IF;
    --
    -- Create the shape generation / snapping trigger
    --------------------------------------------------------------
    --
    IF pi_snapping_trig = 'TRUE' THEN
      IF hig.is_product_licensed('HIG') THEN
      --
        EXECUTE IMMEDIATE 'BEGIN ENQ_SDO_UTIL.CHECK_OLD_ENQ_TRIGGER; END;';
      --
      END IF;

      --
      nm3sdm.create_nth_sdo_trigger(p_nth_theme_id   => l_theme_id
                                   ,p_restrict       => g_restriction);
    END IF;

    --
    register_metadata(p_table_name     => g_table_name
                     ,p_geometry_col   => g_shape_col);

    register_metadata(p_table_name     => g_theme_feature_views
                     ,p_geometry_col   => g_shape_col);
  --
  END make_base_sdo_layer;

  FUNCTION doc_is_doc(pi_doc_dtp_code VARCHAR2)
    RETURN BOOLEAN
  IS
    --
    CURSOR doc_cur(
      p_doc_dtp_code VARCHAR2)
    IS
      SELECT 'X'
        FROM doc_types
       WHERE dtp_allow_comments = 'N'
         AND dtp_allow_complaints = 'N'
         AND sysdate BETWEEN nvl(dtp_start_date, sysdate)
                         AND nvl(dtp_end_date, sysdate)
         AND dtp_code = p_doc_dtp_code;
    --
    l_dummy       VARCHAR2(1);
    l_return_val  BOOLEAN;
  BEGIN
    --
    OPEN doc_cur(pi_doc_dtp_code);

    FETCH doc_cur INTO l_dummy;

    l_return_val   := doc_cur%FOUND;

    CLOSE doc_cur;

    --
    RETURN l_return_val;
  END;
--
-----------------------------------------------------------------------------
--
END doc_sdo_util;
/
