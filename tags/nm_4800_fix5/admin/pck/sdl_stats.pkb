CREATE OR REPLACE PACKAGE BODY sdl_stats
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_stats.pkb-arc   1.6   Nov 09 2020 10:59:22   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_stats.pkb  $
    --       Date into PVCS   : $Date:   Nov 09 2020 10:59:22  $
    --       Date fetched Out : $Modtime:   Nov 09 2020 10:58:38  $
    --       PVCS Version     : $Revision:   1.6  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling statistics based on coincidence of loaded geometry with existing network.
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is to handle all the procedures for handling the accuracy
    -- of loaded network against the existing network.

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.6  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_STATS';

    PROCEDURE remove_batch_datum_stats (p_batch_id IN NUMBER);
    
    FUNCTION get_node_type(p_batch_id in NUMBER) return varchar2;

    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    PROCEDURE generate_statistics_on_sld (
        p_batch_id    IN NUMBER,
        p_buffer      IN NUMBER,
        p_tolerance   IN NUMBER,
        p_sld_key     IN NUMBER DEFAULT NULL)
    IS
    BEGIN
        -- we are performing a standard radial buffer assessment around either every record in the whole batch or a record within the batch.
        -- clear out the existing stats;
        nm_debug.debug_on;
        nm_debug.debug ('start');

        BEGIN
            delete_statistics (p_batch_id, p_sld_key);
        END;

        nm_debug.debug ('start of insert');

        --    grab stats on whole geometry of all rows in batch or a specified sld_key

        INSERT INTO sdl_geom_accuracy (slga_sld_key,
                                       slga_buffer_size,
                                       slga_pct_inside,
                                       slga_min_offset,
                                       slga_max_offset)
            SELECT sld_key,
                   buffer_distance,
                   pctage_accuracy,
                   min_dist,
                   max_dist
              FROM (  SELECT sld_key,
                             MIN (dist_from)                            min_dist,
                             MAX (dist_from)                            max_dist,
                             buffer_distance,
                             SUM (intsct_length) / load_length * 100    pctage_accuracy
                        FROM (SELECT sld_key,
                                     ne_id,
                                     SDO_GEOM.sdo_distance (nw_geom,
                                                            load_geom,
                                                            p_tolerance,
                                                            'unit=M')
                                         dist_from,
                                     buffer_distance,
                                     SDO_GEOM.sdo_length (
                                         SDO_GEOM.sdo_intersection (
                                             SDO_LRS.convert_to_std_geom (
                                                 nw_geom),
                                             buffer_geom,
                                             p_tolerance),
                                         p_tolerance,
                                         'unit=M')
                                         intsct_length,
                                     SDO_GEOM.sdo_length (load_geom,
                                                          p_tolerance,
                                                          'unit=M')
                                         load_length
                                FROM (SELECT l.sld_key,
                                             n.ne_id,
                                             p_buffer                buffer_distance,
                                             geoloc                  nw_geom,
                                             sld_working_geometry    load_geom,
                                             SDO_GEOM.sdo_buffer (
                                                 l.sld_working_geometry,
                                                 p_buffer,
                                                 p_tolerance,
                                                 'unit=M')           buffer_geom
                                        FROM V_LB_NLT_GEOMETRY2 n,
                                             sdl_load_data     l,
                                             nm_elements       e
                                       WHERE     l.sld_sfs_id = p_batch_id
                                             AND l.sld_key =
                                                 NVL (p_sld_key, sld_key)
                                             AND e.ne_id = n.ne_id
                                             AND sdo_within_distance (
                                                     geoloc,
                                                     l.sld_working_geometry,
                                                        'distance = '
                                                     || p_buffer
                                                     || ' unit=M') =
                                                 'TRUE'))
                    GROUP BY sld_key, buffer_distance, load_length);

        --        ELSIF p_sub_seg = 'TRUE'
        --        THEN
        --            --  we are making an assessment of a specific record in the batch or a derived datum from a record in the batch
        --            --  using the polyline sub-segments
        --            --
        --            IF p_datum_id IS NOT NULL
        --            THEN
        --                DECLARE
        --                    lgeom   SDO_GEOMETRY;
        --                BEGIN
        --                    SELECT slwd_geom
        --                      INTO lgeom
        --                      FROM sdl_wip_datums
        --                     WHERE slwd_id = p_datum_id;
        --
        --                     (p_record_id,
        --                                             'L',
        --                                             lgeom,
        --                                             5);
        --                END;
        --            ELSE
        --                DECLARE
        --                    lgeom   SDO_GEOMETRY;
        --                BEGIN
        --                    SELECT slr_geom
        --                      INTO lgeom
        --                      FROM sdl_batch_records
        --                     WHERE slr_record_id = p_record_id;
        --
        --                    stats_on_pline_sub_segs (p_record_id,
        --                                             'L',
        --                                             lgeom,
        --                                             5);
        --                END;
        --            END IF;
        --
        --        END IF;

        INSERT INTO sdl_geom_accuracy (slga_sld_key,
                                       slga_datum_id,
                                       slga_buffer_size,
                                       slga_pct_inside,
                                       slga_min_offset,
                                       slga_max_offset)
            SELECT sld_key,
                   NULL,
                   p_buffer,
                   0,
                   NULL,
                   NULL
              FROM sdl_load_data
             WHERE     sld_sfs_id = p_batch_id
                   AND NOT EXISTS
                           (SELECT 1
                              FROM sdl_geom_accuracy
                             WHERE slga_sld_key = sld_key);

        nm_debug.debug ('End of insert');
    END;

    PROCEDURE generate_statistics_on_swd (
        p_batch_id    IN NUMBER,
        p_buffer      IN NUMBER,
        p_tolerance   IN NUMBER,
        p_sld_key     IN NUMBER DEFAULT NULL,
        p_datum_id    IN NUMBER DEFAULT NULL)
    IS
        l_swd_ids   int_array_type := nm3array.init_int_array ().ia;
    BEGIN
        remove_batch_datum_stats (p_batch_id);

        SELECT swd_id
          BULK COLLECT INTO l_swd_ids
          FROM sdl_wip_datums
         WHERE batch_id = p_batch_id;

        BEGIN
            nm3ctx.set_context ('SDL_BUFFER_SIZE', TO_CHAR (p_buffer));
            nm3ctx.set_context ('SDL_BATCH_ID', TO_CHAR (p_batch_id));
        END;

        FOR i IN 1 .. l_swd_ids.COUNT
        LOOP
            DECLARE
                l_pct   NUMBER;
            BEGIN
                nm3ctx.set_context ('SDL_SWD_ID', TO_CHAR (l_swd_ids (i)));
                nm3ctx.set_context ('SDL_BUFFER', TO_CHAR (p_buffer));
                nm3ctx.set_context ('SDL_TOLERANCE', TO_CHAR (p_tolerance));

                BEGIN
                    SELECT pctage_accuracy
                      INTO l_pct
                      FROM v_sdl_datum_stats_working;
                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        l_pct := 0;
                END;

                UPDATE sdl_wip_datums
                   SET pct_match = l_pct
                 WHERE swd_id = l_swd_ids (i);

                COMMIT;
            END;
        END LOOP;
    END;

    FUNCTION geom_as_pline_tab (pi_geom IN SDO_GEOMETRY)
        RETURN geom_id_tab
    AS
        retval   geom_id_tab;
    BEGIN
        SELECT geom_id (id,
                        sdo_geometry (2002,
                                      pi_geom.sdo_srid,
                                      NULL,
                                      sdo_elem_info_array (1, 2, 1),
                                      sdo_ordinate_array (x1,
                                                          y1,
                                                          x2,
                                                          y2)))
          BULK COLLECT INTO retval
          FROM (SELECT t.id,
                       t.x                                  x1,
                       t.y                                  y1,
                       LEAD (t.x, 1) OVER (ORDER BY id)     x2,
                       LEAD (y, 1) OVER (ORDER BY id)       y2
                  FROM TABLE (nm_sdo.get_vertices (pi_geom)) t)
         WHERE x2 IS NOT NULL;

        --        SELECT CAST (
        --                   COLLECT (
        --                       ptr_num (id,
        --                                SDO_GEOM.sdo_length (geom, 0.005, 'unit=M')))
        --                       AS ptr_num_array_type)
        --          INTO g_pline_lengths
        --          FROM TABLE (retval);

        RETURN retval;
    END;

    FUNCTION gen_pline_boxes (p_geom        IN SDO_GEOMETRY,
                              p_offset      IN NUMBER,
                              p_tolerance   IN NUMBER)
        RETURN pline_box_tab
    IS
        retval   pline_box_tab;
    BEGIN
        --        retval. g_plines := GEOM_AS_PLINE_TAB (geom);

        WITH
            pl1
            AS
                (SELECT t.*
                   FROM TABLE (geom_as_pline_tab (p_geom)) t),
            pl2
            AS
                (SELECT *
                   FROM (SELECT p.id
                                    gid,
                                geom,
                                t.id,
                                t.x
                                    x1,
                                t.y
                                    y1,
                                LEAD (t.x, 1)
                                    OVER (PARTITION BY p.id ORDER BY t.id)
                                    x2,
                                LEAD (t.y, 1)
                                    OVER (PARTITION BY p.id ORDER BY t.id)
                                    y2
                           FROM pl1 p, TABLE (nm_sdo.get_vertices (geom)) t --where p.id = 25
                                                                           )
                  WHERE id = 1)
        SELECT CAST (
                   COLLECT (
                       pline_box (
                           gid,
                           geom,
                           sdo_geometry (2003,
                                         p_geom.sdo_srid,
                                         NULL,
                                         sdo_elem_info_array (1, 1003, 1),
                                         ords),
                           SDO_GEOM.sdo_length (geom, p_tolerance, 'unit=M')))
                       AS pline_box_tab)
          INTO retval
          FROM (SELECT gid,
                       geom,
                       sdo_ordinate_array (x1 + xoffset,
                                           y1 + yoffset,
                                           x2 + xoffset,
                                           y2 + yoffset,
                                           x2 - xoffset,
                                           y2 - yoffset,
                                           x1 - xoffset,
                                           y1 - yoffset,
                                           x1 + xoffset,
                                           y1 + yoffset)    ords
                  FROM (SELECT p2.*,
                                 p_offset
                               * (y1 - y2)
                               / SQRT (
                                       POWER ((x2 - x1), 2)
                                     + POWER ((y2 - y1), 2))    xoffset,
                                 p_offset
                               * (x2 - x1)
                               / SQRT (
                                       POWER ((x2 - x1), 2)
                                     + POWER ((y2 - y1), 2))    yoffset
                          FROM pl2 p2)                          --group by gid
                                      );

        RETURN retval;
    END;

    PROCEDURE stats_on_load_pline_sub_segs (p_sld_key     IN NUMBER,
                                            p_buffer      IN NUMBER,
                                            p_tolerance   IN NUMBER)
    IS
    BEGIN
        --        SELECT l.ROWID, slga_buffer_size
        --          INTO l_load_row, l_buffer
        --          FROM sdl_load_data l, sdl_geom_accuracy
        --         WHERE slga_id = p_slga_id AND slga_sld_key = sld_key;

        DELETE FROM sdl_pline_statistics
              WHERE slps_sld_key = p_sld_key;

        INSERT INTO sdl_pline_statistics (slps_sld_key,
                                          slps_buffer,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_sld_key,
                   p_buffer,
                   pline_id,
                   NVL (pct_accuracy, 0),
                   pline_geom
              FROM (WITH
                        pline_boxes
                        AS
                            (SELECT t.id     box_id,
                                    t.box_geom,
                                    t.len,
                                    t.line_geom
                               FROM sdl_load_data  l,
                                    TABLE (
                                        sdl_stats.gen_pline_boxes (
                                            sld_working_geometry,
                                            p_buffer,
                                            p_tolerance)) t
                              WHERE sld_key = p_sld_key)--
                                                        ,
                        all_box_relate
                        AS
                            (SELECT /*+ LEADING (n p) */
                                    box_id,
                                    box_geom,
                                    len,
                                    line_geom,
                                    ne_id,
                                    geoloc
                               FROM pline_boxes p, v_lb_nlt_geometry2 n
                              WHERE sdo_relate (n.geoloc,
                                                box_geom,
                                                'mask=ANYINTERACT') =
                                    'TRUE') --          select * from all_box_relate
                                                                            --
                        ,
                        box_relate
                        AS
                            (SELECT /*+FULL(b) INDEX(e ne_pk) */
                                    b.*
                               FROM all_box_relate b, nm_elements_all e
                              WHERE b.ne_id = e.ne_id AND ne_end_date IS NULL) --          select * from box_relate
                                                                              --
                                                                              ,
                        box_intsct
                        AS
                            (  SELECT box_id,
                                      len,
                                      NVL (
                                          SUM (
                                              SDO_GEOM.sdo_length (
                                                  SDO_GEOM.sdo_intersection (
                                                      SDO_LRS.convert_to_std_geom (
                                                          geoloc),
                                                      box_geom,
                                                      p_tolerance),
                                                  p_tolerance,
                                                  'unit=M')), --over (partition by box_id ),
                                          0)    intsct_length
                                 FROM box_relate
                             GROUP BY box_id, len) --         select t.box_id, t.len, intsct_length, t.line_geom from box_intsct bi, pline_boxes t
                                                  --         where t.box_id = bi.box_id
                                                    --         order by box_id
                                                                            --
                        ,
                        box_stats
                        AS
                            (SELECT b.box_id
                                        pline_id,
                                    b.intsct_length,
                                    t.len
                                        pline_length,
                                    b.intsct_length / b.len * 100
                                        pct_accuracy,
                                    t.line_geom
                                        pline_geom
                               FROM box_intsct b, pline_boxes t
                              WHERE t.box_id = b.box_id)
                    SELECT pline_id, pline_geom, pct_accuracy
                      FROM box_stats);

        INSERT INTO sdl_pline_statistics (slps_sld_key,
                                          slps_buffer,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_sld_key,
                   p_buffer,
                   box_id,
                   0,
                   line_geom
              FROM (WITH
                        pline_boxes
                        AS
                            (SELECT t.id     box_id,
                                    t.box_geom,
                                    t.len,
                                    t.line_geom
                               FROM sdl_load_data  l,
                                    TABLE (
                                        sdl_stats.gen_pline_boxes (
                                            sld_working_geometry,
                                            p_buffer,
                                            p_tolerance)) t
                              WHERE sld_key = p_sld_key)
                    SELECT box_id, line_geom, 0
                      FROM pline_boxes
                     WHERE NOT EXISTS
                               (SELECT 1
                                  FROM sdl_pline_statistics
                                 WHERE     slps_sld_key = p_sld_key
                                       AND box_id = slps_pline_segment_id));
    END;

    PROCEDURE stats_on_datum_pline_sub_segs (p_swd_id      IN NUMBER,
                                             p_sld_key     IN NUMBER,
                                             p_buffer      IN NUMBER,
                                             p_tolerance   IN NUMBER)
    IS
    BEGIN
        DELETE FROM sdl_pline_statistics
              WHERE slps_swd_id = p_swd_id;

        INSERT INTO sdl_pline_statistics (slps_swd_id,
                                          slps_buffer,
                                          slps_sld_key,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_swd_id,
                   p_buffer,
                   p_sld_key,
                   pline_id,
                   NVL (pct_accuracy, 0),
                   pline_geom
              FROM (WITH
                        pline_boxes
                        AS
                            (SELECT t.id     box_id,
                                    t.box_geom,
                                    t.len,
                                    t.line_geom
                               FROM sdl_wip_datums  d,
                                    TABLE (
                                        sdl_stats.gen_pline_boxes (
                                            d.geom,
                                            p_buffer,
                                            p_tolerance)) t
                              WHERE swd_id = p_swd_id)                      --
                                                      ,
                        all_box_relate
                        AS
                            (SELECT /*+ LEADING (n p) */
                                    box_id,
                                    box_geom,
                                    len,
                                    line_geom,
                                    ne_id,
                                    geoloc
                               FROM pline_boxes p, v_lb_nlt_geometry2 n
                              WHERE sdo_relate (n.geoloc,
                                                box_geom,
                                                'mask=ANYINTERACT') =
                                    'TRUE') --          select * from all_box_relate
                                                                            --
                        ,
                        box_relate
                        AS
                            (SELECT /*+FULL(b) INDEX(e ne_pk) */
                                    b.*
                               FROM all_box_relate b, nm_elements_all e
                              WHERE b.ne_id = e.ne_id AND ne_end_date IS NULL) --          select * from box_relate
                                                                              --
                                                                              ,
                        box_intsct
                        AS
                            (  SELECT box_id,
                                      len,
                                      NVL (
                                          SUM (
                                              SDO_GEOM.sdo_length (
                                                  SDO_GEOM.sdo_intersection (
                                                      SDO_LRS.convert_to_std_geom (
                                                          geoloc),
                                                      box_geom,
                                                      p_tolerance),
                                                  p_tolerance,
                                                  'unit=M')), --over (partition by box_id ),
                                          0)    intsct_length
                                 FROM box_relate
                             GROUP BY box_id, len) --         select t.box_id, t.len, intsct_length, t.line_geom from box_intsct bi, pline_boxes t
                                                  --         where t.box_id = bi.box_id
                                                    --         order by box_id
                                                                            --
                        ,
                        box_stats
                        AS
                            (SELECT b.box_id
                                        pline_id,
                                    b.intsct_length,
                                    t.len
                                        pline_length,
                                    b.intsct_length / b.len * 100
                                        pct_accuracy,
                                    t.line_geom
                                        pline_geom
                               FROM box_intsct b, pline_boxes t
                              WHERE t.box_id = b.box_id)
                    SELECT pline_id, pline_geom, pct_accuracy
                      FROM box_stats);

        INSERT INTO sdl_pline_statistics (slps_swd_id,
                                          slps_sld_key,
                                          slps_buffer,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_swd_id,
                   sld_key,
                   p_buffer,
                   box_id,
                   0,
                   line_geom
              FROM (WITH
                        pline_boxes
                        AS
                            (SELECT d.sld_key,
                                    t.id     box_id,
                                    t.box_geom,
                                    t.len,
                                    t.line_geom
                               FROM sdl_wip_datums  d,
                                    TABLE (
                                        sdl_stats.gen_pline_boxes (
                                            d.geom,
                                            p_buffer,
                                            p_tolerance)) t
                              WHERE swd_id = p_swd_id)
                    SELECT box_id,
                           sld_key,
                           line_geom,
                           0
                      FROM pline_boxes
                     WHERE NOT EXISTS
                               (SELECT 1
                                  FROM sdl_pline_statistics
                                 WHERE     slps_swd_id = p_swd_id
                                       AND box_id = slps_pline_segment_id));
    END;

    PROCEDURE delete_statistics (p_batch_id   IN NUMBER,
                                 p_sld_key    IN NUMBER DEFAULT NULL)
    IS
    BEGIN
        BEGIN
            DELETE FROM sdl_pline_statistics
                  WHERE slps_sld_key IN
                            (SELECT sld_key
                               FROM sdl_load_data
                              WHERE     sld_sfs_id = p_batch_id
                                    AND sld_key = NVL (p_sld_key, sld_key));
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;
    --        BEGIN
    --            DELETE FROM sdl_geom_accuracy
    --                  WHERE slga_sld_key IN (SELECT sld_key
    --                                           FROM sdl_load_data
    --                                          WHERE sld_sfs_id = p_batch_id);
    --        EXCEPTION
    --            WHEN NO_DATA_FOUND
    --            THEN
    --                NULL;
    --        END;
    END;

    PROCEDURE delete_statistics_by_datum (
        p_batch_id   IN NUMBER,
        p_sld_key    IN NUMBER DEFAULT NULL,
        p_datum_id   IN NUMBER DEFAULT NULL)
    IS
    BEGIN
        DELETE FROM sdl_pline_statistics
              WHERE slps_swd_id IN
                        (SELECT swd_id
                           FROM sdl_wip_datums d
                          WHERE     d.batch_id = p_batch_id
                                AND sld_key = NVL (p_sld_key, sld_key)
                                AND d.datum_id = NVL (p_datum_id, d.datum_id));
    END;

    --
    PROCEDURE match_nodes (p_batch_id          IN NUMBER,
                           p_match_tolerance   IN NUMBER,
                           p_tolerance         IN NUMBER)
    IS
        l_node_type          VARCHAR2(4);
        l_load_node_id       NM3TYPE.tab_number;
        l_existing_node_id   NM3TYPE.tab_number;
        l_dist               NM3TYPE.tab_number;
        qq                   CHAR (1) := CHR (39);
        l_sdo_param          VARCHAR2 (50)
            :=    'distance = '
               || TO_CHAR (p_match_tolerance)
               || ' unit = '
               || qq
               || 'METER'
               || qq;

        --
        CURSOR retrieve_nodes (c_node_type in varchar2) IS
            SELECT load_node_id, existing_node_id, dist
              FROM (WITH
                        matching_nodes
                        AS
                            (SELECT n.*,
                                    no_node_id,
                                    MIN (rn) OVER (PARTITION BY node_id)    min_rn
                               FROM (SELECT ROW_NUMBER ()
                                                OVER (PARTITION BY node_id
                                                      ORDER BY dist)    rn,
                                            node_id,
                                            node_geom,
                                            npl_id,
                                            npl_location,
                                            dist,
                                            min_dist
                                       FROM (SELECT node_id,
                                                    node_geom,
                                                    npl_id,
                                                    npl_location,
                                                    dist,
                                                    MIN (dist)
                                                        OVER (
                                                            PARTITION BY node_id)    min_dist
                                               FROM (SELECT node_id,
                                                            node_geom,
                                                            npl_id,
                                                            npl_location,
                                                            SDO_GEOM.sdo_distance (
                                                                npl_location,
                                                                node_geom,
                                                                p_tolerance,
                                                                'unit=FOOT')    dist
                                                       FROM sdl_wip_nodes,
                                                            nm_point_locations
                                                      WHERE     batch_id =
                                                                p_batch_id
                                                            AND sdo_within_distance (
                                                                    npl_location,
                                                                    node_geom,
                                                                    l_sdo_param) =
                                                                'TRUE'))) n,
                                    nm_nodes
                              WHERE no_np_id = npl_id AND dist = min_dist and no_node_type = c_node_type --and rownum = 1
                                                                         )
                    SELECT node_id        load_node_id,
                           npl_id,
                           no_node_id     existing_node_id,
                           dist,
                           rn,
                           min_rn
                      FROM matching_nodes
                     WHERE rn = min_rn);
    --
    BEGIN
    
        l_node_type := get_node_type(p_batch_id);
        
        UPDATE sdl_wip_nodes
           SET existing_node_id = NULL, distance_from = NULL
         WHERE batch_id = p_batch_id;

        OPEN retrieve_nodes(l_node_type);

        FETCH retrieve_nodes
            BULK COLLECT INTO l_load_node_id, l_existing_node_id, l_dist;

        FORALL i IN 1 .. l_load_node_id.COUNT
            UPDATE sdl_wip_nodes
               SET existing_node_id = l_existing_node_id (i),
                   distance_from = l_dist (i)
             WHERE node_id = l_load_node_id (i);
    --
    END;

    PROCEDURE remove_batch_datum_stats (p_batch_id IN NUMBER)
    IS
    BEGIN
        UPDATE sdl_wip_datums
           SET pct_match = NULL
         WHERE batch_id = p_batch_id;
    END;

    FUNCTION get_relative_overlap (p_swd_id       IN NUMBER,
                                   p_stop_value   IN NUMBER DEFAULT NULL,
                                   p_rnd          IN NUMBER DEFAULT 2)
        RETURN SYS_REFCURSOR
    IS
        retval        SYS_REFCURSOR;
        l_match_tol   NUMBER;
        l_sdo_tol     NUMBER;
    --
    BEGIN
        --
        BEGIN
            SELECT spa_match_tolerance, spa_tolerance
              INTO l_match_tol, l_sdo_tol
              FROM sdl_process_audit, sdl_wip_datums
             WHERE     swd_id = p_swd_id
                   AND spa_sfs_id = batch_id
                   AND spa_process = 'TOPO_GENERATION';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                l_match_tol := 5;
                l_sdo_tol := 0.005;
        END;

        --
        OPEN retval FOR
              SELECT swd_id,
                     sld_key,
                     pct_match,
                     t.ne_id,
                     ne_descr,
                     ne_pct
                FROM (SELECT s.ne_id,
                             swd_id,
                             sld_key,
                             ROUND (pct_match, p_rnd)    pct_match,
                             ROUND (
                                   SDO_GEOM.sdo_length (
                                       SDO_LRS.convert_to_std_geom (
                                           SDO_LRS.lrs_intersection (s.geoloc,
                                                                     d_buffer,
                                                                     l_sdo_tol)))
                                 / d_length
                                 * 100,
                                 p_rnd)                  ne_pct
                        FROM v_lb_nlt_geometry2 s,
                             (SELECT swd_id,
                                     sld_key,
                                     pct_match,
                                     SDO_GEOM.sdo_length (d.geom, l_sdo_tol)
                                         d_length,
                                     SDO_GEOM.sdo_buffer (d.geom, 2)
                                         d_buffer
                                FROM sdl_wip_datums d
                               WHERE swd_id = p_swd_id) b
                       WHERE sdo_anyinteract (s.geoloc, d_buffer) = 'TRUE') t,
                     nm_elements e
               WHERE e.ne_id = t.ne_id AND ne_pct > NVL (p_stop_value, -1)
            ORDER BY ne_pct DESC;

        --
        RETURN retval;
    END;
function get_node_type( p_batch_id in number) return varchar2 is
retval varchar2(4);
begin
select node_type into retval
from (
select nt_node_type node_type --sp_id, sp_nlt_id, nt_node_type, nlt_nt_type, nlt_gty_type
from sdl_profiles, sdl_file_submissions, nm_linear_types, nm_types
where sfs_id = p_batch_id
and sfs_sp_id = sp_id
and sp_nlt_id = nlt_id
and nt_type = nlt_nt_type
and nlt_gty_type is NULL
union all
select nt_node_type --sp_id, sp_nlt_id, nt_node_type, nng_nt_type, nlt_gty_type
from sdl_profiles, sdl_file_submissions, nm_linear_types, nm_types, nm_nt_groupings
where sfs_id = p_batch_id
and sfs_sp_id = sp_id
and sp_nlt_id = nlt_id
and nt_type = nng_nt_type
and nlt_gty_type = nng_group_type )
group by node_type;
--
return retval;
end;
    
END sdl_stats;
/
