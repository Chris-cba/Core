CREATE OR REPLACE PACKAGE BODY nm_srid
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm_srid.pkb-arc   1.0   Jan 22 2019 15:46:54   Rob.Coupe  $
    --       Module Name      : $Workfile:   nm_srid.pkb  $
    --       Date into PVCS   : $Date:   Jan 22 2019 15:46:54  $
    --       Date fetched Out : $Modtime:   Jan 22 2019 15:20:42  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling SDO SRIDs such as conversions etc.     --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is to handle conversions of units relating to the SDO_SRID

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

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
            raise_application_error (-20002, 'Unknown SRID');
    END;

    FUNCTION get_unit (srid IN NUMBER)
        RETURN NUMBER
    IS
        retval    INTEGER;
        uom_id1   NUMBER;
        uom_id2   NUMBER;
        uom_id3   NUMBER;
    BEGIN
        SDO_CS.determine_srid_units (srid,
                                     uom_id1,
                                     uom_id2,
                                     uom_id3);

        --dbms_output.put_line( uom_id1||', '||uom_id2||', '||uom_id3);
        SELECT un_unit_id
          INTO retval
          FROM v_nm_sdo_units
         WHERE uom_id = uom_id1;

        RETURN retval;
    END;

    FUNCTION get_xy_to_m_conversion (srid         IN     NUMBER,
                                     themes       IN     nm_theme_array_type,
                                     po_nw_unit      OUT INTEGER)
        RETURN NUMBER
    IS
        retval   NUMBER;
        l_unit   INTEGER := get_unit (srid);
    BEGIN
        SELECT uc_conversion_factor, uc_unit_id_out
          INTO retval, po_nw_unit
          FROM nm_unit_conversions,
               (SELECT nlt_units     out_unit
                  FROM nm_linear_types, nm_nw_themes, TABLE (themes)
                 WHERE     nlt_id = nnth_nlt_id
                       AND nnth_nth_theme_id = nthe_id
                       AND ROWNUM = 1)
         WHERE uc_unit_id_in = l_unit AND uc_unit_id_out = out_unit;

        RETURN retval;
    END;

    FUNCTION get_xy_to_m_conversion (srid     IN NUMBER,
                                     themes   IN nm_theme_array_type)
        RETURN NUMBER
    IS
        retval      NUMBER;
        l_nw_unit   INTEGER;
    BEGIN
        retval :=
            get_xy_to_m_conversion (srid         => srid,
                                    themes       => themes,
                                    po_nw_unit   => l_nw_unit);
        RETURN retval;
    END;

    FUNCTION get_m_to_xy_conversion (srid         IN     NUMBER,
                                     themes       IN     nm_theme_array_type,
                                     po_nw_unit      OUT INTEGER)
        RETURN NUMBER
    IS
        retval   NUMBER;
        l_unit   INTEGER := get_unit (srid);
    BEGIN
        SELECT uc_conversion_factor, in_unit
          INTO retval, po_nw_unit
          FROM nm_unit_conversions,
               (SELECT nlt_units     in_unit
                  FROM nm_linear_types, nm_nw_themes, TABLE (themes)
                 WHERE     nlt_id = nnth_nlt_id
                       AND nnth_nth_theme_id = nthe_id
                       AND ROWNUM = 1)
         WHERE uc_unit_id_out = l_unit AND uc_unit_id_in = in_unit;

        RETURN retval;
    END;

    FUNCTION get_m_to_xy_conversion (srid     IN NUMBER,
                                     themes   IN nm_theme_array_type)
        RETURN NUMBER
    IS
        retval      NUMBER;
        l_nw_unit   INTEGER;
    BEGIN
        retval :=
            get_m_to_xy_conversion (srid         => srid,
                                    themes       => themes,
                                    po_nw_unit   => l_nw_unit);
        RETURN retval;
    END;
END;
/