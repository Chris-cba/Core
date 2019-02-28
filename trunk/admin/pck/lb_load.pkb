CREATE OR REPLACE PACKAGE BODY lb_load
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/lb_load.pkb-arc   1.38   Feb 28 2019 11:37:54   Rob.Coupe  $
    --       Module Name      : $Workfile:   lb_load.pkb  $
    --       Date into PVCS   : $Date:   Feb 28 2019 11:37:54  $
    --       Date fetched Out : $Modtime:   Feb 28 2019 11:31:50  $
    --       PVCS Version     : $Revision:   1.38  $
    --
    --   Author : R.A. Coupe
    --
    --   Location Bridge package for loading LRS placements
    --lb_load
    -----------------------------------------------------------------------------
    -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.38  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'lb_load';

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

    --
    PROCEDURE lb_load (p_obj_Rpt       IN     lb_RPt_tab,
                       p_nal_id        IN     NM_ASSET_LOCATIONS_ALL.NAL_ID%TYPE,
                       p_start_date    IN     DATE,
                       p_security_id   IN     INTEGER,
                       p_xsp           IN     VARCHAR2,
                       p_loc_error        OUT lb_loc_error_tab);

    PROCEDURE lb_load (
        p_obj_geom      IN     lb_obj_geom_tab,
        p_nal_id        IN     NM_ASSET_LOCATIONS_ALL.NAL_ID%TYPE,
        p_start_date    IN     DATE,
        p_security_id   IN     INTEGER,
        p_loc_error        OUT lb_loc_error_tab);

    --
    FUNCTION validate_admin_unit (pi_user_id   IN INTEGER,
                                  pi_rpt_tab      lb_RPt_tab --, return_code OUT integer
                                                            )
        RETURN lb_loc_error_tab;

    FUNCTION validate_xsp_on_RPt_tab (pi_xsp       IN VARCHAR2,
                                      pi_rpt_tab      lb_RPt_tab)
        RETURN lb_loc_error_tab;

    FUNCTION validate_inv_nw_constraint (p_rpt_tab IN lb_rpt_tab)
        RETURN VARCHAR2;


    FUNCTION ld_nal (
        p_nal_nit_type        IN nm_asset_locations_all.nal_nit_type%TYPE,
        p_nal_asset_id        IN nm_asset_locations_all.nal_asset_id%TYPE,
        p_nal_descr           IN nm_asset_locations_all.nal_descr%TYPE,
        p_nal_jxp             IN nm_asset_locations_all.nal_jxp%TYPE,
        p_nal_primary         IN nm_asset_locations_all.nal_primary%TYPE,
        p_nal_location_type   IN nm_asset_locations_all.nal_location_type%TYPE,
        p_nal_start_date      IN nm_asset_locations_all.nal_start_date%TYPE,
        p_nal_security        IN nm_asset_locations_all.nal_security_key%TYPE)
        RETURN INTEGER
    IS
        retval   INTEGER;
    BEGIN
        INSERT INTO nm_asset_locations_all (nal_nit_type,
                                            nal_asset_id,
                                            nal_descr,
                                            nal_jxp,
                                            nal_primary,
                                            nal_location_type,
                                            nal_security_key,
                                            nal_start_date)
             VALUES (p_nal_nit_type,
                     p_nal_asset_id,
                     p_nal_descr,
                     p_nal_jxp,
                     p_nal_primary,
                     p_nal_location_type,
                     p_nal_security,
                     p_nal_start_date)
          RETURNING nal_id
               INTO retval;

        RETURN retval;
    END;

    PROCEDURE lb_ld_Rpt (
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_Rpt            IN lb_RPt_tab,
        --    pi_g_i_d          IN varchar2,
        pi_xsp            IN VARCHAR2,
        pi_start_date     IN nm_asset_locations_all.nal_start_date%TYPE,
        pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE)
    IS
        loc_error    lb_loc_error_tab;
        l_g_i_d      VARCHAR2 (1);
        l_load_tab   lb_rpt_tab;
    BEGIN
        lb_load (lb_ops.group_lb_rpt_tab (lb_ops.merge_lb_rpt_tab (
                                              pi_nal_id,
                                              pi_nal_nit_type,
                                              pi_Rpt,
                                              100),
                                          100),
                 pi_nal_id,
                 pi_start_date,
                 pi_security_id,
                 pi_xsp,
                 loc_error);
    END;

    --
    PROCEDURE lb_ld_range (
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_refnt          IN v_nm_nlt_refnts.ne_id%TYPE,
        pi_g_i_d          IN v_nm_nlt_data.nlt_g_i_d%TYPE,
        pi_nlt_id         IN v_nm_nlt_refnts.nlt_id%TYPE,
        pi_start_m        IN NUMBER,
        pi_end_m          IN NUMBER,
        pi_unit           IN nm_units.un_unit_id%TYPE,
        pi_xsp            IN VARCHAR2,
        pi_start_date     IN nm_asset_locations_all.nal_start_date%TYPE,
        pi_range_seq_no   IN INTEGER,
        pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE)
    IS
        loc_error       lb_loc_error_tab;
        l_g_i_d         VARCHAR2 (1);
        l_load_tab      lb_rpt_tab;
        l_pnt_or_cont   VARCHAR2 (1);
        l_start         NUMBER;
        l_end           NUMBER;
        l_unit          INTEGER;
        l_reverse       INTEGER := 1;
        l_start_m       NUMBER := pi_start_m;
        l_end_m         NUMBER := pi_end_m;
        l_min_start_m   NUMBER;
        l_max_end_m     NUMBER;
    BEGIN
        --
        IF pi_g_i_d IS NULL
        THEN
            SELECT nlt_g_i_d
              INTO l_g_i_d
              FROM nm_linear_types
             WHERE nlt_id = pi_nlt_id;
        ELSE
            l_g_i_d := pi_g_i_d;
        END IF;

        SELECT nit_pnt_or_cont
          INTO l_pnt_or_cont
          FROM nm_inv_types
         WHERE nit_inv_type = pi_nal_nit_type;

        IF pi_start_m IS NULL
        THEN
            raise_application_error (-20001,
                                     'Start measure must be specified');
        END IF;

        IF l_pnt_or_cont = 'P' AND pi_start_m <> NVL (pi_end_m, pi_start_m)
        THEN
            raise_application_error (
                -20002,
                'The start and end measures must be the same for point asset types');
        ELSIF     l_pnt_or_cont = 'C'
              AND pi_start_m >= NVL (pi_end_m, pi_start_m)
        THEN
            l_reverse := -1;
            l_start_m := pi_end_m;
            l_end_m := pi_start_m;
        --         raise_application_error (
        --            -20002,
        --            'The end measure must be provided and greater than the start measure');
        END IF;

        SELECT l_start_m * NVL (uc_conversion_factor, 1),
               l_end_m * NVL (uc_conversion_factor, 1),
               nlt_units,
               CASE
                   WHEN ne_gty_group_type IS NOT NULL
                   THEN
                       (SELECT MIN (nm_slk)
                          FROM nm_members
                         WHERE nm_ne_id_in = pi_refnt)
                   ELSE
                       0
               END    min_start_m,
               CASE
                   WHEN ne_gty_group_type IS NOT NULL
                   THEN
                       (SELECT MAX (nm_end_slk)
                          FROM nm_members
                         WHERE nm_ne_id_in = pi_refnt)
                   ELSE
                       ne_length
               END    max_end_m
          INTO l_start,
               l_end,
               l_unit,
               l_min_start_m,
               l_max_end_m
          FROM nm_unit_conversions, nm_linear_types, nm_elements
         WHERE     nlt_units = uc_unit_id_out
               AND uc_unit_id_in = pi_unit
               AND ne_id = pi_refnt
               AND nlt_nt_type = ne_nt_type
               AND NVL (ne_gty_group_type, '%^&*') =
                   NVL (nlt_gty_type, '%^&*')
        UNION
        SELECT l_start_m,
               l_end_m,
               nlt_units,
               CASE
                   WHEN ne_gty_group_type IS NOT NULL
                   THEN
                       (SELECT MIN (nm_slk)
                          FROM nm_members
                         WHERE nm_ne_id_in = pi_refnt)
                   ELSE
                       0
               END    min_start_m,
               CASE
                   WHEN ne_gty_group_type IS NOT NULL
                   THEN
                       (SELECT MAX (nm_end_slk)
                          FROM nm_members
                         WHERE nm_ne_id_in = pi_refnt)
                   ELSE
                       ne_length
               END    max_end_m
          FROM nm_linear_types, nm_elements
         WHERE     nlt_units = pi_unit
               AND ne_id = pi_refnt
               AND nlt_nt_type = ne_nt_type
               AND NVL (ne_gty_group_type, '%^&*') =
                   NVL (nlt_gty_type, '%^&*');

        IF l_start_m < l_min_start_m OR l_end_m > l_max_end_m
        THEN
            raise_application_error (
                -20003,
                'The range measures must be within the measures of the referent');
        END IF;

        --
        IF l_g_i_d = 'D'
        THEN
            lb_load (lb_ops.merge_lb_rpt_tab (
                         pi_nal_id,
                         pi_nal_nit_type,
                         LB_RPT_TAB (LB_RPt (pi_refnt,
                                             pi_nlt_id,
                                             NULL,
                                             NULL,
                                             1,
                                             pi_range_seq_no,
                                             l_reverse,
                                             l_start,
                                             l_end,
                                             l_unit)),
                         10),
                     pi_nal_id,
                     pi_start_date,
                     pi_security_id,
                     pi_xsp,
                     loc_error);
        ELSE
            lb_load (lb_ops.merge_lb_rpt_tab (pi_nal_id,
                                              pi_nal_nit_type,
                                              lb_get.get_lb_rpt_d_tab (
                                                  LB_RPT_TAB (
                                                      LB_RPt (pi_refnt,
                                                              pi_nlt_id,
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              l_reverse,
                                                              l_start,
                                                              l_end,
                                                              l_unit))),
                                              10),
                     pi_nal_id,
                     pi_start_date,
                     pi_security_id,
                     pi_xsp,
                     loc_error);
        END IF;
    END;

    --
    PROCEDURE lb_load (p_obj_Rpt       IN     lb_RPt_tab,
                       p_nal_id        IN     nm_asset_locations_all.nal_id%TYPE,
                       p_start_date    IN     DATE,
                       p_security_id   IN     INTEGER,
                       p_xsp           IN     VARCHAR2,
                       p_loc_error        OUT lb_loc_error_tab)
    IS
        l_loc_tab   int_array_type := int_array_type (NULL);
        l_err_tab   lb_loc_error_tab;
    BEGIN
        l_err_tab :=
            validate_xsp_on_RPt_tab (PI_XSP => p_xsp, PI_RPT_TAB => p_obj_Rpt);

        IF l_err_tab.COUNT IS NOT NULL AND l_err_tab.COUNT > 0
        THEN
            --        if l_err_tab(1).error_code is not null then
            raise_application_error (
                -20004,
                'XSP is invalid - count = ' || l_err_tab.COUNT);
        --        end if;
        END IF;

        l_err_tab :=
            validate_admin_unit (
                PI_USER_ID   => TO_NUMBER (SYS_CONTEXT ('NM3CORE', 'USER_ID')),
                PI_RPT_TAB   => p_obj_Rpt);

        IF l_err_tab.COUNT IS NOT NULL AND l_err_tab.COUNT > 0
        THEN
            --        if l_err_tab(1).error_code is not null then
            raise_application_error (
                -20011,
                   'The user has no admin-unit privileges to place asset on the network - count = '
                || l_err_tab.COUNT);
        --        end if;
        END IF;

        DECLARE
            problem   VARCHAR2 (7) := NULL;
        BEGIN
            SELECT 'Problem'
              INTO problem
              FROM nm_inv_types
             WHERE EXISTS
                       (SELECT 1
                          FROM TABLE (p_obj_Rpt) t
                         WHERE     t.obj_type = nit_inv_type
                               AND nit_pnt_or_cont !=
                                   CASE start_m
                                       WHEN end_m THEN 'P'
                                       ELSE 'C'
                                   END);

            --
            raise_application_error (
                -20005,
                'Asset location has a point/line reference when asset type is flagged as line/point');
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        IF NVL (validate_inv_nw_constraint (p_obj_rpt), 'FALSE') = 'FALSE'
        THEN
            raise_application_error (
                -20006,
                'Asset locations fail to fit with network constraints');
        END IF;

        FORALL i IN 1 .. p_obj_Rpt.COUNT
            INSERT INTO nm_locations_all (nm_ne_id_of,
                                          nm_obj_type,
                                          nm_ne_id_in,
                                          nm_begin_mp,
                                          nm_start_date,
                                          nm_end_mp,
                                          nm_type,
                                          nm_security_id,
                                          nm_x_sect_st,
                                          nm_x_sect_end,
                                          nm_dir_flag,
                                          nm_nlt_id,
                                          nm_offset_st,
                                          nm_offset_end,
                                          nm_seg_no,
                                          nm_seq_no)
                 VALUES (
                     p_obj_Rpt (i).refnt,
                     p_obj_Rpt (i).obj_type,
                     p_obj_Rpt (i).obj_id,
                     p_obj_Rpt (i).start_m,
                     p_start_date,
                     p_obj_Rpt (i).end_m,
                     'I',
                     (SELECT CASE lb_security_type
                                 WHEN 'INHERIT'
                                 THEN
                                     (SELECT ne_admin_unit
                                        FROM nm_elements
                                       WHERE ne_id = p_obj_Rpt (i).refnt)
                                 ELSE
                                     p_security_id
                             END
                        FROM LB_INV_SECURITY
                       WHERE lb_exor_inv_type = p_obj_Rpt (i).obj_type),
                     p_xsp,
                     p_xsp,
                     p_obj_Rpt (i).dir_flag,
                     p_obj_Rpt (i).refnt_type,
                     (SELECT nwx_offset * p_obj_Rpt (i).dir_flag
                        FROM nm_nw_xsp, nm_elements
                       WHERE     nwx_nw_type = ne_nt_type
                             AND ne_id = p_obj_Rpt (i).refnt
                             AND nwx_x_sect = p_xsp
                             AND nwx_nsc_sub_class = ne_sub_class
                      UNION ALL
                      SELECT nwx_offset * p_obj_Rpt (i).dir_flag
                        FROM nm_members,
                             nm_elements,
                             nm_nt_groupings,
                             nm_linear_types,
                             nm_nw_xsp
                       WHERE     ne_id = nm_ne_id_in
                             AND nm_ne_id_of = p_obj_Rpt (i).refnt
                             AND nm_type = 'G'
                             AND nng_group_type = nm_obj_type
                             AND nng_nt_type = nlt_nt_type
                             AND nlt_id = p_obj_Rpt (i).refnt_type
                             AND nwx_nw_type = ne_nt_type
                             AND nwx_x_sect = p_xsp
                             AND nwx_nsc_sub_class = ne_sub_class),
                     (SELECT nwx_offset * p_obj_Rpt (i).dir_flag
                        FROM nm_nw_xsp, nm_elements
                       WHERE     nwx_nw_type = ne_nt_type
                             AND ne_id = p_obj_Rpt (i).refnt
                             AND nwx_x_sect = p_xsp
                             AND nwx_nsc_sub_class = ne_sub_class),
                     p_obj_Rpt (i).seg_id,
                     p_obj_Rpt (i).seq_id)
              RETURNING nm_loc_id
                   BULK COLLECT INTO l_loc_tab;

        IF int_array (l_loc_tab).is_empty
        THEN
            raise_application_error (
                -20007,
                'There is no location to load, please check the input arguments');
        END IF;


        --      FOR i IN 1 .. l_loc_tab.COUNT
        --      LOOP
        --         DBMS_OUTPUT.put_line ('ID  ' || TO_CHAR (l_loc_tab (i)));
        --      END LOOP;

        --
        INSERT INTO nm_location_geometry (nlg_loc_id,
                                          nlg_nal_id,
                                          nlg_location_type,
                                          nlg_obj_type,
                                          nlg_geometry)
            SELECT nm_loc_id,
                   p_nal_id,
                   'N',
                   nm_obj_type,
                   SDO_GEOM.sdo_arc_densify (
                       SDO_LRS.convert_to_std_geom (
                           SDO_LRS.OFFSET_GEOM_SEGMENT (
                               geoloc,
                               nm_begin_mp,
                               nm_end_mp,
                               NVL (nm_offset_st, 0),
                               g_sdo_tolerance --                                               ,'unit=m'
                                              )),
                       g_sdo_tolerance,
                       'arc_tolerance=' || TO_CHAR (g_sdo_arc_tolerance))    geoloc
              FROM nm_locations_all, v_lb_nlt_geometry
             WHERE     nm_ne_id_of = ne_id
                   AND nm_loc_id IN (SELECT t.COLUMN_VALUE
                                       FROM TABLE (l_loc_tab) t);

        --
        --  look after the aggregated geoetry
        --
        aggregate_geometry (pi_nal_id       => p_nal_id,
                            pi_start_date   => p_start_date);
    END;


    PROCEDURE lb_ld_path (
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_start_refnt    IN v_nm_nlt_refnts.ne_id%TYPE,
        pi_start_nlt_id   IN v_nm_nlt_refnts.nlt_id%TYPE,
        pi_start_m        IN NUMBER,
        pi_start_xsp      IN VARCHAR2,
        pi_end_refnt      IN v_nm_nlt_refnts.ne_id%TYPE,
        pi_end_nlt_id     IN v_nm_nlt_refnts.nlt_id%TYPE,
        pi_end_m          IN NUMBER,
        pi_end_xsp        IN VARCHAR2,
        pi_start_date     IN nm_asset_locations_all.nal_start_date%TYPE,
        pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE)
    IS
        loc_error    lb_loc_error_tab;
        l_load_tab   lb_rpt_tab;
    BEGIN
        l_load_tab :=
            lb_path.get_sdo_path (nm_lref (pi_start_refnt, pi_start_m),
                                  nm_lref (pi_end_refnt, pi_end_m));

        lb_load (lb_ops.merge_lb_rpt_tab (pi_nal_id,
                                          pi_nal_nit_type,
                                          l_load_tab,
                                          10),
                 pi_nal_id,
                 pi_start_date,
                 pi_security_id,
                 pi_start_xsp,
                 loc_error);
    END;

    PROCEDURE lb_ld_lref_array (
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_lref_array     IN nm_lref_array_type,
        pi_xsp            IN VARCHAR2,
        pi_start_date     IN nm_asset_locations_all.nal_start_date%TYPE,
        pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE)
    IS
        loc_error    lb_loc_error_tab;
        l_load_tab   lb_rpt_tab;
    BEGIN
        l_load_tab := lb_path.get_lb_rpt_tab_from_lref_array (pi_lref_array);
        lb_load (lb_ops.group_lb_rpt_tab (lb_ops.merge_lb_rpt_tab (
                                              pi_nal_id,
                                              pi_nal_nit_type,
                                              l_load_tab,
                                              10),
                                          10),
                 pi_nal_id,
                 pi_start_date,
                 pi_security_id,
                 pi_xsp,
                 loc_error);
    END;


    PROCEDURE lb_ld_geom (
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_geom           IN MDSYS.sdo_geometry,
        pi_start_date     IN nm_asset_locations_all.nal_start_date%TYPE,
        pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE)
    IS
        l_obj_geom    lb_obj_geom_tab;
        l_loc_error   lb_loc_error_tab;
    BEGIN
        SELECT CAST (
                   COLLECT (
                       lb_obj_geom (pi_nal_nit_type, nal_asset_id, pi_geom))
                       AS lb_obj_geom_tab)
          INTO l_obj_geom
          FROM nm_asset_locations
         WHERE nal_id = pi_nal_id AND nal_location_type = 'G';

        lb_load (l_obj_geom,
                 pi_nal_id,
                 pi_start_date,
                 pi_security_id,
                 l_loc_error);

        aggregate_geometry (pi_nal_id       => pi_nal_id,
                            pi_start_date   => pi_start_date);
    END;

    --

    PROCEDURE lb_load (
        p_obj_geom      IN     lb_obj_geom_tab,
        p_nal_id        IN     NM_ASSET_LOCATIONS_ALL.NAL_ID%TYPE,
        p_start_date    IN     DATE,
        p_security_id   IN     INTEGER,
        p_loc_error        OUT lb_loc_error_tab)
    IS
    BEGIN
        FORALL i IN 1 .. p_obj_geom.COUNT
            INSERT INTO nm_location_geometry (nlg_loc_id,
                                              nlg_location_type,
                                              nlg_nal_id,
                                              nlg_obj_type,
                                              nlg_geometry)
                 VALUES (NULL,
                         'G',
                         p_nal_id,
                         p_obj_geom (i).obj_type,
                         p_obj_geom (i).geom);

        aggregate_geometry (PI_NAL_ID       => p_nal_id,
                            PI_START_DATE   => p_start_date);
    END;


    PROCEDURE delete_asset_location (
        pi_nal_asset_id   IN INTEGER,
        pi_nal_nit_type   IN VARCHAR2,
        pi_nal_jxp        IN VARCHAR2 DEFAULT NULL)
    IS
    BEGIN
        DELETE FROM nm_location_geometry
              WHERE EXISTS
                        (SELECT 1
                           FROM nm_asset_locations_all, nm_locations_all
                          WHERE     nal_asset_id = pi_nal_asset_id
                                AND nal_id = nm_ne_id_in
                                AND nal_nit_type = nm_obj_type
                                AND nal_nit_type = pi_nal_nit_type
                                AND nlg_loc_id = nm_loc_id
                                AND DECODE (pi_nal_jxp,
                                            NULL, '&^%$',
                                            pi_nal_jxp) =
                                    DECODE (pi_nal_jxp,
                                            NULL, '&^%$',
                                            nal_jxp));

        DELETE FROM nm_locations_all
              WHERE EXISTS
                        (SELECT 1
                           FROM nm_asset_locations_all
                          WHERE     nal_asset_id = pi_nal_asset_id
                                AND nal_id = nm_ne_id_in
                                AND nal_nit_type = nm_obj_type
                                AND nal_nit_type = pi_nal_nit_type
                                AND DECODE (pi_nal_jxp,
                                            NULL, '&^%$',
                                            pi_nal_jxp) =
                                    DECODE (pi_nal_jxp,
                                            NULL, '&^%$',
                                            nal_jxp));

        DELETE FROM nm_asset_locations_all
              WHERE     nal_asset_id = pi_nal_asset_id
                    AND nal_nit_type = pi_nal_nit_type
                    AND DECODE (pi_nal_jxp, NULL, '&^%$', pi_nal_jxp) =
                        DECODE (pi_nal_jxp, NULL, '&^%$', nal_jxp);

        DELETE FROM nm_asset_geometry_all
              WHERE nag_asset_id = pi_nal_asset_id;

        aggregate_geometry (PI_ASSET_ID        => pi_nal_asset_id,
                            pi_location_type   => NULL,
                            pi_obj_type        => pi_nal_nit_type,
                            PI_START_DATE      => TRUNC (SYSDATE));
    END;

    PROCEDURE delete_location (pi_nal_id IN INTEGER)
    IS
    BEGIN
        DELETE FROM nm_location_geometry
              WHERE EXISTS
                        (SELECT 1
                           FROM nm_asset_locations_all, nm_locations_all
                          WHERE     nal_id = pi_nal_id
                                AND nal_id = nm_ne_id_in
                                AND nal_nit_type = nm_obj_type
                                AND nlg_loc_id = nm_loc_id);


        DELETE FROM nm_locations_all
              WHERE EXISTS
                        (SELECT 1
                           FROM nm_asset_locations_all
                          WHERE     nal_id = pi_nal_id
                                AND nal_id = nm_ne_id_in
                                AND nal_nit_type = nm_obj_type);

        DELETE FROM nm_asset_geometry_all
              WHERE EXISTS
                        (SELECT 1
                           FROM nm_asset_locations_all
                          WHERE     nal_id = pi_nal_id
                                AND nal_nit_type = nag_obj_type
                                AND nag_asset_id = nal_asset_id);

        DELETE FROM NM_ASSET_LOCATIONS_ALL
              WHERE nal_id = pi_nal_id;

        aggregate_geometry (pi_nal_id       => pi_nal_id,
                            pi_start_date   => TRUNC (SYSDATE));
    END;


    PROCEDURE close_asset_location (
        pi_nal_asset_id   IN INTEGER,
        pi_nal_nit_type   IN VARCHAR2,
        pi_end_date       IN DATE,
        pi_nal_jxp        IN VARCHAR2 DEFAULT NULL)
    IS
    BEGIN
        UPDATE nm_locations_all
           SET nm_end_date = pi_end_date
         WHERE EXISTS
                   (SELECT 1
                      FROM nm_asset_locations_all
                     WHERE     nal_asset_id = pi_nal_asset_id
                           AND nal_id = nm_ne_id_in
                           AND nal_nit_type = nm_obj_type
                           AND nal_nit_type = pi_nal_nit_type
                           AND DECODE (pi_nal_jxp, NULL, '&^%$', pi_nal_jxp) =
                               DECODE (pi_nal_jxp, NULL, '&^%$', nal_jxp));

        UPDATE nm_asset_locations_all
           SET nal_end_date = pi_end_date
         WHERE     nal_asset_id = pi_nal_asset_id
               AND nal_nit_type = pi_nal_nit_type
               AND DECODE (pi_nal_jxp, NULL, '&^%$', pi_nal_jxp) =
                   DECODE (pi_nal_jxp, NULL, '&^%$', nal_jxp);

        aggregate_geometry (pi_asset_id        => pi_nal_asset_id,
                            pi_location_type   => 'N',
                            pi_obj_type        => pi_nal_nit_type,
                            pi_start_date      => pi_end_date);
    END;

    PROCEDURE close_location (pi_nal_id IN INTEGER, pi_end_date IN DATE)
    IS
    BEGIN
        UPDATE nm_locations_all
           SET nm_end_date = pi_end_date
         WHERE EXISTS
                   (SELECT 1
                      FROM nm_asset_locations_all
                     WHERE     nal_id = pi_nal_id
                           AND nal_id = nm_ne_id_in
                           AND nal_nit_type = nm_obj_type);

        --
        UPDATE nm_asset_locations_all
           SET nal_end_date = pi_end_date
         WHERE nal_id = pi_nal_id;

        --
        aggregate_geometry (pi_nal_id       => pi_nal_id,
                            pi_start_date   => pi_end_date);
    END;

    --
    FUNCTION validate_admin_unit (pi_user_id   IN INTEGER,
                                  pi_rpt_tab      lb_RPt_tab --, return_code OUT integer
                                                            )
        RETURN lb_loc_error_tab
    AS
        retval   lb_loc_error_tab;
    BEGIN
        SELECT CAST (
                   COLLECT (
                       lb_loc_error (refnt, -99, 'No Admin Unit Privileges'))
                       AS lb_loc_error_tab)
          INTO retval
          FROM nm_elements, TABLE (pi_rpt_tab)
         WHERE     refnt = ne_id
               AND NOT EXISTS
                       (SELECT 1
                          FROM nm_user_aus, nm_admin_groups
                         WHERE     nag_parent_admin_unit = nua_admin_unit
                               --                          AND nua_mode = 'NORMAL'  -- any admin-unit mode as long as the user has been granted the network access
                               AND nag_child_admin_unit = ne_admin_unit
                               AND nua_user_id =
                                   TO_NUMBER (
                                       SYS_CONTEXT ('NM3CORE', 'USER_ID')));

        RETURN retval;
    EXCEPTION
        WHEN OTHERS
        THEN
            --    return_code := 1;
            raise_application_error (-20010, 'Problem in Admin-unit check');
    END;



    FUNCTION validate_xsp_on_RPt_tab (pi_xsp       IN VARCHAR2,
                                      pi_rpt_tab      lb_RPt_tab --, return_code OUT integer
                                                                )
        RETURN lb_loc_error_tab
    AS
        retval   lb_loc_error_tab;
    BEGIN
        SELECT CAST (
                   COLLECT (lb_loc_error (refnt, -99, 'No XSP Value'))
                       AS lb_loc_error_tab)
          INTO retval
          FROM TABLE (pi_rpt_tab)
         WHERE     NOT EXISTS
                       (SELECT 1
                          FROM nm_elements, xsp_restraints
                         WHERE     ne_id = refnt
                               AND ne_sub_class = xsr_scl_class
                               AND obj_type = xsr_ity_inv_code
                               AND xsr_nw_type = ne_nt_type
                               AND xsr_x_sect_value = pi_xsp)
               AND NOT EXISTS
                       (SELECT 1
                          FROM nm_elements, xsp_restraints, nm_members
                         WHERE     nm_ne_id_of = refnt
                               AND nm_ne_id_in = ne_id
                               AND ne_sub_class = xsr_scl_class
                               AND obj_type = xsr_ity_inv_code
                               AND xsr_nw_type = ne_nt_type
                               AND xsr_x_sect_value = pi_xsp)
               AND EXISTS
                       (SELECT 1
                          FROM nm_inv_types
                         WHERE     nit_inv_type = obj_type
                               AND nit_x_sect_allow_flag = 'Y'
                               AND pi_xsp IS NOT NULL);

        --  if retval.count >0 then
        --    return_code := 0;
        --  end if;
        RETURN retval;
    EXCEPTION
        WHEN OTHERS
        THEN
            --    return_code := 1;
            raise_application_error (-20008, 'Problem in XSP validation');
    END;

    --
    PROCEDURE aggregate_geometry (pi_nal_id       IN INTEGER,
                                  pi_start_date   IN DATE)
    IS
        l_location_type   VARCHAR2 (1);
        l_asset_id        INTEGER;
        l_obj_type        VARCHAR2 (4);
        l_start_date      DATE;
        l_end_date        DATE;
    BEGIN
        BEGIN
            SELECT nal_asset_id, nal_location_type, nal_nit_type
              INTO l_asset_id, l_location_type, l_obj_type
              FROM nm_asset_locations_all
             WHERE nal_id = pi_nal_id;

            aggregate_geometry (pi_asset_id        => l_asset_id,
                                pi_location_type   => l_location_type,
                                pi_obj_type        => l_obj_type,
                                pi_start_date      => pi_start_date);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;
    END;

    --

    PROCEDURE aggregate_geometry (pi_asset_id        IN INTEGER,
                                  pi_location_type   IN VARCHAR2,
                                  pi_obj_type        IN VARCHAR2,
                                  pi_start_date      IN DATE)
    IS
        l_geom   MDSYS.sdo_geometry;
    BEGIN
        BEGIN
            DELETE FROM nm_asset_geometry_all
                  WHERE     nag_asset_id = pi_asset_id
                        AND nag_location_type = pi_location_type
                        AND nag_obj_type = pi_obj_type;

            INSERT INTO nm_asset_geometry_all (nag_location_type,
                                               nag_asset_id,
                                               nag_obj_type,
                                               nag_start_date,
                                               nag_end_date,
                                               nag_geometry)
                  SELECT location_type,
                         nal_asset_id,
                         pi_obj_type,
                         start_date,
                         CASE end_date
                             WHEN TO_DATE ('31123000', 'DDMMYYYY') THEN NULL
                             ELSE end_date
                         END    end_date,
                         sdo_aggr_union (sdoaggrtype (geoloc, g_sdo_tolerance))
                    FROM (WITH
                              date_tracked_assets
                              AS
                                  (SELECT                   /* +materialize */
                                          nal_asset_id,
                                          d.nm_ne_id_in,
                                          d.start_date,
                                          d.end_date
                                     FROM (SELECT nal_asset_id,
                                                  nm_ne_id_in,
                                                  start_date,
                                                  LEAD (start_date, 1)
                                                      OVER (
                                                          PARTITION BY nm_ne_id_in
                                                          ORDER BY start_date)    end_date
                                             FROM (SELECT nal_asset_id,
                                                          nm_ne_id_in,
                                                          nm_start_date    start_date
                                                     FROM nm_locations_all,
                                                          nm_asset_locations_all
                                                    WHERE     nm_obj_type =
                                                              pi_obj_type
                                                          AND nm_ne_id_in =
                                                              nal_id
                                                          AND nal_asset_id =
                                                              pi_asset_id
                                                   UNION ALL
                                                   SELECT nal_asset_id,
                                                          nm_ne_id_in,
                                                          NVL (
                                                              nm_end_date,
                                                              TO_DATE (
                                                                  '31123000',
                                                                  'DDMMYYYY'))
                                                     FROM nm_locations_all,
                                                          nm_asset_locations_all
                                                    WHERE     nm_obj_type =
                                                              pi_obj_type
                                                          AND nm_ne_id_in =
                                                              nal_id
                                                          AND nal_asset_id =
                                                              pi_asset_id)) d
                                    WHERE start_date != end_date)
                          SELECT location_type,
                                 nal_asset_id,
                                 pi_obj_type,
                                 start_date,
                                 end_date,
                                 geoloc
                            FROM (SELECT 'N'                                      location_type,
                                         nal_asset_id,
                                         pi_obj_type,
                                         start_date,
                                         end_date,
                                         SDO_GEOM.sdo_arc_densify (
                                             SDO_LRS.convert_to_std_geom (
                                                 SDO_LRS.OFFSET_GEOM_SEGMENT (
                                                     geoloc,
                                                     nm_begin_mp,
                                                     nm_end_mp,
                                                     NVL (
                                                         nm_offset_st,
                                                         0),
                                                     g_sdo_tolerance --                                               ,'unit=m'
                                                                    )),
                                             g_sdo_tolerance,
                                                'arc_tolerance='
                                             || TO_CHAR (g_sdo_arc_tolerance))    geoloc
                                    FROM date_tracked_assets d,
                                         nm_locations_all   l,
                                         V_LB_NLT_GEOMETRY  g
                                   WHERE     nm_ne_id_of = ne_id
                                         AND l.nm_ne_id_in = d.nm_ne_id_in
                                         AND l.nm_obj_type = pi_obj_type
                                         AND l.nm_start_date < end_date
                                         AND NVL (
                                                 l.nm_end_date,
                                                 TO_DATE ('31123000',
                                                          'DDMMYYYY')) >
                                             start_date
                                         AND l.nm_nlt_id = g.nlt_id)
                           WHERE geoloc IS NOT NULL)
                GROUP BY location_type,
                         nal_asset_id,
                         pi_obj_type,
                         start_date,
                         end_date;
        --             WHERE geoloc IS NOT NULL;
        END;
    END;

    --
    PROCEDURE update_location (
        p_nal_id      IN nm_asset_locations_all.nal_id%TYPE,
        p_nal_descr   IN nm_asset_locations_all.nal_descr%TYPE DEFAULT g_nvl,
        p_jxp         IN nm_juxtapositions.njx_meaning%TYPE DEFAULT g_nvl)
    IS
        l_exor_njx_code   nm_juxtapositions.njx_code%TYPE := NULL;
    BEGIN
        IF p_jxp != g_nvl
        THEN
            --
            BEGIN
                SELECT njx_code
                  INTO l_exor_njx_code
                  FROM nm_juxtapositions,
                       NM_ASSET_TYPE_JUXTAPOSITIONS,
                       nm_asset_locations
                 WHERE     nal_id = p_nal_id
                       AND najx_njxt_id = njx_njxt_id
                       AND njx_meaning = p_jxp
                       AND najx_inv_type = nal_nit_type;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    raise_application_error (-20009,
                                             'Juxtaposition not known');
            END;
        ELSIF p_jxp IS NULL
        THEN
            l_exor_njx_code := NULL;
        END IF;

        UPDATE nm_asset_locations
           SET nal_descr =
                   DECODE (p_nal_descr, g_nvl, nal_descr, p_nal_descr),
               nal_jxp = DECODE (p_jxp, g_nvl, nal_jxp, l_exor_njx_code)
         WHERE nal_id = p_nal_id;
    END;

    FUNCTION validate_inv_nw_constraint (p_rpt_tab IN lb_rpt_tab)
        RETURN VARCHAR2
    IS
        retval            VARCHAR2 (10);
        l_dummy           INTEGER;
        constraint_code   VARCHAR2 (2000);
        validation_sql    VARCHAR2 (2000);
    BEGIN
        BEGIN
            SELECT LISTAGG (lb_nw_cons.get_constraint (ninc_id), ' AND ')
                       WITHIN GROUP (ORDER BY 1)
              INTO constraint_code
              FROM (  SELECT ninc_nlt_id,
                             ninc_inv_type,
                             ninc_id,
                             COUNT (*),
                             lb_nw_cons.get_constraint (ninc_id)    constraint_list
                        FROM nm_inv_nw_constraints, TABLE (p_rpt_tab) t
                       WHERE     t.obj_type = ninc_inv_type
                             AND t.refnt_type = ninc_nlt_id
                    GROUP BY ninc_inv_type, ninc_nlt_id, ninc_id);

            IF constraint_code IS NULL
            THEN
                RAISE NO_DATA_FOUND;
            END IF;

            --
            validation_sql :=
                   'select 1  from dual '
                || 'where exists ( select 1 from table(:b_rpt_tab) t '
                || 'where not exists ( '
                || ' select ne_id, ne_nt_type '
                || ' from nm_elements, nm_linear_types '
                || ' where t.refnt_type = nlt_id '
                || ' and ne_nt_type = nlt_nt_type '
                || ' and ne_id = t.refnt '
                || ' and '
                || constraint_code
                || '))';
            nm_debug.debug ('validation_sql ' || validation_sql);

            EXECUTE IMMEDIATE validation_sql
                INTO l_dummy
                USING p_rpt_tab;

            retval := 'FALSE';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                retval := 'TRUE';
        END;

        RETURN retval;
    END;

    PROCEDURE replace_location (
        pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
        pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
        pi_Rpt            IN lb_RPt_tab,
        pi_xsp            IN VARCHAR2,
        pi_start_date     IN nm_asset_locations_all.nal_start_date%TYPE,
        pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE,
        pi_use_history    IN VARCHAR2 DEFAULT 'N')
    IS
    BEGIN
        IF pi_use_history = 'N'
        THEN
            DELETE FROM nm_location_geometry
                  WHERE     nlg_nal_id = pi_nal_id
                        AND nlg_obj_type = pi_nal_nit_type;

            DELETE FROM nm_locations_all
                  WHERE     nm_ne_id_in = pi_nal_id
                        AND nm_obj_type = pi_nal_nit_type;

            lb_ld_rpt (pi_nal_id,
                       pi_nal_nit_type,
                       pi_Rpt,
                       pi_xsp,
                       pi_start_date,
                       pi_security_id);
        ELSE
            BEGIN
                UPDATE nm_locations
                   SET nm_end_date = pi_start_date
                 WHERE     nm_ne_id_in = pi_nal_id
                       AND nm_obj_type = pi_nal_nit_type;

                DECLARE
                    loc_errors   lb_loc_error_tab;
                BEGIN
                    lb_load (p_obj_Rpt       => pi_rpt,
                             p_nal_id        => pi_nal_id,
                             p_start_date    => pi_start_date,
                             p_security_id   => pi_security_id,
                             p_xsp           => pi_xsp,
                             p_loc_error     => loc_errors);
                END;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                    DELETE FROM nm_locations_all
                          WHERE     nm_ne_id_in = pi_nal_id
                                AND nm_obj_type = pi_nal_nit_type;

                    DECLARE
                        loc_errors   lb_loc_error_tab;
                    BEGIN
                        lb_load (p_obj_Rpt       => pi_rpt,
                                 p_nal_id        => pi_nal_id,
                                 p_start_date    => pi_start_date,
                                 p_security_id   => pi_security_id,
                                 p_xsp           => pi_xsp,
                                 p_loc_error     => loc_errors);
                    END;
            --                    lb_ld_rpt (pi_nal_id,
            --                               pi_nal_nit_type,
            --                               pi_Rpt,
            --                               pi_xsp,
            --                               pi_start_date,
            --                               pi_security_id);
            END;
        END IF;
    END;


    FUNCTION update_lb_rpt_tab (pi_rpt_tab   IN lb_rpt_tab,
                                pi_rn        IN INTEGER,
                                pi_start_m   IN NUMBER,
                                pi_end_m     IN NUMBER)
        RETURN lb_rpt_tab
    IS
        retval   lb_rpt_tab;
        dummy    INTEGER := 0;
    BEGIN
        -- check if the start and end can be updated
        BEGIN
            WITH
                l1
                AS
                    (SELECT ROW_NUMBER ()
                                OVER (PARTITION BY obj_id
                                      ORDER BY seg_id, seq_id)    rn,
                            t.*
                       FROM TABLE (pi_rpt_tab) t),
                l2
                AS
                    (SELECT l.*,
                            ne_id,
                            ne_unique,
                            ne_descr,
                            CASE
                                WHEN ne_gty_group_type IS NULL THEN 0
                                ELSE nm3net.get_min_slk (ne_id)
                            END    min_measure,
                            CASE
                                WHEN ne_gty_group_type IS NULL THEN ne_length
                                ELSE nm3net.get_max_slk (ne_id)
                            END    max_measure,
                            CASE dir_flag
                                WHEN 1 THEN ne_no_start
                                ELSE ne_no_end
                            END    start_node,
                            CASE dir_flag
                                WHEN -1 THEN ne_no_start
                                ELSE ne_no_end
                            END    end_node
                       FROM l1 l, nm_elements
                      WHERE ne_id = refnt),
                l3
                AS
                    (SELECT l2.*,
                            LAG (end_node, 1)
                                OVER (PARTITION BY obj_id ORDER BY rn)
                                prior_node,
                            LEAD (start_node, 1)
                                OVER (PARTITION BY obj_id ORDER BY rn)
                                next_node
                       FROM l2 l2),
                l4
                AS
                    (SELECT l3.*,
                            CASE
                                WHEN     NVL (prior_node, -999) =
                                         NVL (start_node, -999)
                                     AND CASE dir_flag
                                             WHEN 1 THEN min_measure
                                             ELSE max_measure
                                         END =
                                         CASE dir_flag
                                             WHEN 1 THEN start_m
                                             ELSE end_m
                                         END
                                THEN
                                    1
                                ELSE
                                    0
                            END    s_c,
                            CASE
                                WHEN     NVL (next_node, -999) =
                                         NVL (end_node, -999)
                                     AND CASE dir_flag
                                             WHEN -1 THEN min_measure
                                             ELSE max_measure
                                         END =
                                         CASE dir_flag
                                             WHEN -1 THEN start_m
                                             ELSE end_m
                                         END
                                THEN
                                    1
                                ELSE
                                    0
                            END    e_c
                       FROM l3),
                ranges
                AS
                    (SELECT l4.*,
                            CASE
                                WHEN s_c = 0
                                THEN
                                    CASE
                                        WHEN dir_flag = 1 THEN 'S'
                                        ELSE 'E'
                                    END
                            END
                                s_updatable,
                            CASE WHEN s_c = 0 THEN min_measure ELSE NULL END
                                s_range_start,
                            CASE WHEN s_c = 0 THEN max_measure ELSE NULL END
                                s_range_end,
                            CASE
                                WHEN e_c = 0
                                THEN
                                    CASE
                                        WHEN dir_flag = -1 THEN 'S'
                                        ELSE 'E'
                                    END
                            END
                                e_updatable,
                            CASE WHEN e_c = 0 THEN min_measure ELSE NULL END
                                e_range_start,
                            CASE WHEN e_c = 0 THEN max_measure ELSE NULL END
                                e_range_end
                       FROM l4)
            --            SELECT rn,
            --                   ne_id,
            --                   ne_unique,
            --                   ne_descr,
            --                   refnt_type,
            --                   obj_type,
            --                   obj_id,
            --                   seg_id,
            --                   seq_id,
            --                   dir_flag,
            --                   start_m,
            --                   end_m,
            --                   m_unit,
            --                   s_updatable,
            --                   s_range_start,
            --                   s_range_end,
            --                   e_updatable,
            --                   e_range_start,
            --                   e_range_end
            --              FROM l5 )
            SELECT 1
              INTO dummy
              FROM DUAL
             WHERE                                                     --1 = 2
                      --         and
                      EXISTS
                          (SELECT 1
                             FROM ranges
                            WHERE     rn = pi_rn
                                  AND pi_start_m IS NOT NULL
                                  AND (   s_updatable IS NULL
                                       OR (   pi_start_m < s_range_start
                                           OR pi_start_m > s_range_end)))
                   OR EXISTS
                          (SELECT 1
                             FROM ranges
                            WHERE     rn = pi_rn
                                  AND pi_end_m IS NOT NULL
                                  AND (   e_updatable IS NULL
                                       OR (   pi_end_m < e_range_start
                                           OR pi_end_m > e_range_end)));

            --
            IF dummy != 0
            THEN
                raise_application_error (
                    -20095,
                    'The values to be updated on this record are either not allowed or are out of range');
            END IF;
        --
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;                                     -- No exception data
        END;

        --

        WITH
            tab
            AS
                (SELECT ROWNUM rn, t.*
                   FROM TABLE (pi_rpt_tab) t)
        SELECT CAST (
                   COLLECT (
                       lb_rpt (
                           t.refnt,
                           t.refnt_type,
                           t.obj_type,
                           t.obj_id,
                           t.seg_id,
                           t.seq_id,
                           dir_flag,
                           CASE
                               WHEN t.rn = pi_rn
                               THEN
                                   NVL (pi_start_m, t.start_m)
                               ELSE
                                   t.start_m
                           END,
                           CASE
                               WHEN t.rn = pi_rn THEN NVL (pi_end_m, t.end_m)
                               ELSE t.end_m
                           END,
                           m_unit)) AS lb_rpt_tab)
          INTO retval
          FROM tab t;

        g_load_tab := retval;

        --
        RETURN retval;
    END;


    FUNCTION retrieve_global_rpt_tab
        RETURN lb_rpt_tab
    IS
    BEGIN
        RETURN g_load_tab;
    END;
END lb_load;
/