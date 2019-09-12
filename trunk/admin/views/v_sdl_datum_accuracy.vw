CREATE OR REPLACE FORCE VIEW V_SDL_DATUM_ACCURACY
(
    SWD_ID,
    BATCH_ID,
    SLD_KEY,
    SLGA_ID,
    SLGA_DATUM_ID,
    SLGA_PCT_INSIDE,
    SLGA_MEAN,
    SLGA_SD,
    GEOM
)
BEQUEATH DEFINER
AS
    SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_datum_accuracy.vw-arc   1.1   Sep 12 2019 12:44:42   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_datum_accuracy.vw  $
           --       Date into PVCS   : $Date:   Sep 12 2019 12:44:42  $
           --       Date fetched Out : $Modtime:   Sep 12 2019 12:43:56  $
           --       PVCS Version     : $Revision:   1.1  $
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
           swd_id,
           batch_id,
           sld_key,
           slga_id,
           slga_datum_id,
           nvl(slga_pct_inside,-1),
           slga_mean,
           slga_sd,
           geom
      FROM sdl_geom_accuracy, sdl_wip_datums
     WHERE slga_datum_id (+) = datum_id 
	 AND slga_sld_key (+) = sld_key
	 and datum_id is NOT NULL;