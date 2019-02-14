CREATE OR REPLACE PACKAGE BODY lb_query
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/lb_query.pkb-arc   1.0   Feb 14 2019 14:13:32   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_query.pkb  $
   --       Date into PVCS   : $Date:   Feb 14 2019 14:13:32  $
   --       Date fetched Out : $Modtime:   Feb 14 2019 14:09:10  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for retrieving asset and locations
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_query';

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

   FUNCTION get_asset_data (p_ne_id         IN INTEGER,
                            p_start_m       IN NUMBER,
                            p_end_m         IN NUMBER,
                            p_unit          IN NUMBER,
                            p_obj_types     IN lb_asset_type_tab,
                            p_intsct        IN VARCHAR2 DEFAULT 'FALSE',
                            p_lb_only       IN VARCHAR2 DEFAULT 'FALSE',
                            p_whole_only    IN VARCHAR2 DEFAULT 'FALSE',
                            p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      --
      l_is_linear   VARCHAR2 (1);
      l_is_group    VARCHAR2 (1);
      g_of_g_flag   VARCHAR2 (1);

      --
      FUNCTION is_linear
         RETURN VARCHAR2
      IS
         linear_flag   VARCHAR2 (1);
      BEGIN
         SELECT nt_linear
           INTO linear_flag
           FROM nm_types, nm_elements
          WHERE ne_id = p_ne_id AND ne_nt_type = nt_type;

         RETURN linear_flag;
      END;
   --
   BEGIN
      l_is_linear := is_linear;

      BEGIN
         SELECT ngt_sub_group_allowed
           INTO g_of_g_flag
           FROM nm_group_types, nm_elements
          WHERE ne_id = p_ne_id AND ne_gty_group_type = ngt_group_type;

         l_is_group := 'Y';

         IF g_of_g_flag = 'Y' AND p_intsct = 'TRUE'
         THEN
            raise_application_error (
               -20020,
               'Intersections cannot be formed with a group of groups');
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_is_group := 'N';
      END;

      --
      IF p_ne_id IS NULL
      THEN
         raise_application_error (-20021,
                                  'A road group or element ID is required');
      ELSIF     l_is_linear = 'N'
            AND (   p_start_m IS NOT NULL
                 OR p_end_m IS NOT NULL
                 OR p_unit IS NOT NULL)
      THEN
         raise_application_error (
            -20022,
            'Range and unit details do not apply to this group');
      END IF;

      --
      IF g_of_g_flag = 'Y'
      THEN
         RETURN lb_get.g_of_g_search (p_ne_id,
                               NULL, --p_obj_types,
                               p_lb_only,
                               p_whole_only,
                               100);
      ELSIF l_is_group = 'Y'
      THEN
         RETURN get_asset_data_from_rpt_tab (
                   p_refnt_tab     => lb_get.get_lb_rpt_d_tab (
                                        LB_OPS.NORMALIZE_RPT_TAB (
                                           lb_rpt_tab (
                                              lb_rpt (
                                                 p_ne_id,
                                                 NULL,
                                                 NULL,
                                                 p_ne_id,
                                                 p_start_m,
                                                 p_end_m,
                                                 p_unit,
                                                 NULL,
                                                 NULL,
                                                 NULL)))),
                   p_obj_types     => p_obj_types,
                   p_intsct        => p_intsct,
                   p_lb_only       => p_lb_only,
                   p_whole_only    => p_whole_only,
                   p_cardinality   => 100);
      ELSIF l_is_group = 'Y'
      THEN
         RETURN get_asset_data_from_rpt_tab (
                   p_refnt_tab     => LB_OPS.NORMALIZE_RPT_TAB (
                                        lb_rpt_tab (
                                           lb_rpt (
                                              p_ne_id,
                                              NULL,
                                              NULL,
                                              p_ne_id,
                                              p_start_m,
                                              p_end_m,
                                              p_unit,
                                              NULL,
                                              NULL,
                                              NULL))),
                   p_obj_types     => p_obj_types,
                   p_intsct        => p_intsct,
                   p_lb_only       => p_lb_only,
                   p_whole_only    => p_whole_only,
                   p_cardinality   => 100);
      END IF;
   END;

   --
   FUNCTION get_asset_data_from_rpt_tab (
      p_refnt_tab     IN lb_RPt_tab,
      p_obj_types     IN lb_asset_type_tab,
      p_intsct        IN VARCHAR2 DEFAULT 'FALSE',
      p_lb_only       IN VARCHAR2 DEFAULT 'FALSE',
      p_whole_only    IN VARCHAR2 DEFAULT 'FALSE',
      p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      retval       lb_rpt_tab;
      l_nit_row    nm_inv_types%ROWTYPE;
      l_ft_flag    VARCHAR2 (1);
      l_category   VARCHAR2 (1);
      g_tol        NUMBER := 0.005;
   BEGIN
      IF p_obj_types IS NULL OR p_obj_types IS EMPTY
      THEN
         IF lb_ops.lb_rpt_tab_has_network (p_refnt_tab) = 'FALSE'
         THEN
            raise_application_error (
               -20015,
               'Inadequate input arguments to from a valid query');
         END IF;                        -- allow a query based on network only
      END IF;

      --   Do we need to include Exor FT data?
      /*
            BEGIN
               SELECT DECODE (nit_table_name, NULL, 'N', 'Y'), nit_category
                 INTO l_ft_flag, l_category
                 FROM nm_inv_types, table( p_obj_types )
                WHERE nit_inv_type = column_value;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF l_ft_flag = 'Y' AND l_category = 'F'
            THEN
               IF p_lb_only = 'TRUE'
               THEN
                  raise_application_error (
                     -20003,
                     'LB only flag is at odds with a foreign table asset');
               END IF;

               --
               retval :=
                  lb_get.get_ft_rpt_tab (
                     p_rpt_tab      => p_refnt_tab,
                     p_table_name   => l_nit_row.nit_table_name,
                     p_inv_type     => p_obj_type,
                     p_key          => l_nit_row.nit_foreign_pk_column,
                     p_ne_key       => l_nit_row.nit_lr_ne_column_name,
                     p_start_col    => l_nit_row.nit_lr_st_chain,
                     p_end_col      => l_nit_row.nit_lr_end_chain);
            ELSIF     p_refnt_tab IS NOT NULL
      */
      IF     p_refnt_tab IS NOT NULL
         AND lb_ops.lb_rpt_tab_has_network (p_refnt_tab) = 'TRUE'
      THEN
         IF p_intsct = 'TRUE'
         THEN
            nm_debug.debug_on;
            nm_debug.debug ('intersect using tolerance of ' || g_tol);

            SELECT lb_ops.rpt_intersection (rpt_tab, p_refnt_tab, 20)
              INTO retval
              FROM (SELECT CAST (COLLECT (rpt) AS lb_rpt_tab) rpt_tab
                      FROM (SELECT lb_RPt (nm_ne_id_of,
                                           nlt_id,
                                           nm_obj_type,
                                           nm_ne_id_in,
                                           nm_seg_no,
                                           nm_seq_no,
                                           nm_dir_flag,
                                           nm_begin_mp,
                                           nm_end_mp,
                                           nlt_units)
                                      rpt
                              FROM nm_asset_locations nal,
                                   nm_locations_all m,
                                   nm_linear_types,
                                   TABLE (p_refnt_tab) t,
                                   TABLE (p_obj_types) ta
                             WHERE     nal_nit_type = ta.COLUMN_VALUE(+)
                                   --                                          NVL (ta.column_value, nal_nit_type)
                                   AND nlt_id = m.nm_nlt_id
                                   AND nm_start_date <=
                                          TO_DATE (
                                             SYS_CONTEXT ('NM3CORE',
                                                          'EFFECTIVE_DATE'),
                                             'DD-MON-YYYY')
                                   AND NVL (nm_end_date,
                                            TO_DATE ('99991231', 'YYYYMMDD')) >
                                          TO_DATE (
                                             SYS_CONTEXT ('NM3CORE',
                                                          'EFFECTIVE_DATE'),
                                             'DD-MON-YYYY')
                                   AND nal_id = nm_ne_id_in
                                   AND nm_ne_id_of = refnt
                                   AND (   (    nm_begin_mp < t.end_m + g_tol
                                            AND nm_end_mp > t.start_m - g_tol)
                                        OR (    nm_begin_mp = nm_end_mp
                                            AND nm_begin_mp BETWEEN   t.start_m
                                                                    - g_tol
                                                                AND   t.end_m
                                                                    + g_tol)
                                        OR (    t.start_m = t.end_m
                                            AND nm_begin_mp <=
                                                   t.end_m + g_tol
                                            AND nm_end_mp >=
                                                   t.start_m - g_tol))
                                   AND (       p_whole_only = 'TRUE'
                                           AND (    NOT EXISTS
                                                           (SELECT 1
                                                              FROM nm_asset_locations nal1,
                                                                   nm_locations l
                                                             WHERE     nal1.nal_nit_type =
                                                                          nal.nal_nit_type
                                                                   AND nal1.nal_asset_id =
                                                                          nal.nal_asset_id
                                                                   AND nm_ne_id_in =
                                                                          nal1.nal_id
                                                                   AND l.nm_ne_id_of NOT IN (SELECT refnt
                                                                                               FROM TABLE (
                                                                                                       p_refnt_tab)))
                                                AND NOT EXISTS
                                                           (SELECT 1
                                                              FROM nm_locations l,
                                                                   TABLE (
                                                                      p_refnt_tab)
                                                             WHERE     l.nm_ne_id_in =
                                                                          nal.nal_id
                                                                   AND nm_ne_id_in =
                                                                          m.nm_ne_id_in
                                                                   AND refnt =
                                                                          l.nm_ne_id_of
                                                                   AND (   l.nm_begin_mp <
                                                                              start_m
                                                                        OR l.nm_end_mp >
                                                                              end_m)))
                                        OR p_whole_only = 'FALSE')
                            UNION ALL
                            SELECT lb_RPt (nm_ne_id_of,
                                           nlt_id,
                                           nm_obj_type,
                                           nm_ne_id_in,
                                           nm_seg_no,
                                           nm_seq_no,
                                           nm_cardinality,
                                           nm_begin_mp,
                                           nm_end_mp,
                                           nlt_units)
                              FROM nm_members m,
                                   nm_linear_types,
                                   nm_elements,
                                   TABLE (p_refnt_tab) t,
                                   TABLE (p_obj_types) ta
                             WHERE     p_lb_only = 'FALSE'
                                   AND nm_ne_id_of = ne_id
                                   AND nlt_nt_type = ne_nt_type
                                   --                                   AND nlt_g_i_d = 'D'
                                   AND nm_obj_type = ta.COLUMN_VALUE(+)
                                   --                                          NVL (ta.column_value, nm_obj_type)
                                   AND nm_ne_id_of = refnt
                                   AND (   (    nm_begin_mp < t.end_m
                                            AND nm_end_mp > t.start_m)
                                        OR (    nm_begin_mp = nm_end_mp
                                            AND nm_begin_mp BETWEEN   t.start_m
                                                                    - g_tol
                                                                AND   t.end_m
                                                                    + g_tol)
                                        OR (    t.start_m = t.end_m
                                            AND nm_begin_mp <=
                                                   t.end_m + g_tol
                                            AND nm_end_mp >=
                                                   t.start_m - g_tol))
                                   AND (       p_whole_only = 'TRUE'
                                           AND (    NOT EXISTS
                                                           (SELECT 1
                                                              FROM nm_members l
                                                             WHERE     nm_ne_id_in =
                                                                          m.nm_ne_id_in
                                                                   AND l.nm_ne_id_of NOT IN (SELECT refnt
                                                                                               FROM TABLE (
                                                                                                       p_refnt_tab)))
                                                AND NOT EXISTS
                                                           (SELECT 1
                                                              FROM nm_members l,
                                                                   TABLE (
                                                                      p_refnt_tab)
                                                             WHERE     nm_ne_id_in =
                                                                          m.nm_ne_id_in
                                                                   AND refnt =
                                                                          l.nm_ne_id_of
                                                                   AND (   l.nm_begin_mp <
                                                                              start_m
                                                                        OR l.nm_end_mp >
                                                                              end_m)))
                                        OR p_whole_only = 'FALSE')));
         ELSIF p_intsct = 'FALSE'
         THEN
            --                               SELECT lb_ops.rpt_intersection( rpt_tab, p_refnt_tab, 20)
            --                into retval from ( select cast( collect (rpt ) as lb_rpt_tab ) rpt_tab
            SELECT CAST (COLLECT (rpt) AS lb_rpt_tab) rpt_tab
              INTO retval
              FROM (SELECT lb_RPt (nm_ne_id_of,
                                   nlt_id,
                                   nm_obj_type,
                                   nm_ne_id_in,
                                   nm_seg_no,
                                   nm_seq_no,
                                   nm_dir_flag,
                                   nm_begin_mp,
                                   nm_end_mp,
                                   nlt_units)
                              rpt
                      FROM nm_asset_locations nal,
                           nm_locations_all m,
                           nm_linear_types,
                           TABLE (p_obj_types) ta
                     WHERE     nal_nit_type = ta.COLUMN_VALUE(+)
                           AND nlt_id = m.nm_nlt_id
                           --                           AND nlt_g_i_d = 'D'
                           AND nm_start_date <=
                                  TO_DATE (
                                     SYS_CONTEXT ('NM3CORE',
                                                  'EFFECTIVE_DATE'),
                                     'DD-MON-YYYY')
                           AND NVL (nm_end_date,
                                    TO_DATE ('99991231', 'YYYYMMDD')) >
                                  TO_DATE (
                                     SYS_CONTEXT ('NM3CORE',
                                                  'EFFECTIVE_DATE'),
                                     'DD-MON-YYYY')
                           AND nal_id = nm_ne_id_in
                           AND nm_ne_id_in IN (SELECT nm_ne_id_in
                                                 FROM nm_locations c,
                                                      TABLE (p_refnt_tab) t
                                                WHERE     c.nm_ne_id_of =
                                                             refnt
                                                      --                                               AND c.nm_ne_id_in =
                                                      --                                                   m.nm_ne_id_in
                                                      --and NVL (p_obj_type, c.nm_obj_type) = c.nm_obj_type
                                                      AND (   (    c.nm_begin_mp <
                                                                      t.end_m
                                                               AND c.nm_end_mp >
                                                                      t.start_m)
                                                           OR (    c.nm_begin_mp =
                                                                      nm_end_mp
                                                               AND c.nm_begin_mp BETWEEN   t.start_m
                                                                                         - g_tol
                                                                                     AND   t.end_m
                                                                                         + g_tol)
                                                           OR (    t.start_m
                                                                      IS NULL
                                                               AND t.end_m
                                                                      IS NULL)
                                                           OR (    t.start_m =
                                                                      t.end_m
                                                               AND nm_begin_mp <=
                                                                        t.end_m
                                                                      + g_tol
                                                               AND nm_end_mp >=
                                                                        t.start_m
                                                                      - g_tol)))
                           AND (       p_whole_only = 'TRUE'
                                   AND (    NOT EXISTS
                                                   (SELECT 1
                                                      FROM nm_asset_locations nal1,
                                                           nm_locations l
                                                     WHERE     nal1.nal_nit_type =
                                                                  nal.nal_nit_type
                                                           AND nal1.nal_asset_id =
                                                                  nal.nal_asset_id
                                                           AND nm_ne_id_in =
                                                                  nal1.nal_id
                                                           AND l.nm_ne_id_of NOT IN (SELECT refnt
                                                                                       FROM TABLE (
                                                                                               p_refnt_tab)))
                                        AND NOT EXISTS
                                                   (SELECT 1
                                                      FROM nm_locations l,
                                                           TABLE (
                                                              p_refnt_tab)
                                                     WHERE     l.nm_ne_id_in =
                                                                  nal.nal_id
                                                           AND nm_ne_id_in =
                                                                  m.nm_ne_id_in
                                                           AND refnt =
                                                                  l.nm_ne_id_of
                                                           AND (   l.nm_begin_mp <
                                                                      start_m
                                                                OR l.nm_end_mp >
                                                                      end_m)))
                                OR p_whole_only = 'FALSE')
                    UNION ALL
                    SELECT lb_RPt (nm_ne_id_of,
                                   nlt_id,
                                   nm_obj_type,
                                   nm_ne_id_in,
                                   nm_seg_no,
                                   nm_seq_no,
                                   nm_cardinality,
                                   nm_begin_mp,
                                   nm_end_mp,
                                   nlt_units)
                      FROM nm_members m,
                           nm_linear_types,
                           nm_elements,
                           TABLE (p_obj_types) ta
                     WHERE     p_lb_only = 'FALSE'
                           AND nlt_nt_type = ne_nt_type
                           AND nm_ne_id_of = ne_id
                           --                           AND nlt_g_i_d = 'D'
                           AND nm_obj_type = ta.COLUMN_VALUE(+)
                           AND nm_ne_id_in IN (SELECT c.nm_ne_id_in
                                                 FROM nm_members c,
                                                      TABLE (p_refnt_tab) t
                                                WHERE     c.nm_ne_id_of =
                                                             refnt
                                                      --                                               AND c.nm_ne_id_in =
                                                      --                                                   m.nm_ne_id_in
                                                      --                               AND nm_obj_type =
                                                      --                                   NVL (p_obj_type, nm_obj_type)
                                                      AND (   (    c.nm_begin_mp <
                                                                      t.end_m
                                                               AND c.nm_end_mp >
                                                                      t.start_m)
                                                           OR (    c.nm_begin_mp =
                                                                      nm_end_mp
                                                               AND c.nm_begin_mp BETWEEN t.start_m
                                                                                     AND t.end_m)))
                           AND (       p_whole_only = 'TRUE'
                                   AND (    NOT EXISTS
                                                   (SELECT 1
                                                      FROM nm_members l
                                                     WHERE     nm_ne_id_in =
                                                                  m.nm_ne_id_in
                                                           AND l.nm_ne_id_of NOT IN (SELECT refnt
                                                                                       FROM TABLE (
                                                                                               p_refnt_tab)))
                                        AND NOT EXISTS
                                                   (SELECT 1
                                                      FROM nm_members l,
                                                           TABLE (
                                                              p_refnt_tab)
                                                     WHERE     nm_ne_id_in =
                                                                  m.nm_ne_id_in
                                                           AND refnt =
                                                                  l.nm_ne_id_of
                                                           AND (   l.nm_begin_mp <
                                                                      start_m
                                                                OR l.nm_end_mp >
                                                                      end_m)))
                                OR p_whole_only = 'FALSE'));
         END IF;                                -- end p_refnt_tab is not null
      --        ELSIF p_obj_id IS NOT NULL
      --        THEN
      --        nm_debug.debug('By obj_id ');
      --            retval := get_obj_id_as_rpt_tab (p_obj_id, p_obj_type);
      ELSE
         IF p_whole_only = 'TRUE' OR p_intsct = 'TRUE'
         THEN
            raise_application_error (
               -20013,
               'Use of the intersection or whole-only option is only valid when accompanied by a network reference');
         END IF;

         --
         SELECT lb_rpt (nm_ne_id_of,
                        nlt_id,
                        nm_obj_type,
                        nm_ne_id_in,
                        nm_seg_no,
                        nm_seq_no,
                        nm_cardinality,
                        nm_begin_mp,
                        nm_end_mp,
                        nlt_units)
           BULK COLLECT INTO retval
           FROM nm_locations_full,
                nm_linear_types,
                nm_elements,
                TABLE (p_obj_types) ta
          WHERE     nm_obj_type = ta.COLUMN_VALUE(+)
                AND ne_id = nm_ne_id_of
                AND ne_nt_type = nlt_nt_type
                AND NVL (ne_gty_group_type, '¿$%^') =
                       NVL (nlt_gty_type, '¿$%^');
      -- just based on type
      END IF;

      RETURN retval;
   END;
END;
/
