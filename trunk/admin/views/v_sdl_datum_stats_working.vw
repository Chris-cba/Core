CREATE OR REPLACE FORCE VIEW V_SDL_DATUM_STATS_WORKING
(
    SLD_KEY,
    DATUM_ID,
    BUFFER_SIZE,
    PCTAGE_ACCURACY,
    MIN_DIST,
    MAX_DIST
)
BEQUEATH DEFINER
AS
    SELECT --   PVCS Identifiers :-
           --
           --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_datum_stats_working.vw-arc   1.0   Sep 18 2019 16:42:12   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_sdl_datum_stats_working.vw  $
           --       Date into PVCS   : $Date:   Sep 18 2019 16:42:12  $
           --       Date fetched Out : $Modtime:   Sep 18 2019 16:41:08  $
           --       PVCS Version     : $Revision:   1.0  $
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
           sld_key,
           datum_id,
           TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'SDL_BUFFER_SIZE'))
               buffer_size,
           pctage_accuracy,
           min_dist,
           max_dist
      FROM (  SELECT sld_key,
                     datum_id,
                     MIN (dist_from)                            min_dist,
                     MAX (dist_from)                            max_dist,
                     TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'SDL_BUFFER_SIZE')),
                     SUM (intsct_length) / load_length * 100    pctage_accuracy
                FROM (SELECT sld_key,
                             datum_id,
                             ne_id,
                             SDO_GEOM.sdo_distance (nw_geom,
                                                    load_geom,
                                                    0.005,
                                                    'unit=M')
                                 dist_from,
                             TO_NUMBER (
                                 SYS_CONTEXT ('NM3SQL', 'SDL_BUFFER_SIZE')),
                             SDO_GEOM.sdo_length (
                                 SDO_GEOM.sdo_intersection (
                                     SDO_LRS.convert_to_std_geom (nw_geom),
                                     buffer_geom,
                                     0.005),
                                 0.005,
                                 'unit=M')
                                 intsct_length,
                             SDO_GEOM.sdo_length (load_geom, 0.005, 'unit=M')
                                 load_length
                        FROM (SELECT d.sld_key,
                                     datum_id,
                                     n.ne_id,
                                     TO_NUMBER (
                                         SYS_CONTEXT ('NM3SQL',
                                                      'SDL_BUFFER_SIZE')),
                                     geoloc
                                         nw_geom,
                                     d.geom
                                         load_geom,
                                     SDO_GEOM.sdo_buffer (
                                         d.geom,
                                         TO_NUMBER (
                                             SYS_CONTEXT ('NM3SQL',
                                                          'SDL_BUFFER_SIZE')),
                                         0.005,
                                         'unit=M')
                                         buffer_geom
                                FROM V_LB_NLT_GEOMETRY2 n,
                                     sdl_wip_datums    d,
                                     nm_elements       e
                               WHERE     d.batch_id =
                                         TO_NUMBER (
                                             SYS_CONTEXT ('NM3SQL',
                                                          'SDL_BATCH_ID'))
                                     AND e.ne_id = n.ne_id
                                     AND d.swd_id =
                                         NVL (
                                             TO_NUMBER (
                                                 SYS_CONTEXT ('NM3SQL',
                                                              'SDL_SWD_ID')),
                                             d.swd_id)
                                     --                                             AND d.DATUM_ID =
                                     --                                                 NVL (p_datum_id, d.DATUM_ID)
                                     AND sdo_relate (geoloc,
                                                     SDO_GEOM.sdo_buffer (
                                                         d.geom,
                                                         TO_NUMBER (
                                                             SYS_CONTEXT (
                                                                 'NM3SQL',
                                                                 'SDL_BUFFER_SIZE')),
                                                         0.005,
                                                         'unit=M'),
                                                     'mask=anyinteract') =
                                         'TRUE'))
            GROUP BY sld_key, datum_id, load_length);
