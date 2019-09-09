CREATE OR REPLACE VIEW v_sdl_wip_nodes
(
    node_id,
    batch_id,
    node_geom,
    existing_node_id,
    distance_from
)
AS
    SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_wip_nodes.vw-arc   1.1   Sep 09 2019 16:59:46   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_wip_nodes.vw  $
           --       Date into PVCS   : $Date:   Sep 09 2019 16:59:46  $
           --       Date fetched Out : $Modtime:   Sep 09 2019 16:59:28  $
           --       PVCS Version     : $Revision:   1.1  $
           --
           --   Author : R.A. Coupe
           --
           --   A view showing the work-in-progress nodes of the SDL repository.
           --   It is context sensitive by restricting data to a psecific batch.
           -----------------------------------------------------------------------------
           -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
           ---------------------------------------------------------------------------- 
           node_id,
           batch_id,
           node_geom,
           existing_node_id,
           nvl(distance_from, -1)
      FROM sdl_wip_nodes
     WHERE batch_id =
           NVL (TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'SDLCTX_SFS_ID')),
                batch_id);
