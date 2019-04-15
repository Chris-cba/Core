CREATE OR REPLACE PACKAGE BODY nm_sdo
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm_sdo.pkb-arc   1.19   Apr 15 2019 16:20:32   Rob.Coupe  $
    --       Module Name      : $Workfile:   nm_sdo.pkb  $
    --       Date into PVCS   : $Date:   Apr 15 2019 16:20:32  $
    --       Date fetched Out : $Modtime:   Apr 15 2019 16:19:16  $
    --       PVCS Version     : $Revision:   1.19  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling SDO data - acts as a the basis for the replacement of SDO_LRS
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is to replicate the functions inside the SDO_LRS package as
    -- supplied under the MDSYS schema and licensed under the Oracle Spatial license on EE.

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.19  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'NM_SDO';

    g_round          CONSTANT INTEGER := 18; -- the number of DP to round number return values. SDO_LRS is linked to code which

    -- return Java based-values. This means the values will be standard floating point values
    -- and are likely not to have the same number of decimal places.

    FUNCTION offset_whole_geom (geom        IN SDO_GEOMETRY,
                                offset      IN NUMBER,
                                tolerance      NUMBER)
        RETURN SDO_GEOMETRY
        DETERMINISTIC;

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

    --

    FUNCTION scale_vertices (geom            IN SDO_GEOMETRY,
                             geom_length     IN NUMBER DEFAULT NULL,
                             start_measure   IN NUMBER DEFAULT 0,
                             reuse_scale     IN VARCHAR2 DEFAULT 'Y')
        RETURN nm_vertex_tab;

    FUNCTION append_elem_info (elem_info      IN sdo_elem_info_array,
                               vertex_count   IN INTEGER)
        RETURN sdo_elem_info_array;

    FUNCTION get_terminations (geom IN SDO_GEOMETRY)
        RETURN nm_geom_terminations;

    PROCEDURE debug_terms (geom IN SDO_GEOMETRY);

    FUNCTION add_m (p_geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY;

    FUNCTION dist (x1   IN NUMBER,
                   y1   IN NUMBER,
                   x2   IN NUMBER,
                   y2   IN NUMBER)
        RETURN NUMBER;

    FUNCTION set_measure_on_intsct (p_lrs_geom   IN SDO_GEOMETRY,
                                    p_parts      IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY;


    FUNCTION clip_dbug (id              IN INTEGER,
                        geom            IN SDO_GEOMETRY,
                        start_measure   IN NUMBER,
                        end_measure     IN NUMBER)
        RETURN SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
        ord_array   sdo_ordinate_array;
        retval      SDO_GEOMETRY;
    BEGIN
        nm_debug.debug (
               'ID='
            || id
            || ','
            || geom.sdo_ordinates (1)
            || ','
            || geom.sdo_ordinates (2)
            || ','
            || start_measure
            || ','
            || end_measure);

          SELECT sdo_geometry (3302,
                               geom.sdo_srid,
                               NULL,
                               sdo_elem_info_array (1, 2, 1),
                               CAST (COLLECT (VALUE  /*ORDER BY rn, ordinate*/
                                                   ) AS sdo_ordinate_array))
            INTO retval
            FROM (WITH
                      ranges
                      AS
                          (SELECT start_measure, end_measure, q1.*
                             FROM (SELECT ROW_NUMBER () OVER (ORDER BY 1)
                                              rn,
                                          t.COLUMN_VALUE
                                              x1,
                                          LEAD (t.COLUMN_VALUE, 1)
                                              OVER (ORDER BY 1)
                                              y1,
                                          LEAD (t.COLUMN_VALUE, 2)
                                              OVER (ORDER BY 1)
                                              m1,
                                          LEAD (t.COLUMN_VALUE, 3)
                                              OVER (ORDER BY 1)
                                              x2,
                                          LEAD (t.COLUMN_VALUE, 4)
                                              OVER (ORDER BY 1)
                                              y2,
                                          LEAD (t.COLUMN_VALUE, 5)
                                              OVER (ORDER BY 1)
                                              m2
                                     FROM TABLE (geom.sdo_ordinates) t) q1
                            WHERE     MOD (rn, 3) = 1     --and m2 is not null
                                  AND m1 <= end_measure
                                  AND m2 >= start_measure)
                  --select r.* from ranges r ),
                  SELECT rn,
                         x1     A,
                         y1     B,
                         m1     C
                    FROM ranges
                   WHERE m1 > start_measure AND m2 < end_measure
                  UNION ALL
                  SELECT -1
                             rn, -- this is where the start measure is between two vertices - interpolate the xy's
                           x1
                         +   (GREATEST (m1, start_measure) - m1)
                           * (x2 - x1)
                           / (m2 - m1),
                           y1
                         +   (GREATEST (m1, start_measure) - m1)
                           * (y2 - y1)
                           / (m2 - m1),
                         GREATEST (m1, start_measure)
                    FROM ranges
                   WHERE m1 <= start_measure
                  UNION ALL
                  SELECT rn,
                         x1,
                         y1,
                         m1
                    FROM ranges
                   WHERE m2 >= end_measure
                  UNION ALL
                  SELECT 99999
                             rn, -- This is to ensure that the end vertex is included, possibly interpolated - may be better performance if the
                           x1
                         +   (LEAST (m2, end_measure) - m1)
                           * (x2 - x1)
                           / (m2 - m1),
                           y1
                         +   (LEAST (m2, end_measure) - m1)
                           * (y2 - y1)
                           / (m2 - m1),
                         LEAST (m2, end_measure)
                    FROM ranges
                   WHERE m2 >= end_measure
                  ORDER BY rn)
                 UNPIVOT EXCLUDE NULLS (VALUE FOR ordinate IN (A, B, C))
        ORDER BY rn, ordinate;

        RETURN retval;
    END;

    FUNCTION clip (geom            IN SDO_GEOMETRY,
                   start_measure   IN NUMBER,
                   end_measure     IN NUMBER,
                   tolerance       IN NUMBER DEFAULT 1.0e-8)
        RETURN SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
        ord_array         sdo_ordinate_array;
        retval            SDO_GEOMETRY;
        check_count       INTEGER;
        sm                NUMBER := SDO_LRS.geom_segment_start_measure (geom);
        em                NUMBER := SDO_LRS.geom_segment_end_measure (geom);
        l_tolerance       NUMBER; -- tolerance adjusted from XY unots to M units or meters
        l_start_measure   NUMBER := LEAST (start_measure, end_measure);
        l_end_measure     NUMBER := GREATEST (start_measure, end_measure);
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            l_tolerance := tolerance;

            IF geom.sdo_srid IS NOT NULL
            THEN
                IF nm_sdo_geom.is_geodetic (geom.sdo_srid) = 'TRUE'
                THEN
                    NULL;
                ELSE
                    l_tolerance :=
                          tolerance
                        * SDO_LRS.geom_segment_end_measure (geom)
                        / SDO_GEOM.sdo_length (geom);
                END IF;
            END IF;

            IF l_start_measure = sm AND l_end_measure = em
            THEN
                retval := geom;
            ELSIF l_start_measure > em OR l_end_measure < sm
            THEN
                retval := NULL;
            ELSIF ABS (l_end_measure - l_start_measure) < l_tolerance
            THEN
                retval := locate_pt (geom, l_start_measure);
            ELSE
                  SELECT sdo_geometry (
                             CASE
                                 WHEN ABS (l_end_measure - l_start_measure) <
                                      l_tolerance
                                 THEN
                                     3301
                                 ELSE
                                     3302
                             END,
                             geom.sdo_srid,
                             NULL,
                             CASE
                                 WHEN ABS (l_end_measure - l_start_measure) <
                                      l_tolerance
                                 THEN
                                     sdo_elem_info_array (1, 1, 1)
                                 ELSE
                                     sdo_elem_info_array (1, 2, 1)
                             END,
                             CAST (COLLECT (VALUE    /*ORDER BY rn, ordinate*/
                                                 ) AS sdo_ordinate_array)),
                         COUNT (*)
                             check_count
                    INTO retval, check_count
                    FROM (WITH
                              ranges
                              AS
                                  (SELECT l_start_measure,
                                          l_end_measure,
                                          MIN (rn) OVER (PARTITION BY 'A')
                                              min_rn,
                                          MAX (rn) OVER (PARTITION BY 'A')
                                              max_rn,
                                          l_tolerance,
                                          q1.*
                                     FROM (SELECT ROW_NUMBER ()
                                                      OVER (ORDER BY 1)
                                                      rn,
                                                  COUNT (*)
                                                      OVER (PARTITION BY 'A')
                                                      rc,
                                                  t.COLUMN_VALUE
                                                      x1,
                                                  LEAD (t.COLUMN_VALUE, 1)
                                                      OVER (ORDER BY 1)
                                                      y1,
                                                  LEAD (t.COLUMN_VALUE, 2)
                                                      OVER (ORDER BY 1)
                                                      m1,
                                                  LEAD (t.COLUMN_VALUE, 3)
                                                      OVER (ORDER BY 1)
                                                      x2,
                                                  LEAD (t.COLUMN_VALUE, 4)
                                                      OVER (ORDER BY 1)
                                                      y2,
                                                  LEAD (t.COLUMN_VALUE, 5)
                                                      OVER (ORDER BY 1)
                                                      m2
                                             FROM TABLE (geom.sdo_ordinates) t)
                                          q1
                                    WHERE     MOD (rn, 3) = 1 --and m2 is not null
                                          AND m1 <= l_end_measure + l_tolerance
                                          AND m2 >=
                                              l_start_measure - l_tolerance)
                          --                                            select r.* from ranges r
                          --
                          SELECT rn, -- this will retrieve all vertices which are wholly between the two measures
                                 x1     A,
                                 y1     B,
                                 m1     C
                            FROM ranges
                           WHERE     m1 >= l_start_measure - l_tolerance
                                 AND m1 <= l_end_measure + l_tolerance
                          UNION ALL
                          SELECT -1
                                     rn, -- this is where the start measure is between two vertices - interpolate the xy's
                                   x1
                                 +   (GREATEST (m1, l_start_measure) - m1)
                                   * (x2 - x1)
                                   / (m2 - m1),
                                   y1
                                 +   (GREATEST (m1, l_start_measure) - m1)
                                   * (y2 - y1)
                                   / (m2 - m1),
                                 GREATEST (m1, l_start_measure)
                            FROM ranges
                           WHERE     rn = min_rn
                                 AND m1 < l_start_measure
                                 AND m2 > l_start_measure
                                 AND ABS (m1 - l_start_measure) > l_tolerance
                                 AND ABS (m2 - l_start_measure) > l_tolerance
                          --                       and (abs(m1-greatest(start_measure, m1)) > tolerance )
                          UNION ALL
                          SELECT 99999
                                     rn, -- This is to ensure that the end vertex is included, possibly interpolated - may be better performance if the
                                   x1
                                 +   (LEAST (m2, l_end_measure) - m1)
                                   * (x2 - x1)
                                   / (m2 - m1),
                                   y1
                                 +   (LEAST (m2, l_end_measure) - m1)
                                   * (y2 - y1)
                                   / (m2 - m1),
                                 LEAST (m2, l_end_measure)
                            FROM ranges
                           WHERE     m1 < l_end_measure
                                 AND m2 >= l_end_measure - l_tolerance
                                 AND rn = max_rn
                          ORDER BY rn)
                         UNPIVOT EXCLUDE NULLS (VALUE
                                               FOR ordinate
                                               IN (A, B, C))
                ORDER BY rn, ordinate;

                IF check_count < 6
                THEN
                    IF check_count = 3
                    THEN
                        retval.sdo_gtype := 3301;
                        retval.sdo_elem_info := sdo_elem_info_array (1, 1, 1);
                    ELSE
                        DBMS_OUTPUT.put_line (
                            'Check count = ' || check_count);
                        raise_application_error (-20001,
                                                 'Invalid LRS Measure');
                    END IF;
                END IF;
            END IF;
        END IF;

        RETURN retval;
    END;

    FUNCTION clip_l (geom            IN SDO_GEOMETRY,
                     geom_length     IN NUMBER,
                     start_measure   IN NUMBER,
                     end_measure     IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
    BEGIN
        RETURN NULL;
    END;

    FUNCTION locate_pt_ptype (geom IN SDO_GEOMETRY, measure IN NUMBER)
        RETURN SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        --select sdo_geometry( 2001, NULL, sdo_point_type(x1 + start_measure * (x2 - x1) / (m2 - m1) ,
        --                              y1 + start_measure * (y2 - y1) / (m2 - m1), start_measure), null, null )
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            SELECT CASE
                       WHEN measure > m1 AND measure < m2
                       THEN
                           sdo_geometry (
                               3301,
                               geom.sdo_srid,
                               sdo_point_type (
                                     x1
                                   + (measure - m1) * (x2 - x1) / (m2 - m1),
                                     y1
                                   + (measure - m1) * (y2 - y1) / (m2 - m1),
                                   measure),
                               NULL,
                               NULL)
                       WHEN measure = m1
                       THEN
                           sdo_geometry (3301,
                                         geom.sdo_srid,
                                         sdo_point_type (x1, y1, m1),
                                         NULL,
                                         NULL)
                       WHEN measure = m2
                       THEN
                           sdo_geometry (3301,
                                         geom.sdo_srid,
                                         sdo_point_type (x2, y2, m2),
                                         NULL,
                                         NULL)
                       ELSE
                           NULL
                   END
              INTO retval
              FROM (SELECT ROW_NUMBER () OVER (ORDER BY rn)     rn,
                           x1,
                           y1,
                           m1,
                           x2,
                           y2,
                           m2
                      FROM (SELECT ROW_NUMBER () OVER (ORDER BY 1)
                                       rn,
                                   t.COLUMN_VALUE
                                       x1,
                                   LEAD (t.COLUMN_VALUE, 1) OVER (ORDER BY 1)
                                       y1,
                                   LEAD (t.COLUMN_VALUE, 2) OVER (ORDER BY 1)
                                       m1,
                                   LEAD (t.COLUMN_VALUE, 3) OVER (ORDER BY 1)
                                       x2,
                                   LEAD (t.COLUMN_VALUE, 4) OVER (ORDER BY 1)
                                       y2,
                                   LEAD (t.COLUMN_VALUE, 5) OVER (ORDER BY 1)
                                       m2
                              FROM TABLE (geom.sdo_ordinates) t)
                     WHERE MOD (rn, 3) = 1 AND m2 IS NOT NULL) q1
             WHERE     measure BETWEEN LEAST (m1, m2) AND GREATEST (m1, m2)
                   AND ROWNUM = 1;
        END IF;

        RETURN retval;
    END;

    FUNCTION locate_pt (geom IN SDO_GEOMETRY, measure IN NUMBER)
        RETURN SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        --select sdo_geometry( 2001, NULL, sdo_point_type(x1 + start_measure * (x2 - x1) / (m2 - m1) ,
        --                              y1 + start_measure * (y2 - y1) / (m2 - m1), start_measure), null, null )
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            SELECT CASE
                       WHEN measure > m1 AND measure < m2
                       THEN
                           sdo_geometry (
                               3301,
                               geom.sdo_srid,
                               NULL,
                               sdo_elem_info_array (1, 1, 1),
                               sdo_ordinate_array (
                                     x1
                                   + (measure - m1) * (x2 - x1) / (m2 - m1),
                                     y1
                                   + (measure - m1) * (y2 - y1) / (m2 - m1),
                                   measure))
                       WHEN measure = m1
                       THEN
                           sdo_geometry (3301,
                                         geom.sdo_srid,
                                         NULL,
                                         sdo_elem_info_array (1, 1, 1),
                                         sdo_ordinate_array (x1, y1, m1))
                       WHEN measure = m2
                       THEN
                           sdo_geometry (3301,
                                         geom.sdo_srid,
                                         NULL,
                                         sdo_elem_info_array (1, 1, 1),
                                         sdo_ordinate_array (x2, y2, m2))
                       ELSE
                           NULL
                   END
              INTO retval
              FROM (SELECT ROW_NUMBER () OVER (ORDER BY rn)     rn,
                           x1,
                           y1,
                           m1,
                           x2,
                           y2,
                           m2
                      FROM (SELECT ROW_NUMBER () OVER (ORDER BY 1)
                                       rn,
                                   t.COLUMN_VALUE
                                       x1,
                                   LEAD (t.COLUMN_VALUE, 1) OVER (ORDER BY 1)
                                       y1,
                                   LEAD (t.COLUMN_VALUE, 2) OVER (ORDER BY 1)
                                       m1,
                                   LEAD (t.COLUMN_VALUE, 3) OVER (ORDER BY 1)
                                       x2,
                                   LEAD (t.COLUMN_VALUE, 4) OVER (ORDER BY 1)
                                       y2,
                                   LEAD (t.COLUMN_VALUE, 5) OVER (ORDER BY 1)
                                       m2
                              FROM TABLE (geom.sdo_ordinates) t)
                     WHERE MOD (rn, 3) = 1 AND m2 IS NOT NULL) q1
             WHERE     measure BETWEEN LEAST (m1, m2) AND GREATEST (m1, m2)
                   AND ROWNUM = 1;
        END IF;

        RETURN retval;
    END;

    FUNCTION get_lr (geom            IN SDO_GEOMETRY,
                     geom_length     IN NUMBER,
                     start_percent   IN NUMBER,
                     end_percent     IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
    BEGIN
        RETURN NULL;
    END;

    FUNCTION scale_vertices (geom            IN SDO_GEOMETRY,
                             geom_length     IN NUMBER DEFAULT NULL, -- defaults to geometric length
                             start_measure   IN NUMBER DEFAULT 0,
                             reuse_scale     IN VARCHAR2 DEFAULT 'Y')
        RETURN nm_vertex_tab
    IS
        retval   nm_vertex_tab;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            WITH
                mdata
                AS
                    (SELECT q2.*,
                            --                          :sm
                            SUM (m1 - m2)
                                OVER (
                                    ORDER BY id1
                                    ROWS BETWEEN UNBOUNDED PRECEDING
                                         AND     0 FOLLOWING)
                                interval_length,
                            LAST_VALUE (m1)
                                OVER (
                                    ORDER BY id1
                                    ROWS BETWEEN UNBOUNDED PRECEDING
                                         AND     UNBOUNDED FOLLOWING)
                                measured_length,
                            SUM (pyth_length)
                                OVER (
                                    ORDER BY id1
                                    ROWS BETWEEN UNBOUNDED PRECEDING
                                         AND     0 FOLLOWING)
                                cum_length,
                            SUM (pyth_length)
                                OVER (
                                    ORDER BY id1
                                    ROWS BETWEEN UNBOUNDED PRECEDING
                                         AND     UNBOUNDED FOLLOWING)
                                total_length
                       FROM (SELECT q1.*,
                                    SQRT (
                                          (x1 - x2) * (x1 - x2)
                                        + (y1 - y2) * (y1 - y2)) --                              / 5280
                                                                    pyth_length
                               FROM (SELECT t.id
                                                id1,
                                            t.x
                                                x1,
                                            t.y
                                                y1,
                                            t.z
                                                m1,
                                            LAG (t.id, 1) OVER (ORDER BY id)
                                                id2,
                                            LAG (t.x, 1) OVER (ORDER BY id)
                                                x2,
                                            LAG (t.y, 1) OVER (ORDER BY id)
                                                y2,
                                            LAG (t.z, 1) OVER (ORDER BY id)
                                                m2
                                       FROM TABLE (
                                                SDO_UTIL.getvertices (geom))
                                            t) q1       --where x2 is not null
                                                 ) q2)
            SELECT CAST (
                       COLLECT (
                           nm_vertex (
                               id1,
                               x1,
                               y1,
                               NULL,
                                 NVL (
                                       NVL (
                                           geom_length,
                                           NVL (measured_length,
                                                total_length))
                                     * CASE reuse_scale
                                           WHEN 'Y'
                                           THEN
                                               NVL (interval_length,
                                                    cum_length)
                                           ELSE
                                               cum_length
                                       END
                                     / case reuse_scale when 'Y' then NVL (measured_length, total_length) else total_length end,
                                     0)
                               + NVL (start_measure, 0))) AS nm_vertex_tab)
              INTO retval
              FROM mdata;
        END IF;

        RETURN retval;
    END;

    FUNCTION scale_geom_l (geom            IN SDO_GEOMETRY,
                           geom_length     IN NUMBER DEFAULT NULL,
                           start_measure   IN NUMBER DEFAULT 0)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            retval :=
                get_geom (scale_vertices (geom,
                                          geom_length,
                                          start_measure,
                                          'Y'),
                          geom.sdo_srid);
        END IF;

        RETURN retval;
    END;

    FUNCTION scale_geom (geom            IN SDO_GEOMETRY,
                         start_measure   IN NUMBER DEFAULT 0,
                         end_measure     IN NUMBER DEFAULT NULL)
        RETURN SDO_GEOMETRY
    IS
        retval     SDO_GEOMETRY;
        l_length   NUMBER := end_measure - start_measure;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            retval :=
                get_geom (scale_vertices (geom,
                                          l_length,
                                          start_measure,
                                          'Y'),
                          geom.sdo_srid);
        END IF;

        RETURN retval;
    END;

    FUNCTION scale_geom (geom            IN SDO_GEOMETRY,
                         geom_length     IN NUMBER,
                         start_x         IN NUMBER,
                         start_y         IN NUMBER,
                         start_m            NUMBER,
                         start_measure   IN NUMBER DEFAULT 0)
        RETURN SDO_GEOMETRY
    IS
    BEGIN
        RETURN NULL;
    END;

    FUNCTION redefine_geom_l (geom            IN SDO_GEOMETRY,
                              geom_length     IN NUMBER DEFAULT NULL,
                              start_measure   IN NUMBER DEFAULT 0)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            retval :=
                get_geom (scale_vertices (geom,
                                          geom_length,
                                          start_measure,
                                          'N'),
                          geom.sdo_srid);
        END IF;

        RETURN retval;
    END;


    FUNCTION redefine_geom (geom            IN SDO_GEOMETRY,
                            start_measure   IN NUMBER DEFAULT 0,
                            end_measure     IN NUMBER DEFAULT NULL)
        RETURN SDO_GEOMETRY
    IS
        retval     SDO_GEOMETRY;
        l_length   NUMBER := end_measure - start_measure;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            retval :=
                get_geom (scale_vertices (geom,
                                          l_length,
                                          start_measure,
                                          'N'),
                          geom.sdo_srid);
        END IF;

        RETURN retval;
    END;



    FUNCTION get_geom (vertices   IN nm_vertex_tab,
                       srid       IN INTEGER DEFAULT NULL)
        RETURN SDO_GEOMETRY
    IS
        --only for point and line geometry

        retval   SDO_GEOMETRY;
        l_ords   sdo_ordinate_array;
        v_c      INTEGER;                                      -- vertex count
        v_t_c    INTEGER;                                 -- vertex type count
    BEGIN
          SELECT CAST (
                     COLLECT (ord_value ORDER BY id, ord_type)
                         AS sdo_ordinate_array),
                 COUNT (DISTINCT ord_type),
                 COUNT (*)
            INTO l_ords, v_t_c, v_c
            FROM (WITH
                      vertex_list
                      AS
                          (SELECT t.*
                             FROM TABLE (vertices) t)
                  SELECT id, 1 ord_type, x ord_value
                    FROM vertex_list
                   WHERE x IS NOT NULL
                  UNION ALL
                  SELECT id, 2 ord_type, y ord_value
                    FROM vertex_list
                   WHERE y IS NOT NULL
                  UNION ALL
                  SELECT id, 3 ord_type, z ord_value
                    FROM vertex_list
                   WHERE z IS NOT NULL
                  UNION ALL
                  SELECT id, 4 ord_type, m ord_value
                    FROM vertex_list
                   WHERE m IS NOT NULL)
        ORDER BY id, ord_type;

        retval :=
            sdo_geometry (
                CASE v_t_c
                    WHEN 3 THEN CASE WHEN v_c = 3 THEN 3301 ELSE 3302 END
                    WHEN 2 THEN CASE WHEN v_c = 2 THEN 2001 ELSE 2002 END
                END,
                srid,
                NULL,
                CASE
                    WHEN l_ords.COUNT < 4 THEN sdo_elem_info_array (1, 1, 1)
                    ELSE sdo_elem_info_array (1, 2, 1)
                END,
                l_ords);
        RETURN retval;
    END;


    FUNCTION reverse_geometry (geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            SELECT sdo_geometry (
                       3302,
                       geom.sdo_srid,
                       NULL,
                       sdo_elem_info_array (1, 2, 1),
                       CAST (COLLECT (VALUE          /*ORDER BY rn, ordinate*/
                                           ) AS sdo_ordinate_array))
              INTO retval
              FROM (  SELECT *
                        FROM (SELECT reversed_id     id,
                                     x               A,
                                     y               B,
                                     m               C
                                FROM (SELECT q1.*,
                                             CASE
                                                 WHEN id = 1 THEN last_id
                                                 ELSE last_id - id + 1
                                             END    reversed_id
                                        FROM (SELECT t.id,
                                                     t.x,
                                                     t.y,
                                                     t.z                                m,
                                                     LAST_VALUE (id)
                                                         OVER (
                                                             ORDER BY id
                                                             ROWS BETWEEN UNBOUNDED
                                                                          PRECEDING
                                                                  AND     UNBOUNDED
                                                                          FOLLOWING)    last_id
                                                FROM TABLE (
                                                         SDO_UTIL.getvertices (
                                                             geom)) t) q1))
                             UNPIVOT EXCLUDE NULLS (VALUE
                                                   FOR ordinate
                                                   IN (A, B, C))
                    ORDER BY id, ordinate);
        END IF;

        RETURN retval;
    END;

    FUNCTION reverse_measure (geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            SELECT sdo_geometry (
                       3302,
                       geom.sdo_srid,
                       NULL,
                       sdo_elem_info_array (1, 2, 1),
                       CAST (COLLECT (VALUE          /*ORDER BY rn, ordinate*/
                                           ) AS sdo_ordinate_array))
              INTO retval
              FROM (  SELECT *
                        FROM (SELECT id,
                                     x              A,
                                     y              B,
                                     reversed_m     C
                                FROM (SELECT q1.*,
                                             CASE
                                                 WHEN id = 1 THEN end_m
                                                 ELSE end_m - m
                                             END    reversed_m
                                        FROM (SELECT t.id,
                                                     t.x,
                                                     t.y,
                                                     t.z
                                                         m,
                                                     --               lag (t.z, 1) OVER (ORDER BY id )
                                                     --                   prior_m,
                                                     FIRST_VALUE (z)
                                                         OVER (
                                                             ORDER BY id
                                                             ROWS BETWEEN UNBOUNDED
                                                                          PRECEDING
                                                                  AND     UNBOUNDED
                                                                          FOLLOWING)
                                                         start_m,
                                                     LAST_VALUE (z)
                                                         OVER (
                                                             ORDER BY id
                                                             ROWS BETWEEN UNBOUNDED
                                                                          PRECEDING
                                                                  AND     UNBOUNDED
                                                                          FOLLOWING)
                                                         end_m
                                                FROM TABLE (
                                                         SDO_UTIL.getvertices (
                                                             geom)) t) q1))
                             UNPIVOT EXCLUDE NULLS (VALUE
                                                   FOR ordinate
                                                   IN (A, B, C))
                    ORDER BY id, ordinate);
        END IF;

        RETURN retval;
    END;

    FUNCTION reverse_geom_and_measure (geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            SELECT sdo_geometry (
                       3302,
                       geom.sdo_srid,
                       NULL,
                       sdo_elem_info_array (1, 2, 1),
                       CAST (COLLECT (VALUE          /*ORDER BY rn, ordinate*/
                                           ) AS sdo_ordinate_array))
              INTO retval
              FROM (  SELECT *
                        FROM (SELECT reversed_id     id,
                                     x               A,
                                     y               B,
                                     reversed_m      C
                                FROM (SELECT q1.*,
                                             CASE
                                                 WHEN id = 1 THEN end_m
                                                 ELSE end_m - m
                                             END    reversed_m,
                                             CASE
                                                 WHEN id = 1 THEN last_id
                                                 ELSE last_id - id + 1
                                             END    reversed_id
                                        FROM (SELECT t.id,
                                                     t.x,
                                                     t.y,
                                                     t.z
                                                         m,
                                                     --               lag (t.z, 1) OVER (ORDER BY id )
                                                     --                   prior_m,
                                                     LAST_VALUE (id)
                                                         OVER (
                                                             ORDER BY id
                                                             ROWS BETWEEN UNBOUNDED
                                                                          PRECEDING
                                                                  AND     UNBOUNDED
                                                                          FOLLOWING)
                                                         last_id,
                                                     FIRST_VALUE (z)
                                                         OVER (
                                                             ORDER BY id
                                                             ROWS BETWEEN UNBOUNDED
                                                                          PRECEDING
                                                                  AND     UNBOUNDED
                                                                          FOLLOWING)
                                                         start_m,
                                                     LAST_VALUE (z)
                                                         OVER (
                                                             ORDER BY id
                                                             ROWS BETWEEN UNBOUNDED
                                                                          PRECEDING
                                                                  AND     UNBOUNDED
                                                                          FOLLOWING)
                                                         end_m
                                                FROM TABLE (
                                                         SDO_UTIL.getvertices (
                                                             geom)) t) q1))
                             UNPIVOT EXCLUDE NULLS (VALUE
                                                   FOR ordinate
                                                   IN (A, B, C))
                    ORDER BY id, ordinate);
        END IF;

        RETURN retval;
    END;


    FUNCTION geom_segment_start_pt (geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            SELECT get_geom (
                       CAST (COLLECT (nm_vertex (t.id,
                                                 t.x,
                                                 t.y,
                                                 NULL,
                                                 t.z)) AS nm_vertex_tab),
                       geom.sdo_srid)
              INTO retval
              FROM TABLE (SDO_UTIL.getvertices (geom)) t
             WHERE id = 1;
        END IF;

        RETURN retval;
    END;


    FUNCTION geom_segment_end_pt (geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            SELECT get_geom (CAST (COLLECT (v) AS nm_vertex_tab),
                             geom.sdo_srid)
              INTO retval
              FROM (SELECT *
                      FROM (SELECT MAX (id) OVER (PARTITION BY 1)    max_id,
                                   id,
                                   nm_vertex (t.id,
                                              t.x,
                                              t.y,
                                              NULL,
                                              t.z)                   v
                              FROM TABLE (SDO_UTIL.getvertices (geom)) t)
                     WHERE id = max_id);
        END IF;

        RETURN retval;
    END;

    FUNCTION geom_segment_start_measure (geom IN SDO_GEOMETRY)
        RETURN NUMBER
    IS
    BEGIN
        IF geom IS NULL
        THEN
            RETURN NULL;
        ELSE
            IF geom.sdo_point.x IS NOT NULL
            THEN
                RETURN geom.sdo_point.z;
            ELSIF geom.sdo_gtype IN (3302,
                                     3306,
                                     3002,
                                     3001,
                                     3301)
            THEN
                RETURN ROUND (geom.sdo_ordinates (3), g_round);
            ELSE
                raise_application_error (-20002, 'Invalid Geometry Type');
            END IF;
        END IF;
    END;


    FUNCTION geom_segment_end_measure (geom IN SDO_GEOMETRY)
        RETURN NUMBER
    IS
    BEGIN
        IF geom IS NULL
        THEN
            RETURN NULL;
        ELSE
            IF geom.sdo_point.x IS NOT NULL
            THEN
                RETURN geom.sdo_point.z;
            ELSIF geom.sdo_gtype IN (3302,
                                     3306,
                                     3002,
                                     3001,
                                     3301)
            THEN
                RETURN ROUND (geom.sdo_ordinates (geom.sdo_ordinates.LAST),
                              g_round);
            ELSE
                raise_application_error (-20002, 'Invalid Geometry Type');
            END IF;
        END IF;
    END;

    FUNCTION convert_to_std_dim_array (dim_array sdo_dim_array)
        RETURN sdo_dim_array
    IS
        retval   sdo_dim_array;
    BEGIN
        SELECT CAST (
                   COLLECT (sdo_dim_element (sdo_dimname,
                                             sdo_lb,
                                             sdo_ub,
                                             sdo_tolerance)) AS sdo_dim_array)
          INTO retval
          FROM TABLE (dim_array) t
         WHERE ROWNUM < 3;

        --
        RETURN retval;
    END;


    FUNCTION convert_to_lrs_dim_array (dim_array        sdo_dim_array,
                                       lower_bound   IN NUMBER DEFAULT NULL,
                                       upper_bound   IN NUMBER DEFAULT NULL,
                                       tolerance     IN NUMBER DEFAULT NULL)
        RETURN sdo_dim_array
    IS
        retval   sdo_dim_array;
    BEGIN
        SELECT CAST (COLLECT (dim_element) AS sdo_dim_array)
          INTO retval
          FROM (SELECT sdo_dim_element (sdo_dimname,
                                        sdo_lb,
                                        sdo_ub,
                                        sdo_tolerance)    dim_element
                  FROM TABLE (dim_array) t
                 WHERE ROWNUM < 3
                UNION ALL
                SELECT sdo_dim_element ('M',
                                        lower_bound,
                                        upper_bound,
                                        tolerance)
                  FROM DUAL);

        --
        RETURN retval;
    END;

    --
    FUNCTION convert_to_std_geom (geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            IF geom.sdo_gtype IN (3302,
                                  3301,
                                  3002,
                                  3001,
                                  3306,
                                  3303)
            THEN
                  /* needs a case statement to cater for source gtypes of:
                  3301 - pt 2D +M
                  4401 - pt 3D +M
                  3302 - line 2D +M
                  4402 - line 3D +M
                  all others to be returned as an invalid geometry type
                  */
                  --if geom.sdo_gtype in (3302, 3301) then
                  SELECT sdo_geometry (
                             CASE geom.sdo_gtype
                                 WHEN 3302 THEN 2002
                                 WHEN 3301 THEN 2001
                                 WHEN 3002 THEN 2002
                                 WHEN 3001 THEN 2001
                                 WHEN 3306 THEN 2002
                                 WHEN 3303 THEN 2003
                             END,
                             geom.sdo_srid,
                             NULL,
                             convert_to_std_elem_info (geom.sdo_elem_info),
                             CAST (COLLECT (VALUE) AS sdo_ordinate_array))
                    -- sdo_geometry( geom.sdo_gtype,  geom.sdo_srid, NULL, sdo_elem_info_array(1,2,1), cast( collect (value) as sdo_ordinate_array))
                    --  when 3301 then
                    ---- sdo_geometry( case geom.sdo_gtype when 3302 then 2002 when 3301 then 2001 end, geom.sdo_srid, NULL, sdo_elem_info_array(1,2,1), cast( collect (value) as sdo_ordinate_array))
                    -- sdo_geometry( geom.sdo_gtype,  geom.sdo_srid, NULL, sdo_elem_info_array(1,2,1), cast( collect (value) as sdo_ordinate_array))
                    --else NULL
                    --end
                    INTO retval
                    FROM (  SELECT *
                              FROM (SELECT ROW_NUMBER () OVER (ORDER BY 1)    rn,
                                           t.COLUMN_VALUE                     X,
                                           LEAD (t.COLUMN_VALUE, 1)
                                               OVER (ORDER BY 1)              Y,
                                           LEAD (t.COLUMN_VALUE, 2)
                                               OVER (ORDER BY 1)              Z
                                      FROM TABLE (geom.sdo_ordinates) t)
                             WHERE MOD (rn, 3) = 1
                          ORDER BY rn)
                         UNPIVOT EXCLUDE NULLS (VALUE FOR ordinate IN (X, Y))
                ORDER BY rn, ordinate;
            ELSE
                raise_application_error (-20002, 'Invalid geometry type');
            END IF;
        END IF;

        RETURN retval;
    END;

    FUNCTION convert_to_lrs_geom (geom          IN SDO_GEOMETRY,
                                  geom_length   IN NUMBER DEFAULT NULL)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            IF geom.sdo_gtype = 2002 OR geom.sdo_gtype = 2001
            THEN
                retval := nm_sdo.scale_geom_l (geom, geom_length);
            ELSE
                raise_application_error (-20003, 'Invalid Geometry');
            END IF;
        END IF;

        RETURN retval;
    END;

    --
    FUNCTION get_vertices (geom IN SDO_GEOMETRY)
        RETURN nm_vertex_tab
    IS
        retval   nm_vertex_tab;
        min_rn   INTEGER := 0;
    BEGIN
        BEGIN
            WITH
                ords
                AS
                    (SELECT ROWNUM                          rn,
                            nm_sdo_geom.get_dims (geom)     dims,
                            COLUMN_VALUE                    ordinate
                       FROM TABLE (geom.sdo_ordinates))
              SELECT min_rn,
                     CAST (COLLECT (nm_vertex (id,
                                               x,
                                               y,
                                               z,
                                               m)
                                    ORDER BY id) AS nm_vertex_tab)
                INTO min_rn, retval
                FROM (  SELECT MIN (rn) OVER (PARTITION BY 1)       min_rn,
                               ROW_NUMBER () OVER (ORDER BY rn)     id,
                               t.x,
                               t.y,
                               NULL                                 z,
                               t.z                                  m
                          FROM (SELECT dims,
                                       rn,
                                       ordinate
                                           x,
                                       LEAD (ordinate, 1) OVER (ORDER BY rn)
                                           y,
                                       CASE dims
                                           WHEN 3
                                           THEN
                                               LEAD (ordinate, 2)
                                                   OVER (ORDER BY rn)
                                           ELSE
                                               NULL
                                       END
                                           z
                                  FROM ords) t
                         WHERE MOD (rn, dims) = 1
                      ORDER BY id)
            GROUP BY min_rn;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                IF     (min_rn IS NULL OR min_rn = 0)
                   AND geom.sdo_point.x IS NOT NULL
                THEN
                    retval :=
                        nm_vertex_tab (nm_vertex (1,
                                                  geom.sdo_point.x,
                                                  geom.sdo_point.y,
                                                  NULL,
                                                  geom.sdo_point.z));
                END IF;
        --
        END;

        RETURN retval;
    END;

    FUNCTION get_projection (pt          IN SDO_GEOMETRY,
                             geom        IN SDO_GEOMETRY,
                             tolerance   IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
        retval    SDO_GEOMETRY;
        lg        SDO_GEOMETRY;
        dist      NUMBER;
        pt_2d     SDO_GEOMETRY := pt;
        geom_2d   SDO_GEOMETRY := geom;
        measure   ptr_num_array;
    BEGIN
        IF geom IS NULL
        THEN
            retval := NULL;
        ELSE
            IF nm_sdo_geom.get_dims (geom) = 3
            THEN
                geom_2d := nm_sdo.convert_to_std_geom (geom);
            --        ELSE
            --            raise_application_error (
            --                -20001,
            --                'The linear geometry is expected to be of an LRS type');
            END IF;

            --
            IF nm_sdo_geom.get_dims (pt) = 3
            THEN
                pt_2d := nm_sdo.convert_to_std_geom (pt);
            END IF;

            SDO_GEOM.SDO_CLOSEST_POINTS (geom_2d,
                                         pt_2d,
                                         tolerance,
                                         'unit=METER',
                                         dist,
                                         retval,
                                         lg);
            --distance := dist;
            measure := --ptr_num_array( ptr_num_array_type( ptr_num(1,20))); --
                       get_measure_array (geom, retval, tolerance);

            retval :=
                nm_sdo_geom.set_pt_measure (retval, measure.pa (1).ptr_value);
        END IF;

        --
        RETURN retval;
    END;

    FUNCTION project_pt (geom_segment   IN     SDO_GEOMETRY,
                         point          IN     SDO_GEOMETRY,
                         tolerance      IN     NUMBER,
                         offset            OUT NUMBER)
        RETURN SDO_GEOMETRY
    IS
        retval    SDO_GEOMETRY;
        lg        SDO_GEOMETRY;
        pt_2d     SDO_GEOMETRY := point;
        geom_2d   SDO_GEOMETRY := geom_segment;
        measure   ptr_num_array;
    BEGIN
        IF geom_segment IS NULL
        THEN
            retval := NULL;
        ELSE
            IF nm_sdo_geom.get_dims (geom_segment) = 3
            THEN
                geom_2d := nm_sdo.convert_to_std_geom (geom_segment);
            --        ELSE
            --            raise_application_error (
            --                -20001,
            --                'The linear geometry is expected to be of an LRS type');
            END IF;

            --
            IF nm_sdo_geom.get_dims (point) = 3
            THEN
                pt_2d := nm_sdo.convert_to_std_geom (point);
            END IF;

            SDO_GEOM.SDO_CLOSEST_POINTS (geom_2d,
                                         pt_2d,
                                         tolerance,
                                         'unit=METER',
                                         offset,
                                         retval,
                                         lg);
            --distance := dist;
            measure := --ptr_num_array( ptr_num_array_type( ptr_num(1,20))); --
                       get_measure_array (geom_segment, retval, tolerance);

            retval :=
                nm_sdo_geom.set_pt_measure (retval, measure.pa (1).ptr_value);
        --
        END IF;

        RETURN retval;
    END;

    FUNCTION project_pt (geom_segment   IN SDO_GEOMETRY,
                         point          IN SDO_GEOMETRY,
                         tolerance      IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
        dummy    NUMBER;
    BEGIN
        IF geom_segment IS NULL
        THEN
            retval := NULL;
        ELSE
            retval :=
                project_pt (geom_segment,
                            point,
                            tolerance,
                            dummy);
        END IF;

        RETURN retval;
    END;


    FUNCTION find_measure (p_lrs_geom   IN SDO_GEOMETRY,
                           p_pt_geom    IN SDO_GEOMETRY)
        RETURN NUMBER
    IS
        geoma       SDO_GEOMETRY;
        geomb       SDO_GEOMETRY;
        p_proj      SDO_GEOMETRY;
        proj_dist   NUMBER;
        retval      NUMBER;
    BEGIN
        geoma := nm_sdo.get_projection (p_pt_geom, p_lrs_geom, 0.005);
        --
        retval := nm_sdo.geom_segment_start_measure (geoma);
        RETURN ROUND (retval, g_round);
    END;

    FUNCTION add_m (p_geom IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY := p_geom;
    BEGIN
        IF p_geom IS NULL
        THEN
            retval := NULL;
        ELSE
            IF p_geom.sdo_gtype = 2001
            THEN
                IF p_geom.sdo_point IS NULL
                THEN
                    retval.sdo_ordinates.EXTEND;
                    retval.sdo_ordinates (3) := 0;
                ELSE
                    retval.sdo_point.z := 0;
                END IF;

                retval.sdo_gtype := 3301;
            END IF;
        END IF;

        RETURN retval;
    END;

    PROCEDURE split (geom            IN     SDO_GEOMETRY,
                     split_measure   IN     NUMBER,
                     tolerance       IN     NUMBER,
                     geom1              OUT SDO_GEOMETRY,
                     geom2              OUT SDO_GEOMETRY)
    IS
        l_old_end   NUMBER := nm_sdo.geom_segment_end_measure (geom);
        l_new_end   NUMBER := l_old_end - split_measure;
    BEGIN
        IF geom IS NULL
        THEN
            geom1 := NULL;
            geom2 := NULL;
        ELSE
            geom1 :=
                nm_sdo.clip (geom            => geom,
                             start_measure   => 0,
                             end_measure     => split_measure,
                             tolerance       => tolerance);
            geom2 :=
                NM_SDO.SCALE_GEOM (nm_sdo.clip (
                                       geom            => geom,
                                       start_measure   => split_measure,
                                       end_measure     =>
                                           nm_sdo.geom_segment_end_measure (
                                               geom),
                                       tolerance       => tolerance));
        END IF;
    END;

    FUNCTION get_terminations (geom IN SDO_GEOMETRY)
        RETURN nm_geom_terminations
    AS
        retval   nm_geom_terminations;
    BEGIN
        SELECT nm_geom_terminations (XS,
                                     YS,
                                     MS,
                                     XE,
                                     YE,
                                     ME,
                                     rowc)
          INTO retval
          FROM (SELECT FIRST_VALUE (x) OVER (ORDER BY rn)           XS,
                       FIRST_VALUE (y) OVER (ORDER BY rn)           YS,
                       FIRST_VALUE (z) OVER (ORDER BY rn)           MS,
                       LAST_VALUE (x)
                           OVER (
                               ORDER BY rn
                               ROWS BETWEEN UNBOUNDED PRECEDING
                                    AND     UNBOUNDED FOLLOWING)    XE,
                       LAST_VALUE (y)
                           OVER (
                               ORDER BY rn
                               ROWS BETWEEN UNBOUNDED PRECEDING
                                    AND     UNBOUNDED FOLLOWING)    YE,
                       LAST_VALUE (z)
                           OVER (
                               ORDER BY rn
                               ROWS BETWEEN UNBOUNDED PRECEDING
                                    AND     UNBOUNDED FOLLOWING)    ME,
                       COUNT (*)
                           OVER (
                               ORDER BY rn
                               ROWS BETWEEN UNBOUNDED PRECEDING
                                    AND     UNBOUNDED FOLLOWING)    rowc
                  FROM (SELECT ROW_NUMBER () OVER (ORDER BY 1)
                                   rn,
                               t.COLUMN_VALUE
                                   X,
                               LEAD (t.COLUMN_VALUE, 1) OVER (ORDER BY 1)
                                   y,
                               LEAD (t.COLUMN_VALUE, 2) OVER (ORDER BY 1)
                                   z
                          FROM TABLE (geom.sdo_ordinates) t) q1
                 WHERE MOD (rn, 3) = 1)
         WHERE ROWNUM = 1;

        RETURN retval;
    END;

    --
    FUNCTION concat_geom (geom1       IN SDO_GEOMETRY,
                          geom2       IN SDO_GEOMETRY,
                          connected   IN VARCHAR2 DEFAULT 'TRUE')
        RETURN SDO_GEOMETRY
    IS
        retval        SDO_GEOMETRY;
        geom1_terms   nm_geom_terminations := get_terminations (geom1);
        l_elem_info   sdo_elem_info_array;
    --
    BEGIN
        IF connected = 'TRUE'
        THEN
              SELECT sdo_geometry (
                         3302,
                         geom1.sdo_srid,
                         NULL,
                         geom1.sdo_elem_info,
                         CAST (COLLECT (VALUE        /*ORDER BY rn, ordinate*/
                                             ) AS sdo_ordinate_array))
                INTO retval
                FROM (SELECT q1.*
                        FROM (SELECT 1
                                         seg_id,
                                     ROW_NUMBER () OVER (ORDER BY 1)
                                         rn,
                                     t.COLUMN_VALUE
                                         x,
                                     LEAD (t.COLUMN_VALUE, 1) OVER (ORDER BY 1)
                                         y,
                                     LEAD (t.COLUMN_VALUE, 2) OVER (ORDER BY 1)
                                         z
                                FROM TABLE (geom1.sdo_ordinates) t) q1
                       WHERE MOD (rn, 3) = 1
                      UNION
                      SELECT q1.*
                        FROM (SELECT 2
                                         seg_id,
                                     ROW_NUMBER () OVER (ORDER BY 1)
                                         rn,
                                     t.COLUMN_VALUE
                                         x,
                                     LEAD (t.COLUMN_VALUE, 1) OVER (ORDER BY 1)
                                         y,
                                       nm_sdo.geom_segment_end_measure (geom1)
                                     + LEAD (t.COLUMN_VALUE, 2)
                                           OVER (ORDER BY 1)
                                         z
                                FROM TABLE (geom2.sdo_ordinates) t) q1
                       WHERE MOD (rn, 3) = 1 AND rn > 1)
                     UNPIVOT EXCLUDE NULLS (VALUE FOR ordinate IN (X, Y, Z))
            ORDER BY seg_id, rn, ordinate;
        ELSE
            l_elem_info :=
                append_elem_info (geom1.sdo_elem_info, geom1_terms.rowc);

              SELECT sdo_geometry (
                         3306,
                         geom1.sdo_srid,
                         NULL,
                         l_elem_info,
                         CAST (COLLECT (VALUE        /*ORDER BY rn, ordinate*/
                                             ) AS sdo_ordinate_array))
                INTO retval
                FROM (SELECT q1.*
                        FROM (SELECT 1
                                         seg_id,
                                     ROW_NUMBER () OVER (ORDER BY 1)
                                         rn,
                                     t.COLUMN_VALUE
                                         x,
                                     LEAD (t.COLUMN_VALUE, 1) OVER (ORDER BY 1)
                                         y,
                                     LEAD (t.COLUMN_VALUE, 2) OVER (ORDER BY 1)
                                         z
                                FROM TABLE (geom1.sdo_ordinates) t) q1
                       WHERE MOD (rn, 3) = 1
                      UNION ALL
                      SELECT q1.*
                        FROM (SELECT 2
                                         seg_id,
                                     ROW_NUMBER () OVER (ORDER BY 1)
                                         rn,
                                     t.COLUMN_VALUE
                                         x,
                                     LEAD (t.COLUMN_VALUE, 1) OVER (ORDER BY 1)
                                         y,
                                       nm_sdo.geom_segment_end_measure (geom1)
                                     + LEAD (t.COLUMN_VALUE, 2)
                                           OVER (ORDER BY 1)
                                         z
                                FROM TABLE (geom2.sdo_ordinates) t) q1
                       WHERE MOD (rn, 3) = 1)
                     UNPIVOT EXCLUDE NULLS (VALUE FOR ordinate IN (X, Y, Z))
            ORDER BY seg_id, rn, ordinate;
        END IF;

        RETURN retval;
    END;

    FUNCTION append_elem_info (elem_info      IN sdo_elem_info_array,
                               vertex_count   IN INTEGER)
        RETURN sdo_elem_info_array
    IS
        retval   sdo_elem_info_array := elem_info;
    BEGIN
        retval.EXTEND;
        retval (retval.LAST) := retval (retval.LAST - 3) + (vertex_count * 3);
        retval.EXTEND;
        retval (retval.LAST) := 2;
        retval.EXTEND;
        retval (retval.LAST) := 1;
        RETURN retval;
    END;

    FUNCTION convert_to_std_elem_info (elem_info IN sdo_elem_info_array)
        RETURN sdo_elem_info_array
    IS
        retval   sdo_elem_info_array;
    BEGIN
        SELECT CAST (
                   COLLECT (element_value ORDER BY element_id)
                       AS sdo_elem_info_array)
          INTO retval
          FROM (SELECT element_id,
                       CASE ptr_flag
                           WHEN 0 THEN 1 + (element_value - 1) * 2 / 3
                           ELSE element_value
                       END    element_value
                  FROM (SELECT t1.id                        element_id,
                               t1.COLUMN_VALUE              element_value,
                               TRUNC ((id - 1) / 3) + 1     v_id,
                               MOD (id - 1, 3)              ptr_flag
                          FROM (SELECT ROWNUM id, t.*
                                  FROM TABLE (elem_info) t) t1) t2);

        RETURN retval;
    END;


    FUNCTION is_connected (geom1       IN SDO_GEOMETRY,
                           geom2       IN SDO_GEOMETRY,
                           tolerance   IN NUMBER)
        RETURN INTEGER
    IS
        retval      INTEGER;
        --return 11  for geom1/geom2 connected at S/E respectively
        --       12  for geom1/geom2 connected at S/S respectively
        --       22  for geom1/geom2 connected at E/S respectively
        --       21  for geom1/geom2 connected at E/E respectively
        --       -1   for geom1/geom2 disjoint
        --  Note 11,12,21,22 all handle cases where the geometry loops back on itself after the merge
        --  Also note that the direction of the geometry is preserved from the first geometry
        --
        term1       nm_geom_terminations := nm_sdo.get_terminations (geom1);
        term2       nm_geom_terminations := nm_sdo.get_terminations (geom2);
        dist_btwn   NUMBER;
    --
    BEGIN
        dist_btwn :=
            dist (term1.xe,
                  term1.ye,
                  term2.xs,
                  term2.ys);

        IF dist_btwn < tolerance
        THEN
            retval := 11;
        ELSE
            dist_btwn :=
                dist (term1.xe,
                      term1.ye,
                      term2.xe,
                      term2.ye);

            IF dist_btwn < tolerance
            THEN
                retval := 12;
            ELSE
                dist_btwn :=
                    dist (term1.xs,
                          term1.ys,
                          term2.xs,
                          term2.ys);

                IF dist_btwn < tolerance
                THEN
                    retval := 21;
                ELSE
                    dist_btwn :=
                        dist (term1.xs,
                              term1.ys,
                              term2.xe,
                              term2.ye);

                    IF dist_btwn < tolerance
                    THEN
                        retval := 22;
                    ELSE
                        retval := -1;
                    END IF;
                END IF;
            END IF;
        END IF;

        RETURN retval;
    END;

    FUNCTION merge (geom1       IN SDO_GEOMETRY,
                    geom2       IN SDO_GEOMETRY,
                    tolerance   IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;
        cnct     INTEGER := is_connected (geom1, geom2, tolerance);
    BEGIN
        IF cnct = 11
        THEN
            RETURN concat_geom (geom1, geom2, 'TRUE');
        ELSIF cnct = 12
        THEN
            RETURN concat_geom (geom1,
                                reverse_geom_and_measure (geom2),
                                'TRUE');
        ELSIF cnct = 21
        THEN
            RETURN concat_geom (reverse_geom_and_measure (geom2),
                                geom1,
                                'TRUE');
        ELSIF cnct = 22
        THEN
            RETURN concat_geom (geom2, geom1, 'TRUE');
        ELSE
            RETURN concat_geom (geom1, geom2, 'FALSE');
        END IF;
    END;

    PROCEDURE debug_terms (geom IN SDO_GEOMETRY)
    IS
        terms   nm_geom_terminations;
    BEGIN
        terms := get_terminations (geom);
        nm_debug.debug (
               'XS= '
            || terms.xs
            || ', '
            || 'YS= '
            || terms.ys
            || ', '
            || 'XE= '
            || terms.xe
            || ', '
            || 'YE= '
            || terms.ye
            || ', '
            || 'cnt='
            || terms.rowc);
    END;

    FUNCTION dist (x1   IN NUMBER,
                   y1   IN NUMBER,
                   x2   IN NUMBER,
                   y2   IN NUMBER)
        RETURN NUMBER
    IS
        retval   NUMBER := SQRT (POWER ((x2 - x1), 2) + POWER ((y2 - y1), 2));
    BEGIN
        RETURN ROUND (retval, g_round);
    END;

    FUNCTION get_measure_array (lr_geom     IN SDO_GEOMETRY,
                                pts         IN SDO_GEOMETRY,
                                tolerance   IN NUMBER DEFAULT 1.0e-8)
        RETURN ptr_num_array
    IS
        retval   ptr_num_array := NM3ARRAY.INIT_PTR_NUM_ARRAY;
    BEGIN
        SELECT CAST (
                   COLLECT (
                       ptr_num (
                           pt_id,
                             m1
                           +   (m2 - m1)
                             * SQRT (
                                     POWER ((pt_x - x1), 2)
                                   + POWER ((pt_y - y1), 2))
                             / SQRT (
                                     POWER ((x2 - x1), 2)
                                   + POWER ((y2 - y1), 2))))
                       AS ptr_num_array_type)
          INTO retval.pa
          FROM (SELECT q1.pt_id,
                       q1.id,
                       q1.x1,
                       q1.y1,
                       q1.m1,
                       q1.x2,
                       q1.y2,
                       q1.m2,
                       t1.x     pt_x,
                       t1.y     pt_y,
                       t1.z     pt_m
                  FROM (  SELECT *
                            FROM (SELECT tp.id                       pt_id,
                                         tp.geom                     pt_geom,
                                         t.id,
                                         t.x                         x1,
                                         t.y                         y1,
                                         t.z                         m1,
                                         LEAD (t.x, 1)
                                             OVER (PARTITION BY tp.id
                                                   ORDER BY t.id)    x2,
                                         LEAD (t.y, 1)
                                             OVER (PARTITION BY tp.id
                                                   ORDER BY t.id)    y2,
                                         LEAD (t.z, 1)
                                             OVER (PARTITION BY tp.id
                                                   ORDER BY t.id)    m2
                                    FROM TABLE (SDO_UTIL.getvertices (lr_geom))
                                         t,
                                         TABLE (
                                             nm_sdo_geom.extract_id_geom (pts))
                                         tp)
                           WHERE m2 IS NOT NULL
                        ORDER BY pt_id, id) q1,
                       TABLE (nm_sdo.get_vertices (pt_geom))  t1
                 WHERE     t1.x BETWEEN LEAST (x1, x2) - tolerance
                                    AND GREATEST (x1, x2) + tolerance
                       AND t1.y BETWEEN LEAST (y1, y2) - tolerance
                                    AND GREATEST (y1, y2) + tolerance
                       AND ROWNUM = 1);

        --
        RETURN retval;
    END;

    FUNCTION get_measure (point IN SDO_GEOMETRY, dim_array IN sdo_dim_array)
        RETURN NUMBER
    IS
    BEGIN
        RETURN get_measure (point);
    END;

    FUNCTION get_measure (point IN SDO_GEOMETRY)
        RETURN NUMBER
    IS
        l_dim   INTEGER := nm_sdo_geom.get_dims (point);
    BEGIN
        IF point.sdo_gtype NOT IN (3301, 3001)
        THEN
            raise_application_error (-20004, 'Invalid Point Geometry');
        ELSIF    point.sdo_ordinates IS NULL
              OR point.sdo_ordinates.COUNT < l_dim
        THEN
            IF point.sdo_point.z IS NOT NULL
            THEN
                RETURN point.sdo_point.z;
            ELSE
                raise_application_error (-20003, 'Invalid Geometry');
            END IF;
        END IF;

        RETURN ROUND (
                   CASE l_dim
                       WHEN 3 THEN point.sdo_ordinates (3)
                       WHEN 4 THEN point.sdo_ordinates (4)
                   END,
                   g_round);
    END;


    --    FUNCTION sdo_intersection (p_lrs_geom   IN SDO_GEOMETRY,
    --                               p_geom       IN SDO_GEOMETRY)
    --        RETURN SDO_GEOMETRY
    --    IS
    --        part_geom       SDO_GEOMETRY;
    --        pts             SDO_GEOMETRY;
    --        measure_array   ptr_num_array;
    --        ord_count       INTEGER;
    --    --    CURSOR elem_ranges (c_geom IN SDO_GEOMETRY, ord_count IN INTEGER)
    --    --    IS
    --    --        SELECT ROW_NUMBER () OVER (ORDER BY rn) id, start_id, end_id
    --    --          FROM (SELECT COLUMN_VALUE       start_id,
    --    --                       rn,
    --    --                       rc,
    --    --                       rc / 3             no_parts,
    --    --                       NVL (LEAD (COLUMN_VALUE, 3) OVER (ORDER BY rn) - 1,
    --    --                            ord_count)    end_id
    --    --                  FROM (SELECT t.*, ROWNUM rn, COUNT (*) OVER (ORDER BY 1) rc
    --    --                          FROM TABLE (c_geom.sdo_elem_info) t))
    --    --         WHERE MOD (rn, 3) = 1;
    --    BEGIN
    --        nm_debug.debug_on;
    --        nm_debug.debug ('Start');
    --        nm_debug.debug ('get intersection');
    --        part_geom := SDO_GEOM.sdo_intersection (p_lrs_geom, p_geom);
    --        nm_debug.debug ('get pts');
    --        --
    --        pts :=
    --            SDO_GEOM.sdo_intersection (p_lrs_geom,
    --                                       SDO_UTIL.polygontoline (p_geom));
    --        --
    --        nm_debug.debug ('get measures');
    --
    --        measure_array := get_measure (p_lrs_geom, pts);
    --
    --        ord_count := part_geom.sdo_ordinates.COUNT;
    --
    --        nm_debug.debug ('Loop over ords and set measures where missing');
    --
    --        -- should have a correlation between the numbers in the measure_array and twice the number of parts in the part_geom (i.e. a measure at each termination
    --        --
    --        FOR irec
    --            IN        --elem_ranges (part_geom, part_geom.sdo_ordinates.COUNT)
    --               (SELECT ROW_NUMBER () OVER (ORDER BY rn) id, start_id, end_id
    --                  FROM (SELECT COLUMN_VALUE      start_id,
    --                               rn,
    --                               rc,
    --                               rc / 3            no_parts,
    --                               NVL (
    --                                     LEAD (COLUMN_VALUE, 3)
    --                                         OVER (ORDER BY rn)
    --                                   - 1,
    --                                   ord_count)    end_id
    --                          FROM (SELECT t.*,
    --                                       ROWNUM                          rn,
    --                                       COUNT (*) OVER (ORDER BY 1)     rc
    --                                  FROM TABLE (part_geom.sdo_elem_info) t))
    --                 WHERE MOD (rn, 3) = 1)
    --        LOOP
    --            part_geom.sdo_ordinates (irec.start_id + 2) :=
    --                measure_array.pa (2 * irec.id - 1).ptr_value;
    --            part_geom.sdo_ordinates (irec.end_id) :=
    --                measure_array.pa (2 * irec.id).ptr_value;
    --        END LOOP;
    --
    --        nm_debug.debug ('End of loop and return');
    --
    --        --
    --        RETURN part_geom;
    --    END;
    --
    FUNCTION lrs_intersection (p_lrs_geom   IN SDO_GEOMETRY,
                               p_geom       IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
    BEGIN
        RETURN set_measure_on_intsct (
                   p_lrs_geom,
                   SDO_GEOM.sdo_intersection (p_lrs_geom, p_geom, 0.005));
    END;


    FUNCTION set_measure_on_intsct (p_lrs_geom   IN SDO_GEOMETRY,
                                    p_parts      IN SDO_GEOMETRY)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY;

        CURSOR get_m_values (c_elem_info IN sdo_elem_info_array)
        IS
            WITH
                vertices
                AS
                    (SELECT v_part_id,
                            (v_id - 1) * 3 + ord_offset + 2     v_id,
                            vx,
                            vy,
                            vrc
                       FROM (SELECT v1.*,
                                    (SELECT ord_offset
                                       FROM (SELECT ROWNUM            rn,
                                                    t.COLUMN_VALUE    ord_offset
                                               FROM TABLE (c_elem_info) t)
                                      WHERE rn = (v_part_id - 1) * 3 + 1)    ord_offset
                               FROM (SELECT part_id                            v_part_id,
                                            id                                 v_id,
                                            v.x                                vx,
                                            v.y                                vy,
                                            COUNT (*) OVER (PARTITION BY 1)    vrc
                                       FROM (SELECT part_id,
                                                    part_geom,
                                                    p_parts
                                               FROM (SELECT t.id
                                                                part_id,
                                                            t.geom
                                                                part_geom,
                                                            p_parts
                                                       FROM TABLE (
                                                                NM_SDO_GEOM.EXTRACT_ID_GEOM (
                                                                    p_parts))
                                                            t)),
                                            TABLE (
                                                SDO_UTIL.getvertices (
                                                    part_geom)) v
                                      WHERE (v.z = 0 OR v.z IS NULL)) v1)),
                element_vertices
                AS
                    (SELECT id                                  e_id,
                            v.x                                 ex,
                            v.y                                 ey,
                            v.z                                 ez,
                            COUNT (*) OVER (PARTITION BY 1)     erc
                       FROM TABLE (SDO_UTIL.getvertices (p_lrs_geom)) v),
                element_ranges
                AS
                    (SELECT e_id,
                            ex                                    ex1,
                            ey                                    ey1,
                            ez                                    ez1,
                            LEAD (ex, 1) OVER (ORDER BY e_id)     ex2,
                            LEAD (ey, 1) OVER (ORDER BY e_id)     ey2,
                            LEAD (ez, 1) OVER (ORDER BY e_id)     ez2
                       FROM element_vertices),
                measure_values
                AS
                    (SELECT e.*,
                            v.*,
                              ez1
                            +   (ez2 - ez1)
                              * SQRT (
                                      POWER ((vx - ex1), 2)
                                    + POWER ((vy - ey1), 2))
                              / SQRT (
                                      POWER ((ex2 - ex1), 2)
                                    + POWER ((ey2 - ey1), 2))    measure
                       FROM element_ranges e, vertices v
                      WHERE vx BETWEEN ex1 AND ex2 AND vy BETWEEN ey1 AND ey2)
            SELECT v_part_id,
                   v_id,
                   vx,
                   vy,
                   measure
              FROM measure_values;
    BEGIN
        FOR irec IN (SELECT COLUMN_VALUE FROM TABLE (p_parts.sdo_elem_info))
        LOOP
            nm_debug.debug ('column_value = ' || irec.COLUMN_VALUE);
        END LOOP;

        --
        retval := p_parts;

        FOR irec IN get_m_values (p_parts.sdo_elem_info)
        LOOP
            nm_debug.debug (
                   'part-id ='
                || irec.v_part_id
                || ', id = '
                || irec.v_id
                || ', measure = '
                || irec.measure);

            IF irec.v_id IS NOT NULL
            THEN
                retval.sdo_ordinates (irec.v_id) := irec.measure;
            END IF;
        END LOOP;

        IF retval.sdo_gtype = 3002
        THEN
            retval.sdo_gtype := 3302;
        END IF;

        RETURN retval;
    END;

    PROCEDURE reset_measure (p_geom IN OUT NOCOPY SDO_GEOMETRY)
    IS
    BEGIN
        SELECT sdo_geometry (3302,
                             p_geom.sdo_srid,
                             NULL,
                             sdo_elem_info_array (1, 2, 1),
                             CAST (COLLECT (VALUE    /*ORDER BY rn, ordinate*/
                                                 ) AS sdo_ordinate_array))
          INTO p_geom
          FROM (  SELECT *
                    FROM (SELECT id     id,
                                 x      A,
                                 y      B,
                                 m      C
                            FROM (SELECT q1.*
                                    FROM (SELECT t.id,
                                                 t.x,
                                                 t.y,
                                                 NULL     m
                                            FROM TABLE (
                                                     SDO_UTIL.getvertices (
                                                         p_geom)) t) q1))
                         UNPIVOT INCLUDE NULLS (VALUE
                                               FOR ordinate
                                               IN (A, B, C))
                ORDER BY id, ordinate);
    END;

    PROCEDURE translate_measure (p_geom        IN OUT NOCOPY SDO_GEOMETRY,
                                 translate_m   IN            NUMBER)
    IS
    BEGIN
        SELECT sdo_geometry (3302,
                             p_geom.sdo_srid,
                             NULL,
                             sdo_elem_info_array (1, 2, 1),
                             CAST (COLLECT (VALUE    /*ORDER BY rn, ordinate*/
                                                 ) AS sdo_ordinate_array))
          INTO p_geom
          FROM (  SELECT *
                    FROM (SELECT id     id,
                                 x      A,
                                 y      B,
                                 m      C
                            FROM (SELECT q1.*
                                    FROM (SELECT t.id,
                                                 t.x,
                                                 t.y,
                                                 t.z + translate_m     m
                                            FROM TABLE (
                                                     SDO_UTIL.getvertices (
                                                         p_geom)) t) q1))
                         UNPIVOT INCLUDE NULLS (VALUE
                                               FOR ordinate
                                               IN (A, B, C))
                ORDER BY id, ordinate);
    END;

    FUNCTION connected_geom_segments (geom_segment_1   IN SDO_GEOMETRY,
                                      geom_segment_2   IN SDO_GEOMETRY,
                                      tolerance        IN NUMBER)
        RETURN VARCHAR2
    IS
        retval      VARCHAR2 (10);
        connected   INTEGER;
    BEGIN
        connected := is_connected (geom_segment_1, geom_segment_2, tolerance);

        IF connected IS NULL OR connected = -1
        THEN
            retval := 'FALSE';
        ELSE
            retval := 'TRUE';
        END IF;

        RETURN retval;
    END;

    FUNCTION geom_segment_length (geom_segment   IN SDO_GEOMETRY,
                                  dim_array      IN SDO_DIM_ARRAY)
        RETURN NUMBER
    IS
    BEGIN
        RETURN ROUND (
                   ABS (
                         geom_segment_end_measure (geom_segment)
                       - geom_segment_start_measure (geom_segment)),
                   g_round);
    END;

    FUNCTION geom_segment_length (geom_segment   IN SDO_GEOMETRY,
                                  tolerance      IN NUMBER DEFAULT 1.0e-8)
        RETURN NUMBER
    IS
    BEGIN
        RETURN ROUND (
                   ABS (
                         geom_segment_end_measure (geom_segment)
                       - geom_segment_start_measure (geom_segment)),
                   g_round);
    END;

    FUNCTION offset_geom_segment (geom            IN SDO_GEOMETRY,
                                  start_measure   IN NUMBER,
                                  end_measure     IN NUMBER,
                                  offset          IN NUMBER,
                                  tolerance       IN NUMBER DEFAULT 1.0e-8)
        RETURN SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
        retval        SDO_GEOMETRY;
        check_count   INTEGER;
        sm            NUMBER := SDO_LRS.geom_segment_start_measure (geom);
        em            NUMBER := SDO_LRS.geom_segment_end_measure (geom);
        l_tolerance   NUMBER; -- tolerance adjusted from XY unots to M units or meters
    BEGIN
        l_tolerance := tolerance;

        IF geom.sdo_srid IS NOT NULL
        THEN
            IF nm_sdo_geom.is_geodetic (geom.sdo_srid) = 'TRUE'
            THEN
                NULL;
            ELSE
                l_tolerance :=
                      tolerance
                    * SDO_LRS.geom_segment_end_measure (geom)
                    / SDO_GEOM.sdo_length (geom);
            END IF;
        END IF;

        IF start_measure = sm AND end_measure = em
        THEN
            retval := offset_whole_geom (geom, offset, tolerance);
        ELSIF start_measure > em OR end_measure < sm
        THEN
            retval := NULL;
        ELSE
              SELECT sdo_geometry (
                         3302,
                         geom.sdo_srid,
                         NULL,
                         sdo_elem_info_array (1, 2, 1),
                         CAST (COLLECT (VALUE        /*ORDER BY rn, ordinate*/
                                             ) AS sdo_ordinate_array)),
                     COUNT (*)
                         check_count
                INTO retval, check_count
                FROM (WITH
                          ranges
                          AS
                              (SELECT start_measure,
                                      end_measure,
                                      MIN (rn) OVER (PARTITION BY 'A')
                                          min_rn,
                                      MAX (rn) OVER (PARTITION BY 'A')
                                          max_rn,
                                      l_tolerance,
                                        offset
                                      * (y1 - y2)
                                      / SQRT (
                                              POWER ((x2 - x1), 2)
                                            + POWER ((y2 - y1), 2))
                                          x_offset,
                                        offset
                                      * (x2 - x1)
                                      / SQRT (
                                              POWER ((x2 - x1), 2)
                                            + POWER ((y2 - y1), 2))
                                          y_offset,
                                      q1.*
                                 FROM (SELECT ROW_NUMBER () OVER (ORDER BY 1)
                                                  rn,
                                              COUNT (*) OVER (PARTITION BY 'A')
                                                  rc,
                                              t.COLUMN_VALUE
                                                  x1,
                                              LEAD (t.COLUMN_VALUE, 1)
                                                  OVER (ORDER BY 1)
                                                  y1,
                                              LEAD (t.COLUMN_VALUE, 2)
                                                  OVER (ORDER BY 1)
                                                  m1,
                                              LEAD (t.COLUMN_VALUE, 3)
                                                  OVER (ORDER BY 1)
                                                  x2,
                                              LEAD (t.COLUMN_VALUE, 4)
                                                  OVER (ORDER BY 1)
                                                  y2,
                                              LEAD (t.COLUMN_VALUE, 5)
                                                  OVER (ORDER BY 1)
                                                  m2
                                         FROM TABLE (geom.sdo_ordinates) t) q1
                                WHERE     MOD (rn, 3) = 1 --and m2 is not null
                                      AND m1 <= end_measure + l_tolerance
                                      AND m2 >= start_measure - l_tolerance)
                      --                                            select r.* from ranges r
                      --
                      SELECT rn, -- this will retrieve all vertices which are wholly between the two measures
                             x1 + x_offset     A,
                             y1 + y_offset     B,
                             m1                C
                        FROM ranges
                       WHERE     m1 >= start_measure - l_tolerance
                             AND m1 <= end_measure + l_tolerance
                      UNION ALL
                      SELECT -1
                                 rn, -- this is where the start measure is between two vertices - interpolate the xy's
                               x1
                             +   (GREATEST (m1, start_measure) - m1)
                               * (x2 - x1)
                               / (m2 - m1)
                             + x_offset,
                               y1
                             +   (GREATEST (m1, start_measure) - m1)
                               * (y2 - y1)
                               / (m2 - m1)
                             + y_offset,
                             GREATEST (m1, start_measure)
                        FROM ranges
                       WHERE     rn = min_rn
                             AND m1 < start_measure
                             AND m2 > start_measure
                             AND ABS (m1 - start_measure) > l_tolerance
                             AND ABS (m2 - start_measure) > l_tolerance
                      --                       and (abs(m1-greatest(start_measure, m1)) > tolerance )
                      UNION ALL
                      SELECT 99999
                                 rn, -- This is to ensure that the end vertex is included, possibly interpolated - may be better performance if the
                               x1
                             +   (LEAST (m2, end_measure) - m1)
                               * (x2 - x1)
                               / (m2 - m1)
                             + x_offset,
                               y1
                             +   (LEAST (m2, end_measure) - m1)
                               * (y2 - y1)
                               / (m2 - m1)
                             + y_offset,
                             LEAST (m2, end_measure)
                        FROM ranges
                       WHERE     m1 < end_measure
                             AND m2 >= end_measure - l_tolerance
                             AND rn = max_rn
                      ORDER BY rn)
                     UNPIVOT EXCLUDE NULLS (VALUE FOR ordinate IN (A, B, C))
            ORDER BY rn, ordinate;

            IF check_count < 6
            THEN
                IF check_count = 3
                THEN
                    retval.sdo_gtype := 3301;
                    retval.sdo_elem_info := sdo_elem_info_array (1, 1, 1);
                ELSE
                    DBMS_OUTPUT.put_line ('Check count = ' || check_count);
                    raise_application_error (-20001, 'Invalid LRS Measure');
                END IF;
            END IF;
        END IF;

        RETURN retval;
    END;

    FUNCTION offset_whole_geom (geom        IN SDO_GEOMETRY,
                                offset      IN NUMBER,
                                tolerance      NUMBER)
        RETURN SDO_GEOMETRY
        DETERMINISTIC
    IS
        retval   SDO_GEOMETRY;
    BEGIN
        WITH
            ranges
            AS
                (SELECT t.x                                  x1,
                        t.y                                  y1,
                        t.z                                  m1,
                        LEAD (t.x, 1) OVER (ORDER BY id)     x2,
                        LEAD (t.y, 1) OVER (ORDER BY id)     y2,
                        LEAD (t.z, 1) OVER (ORDER BY id)     m2
                   FROM TABLE (SDO_UTIL.getvertices (geom)) t),
            offsets
            AS
                (SELECT rn,
                        x1 + x_offset     x1,
                        y1 + y_offset     y1,
                        m1,
                        x2 + x_offset     x2,
                        y2 + y_offset     y2,
                        m2
                   FROM (SELECT ROWNUM                           rn,
                                x1,
                                y1,
                                m1,
                                x2,
                                y2,
                                m2,
                                  offset
                                * (y1 - y2)
                                / SQRT (
                                        POWER ((x2 - x1), 2)
                                      + POWER ((y2 - y1), 2))    x_offset,
                                  offset
                                * (x2 - x1)
                                / SQRT (
                                        POWER ((x2 - x1), 2)
                                      + POWER ((y2 - y1), 2))    y_offset
                           FROM ranges
                          WHERE x2 IS NOT NULL))
        SELECT sdo_geometry (CASE MAX (rn) WHEN 1 THEN 3302 ELSE 3306 END,
                             geom.sdo_srid,
                             NULL,
                             get_pline_parts_elem_info (MAX (rn)),
                             CAST (COLLECT (VALUE) AS sdo_ordinate_array))
          INTO retval
          FROM (SELECT rn, 1, x1 X, y1 Y, m1 M FROM offsets
                UNION ALL
                SELECT rn, 2, x2 X, y2 Y, m2 M FROM offsets
                ORDER BY 1, 2)
               UNPIVOT EXCLUDE NULLS (VALUE FOR ordinate IN (X, Y, M));

        RETURN retval;
    END;

    FUNCTION get_pline_parts_elem_info (rc IN INTEGER)
        RETURN sdo_elem_info_array
    IS
        retval   sdo_elem_info_array;
    BEGIN
        WITH
            rn
            AS
                (    SELECT LEVEL     rn
                       FROM DUAL
                 CONNECT BY LEVEL <= rc)
        SELECT CAST (COLLECT (VALUE) AS sdo_elem_info_array)
          INTO retval
          FROM (SELECT (rn - 1) * 6 + 1     sdo_starting_offset,
                       2                    sdo_etype,
                       1                    sdo_interpretation
                  FROM rn)
               UNPIVOT EXCLUDE NULLS (VALUE
                                     FOR elem_info
                                     IN (sdo_starting_offset,
                                        sdo_etype,
                                        sdo_interpretation));

        RETURN retval;
    END;
END;
/