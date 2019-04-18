CREATE OR REPLACE PACKAGE BODY nm_sdo_geom
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm_sdo_geom.pkb-arc   1.4   Apr 18 2019 21:41:06   Rob.Coupe  $
    --       Module Name      : $Workfile:   nm_sdo_geom.pkb  $
    --       Date into PVCS   : $Date:   Apr 18 2019 21:41:06  $
    --       Date fetched Out : $Modtime:   Apr 18 2019 21:40:28  $
    --       PVCS Version     : $Revision:   1.4  $
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

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.4  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'NM_SDO_GEOM';

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

    FUNCTION get_dims (geom IN SDO_GEOMETRY)
        RETURN INTEGER
    IS
    BEGIN
        RETURN geom.get_dims ();
    END;

    FUNCTION get_lr_dim (geom IN SDO_GEOMETRY)
        RETURN INTEGER
    IS
        retval   INTEGER;
    BEGIN
        retval :=
            (MOD (geom.sdo_gtype, 1000) - MOD (geom.sdo_gtype, 100)) / 100;
        RETURN retval;
    END;

    FUNCTION set_pt_measure (p_pt IN SDO_GEOMETRY, p_measure IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
        retval   SDO_GEOMETRY := p_pt;
    BEGIN
        IF retval.sdo_gtype IN (2001, 3001, 3301)
        THEN
            retval.sdo_gtype := 3301;

            IF retval.sdo_point.x IS NOT NULL
            THEN
                retval.sdo_ordinates :=
                    sdo_ordinate_array (retval.sdo_point.x,
                                        retval.sdo_point.y,
                                        p_measure);
                retval.sdo_elem_info := sdo_elem_info_array (1, 1, 1);
                retval.sdo_point := NULL;
            ELSE
                IF retval.sdo_ordinates.LAST = 2
                THEN
                    retval.sdo_ordinates.EXTEND;
                END IF;

                retval.sdo_ordinates (3) := p_measure;
            END IF;
        ELSE
            raise_application_error (
                -20001,
                'Projection can only operate from a point geometry');
        END IF;

        RETURN retval;
    END;

    FUNCTION extract_id_geom (geom IN SDO_GEOMETRY)
        RETURN geom_id_tab
    IS
        retval   geom_id_tab;
    BEGIN
        IF geom.sdo_gtype = 2005
        THEN
            SELECT CAST (
                       COLLECT (
                           geom_id (
                               ROWNUM,
                               sdo_geometry (2001,
                                             geom.sdo_srid,
                                             NULL,
                                             sdo_elem_info_array (1, 1, 1),
                                             sdo_ordinate_array (x, y))))
                           AS geom_id_tab)
              INTO retval
              FROM (SELECT t.*
                      FROM TABLE (SDO_UTIL.getvertices (geom)) t);
        ELSIF geom.sdo_gtype IN (3005,
                                 3305,
                                 3001,
                                 3301)
        THEN
            SELECT CAST (
                       COLLECT (geom_id (ROWNUM,
                                         mdsys.sdo_geometry (
                                             3301,
                                             geom.sdo_srid,
                                             NULL,
                                             sdo_elem_info_array (1, 1, 1),
                                             sdo_ordinate_array (x, y, z))))
                           AS geom_id_tab)
              INTO retval
              FROM (SELECT t.*
                      FROM TABLE (SDO_UTIL.getvertices (geom)) t);
        ELSIF geom.sdo_gtype IN (3302,
                                 3002,
                                 3306,
                                 3006,
								 2006)
        THEN
            SELECT g_id
              INTO retval
              FROM (WITH
                        elem
                        AS
                            (SELECT ROW_NUMBER () OVER (ORDER BY rn)     id,
                                    start_id,
                                    end_id
                               FROM (SELECT COLUMN_VALUE              start_id,
                                            rn,
                                            rc,
                                            rc / 3                    no_parts,
                                            LEAD (COLUMN_VALUE, 3)
                                                OVER (ORDER BY rn)    end_id
                                       FROM (SELECT t.*,
                                                    ROWNUM                   rn,
                                                    COUNT (*)
                                                        OVER (ORDER BY 1)    rc
                                               FROM TABLE (
                                                        geom.sdo_elem_info) t))
                              WHERE MOD (rn, 3) = 1)
                    SELECT CAST (
                               COLLECT (
                                   geom_id (
                                       id,
                                       sdo_geometry (
                                           3302,
                                           geom.sdo_srid,
                                           NULL,
                                           sdo_elem_info_array (1, 2, 1),
                                           nm_sdo_geom.extract_ords (
                                               geom.sdo_ordinates,
                                               start_id,
                                               end_id)))) AS geom_id_tab)    g_id
                      FROM elem);
        ELSIF geom.sdo_gtype IN (2002, 2001, 2003)
        THEN
            RETURN geom_id_tab (geom_id (1, geom));
        END IF;

        RETURN retval;
    END;

    FUNCTION extract_ords (ords          sdo_ordinate_array,
                           start_id   IN INTEGER,
                           end_id        INTEGER)
        RETURN sdo_ordinate_array
    IS
        retval   sdo_ordinate_array;
    BEGIN
        SELECT CAST (COLLECT (ord_value ORDER BY rn) AS sdo_ordinate_array)
          INTO retval
          FROM (SELECT ROWNUM                              rn,
                       COLUMN_VALUE                        ord_value,
                       COUNT (*) OVER (PARTITION BY 1)     rc
                  FROM TABLE (ords))
         WHERE rn >= start_id AND rn < NVL (end_id, rc + 1);

        RETURN retval;
    END;

    FUNCTION test_equivalence (geom1         IN SDO_GEOMETRY,
                               geom2         IN SDO_GEOMETRY,
                               tolerance        NUMBER DEFAULT 0.005,
                               measure_tol      NUMBER DEFAULT 0.005)
        RETURN VARCHAR2
    IS
        l_geom1            SDO_GEOMETRY := geom1;
        l_geom2            SDO_GEOMETRY := geom2;
        l_buffer1          SDO_GEOMETRY;
        l_buffer2          SDO_GEOMETRY;
        spatial_relation   VARCHAR2 (10);
        retval             VARCHAR2 (10) := 'FALSE';
        dummy              INTEGER;
        rnd                INTEGER;
        rnd_m              INTEGER;
        l_vertex_tab       nm_vertex_tab;
    BEGIN
        rnd := ABS (TRUNC (LOG (10, tolerance))) + 1;
        rnd := ABS (TRUNC (LOG (10, measure_tol))) + 1;

        IF    geom1.sdo_gtype != geom2.sdo_gtype
           OR geom1.sdo_srid != geom2.sdo_srid
        THEN
            retval := 'FALSE';
        ELSE
            --
            IF nm_sdo_geom.get_dims (l_geom1) = 3
            THEN
                l_geom1 := nm_sdo.convert_to_std_geom (l_geom1);
            END IF;

            l_buffer1 :=
                SDO_GEOM.sdo_buffer (l_geom1, tolerance * 2, tolerance);

            --
            IF nm_sdo_geom.get_dims (l_geom2) = 3
            THEN
                l_geom2 := nm_sdo.convert_to_std_geom (l_geom2);
            END IF;

            --
            l_buffer2 :=
                SDO_GEOM.sdo_buffer (l_geom2, tolerance * 2, tolerance);
            --
            spatial_relation :=
                SDO_GEOM.relate (l_geom1,
                                 'DETERMINE',
                                 l_buffer2,
                                 tolerance);

            IF spatial_relation = 'INSIDE'
            THEN
                spatial_relation :=
                    SDO_GEOM.relate (l_geom2,
                                     'DETERMINE',
                                     l_buffer1,
                                     tolerance);

                IF spatial_relation = 'INSIDE'
                THEN
                    retval := 'TRUE';
                END IF;
            END IF;
        END IF;

        IF nm_sdo_geom.get_dims (l_geom1) = 3
        THEN
            -- test measures
            NULL;
        END IF;

        SELECT CAST (COLLECT (nm_vertex (ROWNUM,
                                         x,
                                         y,
                                         NULL,
                                         m)) AS nm_vertex_tab)
          INTO l_vertex_tab
          FROM (WITH
                    adat
                    AS
                        (SELECT ROUND (t.x, rnd)       x,
                                ROUND (t.y, rnd)       y,
                                ROUND (t.m, rnd_m)     m
                           FROM TABLE (nm_sdo.get_vertices (geom1)) t),
                    bdat
                    AS
                        (SELECT ROUND (t.x, rnd),
                                ROUND (t.y, rnd),
                                ROUND (t.m, rnd_m)
                           FROM TABLE (nm_sdo.get_vertices (geom2)) t)
                (SELECT * FROM adat
                 MINUS
                 SELECT * FROM bdat)
                UNION ALL
                (SELECT * FROM bdat
                 MINUS
                 SELECT * FROM adat));

        IF l_vertex_tab.COUNT > 0
        THEN
            --      ideally, each geometry should be densified with the XYs that are missing from it with a derived M value AND
            --               densified with each M value and derived XY and the test re-executed.
            retval := 'FALSE';
        END IF;

        RETURN retval;
    END;

    FUNCTION get_vertices_as_pts (geom IN SDO_GEOMETRY)
        RETURN geom_id_tab
    IS
        retval   geom_id_tab;
        dims     INTEGER := nm_sdo_geom.get_dims (geom);
    BEGIN
        SELECT CAST (
                   COLLECT (
                       geom_id (
                           t.id,
                           sdo_geometry (
                               CASE dims
                                   WHEN 2 THEN 2001
                                   WHEN 3 THEN 3301
                               END,
                               geom.sdo_srid,
                               NULL,
                               sdo_elem_info_array (1, 1, 1),
                               case when dims = 3 then
                               sdo_ordinate_array (t.x, t.y, t.m)
                               else 
                               sdo_ordinate_array(t.x, t.y)
                               end)))
                       AS geom_id_tab)
          INTO retval
          FROM TABLE (nm_sdo.get_vertices (geom)) t;

        RETURN retval;
    END;

    FUNCTION is_geodetic (pi_srid IN INTEGER)
        RETURN VARCHAR2
    IS
        retval    VARCHAR2 (10);
        l_dummy   VARCHAR2 (6);
    BEGIN
        SELECT UPPER (SUBSTR (wktext, 1, 6))
          INTO l_dummy
          FROM mdsys.cs_srs
         WHERE srid = pi_srid;

        IF l_dummy = 'GEOGCS'
        THEN
            RETURN 'TRUE';
        ELSE
            RETURN 'FALSE';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            raise_application_error (-20001, 'Unknown SRID');
    END;
END;
/