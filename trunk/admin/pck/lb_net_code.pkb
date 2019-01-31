CREATE OR REPLACE PACKAGE BODY lb_net_code
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/lb_net_code.pkb-arc   1.3   Jan 31 2019 15:13:58   Rob.Coupe  $
    --       Module Name      : $Workfile:   lb_net_code.pkb  $
    --       Date into PVCS   : $Date:   Jan 31 2019 15:13:58  $
    --       Date fetched Out : $Modtime:   Jan 30 2019 15:02:00  $
    --       PVCS Version     : $Revision:   1.3  $
    --
    --   Author : R.A. Coupe
    --
    --   Location Bridge package for snapping and net-coding
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.3  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'lb_net_code';

    PROCEDURE append_text (pi_in_text VARCHAR2, po_out_text IN OUT CLOB);

    FUNCTION get_nw_themes_for_inv_type (pi_inv_type IN VARCHAR2)
        RETURN nm_theme_array_type;

    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    --
    -----------------------------------------------------------------------------
    --

    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    PROCEDURE append_text (pi_in_text VARCHAR2, po_out_text IN OUT CLOB)
    IS
        lf   VARCHAR2 (2) := CHR (10) || CHR (13);
    BEGIN
        --       if nvl(length(po_out_text),0) <= 4000 - nvl(length(pi_in_text),0) then
        DBMS_LOB.append (po_out_text, lf || pi_in_text);
    --       else
    --          raise_application_error(-20099, 'Problem in append_text - sizes are '||to_char(length( pi_in_text))||', '||to_char(length( po_out_text)));
    --       end if;
    END;

    --
    FUNCTION get_nw_themes_for_inv_type (pi_inv_type IN VARCHAR2)
        RETURN nm_theme_array_type
    IS
        retval   nm_theme_array_type;
    BEGIN
        SELECT nm_theme_entry (nth_theme_id)
          BULK COLLECT INTO retval
          FROM nm_themes_all,
               nm_inv_nw,
               nm_nw_themes,
               nm_linear_types
         WHERE     nin_nit_inv_code = pi_inv_type
               AND nnth_nlt_id = nlt_id
               AND nnth_nth_theme_id = nth_theme_id
               AND nlt_g_i_d = 'D'
               AND nlt_nt_type = nin_nw_type
               AND nth_base_table_theme IS NOT NULL;

        RETURN retval;
    END;

    -----------------------------------------------------------------------------
    --

    FUNCTION lb_snap_xy_to_nw (
        pi_x                  IN NUMBER,
        pi_y                  IN NUMBER,
        pi_in_srid            IN NUMBER,
        pi_buffer             IN NUMBER,
        pi_in_uol             IN nm_units.un_unit_id%TYPE,
        pi_out_srid           IN NUMBER,
        pi_measure_out_uol    IN nm_units.un_unit_id%TYPE,
        pi_distance_out_uol   IN nm_units.un_unit_id%TYPE,
        pi_themes             IN nm_theme_array_type,
        CARDINALITY           IN INTEGER)
        RETURN lb_snap_tab
    AS
        retval                 lb_snap_tab;
        l_sql                  VARCHAR2 (4000);
        qq                     CHAR (1) := CHR (39);
        tol                    NUMBER := 0.005;
        l_units_in             nm_units.un_unit_name%TYPE;
        l_measure_units_out    nm_units.un_unit_name%TYPE;
        l_distance_units_out   nm_units.un_unit_name%TYPE;

        invalid_unit           EXCEPTION;
        PRAGMA EXCEPTION_INIT (invalid_unit, -29902);
    BEGIN
        /*
          Check the supplied units
        */
        BEGIN
            SELECT un_unit_name
              INTO l_units_in
              FROM nm_units
             WHERE un_unit_id = pi_in_uol;

            SELECT un_unit_name
              INTO l_measure_units_out
              FROM nm_units
             WHERE un_unit_id = pi_measure_out_uol;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20010,
                    'Unit of measure not found, check Exor units data');
        END;

        BEGIN
            WITH
                themes
                AS
                    (SELECT t.*,
                            nlt_id,
                            nlt_units,
                            pi_in_srid     in_srid
                       FROM TABLE (pi_themes)  t,
                            nm_nw_themes,
                            nm_linear_types
                      WHERE     nlt_id = nnth_nlt_id
                            AND nnth_nth_theme_id = nthe_id)
            SELECT LISTAGG (
                          ' select s.'
                       || nth_feature_pk_column
                       || ' ne_id'
                       || ', s.'
                       || nth_feature_shape_column
                       || ' geom , '
                       || nlt_id
                       || ' nlt_id, '
                       || CASE in_srid
                              WHEN srid
                              THEN
                                  ' in_pt.pt_input_geom '
                              ELSE
                                     'sdo_cs.transform(in_pt.pt_input_geom, '
                                  || srid
                                  || ') '
                          END
                       || ' pt_input_geom '
                       || ', '
                       || nlt_units
                       || ' base_nw_unit, '
                       || pi_in_srid
                       || ' in_srid, '
                       || srid
                       || ' base_srid, '
                       || pi_out_srid
                       || ' out_srid '
                       || 'FROM '
                       || nth_feature_table
                       || ' s, in_pt '
                       || ' WHERE sdo_within_distance ( '
                       || nth_feature_shape_column
                       || ', '
                       || CASE in_srid
                              WHEN srid
                              THEN
                                  ' pt_input_geom, '
                              ELSE
                                     'sdo_cs.transform(pt_input_geom, '
                                  || srid
                                  || '), '
                          END
                       || ' buffer_string) = '
                       || ''''
                       || 'TRUE'
                       || '''',
                       ' union all ')
                   WITHIN GROUP (ORDER BY nthe_id)
              INTO l_sql
              --, nth_theme_id, nth_feature_table, nth_feature_shape_column, nth_feature_pk_column
              FROM nm_themes_all, themes, user_sdo_geom_metadata
             WHERE nthe_id = nth_theme_id AND nth_feature_table = table_name;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20011,
                    'The list of themes does not match the Exor network themes');
        END;

        IF l_sql IS NULL
        THEN
            raise_application_error (
                -20012,
                'The list of themes does not match the Exor network themes');
        END IF;

        --      nm_debug.debug ('SQL = ' || l_sql);


        BEGIN
            l_sql :=
                   ' WITH '
                || '  in_pt as ( select '
                || qq
                || 'distance = '
                || qq
                || '||to_char(:buffer)||'
                || qq
                || ' unit='
                || l_units_in
                || qq
                || ' buffer_string, '
                || '  sdo_geometry(2001, :in_srid, sdo_point_type( :x , :y, NULL), NULL, NULL) pt_input_geom, :out_srid out_srid, :out_uom out_uom from dual ), '
                || ' snaps AS ( '
                || l_sql
                || ')'
                || ' SELECT CAST (COLLECT (lb_snap(q1.ne_id, nlt_id, q1.ne_nt_type, q1.ne_gty_group_type, q1.ne_unique, q1.ne_descr, '
                || 'sdo_lrs.geom_segment_start_measure(proj_pt)*uc_conversion_factor, distance, '
                || TO_CHAR (pi_measure_out_uol)
                || ', '
                || qq
                || l_measure_units_out
                || qq
                || ','
                || ' case base_srid when out_srid then geom else sdo_cs.transform(geom, out_srid) end, '
                || ' case base_srid when out_srid then proj_pt else sdo_cs.transform(proj_pt, out_srid) end '
                || ' )) as lb_snap_tab ) '
                || ' FROM (SELECT /*+INDEX(e NE_PK) */ s.ne_id, s.nlt_id, e.ne_unique, e.ne_descr, e.ne_nt_type, e.ne_gty_group_type, pt_input_geom, in_srid, out_srid, base_srid,'
                || '  SDO_LRS.project_pt ( geom, pt_input_geom) '
                || '   proj_pt, '
                || '  sdo_geom.sdo_distance ( geom, pt_input_geom, :tol, '
                || qq
                || 'unit='
                || l_measure_units_out
                || qq
                || ') distance, '
                || ' geom, '
                || ' base_nw_unit '
                || ' FROM snaps s, nm_elements e '
                || '     WHERE s.ne_id = e.ne_id order by 8 ) q1, nm_unit_conversions where uc_unit_id_in = base_nw_unit and uc_unit_id_out = :out_uol '
                || '        order by distance ';

            --       nm_debug.debug (l_sql);

            EXECUTE IMMEDIATE l_sql
                INTO retval
                USING pi_buffer,
                      pi_in_srid,
                      pi_x,
                      pi_y,
                      pi_out_srid,
                      pi_measure_out_uol,
                      tol,
                      pi_distance_out_uol;
        EXCEPTION
            WHEN invalid_unit
            THEN
                raise_application_error (
                    -20902,
                    'Invalid Unit, the Exor unit name must match the unit name in SDO_DIST_UNITS table');
        END;

        RETURN retval;
    END;

    FUNCTION lb_snap_xy_to_rpt_tab (
        pi_x                  IN NUMBER,
        pi_y                  IN NUMBER,
        pi_in_srid            IN NUMBER,
        pi_buffer             IN NUMBER,
        pi_in_uol             IN nm_units.un_unit_id%TYPE,
        pi_out_srid           IN NUMBER,
        pi_measure_out_uol    IN nm_units.un_unit_id%TYPE,
        pi_distance_out_uol   IN nm_units.un_unit_id%TYPE,
        CARDINALITY           IN INTEGER)
        RETURN lb_snap_tab
    IS
    BEGIN
        RETURN NULL;
    END;


    FUNCTION lb_snap_xy_to_nw (
        pi_x                  IN NUMBER,
        pi_y                  IN NUMBER,
        pi_in_srid            IN NUMBER,
        pi_buffer             IN NUMBER,
        pi_in_uol             IN nm_units.un_unit_id%TYPE,
        pi_out_srid           IN NUMBER,
        pi_measure_out_uol    IN nm_units.un_unit_id%TYPE,
        pi_distance_out_uol   IN nm_units.un_unit_id%TYPE,
        pi_inv_type           IN VARCHAR2,
        CARDINALITY           IN INTEGER)
        RETURN lb_snap_tab
    IS
        retval     lb_snap_tab;
        l_themes   nm_theme_array_type;
    BEGIN
        l_themes := get_nw_themes_for_inv_type (pi_inv_type);

        IF l_themes.COUNT = 0
        THEN
            raise_application_error (
                -20013,
                'The snapping cannot be performed because the inventory type does not relate to network themes');
        END IF;

        retval :=
            lb_snap_xy_to_nw (pi_x                  => pi_x,
                              pi_y                  => pi_y,
                              pi_in_srid            => pi_in_srid,
                              pi_buffer             => pi_buffer,
                              pi_in_uol             => pi_in_uol,
                              pi_out_srid           => pi_out_srid,
                              pi_measure_out_uol    => pi_measure_out_uol,
                              pi_distance_out_uol   => pi_distance_out_uol,
                              pi_themes             => l_themes,
                              CARDINALITY           => CARDINALITY);
        RETURN retval;
    END;
    
    --

    FUNCTION trace_geom (pi_geom           IN     SDO_GEOMETRY,
                         pi_themes         IN     nm_theme_array_type,
                         pi_must_connect   IN     VARCHAR2,
                         pi_buffer         IN     NUMBER DEFAULT 20,
                         pi_buffer_unit    IN     INTEGER DEFAULT 1, /*meters*/
                         pi_ratio_limit    IN     NUMBER,
                         po_trace_text     IN OUT CLOB)
        RETURN lb_rpt_tab
    IS
        retval                 lb_rpt_tab;
        vertices               nm_vertex_tab := nm_sdo.get_vertices (pi_geom);
        l_initial_path         lb_rpt_tab;
        l_vertex_count         INTEGER := vertices.COUNT;
        l_path                 lb_rpt_tab;
        l_lref                 nm_lref;
        no_connectivity        EXCEPTION;
        PRAGMA EXCEPTION_INIT (no_connectivity, -20001);
        l_lost_connectivity    BOOLEAN := FALSE;
        l_xy_to_m_conversion   NUMBER;
        l_nw_unit              INTEGER;
    --
    BEGIN
        --
        --        nm_debug.debug ('Start of trace');
        po_trace_text := 'Start of trace';

        l_xy_to_m_conversion :=
            nm_srid.get_xy_to_m_conversion (pi_geom.sdo_srid,
                                            pi_themes,
                                            l_nw_unit);

        append_text ('Conversion factor = ' || l_xy_to_m_conversion,
                     po_trace_text);

        --
        -- if there is only one vertex then just use the snapped value and return the point
        --
        IF l_vertex_count = 0
        THEN
            raise_application_error (-20001, 'No geometry');
        ELSIF l_vertex_count = 1
        THEN
            raise_application_error (-20002, 'Cant do points yet');
        ELSE
            --
            --nm_debug.delete_debug(true);
            --nm_debug.debug_on;
            --
            -- get the initial minimal path from the first two vertices
            --            nm_debug.debug (
            --                'get the initial minimal path from the first two vertices');

            BEGIN
                retval :=
                    get_minimal_path_from_vertices (pi_geom,
                                                    retval,
                                                    1,
                                                    2,
                                                    pi_themes,
                                                    pi_buffer,
                                                    pi_buffer_unit,
                                                    l_nw_unit,
                                                    l_xy_to_m_conversion,
                                                    pi_ratio_limit,
                                                    po_trace_text);

                append_text (
                    'Retrieved inital path between first two vertices',
                    po_trace_text);
            EXCEPTION
                WHEN no_connectivity
                THEN
                    --                    nm_debug.debug (
                    --                        'No connectivity between vertices 1 and 2 ');
                    append_text ('No connectivity at the start of tracing',
                                 po_trace_text);
                    raise_application_error (
                        -20001,
                        'No Connectivity at the start of tracing');
            END;

            --            nm_debug.debug (
            --                   'Retrieved minial LCP from first two vertices, terminating at nm_lref('
            --                || retval (retval.LAST).refnt
            --                || ', '
            --                || CASE retval (retval.LAST).dir_flag
            --                       WHEN 1 THEN retval (retval.LAST).end_m
            --                       ELSE retval (retval.LAST).start_m
            --                   END
            --                || ')');

            FOR iv IN 3 .. vertices.COUNT
            LOOP
                --                nm_debug.debug ('In loop at vertex ' || TO_CHAR (iv));
                l_lref :=
                    nm_lref (
                        retval (retval.LAST).refnt,
                        CASE retval (retval.LAST).dir_flag
                            WHEN 1 THEN retval (retval.LAST).end_m
                            ELSE retval (retval.LAST).start_m
                        END);

                append_text (
                       'Last linear reference of path = nm_lref('
                    || l_lref.lr_ne_id
                    || ','
                    || l_lref.lr_offset
                    || ')',
                    po_trace_text);

                append_text ('Attempt to trace to vertex ' || iv,
                             po_trace_text);

                --                nm_debug.debug (
                --                       'In loop - count = '
                --                    || iv
                --                    || ' attempt join from terminating nm_lref('
                --                    || l_lref.lr_ne_id
                --                    || ', '
                --                    || l_lref.lr_offset
                --                    || ')');

                BEGIN
                    l_path :=
                        get_minimal_adjoining_path (
                            pi_geom,
                            retval,
                            sdo_geometry (
                                2001,
                                pi_geom.sdo_srid,
                                sdo_point_type (vertices (iv - 1).x,
                                                vertices (iv - 1).y,
                                                NULL),
                                NULL,
                                NULL),
                            l_lref,
                            iv,
                            pi_themes,
                            pi_buffer,
                            pi_buffer_unit,
                            l_nw_unit,
                            l_xy_to_m_conversion,
                            pi_ratio_limit,
                            po_trace_text);

                    IF l_path IS NULL
                    THEN
                        append_text (
                            'No path retrieved, raising no-connectivity',
                            po_trace_text);
                        --                        nm_debug.debug (
                        --                            'Path count is zero, raise no-connectivity');
                        RAISE no_connectivity;
                    END IF;
                EXCEPTION
                    WHEN no_connectivity
                    THEN
                        --                   nm_debug.debug_on;
                        IF pi_must_connect = 'Y'
                        THEN
                            raise_application_error (
                                -20099,
                                'Using with the must-connect flag set on an no connectivity');
                        END IF;

                        l_lost_connectivity := TRUE; -- we need to terminate existing table and append a new segment using the minimal LCP from vertex iv to the next.

                        --                        nm_debug.debug (
                        --                               'no-connectivity between last LR and new vertex '
                        --                            || TO_CHAR (iv));

                        BEGIN
                            append_text (
                                   'Find path between vertices '
                                || TO_CHAR (iv - 1)
                                || ' and '
                                || TO_CHAR (iv),
                                po_trace_text);
                            l_path :=
                                get_minimal_path_from_vertices (
                                    pi_geom,
                                    retval,
                                    iv - 1,
                                    iv,
                                    pi_themes,
                                    pi_buffer,
                                    pi_buffer_unit,
                                    l_nw_unit,
                                    l_xy_to_m_conversion,
                                    pi_ratio_limit,
                                    po_trace_text);
                            l_lost_connectivity := FALSE;
                        --                            nm_debug.debug (
                        --                                   'Now using path between vertices '
                        --                                || TO_CHAR (iv - 1)
                        --                                || ' and '
                        --                                || TO_CHAR (iv));
                        EXCEPTION
                            WHEN no_connectivity
                            THEN
                                append_text (
                                    'No connectivity raised in get_minimal_path_from_vertices',
                                    po_trace_text);

                                l_lost_connectivity := TRUE;
                        END;
                --                    IF l_path.COUNT = 0
                --                    THEN
                ----                        nm_debug.debug('Setting no connectivity flag');
                --                        l_lost_connectivity := TRUE;
                --                    END IF;
                END;

                IF NOT l_lost_connectivity AND l_path IS NOT NULL
                THEN
                    BEGIN
                        retval := lb_ops.rpt_append (retval, l_path, 10);
                        --                nm_debug.debug (
                        --                       'Append terminating at '
                        --                    || retval (retval.LAST).refnt
                        --                    || ', '
                        --                    || CASE retval (retval.LAST).dir_flag
                        --                           WHEN 1 THEN retval (retval.LAST).end_m
                        --                           ELSE retval (retval.LAST).start_m end );
                        append_text (
                               'Path appended terminating at nm_lref('
                            || retval (retval.LAST).refnt
                            || CASE retval (retval.LAST).dir_flag
                                   WHEN 1 THEN retval (retval.LAST).end_m
                                   ELSE retval (retval.LAST).start_m
                               END
                            || ')',
                            po_trace_text);
                    END;
                END IF;
            END LOOP;
        END IF;

        RETURN retval;
    END;

    FUNCTION trace_geom (pi_geom           IN SDO_GEOMETRY,
                         pi_themes         IN nm_theme_array_type,
                         pi_must_connect   IN VARCHAR2,
                         pi_buffer         IN NUMBER DEFAULT 20,
                         pi_buffer_unit    IN INTEGER DEFAULT 1,    /*meters*/
                         pi_ratio_limit    IN NUMBER)
        RETURN lb_rpt_tab
    IS
        l_trace_output   CLOB;
        retval           lb_rpt_tab;
    BEGIN
        retval :=
            lb_net_code.trace_geom (pi_geom           => pi_geom,
                                    pi_themes         => pi_themes,
                                    pi_must_connect   => pi_must_connect,
                                    pi_buffer         => pi_buffer,
                                    pi_buffer_unit    => pi_buffer_unit,
                                    pi_ratio_limit    => pi_ratio_limit,
                                    po_trace_text     => l_trace_output);
        RETURN retval;
    END;


    FUNCTION get_minimal_adjoining_path (
        pi_geom          IN     SDO_GEOMETRY,
        existing_path    IN     lb_rpt_tab,
        pi_pt_geom       IN     SDO_GEOMETRY,
        pi_lref          IN     nm_lref,
        pi_vid           IN     INTEGER,
        pi_themes        IN     nm_theme_array_type,
        pi_buffer        IN     NUMBER,
        pi_buffer_unit   IN     INTEGER,
        pi_nw_unit       IN     INTEGER,
        pi_conv_factor   IN     NUMBER,
        pi_ratio_limit   IN     NUMBER,
        po_trace_text    IN OUT CLOB)
        RETURN lb_rpt_tab
    IS
        retval                lb_rpt_tab;
        --    l_dbg    BOOLEAN := nm_debug.is_debug_on;

        l_min_count           INTEGER;
        l_min_length          NUMBER;
        l_path_count          INTEGER;
        l_path_length         NUMBER;
        l_distance_between    NUMBER;
        l_min_distance_from   NUMBER;
        l_max_distance_from   NUMBER;
        l_order               NUMBER;
        no_connectivity       EXCEPTION;
        PRAGMA EXCEPTION_INIT (no_connectivity, -20001);
    BEGIN
        --    IF l_dbg
        --    THEN
        --        nm_debug.debug_off;
        --    END IF;

        SELECT v_path,
               min_count,
               min_len,
               path_count,
               p_len,
               distance_between,
               min_distance_from,
               max_distance_from,
               ABS (p_len - min_len) / min_len             --/( p_len+min_len)
          --                 (  (min_distance_from + max_distance_from)
          --                  / 2
          --                  * max_distance_from)
          --               * (1 + (p_len - min_len) / min_len)
          --               * (1 + (p_len - distance_between) / p_len)
          INTO retval,
               l_min_count,
               l_min_length,
               l_path_count,
               l_path_length,
               l_distance_between,
               l_min_distance_from,
               l_max_distance_from,
               l_order
          FROM (WITH
                    trace_vertices
                    AS
                        (SELECT t.id v_id, t.x v_x, t.y v_y
                           FROM TABLE (nm_sdo.get_vertices (pi_geom)) t),
                    vertices (v_id,
                              v_x,
                              v_y,
                              ne_id,
                              nlt_id,
                              measure,
                              distance_from)
                    AS
                        (SELECT v_id,
                                v_x,
                                v_y,
                                ne_id,
                                nlt_id,
                                measure,
                                distance_from
                           FROM trace_vertices,
                                TABLE (LB_NET_CODE.LB_SNAP_XY_TO_NW (
                                           v_x,
                                           v_y,
                                           pi_geom.sdo_srid,
                                           pi_buffer,
                                           pi_buffer_unit,
                                           pi_geom.sdo_srid,
                                           pi_nw_unit,
                                           pi_nw_unit,
                                           pi_themes,
                                           10)) t
                          WHERE v_id = pi_vid),
                    v_snap
                    AS
                        (SELECT v1.v_id,
                                v1.v_x,
                                v1.v_y,
                                v1.ne_id,
                                v1.measure,
                                distance_from,
                                  SDO_GEOM.sdo_distance (
                                      pi_pt_geom,
                                      sdo_geometry (
                                          2001,
                                          pi_geom.sdo_srid,
                                          sdo_point_type (v1.v_x,
                                                          v1.v_y,
                                                          NULL),
                                          NULL,
                                          NULL))
                                * pi_conv_factor    distance_between
                           FROM vertices v1
                          WHERE v1.v_id = pi_vid)
                  --select * from v_snap
                  SELECT *
                    FROM (SELECT t2.*,
                                 MIN (p_count) OVER (PARTITION BY v_id)
                                     min_count,
                                 MIN (p_len) OVER (PARTITION BY v_id)
                                     min_len,
                                 COUNT (*) OVER (PARTITION BY v_id)
                                     path_count,
                                 MIN (distance_from) OVER (PARTITION BY v_id)
                                     min_distance_from,
                                 MAX (distance_from) OVER (PARTITION BY v_id)
                                     max_distance_from
                            FROM (SELECT t1.*,
                                         lb_get.get_count (v_path)         p_count,
                                         lb_get.get_length (v_path, 1)     p_len
                                    FROM (SELECT v_id,
                                                 ne_id,
                                                 measure,
                                                 distance_between,
                                                 distance_from,
                                                 get_trace_path (
                                                     pi_lref,
                                                     nm_lref (ne_id, measure))    v_path
                                            FROM v_snap w) t1) t2) t3
                   WHERE 1 = 1 AND distance_between / p_len > pi_ratio_limit
                ORDER BY (min_distance_from + max_distance_from) / 2,
                         ABS (p_len - distance_between) / distance_between --                   /( (min_distance_from+max_distance_from)/2)
                                                                          --                   abs(p_len - distance_between )/distance_between;
                                                                          --                   order by min_distance_from/( (min_distance_from+max_distance_from)/2) * abs(p_len - distance_between )/distance_between, min_distance_from
                                                                          --                ORDER BY   (  (min_distance_from + max_distance_from)
                                                                          --                            / 2
                                                                          --                            * max_distance_from)
                                                                          --                         * (1 + (p_len - min_len) / min_len)
                                                                          --                         * (1 + (p_len - distance_between) / p_len)
                                                                          )
         WHERE ROWNUM = 1;

        append_text (
               'Found, r = '
            || TO_CHAR (l_order)
            || ', length = '
            || TO_CHAR (l_path_length)
            || ',  between = '
            || TO_CHAR (l_distance_between),
            po_trace_text);

        IF l_order > pi_ratio_limit
        THEN                                        --p_length_difference then
            append_text (
                   'Problem with path adjoining LR at vertex '
                || TO_CHAR (pi_vid)
                || ' -  path length and distance between vertices = '
                || TO_CHAR (l_path_length)
                || ','
                || TO_CHAR (l_distance_between)
                || 'ratio of segment to path length = '
                || TO_CHAR (l_order),
                po_trace_text);

            --            nm_debug.debug_on;
            --            nm_debug.debug (
            --                   'Problem with path adjoining LR at vertex '
            --                || pi_vid
            --                || ' -  path length and distance between vertices = '
            --                || l_path_length
            --                || ','
            --                || l_distance_between);
            --            nm_debug.debug_off;
            RAISE no_connectivity;
        END IF;

        --
        --    IF l_dbg
        --    THEN
        --        nm_debug.debug_on;
        --    END IF;

        append_text (
               'Path from LR nm_lref('
            || pi_lref.lr_ne_id
            || ','
            || pi_lref.lr_offset
            || ') to vertex '
            || pi_vid
            || ' element-count = '
            || l_min_count
            || ', length = '
            || l_min_length
            || ', path_count = '
            || l_path_count,
            po_trace_text);
        nm_debug.debug (
               'Path from LR nm_lref('
            || pi_lref.lr_ne_id
            || ','
            || pi_lref.lr_offset
            || ') to vertex '
            || pi_vid
            || ' element-count = '
            || l_min_count
            || ', length = '
            || l_min_length
            || ', path_count = '
            || l_path_count);

        RETURN retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            append_text (
                'No data found in the get_minimal_adjoining_path - raising no-connectivity',
                po_trace_text);
            --      nm_debug.debug('get_minimal_adjoining_path - no-data-found from LR nm_lref('||pi_lref.lr_ne_id||','||pi_lref.lr_offset||') to vertex '||vid );
            RAISE no_connectivity;
    END;

    FUNCTION get_minimal_path_from_vertices (
        pi_geom          IN     SDO_GEOMETRY,
        existing_path    IN     lb_rpt_tab,
        pi_vid1          IN     INTEGER,
        pi_vid2          IN     INTEGER,
        pi_themes        IN     nm_theme_array_type,
        pi_buffer        IN     NUMBER,
        pi_buffer_unit   IN     INTEGER,
        pi_nw_unit       IN     INTEGER,
        pi_conv_factor   IN     NUMBER,
        pi_ratio_limit   IN     NUMBER,
        po_trace_text    IN OUT CLOB)
        RETURN lb_rpt_tab
    IS
        retval                lb_rpt_tab;
        l_min_count           INTEGER;
        l_min_length          NUMBER;
        l_path_count          INTEGER;
        l_path_length         NUMBER;
        l_distance_between    NUMBER;
        l_min_distance_from   NUMBER;
        l_max_distance_from   NUMBER;
        l_order               NUMBER;
        l_ratio               NUMBER;

        --    l_dbg    BOOLEAN := nm_debug.is_debug_on;
        no_connectivity       EXCEPTION;
        PRAGMA EXCEPTION_INIT (no_connectivity, -20001);
    BEGIN
        --    IF l_dbg
        --    THEN
        --        nm_debug.debug_off;
        --    END IF;

        SELECT v_path,
               min_count,
               min_len,
               path_count,
               p_len,
               distance_between,
               min_distance_from,
               max_distance_from,
               ((min_distance_from + max_distance_from) / 2),
               distance_between / p_len
          --                  / 2
          --                  * max_distance_from)
          --               * (1 + (p_len - min_len) / min_len)
          --               * (1 + (p_len - distance_between) / p_len)
          INTO retval,
               l_min_count,
               l_min_length,
               l_path_count,
               l_path_length,
               l_distance_between,
               l_min_distance_from,
               l_max_distance_from,
               l_order,
               l_ratio
          FROM (WITH
                    trace_vertices
                    AS
                        (SELECT t.id v_id, t.x v_x, t.y v_y
                           FROM TABLE (nm_sdo.get_vertices (pi_geom)) t),
                    vertices (v_id,
                              v_x,
                              v_y,
                              ne_id,
                              nlt_id,
                              measure,
                              distance_from)
                    AS
                        (SELECT v_id,
                                v_x,
                                v_y,
                                ne_id,
                                nlt_id,
                                measure,
                                t.distance_from
                           FROM trace_vertices,
                                TABLE (LB_NET_CODE.LB_SNAP_XY_TO_NW (
                                           v_x,
                                           v_y,
                                           pi_geom.sdo_srid,
                                           pi_buffer,
                                           pi_buffer_unit,
                                           pi_geom.sdo_srid,
                                           pi_nw_unit,
                                           pi_nw_unit,
                                           pi_themes,
                                           10)) t
                          WHERE v_id IN (pi_vid1, pi_vid2)),
                    v_interval (v1_id,
                                v1_x,
                                v1_y,
                                v1_ne_id,
                                v1_measure,
                                v2_id,
                                v2_x,
                                v2_y,
                                v2_ne_id,
                                v2_measure,
                                distance_between,
                                min_distance_from,
                                max_distance_from)
                    AS
                        (SELECT v1.v_id,
                                v1.v_x,
                                v1.v_y,
                                v1.ne_id,
                                v1.measure,
                                v2.v_id,
                                v2.v_x,
                                v2.v_y,
                                v2.ne_id,
                                v2.measure,
                                  SDO_GEOM.sdo_distance (
                                      sdo_geometry (
                                          2001,
                                          pi_geom.sdo_srid,
                                          sdo_point_type (v1.v_x,
                                                          v1.v_y,
                                                          NULL),
                                          NULL,
                                          NULL),
                                      sdo_geometry (
                                          2001,
                                          pi_geom.sdo_srid,
                                          sdo_point_type (v2.v_x,
                                                          v2.v_y,
                                                          NULL),
                                          NULL,
                                          NULL))
                                * pi_conv_factor,
                                LEAST (v1.distance_from, v2.distance_from)
                                    min_distance_from,
                                GREATEST (v1.distance_from, v2.distance_from)
                                    max_distance_from
                           FROM vertices v1, vertices v2
                          WHERE v1.v_id = pi_vid1 AND v2.v_id = pi_vid2)
                  --select * from v_interval
                  SELECT *
                    FROM (SELECT t2.*,
                                 MIN (p_count) OVER (PARTITION BY v1_id)
                                     min_count,
                                 MIN (p_len) OVER (PARTITION BY v1_id)
                                     min_len,
                                 COUNT (*) OVER (PARTITION BY v1_id)
                                     path_count
                            FROM (SELECT t1.*,
                                         lb_get.get_count (v_path)         p_count,
                                         lb_get.get_length (v_path, 1)     p_len
                                    --                             min_distance_from,
                                    --                             max_distance_from
                                    FROM (SELECT v1_id,
                                                 v2_id,
                                                 v1_ne_id,
                                                 v2_ne_id,
                                                 v1_measure,
                                                 v2_measure,
                                                 distance_between,
                                                 get_trace_path (
                                                     nm_lref (v1_ne_id,
                                                              v1_measure),
                                                     nm_lref (v2_ne_id,
                                                              v2_measure))
                                                     v_path,
                                                 min_distance_from,
                                                 max_distance_from
                                            FROM v_interval) t1) t2) t3
                   WHERE 1 = 1 AND distance_between / p_len > pi_ratio_limit
                ORDER BY (min_distance_from + max_distance_from) / 2,
                         --                   /( (min_distance_from+max_distance_from)/2)
                         ABS (p_len - distance_between) / distance_between --                ORDER BY  abs(p_len - distance_between )/distance_between ,min_distance_from
                                                                          --                (  (min_distance_from + max_distance_from)
                                                                          --                            / 2
                                                                          --                            * max_distance_from)
                                                                          --                         * (1 + (p_len - min_len) / min_len)
                                                                          --                         * (1 + (p_len - distance_between) / p_len)
                                                                          --               and abs(p_len - distance_between ) < p_length_difference
                                                                          )
         WHERE ROWNUM = 1;

        --        IF ABS (l_path_length - l_distance_between) / l_distance_between > pi_ratio_limit
        --        THEN                                        --p_length_difference then
        --            nm_debug.debug_on;
        --            nm_debug.debug (
        --                   'Problem with path between vertices '
        --                || pi_vid1
        --                || ', '
        --                || pi_vid2
        --                || ' -  path length and distance between vertices = '
        --                || l_path_length
        --                || ','
        --                || l_distance_between);
        --            nm_debug.debug_off;
        --            RAISE no_connectivity;
        --        END IF;

        --
        --    IF l_dbg
        --    THEN
        --        nm_debug.debug_on;
        --    END IF;

        append_text (
               'Path from vertices '
            || pi_vid1
            || ', '
            || pi_vid2
            || ' element-count = '
            || l_min_count
            || ', length = '
            || l_min_length
            || ', path_count = '
            || l_path_count,
            po_trace_text);
        nm_debug.debug (
               'Path from vertices '
            || pi_vid1
            || ', '
            || pi_vid2
            || ' element-count = '
            || l_min_count
            || ', length = '
            || l_min_length
            || ', path_count = '
            || l_path_count
            || ' ratio = '
            || TO_CHAR (l_ratio));

        RETURN retval;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            append_text (
                'No data found in the get_minimal_path_from_vertices - raising no-connectivity',
                po_trace_text);

            --      nm_debug.debug('get_minimal_adjoining_path - no-data-found from LR nm_lref('||pi_lref.lr_ne_id||','||pi_lref.lr_offset||') to vertex '||vid );
            RAISE no_connectivity;
    END;
END;
/