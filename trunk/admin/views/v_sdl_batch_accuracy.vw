CREATE OR REPLACE FORCE VIEW V_SDL_BATCH_ACCURACY
(
    SLGA_ID,
    BATCH_ID,
    RECORD_ID,
    BUFFER_SIZE,
    PCT_INSIDE,
    MIN_OFFSET,
    MAX_OFFSET,
    PCT_STD_DEV,
    PCT_AVERAGE,
    PCT_MEDIAN
)
BEQUEATH DEFINER
AS
    SELECT --
           --   SCCS Identifiers :-
           --
           --       sccsid           : @(#)nm_elements.vw 1.3 03/24/05
           --       Module Name      : nm_elements.vw
           --       Date into SCCS   : 05/03/24 16:15:06
           --       Date fetched Out : 07/06/13 17:08:05
           --       SCCS Version     : 1.3
           --
           -----------------------------------------------------------------------------
           --   Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
           -----------------------------------------------------------------------------
           --
             slga_id,
             sld_sfs_id,
             sld_id,
             a.slga_buffer_size,
             slga_pct_inside,
             slga_min_offset,
             slga_max_offset,
             STDDEV (LEAST (slga_pct_inside, 100))
                 OVER (PARTITION BY sld_sfs_id, slga_buffer_size)
                 std_dev,
             AVG (LEAST (slga_pct_inside, 100))
                 OVER (PARTITION BY sld_sfs_id, slga_buffer_size)
                 average_accuracy,
             MEDIAN (LEAST (slga_pct_inside, 100))
                 OVER (PARTITION BY sld_sfs_id, slga_buffer_size)
                 median_accuracy
        FROM sdl_geom_accuracy a, sdl_load_data
       WHERE sld_key = slga_sld_key AND slga_datum_id IS NULL
    ORDER BY sld_id, slga_buffer_size;

	
