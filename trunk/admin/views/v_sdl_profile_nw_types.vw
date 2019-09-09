CREATE OR REPLACE VIEW v_sdl_profile_nw_types
(
    SP_ID,
    SP_NAME,
    SP_NLT_ID,
    NLT_G_I_D,
    PROFILE_NT_TYPE,
    PROFILE_GROUP_TYPE,
    DATUM_NT_TYPE,
    NODE_TYPE,
    SPATIAL_TABLE,
    SPATIAL_PK_COLUMN,
    GEOMETRY_COLUMN
)
BEQUEATH DEFINER
AS
    SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_profile_nw_types.vw-arc   1.0   Sep 09 2019 16:52:50   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_profile_nw_types.vw  $
           --       Date into PVCS   : $Date:   Sep 09 2019 16:52:50  $
           --       Date fetched Out : $Modtime:   Sep 09 2019 16:51:26  $
           --       PVCS Version     : $Revision:   1.0  $
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
           nt_node_type                 node_type,
           nth_feature_table            spatial_table,
           nth_feature_pk_column        spatial_pk_column,
           nth_feature_shape_column     geometry_column
      FROM sdl_profiles,
           nm_linear_types  g,
           nm_nt_groupings,
           nm_types,
           nm_themes_all,
           nm_nw_themes,
           nm_linear_types  d
     WHERE     sp_nlt_id = g.nlt_id
           AND g.nlt_gty_type = nng_group_type
           AND nt_type = nng_nt_type
           AND nth_theme_id = nnth_nth_theme_id
           AND nnth_nlt_id = d.nlt_id
           AND d.nlt_g_i_d = 'D'
           AND d.nlt_nt_type = nt_type
           AND nth_base_table_theme IS NULL
    UNION ALL
    SELECT sp_id,
           sp_name,
           sp_nlt_id,
           nlt_g_i_d,
           nlt_nt_type,
           nlt_gty_type,
           nlt_nt_type,
           nt_node_type,
           nth_feature_table,
           nth_feature_pk_column,
           nth_feature_shape_column
      FROM sdl_profiles,
           nm_linear_types,
           nm_types,
           nm_themes_all,
           nm_nw_themes
     WHERE     sp_nlt_id = nlt_id
           AND nlt_gty_type IS NULL
           AND nlt_nt_type = nt_type
           AND nth_theme_id = nnth_nth_theme_id
           AND nnth_nlt_id = nlt_id
           AND nth_base_table_theme IS NULL;
