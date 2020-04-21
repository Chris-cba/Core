CREATE OR REPLACE PACKAGE BODY sdl_topo
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_topo.pkb-arc   1.13   Apr 21 2020 16:31:20   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_topo.pkb  $
    --       Date into PVCS   : $Date:   Apr 21 2020 16:31:20  $
    --       Date fetched Out : $Modtime:   Apr 21 2020 16:30:32  $
    --       PVCS Version     : $Revision:   1.13  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the generation of a toplogical network from the loaded data.
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is for breaking the loaded data into individual connected segments.

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.13  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_TOPO';

    g_sdo_tol                 NUMBER;
    g_m_tol                   NUMBER;

    g_unit_name               VARCHAR2 (20);

    g_unit_string             VARCHAR2 (30);

    PROCEDURE initiate_tolerances (p_batch_id      IN NUMBER,
                                   p_tol_unit_id   IN NUMBER);

    PROCEDURE delete_stats_for_batch (p_batch_id IN NUMBER);

    PROCEDURE clear_wip_data (p_batch_id          IN NUMBER,
                              p_gen_self_intsct      VARCHAR2 DEFAULT 'TRUE');

    PROCEDURE generate_wip_datums (p_batch_id   IN NUMBER,
                                   p_sld_key    IN NUMBER,
                                   p_tol_load   IN NUMBER);

    PROCEDURE cleanup (p_batch_id IN NUMBER, tolerance IN NUMBER);

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

    PROCEDURE initiate_tolerances (p_batch_id      IN NUMBER,
                                   p_tol_unit_id   IN NUMBER)
    IS
        l_diminfo   sdo_dim_array;
    /*
    -- we need to instantiate a few tolerance related bits of data
    -- firstly we need the sdo tolerance from the layer metadata
    -- note that the standard layer based tolerances are from the layer itself and are assumed
    -- to be in the correct units - i.e. those of the layer itself.
    -- The network tolerance is derived from the profile and its related network type.
    -- Other tolerances will be supplied in a specified unit ID for which the unit name must be available
    -- for the operators such as within-distance. If no unit is specified it
    -- will default to being used with no unit specifier so the value will be either
    -- in the units of the layer (for projected systems) or in meters for geodetics
    -- The unit name must match a valid SDO_DIST_UNIT.UNIT_NAME.

    */
    BEGIN
        SELECT m.sdo_diminfo
          INTO l_diminfo
          FROM mdsys.sdo_geom_metadata_table m
         WHERE     sdo_owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
               AND sdo_table_name = 'SDL_LOAD_DATA'
               AND sdo_column_name = 'SLD_WORKING_GEOMETRY';

        g_sdo_tol := l_diminfo (1).sdo_tolerance;

        SELECT nm3unit.get_tol_from_unit_mask (nlt_units)
          INTO g_m_tol
          FROM sdl_profiles,
               sdl_file_submissions,
               nm_linear_types,
               nm_units
         WHERE     nlt_id = sp_nlt_id
               AND sfs_id = p_batch_id
               AND sfs_sp_id = sp_id
               AND nlt_units = un_unit_id;

        IF p_tol_unit_id IS NOT NULL
        THEN
            BEGIN
                SELECT unit_name
                  INTO g_unit_name
                  FROM sdo_dist_units, nm_units
                 WHERE     un_unit_id = p_tol_unit_id
                       AND unit_name = un_unit_name
                       AND ROWNUM = 1;      --sdo dist unit name is non unique
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    raise_application_error (
                        -20001,
                        'The unit name must match one that exists in the SDO_DIST_UNITS table');
            END;

            g_unit_string := 'UNIT = ' || g_unit_name;
        ELSE
            g_unit_name := 'M';
            g_unit_string := 'UNIT = M';
        END IF;
    END;


    PROCEDURE generate_wip_topo_nw (
        p_batch_id          IN NUMBER,
        p_gen_self_intsct      VARCHAR2 DEFAULT 'FALSE',
        p_gen_grade_sep        VARCHAR2 DEFAULT 'FALSE',
        p_tol_load          IN NUMBER,
        p_tol_nw            IN NUMBER,
        p_tol_unit_id       IN NUMBER,
        p_stop_count        IN NUMBER)
    AS
    BEGIN
        initiate_tolerances (p_batch_id, p_tol_unit_id);

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
                                         ne_id,
                                         ne_nt_type,
                                         geom,
                                         relation,
                                         intsct_type)
            SELECT            /* +LEADING(A B) INDEX(B SDL_LOAD_DATA_SPIDX) */
                   p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   a.sld_key,
                   b.sld_key,
                   NULL,
                   NULL,
                   t.geom,
                   SDO_GEOM.relate (
                       SDO_LRS.convert_to_std_geom (a.sld_working_geometry),
                       'determine',
                       SDO_LRS.convert_to_std_geom (b.sld_working_geometry),
                       g_sdo_tol),
                   'LOAD INTERSECTION'
              FROM sdl_load_data  A,
                   sdl_load_data  B,
                   TABLE (
                       nm_sdo_geom.extract_id_geom (
                           SDO_GEOM.sdo_intersection (a.sld_working_geometry,
                                                      b.sld_working_geometry,
                                                      g_sdo_tol))) t
             WHERE     a.sld_key < b.sld_key
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
                                         ne_id,
                                         ne_nt_type,
                                         geom,
                                         relation,
                                         intsct_type)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   NULL,
                   NULL,
                   NULL,
                   geom,
                   'TERMINUS',
                   'LOAD TERMINUS'
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
                                         ne_id,
                                         ne_nt_type,
                                         geom,
                                         relation,
                                         intsct_type)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key1,
                   sld_key2,
                   NULL,
                   NULL,
                   geom,
                   relation,
                   'LOAD LINE INTERSECTION'
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

            generate_self_intersections (p_batch_id, 5, 7);
        END IF;

        IF p_gen_grade_sep = 'TRUE'
        THEN
            generate_grade_separations (p_tol_nw, p_tol_unit_id);
        END IF;

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         ne_id,
                                         ne_nt_type,
                                         geom,
                                         relation,
                                         intsct_type)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   sld_key,
                   NULL,
                   NULL,
                   SDO_LRS.convert_to_lrs_geom (geom),
                   'SELF INTERSECT',
                   'LOAD SELF INTERSECT'
              FROM sdl_wip_self_intersections;

        COMMIT;

        --This looks after all possible nodes arising from the load data itself.
        --But, in some cases, the loaded data may be local routes and the routes may intersect with other networks which
        --share a common node type. Also the user may wish to from nodes where load data intersects with the very network that
        -- it may be replacing. In some cases, a load geometry may be a valid new road which forms several intersections
        -- with existing network, in other cases, the load geometry may weave around the existing network which could produce
        -- a great many intersections when the load geometry is intended to replace the existing network. This is difficult to
        -- establish spatially. If required, we shoudl exclude the positions already designated as grade separations.

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         ne_id,
                                         ne_nt_type,
                                         geom,
                                         relation,
                                         intsct_type)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   NULL,
                   ne_id,
                   ne_nt_type,
                   geom,
                   relation,
                   'EXISTING'
              FROM (WITH
                        intsct
                        AS
                            (SELECT /*+LEADING(A B ) INDEX (B XCTDOT_SEGM_SDO_SPPK)*/
                                    p_batch_id,
                                    a.sld_key,
                                    NE_ID,
                                    t.geom,
                                    SDO_GEOM.relate (
                                        SDO_LRS.convert_to_std_geom (
                                            a.sld_working_geometry),
                                        'determine',
                                        SDO_LRS.convert_to_std_geom (
                                            b.geoloc),
                                        g_sdo_tol)                           relation,
                                    COUNT (*) OVER (PARTITION BY sld_key)    rc
                               FROM sdl_load_data       A,
                                    v_lb_nlt_geometry2  B, --xctdot_segm_sdo_table  b,
                                    TABLE (
                                        nm_sdo_geom.extract_id_geom (
                                            SDO_GEOM.sdo_intersection (
                                                a.sld_working_geometry,
                                                b.geoloc,
                                                g_sdo_tol))) t
                              WHERE     a.sld_sfs_id = p_batch_id
                                    AND sdo_relate (
                                            b.geoloc,
                                            a.sld_working_geometry,
                                            'mask=OVERLAPBDYDISJOINT+OVERLAPBDYINTERSECT+TOUCH') =
                                        'TRUE')
                    SELECT /*+LEADING(I E) INDEX(E NE_PK) */
                           i.*, ne_nt_type
                      FROM intsct i, nm_elements e
                     WHERE     e.ne_id = i.ne_id
                           AND rc < p_stop_count
                           AND NOT EXISTS
                                   (SELECT 1
                                      FROM SDL_WIP_GRADE_SEPARATIONS
                                     WHERE sdo_within_distance (
                                               sgs_geom,
                                               geom,
                                                  'distance = '
                                               || TO_CHAR (p_tol_nw)
                                               || ' unit = '
                                               || g_unit_name) =
                                           'TRUE'));

        COMMIT;

        --
        --Now find all load geometry which almost touch the existing network
        --

        INSERT INTO sdl_wip_intsct_geom (batch_id,
                                         r_id,
                                         sld_key1,
                                         sld_key2,
                                         ne_id,
                                         ne_nt_type,
                                         geom,
                                         relation,
                                         intsct_type,
                                         terminal_type)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   NULL,
                   NE_ID,
                   ne_nt_type,
                   geom,
                   'ALMOST TOUCH',
                   'EX UNDR/OVR',
                   terminal_type
              FROM (WITH
                        end_pts
                        AS
                            (SELECT sld_key,
                                    SDO_LRS.GEOM_SEGMENT_START_PT (
                                        sld_working_geometry)    st_pt,
                                    SDO_LRS.GEOM_SEGMENT_END_PT (
                                        sld_working_geometry)    end_pt
                               FROM sdl_load_data
                              WHERE sld_sfs_id = p_batch_id),
                        terminals
                        AS
                            (SELECT sld_key,
                                    'S'       terminal_type,
                                    st_pt     terminal
                               FROM end_pts
                             UNION ALL
                             SELECT sld_key,
                                    'E'        terminal_type,
                                    end_pt     terminal
                               FROM end_pts),
                        --                                (SELECT sld_key,
                        --                                        'S'                          terminal_type,
                        --                                        SDO_LRS.GEOM_SEGMENT_START_PT (
                        --                                            sld_working_geometry)    terminal
                        --                                   FROM sdl_load_data
                        --                                  WHERE sld_sfs_id = p_batch_id
                        --                                 UNION ALL
                        --                                 SELECT sld_key,
                        --                                        'E',
                        --                                        SDO_LRS.GEOM_SEGMENT_END_PT (
                        --                                            sld_working_geometry)
                        --                                   FROM sdl_load_data
                        --                                  WHERE sld_sfs_id = p_batch_id),
                        intscts
                        AS
                            (SELECT /*+LEADING T G) INDEX(g XCTDOT_SEGM_SDO_SPPK) */
                                    t.*,
                                    SDO_LRS.project_pt (geoloc,
                                                        t.terminal,
                                                        g_sdo_tol)           geom,
                                    ne_id,
                                    SDO_GEOM.sdo_distance (geoloc,
                                                           t.terminal,
                                                           g_sdo_tol,
                                                           g_unit_string)    dist
                               FROM terminals T, v_lb_nlt_geometry2 G
                              WHERE sdo_within_distance (
                                        geoloc,
                                        t.terminal,
                                           'distance='
                                        || p_tol_load
                                        || ' '
                                        || g_unit_string) =
                                    'TRUE'),
                        nodes
                        AS
                            (SELECT /*+LEADING T P) INDEX(P NM_POINT_LOCATIONS_SPIDX) */
                                    t.*,
                                    npl_location,
                                    npl_id,
                                    SDO_GEOM.sdo_distance (npl_location,
                                                           t.terminal,
                                                           g_sdo_tol,
                                                           g_unit_string)    dist
                               FROM terminals T, nm_point_locations P
                              WHERE sdo_within_distance (
                                        npl_location,
                                        t.terminal,
                                           'distance='
                                        || p_tol_load
                                        || ' '
                                        || g_unit_string) =
                                    'TRUE')
                    SELECT /*+LEADING( X E) INDEX(E NE_PK) */
                           x.*, e.ne_nt_type
                      FROM intscts x, nm_elements e
                     WHERE     e.ne_id = x.ne_id
                           AND dist > 0.1
                           AND NOT EXISTS
                                   (SELECT 1
                                      FROM nodes n
                                     WHERE     n.sld_key = x.sld_key
                                           AND n.terminal_type =
                                               x.terminal_type)
                    UNION ALL
                    SELECT /*+LEADING( X N ) INDEX(N NN_NP_FK_IND) INDEX(NU NNU_NN_FK_IND)*/
                           sld_key,
                           terminal_type,
                           terminal,
                           sdo_geometry (
                               3301,
                               x.npl_location.sdo_srid,
                               NULL,
                               sdo_elem_info_array (1, 1, 1),
                               sdo_ordinate_array (
                                   x.npl_location.sdo_point.x,
                                   x.npl_location.sdo_point.y,
                                   0)),
                           FIRST_VALUE (nnu_ne_id)
                               OVER (PARTITION BY no_node_id),
                           dist,
                           ne_nt_type
                      FROM nodes           X,
                           nm_elements     E,
                           nm_node_usages  NU,
                           nm_nodes        N
                     WHERE     e.ne_id = nnu_ne_id
                           AND x.npl_id = n.no_np_id
                           AND nu.nnu_no_node_id = n.no_node_id
                           AND dist > 0.1);

        COMMIT;

        --Now build the relationships - only include the point data

        INSERT INTO sdl_wip_pt_geom (batch_id,
                                     id,
                                     geom,
                                     pt_type)
            SELECT p_batch_id,
                   r_id,
                   geom,
                   intsct_type
              FROM sdl_wip_intsct_geom a
             WHERE batch_id = p_batch_id AND a.geom.sdo_gtype = 3301;

        COMMIT;

        INSERT INTO sdl_wip_pt_arrays (batch_id,
                                       ia,
                                       hashcode,
                                       existing_nw)
            SELECT p_batch_id,
                   ia,
                   ORA_HASH (ia)     hashcode,
                   CASE WHEN pt_type = 'E' THEN 'Y' ELSE 'N' END
              FROM (  SELECT /* +LEADING(A B) INDEX(B SDL_WIP_PT_GEOM_SPIDX ) */
                             a.id,
                             CAST (
                                 COLLECT (b.id ORDER BY b.id) AS int_array_type)
                                 ia,
                             MIN (SUBSTR (b.pt_type, 1, 1))
                                 pt_type
                        FROM sdl_wip_pt_geom a, sdl_wip_pt_geom b
                       WHERE     a.batch_id = p_batch_id
                             AND b.batch_id = p_batch_id
                             AND sdo_within_distance (
                                     a.GEOM,
                                     b.GEOM,
                                        'distance='
                                     || TO_CHAR (p_tol_load)
                                     || ' '
                                     || g_unit_string) =
                                 'TRUE'
                    GROUP BY a.id);

        COMMIT;

        INSERT INTO sdl_wip_nodes (batch_id,
                                   node_geom,
                                   hashcode,
                                   existing_nw)
            SELECT p_batch_id,
                   node_geom,
                   hashcode,
                   existing_nw
              FROM (WITH
                        individual_hashes
                        AS
                            (  SELECT hashcode,
                                      MIN (existing_nw)     existing_nw,
                                      COUNT (*)             rc
                                 FROM sdl_wip_pt_arrays pa
                                WHERE batch_id = p_batch_id
                             GROUP BY hashcode),
                        grouped_hashes
                        AS
                            (SELECT ih.hashcode,
                                    rc,
                                    existing_nw,
                                    (SELECT ia
                                       FROM sdl_wip_pt_arrays pa2
                                      WHERE     ROWNUM = 1
                                            AND pa2.hashcode = ih.hashcode
                                            AND pa2.batch_id = p_batch_id)    ia
                               FROM individual_hashes ih)
                      --select * from grouped_hashes,                      TABLE (ia)
                      --where column_value =
                      SELECT existing_nw,
                             sdo_aggr_centroid (
                                 sdoaggrtype (
                                     SDO_LRS.convert_to_std_geom (a.geom),
                                     g_sdo_tol))    node_geom,
                             hashcode
                        FROM sdl_wip_pt_geom a, grouped_hashes, TABLE (ia)
                       WHERE     a.id = COLUMN_VALUE
                             AND a.batch_id = p_batch_id
                             AND existing_nw = 'N'
                    GROUP BY hashcode, existing_nw
                    UNION ALL
                      SELECT existing_nw,
                             sdo_aggr_centroid (
                                 sdoaggrtype (
                                     SDO_LRS.convert_to_std_geom (a.geom),
                                     g_sdo_tol))    node_geom,
                             hashcode
                        FROM sdl_wip_pt_geom a, grouped_hashes, TABLE (ia)
                       WHERE     a.id = COLUMN_VALUE
                             AND a.batch_id = p_batch_id
                             AND existing_nw = 'Y'
                             AND SUBSTR (a.pt_type, 1, 1) = 'E'
                    GROUP BY hashcode, existing_nw);

        COMMIT;

        INSERT INTO sdl_wip_route_nodes (batch_id, sld_key, hashcode)
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

        INSERT INTO SDL_WIP_DATUMS (swd_id,
                                    batch_id,
                                    sld_key,
                                    datum_id,
                                    geom)
            SELECT swd_id_seq.NEXTVAL,
                   p_batch_id,
                   sld_key,
                   1,
                   sld_working_geometry
              FROM sdl_load_data l
             WHERE sld_key IN (  SELECT sld_key
                                   FROM sdl_wip_route_nodes n
                                  WHERE batch_id = p_batch_id
                               GROUP BY sld_key
                                 HAVING COUNT (*) = 2);

        INSERT INTO sdl_wip_datum_nodes (swd_id,
                                         batch_id,
                                         hashcode,
                                         node_type,
                                         node_measure)
            SELECT swd_id,
                   batch_id,
                   hashcode,
                   CASE WHEN rn = 1 THEN 'S' ELSE 'E' END     node_type,
                   m_val
              FROM (SELECT t.*, ROW_NUMBER () OVER (partition by swd_id ORDER BY m_val) rn
                      FROM (SELECT d.swd_id,
                                   d.batch_id,
                                   a.hashcode,
                                   b.node_id,
                                   SDO_LRS.find_measure (geom, node_geom)    m_val
                              FROM sdl_wip_datums       d,
                                   sdl_wip_route_nodes  a,
                                   sdl_wip_nodes        b
                             WHERE     a.hashcode = b.hashcode
                                   AND d.sld_key = a.sld_key
                                   AND d.batch_id = p_batch_id
                                   AND a.batch_id = p_batch_id
                                   AND b.batch_id = p_batch_id) t) t1;

        commit;
--        raise_application_error(-20001, 'Stop');
        FOR irec IN (SELECT sld_sfs_id batch_id, sld_key
                       FROM sdl_load_data l
                      WHERE     l.sld_sfs_id = p_batch_id
                            AND not exists ( select 1 from sdl_wip_datums d where d.sld_key = l.sld_key and d.batch_id = p_batch_id ))
--                            AND sld_key IN (  SELECT sld_key
--                                                FROM sdl_wip_route_nodes n
--                                               WHERE batch_id = p_batch_id
--                                            GROUP BY sld_key
--                                              HAVING COUNT (*) <> 2))
        LOOP
            generate_wip_datums (irec.batch_id, irec.sld_key, p_tol_load);
        END LOOP;
        commit;
--      raise_application_error(-20001, 'Stop');
        cleanup (p_batch_id, 5);

        COMMIT;
    END;

    PROCEDURE generate_wip_nw (p_batch_id      IN NUMBER,
                               p_tol_load      IN NUMBER,
                               p_tol_nw        IN NUMBER,
                               p_tol_unit_id   IN NUMBER,
                               p_stop_count    IN NUMBER)
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
                                         ne_id,
                                         ne_nt_type,
                                         geom,
                                         relation,
                                         intsct_type)
            SELECT p_batch_id,
                   sld_intsct_seq.NEXTVAL,
                   sld_key,
                   NULL,
                   NULL,
                   NULL,
                   geom,
                   'TERMINUS',
                   'LOAD TERMINUS'
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

        INSERT INTO sdl_wip_pt_geom (batch_id,
                                     id,
                                     pt_type,
                                     geom)
            SELECT p_batch_id,
                   r_id,
                   intsct_type,
                   geom
              FROM sdl_wip_intsct_geom a
             WHERE batch_id = p_batch_id AND a.geom.sdo_gtype = 3301;

        COMMIT;

        INSERT INTO sdl_wip_pt_arrays (batch_id,
                                       ia,
                                       hashcode,
                                       existing_nw)
            SELECT /*+index(a SDL_WIP_PT_GEOM_IDX) */
                   p_batch_id,
                   ia,
                   ORA_HASH (ia)     hashcode,
                   CASE WHEN pt_type = 'E' THEN 'Y' ELSE 'N' END
              FROM (  SELECT a.id,
                             CAST (
                                 COLLECT (b.id ORDER BY b.id) AS int_array_type)
                                 ia,
                             MIN (SUBSTR (b.pt_type, 1, 1))
                                 pt_type
                        FROM sdl_wip_pt_geom a, sdl_wip_pt_geom b
                       WHERE     a.batch_id = p_batch_id
                             AND b.batch_id = p_batch_id
                             AND sdo_within_distance (
                                     a.GEOM,
                                     b.GEOM,
                                        'distance='
                                     || p_tol_load
                                     || ' '
                                     || g_unit_string) =
                                 'TRUE'
                    GROUP BY a.id);

        COMMIT;

        INSERT INTO sdl_wip_nodes (batch_id, node_geom, hashcode)
              SELECT p_batch_id,
                     sdo_aggr_centroid (
                         sdoaggrtype (SDO_LRS.convert_to_std_geom (a.geom),
                                      g_sdo_tol))    node_geom,
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

        INSERT INTO sdl_wip_route_nodes (batch_id, sld_key, hashcode)
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
                           'distance= ' || p_tol_nw || ' ' || g_unit_string) =
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
                           'distance=' || p_tol_nw || ' ' || g_unit_string) =
                       'TRUE'
                   AND d.batch_id = p_batch_id
                   AND n.batch_id = p_batch_id;

        COMMIT;
    END;

    PROCEDURE generate_grade_separations (p_tol_nw        IN NUMBER,
                                          p_tol_unit_id   IN NUMBER)
    AS
    BEGIN
        DELETE FROM sdl_wip_grade_separations;

        INSERT INTO sdl_wip_grade_separations
            WITH
                intsct
                AS
                    (SELECT a.ne_id                                  ne_id1,
                            b.ne_id                                  ne_id2,
                            SDO_GEOM.sdo_intersection (a.geoloc,
                                                       b.geoloc,
                                                       g_sdo_tol)    geom
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
              WHERE slps_sld_key IN (SELECT sld_key
                                       FROM sdl_load_data
                                      WHERE sld_sfs_id = p_batch_id);

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

    PROCEDURE generate_self_intersections (p_batch_id      IN NUMBER,
                                           p_tol_load      IN NUMBER,
                                           p_tol_unit_id   IN NUMBER)
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
                       p1.id                                    id1,
                       p2.id                                    id2,
                       SDO_GEOM.sdo_intersection (p1.geom,
                                                  p2.geom,
                                                  g_sdo_tol)    intsct_geom,
                       SDO_GEOM.relate (p1.geom,
                                        'determine',
                                        p2.geom,
                                        g_sdo_tol)              relation
                  FROM plines p1, plines p2
                 WHERE     sdo_relate (p1.geom, p2.geom, 'mask=anyinteract') =
                           'TRUE'
                       AND p1.id != p2.id
                       AND p1.id < p2.id - 1;
        END LOOP;
    END;

    PROCEDURE generate_wip_datums (p_batch_id   IN NUMBER,
                                   p_sld_key    IN NUMBER,
                                   p_tol_load   IN NUMBER)
    IS
        l_topo_nw_tab   topo_nw_geom_id_tab;
    BEGIN
        /*
        Each node position is projected back onto the load geometry to generate a set of geometry and node-ids whcih are internal to the load geometry.
        Each interval between the node points is split into an entry in the returned geom-id-tab. The geom-id-tab is then deconstructed into
        relational from for the insert

        */



        SELECT CAST (
                   COLLECT (topo_nw_geom_id (t.id,
                                             t.geom,
                                             t.sn_id,
                                             t.en_id)) AS topo_nw_geom_id_tab)
          INTO l_topo_nw_tab
          FROM (  SELECT l1.sld_key,
                         CAST (
                             COLLECT (geom_id (n.node_id, node_geom --                                     nm_sdo.project_pt (sld_working_geometry,
                                                                   --                                                        node_geom,
                                                                   --                                                        g_sdo_tol)
                                                                   ))
                                 AS geom_id_tab)    node_tab
                    FROM sdl_wip_route_nodes nu,
                         sdl_wip_nodes      n,
                         sdl_load_data      l1
                   WHERE     nu.sld_key = p_sld_key
                         AND nu.hashcode = n.hashcode
                         AND l1.sld_key = nu.sld_key
                GROUP BY l1.sld_key) nnu,
               sdl_load_data  l,
               TABLE (multi_split (sld_working_geometry,
                                   node_tab,
                                   g_sdo_tol,
                                   g_m_tol)) t
         WHERE l.sld_key = nnu.sld_key AND l.sld_key = p_sld_key;


        INSERT INTO sdl_wip_datums (batch_id,
                                    sld_key,
                                    datum_id,
                                    geom)
            SELECT p_batch_id,
                   p_sld_key,
                   t.id,
                   t.geom
              FROM TABLE (l_topo_nw_tab) t
             WHERE    sn_id != en_id
                   OR SDO_GEOM.sdo_length (geom, g_sdo_tol) > p_tol_load;

        COMMIT;

        INSERT INTO sdl_wip_datum_nodes (swd_id,
                                         batch_id,
                                         hashcode,
                                         node_type,
                                         node_measure)
            SELECT d.swd_id,
                   d.batch_id,
                   hashcode,
                   'S',
                   nm_sdo.geom_segment_start_measure (t.geom)
              FROM sdl_wip_nodes n, TABLE (l_topo_nw_tab) t, sdl_wip_datums d
             WHERE     n.node_id = t.sn_id
                   AND d.datum_id = t.id
                   AND d.sld_key = p_sld_key
                   AND d.batch_id = p_batch_id
            UNION ALL
            SELECT d.swd_id,
                   d.batch_id,
                   hashcode,
                   'E',
                   nm_sdo.geom_segment_end_measure (t.geom)
              FROM sdl_wip_nodes n, TABLE (l_topo_nw_tab) t, sdl_wip_datums d
             WHERE     n.node_id = t.en_id
                   AND d.datum_id = t.id
                   AND d.sld_key = p_sld_key
                   AND d.batch_id = p_batch_id;
    END;

    FUNCTION multi_split (p_line      IN SDO_GEOMETRY,
                          pt_tab      IN geom_id_tab,
                          p_sdo_tol   IN NUMBER,
                          p_m_tol     IN NUMBER)
        RETURN topo_nw_geom_id_tab
    IS
        retval    topo_nw_geom_id_tab;
        l_geom    SDO_GEOMETRY;
        n_ptr     ptr_array_type;
        seg_ids   int_array_type;
    BEGIN
        nm_debug.debug_on;
        nm_debug.delete_debug (TRUE);
        nm_debug.debug ('Tols = ' || p_sdo_tol || ' and ' || p_m_tol);

        --
        IF p_line.sdo_gtype IN (2002, 2006)
        THEN
            l_geom :=
                NM_SDO.REDEFINE_GEOM (p_line,
                                      0,
                                      SDO_GEOM.sdo_length (p_line));
        ELSIF p_line.sdo_gtype NOT IN (3302, 3306)
        THEN
            raise_application_error (-20010,
                                     'The function requires an LRS geometry');
        ELSE
            l_geom := p_line;
        END IF;

        WITH
            geom_data
            AS
                (SELECT p.id p_id, p.geom p_geom
                   FROM TABLE (pt_tab) p),
            geom_proj
            AS
                (SELECT p_id,
                        ROW_NUMBER () OVER (ORDER BY t.geom.sdo_point.z)
                            seg_id,
                        l_geom,
                        t.geom,
                        t.geom.sdo_point.z
                            mval
                   FROM geom_data,
                        TABLE (nm_sdo.project_pt_m (l_geom,
                                                    p_geom,
                                                    p_sdo_tol,
                                                    p_m_tol)) t)
        --select * from geom_proj
        --
        SELECT --cast (collect( ptr(prev_id, p_id)) as ptr_array_type ) n_ptr,
                        --cast (collect( rownum ) as int_array_type ) seg_ids,
              CAST (COLLECT (topo_nw_geom_id (ROWNUM,
                                              --                                              mdsys.sdo_lrs.clip_geom_segment (l_geom,
                                              --                                                           prior_mval,
                                              --                                                           mval,
                                              --                                                           p_sdo_tol),
                                              nm_sdo.clip (l_geom,
                                                           prior_mval,
                                                           mval,
                                                           p_sdo_tol),
                                              prev_id,
                                              p_id)
                             ORDER BY seg_id) AS topo_nw_geom_id_tab)
         INTO retval
         FROM (  SELECT p_id,
                        seg_id,
                        LAG (p_id, 1) OVER (ORDER BY mval)
                            prev_id,
                        l_geom,
                        NVL (LAG (mval, 1) OVER (ORDER BY mval),
                             nm_sdo.geom_segment_start_measure (l_geom))
                            prior_mval,
                        mval,
                        NVL (LEAD (mval, 1) OVER (ORDER BY mval),
                             nm_sdo.geom_segment_end_measure (l_geom))
                            next_mval
                   FROM (SELECT p_id, seg_id, l_geom, mval FROM geom_proj)
               ORDER BY mval)
        WHERE prev_id IS NOT NULL;

        --        WHERE prior_mval > 0 OR mval > 0;


        RETURN retval;
    END;

    PROCEDURE cleanup (p_batch_id IN NUMBER, tolerance IN NUMBER)
    IS
        -- cleanup any overshoots with existing network. They can be found as a datum which relates to a node formed
        -- from an intersection with existing where the length is less than tolerance and the

        l_swd_ids   int_array_type;
    BEGIN
        SELECT CAST (COLLECT (swd_id) AS int_array_type)
          INTO l_swd_ids
          FROM sdl_wip_datums
         WHERE     batch_id = p_batch_id
               AND swd_id IN
                       (SELECT d.swd_id
                          FROM sdl_wip_nodes        n,
                               sdl_wip_datums       d,
                               sdl_wip_datum_nodes  dn
                         WHERE     dn.hashcode = n.hashcode
                               AND dn.swd_id = d.swd_id
                               AND EXISTS
                                       (SELECT 1
                                          FROM sdl_wip_pt_arrays    a,
                                               sdl_wip_intsct_geom  g,
                                               TABLE (ia)           t
                                         WHERE     g.r_id = t.COLUMN_VALUE
                                               AND a.hashcode = n.hashcode
                                               AND intsct_type = 'EXISTING'
                                               AND relation =
                                                   'OVERLAPBDYDISJOINT')
                               AND SDO_GEOM.sdo_length (d.geom, g_sdo_tol) <
                                   tolerance);

        DELETE FROM sdl_wip_datum_nodes
              WHERE swd_id IN (SELECT COLUMN_VALUE FROM TABLE (l_swd_ids));

        DELETE FROM sdl_wip_datums
              WHERE swd_id IN (SELECT COLUMN_VALUE FROM TABLE (l_swd_ids));

        --      Possible to clean up the nodes that are not related to datums

        DELETE FROM sdl_wip_nodes n
              WHERE     batch_id = p_batch_id
                    AND NOT EXISTS
                            (SELECT 1
                               FROM sdl_wip_datum_nodes nu
                              WHERE     nu.batch_id = n.batch_id
                                    AND nu.hashcode = n.hashcode)
                    AND NOT EXISTS
                            (SELECT 1
                               FROM sdl_wip_route_nodes nu
                              WHERE     nu.batch_id = n.batch_id
                                    AND nu.hashcode = n.hashcode);

        BEGIN
            FOR irec IN (SELECT *
                           FROM v_sdl_disconnected_network
                          WHERE batch_id = p_batch_id)
            LOOP
                BEGIN
                    UPDATE sdl_wip_datums
                       SET geom =
                               SDO_UTIL.remove_duplicate_vertices (
                                   set_terminal_vertex (geom,
                                                        irec.node_geom,
                                                        irec.node_type),
                                   g_sdo_tol)
                     WHERE swd_id = irec.swd_id;
                END;
            END LOOP;
        END;
    END;

    FUNCTION set_terminal_vertex (p_geom            IN SDO_GEOMETRY,
                                  p_pt              IN SDO_GEOMETRY,
                                  p_terminal_type   IN VARCHAR2)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY := p_geom;
    BEGIN
        IF p_terminal_type = 'S'
        THEN
            retval.sdo_ordinates (1) := p_pt.sdo_point.x;
            retval.sdo_ordinates (2) := p_pt.sdo_point.y;
        ELSIF p_terminal_type = 'E'
        THEN
            retval.sdo_ordinates (retval.sdo_ordinates.LAST - 2) :=
                p_pt.sdo_point.x;
            retval.sdo_ordinates (retval.sdo_ordinates.LAST - 1) :=
                p_pt.sdo_point.y;
        END IF;

        RETURN retval;
    END;
END;
/
