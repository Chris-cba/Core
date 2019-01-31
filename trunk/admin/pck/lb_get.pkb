CREATE OR REPLACE PACKAGE BODY lb_get
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/lb_get.pkb-arc   1.60   Jan 31 2019 16:04:24   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_get.pkb  $
   --       Date into PVCS   : $Date:   Jan 31 2019 16:04:24  $
   --       Date fetched Out : $Modtime:   Jan 30 2019 15:02:42  $
   --       PVCS Version     : $Revision:   1.60  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.60  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_get';

   g_tol                     NUMBER := 0.00000001;

   --
   FUNCTION get_refnt_RPt_tab_from_geom (
      p_geom          IN MDSYS.sdo_geometry,
      p_nlt_ids       IN int_array_type,
      p_constraint    IN VARCHAR2,
      p_mask_array    IN VARCHAR2 DEFAULT 'ANYINTERACT',
      p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab;

   FUNCTION get_FT_retrieval_str (p_obj_type   IN VARCHAR2,
                                  p_obj_id     IN INTEGER)
      RETURN VARCHAR2;

   FUNCTION get_FT_retrieval_str (p_obj_type   IN VARCHAR2,
                                  p_obj_id     IN INTEGER)
      RETURN VARCHAR2
   IS
      l_inv_on_nw_row   v_nm_inv_on_network%ROWTYPE;
   BEGIN
      SELECT *
        INTO l_inv_on_nw_row
        FROM v_nm_inv_on_network
       WHERE nit_inv_type = p_obj_type;

      --
      RETURN    l_inv_on_nw_row.rpt_string
             || ' where '
             || l_inv_on_nw_row.nit_foreign_pk_column
             || ' = :obj_id ';
   END;


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

   FUNCTION get_obj_RPt_tab (p_refnt_tab     IN lb_RPt_tab,
                             p_obj_type      IN VARCHAR2,
                             p_obj_id        IN INTEGER,
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
   BEGIN
      IF p_obj_type IS NULL
      THEN
         IF p_obj_id IS NULL
         THEN
            IF lb_ops.lb_rpt_tab_has_network (p_refnt_tab) = 'FALSE'
            THEN
               raise_application_error (
                  -20015,
                  'Inadequate input arguments to from a valid query');
            END IF;                     -- allow a query based on network only
         ELSE
            raise_application_error (
               -20016,
               'A query cannot be built on a specified ID without a type');
         END IF;
      END IF;

      BEGIN
         SELECT DECODE (nit_table_name, NULL, 'N', 'Y'), nit_category
           INTO l_ft_flag, l_category
           FROM nm_inv_types
          WHERE nit_inv_type = p_obj_type;
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
                                   TABLE (p_refnt_tab) t
                             WHERE     nal_nit_type =
                                          NVL (p_obj_type, nal_nit_type)
                                   AND nlt_id = m.nm_nlt_id
                                   AND nm_ne_id_in =
                                          NVL (p_obj_id, nm_ne_id_in)
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
                                   TABLE (p_refnt_tab) t
                             WHERE     p_lb_only = 'FALSE'
                                   AND nm_ne_id_of = ne_id
                                   AND nlt_nt_type = ne_nt_type
                                   AND nlt_g_i_d = 'D'
                                   AND nm_obj_type =
                                          NVL (p_obj_type, nm_obj_type)
                                   AND nm_ne_id_in =
                                          NVL (p_obj_id, nm_ne_id_in)
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
                           nm_linear_types
                     WHERE     nal_nit_type || '' =
                                  NVL (p_obj_type, nal_nit_type)
                           AND nlt_id = m.nm_nlt_id
                           AND nlt_g_i_d = 'D'
                           AND nm_ne_id_in + 0 = NVL (p_obj_id, nm_ne_id_in)
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
                      FROM nm_members m, nm_linear_types, nm_elements
                     WHERE     p_lb_only = 'FALSE'
                           AND nlt_nt_type = ne_nt_type
                           AND nm_ne_id_of = ne_id
                           AND nlt_g_i_d = 'D'
                           AND nm_obj_type || '' =
                                  NVL (p_obj_type, nm_obj_type)
                           AND nm_ne_id_in + 0 = NVL (p_obj_id, nm_ne_id_in)
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
           FROM nm_locations_full, nm_linear_types, nm_elements
          WHERE     nm_obj_type = p_obj_type
                AND ne_id = nm_ne_id_of
                AND ne_nt_type = nlt_nt_type
                AND NVL (ne_gty_group_type, '¿$%^') =
                       NVL (nlt_gty_type, '¿$%^');
      -- just based on type
      END IF;

      RETURN retval;
   END;

   --
   FUNCTION get_refnt_RPt_tab_from_geom (
      p_geom          IN MDSYS.sdo_geometry,
      p_theme_id      IN nm_themes_all.nth_theme_id%TYPE,
      p_mask_array    IN VARCHAR2 := 'ANYINTERACT',
      p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      --
      retval   lb_RPt_tab;
      qq       CHAR (1) := CHR (39);
      nth      nm_themes_all%ROWTYPE := nm3get.get_nth (p_theme_id);
      lstr     VARCHAR2 (2000);
   --
   BEGIN
      lstr :=
            'select  /*+INDEX (e, NE_PK) */ lb_RPt( e.ne_id, nlt_id, null, null, null, null, 1, start_m, end_m, nlt_units ) '
         || ' from ( '
         || ' select /*+materialize */ '
         || nth.nth_pk_column
         || ', sdo_lrs.geom_segment_start_measure('
         || nth.nth_feature_shape_column
         || ') start_m, '
         || ' sdo_lrs.geom_segment_end_measure('
         || nth.nth_feature_shape_column
         || ') end_m '
         || ' from '
         || nth.nth_feature_table
         || '  where sdo_relate( '
         || nth.nth_feature_shape_column
         || ', :geom, '
         || qq
         || ' mask=anyinteract'
         || qq
         || ') = '
         || qq
         || 'TRUE'
         || qq
         || ' ) a, nm_linear_types, nm_elements e '
         || '   where a.'
         || nth.nth_feature_pk_column
         || ' = e.ne_id and nlt_nt_type = e.ne_nt_type ';

      nm_debug.debug_on;
      nm_debug.debug (lstr);

      EXECUTE IMMEDIATE lstr BULK COLLECT INTO retval USING p_geom;         --

      RETURN retval;
   --
   END;

   FUNCTION get_refnt_RPt_tab_from_geom (
      p_geom          IN MDSYS.sdo_geometry,
      p_inv_type      IN lb_types.lb_exor_inv_type%TYPE,
      p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      --
      retval      lb_RPt_tab;
      l_nlt_ids   int_array_type := nm3array.init_int_array ().ia;
   BEGIN
      IF p_inv_type IS NOT NULL
      THEN
         SELECT CAST (COLLECT (nlt_id) AS int_array_type)
           INTO l_nlt_ids
           FROM nm_linear_types, nm_inv_nw
          WHERE nlt_nt_type = nin_nw_type AND nin_nit_inv_code = p_inv_type;
      ELSE
         SELECT CAST (COLLECT (nlt_id) AS int_array_type)
           INTO l_nlt_ids
           FROM nm_linear_types
          WHERE nlt_gty_type IS NULL;
      END IF;

      --
      return get_refnt_RPt_tab_from_geom (
                p_geom          => p_geom,
                p_nlt_ids       => l_nlt_ids,
                p_constraint    => lb_nw_cons.get_aggr_constraint (p_inv_type),
                p_mask_array    => 'ANYINTERACT',
                p_cardinality   => 100);
                
                      
   END;

   FUNCTION get_refnt_RPt_tab_from_geom (
      p_geom          IN MDSYS.sdo_geometry,
      p_nlt_ids       IN int_array_type,
      p_constraint    IN VARCHAR2,
      p_mask_array    IN VARCHAR2 DEFAULT 'ANYINTERACT',
      p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      --
      retval         lb_RPt_tab;
      qq             CHAR (1) := CHR (39);
      --      nth      nm_themes_all%ROWTYPE := nm3get.get_nth (p_theme_id);
      lstr           VARCHAR2 (4000);
      --      p_intersect varchar2(1) := 'N';
      nlt_is_empty   VARCHAR2 (1);
   --
   BEGIN
      IF int_array (p_nlt_ids).is_empty
      THEN
         raise_application_error (
            -20010,
            'No network type has been supplied in call to geenrate a spatial intersection');
      END IF;

nm_debug.debug('cons = '||p_constraint);

      SELECT    'with geom_tab as ( select :geom geoloc from dual ) '
             || ' select cast (collect( lb_rpt( ne_id, nlt_id, NULL, ne_id, 1, 1, 1, 0, ne_length, nlt_units)) as lb_rpt_tab )'
             || ' from ( select /*+INDEX(e NE_PK) */ e.ne_id, e.ne_length, nlt_id, nlt_units, shape '
             || CHR (10)
             || 'from ( Select /*+MATERIALIZE*/ * from ('
             || CHR (10)
             || LISTAGG (select_string, CHR (10) || 'UNION ALL' || CHR (10))
                   WITHIN GROUP (ORDER BY nlt_id)
             || CHR (10)
             || ')) s, nm_elements e where e.ne_id = s.ne_id and '||p_constraint||')'
                aggr_str
        INTO lstr
        FROM (SELECT nlt_id, nlt_units, select_string
                FROM (SELECT nlt_id,
                             nlt_units,
                                'select '
                             || nlt_id
                             || ' nlt_id, '
                             || nlt_units
                             || ' nlt_units, '
                             || pk
                             || ' NE_ID, '
                             || 'f.'
                             || shape
                             || ' SHAPE '
                             || 'from '
                             || feat_tab
                             || ' f, geom_tab g where sdo_relate(f.'
                             || shape
                             || ', g.geoloc, '
                             || ''''
                             || 'mask=ANYINTERACT'
                             || ''''
                             || ' ) = '
                             || ''''
                             || 'TRUE'
                             || ''''
                                select_string
                        FROM (SELECT nlt_id,
                                     nlt_units,
                                     nth_feature_pk_column pk,
                                     nth_feature_shape_column shape,
                                     nth_feature_table feat_tab
                                FROM v_nm_datum_themes
                               --                               WHERE
                               --                               nlt_id IN (SELECT COLUMN_VALUE
                               --                                                  FROM TABLE (p_nlt_ids)))));
                               --                                     OR nlt_is_empty = 'Y')));
                               WHERE nlt_id IN (SELECT COLUMN_VALUE
                                                  FROM TABLE (p_nlt_ids)))));

      --                                     OR nlt_is_empty = 'Y')));



      nm_debug.debug_on;
      nm_debug.debug (lstr);

      EXECUTE IMMEDIATE lstr INTO retval USING p_geom;

      RETURN retval;
   --
   END;

   FUNCTION get_refnt_RPt_tab_from_nspe (
      p_nspe_id       IN INTEGER,
      p_theme_id      IN nm_themes_all.nth_theme_id%TYPE,
      p_mask_array    IN VARCHAR2 := 'ANYINTERACT',
      p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      --
      retval   lb_RPt_tab;
      qq       CHAR (1) := CHR (39);
      nth      nm_themes_all%ROWTYPE := nm3get.get_nth (p_theme_id);
      lstr     VARCHAR2 (2000);
   --
   BEGIN
      lstr :=
            'select /*+INDEX (e, NE_PK) */ lb_RPt( e.ne_id, nlt_id, null, null, null, null, 1, start_m, end_m, nlt_units ) '
         || ' from ( '
         || ' select /*+materialize */ '
         || nth.nth_pk_column
         || ' ne_id, sdo_lrs.geom_segment_start_measure(shape) start_m, sdo_lrs.geom_segment_end_measure(shape) end_m '
         || ' from '
         || nth.nth_feature_table
         || ', nm_spatial_extents x '
         || '  where sdo_relate( '
         || nth.nth_feature_shape_column
         || ', x.nspe_boundary, '
         || qq
         || ' mask=anyinteract'
         || qq
         || ') = '
         || qq
         || 'TRUE'
         || qq
         || ' and x.nspe_id = :nspe_id '
         || ' ) a, nm_linear_types, nm_elements e '
         || '   where a.ne_id'
         || ' = e.ne_id and nlt_nt_type = e.ne_nt_type ';

      nm_debug.debug_on;
      nm_debug.debug (lstr);

      EXECUTE IMMEDIATE lstr BULK COLLECT INTO retval USING p_nspe_id;      --

      RETURN retval;
   --
   END;


   FUNCTION get_lb_RPt_geom_tab_from_geom (
      p_geom         IN MDSYS.sdo_geometry,
      p_theme_id     IN nm_themes_all.nth_theme_id%TYPE,
      p_mask_array      VARCHAR2 := 'coveredby+inside+anyinteract')
      RETURN lb_RPt_geom_tab
   IS
      --
      retval   lb_RPt_geom_tab;
      qq       CHAR (1) := CHR (39);
      nth      nm_themes_all%ROWTYPE := nm3get.get_nth (p_theme_id);
      lstr     VARCHAR2 (2000);
   --
   BEGIN
      lstr :=
            'select  /*+INDEX (e, NE_PK) */ lb_RPt_geom( e.ne_id, nlt_id, null, null, null, null, 1, start_m, end_m, nlt_units, '
         || nth.nth_feature_shape_column
         || ' ) '
         || ' from ( '
         || ' select /*+MATERIALIZE*/ '
         || nth.nth_pk_column
         || ', sdo_lrs.geom_segment_start_measure('
         || nth.nth_feature_shape_column
         || ') start_m, '
         || '       sdo_lrs.geom_segment_end_measure('
         || nth.nth_feature_shape_column
         || ') end_m, '
         || nth.nth_feature_shape_column
         || ' from '
         || nth.nth_feature_table
         || '  where sdo_relate( '
         || nth.nth_feature_shape_column
         || ', :geom, '
         || qq
         || ' mask=anyinteract'
         || qq
         || ') = '
         || qq
         || 'TRUE'
         || qq
         || ' ) a, nm_linear_types, nm_elements e '
         || '   where a.'
         || nth.nth_feature_pk_column
         || ' = e.ne_id and nlt_nt_type = e.ne_nt_type ';

      nm_debug.debug_on;
      nm_debug.debug (lstr);

      EXECUTE IMMEDIATE lstr BULK COLLECT INTO retval USING p_geom;         --

      RETURN retval;
   --
   END;

   FUNCTION get_RPT_geom_tab_from_RPt (p_rpt_tab IN lb_RPt_tab)
      RETURN lb_RPt_geom_tab
   IS
      retval    lb_RPt_geom_tab;
      cur_str   VARCHAR2 (4000);
      l_str     VARCHAR2 (2000);
   BEGIN
      SELECT LISTAGG (case_stmt, ' ' || CHR (10))
                WITHIN GROUP (ORDER BY nlt_id)
        INTO l_str
        FROM (SELECT nlt_id,
                     nlt_nt_type,
                     nlt_gty_type,
                     nth_theme_id,
                     nth_feature_table,
                     nth_feature_shape_column,
                     nth_feature_pk_column,
                        '         when '
                     || nlt_id
                     || ' then (select sdo_lrs.clip_geom_segment('
                     || nth_feature_shape_column
                     || ', start_m, end_m, 0.005 ) from '
                     || nth_feature_table
                     || ' s where s.'
                     || nth_feature_pk_column
                     || ' = refnt ) '
                        case_stmt
                FROM nm_nw_themes, nm_themes_all, nm_linear_types
               WHERE     nth_theme_id = nnth_nth_theme_id
                     AND nlt_id = nnth_nlt_id
                     AND nth_base_table_theme IS NOT NULL
                     AND nth_feature_table NOT LIKE '%DT');

      --
      cur_str :=
            'select lb_RPt_geom( refnt, refnt_type, obj_type, obj_id, seg_id, seq_id, dir_flag, start_m, end_m, m_unit, geoloc ) '
         || ' from ( '
         || 'select refnt, refnt_type, obj_type, obj_id, seg_id, seq_id, dir_flag, start_m, end_m, m_unit, '
         || ' case refnt_type '
         || l_str
         || CHR (13)
         || '    end geoloc '
         || ' from table (:p_d_rpt_tab) t ) ';

      --
      nm_debug.debug_on;
      nm_debug.debug (cur_str);

      EXECUTE IMMEDIATE cur_str BULK COLLECT INTO retval USING p_rpt_tab;

      RETURN retval;
   END;

   FUNCTION get_x_RPt_tab_from_geom (
      p_geom         IN MDSYS.sdo_geometry,
      p_theme_id     IN nm_themes_all.nth_theme_id%TYPE,
      p_mask_array      VARCHAR2 := 'coveredby+inside+anyinteract')
      RETURN lb_RPt_tab
   IS
      --
      retval   lb_RPt_tab;
      qq       CHAR (1) := CHR (39);
      nth      nm_themes_all%ROWTYPE := nm3get.get_nth (p_theme_id);
      lstr     VARCHAR2 (2000);
   --
   BEGIN
      lstr :=
            'select lb_RPt( e.ne_id, nlt_id, null, null, null, null, 1, start_m, end_m, nlt_units ) from '
         || ' (select '
         || nth.nth_feature_pk_column
         || ', sdo_lrs.geom_segment_start_measure(sdo_intsct) start_m, sdo_lrs.geom_segment_end_measure(sdo_intsct) end_m from (
       select ne_id, SDO_LRS.LRS_INTERSECTION('
         || nth.nth_feature_shape_column
         || ', :geom, 0.005) sdo_intsct '
         || 'from '
         || nth.nth_feature_table
         || ' where sdo_relate('
         || nth.nth_feature_shape_column
         || ', :geom, '
         || qq
         || 'mask='
         || p_mask_array
         || qq
         || ') = '
         || qq
         || 'TRUE'
         || qq
         || ')'
         || ' where sdo_intsct is not null'
         || ' )a, nm_linear_types, nm_elements e '
         || '  where a.ne_id = e.ne_id and nlt_nt_type = e.ne_nt_type ';

      nm_debug.debug_on;
      nm_debug.debug (lstr);

      EXECUTE IMMEDIATE lstr BULK COLLECT INTO retval USING p_geom, p_geom;

      --
      RETURN retval;
   --
   END;

   FUNCTION get_x_RPt_geom_tab_from_geom (
      p_geom         IN MDSYS.sdo_geometry,
      p_theme_id     IN nm_themes_all.nth_theme_id%TYPE,
      p_mask_array      VARCHAR2 := 'coveredby+inside+anyinteract')
      RETURN lb_RPt_geom_tab
   IS
      --
      retval   lb_RPt_geom_tab;
      qq       CHAR (1) := CHR (39);
      nth      nm_themes_all%ROWTYPE := nm3get.get_nth (p_theme_id);
      lstr     VARCHAR2 (2000);
   --
   BEGIN
      lstr :=
            'select lb_RPt_geom( e.ne_id, nlt_id, null, null, null, null, 1, start_m, end_m, nlt_units, sdo_intsct ) from '
         || ' (select '
         || nth.nth_feature_pk_column
         || ', sdo_lrs.geom_segment_start_measure(sdo_intsct) start_m, sdo_lrs.geom_segment_end_measure(sdo_intsct) end_m, sdo_intsct from (
       select ne_id, SDO_LRS.LRS_INTERSECTION('
         || nth.nth_feature_shape_column
         || ', :geom, 0.005) sdo_intsct '
         || 'from '
         || nth.nth_feature_table
         || ' where sdo_relate('
         || nth.nth_feature_shape_column
         || ', :geom, '
         || qq
         || 'mask='
         || p_mask_array
         || qq
         || ') = '
         || qq
         || 'TRUE'
         || qq
         || ')'
         || ' where sdo_intsct is not null'
         || ' )a, nm_linear_types, nm_elements e '
         || '  where a.ne_id = e.ne_id and nlt_nt_type = e.ne_nt_type ';

      nm_debug.debug_on;
      nm_debug.debug (lstr);

      EXECUTE IMMEDIATE lstr BULK COLLECT INTO retval USING p_geom, p_geom;

      --
      RETURN retval;
   --
   END;

   FUNCTION get_obj_ids_at_loc (pi_rpt_tab     IN lb_rpt_tab,
                                pi_obj_type    IN VARCHAR2,
                                p_lb_only      IN VARCHAR2 DEFAULT 'FALSE',
                                p_whole_only   IN VARCHAR2 DEFAULT 'FALSE',
                                CARDINALITY    IN INTEGER)
      RETURN lb_obj_id_tab
   IS
      retval   lb_obj_id_tab;
   BEGIN
        SELECT lb_obj_id (nm_obj_type, nm_ne_id_in)
          BULK COLLECT INTO retval
          FROM (SELECT nm_ne_id_in, nm_obj_type
                  FROM nm_locations m, TABLE (pi_rpt_tab) t
                 WHERE     nm_obj_type = NVL (pi_obj_type, nm_obj_type)
                       AND nm_ne_id_of = refnt
                       AND (   (nm_begin_mp < t.end_m AND nm_end_mp > t.start_m)
                            OR (    t.start_m = t.end_m
                                AND (   nm_begin_mp = t.start_m
                                     OR nm_end_mp = t.end_m))
                            OR (    nm_begin_mp = nm_end_mp
                                AND nm_begin_mp BETWEEN t.start_m AND t.end_m))
                       AND (       p_whole_only = 'TRUE'
                               AND (    NOT EXISTS
                                               (SELECT 1
                                                  FROM nm_locations l
                                                 WHERE     nm_ne_id_in =
                                                              m.nm_ne_id_in
                                                       AND l.nm_ne_id_of NOT IN (SELECT refnt
                                                                                   FROM TABLE (
                                                                                           pi_rpt_tab)))
                                    AND NOT EXISTS
                                               (SELECT 1
                                                  FROM nm_locations l,
                                                       TABLE (pi_rpt_tab)
                                                 WHERE     nm_ne_id_in =
                                                              m.nm_ne_id_in
                                                       AND refnt =
                                                              l.nm_ne_id_of
                                                       AND (   l.nm_begin_mp <
                                                                  start_m
                                                            OR l.nm_end_mp >
                                                                  end_m)))
                            OR p_whole_only = 'FALSE')
                UNION ALL
                SELECT nm_ne_id_in, nm_obj_type
                  FROM nm_members m, TABLE (pi_rpt_tab) t
                 WHERE     p_lb_only = 'FALSE'
                       AND nm_obj_type = NVL (pi_obj_type, nm_obj_type)
                       AND nm_ne_id_of = refnt
                       AND (   (nm_begin_mp < t.end_m AND nm_end_mp > t.start_m)
                            OR (    t.start_m = t.end_m
                                AND (   nm_begin_mp = t.start_m
                                     OR nm_end_mp = t.start_m))
                            OR (    nm_begin_mp = nm_end_mp
                                AND nm_begin_mp BETWEEN t.start_m AND t.end_m))
                       AND (       p_whole_only = 'TRUE'
                               AND (    NOT EXISTS
                                               (SELECT 1
                                                  FROM nm_locations l
                                                 WHERE     nm_ne_id_in =
                                                              m.nm_ne_id_in
                                                       AND l.nm_ne_id_of NOT IN (SELECT refnt
                                                                                   FROM TABLE (
                                                                                           pi_rpt_tab)))
                                    AND NOT EXISTS
                                               (SELECT 1
                                                  FROM nm_locations l,
                                                       TABLE (pi_rpt_tab)
                                                 WHERE     nm_ne_id_in =
                                                              m.nm_ne_id_in
                                                       AND refnt =
                                                              l.nm_ne_id_of
                                                       AND (   l.nm_begin_mp <
                                                                  start_m
                                                            OR l.nm_end_mp >
                                                                  end_m)))
                            OR p_whole_only = 'FALSE'))
      GROUP BY nm_ne_id_in, nm_obj_type;

      RETURN retval;
   END;

   --
   FUNCTION get_obj_ids_at_loc (pi_ne_id      IN INTEGER,
                                pi_begin_mp      NUMBER,
                                pi_end_mp        NUMBER)
      RETURN lb_obj_id_tab
   IS
      p_ty_type    NM3TYPE.TAB_VARCHAR4;
      p_ty_descr   NM3TYPE.TAB_VARCHAR80;
      p_it_type    NM3TYPE.TAB_VARCHAR4;
      p_it_descr   NM3TYPE.TAB_VARCHAR80;
      p_id         NM3TYPE.TAB_NUMBER;
      retval       lb_obj_id_tab;
   BEGIN
      nm3gaz_qry.get_all_items_at_location (
         pi_ne_id                      => pi_ne_id,
         pi_nm_begin_mp                => NULL,
         pi_nm_end_mp                  => NULL,
         pi_npq_id                     => NULL,
         po_tab_item_type_type         => p_ty_type,
         po_tab_item_type_type_descr   => p_ty_descr,
         po_tab_item_type              => p_it_type,
         po_tab_item_type_descr        => p_it_descr,
         po_tab_item_id                => p_id);
      retval := lb_obj_id_tab (lb_obj_id (NULL, NULL));
      retval.EXTEND (p_id.COUNT - 1);

      FOR i IN 1 .. p_id.COUNT
      LOOP
         retval (i) := lb_obj_id (p_it_type (i), p_id (i));
      END LOOP;

      RETURN retval;
   --
   END;

   FUNCTION get_lb_RPt_tab (p_refnt         IN INTEGER,
                            p_refnt_type    IN INTEGER,
                            p_obj_type      IN VARCHAR2,
                            p_obj_id        IN INTEGER,
                            p_seg_id        IN INTEGER,
                            p_seq_id        IN INTEGER,
                            p_dir_flag      IN INTEGER,
                            p_start_m       IN NUMBER,
                            p_end_m         IN NUMBER,
                            p_intsct        IN VARCHAR DEFAULT 'FALSE',
                            p_m_unit        IN INTEGER,
                            p_lb_only       IN VARCHAR2 DEFAULT 'FALSE',
                            p_whole_only    IN VARCHAR2 DEFAULT 'FALSE',
                            p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      l_g_i_d        VARCHAR2 (1) := NULL;
      l_refnt_type   INTEGER := NULL;
      l_units        INTEGER;
      retval         lb_Rpt_tab;
      l_start_m      NUMBER;
      l_end_m        NUMBER;
      l_tol          NUMBER;

      FUNCTION get_unit_tolerance (pi_unit_id IN INTEGER)
         RETURN NUMBER
      IS
         retval   NUMBER;
      BEGIN
         retval := NM3UNIT.GET_TOL_FROM_UNIT_MASK (pi_unit_id);
         RETURN retval;
      END;
   --
   BEGIN
      IF p_refnt IS NOT NULL
      THEN
         BEGIN
            SELECT nlt_g_i_d, nlt_id, nlt_units
              INTO l_g_i_d, l_refnt_type, l_units
              FROM nm_linear_types, nm_elements
             WHERE     ne_id = p_refnt
                   -- and nlt_id = nvl(pi_refrnt_type, nlt_id)
                   AND nlt_nt_type = ne_nt_type
                   AND NVL (nlt_gty_type, '¿$%^') =
                          NVL (ne_gty_group_type, '¿$%^');
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -200011,
                  'Supplied linear element ID not found');
         END;
      ELSE
         IF p_intsct = 'TRUE' OR p_whole_only = 'TRUE'
         THEN
            raise_application_error (
               -20013,
               'Use of the intersection or whole-only option is only valid when accompanied by a network reference');
         END IF;
      END IF;

      -- dbms_output.put_line('G or D '||l_g_i_d );
      --

      IF p_refnt_type IS NOT NULL AND p_refnt_type <> l_refnt_type
      THEN
         raise_application_error (-20010,
                                  'Mismatching linear type and referent ID');
      END IF;

      IF l_g_i_d = 'D'
      THEN
         nm_debug.debug ('datum based');

         SELECT lb_get.get_obj_RPt_tab (LB_OPS.NORMALIZE_RPT_TAB (
                                           lb_rpt_tab (
                                              lb_rpt (
                                                 p_refnt,
                                                 l_refnt_type,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 1,
                                                 NVL (p_start_m, 0),
                                                 NVL (p_end_m, ne_length),
                                                 p_m_unit))),
                                        p_obj_type,
                                        p_obj_id,
                                        p_intsct,
                                        p_lb_only,
                                        p_whole_only,
                                        20)
           INTO retval
           FROM nm_elements
          WHERE ne_id = NVL (p_refnt, ne_id);
      ELSIF l_g_i_d = 'G'
      THEN
         nm_debug.debug ('route based');
         l_start_m := p_start_m;
         l_end_m := p_end_m;

         --
         IF l_start_m = l_end_m
         THEN
            g_tol := get_unit_tolerance (l_units);
            nm3ctx.set_context ('LB_TOLERANCE', TO_CHAR (g_tol));
         --              l_start_m := l_start_m - l_tol;
         --              l_end_m   := l_end_m + l_tol;
         END IF;

         SELECT get_obj_RPt_tab (get_lb_rpt_d_tab (lb_ops.normalize_rpt_tab (
                                                      lb_rpt_tab (
                                                         lb_rpt (
                                                            p_refnt,
                                                            l_refnt_type,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            1,
                                                            NVL (
                                                               l_start_m,
                                                               default_start),
                                                            NVL (l_end_m,
                                                                 default_end),
                                                            l_units)))),
                                 p_obj_type,
                                 p_obj_id,
                                 p_intsct,
                                 p_lb_only,
                                 p_whole_only,
                                 20)
           INTO retval
           FROM (  SELECT nm_ne_id_in,
                          MIN (nm_slk) default_start,
                          MAX (nm_end_slk) default_end
                     FROM nm_members
                    WHERE nm_ne_id_in = p_refnt
                 GROUP BY nm_ne_id_in);
      ELSIF p_obj_type IS NULL AND p_obj_id IS NULL
      THEN
         raise_application_error (
            -20012,
            'No network or asset data provided to form the query');
      ELSIF p_obj_id IS NOT NULL
      THEN
         nm_debug.debug ('object based');

         SELECT CAST (COLLECT (lb_rpt (refnt,
                                       refnt_type,
                                       obj_type,
                                       obj_id,
                                       seg_id,
                                       seq_id,
                                       dir_flag,
                                       start_m,
                                       end_m,
                                       m_unit)) AS lb_rpt_tab)
           INTO retval
           FROM TABLE (get_obj_id_as_rpt_tab (p_obj_id, p_obj_type)),
                nm_linear_types,
                nm_elements
          WHERE     ne_id = refnt
                AND nlt_id = refnt_type
                AND refnt_type = NVL (p_refnt_type, refnt_type)
                AND (   (    start_m = end_m
                         AND start_m <= p_end_m
                         AND end_m >= p_start_m)
                     OR (    p_start_m = p_end_m
                         AND start_m <= p_end_m
                         AND end_m >= p_start_m)
                     OR (p_start_m < end_m AND p_end_m > start_m)
                     OR (p_start_m IS NULL AND p_end_m IS NULL));
      ELSE
         nm_debug.debug ('catch-all');

         --            IF p_start_m IS NOT NULL OR p_end_m IS NOT NULL
         --            THEN
         --                raise_application_error (
         --                    -20017,
         --                    'Measure based arguments are not usable in this context');
         --            ELSE
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
           FROM nm_locations_full, nm_linear_types, nm_elements
          WHERE     nm_obj_type = p_obj_type
                AND ne_id = nm_ne_id_of
                AND ne_nt_type = nlt_nt_type
                AND NVL (ne_gty_group_type, '¿$%^') =
                       NVL (nlt_gty_type, '¿$%^')
                AND (   (    nm_begin_mp = nm_end_mp
                         AND nm_begin_mp <= p_end_m
                         AND nm_end_mp >= p_start_m)
                     OR (    p_start_m = p_end_m
                         AND nm_begin_mp <= p_end_m
                         AND nm_end_mp >= p_start_m)
                     OR (p_start_m < nm_end_mp AND p_end_m > nm_begin_mp)
                     OR (p_start_m IS NULL AND p_end_m IS NULL));
      -- just based on type
      --            END IF;
      END IF;

      RETURN retval;
   END;

   FUNCTION get_lb_RPt_tab1 (p_refnt         IN INTEGER,
                             p_refnt_type    IN INTEGER,
                             p_obj_type      IN VARCHAR2,
                             p_obj_id        IN INTEGER,
                             p_seg_id        IN INTEGER,
                             p_seq_id        IN INTEGER,
                             p_dir_flag      IN INTEGER,
                             p_start_m       IN NUMBER,
                             p_end_m         IN NUMBER,
                             p_m_unit        IN INTEGER,
                             p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      retval   lb_RPt_tab;
   BEGIN
      --lb_RPt as object ( refnt integer, refnt_type integer, obj_type varchar2(4), obj_id integer, seg_id integer, seq_id integer,  start_m number, end_m number, m_unit integer )


      SELECT lb_RPt (nm_ne_id_of,
                     nlt_id,
                     nm_obj_type,
                     nm_ne_id_in,
                     nm_seg_no,
                     nm_seq_no,
                     nm_cardinality,
                     nm_begin_mp,
                     nm_end_mp,
                     nt_length_unit)
        BULK COLLECT INTO retval
        FROM nm_members,
             nm_linear_types,
             nm_elements,
             nm_types
       WHERE     nm_ne_id_of = ne_id
             AND ne_nt_type = nlt_nt_type
             AND NVL (ne_gty_group_type, '¿$%"') =
                    NVL (nlt_gty_type, '¿$%"')
             AND nt_type = ne_nt_type
             AND nlt_id = NVL (p_refnt_type, nlt_id)
             AND ne_id = NVL (p_refnt, ne_id)
             AND nm_obj_type = NVL (p_obj_type, nm_obj_type)
             AND nm_ne_id_in = NVL (p_obj_id, nm_ne_id_in)
      UNION ALL
      SELECT lb_RPt (nm_ne_id_of,
                     nlt_id,
                     nm_obj_type,
                     nm_ne_id_in,
                     nm_seg_no,
                     nm_seq_no,
                     nm_dir_flag,
                     nm_begin_mp,
                     nm_end_mp,
                     nt_length_unit)
        FROM nm_locations_all,
             nm_linear_types,
             nm_elements,
             nm_types
       WHERE     nm_ne_id_of = ne_id
             AND ne_nt_type = nlt_nt_type
             AND NVL (ne_gty_group_type, '¿$%"') =
                    NVL (nlt_gty_type, '¿$%"')
             AND nt_type = ne_nt_type
             AND nlt_id = NVL (p_refnt_type, nlt_id)
             AND ne_id = NVL (p_refnt, ne_id)
             AND nm_obj_type = NVL (p_obj_type, nm_obj_type)
             AND nm_ne_id_in = NVL (p_obj_id, nm_ne_id_in);

      --
      RETURN retval;
   END;

   --
   FUNCTION g_of_g_search (p_group_id      IN INTEGER,
                           --                           p_asset_types   IN lb_asset_type_tab,
                           p_inv_type      IN VARCHAR2 DEFAULT NULL,
                           p_LB_only       IN VARCHAR2 DEFAULT 'TRUE',
                           p_whole_only    IN VARCHAR2 DEFAULT 'FALSE',
                           p_cardinality   IN INTEGER)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   --      l_asset_count integer := p_asset_types.count;
   BEGIN
      WITH group_hierarchy (levl,
                            top_group,
                            parent_group,
                            child_group,
                            parent_type,
                            path_string,
                            nm_begin_mp,
                            nm_end_mp,
                            nm_slk,
                            nm_end_slk)
           AS (SELECT /*+materialize*/
                     1 levl,
                      nm_ne_id_in top_group,
                      nm_ne_id_in parent_group,
                      nm_ne_id_of child_group,
                      nm_obj_type parent_type,
                      TO_CHAR (nm_ne_id_in) path_string,
                      nm_begin_mp,
                      nm_end_mp,
                      nm_slk,
                      nm_end_slk
                 FROM nm_members
                WHERE nm_ne_id_in = p_group_id
               --                      TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'GROUP_ID'))
               UNION ALL
               SELECT levl + 1,
                      t.parent_group,
                      p.nm_ne_id_in,
                      p.nm_ne_id_of,
                      p.nm_obj_type,
                      t.path_string || ',' || TO_CHAR (p.nm_ne_id_in),
                      p.nm_begin_mp,
                      p.nm_end_mp,
                      p.nm_slk,
                      p.nm_end_slk
                 FROM group_hierarchy t, nm_members p
                WHERE t.child_group = p.nm_ne_id_in)
                 SEARCH DEPTH FIRST BY parent_group SET order1
                 CYCLE parent_group SET cycle TO '1' DEFAULT '0'
      --select * from group_hierarchy
      SELECT CAST (COLLECT (lb_rpt (nm_ne_id_of,
                                    nlt_id,
                                    nm_obj_type,
                                    nm_ne_id_in,
                                    nm_seg_no,
                                    nm_seq_no,
                                    nm_dir_flag,
                                    nm_begin_mp,
                                    nm_end_mp,
                                    nlt_units)) AS lb_rpt_tab)
        INTO retval
        FROM (SELECT nm_ne_id_of,
                     nlt_id,
                     nm_obj_type,
                     nm_ne_id_in,
                     nm_seg_no,
                     nm_seq_no,
                     nm_dir_flag,
                     GREATEST (m.nm_begin_mp, g.nm_begin_mp) nm_begin_mp,
                     LEAST (m.nm_end_mp, g.nm_end_mp) nm_end_mp,
                     nlt_units
                FROM group_hierarchy g,
                     nm_elements e,
                     nm_locations m,
                     nm_linear_types,
                     lb_types
               --                     TABLE (p_asset_types)
               WHERE     ne_id = m.nm_ne_id_of
                     AND g.child_group = ne_id
                     AND nlt_nt_type = ne_nt_type
                     AND nm_obj_type = NVL (p_inv_type, nm_obj_type) --asset_type --(+)
                     AND nm_obj_type = lb_exor_inv_type                  --(+)
                     --                     and nvl(lb_exor_inv_type, '¿$%^') =  case p_LB_only
                     --                                                             when 'TRUE' then lb_exor_inv_type
                     --                                                             else 'NONE'
                     --                                                             end
                     --                     and nvl(asset_type, '¿$%^') = case nvl(l_asset_count, 0)
                     --                                                             when 0 then asset_type
                     --                                                             else nm_obj_type
                     --                                                             end
                     AND (       p_whole_only = 'TRUE'
                             AND NOT EXISTS
                                        (SELECT 1
                                           FROM nm_locations l
                                          WHERE     l.nm_ne_id_in =
                                                       m.nm_ne_id_in
                                                AND l.nm_obj_type =
                                                       m.nm_obj_type
                                                AND l.nm_ne_id_of NOT IN (SELECT child_group
                                                                            FROM group_hierarchy))
                          OR p_whole_only = 'FALSE')
              UNION ALL
              SELECT nm_ne_id_of,
                     nlt_id,
                     nm_obj_type,
                     nm_ne_id_in,
                     nm_seg_no,
                     nm_seq_no,
                     nm_cardinality,
                     GREATEST (m.nm_begin_mp, g.nm_begin_mp) nm_begin_mp,
                     LEAST (m.nm_end_mp, g.nm_end_mp) nm_end_mp,
                     nlt_units
                FROM group_hierarchy g,
                     nm_elements e,
                     nm_members m,
                     nm_linear_types
               --                     TABLE (p_asset_types)
               WHERE     ne_id = m.nm_ne_id_of
                     AND g.child_group = ne_id
                     AND p_LB_only != 'TRUE'
                     AND nlt_nt_type = ne_nt_type
                     AND nm_obj_type = NVL (p_inv_type, nm_obj_type) --asset_type);
                     AND (       p_whole_only = 'TRUE'
                             AND NOT EXISTS
                                        (SELECT 1
                                           FROM nm_members l
                                          WHERE     l.nm_ne_id_in =
                                                       m.nm_ne_id_in
                                                AND l.nm_obj_type =
                                                       m.nm_obj_type
                                                AND l.nm_ne_id_of NOT IN (SELECT child_group
                                                                            FROM group_hierarchy))
                          OR p_whole_only = 'FALSE'));

      RETURN retval;
   END;

   --   FUNCTION g_of_g_search (p_group_id IN INTEGER, p_obj_type IN VARCHAR2, p_LB_only IN VARCHAR2 DEFAULT 'TRUE', p_cardinality IN INTEGER)
   --      RETURN lb_rpt_tab
   --   IS
   --      retval   lb_rpt_tab;
   --   BEGIN
   --      retval :=
   --         g_of_g_search (p_group_id,
   --                        lb_asset_type_tab (lb_asset_type (p_obj_type)), p_lb_only,
   --                        1);
   --      RETURN retval;
   --   END;


   FUNCTION get_lb_RPt_cur (p_refnt         IN INTEGER,
                            p_refnt_type    IN INTEGER,
                            p_obj_type      IN VARCHAR2,
                            p_obj_id        IN INTEGER,
                            p_seg_id        IN INTEGER,
                            p_seq_id        IN INTEGER,
                            p_dir_flag      IN INTEGER,
                            p_start_m       IN NUMBER,
                            p_end_m         IN NUMBER,
                            p_intsct        IN VARCHAR2 DEFAULT 'FALSE',
                            p_m_unit        IN INTEGER,
                            p_cardinality   IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
      l_str    VARCHAR2 (2000) := 'SELECT t.* FROM TABLE (:t1 ) t ';

      t1       lb_rpt_tab;
   BEGIN
      t1 :=
         lb_get.get_lb_RPt_tab (P_REFNT,
                                P_REFNT_TYPE,
                                P_OBJ_TYPE,
                                P_OBJ_ID,
                                P_SEG_ID,
                                P_SEQ_ID,
                                P_DIR_FLAG,
                                P_START_M,
                                P_END_M,
                                P_INTSCT,
                                P_M_UNIT,
                                'FALSE',
                                'FALSE',
                                P_CARDINALITY);

      OPEN retval FOR l_str USING t1;

      --         SELECT t.*
      --           FROM TABLE (t1 ) t;
      --
      RETURN retval;
   END;

   --
   FUNCTION get_lb_RPt_tab_from_tmp_extent (p_refnt         IN INTEGER,
                                            p_refnt_type    IN INTEGER,
                                            p_obj_type      IN VARCHAR2,
                                            p_obj_id        IN INTEGER,
                                            p_nte_job_id    IN INTEGER,
                                            p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      retval   lb_RPt_tab;
   BEGIN
      --lb_RPt as object ( refnt integer, refnt_type integer, obj_type varchar2(4), obj_id integer, seg_id integer, seq_id integer,  start_m number, end_m number, m_unit integer )


      SELECT lb_RPt (nm_ne_id_of,
                     nlt_id,
                     nm_obj_type,
                     nm_ne_id_in,
                     nm_seg_no,
                     nm_seq_no,
                     1,
                     nm_begin_mp,
                     nm_end_mp,
                     nt_length_unit)
        BULK COLLECT INTO retval
        FROM nm_members,
             nm_linear_types,
             nm_elements,
             nm_types,
             nm_nw_temp_extents
       WHERE     nte_job_id = p_nte_job_id
             AND nm_ne_id_of = ne_id
             AND nte_ne_id_of = ne_id
             AND ne_nt_type = nlt_nt_type
             AND NVL (ne_gty_group_type, '¿$%"') =
                    NVL (nlt_gty_type, '¿$%"')
             AND nt_type = ne_nt_type
             AND nlt_id = NVL (p_refnt_type, nlt_id)
             AND ne_id = NVL (p_refnt, ne_id)
             AND nm_obj_type = NVL (p_obj_type, nm_obj_type)
             AND nm_ne_id_in = NVL (p_obj_id, nm_ne_id_in)
             AND (   (nm_begin_mp < nte_end_mp AND nm_end_mp > nte_begin_mp)
                  OR (    nm_begin_mp = nm_end_mp
                      AND nm_begin_mp BETWEEN nte_begin_mp AND nte_end_mp));

      --
      RETURN retval;
   END;

   --
   FUNCTION get_lb_RPt_r_tab (p_lb_RPt_tab        IN lb_RPt_tab,
                              p_linear_obj_type   IN VARCHAR2,
                              p_cardinality       IN INTEGER DEFAULT NULL)
      RETURN lb_RPt_tab
   IS
      retval         lb_RPt_tab;
      l_refnt_type   nm_linear_types%ROWTYPE;
      l_round        INTEGER;
   BEGIN
      SELECT *
        INTO l_refnt_type
        FROM nm_linear_types
       WHERE nlt_g_i_d = 'G' AND nlt_gty_type = p_linear_obj_type;

      SELECT CASE INSTR (un_format_mask, '.')
                WHEN 0
                THEN
                   0
                ELSE
                   NVL (
                      LENGTH (
                         SUBSTR (un_format_mask,
                                 INSTR (un_format_mask, '.') + 1)),
                      0)
             END
        INTO l_round
        FROM nm_units
       WHERE un_unit_id = l_refnt_type.nlt_units;

      --
      -- just going up the hierarchy to aggregate the data according to linear type

      WITH itab
           AS (SELECT t.*
                 FROM TABLE (lb_ops.normalize_rpt_tab (p_lb_RPt_tab)) t)
      SELECT lb_RPt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     ROWNUM,
                     1,                                        --relative_dir,
                     start_m,
                     end_m,
                     unit_m)
        BULK COLLECT INTO retval
        FROM (  SELECT route_id refnt,
                       l_refnt_type.nlt_id refnt_type,
                       inv_type obj_type,
                       inv_id obj_id,
                       inv_segment_id seg_id,
                       --                       ROUND (INV_START_SLK, l_round) start_m,
                       --                       ROUND (inv_end_slk, l_round) end_m,
                       INV_START_SLK start_m,
                       inv_end_slk end_m,
                       l_refnt_type.nlt_units unit_m,
                       min_seq_id,
                       1                                        --relative_dir
                  FROM (SELECT route_id,
                               l.inv_id,
                               l.inv_segment_id,
                               inv_type,
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
                               datum_unit,
                               min_seq_id,
                               relative_dir
                          FROM (SELECT k.*,
                                         --sum( conn_flag ) over (order by nm_seg_no, nm_seq_no rows between unbounded preceding and current row ) as segment_id,
                                         SUM (
                                            inv_conn_flag)
                                         OVER (
                                            PARTITION BY route_id, inv_id
                                            ORDER BY
                                               nm_seg_no, nm_seq_no, nm_slk
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                             PARTITION BY route_id,
                                                                          inv_id
                                                             ORDER BY
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                             PARTITION BY route_id,
                                                                          inv_id
                                                             ORDER BY
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                             PARTITION BY route_id,
                                                                          inv_id
                                                             ORDER BY
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                             PARTITION BY route_id,
                                                                          inv_id
                                                             ORDER BY
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                             PARTITION BY route_id,
                                                                          inv_id
                                                             ORDER BY
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                             PARTITION BY route_id,
                                                                          inv_id
                                                             ORDER BY
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
                                                                datum_id,
                                                                datum_st * dir,
                                                                datum_end * dir),
                                                          ce)
                                                          inv_prior_datum_st,
                                                       MIN (
                                                          seq_id)
                                                       OVER (
                                                          PARTITION BY route_id)
                                                          min_seq_id
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
                                                                           datum_end,
                                                                        itab.m_unit
                                                                           datum_unit,
                                                                        itab.seq_id,
                                                                        itab.dir_flag,
                                                                        MAX (
                                                                           itab.seq_id)
                                                                        OVER (
                                                                           PARTITION BY obj_id)
                                                                           max_seq
                                                                   FROM itab) --nm_members where nm_ne_id_of in ( select nm_ne_id_of from nm_members c where c.nm_ne_id_in = 1887))
                                                          SELECT i.*,
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
                                                                   m.nm_cardinality
                                                                 * i.dir_flag
                                                                    relative_dir,
                                                                 DECODE (
                                                                    ne_sub_class,
                                                                    'S', 'S/L',
                                                                    'L', 'S/L',
                                                                    'R')
                                                                    sc,
                                                                 --                                                              DECODE (datum_st,
                                                                 --                                                                      0, 0,
                                                                 --                                                                      0) --1)
                                                                 --                                                                 cs,
                                                                 --                                                              DECODE (
                                                                 --                                                                 datum_end,
                                                                 --                                                                 ne_length, 0,
                                                                 --                                                                 0) --1)
                                                                 --                                                                 ce,
                                                                 CASE seq_id
                                                                    WHEN 1
                                                                    THEN
                                                                       0
                                                                    ELSE
                                                                       CASE nm_cardinality
                                                                          WHEN 1
                                                                          THEN
                                                                             CASE datum_st
                                                                                WHEN 0
                                                                                THEN
                                                                                   0
                                                                                ELSE
                                                                                   1
                                                                             END
                                                                          ELSE
                                                                             CASE datum_end
                                                                                WHEN ne_length
                                                                                THEN
                                                                                   0
                                                                                ELSE
                                                                                   1
                                                                             END
                                                                       END
                                                                 END
                                                                    cs,
                                                                 CASE seq_id
                                                                    WHEN max_seq
                                                                    THEN
                                                                       0
                                                                    ELSE
                                                                       CASE nm_cardinality
                                                                          WHEN 1
                                                                          THEN
                                                                             CASE datum_end
                                                                                WHEN ne_length
                                                                                THEN
                                                                                   0
                                                                                ELSE
                                                                                   1
                                                                             END
                                                                          ELSE
                                                                             CASE datum_st
                                                                                WHEN 0
                                                                                THEN
                                                                                   0
                                                                                ELSE
                                                                                   1
                                                                             END
                                                                       END
                                                                 END
                                                                    ce,
                                                                 DECODE (
                                                                    nm_cardinality,
                                                                    1, (  nm_slk
                                                                        +   (  GREATEST (
                                                                                  datum_st,
                                                                                  nm_begin_mp)
                                                                             - nm_begin_mp)
                                                                          * NVL (
                                                                               uc_conversion_factor,
                                                                               1)),
                                                                    -1, (  nm_slk
                                                                         +   (  nm_end_mp
                                                                              - LEAST (
                                                                                   datum_end,
                                                                                   nm_end_mp))
                                                                           * NVL (
                                                                                uc_conversion_factor,
                                                                                1)))
                                                                    start_slk,
                                                                 DECODE (
                                                                    nm_cardinality,
                                                                    1, (  nm_slk
                                                                        +   (  LEAST (
                                                                                  datum_end,
                                                                                  nm_end_mp)
                                                                             - nm_begin_mp)
                                                                          * NVL (
                                                                               uc_conversion_factor,
                                                                               1)),
                                                                    -1, (  nm_slk
                                                                         +   (  nm_end_mp
                                                                              - GREATEST (
                                                                                   datum_st,
                                                                                   nm_begin_mp))
                                                                           * NVL (
                                                                                uc_conversion_factor,
                                                                                1)))
                                                                    end_slk
                                                            FROM INV_IDS i,
                                                                 nm_members m,
                                                                 nm_elements e,
                                                                 (SELECT uc_unit_id_in,
                                                                         uc_unit_id_out,
                                                                         uc_conversion_factor
                                                                    FROM nm_unit_conversions
                                                                  UNION
                                                                  SELECT un_unit_id,
                                                                         un_unit_id,
                                                                         1
                                                                    FROM nm_units)
                                                           WHERE     nm_obj_type =
                                                                        NVL (
                                                                           p_linear_obj_type,
                                                                           nm_obj_type)
                                                                 --                                                             NVL (
                                                                 --                                                                SYS_CONTEXT (
                                                                 --                                                                   'NM3SQL',
                                                                 --                                                                   'ROUTE_OBJ_TYPE'),
                                                                 --                                                                nm_obj_type)
                                                                 --                                                      AND m.nm_type = 'G'
                                                                 AND datum_id =
                                                                        e.ne_id
                                                                 AND nm_ne_id_of =
                                                                        datum_id
                                                                 AND uc_unit_id_out =
                                                                        l_refnt_type.nlt_units
                                                                 AND uc_unit_id_in =
                                                                        i.datum_unit
                                                                 AND (   (    m.nm_begin_mp <
                                                                                 datum_end
                                                                          AND m.nm_end_mp >
                                                                                 datum_st
                                                                          AND datum_end >
                                                                                 datum_st)
                                                                      OR     m.nm_begin_mp <=
                                                                                datum_end
                                                                         AND nm_end_mp >=
                                                                                datum_st
                                                                         AND datum_st =
                                                                                datum_end)
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
                       datum_unit,
                       min_seq_id                                          --,
              --                       relative_dir
              ORDER BY min_seq_id, route_id, inv_start_slk);

      RETURN retval;
   END;



   FUNCTION get_lb_xrpt_r_tab (p_lb_XRPt_tab       IN lb_XRPt_tab,
                               p_linear_obj_type   IN VARCHAR2,
                               p_cardinality       IN INTEGER DEFAULT NULL)
      RETURN lb_XRPt_tab
   IS
      retval         lb_XRPt_tab;
      l_refnt_type   nm_linear_types%ROWTYPE;
      l_round        INTEGER;
   BEGIN
      SELECT *
        INTO l_refnt_type
        FROM nm_linear_types
       WHERE nlt_g_i_d = 'G' AND nlt_gty_type = p_linear_obj_type;

      SELECT CASE INSTR (un_format_mask, '.')
                WHEN 0
                THEN
                   0
                ELSE
                   NVL (
                      LENGTH (
                         SUBSTR (un_format_mask,
                                 INSTR (un_format_mask, '.') + 1)),
                      0)
             END
        INTO l_round
        FROM nm_units
       WHERE un_unit_id = l_refnt_type.nlt_units;

      --
      -- just going up the hierarchy to aggregate the data according to linear type
      WITH input_tab
           AS (SELECT t.*
                 FROM TABLE (lb_ops.normalize_xrpt_tab (p_lb_XRPt_tab)) t),
           itab
           AS (SELECT refnt,
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
                      end_date,
                      CASE
                         WHEN xsp IS NULL
                         THEN
                            NULL
                         ELSE
                            (SELECT NVL (
                                       (SELECT NVL (rvrs_xsp, xsp)
                                          FROM v_nm_element_xsp_rvrs r
                                         WHERE     r.xsp_element_id = refnt
                                               AND r.element_xsp = i.xsp),
                                       xsp)
                               FROM DUAL)
                      END
                         rvrs_xsp
                 FROM input_tab i)
      SELECT lb_XRPt (refnt,
                      refnt_type,
                      obj_type,
                      obj_id,
                      seg_id,
                      ROWNUM,
                      1,
                      start_m,
                      end_m,
                      unit_m,
                      new_xsp,
                      new_offset,
                      new_start_date,
                      new_end_date)
        BULK COLLECT INTO retval
        FROM (  SELECT route_id refnt,
                       l_refnt_type.nlt_id refnt_type,
                       inv_type obj_type,
                       inv_id obj_id,
                       inv_segment_id seg_id,
                       --                     ROUND (INV_START_SLK, l_round) start_m,
                       --                     ROUND (inv_end_slk, l_round) end_m,
                       INV_START_SLK start_m,
                       inv_end_slk end_m,
                       l_refnt_type.nlt_units unit_m,
                       new_xsp,
                       new_offset,
                       MIN (new_start_date) new_start_date,
                       MAX (new_end_date) new_end_date
                  FROM (SELECT route_id,
                               l.inv_id,
                               l.inv_segment_id,
                               inv_type,
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
                               datum_unit,
                               new_xsp,
                               new_offset,
                               new_start_date,
                               new_end_date
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                nm_seg_no,
                                                                nm_seq_no,
                                                                nm_slk,
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
                                                                        itab.dir_flag,
                                                                        itab.start_m
                                                                           datum_st,
                                                                        itab.end_m
                                                                           datum_end,
                                                                        itab.m_unit
                                                                           datum_unit,
                                                                        itab.xsp
                                                                           xsp,
                                                                        itab.offset,
                                                                        itab.start_date,
                                                                        itab.end_date,
                                                                        itab.rvrs_xsp
                                                                   FROM itab) --nm_members where nm_ne_id_of in ( select nm_ne_id_of from nm_members c where c.nm_ne_id_in = 1887))
                                                          SELECT i.*,
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
                                                                 --                                                              DECODE (datum_st,
                                                                 --                                                                      0, 0,
                                                                 --                                                                      0) --1)
                                                                 --                                                                 cs,
                                                                 --                                                              DECODE (
                                                                 --                                                                 datum_end,
                                                                 --                                                                 ne_length, 0,
                                                                 --                                                                 0) --1)
                                                                 --                                                                 ce,
                                                                 CASE nm_cardinality
                                                                    WHEN 1
                                                                    THEN
                                                                       CASE datum_st
                                                                          WHEN 0
                                                                          THEN
                                                                             0
                                                                          ELSE
                                                                             1
                                                                       END
                                                                    ELSE
                                                                       CASE datum_end
                                                                          WHEN ne_length
                                                                          THEN
                                                                             0
                                                                          ELSE
                                                                             1
                                                                       END
                                                                 END
                                                                    cs,
                                                                 CASE nm_cardinality
                                                                    WHEN 1
                                                                    THEN
                                                                       CASE datum_end
                                                                          WHEN ne_length
                                                                          THEN
                                                                             0
                                                                          ELSE
                                                                             1
                                                                       END
                                                                    ELSE
                                                                       CASE datum_st
                                                                          WHEN 0
                                                                          THEN
                                                                             0
                                                                          ELSE
                                                                             1
                                                                       END
                                                                 END
                                                                    ce,
                                                                 DECODE (
                                                                    nm_cardinality,
                                                                    1, (  nm_slk
                                                                        +   (  GREATEST (
                                                                                  datum_st,
                                                                                  nm_begin_mp)
                                                                             - nm_begin_mp)
                                                                          * NVL (
                                                                               uc_conversion_factor,
                                                                               1)),
                                                                    -1, (  nm_slk
                                                                         +   (  nm_end_mp
                                                                              - LEAST (
                                                                                   datum_end,
                                                                                   nm_end_mp))
                                                                           * NVL (
                                                                                uc_conversion_factor,
                                                                                1)))
                                                                    start_slk,
                                                                 DECODE (
                                                                    nm_cardinality,
                                                                    1, (  nm_slk
                                                                        +   (  LEAST (
                                                                                  datum_end,
                                                                                  nm_end_mp)
                                                                             - nm_begin_mp)
                                                                          * NVL (
                                                                               uc_conversion_factor,
                                                                               1)),
                                                                    -1, (  nm_slk
                                                                         +   (  nm_end_mp
                                                                              - GREATEST (
                                                                                   datum_st,
                                                                                   nm_begin_mp))
                                                                           * NVL (
                                                                                uc_conversion_factor,
                                                                                1)))
                                                                    end_slk,
                                                                 CASE   dir_flag
                                                                      * nm_cardinality
                                                                    WHEN 1
                                                                    THEN
                                                                       xsp
                                                                    WHEN -1
                                                                    THEN
                                                                       NVL (
                                                                          rvrs_xsp,
                                                                          xsp)
                                                                 END
                                                                    new_xsp,
                                                                   dir_flag
                                                                 * offset
                                                                    new_offset,
                                                                 GREATEST (
                                                                    i.start_date,
                                                                    m.nm_start_date)
                                                                    new_start_date,
                                                                 LEAST (
                                                                    i.end_date,
                                                                    m.nm_end_date)
                                                                    new_end_date
                                                            FROM INV_IDS i,
                                                                 nm_members m,
                                                                 nm_elements e,
                                                                 --                                                                 v_nm_element_xsp_rvrs x,
                                                                 (SELECT uc_unit_id_in,
                                                                         uc_unit_id_out,
                                                                         uc_conversion_factor
                                                                    FROM nm_unit_conversions
                                                                  UNION
                                                                  SELECT un_unit_id,
                                                                         un_unit_id,
                                                                         1
                                                                    FROM nm_units)
                                                           WHERE     nm_obj_type =
                                                                        NVL (
                                                                           p_linear_obj_type,
                                                                           nm_obj_type)
                                                                 AND datum_id =
                                                                        e.ne_id
                                                                 AND nm_ne_id_of =
                                                                        datum_id
                                                                 AND uc_unit_id_out =
                                                                        l_refnt_type.nlt_units
                                                                 AND uc_unit_id_in =
                                                                        i.datum_unit
                                                                 AND (   (    m.nm_begin_mp <
                                                                                 datum_end
                                                                          AND m.nm_end_mp >
                                                                                 datum_st
                                                                          AND datum_end >
                                                                                 datum_st)
                                                                      OR     m.nm_begin_mp <=
                                                                                datum_end
                                                                         AND nm_end_mp >=
                                                                                datum_st
                                                                         AND datum_st =
                                                                                datum_end)
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
                       datum_unit,
                       new_xsp,
                       new_offset
              ORDER BY route_id, inv_start_slk);

      RETURN retval;
   END;


   FUNCTION get_lb_RPt_D_tab (p_lb_RPt_tab IN lb_RPt_tab)
      RETURN lb_RPt_tab
   IS
      retval         lb_RPt_tab;
      l_refnt_type   nm_linear_types%ROWTYPE;
   BEGIN
      -- just going down the hierarchy to diseeminate the data according to linear type
      WITH itab
           AS (SELECT t.*
                 FROM TABLE (lb_ops.normalize_rpt_tab (p_lb_RPt_tab)) t)
      --                   FROM TABLE (p_lb_RPt_tab) t)
      SELECT lb_RPt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     ROWNUM,
                     dir_flag,
                     start_m,
                     end_m,
                     datum_unit)
        BULK COLLECT INTO retval
        FROM (SELECT datum_ne_id refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     nm_seg_no seg_id,
                     ROWNUM,
                     route_dir_flag dir_flag,
                     inv_datum_start start_m,
                     inv_datum_end end_m,
                     datum_unit
                FROM (SELECT t1."SECTION_ID",
                             t1."NM_SEQ_NO",
                             t1."NM_SEG_NO",
                             t1.datum_ne_id,
                             t1.route_dir_flag * obj_dir_flag
                                "ROUTE_DIR_FLAG",
                             t1."ROUTE_START_ON_ESU",
                             t1."ROUTE_END_ON_ESU",
                             t1."ROUTE_START_M",
                             t1."ROUTE_END_M",
                             obj_id,
                             t1.obj_type,
                             t1."START_M",
                             t1."END_M",
                             t1."INV_START",
                             t1."INV_END",
                             t1."NE_LENGTH",
                             t1.ne_nt_type,
                             inv_start inv_datum_start,
                             -- ROUND (inv_start, 2) inv_datum_start,
                             --                             round(CASE route_dir_flag
                             --                                WHEN 1 THEN inv_start
                             --                                ELSE ne_length - inv_end
                             --                             END, 2 )
                             --                                inv_datum_start,
                             inv_end inv_datum_end,
                             -- ROUND (inv_end, 2)   inv_datum_end,
                             --                             round(CASE route_dir_flag
                             --                                WHEN 1 THEN inv_end
                             --                                ELSE ne_length  - inv_start
                             --                             END, 2)
                             --                                inv_datum_end,
                             refnt_type,
                             datum_unit
                        FROM (  SELECT rm.nm_ne_id_in section_id,
                                       rm.nm_seq_no,
                                       rm.nm_seg_no,
                                       rm.nm_ne_id_of datum_ne_id,
                                       rm.nm_cardinality route_dir_flag,
                                       rm.nm_begin_mp route_start_on_esu,
                                       rm.nm_end_mp route_end_on_esu,
                                       rm.nm_slk route_start_m,
                                       rm.nm_end_slk route_end_m,
                                       im.obj_id,
                                       im.obj_type,
                                       im.start_m,
                                       im.end_m,
                                       CASE rm.nm_cardinality
                                          WHEN 1
                                          THEN
                                             CASE
                                                WHEN NVL (im.start_m, nm_slk) >=
                                                        nm_slk
                                                THEN
                                                       (  NVL (start_m, nm_slk)
                                                        - nm_slk)
                                                     / NVL (
                                                          uc_conversion_factor,
                                                          1)
                                                   + nm_begin_mp
                                                ELSE
                                                   nm_begin_mp
                                             END
                                          ELSE
                                             CASE
                                                WHEN NVL (im.end_m, nm_end_slk) >=
                                                        nm_end_slk
                                                THEN
                                                   nm_begin_mp
                                                ELSE
                                                     nm_end_mp
                                                   -   (  NVL (end_m,
                                                               nm_end_slk)
                                                        - nm_slk)
                                                     / NVL (
                                                          uc_conversion_factor,
                                                          1)
                                                   + nm_begin_mp
                                             END
                                       END
                                          inv_start,
                                       CASE rm.nm_cardinality
                                          WHEN 1
                                          THEN
                                             CASE
                                                WHEN NVL (end_m, nm_end_slk) >=
                                                        nm_end_slk
                                                THEN
                                                   nm_end_mp
                                                ELSE
                                                       (  NVL (end_m,
                                                               nm_end_slk)
                                                        - nm_slk)
                                                     / NVL (
                                                          uc_conversion_factor,
                                                          1)
                                                   + nm_begin_mp
                                             END
                                          ELSE
                                             CASE
                                                WHEN NVL (start_m, nm_slk) <=
                                                        nm_slk
                                                THEN
                                                   nm_end_mp
                                                ELSE
                                                     nm_end_mp
                                                   -   (  NVL (start_m, nm_slk)
                                                        - nm_slk)
                                                     / NVL (
                                                          uc_conversion_factor,
                                                          1)
                                             END
                                       END
                                          inv_end,
                                       e.ne_length,
                                       e.ne_nt_type,
                                       nlt_id refnt_type,
                                       nlt_units datum_unit,
                                       im.m_unit group_unit,
                                       NVL (uc_conversion_factor, 1),
                                       CASE
                                          WHEN im.start_m = im.end_m
                                          THEN
                                             ROW_NUMBER ()
                                             OVER (
                                                PARTITION BY im.obj_id,
                                                             rm.nm_ne_id_in
                                                ORDER BY im.start_m)
                                          ELSE
                                             NULL
                                       END
                                          rn,
                                       im.dir_flag obj_dir_flag
                                  FROM itab im,
                                       nm_members rm,
                                       nm_elements e,
                                       nm_linear_types l,
                                       (SELECT uc_unit_id_in,
                                               uc_unit_id_out,
                                               uc_conversion_factor
                                          FROM nm_unit_conversions
                                        UNION
                                        SELECT un_unit_id, un_unit_id, 1
                                          FROM nm_units)
                                 WHERE     e.ne_id = rm.nm_ne_id_of
                                       AND l.nlt_g_i_d = 'D'
                                       AND l.nlt_nt_type = ne_nt_type
                                       AND rm.nm_ne_id_in = im.refnt
                                       AND (       NVL (im.start_m, 0) !=
                                                      NVL (im.end_m,
                                                           rm.nm_end_slk)
                                               AND ( (    NVL (im.start_m,
                                                               rm.nm_end_slk) <
                                                             rm.nm_end_slk
                                                      AND NVL (im.end_m,
                                                               rm.nm_slk) >
                                                             rm.nm_slk
                                                      AND NVL (im.end_m,
                                                               rm.nm_end_slk) >
                                                             NVL (
                                                                im.start_m,
                                                                  rm.nm_end_slk
                                                                - 1)))
                                            OR (    NVL (im.start_m, 0) =
                                                       NVL (im.end_m, 0)
                                                AND NVL (im.end_m,
                                                         rm.nm_end_slk) <=
                                                       rm.nm_end_slk
                                                AND NVL (im.start_m, rm.nm_slk) >=
                                                       rm.nm_slk) --                                       OR (    nvl(im.start_m,0) = nvl(im.end_m, 0)
                                                                 --                                                AND nvl(im.end_m, rm.nm_end_slk) = rm.nm_end_slk and rownum = 1
                                                                 ----                                                AND nvl(im.start_m, rm.nm_slk)   = rm.nm_slk
                                                                 --                                                )
                                           )
                                       AND UC_UNIT_ID_IN = nlt_units
                                       AND UC_UNIT_ID_OUT = m_unit
                              ORDER BY rm.nm_seg_no, rm.nm_seq_no, im.start_m)
                             t1
                       WHERE rn = 1 OR rn IS NULL));

      RETURN retval;
   END;

   FUNCTION get_lb_XRPt_D_tab (p_lb_XRPt_tab IN lb_XRPt_tab)
      RETURN lb_XRPt_tab
   IS
      retval         lb_XRPt_tab;
      l_refnt_type   nm_linear_types%ROWTYPE;
   BEGIN
      -- just going down the hierarchy to diseeminate the data according to linear type
      WITH itab
           AS (SELECT t.*
                 FROM TABLE (lb_ops.normalize_xrpt_tab (p_lb_XRPt_tab)) t)
      SELECT lb_XRPt (refnt,
                      refnt_type,
                      obj_type,
                      obj_id,
                      seg_id,
                      ROWNUM,
                      dir_flag,
                      start_m,
                      end_m,
                      datum_unit,
                      xsp,
                      offset,
                      start_date,
                      end_date)
        BULK COLLECT INTO retval
        FROM (SELECT datum_ne_id refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     nm_seg_no seg_id,
                     ROWNUM,
                     route_dir_flag dir_flag,
                     inv_datum_start start_m,
                     inv_datum_end end_m,
                     datum_unit,
                     NULL xsp,
                     NULL offset,
                     NULL start_date,
                     NULL end_date
                FROM (SELECT t1."SECTION_ID",
                             t1."NM_SEQ_NO",
                             t1."NM_SEG_NO",
                             t1.datum_ne_id,
                             t1.route_dir_flag * obj_dir_flag
                                "ROUTE_DIR_FLAG",
                             t1."ROUTE_START_ON_ESU",
                             t1."ROUTE_END_ON_ESU",
                             t1."ROUTE_START_M",
                             t1."ROUTE_END_M",
                             obj_id,
                             t1.obj_type,
                             t1."START_M",
                             t1."END_M",
                             t1."INV_START",
                             t1."INV_END",
                             t1."NE_LENGTH",
                             t1.ne_nt_type,
                             inv_start inv_datum_start,
                             -- ROUND (inv_start, 2) inv_datum_start,
                             --                             round(CASE route_dir_flag
                             --                                WHEN 1 THEN inv_start
                             --                                ELSE ne_length - inv_end
                             --                             END, 2 )
                             --                                inv_datum_start,
                             inv_end inv_datum_end,
                             -- ROUND (inv_end, 2)   inv_datum_end,
                             --                             round(CASE route_dir_flag
                             --                                WHEN 1 THEN inv_end
                             --                                ELSE ne_length  - inv_start
                             --                             END, 2)
                             --                                inv_datum_end,
                             refnt_type,
                             datum_unit,
                             xsp,
                             offset,
                             start_date,
                             end_date
                        FROM (  SELECT rm.nm_ne_id_in section_id,
                                       rm.nm_seq_no,
                                       rm.nm_seg_no,
                                       rm.nm_ne_id_of datum_ne_id,
                                       rm.nm_cardinality route_dir_flag,
                                       rm.nm_begin_mp route_start_on_esu,
                                       rm.nm_end_mp route_end_on_esu,
                                       rm.nm_slk route_start_m,
                                       rm.nm_end_slk route_end_m,
                                       im.obj_id,
                                       im.obj_type,
                                       im.start_m,
                                       im.end_m,
                                       CASE rm.nm_cardinality
                                          WHEN 1
                                          THEN
                                               --                                                 CASE
                                               --                                                     WHEN im.start_m >= nm_slk
                                               --                                                     THEN
                                               (start_m - nm_slk)
                                             / NVL (uc_conversion_factor, 1)
                                          --                                                         + nm_begin_mp
                                          --                                                     ELSE
                                          --                                                         nm_begin_mp
                                          --                                                 END
                                          ELSE
                                               --                                                 CASE
                                               --                                                     WHEN im.end_m >=
                                               --                                                          nm_end_slk
                                               --                                                     THEN
                                               --                                                         nm_begin_mp
                                               --                                                     ELSE
                                               nm_end_mp
                                             -   (end_m - nm_slk)
                                               / NVL (uc_conversion_factor, 1)
                                       --                                                         + nm_begin_mp
                                       --                                             END
                                       END
                                          inv_start,
                                       CASE rm.nm_cardinality
                                          WHEN 1
                                          THEN
                                               --                                                 CASE
                                               --                                                     WHEN end_m >= nm_end_slk
                                               --                                                     THEN
                                               --                                                         nm_end_mp
                                               --                                                     ELSE
                                               (end_m - nm_slk)
                                             / NVL (uc_conversion_factor, 1)
                                          --                                                         + nm_begin_mp
                                          --                                                 END
                                          ELSE
                                               --                                                 CASE
                                               --                                                     WHEN start_m <= nm_slk
                                               --                                                     THEN
                                               --                                                         nm_end_mp
                                               --                                                     ELSE
                                               nm_end_mp
                                             -   (start_m - nm_slk)
                                               / NVL (uc_conversion_factor, 1)
                                       --                                                 END
                                       END
                                          inv_end,
                                       e.ne_length,
                                       e.ne_nt_type,
                                       nlt_id refnt_type,
                                       nlt_units datum_unit,
                                       im.m_unit group_unit,
                                       NVL (uc_conversion_factor, 1),
                                       CASE
                                          WHEN im.start_m = im.end_m
                                          THEN
                                             ROW_NUMBER ()
                                             OVER (
                                                PARTITION BY im.obj_id,
                                                             rm.nm_ne_id_in
                                                ORDER BY im.start_m)
                                          ELSE
                                             NULL
                                       END
                                          rn,
                                       im.dir_flag obj_dir_flag,
                                       CASE (rm.nm_cardinality * im.dir_flag)
                                          WHEN 1
                                          THEN
                                             im.xsp
                                          WHEN -1
                                          THEN
                                             (SELECT NVL (
                                                        (SELECT NVL (rvrs_xsp,
                                                                     xsp)
                                                           FROM v_nm_element_xsp_rvrs r
                                                          WHERE     r.xsp_element_id =
                                                                       refnt
                                                                AND r.element_xsp =
                                                                       im.xsp),
                                                        xsp)
                                                FROM DUAL)
                                       END
                                          xsp,
                                       CASE (rm.nm_cardinality * im.dir_flag)
                                          WHEN 1 THEN im.offset
                                          WHEN -1 THEN im.offset * -1 --reversed
                                       END
                                          offset,
                                       im.start_date,
                                       im.end_date
                                  FROM itab im,
                                       nm_members rm,
                                       nm_elements e,
                                       nm_linear_types l,
                                       (SELECT uc_unit_id_in,
                                               uc_unit_id_out,
                                               uc_conversion_factor
                                          FROM nm_unit_conversions
                                        UNION
                                        SELECT un_unit_id, un_unit_id, 1
                                          FROM nm_units)
                                 WHERE     e.ne_id = rm.nm_ne_id_of
                                       AND l.nlt_g_i_d = 'D'
                                       AND l.nlt_nt_type = ne_nt_type
                                       AND rm.nm_ne_id_in = im.refnt
                                       AND (       NVL (im.start_m, 0) !=
                                                      NVL (im.end_m,
                                                           rm.nm_end_slk)
                                               AND ( (    NVL (im.start_m,
                                                               rm.nm_end_slk) <
                                                             rm.nm_end_slk
                                                      AND NVL (im.end_m,
                                                               rm.nm_slk) >
                                                             rm.nm_slk
                                                      AND NVL (im.end_m,
                                                               rm.nm_end_slk) >
                                                             NVL (
                                                                im.start_m,
                                                                  rm.nm_end_slk
                                                                - 1)))
                                            OR (    NVL (im.start_m, 0) =
                                                       NVL (im.end_m, 0)
                                                AND NVL (im.end_m,
                                                         rm.nm_end_slk) <=
                                                       rm.nm_end_slk
                                                AND NVL (im.start_m, rm.nm_slk) >=
                                                       rm.nm_slk) --                                       OR (    nvl(im.start_m,0) = nvl(im.end_m, 0)
                                                                 --                                                AND nvl(im.end_m, rm.nm_end_slk) = rm.nm_end_slk and rownum = 1
                                                                 ----                                                AND nvl(im.start_m, rm.nm_slk)   = rm.nm_slk
                                                                 --                                                )
                                           )
                                       AND UC_UNIT_ID_IN = nlt_units
                                       AND UC_UNIT_ID_OUT = m_unit
                              ORDER BY rm.nm_seg_no, rm.nm_seq_no, im.start_m)
                             t1
                       WHERE rn = 1 OR rn IS NULL));

      RETURN retval;
   END;

   FUNCTION get_asset_ids_at_loc (pi_rpt_tab     IN lb_rpt_tab,
                                  pi_obj_type    IN VARCHAR2,
                                  p_lb_only      IN VARCHAR2 DEFAULT 'FALSE',
                                  p_whole_only   IN VARCHAR2 DEFAULT 'FALSE',
                                  CARDINALITY    IN INTEGER)
      RETURN lb_obj_id_tab
   IS
      retval   lb_obj_id_tab;
   BEGIN
        SELECT lb_obj_id (nal_nit_type, nal_asset_id)
          BULK COLLECT INTO retval
          FROM (SELECT nal_asset_id, nal_nit_type
                  FROM nm_asset_locations nal,
                       nm_locations m,
                       TABLE (pi_rpt_tab) t
                 WHERE     nal_nit_type = NVL (pi_obj_type, nal_nit_type)
                       AND nal_id = nm_ne_id_in
                       AND nm_ne_id_of = refnt
                       AND (   (nm_begin_mp < t.end_m AND nm_end_mp > t.start_m)
                            OR (    nm_begin_mp = nm_end_mp
                                AND nm_begin_mp BETWEEN t.start_m AND t.end_m))
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
                                                                                           pi_rpt_tab)))
                                    AND NOT EXISTS
                                               (SELECT 1
                                                  FROM nm_locations l,
                                                       TABLE (pi_rpt_tab)
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
                SELECT nm_ne_id_in, nm_obj_type
                  FROM nm_members m, TABLE (pi_rpt_tab) t
                 WHERE     p_lb_only = 'FALSE'
                       AND nm_obj_type = NVL (pi_obj_type, nm_obj_type)
                       AND nm_ne_id_of = refnt
                       AND (   (nm_begin_mp < t.end_m AND nm_end_mp > t.start_m)
                            OR (    nm_begin_mp = nm_end_mp
                                AND nm_begin_mp BETWEEN t.start_m AND t.end_m))
                       AND (       p_whole_only = 'TRUE'
                               AND (    NOT EXISTS
                                               (SELECT 1
                                                  FROM nm_locations l
                                                 WHERE     nm_ne_id_in =
                                                              m.nm_ne_id_in
                                                       AND l.nm_ne_id_of NOT IN (SELECT refnt
                                                                                   FROM TABLE (
                                                                                           pi_rpt_tab)))
                                    AND NOT EXISTS
                                               (SELECT 1
                                                  FROM nm_locations l,
                                                       TABLE (pi_rpt_tab)
                                                 WHERE     nm_ne_id_in =
                                                              m.nm_ne_id_in
                                                       AND refnt =
                                                              l.nm_ne_id_of
                                                       AND (   l.nm_begin_mp <
                                                                  start_m
                                                            OR l.nm_end_mp >
                                                                  end_m)))
                            OR p_whole_only = 'FALSE'))
      GROUP BY nal_asset_id, nal_nit_type;

      RETURN retval;
   END;

   FUNCTION get_obj_id_as_rpt_tab (pi_obj_id     IN INTEGER,
                                   pi_obj_type   IN VARCHAR2)
      RETURN lb_rpt_tab
   IS
      retval       lb_rpt_tab;
      l_ft_flag    VARCHAR2 (1) := NULL;
      l_category   VARCHAR2 (1) := NULL;
   BEGIN
      --
      IF pi_obj_type IS NOT NULL
      THEN
         BEGIN
            SELECT DECODE (nit_table_name, NULL, 'N', 'Y'), nit_category
              INTO l_ft_flag, l_category
              FROM nm_inv_types
             WHERE     nit_inv_type = pi_obj_type
                   AND NOT EXISTS
                          (SELECT 1
                             FROM nm_nt_groupings
                            WHERE nng_group_type = pi_obj_type);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END IF;

      IF l_ft_flag = 'Y' AND l_category = 'F'
      THEN
         EXECUTE IMMEDIATE get_FT_retrieval_str (pi_obj_type, pi_obj_id)
            INTO retval
            USING pi_obj_id;
      ELSE
         --
         SELECT CAST (COLLECT (lb_rpt (nm_ne_id_of,
                                       nlt_id,
                                       nm_obj_type,
                                       nm_ne_id_in,
                                       nm_seg_no,
                                       nm_seq_no,
                                       nm_cardinality,
                                       nm_begin_mp,
                                       nm_end_mp,
                                       nlt_units)) AS lb_rpt_tab)
           INTO retval
           FROM (SELECT nm_ne_id_of,
                        nlt_id,
                        nm_obj_type,
                        nm_ne_id_in,
                        nm_seg_no,
                        nm_seq_no,
                        nm_cardinality,
                        nm_begin_mp,
                        nm_end_mp,
                        nlt_units
                   FROM nm_members, nm_linear_types, nm_elements
                  WHERE     ne_id = nm_ne_id_of
                        AND nlt_nt_type = ne_nt_type
                        AND NVL (nlt_gty_type, '¿$%^') =
                               NVL (ne_gty_group_type, '¿$%^')
                        AND nm_ne_id_in = pi_obj_id
                        AND nm_obj_type = NVL (pi_obj_type, nm_obj_type)
                 UNION ALL
                 SELECT nm_ne_id_of,
                        nlt_id,
                        nm_obj_type,
                        nm_ne_id_in,
                        nm_seg_no,
                        nm_seq_no,
                        nm_dir_flag,
                        nm_begin_mp,
                        nm_end_mp,
                        nlt_units
                   FROM nm_locations, nm_linear_types, nm_elements
                  WHERE     ne_id = nm_ne_id_of
                        AND nlt_nt_type = ne_nt_type
                        AND NVL (nlt_gty_type, '¿$%^') =
                               NVL (ne_gty_group_type, '¿$%^')
                        AND nm_ne_id_in = pi_obj_id
                        AND nm_obj_type = NVL (pi_obj_type, nm_obj_type));
      END IF;

      RETURN retval;
   END;

   FUNCTION get_ft_rpt_tab (p_rpt_tab      IN lb_rpt_tab,
                            p_table_name   IN VARCHAR2,
                            p_inv_type     IN VARCHAR2,
                            p_key          IN VARCHAR2,
                            p_ne_key       IN VARCHAR2,
                            p_start_col    IN VARCHAR2,
                            p_end_col      IN VARCHAR2)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
      l_str    VARCHAR2 (4000);
   BEGIN
      l_str :=
            ' SELECT cast ( collect(lb_rpt( esu_id, 2, inv_type, inv_id, NULL, NULL, 1, inv_datum_start, inv_datum_end, 1 ) ) as lb_rpt_tab ) '
         || ' from ( select '
         || '       t1."SECTION_ID", '
         || '       t1."NM_SEQ_NO", '
         || '       t1."NM_SEG_NO", '
         || '       t1."ESU_ID", '
         || '       t1."ROUTE_DIR_FLAG", '
         || '       t1."ROUTE_START_ON_ESU", '
         || '       t1."ROUTE_END_ON_ESU", '
         || '       t1."ROUTE_START_M", '
         || '       t1."ROUTE_END_M", '
         || '       t1."INV_ID", '
         || '       t1."INV_TYPE", '
         || '       t1."START_M", '
         || '       t1."END_M", '
         || '       t1."INV_START", '
         || '       t1."INV_END", '
         || '       t1."NE_LENGTH", '
         --         || '       t1."START_DATE", '
         --         || '       t1."END_DATE", '
         || '       CASE route_dir_flag '
         || '          WHEN 1 THEN inv_start '
         || '          ELSE ne_length - inv_end '
         || '       END '
         || '          inv_datum_start, '
         || '       CASE route_dir_flag '
         || '          WHEN 1 THEN inv_end '
         || '          ELSE ne_length - inv_start '
         || '       END '
         || '          inv_datum_end '
         || '  FROM (  SELECT rm.nm_ne_id_in section_id, '
         || '                 rm.nm_seq_no, '
         || '                 rm.nm_seg_no, '
         || '                 rm.nm_ne_id_of esu_id, '
         || '                 rm.nm_cardinality route_dir_flag, '
         || '                 rm.nm_begin_mp route_start_on_esu, '
         || '                 rm.nm_end_mp route_end_on_esu, '
         || '                 rm.nm_slk route_start_m, '
         || '                 rm.nm_end_slk route_end_m, '
         || '                 im.'
         || p_key
         || ' inv_id, '
         || '                 '
         || ''''
         || p_inv_type
         || ''''
         || ' inv_type, '
         || '                 im.'
         || p_start_col
         || ' start_m, '
         || '                 im.'
         || p_end_col
         || ' end_m,  '
         || '                   GREATEST (im.'
         || p_start_col
         || ', rm.nm_slk) '
         || '                 - rm.nm_slk '
         || '                 + rm.nm_begin_mp '
         || '                    inv_start, '
         || '                   LEAST (im.'
         || p_end_col
         || ', rm.nm_end_slk) '
         || '                 - rm.nm_slk '
         || '                 + rm.nm_begin_mp '
         || '                    inv_end, '
         || '                 e.ne_length '
         --         || '                 start_date, '
         --         || '                 end_date '
         || '            FROM '
         || p_table_name
         || ' im, nm_members rm, nm_elements e, table (:p_rpt_tab ) '
         || '           WHERE     e.ne_id = rm.nm_ne_id_of '
         || '                 AND rm.nm_ne_id_in = im.'
         || p_ne_key
         || '                 AND e.ne_id = refnt '
         || '                 AND (   (    im.'
         || p_start_col
         || ' < rm.nm_end_slk '
         || '                          AND im.'
         || p_end_col
         || ' > rm.nm_slk '
         || '                          AND im.'
         || p_end_col
         || ' > im.'
         || p_start_col
         || ') '
         || '                      OR (    im.'
         || p_start_col
         || ' = im.'
         || p_end_col
         || ' '
         || '                          AND im.'
         || p_end_col
         || ' <= rm.nm_end_slk '
         || '                          AND im.'
         || p_start_col
         || ' >= rm.nm_slk)) '
         || '        ORDER BY rm.nm_seg_no, rm.nm_seq_no, im.'
         || p_start_col
         || ') t1 )';
      --
      nm_debug.debug_on;
      nm_debug.debug (l_str);

      EXECUTE IMMEDIATE l_str INTO retval USING p_rpt_tab;

      --
      RETURN retval;
   END;

   FUNCTION get_geom_from_lrefs (pi_lrefs IN nm_lref_array)
      RETURN SDO_GEOMETRY
   IS
      retval   SDO_GEOMETRY;
   BEGIN
      WITH lrdata
           AS (SELECT ROWNUM ordnum, t.*
                 FROM TABLE (pi_lrefs.nla_lref_array) t),
           input_data
           AS (SELECT objectid,
                      rn,
                      lr_ne_id,
                      lr_offset,
                      g1.g.x x,
                      g1.g.y y,
                      g1.base_srid
                 FROM (  SELECT 1 objectid,
                                ROW_NUMBER () OVER (ORDER BY 1) rn,
                                l.*,
                                nm3sdo.get_2d_pt (
                                   SDO_LRS.locate_pt (geoloc, lr_offset, 0.005)).sdo_point
                                   g,
                                s.geoloc.sdo_srid base_srid
                           FROM v_lb_nlt_geometry s, lrdata l
                          WHERE lr_ne_id = ne_id
                       ORDER BY ordnum) g1)
      SELECT sdo_geometry (2002,
                           base_srid,
                           NULL,
                           sdo_elem_info_array (1, 2, 1),
                           ords)
        INTO retval
        FROM (  SELECT base_srid,
                       CAST (
                          COLLECT (ordinate ORDER BY rn, cn) AS sdo_ordinate_array)
                          ords
                  FROM (SELECT rn,
                               cn,
                               ordinate,
                               base_srid
                          FROM (SELECT rn,
                                       1 cn,
                                       x ordinate,
                                       base_srid
                                  FROM input_data ip
                                UNION ALL
                                SELECT rn,
                                       2 cn,
                                       y ordinate,
                                       base_srid
                                  FROM input_data ip) --                         ORDER BY rn, cn
                                                     )
              GROUP BY base_srid);

      RETURN retval;
   END;
   
function get_count ( pi_rpt_tab in lb_rpt_tab ) return integer is
retval number;
begin
   select count(*) into retval
   from table ( pi_rpt_tab );
   return retval;
end;   
   
function get_length ( pi_rpt_tab in lb_rpt_tab, pi_unit in integer ) return number is
retval number;
begin
   select sum(abs(end_m - start_m)) into retval
   from table ( pi_rpt_tab );
   if retval = 0 then
      raise_application_error(-20098, 'The path has zero length' );
   end if;
   return retval;
end;   
END;
/