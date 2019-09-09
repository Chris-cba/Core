CREATE OR REPLACE FORCE VIEW V_SDL_PLINE_STATS
(
    ID,
    batch_id,
    SLD_KEY,
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
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_pline_stats.vw-arc   1.0   Sep 09 2019 16:45:24   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_pline_stats.vw  $
           --       Date into PVCS   : $Date:   Sep 09 2019 16:45:24  $
           --       Date fetched Out : $Modtime:   Sep 09 2019 16:44:14  $
           --       PVCS Version     : $Revision:   1.0  $
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
           slps_pline_id             pline_id,
           sld_sfs_id                batch_id,
           slga_sld_key              sld_key,
           slga_datum_id             datum_id,
           slga_buffer_size          buffer_size,
           slps_pline_segment_id     segment_id,
           slps_pct_accuracy         accuracy,
           slps_pline_geometry       geom
      FROM sdl_pline_statistics, sdl_geom_accuracy, sdl_load_data
     WHERE slps_slga_id = slga_id
     and slga_sld_key = sld_key
     and sld_sfs_id = nvl(to_number(sys_context('NM3SQL', 'SDLCTX_SFS_ID')),sld_sfs_id)
     
select sys_context('NM3SQL', 'SDLCTX_SFS_ID') from dual

begin
nm3ctx.set_context('SDLCTX_SFS_ID', '4');
end ;


select * from V_SDL_PLINE_STATS_nth where batch_id = 4