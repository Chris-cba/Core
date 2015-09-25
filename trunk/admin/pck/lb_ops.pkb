CREATE OR REPLACE PACKAGE BODY lb_ops
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_ops.pkb-arc   1.2   Sep 25 2015 17:21:56   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_ops.pkb  $
   --       Date into PVCS   : $Date:   Sep 25 2015 17:21:56  $
   --       Date fetched Out : $Modtime:   Sep 25 2015 17:22:08  $
   --       PVCS Version     : $Revision:   1.2  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for minor set operations
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated . All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

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
   FUNCTION RPt_minus (p_Rpt1             lb_RPt_tab,
                       p_Rpt2             lb_RPt_tab,
                       p_cardinality   IN INTEGER)
      RETURN lb_RPt_tab
   AS
      retval   lb_RPt_tab;
   --
   BEGIN
      WITH lrs_Rpt1
           AS (SELECT t1.*
                 FROM TABLE (
                         lb_path.get_sdo_path (nm_lref (3867959, 20),
                                               nm_lref (4174510, 84))) t1),
           lrs_Rpt2
           AS (SELECT t2.*
                 FROM TABLE (
                         lb_path.get_sdo_path (nm_lref (3867959, 10),
                                               nm_lref (4174510, 84))) t2)
      SELECT lb_RPt (
                t.refnt,
                t.refnt_type,
                t.obj_type,
                t.obj_id,
                t.seg_id,
                t.seq_id,
                t.dir_flag,
                --                     t.start_m,
                CASE
                   WHEN t.start_m < NVL (t2.start_m, t.start_m + 1)
                   THEN
                      t.start_m
                   ELSE
                      CASE
                         WHEN t.end_m > NVL (t2.end_m, t.end_m - 1)
                         THEN
                            NVL (t2.end_m, t.end_m)
                         ELSE
                            -99
                      END
                END,
                CASE
                   WHEN t.end_m > NVL (t2.end_m, t.end_m - 1)
                   THEN
                      t.end_m
                   ELSE
                      CASE
                         WHEN t.end_m < NVL (t2.end_m, t.end_m)
                         THEN
                            NVL (t2.start_m, t.end_m)
                         ELSE
                            -99
                      END
                END,
                t.m_unit)
        BULK COLLECT INTO retval
        FROM ((SELECT * FROM lrs_Rpt1
               MINUS
               SELECT * FROM lrs_Rpt2)) t,
             lrs_RPt2 t2
       WHERE     t.refnt = t2.refnt(+)
             AND t.start_m < NVL (t2.end_m, t.start_m - 1)
             AND t.end_m > NVL (t2.start_m, t.end_m + 1);

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
END;
/
