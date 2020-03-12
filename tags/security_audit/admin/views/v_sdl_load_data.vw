create or replace view v_sdl_load_data
as 
    SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_load_data.vw-arc   1.1   Mar 12 2020 08:35:16   Vikas.Mhetre  $
           --       Module Name      : $Workfile:   v_sdl_load_data.vw  $
           --       Date into PVCS   : $Date:   Mar 12 2020 08:35:16  $
           --       Date fetched Out : $Modtime:   Mar 12 2020 08:26:22  $
           --       PVCS Version     : $Revision:   1.1  $
           --
           --   Author : R.A. Coupe
           --
           --   A view showing the working geometry of original load data within an SDL load batch.
           --
           -----------------------------------------------------------------------------
           -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
           ----------------------------------------------------------------------------
           --
     sld_key, sld_id, sld_sfs_id batch_id, sld_working_geometry 
     FROM sdl_load_data 
     where sld_sfs_id =
               NVL (TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'SDLCTX_SFS_ID')),
                    sld_sfs_id);
