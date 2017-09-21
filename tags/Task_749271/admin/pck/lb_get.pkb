CREATE OR REPLACE PACKAGE BODY lb_get
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_get.pkb-arc   1.28   Sep 07 2017 16:36:32   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_get.pkb  $
   --       Date into PVCS   : $Date:   Sep 07 2017 16:36:32  $
   --       Date fetched Out : $Modtime:   Sep 07 2017 16:34:46  $
   --       PVCS Version     : $Revision:   1.28  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.28  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_get';

   --
   -----------------------------------------------------------------------------
   --
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
      --
      DECLARE
         not_an_asset_type   EXCEPTION;
         PRAGMA EXCEPTION_INIT (not_an_asset_type, -20000);
      BEGIN
         l_nit_row := nm3get.get_nit (p_obj_type);
      EXCEPTION
         WHEN not_an_asset_type
         THEN
            NULL;
      END;

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
            get_ft_rpt_tab (p_rpt_tab      => p_refnt_tab,
                            p_table_name   => l_nit_row.nit_table_name,
                            p_inv_type     => p_obj_type,
                            p_key          => l_nit_row.nit_foreign_pk_column,
                            p_ne_key       => l_nit_row.nit_lr_ne_column_name,
                            p_start_col    => l_nit_row.nit_lr_st_chain,
                            p_end_col      => l_nit_row.nit_lr_end_chain);
      ELSE
         BEGIN
            SELECT lb_RPt (
                      nm_ne_id_of,
                      nlt_id,
                      nm_obj_type,
                      nm_ne_id_in,
                      nm_seg_no,
                      nm_seq_no,
                      nm_cardinality,
                      CASE p_intsct
                         WHEN 'FALSE'
                         THEN
                            nm_begin_mp
                         ELSE
                            CASE
                               WHEN (nm_begin_mp <= NVL (t.start_m, 0))
                               THEN
                                  NVL (t.start_m, 0)
                               ELSE
                                  nm_begin_mp
                            END
                      END,
                      CASE p_intsct
                         WHEN 'FALSE'
                         THEN
                            nm_end_mp
                         ELSE
                            CASE
                               WHEN (nm_end_mp >= NVL (t.end_m, ne_length))
                               THEN
                                  NVL (t.end_m, ne_length)
                               ELSE
                                  nm_end_mp
                            END
                      END,
                      nt_length_unit)
              BULK COLLECT INTO retval
              FROM nm_members          m,
                   nm_linear_types,
                   nm_elements,
                   nm_types,
                   TABLE (p_refnt_tab) t
             WHERE     p_lb_only = 'FALSE'
                   AND nm_ne_id_of = ne_id
                   AND t.refnt = ne_id
                   AND ne_nt_type = nlt_nt_type
                   AND NVL (ne_gty_group_type, '�$%"') =
                          NVL (nlt_gty_type, '�$%"')
                   AND nt_type = ne_nt_type
                   AND nlt_id = t.refnt_type
                   --  and ne_id = nvl(p_refnt, ne_id)
                   AND nm_obj_type = NVL (p_obj_type, nm_obj_type)
                   --  and nm_ne_id_in  = nvl(p_obj_id, nm_ne_id_in)
                   AND (   (    nm_begin_mp < NVL (t.end_m, ne_length)
                            AND nm_end_mp > NVL (t.start_m, 0))
                        OR (    nm_begin_mp = nm_end_mp
                            AND nm_begin_mp BETWEEN NVL (t.start_m, 0)
                                                AND NVL (t.end_m, ne_length)))
                   AND (       p_whole_only = 'TRUE'
                           AND NOT EXISTS
                                  (SELECT 1
                                     FROM nm_locations l
                                    WHERE     l.nm_ne_id_in = m.nm_ne_id_in
                                          AND l.nm_obj_type = m.nm_obj_type
                                          AND l.nm_ne_id_of NOT IN
                                                 (SELECT refnt
                                                    FROM TABLE (p_refnt_tab)
                                                         t))
                        OR p_whole_only = 'FALSE')
            UNION ALL
            SELECT lb_RPt (
                      nm_ne_id_of,
                      nlt_id,
                      nm_obj_type,
                      nm_ne_id_in,
                      nm_seg_no,
                      nm_seq_no,
                      nm_dir_flag,
                      CASE p_intsct
                         WHEN 'FALSE'
                         THEN
                            nm_begin_mp
                         ELSE
                            CASE
                               WHEN (nm_begin_mp <= t.start_m) THEN t.start_m
                               ELSE nm_begin_mp
                            END
                      END,
                      CASE p_intsct
                         WHEN 'FALSE'
                         THEN
                            nm_end_mp
                         ELSE
                            CASE
                               WHEN (nm_end_mp >= t.end_m) THEN t.end_m
                               ELSE nm_end_mp
                            END
                      END,
                      nt_length_unit)
              FROM nm_locations_all    m,
                   nm_linear_types,
                   nm_elements,
                   nm_types,
                   TABLE (p_refnt_tab) t
             WHERE     nm_ne_id_of = ne_id
                   AND t.refnt = ne_id
                   AND ne_nt_type = nlt_nt_type
                   AND NVL (ne_gty_group_type, '�$%"') =
                          NVL (nlt_gty_type, '�$%"')
                   AND nt_type = ne_nt_type
                   AND nlt_id = t.refnt_type
                   --  and ne_id = nvl(p_refnt, ne_id)
                   AND nm_obj_type = NVL (p_obj_type, nm_obj_type)
                   --  and nm_ne_id_in  = nvl(p_obj_id, nm_ne_id_in)
                   AND (   (    nm_begin_mp < NVL (t.end_m, ne_length)
                            AND nm_end_mp > NVL (t.start_m, 0))
                        OR (    nm_begin_mp = nm_end_mp
                            AND nm_begin_mp BETWEEN NVL (t.start_m, 0)
                                                AND NVL (t.end_m, ne_length)))
                   AND (       p_whole_only = 'TRUE'
                           AND NOT EXISTS
                                  (SELECT 1
                                     FROM nm_locations l
                                    WHERE     l.nm_ne_id_in = m.nm_ne_id_in
                                          AND l.nm_obj_type = m.nm_obj_type
                                          AND l.nm_ne_id_of NOT IN
                                                 (SELECT refnt
                                                    FROM TABLE (p_refnt_tab)
                                                         t))
                        OR p_whole_only = 'FALSE');
         END;
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
         || ', sdo_lrs.geom_segment_start_measure(shape) start_m, sdo_lrs.geom_segment_end_measure(shape) end_m '
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
      l_g_i_d        VARCHAR2 (1);
      l_refnt_type   INTEGER;
      l_units        INTEGER;
      retval         lb_Rpt_tab;
   BEGIN
      SELECT nlt_g_i_d, nlt_id, nlt_units
        INTO l_g_i_d, l_refnt_type, l_units
        FROM nm_linear_types, nm_elements
       WHERE     ne_id = p_refnt
             -- and nlt_id = nvl(pi_refrnt_type, nlt_id)
             AND nlt_nt_type = ne_nt_type
             AND NVL (nlt_gty_type, '�$%^') =
                    NVL (ne_gty_group_type, '�$%^');

      -- dbms_output.put_line('G or D '||l_g_i_d );
      --


      IF l_g_i_d = 'D'
      THEN
         SELECT lb_get.get_obj_RPt_tab (
                   lb_rpt_tab (lb_rpt (p_refnt,
                                       l_refnt_type,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       1,
                                       NVL (p_start_m, 0),
                                       NVL (p_end_m, ne_length),
                                       l_units)),
                   p_obj_type,
                   p_intsct,
                   p_lb_only,
                   p_whole_only,
                   20)
           INTO retval
           FROM nm_elements
          WHERE ne_id = NVL (p_refnt, ne_id);
      ELSE
         SELECT lb_get.get_obj_RPt_tab (
                   get_lb_rpt_d_tab (lb_rpt_tab (lb_rpt (p_refnt,
                                                         l_refnt_type,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         1,
                                                         p_start_m,
                                                         p_end_m,
                                                         l_units))),
                   p_obj_type,
                   p_intsct,
                   p_lb_only,
                   p_whole_only,
                   20)
           INTO retval
           FROM DUAL;
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
             AND NVL (ne_gty_group_type, '�$%"') =
                    NVL (nlt_gty_type, '�$%"')
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
             AND NVL (ne_gty_group_type, '�$%"') =
                    NVL (nlt_gty_type, '�$%"')
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
                     1                      levl,
                      nm_ne_id_in           top_group,
                      nm_ne_id_in           parent_group,
                      nm_ne_id_of           child_group,
                      nm_obj_type           parent_type,
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
                     CYCLE parent_group SET cycle TO 1 DEFAULT 0
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
                     LEAST (m.nm_end_mp, g.nm_end_mp)        nm_end_mp,
                     nlt_units
                FROM group_hierarchy g,
                     nm_elements     e,
                     nm_locations    m,
                     nm_linear_types,
                     lb_types
               --                     TABLE (p_asset_types)
               WHERE     ne_id = m.nm_ne_id_of
                     AND g.child_group = ne_id
                     AND nlt_nt_type = ne_nt_type
                     AND nm_obj_type = NVL (p_inv_type, nm_obj_type) --asset_type --(+)
                     AND nm_obj_type = lb_exor_inv_type                  --(+)
                     --                     and nvl(lb_exor_inv_type, '�$%^') =  case p_LB_only
                     --                                                             when 'TRUE' then lb_exor_inv_type
                     --                                                             else 'NONE'
                     --                                                             end
                     --                     and nvl(asset_type, '�$%^') = case nvl(l_asset_count, 0)
                     --                                                             when 0 then asset_type
                     --                                                             else nm_obj_type
                     --                                                             end
                     AND (       p_whole_only = 'TRUE'
                             AND NOT EXISTS
                                    (SELECT 1
                                       FROM nm_locations l
                                      WHERE     l.nm_ne_id_in = m.nm_ne_id_in
                                            AND l.nm_obj_type = m.nm_obj_type
                                            AND l.nm_ne_id_of NOT IN
                                                   (SELECT child_group
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
                     LEAST (m.nm_end_mp, g.nm_end_mp)        nm_end_mp,
                     nlt_units
                FROM group_hierarchy g,
                     nm_elements     e,
                     nm_members      m,
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
                                      WHERE     l.nm_ne_id_in = m.nm_ne_id_in
                                            AND l.nm_obj_type = m.nm_obj_type
                                            AND l.nm_ne_id_of NOT IN
                                                   (SELECT child_group
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
             AND NVL (ne_gty_group_type, '�$%"') =
                    NVL (nlt_gty_type, '�$%"')
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
                 FROM TABLE (p_lb_RPt_tab) t)
      SELECT lb_RPt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     ROWNUM,
                     1,
                     start_m,
                     end_m,
                     unit_m)
        BULK COLLECT INTO retval
        FROM (  SELECT route_id                     refnt,
                       l_refnt_type.nlt_id          refnt_type,
                       inv_type                     obj_type,
                       inv_id                       obj_id,
                       inv_segment_id               seg_id,
                       ROUND (INV_START_SLK, l_round) start_m,
                       ROUND (inv_end_slk, l_round) end_m,
                       l_refnt_type.nlt_units       unit_m,
					   min_seq_id
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
                               min_seq_id
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
                                                          inv_prior_datum_st,
                                                    min( seq_id ) over ( partition by route_id ) min_seq_id
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
                                                                        itab.seq_id
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
                                                                        +   datum_st
                                                                          * NVL (
                                                                               uc_conversion_factor,
                                                                               1)),
                                                                    -1, (  nm_slk
                                                                         +   (  ne_length
                                                                              - datum_end)
                                                                           * NVL (
                                                                                uc_conversion_factor,
                                                                                1)))
                                                                    start_slk,
                                                                 DECODE (
                                                                    nm_cardinality,
                                                                    1, (  nm_slk
                                                                        +   datum_end
                                                                          * NVL (
                                                                               uc_conversion_factor,
                                                                               1)),
                                                                    -1, (  nm_slk
                                                                         +   (  ne_length
                                                                              - datum_st)
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
                       min_seq_id
              ORDER BY min_seq_id, route_id, inv_start_slk);

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
                 FROM TABLE (p_lb_RPt_tab) t)
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
        FROM (SELECT datum_ne_id     refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     nm_seg_no       seg_id,
                     ROWNUM,
                     route_dir_flag  dir_flag,
                     inv_datum_start start_m,
                     inv_datum_end   end_m,
                     datum_unit
                FROM (SELECT t1."SECTION_ID",
                             t1."NM_SEQ_NO",
                             t1."NM_SEG_NO",
                             t1.datum_ne_id,
                             t1."ROUTE_DIR_FLAG",
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
                        FROM (  SELECT rm.nm_ne_id_in  section_id,
                                       rm.nm_seq_no,
                                       rm.nm_seg_no,
                                       rm.nm_ne_id_of  datum_ne_id,
                                       rm.nm_cardinality route_dir_flag,
                                       rm.nm_begin_mp  route_start_on_esu,
                                       rm.nm_end_mp    route_end_on_esu,
                                       rm.nm_slk       route_start_m,
                                       rm.nm_end_slk   route_end_m,
                                       im.obj_id,
                                       im.obj_type,
                                       im.start_m,
                                       im.end_m,
                                       CASE rm.nm_cardinality
                                          WHEN 1
                                          THEN
                                             CASE
                                                WHEN im.start_m >= nm_slk
                                                THEN
                                                       (start_m - nm_slk)
                                                     / NVL (
                                                          uc_conversion_factor,
                                                          1)
                                                   + nm_begin_mp
                                                ELSE
                                                   nm_begin_mp
                                             END
                                          ELSE
                                             CASE
                                                WHEN im.end_m >= nm_end_slk
                                                THEN
                                                   nm_begin_mp
                                                ELSE
                                                     ne_length
                                                   -   (end_m - nm_slk)
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
                                                WHEN end_m >= nm_end_slk
                                                THEN
                                                   nm_end_mp
                                                ELSE
                                                       (end_m - nm_slk)
                                                     / NVL (
                                                          uc_conversion_factor,
                                                          1)
                                                   + nm_begin_mp
                                             END
                                          ELSE
                                             CASE
                                                WHEN start_m <= nm_slk
                                                THEN
                                                   nm_end_mp
                                                ELSE
                                                     ne_length
                                                   -   (start_m - nm_slk)
                                                     / NVL (
                                                          uc_conversion_factor,
                                                          1)
                                             END
                                       END
                                          inv_end,
                                       e.ne_length,
                                       e.ne_nt_type,
                                       nlt_id          refnt_type,
                                       nlt_units       datum_unit,
                                       im.m_unit       group_unit,
                                       NVL (uc_conversion_factor, 1),
                                       case 
                                          when im.start_m = im.end_m
                                            then ROW_NUMBER ()
                                                 OVER (
                                                 PARTITION BY im.obj_id,
                                                              rm.nm_ne_id_in
                                                 ORDER BY im.start_m)
                                          else NULL
                                       end
                                       rn
                                  FROM itab          im,
                                       nm_members    rm,
                                       nm_elements   e,
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
                       WHERE  rn = 1 or rn is NULL));

      RETURN retval;
   END;

   FUNCTION get_obj_id_as_rpt_tab (pi_obj_id     IN INTEGER,
                                   pi_obj_type   IN VARCHAR2)
      RETURN lb_rpt_tab
   IS
      retval       lb_rpt_tab;
      l_ft_flag    VARCHAR2 (1);
      l_category   VARCHAR2 (1);
   BEGIN
      --
      BEGIN
         SELECT DECODE (nit_table_name, NULL, 'N', 'Y'), nit_category
           INTO l_ft_flag, l_category
           FROM nm_inv_types
          WHERE nit_inv_type = pi_obj_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

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
                        AND NVL (nlt_gty_type, '�$%^') =
                               NVL (ne_gty_group_type, '�$%^')
                        AND nm_ne_id_in = pi_obj_id
                        AND nm_obj_type = pi_obj_type
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
                        AND NVL (nlt_gty_type, '�$%^') =
                               NVL (ne_gty_group_type, '�$%^')
                        AND nm_ne_id_in = pi_obj_id
                        AND nm_obj_type = pi_obj_type);
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
END;
/