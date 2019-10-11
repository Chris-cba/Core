 CREATE OR REPLACE FORCE VIEW V_SDL_PLINE_STATS
(
    ID,
    BATCH_ID,
    SLD_KEY,
    SWD_ID,
    DATUM_ID,
    BUFFER_SIZE,
    SEGMENT_ID,
    ACCURACY,
    GEOM
)
BEQUEATH DEFINER
AS
   SELECT --   PVCS Identifiers :-
                                                                            --
          --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_pline_stats.vw-arc   1.2   Oct 11 2019 13:05:18   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_sdl_pline_stats.vw  $
          --       Date into PVCS   : $Date:   Oct 11 2019 13:05:18  $
          --       Date fetched Out : $Modtime:   Oct 11 2019 13:03:30  $
          --       PVCS Version     : $Revision:   1.2  $
          --
          --   Author : R.A. Coupe
                                                                            --
          --   A view showing th elevel of matching between a record in thee SDL repository and
          --   existing network. This view uses results prepared at the individual polyline
          --   segment, i.e. from vertex to vertex.
                                                                            --
          -----------------------------------------------------------------------------
          -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
          ----------------------------------------------------------------------------
          slps_pline_id,
          batch_id,
          sld_key,
          datum_id,
          slps_buffer,
          slps_swd_id,
          slps_pline_segment_id,
          slps_pct_accuracy,
          slps_pline_geometry
     FROM sdl_pline_statistics, sdl_wip_datums
    WHERE slps_swd_id = swd_id;
