/* Formatted on 17/01/2020 13:11:31 (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW V_SDL_NEW_INTERSECTIONS
(
    BATCH_ID,
    NODE_ID,
    EXISTING_NODE_ID,
    DISTANCE_FROM,
    HASHCODE,
    SLD_KEY,
    NE_ID,
    MVALUE,
    NE_NT_TYPE,
    GEOM
)
BEQUEATH DEFINER
AS
    SELECT /*
               --   PVCS Identifiers :-
               --
               --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_new_intersections.vw-arc   1.1   Jan 17 2020 13:12:44   Rob.Coupe  $
               --       Module Name      : $Workfile:   v_sdl_new_intersections.vw  $
               --       Date into PVCS   : $Date:   Jan 17 2020 13:12:44  $
               --       Date fetched Out : $Modtime:   Jan 17 2020 13:11:58  $
               --       PVCS Version     : $Revision:   1.1  $
               --
               --   Author : R.A. Coupe
                                                                                       --
               --   A view which provides a list of existing network and SDL nodes which are spatially related.
               --   Can be used a means to identify existing netwoork which may need to be split at the new node.
                                                                                       --
             -----------------------------------------------------------------------------
             -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
             ----------------------------------------------------------------------------
           */
           n.batch_id,
           n.node_id,
           n.existing_node_id,
           n.distance_from,
           n.hashcode,
           g2.sld_key1,
           g2.ne_id,
           mvalue,
           g2.ne_nt_type,
           n.node_geom
      FROM (  SELECT g1.batch_id,
                     g1.sld_key1,
                     g1.ne_id,
                     mvalue,
                     g1.ne_nt_type,
                     a.hashcode
                FROM (SELECT g.*
                        FROM (SELECT p.batch_id,
                                     r_id,
                                     sld_key1,
                                     p.ne_id,
                                     ne_nt_type,
                                     --                     intsct_type,
                                     --                     terminal_type,
                                     SDO_LRS.find_measure (geoloc,
                                                           p.geom,
                                                           0.005)    mvalue
                                FROM SDL_WIP_INTSCT_GEOM p,
                                     v_lb_nlt_geometry2 s
                               WHERE p.ne_id IS NOT NULL --                                     AND p.batch_id = 4
                                                         AND s.ne_id = p.ne_id)
                             g,
                             nm_elements e
                       WHERE     g.ne_id = e.ne_id
                             AND ABS (mvalue) > 0.0005
                             AND ABS (mvalue - ne_length) > 0.0005) g1,
                     sdl_wip_pt_arrays a,
                     TABLE (ia)       t
               WHERE t.COLUMN_VALUE = r_id AND a.batch_id = g1.batch_id
            GROUP BY g1.batch_id,
                     sld_key1,
                     ne_id,
                     mvalue,
                     ne_nt_type,
                     hashcode) g2,
           sdl_wip_nodes  n
     WHERE g2.hashcode = n.hashcode;
/



COMMENT ON TABLE V_SDL_NEW_INTERSECTIONS IS
    'A view which provides a list of existing network and SDL nodes which are spatially related';


COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.BATCH_ID IS
    'The batch ID which is responsible for the creation of the node';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.NODE_ID IS
    'The SDL WIP node created within the batch whch spatially relates to existing network';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.EXISTING_NODE_ID IS
    'The existing node id which is close to or has been created as a result of the transfer of the WIP node ';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.DISTANCE_FROM IS
    'The distance from the SDL WIP node to the existing network node';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.HASHCODE IS
    'An internal code used to map the node to other data in the SDL tables';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.SLD_KEY IS
    'The SLD_KEY of the load recrd in the batch which gives rise to the SDL WIP node';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.NE_ID IS
    'The NE_ID of existing network which is impacted by the new node';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.MVALUE IS
    'The measure along the existing network element at which the SDL WIP node is located';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.NE_NT_TYPE IS
    'The network type of the network element';

COMMENT ON COLUMN V_SDL_NEW_INTERSECTIONS.GEOM IS
    'The geometry of the SDL WIP node';
	