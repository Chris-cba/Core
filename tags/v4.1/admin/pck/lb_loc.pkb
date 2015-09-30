CREATE OR REPLACE PACKAGE BODY lb_loc
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_loc.pkb-arc   1.2   Sep 30 2015 13:08:58   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_loc.pkb  $
   --       Date into PVCS   : $Date:   Sep 30 2015 13:08:58  $
   --       Date fetched Out : $Modtime:   Sep 30 2015 13:08:18  $
   --       PVCS Version     : $Revision:   1.2  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for handling locations
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

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
             FROM nm_location_geometry,
                  nm_locations,
                  nm_asset_locations
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
           FROM nm_asset_locations,
                nm_location_geometry,
                nm_locations
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
      pi_nal_id   IN nm_asset_locations_all.nal_id%TYPE,
      pi_refnt_type IN integer)
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
             AND nlt_id = nvl(pi_refnt_type, nlt_id );

      --
      --
      RETURN retval;
   END;

   FUNCTION translate_nlt (pi_lb_rpt_tab    IN lb_RPt_tab,
                           pi_refnt_type    IN INTEGER,
                           pi_inner_join_flag IN VARCHAR2 DEFAULT 'Y',
                           pi_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      --
      retval         lb_RPt_tab;
      l_refnt_type   nm_linear_types%ROWTYPE;
   BEGIN
      -- just going up the hierarchy to aggregate the data according to linear type
      WITH itab
           AS (SELECT t.*
                 FROM TABLE (pi_lb_rpt_tab) t)
      SELECT lb_RPt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     ROWNUM,
                     1,
                     start_m,
                     end_m,
                     m_unit)
        BULK COLLECT INTO retval
        FROM (  SELECT route_id refnt,
                       nlt_id refnt_type,
                       inv_type obj_type,
                       inv_id obj_id,
                       inv_segment_id seg_id,
                       INV_START_SLK start_m,
                       inv_end_slk end_m,
                       m_unit
                  FROM (SELECT route_id,
                               l.inv_id,
                               l.inv_segment_id,
                               inv_type,
                               nlt_id,
                               l.sc,
                               MIN (
                                  start_slk)
                               OVER (
                                  PARTITION BY route_id, inv_id, inv_segment_id)
                                  inv_start_slk,
                               MAX (
                                  end_slk)
                               OVER (
                                  PARTITION BY route_id, inv_id, inv_segment_id)
                                  inv_end_slk,
                               FIRST_VALUE (
                                  nm_seg_no)
                               OVER (
                                  PARTITION BY route_id, inv_id, inv_segment_id)
                                  start_seg,
                               LAST_VALUE (
                                  nm_seg_no)
                               OVER (
                                  PARTITION BY route_id, inv_id, inv_segment_id)
                                  end_seg,
                               m_unit
                          FROM (SELECT k.*,
                                         --sum( conn_flag ) over (order by nm_seg_no, nm_seq_no rows between unbounded preceding and current row ) as segment_id,
                                         SUM (
                                            inv_conn_flag)
                                         OVER (
                                            PARTITION BY route_id, inv_id
                                            ORDER BY nm_seg_no, nm_seq_no
                                            ROWS BETWEEN UNBOUNDED PRECEDING
                                                 AND     CURRENT ROW)
                                       + 1
                                          AS inv_segment_id
                                  FROM (SELECT j.*,
                                               DECODE (
                                                  start_node,
                                                  inv_prior_node, DECODE (
                                                                     sc,
                                                                     inv_prior_sc, DECODE (
                                                                                      cs,
                                                                                      inv_prior_ce, 0,
                                                                                      1),
                                                                     1),
                                                  1)
                                                  inv_conn_flag
                                          FROM (SELECT i.*,
                                                       NVL (
                                                          LAG (
                                                             nm_seg_no,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
  															    nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          nm_seg_no)
                                                          prior_seg_no,
                                                       NVL (
                                                          LAG (
                                                             datum_id,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          datum_id)
                                                          prior_datum,
                                                       NVL (
                                                          LAG (
                                                             end_node,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          start_node)
                                                          prior_node,
                                                       NVL (
                                                          LEAD (
                                                             start_node,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          end_node)
                                                          next_node,
                                                       NVL (
                                                          LAG (
                                                             sc,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          sc)
                                                          prior_sc,
                                                       NVL (
                                                          LAG (
                                                             cs,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          cs)
                                                          prior_cs,
                                                       --
                                                       NVL (
                                                          LAG (
                                                             inv_id,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          inv_id)
                                                          prior_inv_id,
                                                       NVL (
                                                          LAG (
                                                             nm_seg_no,
                                                             1)
                                                          OVER (
                                                             PARTITION BY inv_id
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          nm_seg_no)
                                                          inv_prior_seg_no,
                                                       NVL (
                                                          LAG (
                                                             datum_id,
                                                             1)
                                                          OVER (
                                                             PARTITION BY inv_id
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          datum_id)
                                                          inv_prior_datum,
                                                       NVL (
                                                          LAG (
                                                             end_node,
                                                             1)
                                                          OVER (
                                                             PARTITION BY inv_id
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          start_node)
                                                          inv_prior_node,
                                                       NVL (
                                                          LAG (
                                                             cs,
                                                             1)
                                                          OVER (
                                                             PARTITION BY inv_id
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          cs)
                                                          inv_prior_cs,
                                                       NVL (
                                                          LAG (
                                                             ce,
                                                             1)
                                                          OVER (
                                                             PARTITION BY inv_id
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          ce)
                                                          inv_prior_ce,
                                                       NVL (
                                                          LAG (
                                                             sc,
                                                             1)
                                                          OVER (
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          sc)
                                                          inv_prior_sc,
                                                       NVL (
                                                          LAG (
                                                             datum_end,
                                                             1)
                                                          OVER (
                                                             PARTITION BY inv_id
                                                             ORDER BY
                                                                route_id,
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          ce)
                                                          inv_prior_datum_st
                                                  FROM (WITH INV_IDS
                                                             AS (SELECT itab.obj_id
                                                                           inv_id,
                                                                        itab.refnt
                                                                           datum_id,
                                                                        itab.obj_type
                                                                           inv_type,
                                                                        itab.start_m
                                                                           datum_st,
                                                                        itab.end_m
                                                                           datum_end
                                                                   FROM itab) --nm_members where nm_ne_id_of in ( select nm_ne_id_of from nm_members c where c.nm_ne_id_in = 1887))
                                                          SELECT i.*,
                                                                 nlt_id,
                                                                 m.nm_ne_id_in
                                                                    route_id,
                                                                 m.nm_slk,
                                                                 m.nm_end_slk,
                                                                 nm_seg_no,
                                                                 nm_seq_no,
                                                                 DECODE (
                                                                    m.nm_cardinality,
                                                                    1, ne_no_start,
                                                                    -1, ne_no_end,
                                                                    ne_no_start)
                                                                    start_node,
                                                                 DECODE (
                                                                    m.nm_cardinality,
                                                                    1, ne_no_end,
                                                                    -1, ne_no_start,
                                                                    ne_no_end)
                                                                    end_node,
                                                                 ne_length,
                                                                 m.nm_cardinality
                                                                    dir,
                                                                 DECODE (
                                                                    ne_sub_class,
                                                                    'S', 'S/L',
                                                                    'L', 'S/L',
                                                                    'R')
                                                                    sc,
                                                                 DECODE (
                                                                    datum_st,
                                                                    0, 0,
                                                                    1)
                                                                    cs,
                                                                 DECODE (
                                                                    datum_end,
                                                                    ne_length, 0,
                                                                    1)
                                                                    ce,
                                                                 DECODE (
                                                                    nm_cardinality,
                                                                    1, (  nm_slk
                                                                        + datum_st),
                                                                    -1, (  nm_slk
                                                                         + (  ne_length
                                                                            - datum_end)))
                                                                    start_slk,
                                                                 DECODE (
                                                                    nm_cardinality,
                                                                    1, (  nm_slk
                                                                        + datum_end),
                                                                    -1, (  nm_slk
                                                                         + (  ne_length
                                                                            - datum_st)))
                                                                    end_slk,
                                                                    nlt_units m_unit
                                                            FROM INV_IDS i,
                                                                 nm_members m,
                                                                 nm_elements e,
                                                                 nm_linear_types
                                                           WHERE     nm_obj_type =
                                                                        nlt_gty_type
                                                                 AND nlt_id = pi_refnt_type
                                                                 AND datum_id =
                                                                        e.ne_id
                                                                 AND nm_ne_id_of =
                                                                        datum_id
                                                        ORDER BY m.nm_ne_id_in,
                                                                 nm_seg_no,
                                                                 nm_seq_no,
                                                                 nm_ne_id_of,
                                                                 datum_st * dir,
                                                                   datum_end
                                                                 * dir) i) j) k)
                               l)
              GROUP BY route_id,
                       inv_id,
                       inv_segment_id,
                       inv_type,
                       sc,
                       inv_start_slk,
                       inv_end_slk,
                       start_seg,
                       end_seg,
                       nlt_id,
                       m_unit
                       union all
            SELECT  refnt,
                    refnt_type,
                    obj_type,
                    obj_id,
                    seg_id,
                    start_m,
                    end_m,
                    m_unit           
           from table (pi_lb_RPt_tab)
           where pi_inner_join_flag = 'N'
           and not exists ( select 1 from nm_members, nm_linear_types where nlt_id = pi_refnt_type and nm_obj_type = nlt_gty_type and nm_ne_id_of = refnt)
                         ORDER BY 1, 6 );





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
         WHERE nin_nit_inv_code = pi_nal_nit_type 
           AND nin_nw_type = nlt_nt_type
           AND nlt_id = nvl(pi_refnt_type, nlt_id )
           AND ROWNUM = 1;
      EXCEPTION
        When NO_DATA_FOUND then
          l_nlt_id := NULL;
        When TOO_MANY_ROWS then
          l_nlt_id := pi_refnt_type;          
      END;
      
      IF l_nlt_id = nvl(pi_refnt_type, l_nlt_id)
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
         WHERE nin_nit_inv_code = nal_nit_type
           AND nin_nw_type = nlt_nt_type
           AND nal_id = pi_nal_id
           AND nlt_id = nvl(pi_refnt_type, nlt_id )
           AND ROWNUM = 1;
      EXCEPTION
        When NO_DATA_FOUND then
          l_nlt_id := NULL;
        When TOO_MANY_ROWS then
          l_nlt_id := pi_refnt_type;
      END;

      IF l_nlt_id = nvl(pi_refnt_type, l_nlt_id)
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