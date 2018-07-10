CREATE OR REPLACE VIEW nm_locations_full
AS
    SELECT                                                                  --
                                                      --   SCCS Identifiers :-
                                                                            --
                   --       sccsid           : @(#)nm_locations_full.vw 1.3 03/24/05
                                    --       Module Name      : nm_locations_full.vw
                                 --       Date into SCCS   : 05/03/24 16:15:06
                                 --       Date fetched Out : 07/06/13 17:08:05
                                               --       SCCS Version     : 1.3
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