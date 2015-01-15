CREATE OR REPLACE PACKAGE BODY lb_get
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_get.pkb-arc   1.0   Jan 15 2015 15:20:08   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_get.pkb  $
   --       Date into PVCS   : $Date:   Jan 15 2015 15:20:08  $
   --       Date fetched Out : $Modtime:   Jan 15 2015 15:19:34  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_get';

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

   FUNCTION get_obj_RPt_tab (p_refnt_tab     IN lb_RPt_tab,
                             p_obj_type      IN VARCHAR2,
                             p_intsct        IN VARCHAR2 DEFAULT 'FALSE',
                             p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      retval   lb_RPt_tab;
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
        FROM nm_members,
             nm_linear_types,
             nm_elements,
             nm_types,
             TABLE (p_refnt_tab) t
       WHERE     nm_ne_id_of = ne_id
             AND t.refnt = ne_id
             AND ne_nt_type = nlt_nt_type
             AND NVL (ne_gty_group_type, '£$%"') =
                    NVL (nlt_gty_type, '£$%"')
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
                         WHEN (nm_end_mp >= t.end_m) THEN t.start_m
                         ELSE nm_end_mp
                      END
                END,
                nt_length_unit)
        FROM nm_locations_all,
             nm_linear_types,
             nm_elements,
             nm_types,
             TABLE (p_refnt_tab) t
       WHERE     nm_ne_id_of = ne_id
             AND t.refnt = ne_id
             AND ne_nt_type = nlt_nt_type
             AND NVL (ne_gty_group_type, '£$%"') =
                    NVL (nlt_gty_type, '£$%"')
             AND nt_type = ne_nt_type
             AND nlt_id = t.refnt_type
             --  and ne_id = nvl(p_refnt, ne_id)
             AND nm_obj_type = NVL (p_obj_type, nm_obj_type)
             --  and nm_ne_id_in  = nvl(p_obj_id, nm_ne_id_in)
             AND (   (    nm_begin_mp < NVL (t.end_m, ne_length)
                      AND nm_end_mp > NVL (t.start_m, 0))
                  OR (    nm_begin_mp = nm_end_mp
                      AND nm_begin_mp BETWEEN NVL (t.start_m, 0)
                                          AND NVL (t.end_m, ne_length)));

      RETURN retval;
   END;

   --
   FUNCTION get_refnt_RPt_tab_from_geom (
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
            'select lb_RPt( e.ne_id, nlt_id, null, null, null, null, 1, start_m, end_m, nlt_units ) '
         || ' from ( '
         || ' select ne_id, sdo_lrs.geom_segment_start_measure(shape) start_m, sdo_lrs.geom_segment_end_measure(shape) end_m '
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
            'select lb_RPt_geom( e.ne_id, nlt_id, null, null, null, null, 1, start_m, end_m, nlt_units, '
         || nth.nth_feature_shape_column
         || ' ) '
         || ' from ( '
         || ' select ne_id, sdo_lrs.geom_segment_start_measure('
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
      SELECT LISTAGG (case_stmt, CHR (13))
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
         || l_str ||chr(13)
         || '    end geoloc '
         || ' from table (:p_d_rpt_tab) t ) ';

      --
      nm_debug.debug_on;
      nm_debug.debug(cur_str);
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
                            p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      l_g_i_d        VARCHAR2 (1);
      l_refnt_type   INTEGER;
      retval         lb_Rpt_tab;
   BEGIN
      SELECT nlt_g_i_d, nlt_id
        INTO l_g_i_d, l_refnt_type
        FROM nm_linear_types, nm_elements
       WHERE     ne_id = p_refnt
             -- and nlt_id = nvl(pi_refrnt_type, nlt_id)
             AND nlt_nt_type = ne_nt_type
             AND NVL (nlt_gty_type, '£$%^') =
                    NVL (ne_gty_group_type, '£$%^');

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
                                       p_m_unit)),
                   p_obj_type,
                   p_intsct,
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
                                                         p_m_unit))),
                   p_obj_type,
                   p_intsct,
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
             AND NVL (ne_gty_group_type, '£$%"') =
                    NVL (nlt_gty_type, '£$%"')
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
             AND NVL (ne_gty_group_type, '£$%"') =
                    NVL (nlt_gty_type, '£$%"')
             AND nt_type = ne_nt_type
             AND nlt_id = NVL (p_refnt_type, nlt_id)
             AND ne_id = NVL (p_refnt, ne_id)
             AND nm_obj_type = NVL (p_obj_type, nm_obj_type)
             AND nm_ne_id_in = NVL (p_obj_id, nm_ne_id_in);

      --
      RETURN retval;
   END;

   --

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
             AND NVL (ne_gty_group_type, '£$%"') =
                    NVL (nlt_gty_type, '£$%"')
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
END;
/