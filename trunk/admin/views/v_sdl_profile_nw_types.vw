CREATE OR REPLACE VIEW v_sdl_profile_nw_types
(
    SP_ID,
    SP_NAME,
    SP_NLT_ID,
    NLT_G_I_D,
    PROFILE_NT_TYPE,
    PROFILE_GROUP_TYPE,
    PROFILE_GROUP_UNIT_ID,
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
    SELECT /*
           --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_profile_nw_types.vw-arc   1.2   Jan 20 2020 10:34:54   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_profile_nw_types.vw  $
           --       Date into PVCS   : $Date:   Jan 20 2020 10:34:54  $
           --       Date fetched Out : $Modtime:   Jan 20 2020 10:34:28  $
           --       PVCS Version     : $Revision:   1.2  $
           --
           --   Author : R.A. Coupe
           --
           --   A view to allow easy access to the metadata required for a specific network type.
           --   Includes table name of spatial data etc.
           --
           -----------------------------------------------------------------------------
           -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
           ----------------------------------------------------------------------------
          */
           sp_id,
           sp_name,
           sp_nlt_id,
           g.nlt_g_i_d,
           g.nlt_nt_type                profile_nt_type,
           g.nlt_gty_type               profile_group_type,
           g.nlt_units,
           nng_nt_type                  datum_nt_type,
           d.nlt_units,
           UPPER (un_unit_name),
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
           nm_linear_types  d,
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
           NULL,
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

COMMENT ON TABLE v_sdl_profile_nw_types IS
    'A view to profile profile-based metadata such as network types and units';

COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.SP_ID IS
    'The profile ID to which the metadata relates';


COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.SP_NAME IS
    'The name of profile to which the metadata relates';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.SP_NLT_ID IS
    'The linear-type of the network described by the profile';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.NLT_G_I_D IS
    'A flag to indicate if the network of the profile is a Datum or Group';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.PROFILE_NT_TYPE IS
    'The network type of the profile';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.PROFILE_GROUP_TYPE IS
    'The group type of the profile network (if a group)';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.PROFILE_GROUP_UNIT_ID IS
    'The unit ID of the group based network (measure)';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.DATUM_NT_TYPE IS
    'The datum type either of the profile or the datum type to be derived from the profile';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.DATUM_UNIT_ID IS
    'The unit ID of the datum type';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.DATUM_UNIT_NAME IS
    'The name of the unit of measure associated with the datum type';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.NODE_TYPE IS
    'The node type related to the datum derived or defined by the profile';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.SPATIAL_TABLE IS
    'The spatial table of the datum network';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.SPATIAL_PK_COLUMN IS
    'The primary key column of the datum spatial table';
COMMENT ON COLUMN V_SDL_PROFILE_NW_TYPES.GEOMETRY_COLUMN IS
    'The geometry column of the datum patial table';