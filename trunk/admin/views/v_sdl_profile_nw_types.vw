CREATE OR REPLACE VIEW v_sdl_profile_nw_types
(
    SP_ID,
    SP_NAME,
    SP_NLT_ID,
    NLT_G_I_D,
    PROFILE_NT_TYPE,
    PROFILE_GROUP_TYPE,
    DATUM_NT_TYPE,
    DATUM_UNIT_ID,
    DATUM_UNIT_NAME,
    NODE_TYPE,
    SPATIAL_TABLE,
    SPATIAL_PK_COLUMN,
    GEOMETRY_COLUMN
)
BEQUEATH DEFINER
AS
    SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_profile_nw_types.vw-arc   1.1   Oct 11 2019 12:46:52   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_profile_nw_types.vw  $
           --       Date into PVCS   : $Date:   Oct 11 2019 12:46:52  $
           --       Date fetched Out : $Modtime:   Sep 25 2019 17:20:02  $
           --       PVCS Version     : $Revision:   1.1  $
           --
           --   Author : R.A. Coupe
           --
           --   A view to allow easy access to the metadata required for a specific network type.
           --   Includes table name of spatial data etc. 
           --
           -----------------------------------------------------------------------------
           -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
           ---------------------------------------------------------------------------- 
          sp_id,
          sp_name,
          sp_nlt_id,
          g.nlt_g_i_d,
          g.nlt_nt_type                profile_nt_type,
          g.nlt_gty_type               profile_group_type,
          nng_nt_type                  datum_nt_type,
          d.nlt_units,
          UPPER (un_unit_name),
          nt_node_type                 node_type,
          nth_feature_table            spatial_table,
          nth_feature_pk_column        spatial_pk_column,
          nth_feature_shape_column     geometry_column
     FROM sdl_profiles,
          nm_linear_types g,
          nm_nt_groupings,
          nm_types,
          nm_themes_all,
          nm_nw_themes,
          nm_linear_types d,
          nm_units
    WHERE     sp_nlt_id = g.nlt_id
          AND g.nlt_gty_type = nng_group_type
          AND nt_type = nng_nt_type
          AND nth_theme_id = nnth_nth_theme_id
          AND nnth_nlt_id = d.nlt_id
          AND d.nlt_g_i_d = 'D'
          AND d.nlt_nt_type = nt_type
          AND nth_base_table_theme IS NULL
          AND d.nlt_units = un_unit_id
    UNION ALL
    SELECT sp_id,
           sp_name,
           sp_nlt_id,
           nlt_g_i_d,
           nlt_nt_type,
           nlt_gty_type,
           nlt_nt_type,
           nlt_units,
           UPPER (un_unit_name),
           nt_node_type,
           nth_feature_table,
           nth_feature_pk_column,
           nth_feature_shape_column
      FROM sdl_profiles,
           nm_linear_types,
           nm_types,
           nm_themes_all,
           nm_nw_themes,
           nm_units
     WHERE     sp_nlt_id = nlt_id
           AND nlt_gty_type IS NULL
           AND nlt_nt_type = nt_type
           AND nth_theme_id = nnth_nth_theme_id
           AND nnth_nlt_id = nlt_id
           AND nth_base_table_theme IS NULL
           AND nlt_units = un_unit_id;
