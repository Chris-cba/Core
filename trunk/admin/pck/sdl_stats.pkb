CREATE OR REPLACE PACKAGE BODY sdl_stats
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_stats.pkb-arc   1.0   Sep 09 2019 11:51:16   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_stats.pkb  $
    --       Date into PVCS   : $Date:   Sep 09 2019 11:51:16  $
    --       Date fetched Out : $Modtime:   Sep 05 2019 14:26:32  $
    --       PVCS Version     : $Revision:   1.0  $
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

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_STATS';

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
        p_batch_id     IN NUMBER,
        p_sld_key      IN NUMBER DEFAULT NULL,
        p_buffer_tab   IN SDO_NUMBER_ARRAY DEFAULT SDO_NUMBER_ARRAY (1,
                                                                     3,
                                                                     5,
                                                                     10))
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
              FROM (WITH
                        buffer_values
                        AS
                            (SELECT COLUMN_VALUE     buffer_distance
                               FROM TABLE (p_buffer_tab) t)
                      SELECT sld_key,
                             MIN (dist_from)                            min_dist,
                             MAX (dist_from)                            max_dist,
                             buffer_distance,
                             SUM (intsct_length) / load_length * 100    pctage_accuracy
                        FROM (SELECT sld_key,
                                     ne_id,
                                     SDO_GEOM.sdo_distance (nw_geom,
                                                            load_geom,
                                                            0.005,
                                                            'unit=M')
                                         dist_from,
                                     buffer_distance,
                                     SDO_GEOM.sdo_length (
                                         SDO_GEOM.sdo_intersection (
                                             SDO_LRS.convert_to_std_geom (
                                                 nw_geom),
                                             buffer_geom,
                                             0.005),
                                         0.005,
                                         'unit=M')
                                         intsct_length,
                                     SDO_GEOM.sdo_length (load_geom,
                                                          0.005,
                                                          'unit=M')
                                         load_length
                                FROM (SELECT l.sld_key,
                                             n.ne_id,
                                             buffer_distance,
                                             geoloc                  nw_geom,
                                             sld_working_geometry    load_geom,
                                             SDO_GEOM.sdo_buffer (
                                                 l.sld_working_geometry,
                                                 buffer_distance,
                                                 0.005,
                                                 'unit=M')           buffer_geom
                                        FROM V_LB_NLT_GEOMETRY2 n,
                                             sdl_load_data     l,
                                             nm_elements       e,
                                             buffer_values
                                       WHERE     l.sld_sfs_id = p_batch_id
                                             AND l.sld_key =
                                                 NVL (p_sld_key, sld_key)
                                             AND e.ne_id = n.ne_id
                                             AND sdo_relate (
                                                     geoloc,
                                                     SDO_GEOM.sdo_buffer (
                                                         l.sld_working_geometry,
                                                         g_match_buffer,
                                                         0.005,
                                                         'unit=M'),
                                                     'mask=anyinteract') =
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
        --                    stats_on_pline_sub_segs (p_record_id,
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
                   column_value buffer_distance,
                   0,
                   NULL,
                   NULL
                               FROM TABLE(p_buffer_tab) t, sdl_load_data
                               where  sld_sfs_id  = p_batch_id
                               and not exists ( select 1 from sdl_geom_accuracy where slga_sld_key = sld_key );        

        nm_debug.debug ('End of insert');
    END;

    PROCEDURE generate_statistics_on_swd (
        p_batch_id        NUMBER,
        p_sld_key      IN NUMBER DEFAULT NULL,
        p_datum_id     IN NUMBER DEFAULT NULL,
        p_buffer_tab   IN SDO_NUMBER_ARRAY DEFAULT SDO_NUMBER_ARRAY (1,
                                                                     3,
                                                                     5,
                                                                     10))
    IS
    BEGIN
        delete_statistics_by_datum (p_batch_id, p_sld_key, p_datum_id);

        INSERT INTO sdl_geom_accuracy (slga_sld_key,
                                       slga_datum_id,
                                       slga_buffer_size,
                                       slga_pct_inside,
                                       slga_min_offset,
                                       slga_max_offset)
            SELECT sld_key,
                   datum_id,
                   buffer_distance,
                   pctage_accuracy,
                   min_dist,
                   max_dist
              FROM (WITH
                        buffer_values
                        AS
                            (SELECT COLUMN_VALUE     buffer_distance
                               FROM TABLE (p_buffer_tab) t)
                      SELECT sld_key,
                             datum_id,
                             MIN (dist_from)                            min_dist,
                             MAX (dist_from)                            max_dist,
                             buffer_distance,
                             SUM (intsct_length) / load_length * 100    pctage_accuracy
                        FROM (SELECT sld_key,
                                     datum_id,
                                     ne_id,
                                     SDO_GEOM.sdo_distance (nw_geom,
                                                            load_geom,
                                                            0.005,
                                                            'unit=M')
                                         dist_from,
                                     buffer_distance,
                                     SDO_GEOM.sdo_length (
                                         SDO_GEOM.sdo_intersection (
                                             SDO_LRS.convert_to_std_geom (
                                                 nw_geom),
                                             buffer_geom,
                                             0.005),
                                         0.005,
                                         'unit=M')
                                         intsct_length,
                                     SDO_GEOM.sdo_length (load_geom,
                                                          0.005,
                                                          'unit=M')
                                         load_length
                                FROM (SELECT d.sld_key,
                                             datum_id,
                                             n.ne_id,
                                             buffer_distance,
                                             geoloc           nw_geom,
                                             d.geom           load_geom,
                                             SDO_GEOM.sdo_buffer (
                                                 d.geom,
                                                 buffer_distance,
                                                 0.005,
                                                 'unit=M')    buffer_geom
                                        FROM V_LB_NLT_GEOMETRY2 n,
                                             sdl_wip_datums    d,
                                             nm_elements       e,
                                             buffer_values
                                       WHERE     d.batch_id = p_batch_id
                                             AND e.ne_id = n.ne_id
                                             AND d.SLD_KEY =
                                                 NVL (p_sld_key, d.SLD_KEY)
                                             AND d.DATUM_ID =
                                                 NVL (p_datum_id, d.DATUM_ID)
                                             AND sdo_relate (
                                                     geoloc,
                                                     SDO_GEOM.sdo_buffer (
                                                         d.geom,
                                                         g_match_buffer,
                                                         0.005,
                                                         'unit=M'),
                                                     'mask=anyinteract') =
                                                 'TRUE'))
                    GROUP BY sld_key,
                             datum_id,
                             buffer_distance,
                             load_length);
--
        INSERT INTO sdl_geom_accuracy (slga_sld_key,
                                       slga_datum_id,
                                       slga_buffer_size,
                                       slga_pct_inside,
                                       slga_min_offset,
                                       slga_max_offset)
            SELECT sld_key,
                   datum_id,
                   column_value buffer_distance,
                   0,
                   NULL,
                   NULL
                               FROM TABLE(p_buffer_tab) t, sdl_wip_datums d
                               where  batch_id = p_batch_id
                               and not exists ( select 1 from sdl_geom_accuracy where slga_sld_key = d.sld_key and slga_datum_id = d.datum_id );
                             
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

    FUNCTION gen_pline_boxes (p_geom IN SDO_GEOMETRY, offset IN NUMBER)
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
                           SDO_GEOM.sdo_length (geom, 0.005, 'unit=M')))
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
                                 offset
                               * (y1 - y2)
                               / SQRT (
                                       POWER ((x2 - x1), 2)
                                     + POWER ((y2 - y1), 2))    xoffset,
                                 offset
                               * (x2 - x1)
                               / SQRT (
                                       POWER ((x2 - x1), 2)
                                     + POWER ((y2 - y1), 2))    yoffset
                          FROM pl2 p2)                          --group by gid
                                      );

        RETURN retval;
    END;

    PROCEDURE stats_on_load_pline_sub_segs (p_slga_id IN NUMBER)
    IS
        l_load_row   ROWID;
        l_buffer     NUMBER;
    BEGIN
        SELECT l.ROWID, slga_buffer_size
          INTO l_load_row, l_buffer
          FROM sdl_load_data l, sdl_geom_accuracy
         WHERE slga_id = p_slga_id AND slga_sld_key = sld_key;

        DELETE FROM sdl_pline_statistics
              WHERE slps_slga_id = p_slga_id;

        INSERT INTO sdl_pline_statistics (slps_slga_id,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_slga_id,
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
                                            l_buffer)) t
                              WHERE l.ROWID = l_load_row) --           select * from pline_boxes
                                                                            --
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
                                                      0.005),
                                                  0.005,
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

        INSERT INTO sdl_pline_statistics (slps_slga_id,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_slga_id,
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
                                            l_buffer)) t
                              WHERE l.ROWID = l_load_row)
                    SELECT box_id, line_geom, 0
                      FROM pline_boxes
                     WHERE NOT EXISTS
                               (SELECT 1
                                  FROM sdl_pline_statistics
                                 WHERE     slps_slga_id = p_slga_id
                                       AND box_id = slps_pline_segment_id));
    END;

    PROCEDURE stats_on_datum_pline_sub_segs (p_slga_id IN NUMBER)
    IS
        l_load_row   ROWID;
        l_buffer     NUMBER;
    BEGIN
        SELECT d.ROWID, slga_buffer_size
          INTO l_load_row, l_buffer
          FROM sdl_wip_datums d, sdl_geom_accuracy
         WHERE     slga_id = p_slga_id
               AND slga_sld_key = sld_key
               AND slga_datum_id = datum_id;

        DELETE FROM sdl_pline_statistics
              WHERE slps_slga_id = p_slga_id;

        INSERT INTO sdl_pline_statistics (slps_slga_id,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_slga_id,
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
                                        sdl_stats.gen_pline_boxes (d.geom,
                                                                   l_buffer))
                                    t
                              WHERE d.ROWID = l_load_row) --           select * from pline_boxes
                                                                            --
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
                                                      0.005),
                                                  0.005,
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

        INSERT INTO sdl_pline_statistics (slps_slga_id,
                                          slps_pline_segment_id,
                                          slps_pct_accuracy,
                                          slps_pline_geometry)
            SELECT p_slga_id,
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
                               FROM sdl_wip_datums  d,
                                    TABLE (
                                        sdl_stats.gen_pline_boxes (d.geom,
                                                                   l_buffer))
                                    t
                              WHERE d.ROWID = l_load_row)
                    SELECT box_id, line_geom, 0
                      FROM pline_boxes
                     WHERE NOT EXISTS
                               (SELECT 1
                                  FROM sdl_pline_statistics
                                 WHERE     slps_slga_id = p_slga_id
                                       AND box_id = slps_pline_segment_id));
    END;

    PROCEDURE delete_statistics (p_batch_id   IN NUMBER,
                                 p_sld_key    IN NUMBER DEFAULT NULL)
    IS
    BEGIN
        BEGIN
            DELETE FROM sdl_pline_statistics
                  WHERE slps_slga_id IN
                            (SELECT slga_id
                               FROM sdl_geom_accuracy, sdl_load_data
                              WHERE     slga_sld_key = sld_key
                                    AND sld_sfs_id = p_batch_id
                                    AND sld_key = NVL (p_sld_key, sld_key));
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        BEGIN
            DELETE FROM sdl_geom_accuracy
                  WHERE slga_sld_key IN (SELECT sld_key
                                           FROM sdl_load_data
                                          WHERE sld_sfs_id = p_batch_id);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;
    END;

    PROCEDURE delete_statistics_by_datum (
        p_batch_id   IN NUMBER,
        p_sld_key    IN NUMBER DEFAULT NULL,
        p_datum_id   IN NUMBER DEFAULT NULL)
    IS
    BEGIN
        DELETE FROM sdl_pline_statistics
              WHERE slps_slga_id IN
                        (SELECT slga_id
                           FROM sdl_geom_accuracy, sdl_wip_datums d
                          WHERE     slga_sld_key = sld_key
                                AND d.batch_id = p_batch_id
                                AND sld_key = NVL (p_sld_key, sld_key)
                                AND slga_datum_id IS NOT NULL
                                AND d.datum_id = NVL (p_datum_id, d.datum_id));

        DELETE FROM sdl_geom_accuracy
              WHERE slga_id IN
                        (SELECT slga_id
                           FROM sdl_geom_accuracy, sdl_wip_datums
                          WHERE     slga_sld_key = sld_key
                                AND slga_datum_id = datum_id
                                AND batch_id = p_batch_id
                                AND sld_key = NVL (p_sld_key, sld_key)
                                AND datum_id = NVL (p_datum_id, datum_id));
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            NULL;
    END;

    --
    PROCEDURE match_nodes (p_batch_id IN NUMBER)
    IS
        l_load_node_id       NM3TYPE.tab_number;
        l_existing_node_id   NM3TYPE.tab_number;
        l_dist               NM3TYPE.tab_number;

        --
        CURSOR retrieve_nodes IS
            SELECT load_node_id, existing_node_id, dist
              FROM (WITH
                        matching_nodes
                        AS
                            (SELECT *
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
                                                                0.005,
                                                                'unit=FOOT')    dist
                                                       FROM sdl_wip_nodes,
                                                            nm_point_locations
                                                      WHERE     batch_id = 4
                                                            AND sdo_within_distance (
                                                                    npl_location,
                                                                    node_geom,
                                                                    'distance=5 unit=FOOT') =
                                                                'TRUE')))
                              WHERE rn = 1)
                    SELECT node_id        load_node_id,
                           npl_id,
                           no_node_id     existing_node_id,
                           dist
                      FROM matching_nodes, nm_nodes
                     WHERE no_np_id = npl_id);
    --
    BEGIN
    
        update sdl_wip_nodes
        set existing_node_id = NULL, distance_from = NULL
        where batch_id = p_batch_id;
        
        OPEN retrieve_nodes;

        FETCH retrieve_nodes
            BULK COLLECT INTO l_load_node_id, l_existing_node_id, l_dist;

        FORALL i IN 1 .. l_load_node_id.COUNT
            UPDATE sdl_wip_nodes
               SET existing_node_id = l_existing_node_id (i),
                   distance_from = l_dist (i)
             WHERE node_id = l_load_node_id (i);
    --
    END;
END sdl_stats;
/