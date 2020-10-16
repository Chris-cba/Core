CREATE OR REPLACE FORCE VIEW V_SDL_DESTINATION_SEQUENCE_COLUMNS
(
    SDSC_SP_ID,
    SDSC_SDH_ID,
    SDSC_SDH_TYPE,
    SDSC_SAM_ID,
    SDSC_SEQUENCE_NAME
)
BEQUEATH DEFINER
AS
    SELECT /*
       --
       -----------------------------------------------------------------------------
       --
       --   PVCS Identifiers :-
       --
       --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_destination_sequence_columns.vw-arc   1.2   Oct 16 2020 11:03:36   Rob.Coupe  $
       --       Module Name      : $Workfile:   v_sdl_destination_sequence_columns.vw  $
       --       Date into PVCS   : $Date:   Oct 16 2020 11:03:36  $
       --       Date fetched Out : $Modtime:   Oct 16 2020 11:03:02  $
       --       PVCS Version     : $Revision:   1.2  $
       --
       --   Author : Rob Coupe
       --
       --   A view to order the sequence of load destinations by reference to the dependencies
       --
       -----------------------------------------------------------------------------
       --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
       -----------------------------------------------------------------------------
       --
    */
           sam_sp_id,
           sam_sdh_id,
           sdh_destination_type,
           sam_id,
           sam_attribute_formula||sam_default_value
      FROM sdl_attribute_mapping, sdl_destination_header
     WHERE     UPPER (sam_attribute_formula || sam_default_value) LIKE
                   '%NEXT%'
           AND sam_sdh_id = sdh_id;


												