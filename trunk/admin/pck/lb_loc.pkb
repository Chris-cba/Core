CREATE OR REPLACE PACKAGE BODY lb_loc
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_loc.pkb-arc   1.3   Oct 19 2016 14:14:22   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_loc.pkb  $
   --       Date into PVCS   : $Date:   Oct 19 2016 14:14:22  $
   --       Date fetched Out : $Modtime:   Oct 19 2016 14:13:48  $
   --       PVCS Version     : $Revision:   1.3  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for handling locations
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.3  $';

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
          WHERE nal_asset_id = pi_asset_id AND nal_nit_type = pi_nal_nit_type;

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
           SELECT SDO_AGGR_CONCAT_lines (
                     SDO_LRS.convert_to_std_geom (nlg_geometry))
                     geoloc
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
           SELECT SDO_AGGR_CONCAT_lines (
                     SDO_LRS.convert_to_std_geom (nlg_geometry))
                     geoloc
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
                     NULL,
                     NULL,
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
             AND ne_nt_type = nlt_nt_type;

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
                     NULL,
                     NULL,
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
             AND nlt_id = NVL (pi_refnt_type, nlt_id);

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
      SELECT *
        INTO l_refnt_type
        FROM nm_linear_types
       WHERE nlt_id = pi_refnt_type;

      IF l_refnt_type.nlt_gty_type IS NULL
      THEN
         raise_application_error (-20004,
                                  'Linear type does not support aggregation');
      END IF;

      SELECT lb_rpt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     ROWNUM,
                     dir_flag,
                     start_m,
                     end_m,
                     m_unit)
        BULK COLLECT INTO retval
        FROM (SELECT t.*
                FROM TABLE (
                        lb_get.get_lb_rpt_r_tab (pi_lb_rpt_tab,
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
                     m_unit
                FROM TABLE (pi_lb_RPt_tab)
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
END lb_loc;
/
