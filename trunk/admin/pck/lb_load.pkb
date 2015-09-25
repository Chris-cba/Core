CREATE OR REPLACE PACKAGE BODY lb_load
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_load.pkb-arc   1.11   Sep 25 2015 17:28:26   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_load.pkb  $
   --       Date into PVCS   : $Date:   Sep 25 2015 17:28:26  $
   --       Date fetched Out : $Modtime:   Sep 25 2015 17:28:28  $
   --       PVCS Version     : $Revision:   1.11  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for loading LRS placements
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.11  $';

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

   PROCEDURE lb_load (p_obj_geom      IN     lb_obj_geom_tab,
                      p_nal_id        IN     NM_ASSET_LOCATIONS_ALL.NAL_ID%TYPE,
                      p_start_date    IN     DATE,
                      p_security_id   IN     INTEGER,
                      p_loc_error        OUT lb_loc_error_tab);

   --
   FUNCTION validate_xsp_on_RPt_tab (pi_xsp       IN VARCHAR2,
                                     pi_rpt_tab      lb_RPt_tab)
      RETURN lb_loc_error_tab;


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
      pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE)
   IS
      loc_error    lb_loc_error_tab;
      l_g_i_d      VARCHAR2 (1);
      l_load_tab   lb_rpt_tab;
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

      --
      IF l_g_i_d = 'D'
      THEN
         lb_load (lb_ops.merge_lb_rpt_tab (pi_nal_id,
                                           pi_nal_nit_type,
                                           LB_RPT_TAB (LB_RPt (pi_refnt,
                                                               pi_nlt_id,
                                                               NULL,
                                                               NULL,
                                                               NULL,
                                                               NULL,
                                                               1,
                                                               pi_start_m,
                                                               pi_end_m,
                                                               pi_unit)),
                                           10),
                  pi_nal_id,
                  pi_start_date,
                  pi_security_id,
                  pi_xsp,
                  loc_error);
      ELSE
         lb_load (lb_ops.merge_lb_rpt_tab (
                     pi_nal_id,
                     pi_nal_nit_type,
                     get_lb_rpt_d_tab (LB_RPT_TAB (LB_RPt (pi_refnt,
                                                           pi_nlt_id,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           1,
                                                           pi_start_m,
                                                           pi_end_m,
                                                           pi_unit))),
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
      l_loc_tab   int_array_type;
      l_err_tab   lb_loc_error_tab;
   BEGIN
      l_err_tab :=
         validate_xsp_on_RPt_tab (PI_XSP => p_xsp, PI_RPT_TAB => p_obj_Rpt);

      IF l_err_tab.COUNT IS NOT NULL AND l_err_tab.COUNT > 0
      THEN
         --        if l_err_tab(1).error_code is not null then
         raise_application_error (
            -20001,
            'XSP is invalid - count = ' || l_err_tab.COUNT);
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
            -20002,
            'Asset location has a point/line reference when asset type is flagged as line/point');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;


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
                                       nm_offset_end)
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
                                   AND nwx_nsc_sub_class = ne_sub_class))
           RETURNING nm_loc_id
                BULK COLLECT INTO l_loc_tab;

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
                SDO_LRS.convert_to_std_geom (SDO_LRS.OFFSET_GEOM_SEGMENT (
                                                geoloc,
                                                nm_begin_mp,
                                                nm_end_mp,
                                                NVL (nm_offset_st, 0),
                                                0.005))
           FROM nm_locations_all, v_lb_nlt_geometry
          WHERE     nm_ne_id_of = ne_id
                AND nm_loc_id IN (SELECT t.COLUMN_VALUE
                                    FROM TABLE (l_loc_tab) t);

      --
      --  look after the aggregated geoetry
      --
      aggregate_geometry (pi_nal_id => p_nal_id, pi_start_date => p_start_date);
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
                   lb_obj_geom (pi_nal_nit_type, nal_asset_id, pi_geom)) AS lb_obj_geom_tab)
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

   PROCEDURE lb_load (p_obj_geom      IN     lb_obj_geom_tab,
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

      aggregate_geometry (PI_NAL_ID => p_nal_id, PI_START_DATE => p_start_date);
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

      aggregate_geometry (pi_nal_id => pi_nal_id, pi_start_date => pi_end_date);
   END;

   --

   FUNCTION validate_xsp_on_RPt_tab (pi_xsp       IN VARCHAR2,
                                     pi_rpt_tab      lb_RPt_tab --, return_code OUT integer
                                                               )
      RETURN lb_loc_error_tab
   AS
      retval   lb_loc_error_tab;
   BEGIN
      SELECT CAST (
                COLLECT (lb_loc_error (refnt, -99, 'No XSP Value')) AS lb_loc_error_tab)
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
         raise_application_error (-20001, 'Problem in XSP validation');
   END;

   --
   PROCEDURE aggregate_geometry (pi_nal_id IN INTEGER, pi_start_date IN DATE)
   IS
      l_location_type   VARCHAR2 (1);
      l_asset_id        INTEGER;
      l_obj_type        VARCHAR2 (4);
      l_start_date      DATE;
      l_end_date        DATE;
   BEGIN
      SELECT nal_asset_id, nal_location_type, nal_nit_type
        INTO l_asset_id, l_location_type, l_obj_type
        FROM nm_asset_locations_all
       WHERE nal_id = pi_nal_id;

      aggregate_geometry (pi_asset_id        => l_asset_id,
                          pi_location_type   => l_location_type,
                          pi_obj_type        => l_obj_type,
                          pi_start_date      => pi_start_date);
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

         --
         INSERT INTO nm_asset_geometry_all (nag_location_type,
                                            nag_asset_id,
                                            nag_obj_type,
                                            nag_start_date,
                                            nag_end_date,
                                            nag_geometry)
            SELECT pi_location_type,
                   asset_id,
                   obj_type,
                   start_date,
                   LEAST (NVL (end_date, TO_DATE ('31122999', 'DDMMYYYY')),
                          lag_start)
                      end_date,
                   l_geom
              FROM (SELECT asset_id,
                           obj_type,
                           start_date,
                           end_date,
                           LAG (start_date, 1)
                              OVER (ORDER BY start_date DESC, end_date DESC)
                              lag_start,
                           LAG (end_date, 1)
                              OVER (ORDER BY start_date DESC, end_date DESC)
                              lag_end,
                           l_geom
                      FROM (  SELECT                      --nlg_location_type,
                                    asset_id,
                                     obj_type,
                                     start_date,
                                     end_date,
                                     sdo_aggr_union (
                                        sdoaggrtype (nlg_geometry, 0.005))
                                        l_geom
                                FROM (SELECT nlg_location_type,
                                             pi_asset_id asset_id,
                                             nlg_obj_type obj_type,
                                             nal_start_date start_date,
                                             nal_end_date end_date,
                                             nlg_geometry
                                        FROM nm_location_geometry,
                                             nm_asset_locations_all l2
                                       WHERE     nlg_nal_id = l2.nal_id
                                             AND l2.nal_asset_id = pi_asset_id
                                             AND nal_location_type =
                                                    pi_location_type
                                             AND l2.nal_location_type =
                                                    nlg_location_type
                                             AND l2.nal_nit_type = nlg_obj_type
                                             AND l2.nal_nit_type = pi_obj_type
                                             AND nal_location_type =
                                                    pi_location_type
                                             AND nlg_obj_type = pi_obj_type) t
                            GROUP BY                      --nlg_location_type,
                                    asset_id,
                                     obj_type,
                                     start_date,
                                     end_date));
      END;
   END;

   --
   PROCEDURE update_location (
      p_nal_id      IN nm_asset_locations_all.nal_id%TYPE,
      p_nal_descr   IN nm_asset_locations_all.nal_descr%TYPE,
      p_jxp         IN nm_juxtapositions.njx_meaning%TYPE DEFAULT NULL)
   IS
      l_exor_njx_code   nm_juxtapositions.njx_code%TYPE := NULL;
   BEGIN
      IF p_jxp IS NOT NULL
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
               raise_application_error (-20001, 'Juxtaposition not known');
         END;
      END IF;

      UPDATE nm_asset_locations
         SET nal_descr = p_nal_descr,
             nal_jxp = NVL (l_exor_njx_code, nal_jxp)
       WHERE nal_id = p_nal_id;
   END;
END lb_load;
/
