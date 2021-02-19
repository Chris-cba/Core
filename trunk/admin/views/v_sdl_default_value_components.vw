CREATE OR REPLACE FORCE VIEW V_SDL_DEFAULT_VALUE_COMPONENTS
(
    SAM_SP_ID,
    SAM_ID,
    SAM_COL_ID,
    SAM_NE_COLUMN_NAME,
    SAM_FILE_ATTRIBUTE_NAME,
    SWAP_COL_NAME,
    SAM_DEFAULT_VALUE,
    C_START,
    C_END,
    STR
)
BEQUEATH DEFINER
AS
    SELECT /*
        --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_default_value_components.vw-arc   1.0   Feb 19 2021 19:09:00   Rob.Coupe  $
    --       Module Name      : $Workfile:   v_sdl_default_value_components.vw  $
    --       Date into PVCS   : $Date:   Feb 19 2021 19:09:00  $
    --       Date fetched Out : $Modtime:   Feb 19 2021 16:36:48  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : R.A. Coupe
    --
    --   A view to organise the breakdown of the sdl attribute default value into components used in name adjustments.
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this view is to assist in the swapping of file-based attributes coded in the attribute default values
    */
           dc."SAM_SP_ID",
           dc."SAM_ID",
           dc."SAM_COL_ID",
           dc."SAM_NE_COLUMN_NAME",
           dc."SAM_FILE_ATTRIBUTE_NAME",
           dc."SWAP_COL_NAME",
           dc."SAM_DEFAULT_VALUE",
           dc."C_START",
           dc."C_END",
           dc."STR"
      FROM (SELECT m1.sam_sp_id,
                   m1.sam_id,
                   m1.sam_col_id,
                   upper(m1.sam_ne_column_name) sam_ne_column_name,
                   upper(m1.sam_file_attribute_name) sam_file_attribute_name,
                   'SLD_COL_' || TO_CHAR (m2.sam_col_id)     swap_col_name,
                   upper(m1.sam_default_value) sam_default_value ,
                   t.*
              FROM sdl_attribute_mapping                                  m1,
                   TABLE (xrc_get_substrings_regexp (sam_default_value))  t,
                   sdl_attribute_mapping                                  m2
             WHERE     m1.sam_sp_id = m2.sam_sp_id
                   AND str IS NOT NULL
                   AND upper(str) = upper(m2.sam_file_attribute_name)) dc
     WHERE sam_sp_id = 4;
