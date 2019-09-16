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
    PCT_MEDIAN,
    SLD_WORKING_GEOMETRY
)
BEQUEATH DEFINER
AS
    SELECT --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_batch_accuracy.vw-arc   1.4   Sep 16 2019 16:20:14   Rob.Coupe  $
    --       Module Name      : $Workfile:   v_sdl_batch_accuracy.vw  $
    --       Date into PVCS   : $Date:   Sep 16 2019 16:20:14  $
    --       Date fetched Out : $Modtime:   Sep 16 2019 16:19:18  $
    --       PVCS Version     : $Revision:   1.4  $
    --
    --   Author : R.A. Coupe
    --
    --   A view showing load data within an SDL load batch supplemented by
	--   a measure of the spatial intersection with existing network.
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
           --
             slga_id,
             sld_sfs_id,
             sld_id,
             a.slga_buffer_size,
             nvl(slga_pct_inside,-1),
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
                 median_accuracy,
             sld_working_geometry
        FROM sdl_geom_accuracy a, sdl_load_data
       WHERE sld_key = slga_sld_key (+) AND slga_datum_id IS NULL
    ORDER BY sld_id, slga_buffer_size;

