CREATE OR REPLACE VIEW nm_locations_full
AS
    SELECT
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/nm_locations_full.vw-arc   1.2   Jul 10 2018 15:09:32   Rob.Coupe  $
    --       Module Name      : $Workfile:   nm_locations_full.vw  $
    --       Date into PVCS   : $Date:   Jul 10 2018 15:09:32  $
    --       Date fetched Out : $Modtime:   Jul 10 2018 15:09:12  $
    --       PVCS Version     : $Revision:   1.2  $
    --
    --   Author : R.A. Coupe
    --
    --   Location Bridge union view of main locations data
    --
 -----------------------------------------------------------------------------
    --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
 -----------------------------------------------------------------------------
                                                                            --
         nm_ne_id_in,
         nm_ne_id_of,
         nm_begin_mp,
         nm_end_mp,
         nm_obj_type,
         nm_type,
         nm_cardinality,
         nm_seg_no,
         nm_seq_no
    FROM nm_members
    UNION ALL
    SELECT nm_ne_id_in,
           nm_ne_id_of,
           nm_begin_mp,
           nm_end_mp,
           nm_obj_type,
           nm_type,
           nm_dir_flag,
           nm_seg_no,
           nm_seq_no
      FROM nm_locations
/      