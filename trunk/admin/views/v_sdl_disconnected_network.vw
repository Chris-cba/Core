CREATE OR REPLACE FORCE VIEW v_sdl_disconnected_network
(
    BATCH_ID,
    SWD_ID,
    SLD_KEY,
    DATUM_ID,
    NODE_TYPE,
    NODE_ID,
    NODE_GEOM,
    DIST
)
BEQUEATH DEFINER
AS
   SELECT --   PVCS Identifiers :-
                                                                            --
          --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_disconnected_network.vw-arc   1.1   Jan 17 2020 10:38:12   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_sdl_disconnected_network.vw  $
          --       Date into PVCS   : $Date:   Jan 17 2020 10:38:12  $
          --       Date fetched Out : $Modtime:   Jan 17 2020 10:37:28  $
          --       PVCS Version     : $Revision:   1.1  $
          --
          --   Author : R.A. Coupe
                                                                            --
          --   A view which provides a list of datums that are spatially disconected from the nodes that underpin them
          --   It is used in the cleanup section which provides snapping of terminating vertex. .
                                                                            --
          -----------------------------------------------------------------------------
          -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
          ----------------------------------------------------------------------------

             "BATCH_ID",
             "SWD_ID",
             "SLD_KEY",
             "DATUM_ID",
             "NODE_TYPE",
             "NODE_ID",
             "NODE_GEOM",
             "DIST"
        FROM (SELECT batch_id,
                     swd_id,
                     sld_key,
                     datum_id,
                     node_type,
                     node_id,
                     node_geom,
                     SDO_GEOM.sdo_distance (terminal, node_geom)     dist
                FROM (SELECT d.batch_id,
                             d.swd_id,
                             d.sld_key,
                             d.datum_id,
                             nu.node_type,
                             node_id,
                             CASE nu.node_type
                                 WHEN 'S'
                                 THEN
                                     nm_sdo.geom_segment_start_pt (d.geom)
                                 WHEN 'E'
                                 THEN
                                     nm_sdo.geom_segment_end_pt (d.geom)
                             END    terminal,
                             n.node_geom
                        FROM sdl_wip_datum_nodes nu,
                             sdl_wip_datums     d,
                             sdl_wip_nodes      n
                       WHERE d.swd_id = nu.swd_id AND nu.hashcode = n.hashcode))
       WHERE dist >
             (SELECT t.sdo_tolerance
                FROM user_sdo_geom_metadata, TABLE (diminfo) t
               WHERE     table_name = 'SDL_LOAD_DATA'
                     AND column_name = 'SLD_WORKING_GEOMETRY'
                     AND ROWNUM = 1)
    ORDER BY dist;
/    

comment on table V_SDL_DISCONNECTED_NETWORK is 'A view which provides a list of datums that are spatially disconected from the nodes that underpin them';


comment on column V_SDL_DISCONNECTED_NETWORK.BATCH_ID is 'The batch containing the disconnected network';

comment on column V_SDL_DISCONNECTED_NETWORK.SWD_ID is 'The key to the datum which is doconnected';

comment on column V_SDL_DISCONNECTED_NETWORK.SLD_KEY is 'The load geometry identifier from whch the datum was generated';

comment on column V_SDL_DISCONNECTED_NETWORK.DATUM_ID is 'The segment identifier within the load geometry';
  
comment on column V_SDL_DISCONNECTED_NETWORK.NODE_TYPE is 'The type of node which is logically connected to the datum';

comment on column V_SDL_DISCONNECTED_NETWORK.NODE_ID is 'The node Id which is logically connected to the datum';

comment on column V_SDL_DISCONNECTED_NETWORK.NODE_GEOM is 'The geometry of the node';

comment on column V_SDL_DISCONNECTED_NETWORK.DIST is 'The distance between the datum (usually the terminal vertex) and the node geometry';
 