CREATE OR REPLACE PACKAGE BODY sdl_topo
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_topo.pkb-arc   1.2   Oct 11 2019 14:44:14   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_topo.pkb  $
    --       Date into PVCS   : $Date:   Oct 11 2019 14:44:14  $
    --       Date fetched Out : $Modtime:   Oct 10 2019 10:17:22  $
    --       PVCS Version     : $Revision:   1.2  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the generation of a toplogical network from the loaded data.
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is for breaking the loaded data into individual connected segments.

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_TOPO';

    PROCEDURE delete_stats_for_batch (p_batch_id IN NUMBER);

    PROCEDURE clear_wip_data (p_batch_id          IN NUMBER,
                              p_gen_self_intsct      VARCHAR2 DEFAULT 'TRUE');

    PROCEDURE generate_wip_datums (p_batch_id   IN NUMBER,
                                   p_sld_key    IN NUMBER);


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



    PROCEDURE generate_wip_topo_nw (
        p_batch_id          IN NUMBER,
        p_gen_self_intsct      VARCHAR2 DEFAULT 'FALSE',
        p_gen_grade_sep        VARCHAR2 DEFAULT 'FALSE')
    AS
    BEGIN
        delete_stats_for_batch (p_batch_id);

        COMMIT;

        clear_wip_data (p_batch_id);

        COMMIT;

        --We need to construct the set of nodes for the loaded data. This is important especially in route geometries where new nodes will from the start and end
        --of individual datum segments.
        --
        --Nodes will be found from the start and end of each geometry and over each intersection of the geometries.

        --This produces the list of all intersections of the loaded data - these can be grade separations, intersections where the two geometries intersect or just touch. They can be points
        -- or lines which intersect due to route geometries being non-exclusive or they can be self-intersecting.
        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         geom,
                                         relation)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   a.sld_key,
                   b.sld_key,
                   t.geom,
                   SDO_GEOM.relate (
                       SDO_LRS.convert_to_std_geom (a.sld_working_geometry),
                       'determine',
                       SDO_LRS.convert_to_std_geom (b.sld_working_geometry),
                       0.005)
              FROM sdl_load_data  a,
                   sdl_load_data  b,
                   TABLE (
                       nm_sdo_geom.extract_id_geom (
                           SDO_GEOM.sdo_intersection (a.sld_working_geometry,
                                                      b.sld_working_geometry,
                                                      0.005))) t
             WHERE     a.sld_key != b.sld_key
                   AND a.sld_sfs_id = p_batch_id
                   AND b.sld_sfs_id = p_batch_id
                   AND sdo_relate (a.sld_working_geometry,
                                   b.sld_working_geometry,
                                   'mask=ANYINTERACT') =
                       'TRUE';

        COMMIT;

        --This is the list of all terminating vertices which are not "close" to another geometry in the batch.

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         geom,
                                         relation)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   NULL,
                   geom,
                   'TERMINUS'
              FROM (SELECT sld_key,
                           SDO_LRS.geom_segment_start_pt (
                               sld_working_geometry)    geom
                      FROM sdl_load_data
                     WHERE sld_sfs_id = p_batch_id
                    UNION ALL
                    SELECT sld_key,
                           SDO_LRS.geom_segment_end_pt (sld_working_geometry)    geom
                      FROM sdl_load_data
                     WHERE sld_sfs_id = p_batch_id) terms
             WHERE NOT EXISTS
                       (SELECT 1
                          FROM sdl_load_data s2
                         WHERE     sld_sfs_id = p_batch_id
                               AND sdo_relate (s2.sld_working_geometry,
                                               geom,
                                               'mask=anyinteract') =
                                   'TRUE'
                               AND s2.sld_key != terms.sld_key);

        COMMIT;

        --The last statement will exclude terminating nodes where there is an intersection but the intersection is a line, so need to catch-up

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         geom,
                                         relation)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key1,
                   sld_key2,
                   geom,
                   relation
              FROM (SELECT sld_key1,
                           sld_key2,
                           SDO_LRS.geom_segment_start_pt (geom)     geom,
                           relation
                      FROM sdl_wip_intsct_geom a
                     WHERE batch_id = p_batch_id AND a.geom.sdo_gtype != 3301
                    UNION ALL
                    SELECT sld_key1,
                           sld_key2,
                           SDO_LRS.geom_segment_end_pt (geom)     geom,
                           relation
                      FROM sdl_wip_intsct_geom a
                     WHERE batch_id = p_batch_id AND a.geom.sdo_gtype != 3301);

        COMMIT;

        --Now any self-intersections

        IF p_gen_self_intsct = 'TRUE'
        THEN
            DELETE FROM sdl_wip_self_intersections
                  WHERE sld_key IN (SELECT sld_key
                                      FROM sdl_load_data
                                     WHERE sld_sfs_id = p_batch_id);

            generate_self_intersections (p_batch_id);
        END IF;

        IF p_gen_grade_sep = 'TRUE'
        THEN
            DELETE FROM sdl_wip_grade_separations;

            generate_grade_separations;
        END IF;

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         geom,
                                         relation)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   sld_key,
                   SDO_LRS.convert_to_lrs_geom (geom),
                   'SELF INTERSECT'
              FROM sdl_wip_self_intersections;

        COMMIT;

        --This looks after all possible nodes arising from the load data itself.
        --But, in some cases, such as CTDOT, the loaded data may be local routes and the routes may intersect with other networks which
        --share a common node type - such as state owned network or RTE. We need to generate the list of possible nodes arising from
        --intersections of this type - but, if required, we should exclude grade separations

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         geom,
                                         relation)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   a.sld_key,
                   NULL,
                   t.geom,
                   SDO_GEOM.relate (
                       SDO_LRS.convert_to_std_geom (a.sld_working_geometry),
                       'determine',
                       SDO_LRS.convert_to_std_geom (b.geoloc),
                       0.005)
              FROM sdl_load_data       a,
                   nm_nlt_rte_rte_sdo  b,
                   TABLE (
                       nm_sdo_geom.extract_id_geom (
                           SDO_GEOM.sdo_intersection (a.sld_working_geometry,
                                                      b.geoloc,
                                                      0.005))) t
             WHERE     a.sld_sfs_id = p_batch_id
                   AND sdo_relate (b.geoloc,
                                   a.sld_working_geometry,
                                   'mask=ANYINTERACT') =
                       'TRUE'
                   AND EXISTS
                           (SELECT 1
                              FROM nm_elements
                             WHERE ne_id = b.ne_id)
                   AND NOT EXISTS
                           (SELECT 1
                              FROM SDL_WIP_GRADE_SEPARATIONS
                             WHERE sdo_within_distance (
                                       sgs_geom,
                                       geom,
                                       'distance = 5 unit = FOOT') =
                                   'TRUE');

        COMMIT;

        --Now build the relationships

        INSERT INTO sdl_wip_pt_geom (batch_id, id, geom)
            SELECT p_batch_id, r_id, geom
              FROM sdl_wip_intsct_geom a
             WHERE batch_id = p_batch_id AND a.geom.sdo_gtype = 3301;

        COMMIT;

        INSERT INTO sdl_wip_pt_arrays (batch_id, ia, hashcode)
            SELECT p_batch_id, ia, ORA_HASH (ia) hashcode
              FROM (  SELECT  a.id,
                             CAST (
                                 COLLECT (b.id ORDER BY b.id) AS int_array_type)    ia
                        FROM sdl_wip_pt_geom a, sdl_wip_pt_geom b
                       WHERE     a.batch_id + 0 = p_batch_id
                             AND b.batch_id + 0 = p_batch_id
                             AND sdo_within_distance (a.GEOM,
                                                      b.GEOM,
                                                      'distance=5 unit=FOOT') =
                                 'TRUE'
                    GROUP BY a.id);

        COMMIT;

        INSERT INTO sdl_wip_nodes (batch_id, node_geom, hashcode)
              SELECT p_batch_id,
                     sdo_aggr_centroid (
                         sdoaggrtype (SDO_LRS.convert_to_std_geom (a.geom),
                                      0.005))    node_geom,
                     hashcode
                FROM sdl_wip_pt_geom a,
                     (WITH
                          individual_hashes
                          AS
                              (  SELECT hashcode, COUNT (*)
                                   FROM sdl_wip_pt_arrays pa
                                  WHERE batch_id = p_batch_id
                               GROUP BY hashcode)
                      SELECT ih.hashcode,
                             (SELECT ia
                                FROM sdl_wip_pt_arrays pa2
                               WHERE     ROWNUM = 1
                                     AND pa2.hashcode = ih.hashcode
                                     AND pa2.batch_id = p_batch_id)    ia
                        FROM individual_hashes ih),
                     TABLE (ia)
               WHERE a.id = COLUMN_VALUE AND a.batch_id = p_batch_id
            GROUP BY hashcode;

        COMMIT;

        INSERT INTO sdl_wip_route_nodes (batch_id, slk_key, hashcode)
            WITH
                int_nodes
                AS
                    (SELECT t.COLUMN_VALUE node_id, n.hashcode, node_geom
                       FROM sdl_wip_nodes      n,
                            sdl_wip_pt_arrays  pa,
                            TABLE (ia)         t
                      WHERE     pa.hashcode = n.hashcode
                            AND n.batch_id = p_batch_id
                            AND pa.batch_id = p_batch_id)
              SELECT p_batch_id, sld_key, hashcode
                FROM (SELECT n.node_id, sld_key1 sld_key, n.hashcode
                        FROM int_nodes n, sdl_wip_intsct_geom i
                       WHERE     i.r_id = n.node_id
                             AND sld_key1 IS NOT NULL
                             AND batch_id = p_batch_id
                      UNION
                      SELECT n.node_id, sld_key2 sld_key, n.hashcode
                        FROM int_nodes n, sdl_wip_intsct_geom i
                       WHERE     i.r_id = n.node_id
                             AND sld_key2 IS NOT NULL
                             AND batch_id = p_batch_id)
            GROUP BY sld_key, hashcode;

        COMMIT;

        FOR irec IN (SELECT sld_sfs_id batch_id, sld_key
                       FROM sdl_load_data
                      WHERE sld_sfs_id = p_batch_id)
        LOOP
            generate_wip_datums (irec.batch_id, irec.sld_key);
        END LOOP;

        COMMIT;

        INSERT INTO sdl_wip_datum_nodes (swd_id,
                                         batch_id,
                                         hashcode,
                                         node_type,
                                         node_measure)
            SELECT /*+INDEX ( N SDL_WIP_NODES_SPIDX) */ swd_id,
                   p_batch_id,
                   hashcode,
                   'S',
                   0
              FROM sdl_wip_datums d, sdl_wip_nodes n
             WHERE     sdo_within_distance (
                           node_geom,
                           SDO_LRS.geom_segment_start_pt (geom),
                           'distance=0.5 unit=FOOT') =
                       'TRUE'
                   AND d.batch_id = p_batch_id
                   AND n.batch_id = p_batch_id;

        COMMIT;

        INSERT INTO sdl_wip_datum_nodes (swd_id,
                                         batch_id,
                                         hashcode,
                                         node_type,
                                         node_measure)
            SELECT swd_id,
                   p_batch_id,
                   hashcode,
                   'E',
                   SDO_LRS.GEOM_SEGMENT_END_MEASURE (geom)
              FROM sdl_wip_datums d, sdl_wip_nodes n
             WHERE     sdo_within_distance (
                           node_geom,
                           SDO_LRS.geom_segment_end_pt (geom),
                           'distance=0.5 unit=FOOT') =
                       'TRUE'
                   AND d.batch_id = p_batch_id
                   AND n.batch_id = p_batch_id;

        COMMIT;
    END;

    PROCEDURE generate_wip_nw (p_batch_id IN NUMBER)
    AS
    --
    -- Similar to topo-nw build but it does not from intersection points, just uses the existing geometries, assumed to be datums.
    -- If a terminal is coincident with the interior of another edge, no connnectivity will be made.
    -- No account is taken for grade separations
    -- Self-intersections will be ignored for now
    -- It assumes that the nodes are taking into account the connectivity with other networks such as state roads
    --
    BEGIN
        delete_stats_for_batch (p_batch_id);

        COMMIT;

        clear_wip_data (p_batch_id);

        COMMIT;

        --This is the list of all terminating vertices which are not "close" to another geometry in the batch.

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         geom,
                                         relation)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   NULL,
                   geom,
                   'TERMINUS'
              FROM (SELECT sld_key,
                           SDO_LRS.geom_segment_start_pt (
                               sld_working_geometry)    geom
                      FROM sdl_load_data
                     WHERE sld_sfs_id = p_batch_id
                    UNION ALL
                    SELECT sld_key,
                           SDO_LRS.geom_segment_end_pt (sld_working_geometry)    geom
                      FROM sdl_load_data
                     WHERE sld_sfs_id = p_batch_id) terms;

        COMMIT;

        --Now build the relationships

        INSERT INTO sdl_wip_pt_geom (batch_id, id, geom)
            SELECT p_batch_id, r_id, geom
              FROM sdl_wip_intsct_geom a
             WHERE batch_id = p_batch_id AND a.geom.sdo_gtype = 3301;

        COMMIT;

        INSERT INTO sdl_wip_pt_arrays (batch_id, ia, hashcode)
            SELECT /*+index(a SDL_WIP_PT_GEOM_IDX) */
                   p_batch_id, ia, ORA_HASH (ia) hashcode
              FROM (  SELECT a.id,
                             CAST (
                                 COLLECT (b.id ORDER BY b.id) AS int_array_type)    ia
                        FROM sdl_wip_pt_geom a, sdl_wip_pt_geom b
                       WHERE     a.batch_id + 0 = p_batch_id
                             AND b.batch_id + 0 = p_batch_id
                             AND sdo_within_distance (a.GEOM,
                                                      b.GEOM,
                                                      'distance=5 unit=FOOT') =
                                 'TRUE'
                    GROUP BY a.id);

        COMMIT;

        INSERT INTO sdl_wip_nodes (batch_id, node_geom, hashcode)
              SELECT p_batch_id,
                     sdo_aggr_centroid (
                         sdoaggrtype (SDO_LRS.convert_to_std_geom (a.geom),
                                      0.005))    node_geom,
                     hashcode
                FROM sdl_wip_pt_geom a,
                     (WITH
                          individual_hashes
                          AS
                              (  SELECT hashcode, COUNT (*)
                                   FROM sdl_wip_pt_arrays pa
                                  WHERE batch_id = p_batch_id
                               GROUP BY hashcode)
                      SELECT ih.hashcode,
                             (SELECT ia
                                FROM sdl_wip_pt_arrays pa2
                               WHERE     ROWNUM = 1
                                     AND pa2.hashcode = ih.hashcode
                                     AND batch_id = p_batch_id)    ia
                        FROM individual_hashes ih),
                     TABLE (ia)
               WHERE a.id = COLUMN_VALUE
            GROUP BY hashcode;

        COMMIT;

        INSERT INTO sdl_wip_route_nodes (batch_id, slk_key, hashcode)
            WITH
                int_nodes
                AS
                    (SELECT t.COLUMN_VALUE node_id, n.hashcode, node_geom
                       FROM sdl_wip_nodes      n,
                            sdl_wip_pt_arrays  pa,
                            TABLE (ia)         t
                      WHERE     pa.hashcode = n.hashcode
                            AND n.batch_id = p_batch_id
                            AND pa.batch_id = p_batch_id)
              SELECT p_batch_id, sld_key, hashcode
                FROM (SELECT n.node_id, sld_key1 sld_key, n.hashcode
                        FROM int_nodes n, sdl_wip_intsct_geom i
                       WHERE     i.r_id = n.node_id
                             AND sld_key1 IS NOT NULL
                             AND i.batch_id = p_batch_id
                      UNION
                      SELECT n.node_id, sld_key2 sld_key, n.hashcode
                        FROM int_nodes n, sdl_wip_intsct_geom i
                       WHERE     i.r_id = n.node_id
                             AND sld_key2 IS NOT NULL
                             AND i.batch_id = p_batch_id)
            GROUP BY sld_key, hashcode;

        COMMIT;

        INSERT INTO sdl_wip_datums (batch_id,
                                    sld_key,
                                    datum_id,
                                    geom)
            SELECT p_batch_id,
                   sld_key,
                   1,
                   sld_working_geometry
              FROM sdl_load_data
             WHERE sld_sfs_id = p_batch_id;

        COMMIT;

        INSERT INTO sdl_wip_datum_nodes (swd_id,
                                         batch_id,
                                         hashcode,
                                         node_type,
                                         node_measure)
            SELECT swd_id,
                   p_batch_id,
                   hashcode,
                   'S',
                   0
              FROM sdl_wip_datums d, sdl_wip_nodes n
             WHERE     sdo_within_distance (
                           node_geom,
                           SDO_LRS.geom_segment_start_pt (geom),
                           'distance=0.5 unit=FOOT') =
                       'TRUE'
                   AND d.batch_id = p_batch_id
                   AND n.batch_id = p_batch_id;

        COMMIT;

        INSERT INTO sdl_wip_datum_nodes (swd_id,
                                         batch_id,
                                         hashcode,
                                         node_type,
                                         node_measure)
            SELECT swd_id,
                   p_batch_id,
                   hashcode,
                   'E',
                   SDO_LRS.GEOM_SEGMENT_END_MEASURE (geom)
              FROM sdl_wip_datums d, sdl_wip_nodes n
             WHERE     sdo_within_distance (
                           node_geom,
                           SDO_LRS.geom_segment_end_pt (geom),
                           'distance=0.5 unit=FOOT') =
                       'TRUE'
                   AND d.batch_id = p_batch_id
                   AND n.batch_id = p_batch_id;

        COMMIT;
    END;

    PROCEDURE generate_grade_separations
    AS
    BEGIN
        DELETE FROM sdl_wip_grade_separations;

        INSERT INTO sdl_wip_grade_separations
            WITH
                intsct
                AS
                    (SELECT a.ne_id                              ne_id1,
                            b.ne_id                              ne_id2,
                            SDO_GEOM.sdo_intersection (a.geoloc,
                                                       b.geoloc,
                                                       0.005)    geom
                       FROM V_LB_NLT_GEOMETRY2 a, V_LB_NLT_GEOMETRY2 b
                      WHERE     sdo_overlapbdydisjoint (a.geoloc, b.geoloc) =
                                'TRUE'
                            AND a.ne_id < b.ne_id)
            SELECT ROWNUM, i.geom
              FROM intsct i, nm_elements e1, nm_elements e2
             WHERE e1.ne_id = ne_id1 AND e2.ne_id = ne_id2;
    END;

    PROCEDURE delete_stats_for_batch (p_batch_id IN NUMBER)
    IS
    BEGIN
        DELETE FROM sdl_pline_statistics
              WHERE slps_sld_key IN
                        (SELECT sld_key
                           FROM sdl_load_data
                          WHERE     sld_sfs_id = p_batch_id);

        DELETE FROM sdl_geom_accuracy
              WHERE slga_sld_key IN (SELECT sld_key
                                       FROM sdl_load_data
                                      WHERE sld_sfs_id = p_batch_id);
    END;


    PROCEDURE clear_wip_data (p_batch_id          IN NUMBER,
                              p_gen_self_intsct      VARCHAR2 DEFAULT 'TRUE')
    IS
    BEGIN
        DELETE FROM sdl_wip_intsct_geom
              WHERE batch_id = p_batch_id;

        DELETE FROM sdl_wip_pt_geom
              WHERE batch_id = p_batch_id;

        DELETE FROM sdl_wip_pt_arrays
              WHERE batch_id = p_batch_id;

        DELETE FROM sdl_wip_datum_nodes
              WHERE batch_id = p_batch_id;

        DELETE FROM sdl_wip_nodes
              WHERE batch_id = p_batch_id;

        DELETE FROM sdl_wip_route_nodes
              WHERE batch_id = p_batch_id;

        IF p_gen_self_intsct = 'TRUE'
        THEN
            DELETE FROM sdl_wip_self_intersections
                  WHERE sld_key IN (SELECT sld_key
                                      FROM sdl_load_data
                                     WHERE sld_sfs_id = p_batch_id);
        END IF;

        DELETE FROM sdl_wip_datums
              WHERE batch_id = p_batch_id;
    END;

    PROCEDURE generate_self_intersections (p_batch_id IN NUMBER)
    IS
        l_locl_ids   geom_id_tab;
    BEGIN
        SELECT CAST (
                   COLLECT (geom_id (sld_key, sld_working_geometry))
                       AS geom_id_tab)
          INTO l_locl_ids
          FROM sdl_load_data
         WHERE sld_sfs_id = p_batch_id;

        --
        FOR i IN 1 .. l_locl_ids.COUNT
        LOOP
            --
            INSERT INTO sdl_wip_self_intersections (sld_key,
                                                    pline_id1,
                                                    pline_id2,
                                                    geom,
                                                    relation)
                WITH
                    plines
                    AS
                        (SELECT t.id, t.geom
                           FROM TABLE (
                                    SDL_STATS.GEOM_AS_PLINE_TAB (
                                        l_locl_ids (i).geom)) t)
                SELECT l_locl_ids (i).id,
                       p1.id
                           id1,
                       p2.id
                           id2,
                       SDO_GEOM.sdo_intersection (p1.geom, p2.geom, 0.005)
                           intsct_geom,
                       SDO_GEOM.relate (p1.geom,
                                        'determine',
                                        p2.geom,
                                        0.005)
                           relation
                  FROM plines p1, plines p2
                 WHERE     sdo_relate (p1.geom, p2.geom, 'mask=anyinteract') =
                           'TRUE'
                       AND p1.id != p2.id
                       AND p1.id < p2.id - 1;
        END LOOP;
    END;

    PROCEDURE generate_wip_datums (p_batch_id   IN NUMBER,
                                   p_sld_key    IN NUMBER)
    IS
    BEGIN
        INSERT INTO sdl_wip_datums (batch_id,
                                    sld_key,
                                    datum_id,
                                    geom)
            SELECT p_batch_id,
                   p_sld_key,
                   t.id,
                   t.geom
              FROM (  SELECT slk_key,
                             CAST (
                                 COLLECT (geom_id (ROWNUM, node_geom))
                                     AS geom_id_tab)    node_tab
                        FROM sdl_wip_route_nodes nu, sdl_wip_nodes n
                       WHERE slk_key = p_sld_key AND nu.hashcode = n.hashcode
                    GROUP BY slk_key),
                   sdl_load_data,
                   TABLE (
                       nm_sdo.multi_split (sld_working_geometry, node_tab))
                   t
             WHERE sld_key = slk_key AND sld_key = p_sld_key;
    END;
END;
/
