CREATE OR REPLACE PACKAGE BODY lb_ops
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_ops.pkb-arc   1.7   Jul 06 2018 00:38:42   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_ops.pkb  $
   --       Date into PVCS   : $Date:   Jul 06 2018 00:38:42  $
   --       Date fetched Out : $Modtime:   Jul 06 2018 00:35:24  $
   --       PVCS Version     : $Revision:   1.7  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for minor set operations
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated . All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.7  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_ops';

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

   FUNCTION RPt_intersection (p_Rpt1             lb_RPt_tab,
                              p_Rpt2             lb_RPt_tab,
                              p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   AS
      retval   lb_RPt_tab;
   --
   BEGIN
      WITH lrs_intsct
           AS (SELECT t1.*, t2.start_m start_m2, t2.end_m end_m2
                 FROM TABLE (p_Rpt1) t1, TABLE (p_Rpt2) t2
                WHERE     t1.refnt = t2.refnt
                      AND t1.start_m < t2.end_m
                      AND t1.end_m > t2.start_m)
      SELECT lb_RPt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     seq_id,
                     dir_flag,
                     GREATEST (start_m, start_m2),
                     LEAST (end_m, end_m2),
                     m_unit)
        BULK COLLECT INTO retval
        FROM lrs_intsct;

      RETURN retval;
   END;

   --
   FUNCTION rpt_minus (p_Rpt1             lb_rpt_tab,
                       p_Rpt2             lb_rpt_tab,
                       p_cardinality   IN INTEGER)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   BEGIN
      --
      WITH ldat
           AS (SELECT 'A' op,
                      refnt,
                      refnt_type,
                      obj_type,
                      obj_id,
                      start_m,
                      end_m,
                      m_unit
                 FROM TABLE (p_Rpt1) t
               UNION ALL
               SELECT 'B' op,
                      refnt,
                      refnt_type,
                      obj_type,
                      obj_id,
                      start_m,
                      end_m,
                      m_unit
                 FROM TABLE (p_Rpt2))
        SELECT CAST (COLLECT (lb_rpt (t4.refnt,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      start_m,
                                      end_m,
                                      NULL)) AS lb_rpt_tab)
          INTO retval
          FROM (SELECT t3.*,
                       LAG (op, 1)
                          OVER (PARTITION BY refnt,
                                             refnt_type,
                                             obj_type,
                                             obj_id,
                                             m_unit
                                ORDER BY rn)
                          p_op,
                       LAG (typ, 1)
                          OVER (PARTITION BY refnt,
                                             refnt_type,
                                             obj_type,
                                             obj_id,
                                             m_unit
                                ORDER BY rn)
                          p_typ,
                       LAG (measure, 1)
                          OVER (PARTITION BY refnt,
                                             refnt_type,
                                             obj_type,
                                             obj_id,
                                             m_unit
                                ORDER BY rn)
                          start_m,
                       measure end_m
                  FROM (SELECT rn,
                               op,
                               refnt,
                               refnt_type,
                               obj_type,
                               obj_id,
                               m_unit,
                               measure,
                               prior_m,
                               typ,
                               CASE op WHEN 'B' THEN 'E' --start or end of the minus array is always considered an end
                                                         --  else case typ
                                                         --     when 'E' then 'R'
                               ELSE typ                               --   end
                                       END typ1
                          FROM (SELECT ROW_NUMBER ()
                                          OVER (PARTITION BY refnt,
                                                             refnt_type,
                                                             obj_type,
                                                             obj_id,
                                                             m_unit
                                                ORDER BY measure, op, typ)
                                          rn,
                                       op,
                                       typ,
                                       refnt,
                                       refnt_type,
                                       obj_type,
                                       obj_id,
                                       m_unit,
                                       measure,
                                       LAG (measure, 1)
                                          OVER (PARTITION BY refnt,
                                                             refnt_type,
                                                             obj_type,
                                                             obj_id,
                                                             m_unit
                                                ORDER BY measure, op, typ)
                                          prior_m
                                  FROM (SELECT t2.op,
                                               'S' typ,
                                               t2.refnt,
                                               refnt_type,
                                               obj_type,
                                               obj_id,
                                               m_unit,
                                               t2.start_m measure
                                          FROM ldat t2
                                        UNION ALL
                                        SELECT t2.op,
                                               'E' typ,
                                               t2.refnt,
                                               refnt_type,
                                               obj_type,
                                               obj_id,
                                               m_unit,
                                               t2.end_m
                                          FROM ldat t2))) t3) t4
         WHERE     p_typ IS NOT NULL
               AND start_m < end_m
               AND ( (   p_op = 'A' AND typ1 = 'E' AND p_typ = 'S'
                      OR op = 'A' AND typ = 'E' AND p_op = 'B' AND p_typ = 'E'))
      ORDER BY refnt, rn, measure;

      RETURN retval;
   END;



   --
   FUNCTION RPt_union (p_Rpt1             lb_RPt_tab,
                       p_Rpt2             lb_RPt_tab,
                       p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   AS
      retval   lb_RPt_tab;
   --
   BEGIN
      WITH RPt_union
           AS (SELECT t1.*
                 FROM TABLE (p_Rpt1) t1
               UNION ALL
               SELECT t2.*
                 FROM TABLE (p_Rpt2) t2)
      SELECT lb_RPt (refnt,
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
        FROM (SELECT DISTINCT refnt,
                              refnt_type,
                              obj_type,
                              obj_id,
                              seg_id,
                              seq_id,
                              dir_flag,
                              MIN (start_m) OVER (PARTITION BY seg) start_m,
                              MAX (end_m) OVER (PARTITION BY seg) end_m,
                              m_unit
                FROM (SELECT q3.*,
                             SUM (
                                sc)
                             OVER (
                                ORDER BY refnt, start_m, end_m
                                ROWS BETWEEN UNBOUNDED PRECEDING
                                     AND     CURRENT ROW)
                                seg
                        FROM (SELECT q2.*,
                                     CASE SIGN (NVL (prior_end - end_m, -1))
                                        WHEN -1 THEN 1
                                        ELSE 0
                                     END
                                        sc
                                FROM (SELECT q1.*
                                        FROM (  SELECT t.*,
                                                       LAG (
                                                          end_m,
                                                          1)
                                                       OVER (
                                                          PARTITION BY refnt
                                                          ORDER BY
                                                             start_m, end_m)
                                                          prior_end
                                                  FROM rpt_union t
                                              ORDER BY refnt, start_m, end_m)
                                             q1) q2) q3) q4);

      --
      RETURN retval;
   END;

   --
   FUNCTION merge_lb_rpt_tab (p_ne_id         IN INTEGER,
                              p_obj_type      IN VARCHAR2,
                              p_tab           IN lb_RPt_tab,
                              p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   IS
      retval   lb_RPt_tab;
   BEGIN
      SELECT lb_RPt (t.refnt,
                     t.refnt_type,
                     p_obj_type,
                     p_ne_id,
                     t.seg_id,
                     t.seq_id,
                     t.dir_flag,
                     start_m,
                     end_m,
                     m_unit)
        BULK COLLECT INTO retval
        FROM TABLE (p_tab) t;

      RETURN retval;
   END;

   --
   FUNCTION group_lb_rpt_tab (p_tab IN lb_RPt_Tab, p_cardinality IN INTEGER)
      RETURN lb_RPt_tab
   IS
      retval   lb_RPt_tab;
   BEGIN
      SELECT lb_RPt (refnt,
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
        FROM (  SELECT refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       MIN (seq_id) seq_id,
                       MIN (dir_flag) dir_flag,
                       MIN (start_m) start_m,
                       MAX (end_m) end_m,
                       m_unit
                  FROM TABLE (p_tab) t
              GROUP BY refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       m_unit);

      RETURN retval;
   END;

   FUNCTION is_contiguous (p_lb_rpt_tab IN lb_rpt_tab)
      RETURN VARCHAR2
   IS
      retval    VARCHAR2 (10) := 'FALSE';
      l_dummy   INTEGER;
   BEGIN
      BEGIN
         SELECT 1
           INTO l_dummy
           FROM (SELECT t2.*
                   FROM (SELECT t1.*,
                                NVL (
                                   LAG (end_node, 1)
                                      OVER (ORDER BY seg_id, seq_id),
                                   start_node)
                                   prior_end_node
                           FROM (  SELECT t.*,
                                          CASE dir_flag
                                             WHEN 1 THEN ne_no_start
                                             ELSE ne_no_end
                                          END
                                             start_node,
                                          CASE dir_flag
                                             WHEN -1 THEN ne_no_start
                                             ELSE ne_no_end
                                          END
                                             end_node,
                                          ne_length refnt_length,
                                          MIN (seq_id)
                                             OVER (PARTITION BY seg_id)
                                             min_seq,
                                          MAX (seq_id)
                                             OVER (PARTITION BY seg_id)
                                             max_seq,
                                          CASE dir_flag
                                             WHEN 1 THEN start_m
                                             WHEN -1 THEN ne_length - end_m
                                          END
                                             start_m2,
                                          CASE dir_flag
                                             WHEN 1 THEN end_m
                                             WHEN -1 THEN ne_length - start_m
                                          END
                                             end_m2
                                     FROM TABLE (p_lb_rpt_tab) t, nm_elements
                                    WHERE ne_id = refnt
                                 ORDER BY seg_id, seq_id) t1) t2
                  WHERE    start_node != prior_end_node
                        OR (start_m2 != 0 AND seq_id != min_seq)
                        OR (end_m2 != refnt_length AND seq_id != max_seq))
          WHERE ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            retval := 'TRUE';
      END;

      RETURN retval;
   END;

   FUNCTION normalize_rpt_tab (pi_rpt_tab IN lb_rpt_tab)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   BEGIN
      SELECT lb_rpt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     seq_id,
                     dir_flag,
                     start_m * uc.uc_conversion_factor,
                     end_m * uc.uc_conversion_factor,
                     uc.uc_unit_id_out)
        BULK COLLECT INTO retval
        FROM TABLE (pi_rpt_tab) t,
             nm_linear_types nlt,
             nm_unit_conversions uc
       WHERE     uc.uc_unit_id_in = t.m_unit
             AND uc.uc_unit_id_out = nlt.nlt_units
             AND nlt.nlt_id = t.refnt_type;

      --
      RETURN retval;
   END;

   FUNCTION translate_rpt_tab_units (pi_rpt_tab   IN lb_rpt_tab,
                                     unit_out     IN INTEGER)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   BEGIN
      SELECT lb_rpt (refnt,
                     refnt_type,
                     obj_type,
                     obj_id,
                     seg_id,
                     seq_id,
                     dir_flag,
                     start_m * uc.uc_conversion_factor,
                     end_m * uc.uc_conversion_factor,
                     unit_out)
        BULK COLLECT INTO retval
        FROM TABLE (pi_rpt_tab) t, nm_unit_conversions uc
       WHERE uc.uc_unit_id_in = t.m_unit AND uc.uc_unit_id_out = unit_out;

      --
      RETURN retval;
   END;

   FUNCTION normalize_xrpt_tab (pi_xrpt_tab IN lb_xrpt_tab)
      RETURN lb_xrpt_tab
   IS
      retval   lb_xrpt_tab;
   BEGIN
      SELECT lb_xrpt (refnt,
                      refnt_type,
                      obj_type,
                      obj_id,
                      seg_id,
                      seq_id,
                      dir_flag,
                      start_m * uc.uc_conversion_factor,
                      end_m * uc.uc_conversion_factor,
                      uc.uc_unit_id_out,
                      xsp,
                      offset,
                      start_date,
                      end_date)
        BULK COLLECT INTO retval
        FROM TABLE (pi_xrpt_tab) t,
             nm_linear_types nlt,
             nm_unit_conversions uc
       WHERE     uc.uc_unit_id_in = t.m_unit
             AND uc.uc_unit_id_out = nlt.nlt_units
             AND nlt.nlt_id = t.refnt_type;

      --
      RETURN retval;
   END;

   FUNCTION translate_xrpt_tab_units (pi_xrpt_tab   IN lb_xrpt_tab,
                                      unit_out      IN INTEGER)
      RETURN lb_xrpt_tab
   IS
      retval   lb_xrpt_tab;
   BEGIN
      SELECT lb_xrpt (refnt,
                      refnt_type,
                      obj_type,
                      obj_id,
                      seg_id,
                      seq_id,
                      dir_flag,
                      start_m * uc.uc_conversion_factor,
                      end_m * uc.uc_conversion_factor,
                      unit_out,
                      xsp,
                      offset,
                      start_date,
                      end_date)
        BULK COLLECT INTO retval
        FROM TABLE (pi_xrpt_tab) t, nm_unit_conversions uc
       WHERE uc.uc_unit_id_in = t.m_unit AND uc.uc_unit_id_out = unit_out;

      --
      RETURN retval;
   END;

   FUNCTION explode_rpt_tab (pi_rpt_tab IN lb_rpt_tab)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   BEGIN
      WITH rpts
           AS (SELECT lb_rpt (refnt,
                              refnt_type,
                              obj_type,
                              obj_id,
                              seg_id,
                              seq_id,
                              dir_flag,
                              start_m,
                              end_m,
                              m_unit)
                         rpt,
                      nlt_g_i_d
                 FROM TABLE (pi_rpt_tab) t, nm_linear_types
                WHERE nlt_id = refnt_type)
      SELECT CAST (COLLECT (rpt) AS lb_rpt_tab)
        INTO retval
        FROM (SELECT rpt
                FROM rpts
               WHERE nlt_g_i_d = 'D'
              UNION ALL
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
                FROM rpts, TABLE (lb_get.get_lb_rpt_d_tab (lb_rpt_tab (rpt))));

      RETURN retval;
   END;
END;
/
