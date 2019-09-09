/* Formatted on 09/09/2019 16:38:03 (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW V_SDL_NODE_USAGES
(
    SWD_ID,
    START_NODE,
    END_NODE
)
BEQUEATH DEFINER
AS
      SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_node_usages.vw-arc   1.0   Sep 09 2019 16:40:26   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_node_usages.vw  $
           --       Date into PVCS   : $Date:   Sep 09 2019 16:40:26  $
           --       Date fetched Out : $Modtime:   Sep 09 2019 16:39:40  $
           --       PVCS Version     : $Revision:   1.0  $
           --
           --   Author : R.A. Coupe
           --
           --   A view which joins the work-in-progress nodes and the new netwrk data
           --   in the load repository
           --
           -----------------------------------------------------------------------------
           -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
           ----------------------------------------------------------------------------       
             swd_id, 
             start_node, 
             end_node
        FROM (SELECT swd_id,
                     FIRST_VALUE (hashcode)
                         OVER (PARTITION BY swd_id ORDER BY node_type DESC)
                         start_node,
                     FIRST_VALUE (hashcode)
                         OVER (PARTITION BY swd_id ORDER BY node_type ASC)
                         end_node
                FROM sdl_wip_datum_nodes d)
    GROUP BY swd_id, start_node, end_node;