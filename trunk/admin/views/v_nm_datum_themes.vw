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
   SELECT -----------------------------------------------------------------------------
                                                                            --
                                                      --   SCCS Identifiers :-
                                                                            --
           --       sccsid           : @(#)v_nm_net_themes_all.vw 1.2 03/07/06
                            --       Module Name      : v_nm_net_themes_all.vw
                                 --       Date into SCCS   : 06/03/07 17:19:49
                                 --       Date fetched Out : 07/06/13 17:08:38
                                               --       SCCS Version     : 1.2
                                                                            --
 -----------------------------------------------------------------------------
                                  --  Copyright (c) exor corporation ltd, 2006
 -----------------------------------------------------------------------------
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
   