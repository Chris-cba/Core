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
    SELECT   /*
    --   PVCS Identifiers :-
                                                                            --
         --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_datum_stats_working.vw-arc   1.2   Nov 03 2020 13:18:24   Rob.Coupe  $
         --       Module Name      : $Workfile:   v_sdl_datum_stats_working.vw  $
         --       Date into PVCS   : $Date:   Nov 03 2020 13:18:24  $
         --       Date fetched Out : $Modtime:   Nov 03 2020 13:16:30  $
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
*/
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
                             SDO_GEOM.sdo_distance (
                                 nw_geom,
                                 load_geom,
                                 TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'SDL_TOLERANCE')),
                                 'unit=M')
                                 dist_from,
                             TO_NUMBER (
                                 SYS_CONTEXT ('NM3SQL', 'SDL_BUFFER_SIZE')),
                             SDO_GEOM.sdo_length (
                                 SDO_GEOM.sdo_intersection (
                                     SDO_LRS.convert_to_std_geom (nw_geom),
                                     buffer_geom,
                                     TO_NUMBER (
                                         SYS_CONTEXT ('NM3SQL',
                                                      'SDL_TOLERANCE'))),
                                 TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'SDL_TOLERANCE')),
                                 'unit=M')
                                 intsct_length,
                             SDO_GEOM.sdo_length (
                                 load_geom,
                                 TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'SDL_TOLERANCE')),
                                 'unit=M')
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
                                         TO_NUMBER (
                                             SYS_CONTEXT ('NM3SQL',
                                                          'SDL_TOLERANCE')),
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
                                     AND sdo_within_distance (
                                             geoloc,
                                             d.geom,
                                                'distance='
                                             || SYS_CONTEXT ('NM3SQL',
                                                             'SDL_BUFFER_SIZE')
                                             || ' unit=M') =
                                         'TRUE'))
            GROUP BY sld_key, datum_id, load_length);
			