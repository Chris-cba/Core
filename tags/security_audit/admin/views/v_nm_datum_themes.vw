CREATE OR REPLACE FORCE VIEW V_NM_DATUM_THEMES
(
    NTH_THEME_ID,
    NTH_THEME_NAME,
    NLT_ID,
    NLT_UNITS,
    NT_TYPE,
    nth_feature_table,
    nth_feature_pk_column,
    nth_feature_shape_column,
    srid
)
AS
    SELECT -------------------------------------------------------------------------
           --   PVCS Identifiers :-
           --
           --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_datum_themes.vw-arc   1.3   Jan 02 2019 14:16:50   Chris.Baugh  $
           --       Module Name      : $Workfile:   v_nm_datum_themes.vw  $
           --       Date into PVCS   : $Date:   Jan 02 2019 14:16:50  $
           --       Date fetched Out : $Modtime:   Dec 07 2018 10:18:04  $
           --       Version          : $Revision:   1.3  $
           ------------------------------------------------------------------
           --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
           ------------------------------------------------------------------
                                                                          ----
          NTH_THEME_ID,
          NTH_THEME_NAME,
          NLT_ID,
          NLT_UNITS,
          NLT_NT_TYPE,
          nth_feature_table,
          nth_feature_pk_column,
          nth_feature_shape_column,
          srid
     FROM nm_themes_all,
          nm_nw_themes,
          nm_linear_types,
          user_sdo_geom_metadata
    WHERE     nnth_nth_theme_id = nth_theme_id
          AND nnth_nlt_id = nlt_id
          AND nth_base_table_theme IS NULL
          AND nth_feature_table = table_name
          AND nth_feature_shape_column = column_name
          AND nlt_gty_type IS NULL;