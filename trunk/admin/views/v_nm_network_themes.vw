CREATE OR REPLACE FORCE VIEW HIGHWAYS.V_NM_NETWORK_THEMES
(
   THEME_TYPE,
   NT_TYPE,
   GTY_TYPE,
   NTH_THEME_ID,
   NTH_FEATURE_TABLE,
   NTH_FEATURE_SHAPE_COLUMN,
   NTH_FEATURE_PK_COLUMN,
   NTH_FEATURE_FK_COLUMN,
   NTH_START_DATE_COLUMN,
   NTH_END_DATE_COLUMN,
   NTH_USE_HISTORY,
   NTH_BASE_TABLE_THEME,
   NTH_UPDATE_ON_EDIT
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_network_themes.vw-arc   1.0   May 05 2015 12:15:42   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_network_themes.vw  $
--       Date into PVCS   : $Date:   May 05 2015 12:15:42  $
--       Date fetched Out : $Modtime:   May 05 2015 12:14:46  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   A view to derive the set of network related themes.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--  
          case ngt_sub_group_allowed
          when 'Y' then 'Group of Groups'
          else 'Non-Linear Group'
          end theme_type,
          nat_nt_type nt_type,
          nat_gty_group_type gty_type,
          nth_theme_id,
          nth_feature_table,
          nth_feature_shape_column,
          nth_feature_pk_column,
          nth_feature_fk_column,
          nth_start_date_column,
          nth_end_date_column,
          nth_use_history,
          nth_base_table_theme,
          nth_update_on_edit
     FROM nm_themes_all, nm_area_themes, nm_area_types, nm_group_types
    WHERE     nath_nth_theme_id = nth_theme_id
          AND nath_nat_id = nat_id
          and nat_gty_group_type = ngt_group_type
          AND nat_shape_type = 'TRACED'
          AND CASE
                 WHEN nth_use_history = 'Y' AND nth_base_table_theme IS NULL
                 THEN
                    1
                 WHEN     nth_use_history = 'Y'
                      AND nth_base_table_theme IS NOT NULL
                 THEN
                    0
                 WHEN nth_use_history = 'N'
                 THEN
                    1
                 ELSE
                    0
              END = 1
   UNION ALL
   SELECT 'Linear'||
          case nlt_g_i_d 
             when 'D' then ' Datum'
             when 'G' then ' Group'
          end theme_type,
          nlt_nt_type,
          nlt_gty_type,
          nth_theme_id,
          nth_feature_table,
          nth_feature_shape_column,
          nth_feature_pk_column,
          nth_feature_fk_column,
          nth_start_date_column,
          nth_end_date_column,
          nth_use_history,
          nth_base_table_theme,
          nth_update_on_edit
     FROM nm_themes_all, nm_nw_themes, nm_linear_types
    WHERE     nnth_nth_theme_id = nth_theme_id
          AND nnth_nlt_id = nlt_id
          AND CASE
                 WHEN nth_use_history = 'Y' AND nth_base_table_theme IS NULL
                 THEN
                    1
                 WHEN     nth_use_history = 'Y'
                      AND nth_base_table_theme IS NOT NULL
                 THEN
                    0
                 WHEN nth_use_history = 'N'
                 THEN
                    1
                 ELSE
                    0
              END = 1;
