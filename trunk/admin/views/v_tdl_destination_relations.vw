CREATE OR REPLACE FORCE VIEW V_TDL_DESTINATION_RELATIONS
(
    SP_ID,
    PARENT_SDH_ID,
    PARENT_DESTINATION_TYPE,
    PARENT_SHORT_NAME,
    CHILD_SDH_ID,
    CHILD_DESTINATION_TYPE,
    CHILD_SHORT_NAME,
    PARENT_SAM_ID,
    PARENT_VIEW_COLUMN_NAME,
    CHILD_SAM_ID,
    CHILD_VIEW_COLUMN_NAME,
    CHILD_TO_PARENT_KEY_COLUMN,
    PARENT_FORMULA,
    CHILD_FORMULA,
    SEQUENCE_NAME
)
BEQUEATH DEFINER
AS
    SELECT /*
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_tdl_destination_relations.vw-arc   1.0   Oct 13 2020 20:46:06   Rob.Coupe  $
   --       Module Name      : $Workfile:   v_tdl_destination_relations.vw  $
   --       Date into PVCS   : $Date:   Oct 13 2020 20:46:06  $
   --       Date fetched Out : $Modtime:   Oct 13 2020 20:45:36  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : Rob Coupe
   --
   --   A view to link the destinations of a load profile by their attribute relationships
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --    
*/        
           sdh_p.sdh_sp_id,
           sdh_p.sdh_id,
           sdh_p.sdh_destination_type,
           nld_p.nld_table_short_name,
           sdh_c.sdh_id,
           sdh_c.sdh_destination_type,
           nld_c.nld_table_short_name,
           sam_p.sam_id,
           sam_p.sam_view_column_name,
           sam_c.sam_id,
           sam_c.sam_view_column_name,
           sam_p.sam_attribute_formula,
           sam_c.sam_attribute_formula,
           SUBSTR (
               sam_c.sam_attribute_formula,
                 INSTR (sam_c.sam_attribute_formula,
                        nld_p.nld_table_short_name || '.')
               + LENGTH (nld_p.nld_table_short_name || '.'),
               LENGTH (sam_c.sam_attribute_formula)),
           (SELECT sdsc_sequence_name
              FROM V_SDL_DESTINATION_SEQUENCE_COLUMNS
             WHERE     sdsc_sam_id = sam_p.sam_id
                   AND sdsc_sp_id = sdh_p.sdh_sp_id
                   AND sdsc_sdh_id = sdh_p.sdh_id)
      FROM sdl_destination_header  sdh_p,
           nm_load_destinations    nld_p,
           sdl_destination_header  sdh_c,
           nm_load_destinations    nld_c,
           sdl_attribute_mapping   sam_p,
           sdl_attribute_mapping   sam_c
     WHERE     sdh_p.sdh_nld_id = nld_p.nld_id
           AND sdh_c.sdh_nld_id = nld_c.nld_id
           AND sdh_p.sdh_sp_id = sdh_c.sdh_sp_id
           AND sam_p.sam_sdh_id = sdh_p.sdh_id
           AND sam_c.sam_sdh_id = sdh_c.sdh_id
           AND sam_c.sam_attribute_formula LIKE
                   nld_p.nld_table_short_name || '%'
           AND sam_p.sam_view_column_name =
               SUBSTR (
                   sam_c.sam_attribute_formula,
                     INSTR (sam_c.sam_attribute_formula,
                            nld_p.nld_table_short_name || '.')
                   + LENGTH (nld_p.nld_table_short_name || '.'),
                   LENGTH (sam_c.sam_attribute_formula));
