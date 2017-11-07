CREATE OR REPLACE FORCE VIEW V_NM_DATUM_THEMES
(
   NTH_THEME_ID,
   NTH_THEME_NAME,
   NLT_ID,
   NLT_UNITS,
   NT_TYPE,
   nth_feature_table,
   nth_feature_pk_column,
   nth_feature_shape_column
)
AS
   SELECT -------------------------------------------------------------------------
            --   PVCS Identifiers :-
            --
            --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_datum_themes.vw-arc   1.1   Nov 07 2017 12:01:04   Rob.Coupe  $
            --       Module Name      : $Workfile:   v_nm_datum_themes.vw  $
            --       Date into PVCS   : $Date:   Nov 07 2017 12:01:04  $
            --       Date fetched Out : $Modtime:   Nov 07 2017 12:00:42  $
            --       Version          : $Revision:   1.1  $
            ------------------------------------------------------------------
            --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
            ------------------------------------------------------------------
            ----
   NTH_THEME_ID,
   NTH_THEME_NAME,
   NLT_ID,
   NLT_UNITS,
   NLT_NT_TYPE,
   nth_feature_table,
   nth_feature_pk_column,
   nth_feature_shape_column
    FROM nm_themes_all, nm_nw_themes, nm_linear_types
   WHERE nnth_nth_theme_id = nth_theme_id AND nnth_nlt_id = nlt_id
   and nth_base_table_theme is null
   and nlt_gty_type is NULL;
   