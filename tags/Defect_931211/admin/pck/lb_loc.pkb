CREATE OR REPLACE PACKAGE BODY lb_loc
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_loc.pkb-arc   1.15   Aug 15 2018 09:37:28   Rob.Coupe  $
    --       Module Name      : $Workfile:   lb_loc.pkb  $
    --       Date into PVCS   : $Date:   Aug 15 2018 09:37:28  $
    --       Date fetched Out : $Modtime:   Aug 15 2018 09:35:38  $
    --       PVCS Version     : $Revision:   1.15  $
    --
    --   Author : R.A. Coupe
    --
    --   Location Bridge package for handling locations
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.15  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'lb_loc';

    --
    -----------------------------------------------------------------------------
    --

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

    --
    -----------------------------------------------------------------------------
    --

    FUNCTION get_nal (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        OPEN retval FOR
            SELECT nal_id,
                   nal_asset_id,
                   nal_nit_type,
                   nal_descr,
                   nal_jxp,
                   nal_primary
              FROM nm_asset_locations
             WHERE     nal_asset_id = pi_asset_id
                   AND nal_nit_type = pi_nal_nit_type;

        RETURN retval;
    END;

    --
    FUNCTION get_location (pi_nal_id nm_asset_locations_all.nal_id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        OPEN retval FOR
            SELECT nm_ne_id_of,
                   ne_unique,
                   nm_begin_mp,
                   nm_end_mp,
                   un_unit_name
              FROM nm_locations,
                   nm_elements,
                   nm_types,
                   nm_units
             WHERE     ne_id = nm_ne_id_of
                   AND ne_nt_type = nt_type
                   AND un_unit_id = nt_length_unit
                   AND nm_ne_id_in = pi_nal_id;

        RETURN retval;
    END;

    --

    FUNCTION get_asset_location (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        OPEN retval FOR
            SELECT nm_ne_id_of,
                   ne_unique,
                   nm_begin_mp,
                   nm_end_mp,
                   un_unit_name
              FROM nm_locations,
                   nm_asset_locations,
                   nm_elements,
                   nm_types,
                   nm_units
             WHERE     ne_id = nm_ne_id_of
                   AND nal_id = nm_ne_id_in
                   AND nal_asset_id = pi_asset_id
                   AND nal_nit_type = pi_nal_nit_type
                   AND ne_nt_type = nt_type
                   AND un_unit_id = nt_length_unit;

        RETURN retval;
    END;

    --
    FUNCTION get_nal_geom (pi_nal_id nm_asset_locations_all.nal_id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        OPEN retval FOR
              SELECT SDO_AGGR_CONCAT_lines (nlg_geometry)     geoloc
                FROM nm_location_geometry, nm_locations
               WHERE nm_loc_id = nlg_loc_id AND nm_ne_id_in = pi_nal_id
            GROUP BY nm_ne_id_in, nm_obj_type;

        RETURN retval;
    END;

    --
    FUNCTION get_asset_geom (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        OPEN retval FOR
              SELECT SDO_AGGR_CONCAT_lines (nlg_geometry)     geoloc
                FROM nm_location_geometry, nm_locations, nm_asset_locations
               WHERE     nm_loc_id = nlg_loc_id
                     AND nal_id = nm_ne_id_in
                     AND nal_asset_id = pi_asset_id
                     AND nal_nit_type = pi_nal_nit_type
            GROUP BY nm_ne_id_in, nm_obj_type;

        RETURN retval;
    END;

    FUNCTION get_nal_geom_mbr (pi_nal_id nm_asset_locations_all.nal_id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        OPEN retval FOR
            SELECT sdo_aggr_mbr (nlg_geometry)
              FROM nm_location_geometry, nm_locations
             WHERE nm_ne_id_in = pi_nal_id AND nm_loc_id = nlg_loc_id;

        RETURN retval;
    END;

    FUNCTION get_asset_geom_mbr (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        OPEN retval FOR
            SELECT sdo_aggr_mbr (nlg_geometry)
              FROM nm_asset_locations, nm_location_geometry, nm_locations
             WHERE     nm_ne_id_in = nal_id
                   AND nal_asset_id = pi_asset_id
                   AND nal_nit_type = pi_nal_nit_type
                   AND nm_obj_type = pi_nal_nit_type
                   AND nm_loc_id = nlg_loc_id;

        RETURN retval;
    END;

    --
    FUNCTION get_location_tab (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_refnt_type     IN INTEGER)
        RETURN lb_RPt_tab
    IS
        retval   lb_RPt_tab;
    BEGIN
          SELECT lb_RPt (nm_ne_id_of,
                         nlt_id,
                         pi_nal_nit_type,
                         nal_id,
                         nm_seg_no,
                         nm_seq_no,
                         nm_dir_flag,
                         nm_begin_mp,
                         nm_end_mp,
                         nlt_units)
            BULK COLLECT INTO retval
            FROM nm_locations,
                 nm_asset_locations,
                 nm_elements,
                 nm_linear_types
           WHERE     ne_id = nm_ne_id_of
                 AND nal_id = nm_ne_id_in
                 AND nal_asset_id = pi_asset_id
                 AND nal_nit_type = pi_nal_nit_type
                 AND ne_nt_type = nlt_nt_type
        ORDER BY nm_seq_no;

        --
        --
        RETURN retval;
    END;

    --
    FUNCTION get_location_tab (
        pi_nal_id       IN nm_asset_locations_all.nal_id%TYPE,
        pi_refnt_type   IN INTEGER)
        RETURN lb_RPt_tab
    IS
        retval   lb_RPt_tab;
    BEGIN
          SELECT lb_RPt (nm_ne_id_of,
                         nlt_id,
                         nal_nit_type,
                         nal_id,
                         nm_seg_no,
                         nm_seq_no,
                         nm_dir_flag,
                         nm_begin_mp,
                         nm_end_mp,
                         nlt_units)
            BULK COLLECT INTO retval
            FROM nm_locations,
                 nm_asset_locations,
                 nm_elements,
                 nm_linear_types
           WHERE     ne_id = nm_ne_id_of
                 AND nal_id = nm_ne_id_in
                 AND nal_id = pi_nal_id
                 AND ne_nt_type = nlt_nt_type
                 AND nlt_id = NVL (pi_refnt_type, nlt_id)
        ORDER BY nm_seq_no;

        --
        --
        RETURN retval;
    END;

    FUNCTION translate_nlt (pi_lb_rpt_tab        IN lb_RPt_tab,
                            pi_refnt_type        IN INTEGER,
                            pi_inner_join_flag   IN VARCHAR2 DEFAULT 'Y',
                            pi_cardinality       IN INTEGER)
        RETURN lb_RPt_tab
    IS
        --
        retval         lb_RPt_tab;
        l_refnt_type   nm_linear_types%ROWTYPE;
    BEGIN
        SELECT lb_rpt (refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m,
                       end_m,
                       m_unit)
          BULK COLLECT INTO retval
          FROM (WITH
                    nlt
                    AS
                        (SELECT *
                           FROM nm_linear_types
                          WHERE nlt_id = pi_refnt_type),
                    location_tab AS (SELECT * FROM TABLE (pi_lb_rpt_tab))
                SELECT refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m,
                       end_m,
                       m_unit
                  FROM location_tab, nlt
                 WHERE refnt_type = nlt_id
                UNION ALL
                SELECT refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m,
                       end_m,
                       m_unit
                  FROM (SELECT CAST (COLLECT (lb_rpt (refnt,
                                                      refnt_type,
                                                      obj_type,
                                                      obj_id,
                                                      seg_id,
                                                      seq_id,
                                                      dir_flag,
                                                      start_m,
                                                      end_m,
                                                      m_unit)) AS lb_rpt_tab)
                                   lb_tab
                          FROM location_tab),
                       nlt,
                       TABLE (
                           lb_get.get_lb_rpt_r_tab (lb_tab,
                                                    nlt_gty_type,
                                                    100)) t
                UNION ALL
                SELECT refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m,
                       end_m,
                       m_unit
                  FROM location_tab, nlt
                 WHERE     pi_inner_join_flag = 'N'
                       AND nlt_gty_type IS NOT NULL
                       AND NOT EXISTS
                               (SELECT 1
                                  FROM nm_members
                                 WHERE     nm_obj_type = nlt_gty_type
                                       AND nm_type = 'G'
                                       AND nm_ne_id_of = refnt)
                ORDER BY 5, 6);

        RETURN retval;
    END;


    --
    FUNCTION get_pref_location_tab (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_refnt_type     IN INTEGER)
        RETURN lb_RPt_tab
    IS
        --
        l_nlt_id   INTEGER;
    BEGIN
        BEGIN
            SELECT nlt_id
              INTO l_nlt_id
              FROM nm_inv_nw, nm_linear_types
             WHERE     nin_nit_inv_code = pi_nal_nit_type
                   AND nin_nw_type = nlt_nt_type
                   AND nlt_id = NVL (pi_refnt_type, nlt_id)
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                l_nlt_id := NULL;
            WHEN TOO_MANY_ROWS
            THEN
                l_nlt_id := pi_refnt_type;
        END;

        IF l_nlt_id = NVL (pi_refnt_type, l_nlt_id)
        THEN
            RETURN get_location_tab (pi_asset_id,
                                     pi_nal_nit_type,
                                     pi_refnt_type);
        ELSE
            RETURN translate_nlt (
                       get_location_tab (pi_asset_id,
                                         pi_nal_nit_type,
                                         pi_refnt_type),
                       pi_refnt_type,
                       'Y',
                       100);
        END IF;
    END;

    --
    FUNCTION get_pref_location_tab (
        pi_nal_id       IN nm_asset_locations_all.nal_id%TYPE,
        pi_refnt_type   IN INTEGER)
        RETURN lb_RPt_tab
    IS
        --
        l_nlt_id   INTEGER;
    BEGIN
        BEGIN
            SELECT nlt_id
              INTO l_nlt_id
              FROM nm_inv_nw, nm_linear_types, nm_asset_locations
             WHERE     nin_nit_inv_code = nal_nit_type
                   AND nin_nw_type = nlt_nt_type
                   AND nal_id = pi_nal_id
                   AND nlt_id = NVL (pi_refnt_type, nlt_id)
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                l_nlt_id := NULL;
            WHEN TOO_MANY_ROWS
            THEN
                l_nlt_id := pi_refnt_type;
        END;

        IF l_nlt_id = NVL (pi_refnt_type, l_nlt_id)
        THEN
            RETURN get_location_tab (pi_nal_id, pi_refnt_type);
        ELSE
            RETURN translate_nlt (get_location_tab (pi_nal_id, NULL),
                                  pi_refnt_type,
                                  'Y',
                                  100);
        END IF;
    END;

    FUNCTION get_xlocation_tab (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_refnt_type     IN INTEGER,
        pi_xsp_rvrs       IN VARCHAR2 DEFAULT 'TRUE')
        RETURN lb_XRPt_tab
    IS
        retval   lb_XRPt_tab;
    BEGIN
        IF pi_nal_id IS NULL AND pi_asset_id IS NULL
        THEN
            raise_application_error (
                -20001,
                'You must specify an asset ID or an asset location ID');
        END IF;

        SELECT lb_XRPt (
                   nm_ne_id_of,
                   nm_nlt_id,
                   nal_nit_type,
                   nal_id,
                   nm_seg_no,
                   nm_seq_no,
                   nm_dir_flag,
                   nm_begin_mp,
                   nm_end_mp,
                   nlt_units,
                   CASE pi_xsp_rvrs
                       WHEN 'TRUE'
                       THEN
                           CASE nm_dir_flag
                               WHEN 1
                               THEN
                                   nm_x_sect_st
                               WHEN -1
                               THEN
                                   (SELECT xrv_new_xsp
                                      FROM v_nlt_element_xsps
                                     WHERE     element_id = nm_ne_id_of
                                           AND nwx_x_sect = nm_x_sect_st)
                           END
                       ELSE
                           nm_x_sect_st
                   END,
                   nm_offset_st,
                   nm_start_date,
                   nm_end_date)
          BULK COLLECT INTO retval
          FROM nm_asset_locations, nm_locations_all, nm_linear_types
         WHERE     nal_asset_id = NVL (pi_asset_id, nal_asset_id)
               AND nal_id = NVL (pi_nal_id, nal_id)
               AND nal_nit_type = pi_nal_nit_type
               AND nm_ne_id_in = nal_id
               AND nlt_id = nm_nlt_id;

        RETURN retval;
    END;


    FUNCTION translate_xnlt (pi_lb_xrpt_tab       IN lb_XRPt_tab,
                             pi_refnt_type        IN INTEGER,
                             pi_inner_join_flag   IN VARCHAR2 DEFAULT 'Y',
                             pi_cardinality       IN INTEGER)
        RETURN lb_XRPt_tab
    IS
        --
        retval         lb_XRPt_tab;
        l_refnt_type   nm_linear_types%ROWTYPE;
    BEGIN
        SELECT *
          INTO l_refnt_type
          FROM nm_linear_types
         WHERE nlt_id = pi_refnt_type;

        IF l_refnt_type.nlt_gty_type IS NULL
        THEN
            raise_application_error (
                -20004,
                'Linear type does not support aggregation');
        END IF;

        SELECT lb_Xrpt (refnt,
                        refnt_type,
                        obj_type,
                        obj_id,
                        seg_id,
                        seq_id,
                        dir_flag,
                        start_m,
                        end_m,
                        m_unit,
                        xsp,
                        offset,
                        start_date,
                        end_date)
          BULK COLLECT INTO retval
          FROM (SELECT t.*
                  FROM TABLE (
                           lb_get.get_lb_xrpt_r_tab (
                               pi_lb_xrpt_tab,
                               l_refnt_type.nlt_gty_type,
                               pi_cardinality)) t
                UNION ALL
                SELECT refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m,
                       end_m,
                       m_unit,
                       xsp,
                       offset,
                       start_date,
                       end_date
                  FROM TABLE (pi_lb_xRPt_tab)
                 WHERE     pi_inner_join_flag = 'N'
                       AND NOT EXISTS
                               (SELECT 1
                                  FROM nm_members, nm_linear_types
                                 WHERE     nlt_id = pi_refnt_type
                                       AND nm_obj_type = nlt_gty_type
                                       AND nm_ne_id_of = refnt)
                ORDER BY 1, 6);

        RETURN retval;
    END;


    FUNCTION get_asset_location_tab (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_refnt_type     IN INTEGER)
        RETURN lb_XRPt_tab
    IS
        --
        l_nlt_id   INTEGER;
    BEGIN
        BEGIN
            SELECT nlt_id
              INTO l_nlt_id
              FROM nm_inv_nw, nm_linear_types
             WHERE     nin_nit_inv_code = pi_nal_nit_type
                   AND nin_nw_type = nlt_nt_type
                   AND nlt_id = NVL (pi_refnt_type, nlt_id)
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                l_nlt_id := NULL;
            WHEN TOO_MANY_ROWS
            THEN
                l_nlt_id := pi_refnt_type;
        END;

        IF l_nlt_id = NVL (pi_refnt_type, l_nlt_id)
        THEN
            RETURN get_xlocation_tab (pi_asset_id,
                                      pi_nal_id,
                                      pi_nal_nit_type,
                                      pi_refnt_type,
                                      'TRUE');
        ELSE
            RETURN translate_xnlt (get_xlocation_tab (pi_asset_id,
                                                      pi_nal_id,
                                                      pi_nal_nit_type,
                                                      pi_refnt_type,
                                                      'FALSE'),
                                   pi_refnt_type,
                                   'Y',
                                   100);
        END IF;
    END;

    FUNCTION get_pref_location (
        pi_asset_id       IN nm_asset_locations_all.nal_asset_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_refnt_type     IN INTEGER)
        RETURN SYS_REFCURSOR
    IS
        retval   SYS_REFCURSOR;
    BEGIN
        retval := NULL;
        RETURN retval;
    END;

    FUNCTION xsps_for_asset_location (p_lb_rpt_tab      IN lb_rpt_tab,
                                      p_exor_inv_type   IN VARCHAR2)
        RETURN lb_xsp_tab
    IS
        retval   lb_xsp_tab;
    BEGIN
        retval :=
            LB_REF.GET_XSP_ON_LB_RPT_TAB (p_lb_rpt_tab   => p_lb_rpt_tab,
                                          P_INV_TYPE     => p_exor_inv_type);
        --
        --      SELECT CAST (COLLECT (lb_xsp (xsp, nwx_descr)) AS lb_xsp_tab)
        --        INTO retval
        --        FROM (select distinct xsp, nwx_descr from
        --        nm_xsp,(select xsr_x_sect_value xsp
        --        from ( SELECT DISTINCT xsr_x_sect_value
        --                FROM (WITH datum_range
        --                           AS (SELECT t1.*,
        --                                      SUM (1) OVER (PARTITION BY 1)
        --                                         datum_count
        --                                 FROM (SELECT /*+materialise*/
        --                                             * FROM TABLE (p_lb_rpt_tab)) t1)
        --                        SELECT ne_id,
        --                               ne_nt_type,
        --                               ne_sub_class,
        --                               xsr_x_sect_value,
        --                               xsr_descr,
        --                               COUNT (
        --                                  1)
        --                               OVER (
        --                                  PARTITION BY xsr_x_sect_value)
        --                                  sc_count,
        --                               datum_count
        --                          FROM (SELECT d.ne_id,
        --                                       d.ne_nt_type,
        --                                       d.ne_gty_group_type,
        --                                       d.ne_sub_class,
        --                                       datum_count
        --                                  FROM nm_elements d, datum_range
        --                                 WHERE refnt = ne_id
        --                                --and ne_sub_class is not null
        --                                UNION ALL
        --                                SELECT /*+INDEX(m nm_obj_type_ne_id_of_ind) */
        --                                      nm_ne_id_of,
        --                                       g.ne_nt_type,
        --                                       g.ne_gty_group_type,
        --                                       g.ne_sub_class,
        --                                       datum_count
        --                                  FROM nm_members m, nm_elements g, datum_range
        --                                 WHERE     nm_ne_id_of = refnt
        --                                       AND nm_ne_id_in = g.ne_id
        --                                       AND nm_obj_type = g.ne_gty_group_type --and g.ne_sub_class is not null
        --                                                                            ) t,
        --                               xsp_restraints
        --                         WHERE     xsr_nw_type(+) = ne_nt_type
        --                               AND xsr_scl_class(+) = ne_sub_class
        --                               AND xsr_ity_inv_code = p_exor_inv_type
        --                      ORDER BY ne_id,
        --                               ne_nt_type,
        --                               ne_sub_class,
        --                               xsr_x_sect_value)
        --               WHERE sc_count = datum_count))where nwx_x_sect = xsp);

        RETURN retval;
    END;
END lb_loc;
/