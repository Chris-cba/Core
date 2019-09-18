CREATE OR REPLACE FORCE VIEW V_SDL_DATUM_ACCURACY
(
    SWD_ID,
    BATCH_ID,
    SLD_KEY,
    DATUM_ID,
    PCT_MATCH,
    GEOM
)
BEQUEATH DEFINER
AS
    SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_datum_accuracy.vw-arc   1.2   Sep 18 2019 08:02:34   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_datum_accuracy.vw  $
           --       Date into PVCS   : $Date:   Sep 18 2019 08:02:34  $
           --       Date fetched Out : $Modtime:   Sep 18 2019 08:01:46  $
           --       PVCS Version     : $Revision:   1.2  $
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
           --
          swd_id,
          batch_id,
          sld_key,
          datum_id,
          NVL (pct_match, -1),
          geom
     FROM sdl_wip_datums;
