/* Formatted on 10/10/2018 18:09:54 (QP5 v5.326) */
CREATE OR REPLACE PACKAGE BODY lb_ops
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_ops.pkb-arc   1.15   Oct 10 2018 18:15:14   Rob.Coupe  $
    --       Module Name      : $Workfile:   lb_ops.pkb  $
    --       Date into PVCS   : $Date:   Oct 10 2018 18:15:14  $
    --       Date fetched Out : $Modtime:   Oct 10 2018 18:14:32  $
    --       PVCS Version     : $Revision:   1.15  $
    --
    --   Author : R.A. Coupe
    --
    --   Location Bridge package for minor set operations
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2015 Bentley Systems Incorporated . All rights reserved.
    ----------------------------------------------------------------------------
    --
    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.15  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'lb_ops';

    g_tol                     NUMBER
        := NVL (TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'LB_TOLERANCE')), 0.000005);
    g_rnd                     INTEGER := ABS (ROUND (LOG (10, g_tol)));

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
        WITH
            lrs_intsct
            AS
                (SELECT t1.*,
                        t2.start_m
                            start_m2,
                        t2.end_m
                            end_m2,
                        CASE
                            WHEN ABS (t2.start_m - t2.end_m) < g_tol
                            THEN                 -- It is a point intersection
                                'POINT'
                            ELSE
                                'LINE'
                        END
                            porl,
                        (SELECT CASE INSTR (un_format_mask, '.')
                                    WHEN 0
                                    THEN
                                        0
                                    ELSE
                                        LENGTH (
                                            SUBSTR (
                                                un_format_mask,
                                                  INSTR (un_format_mask, '.')
                                                + 1,
                                                LENGTH (un_format_mask)))
                                END
                                    rnd
                           FROM nm_units
                          WHERE un_unit_id = t1.m_unit)
                            rnd
                   FROM TABLE (p_Rpt1) t1, TABLE (p_Rpt2) t2
                  WHERE     t1.refnt = t2.refnt
                        AND (   (    t1.start_m = t1.end_m
                                 AND t1.start_m <= t2.end_m
                                 AND t1.end_m >= t2.start_m)
                             OR (    t1.start_m < t1.end_m
                                 AND t1.start_m < t2.end_m
                                 AND t1.end_m > t2.start_m)
                             OR (    t2.start_m = t2.end_m
                                 AND t1.start_m <= t2.end_m + g_tol
                                 AND t1.end_m >= t2.start_m - g_tol)))
        SELECT lb_RPt (
                   refnt,
                   refnt_type,
                   obj_type,
                   obj_id,
                   seg_id,
                   seq_id,
                   dir_flag,
                   --                       case when porl = 'POINT'  then   -- point intersection
                   --                         case when abs(start_m - start_m2) < g_tol then start_m
                   --                         else start_m
                   --                         end
                   --                       else
                   CASE
                       WHEN ABS (start_m - start_m2) < g_tol THEN start_m
                       ELSE ROUND (GREATEST (start_m, start_m2), rnd)
                   --                         end
                   END,
                   --                       case when porl = 'POINT'  then   -- point intersection
                   --                         case when abs(end_m - end_m2) < g_tol then start_m
                   --                         else  end_m
                   --                         end
                   --                       else
                   CASE
                       WHEN ABS (end_m - end_m2) < g_tol THEN end_m
                       ELSE ROUND (LEAST (end_m, end_m2), rnd)
                   --                         end
                   END,
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
        WITH
            ldat
            AS
                (SELECT 'A'     op,
                        refnt,
                        refnt_type,
                        obj_type,
                        obj_id,
                        start_m,
                        end_m,
                        m_unit
                   FROM TABLE (p_Rpt1) t
                 UNION ALL
                 SELECT 'B'     op,
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
                         measure
                             end_m
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
                                  ELSE typ                            --   end
                                           END     typ1
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
                                                 'S'            typ,
                                                 t2.refnt,
                                                 refnt_type,
                                                 obj_type,
                                                 obj_id,
                                                 m_unit,
                                                 t2.start_m     measure
                                            FROM ldat t2
                                          UNION ALL
                                          SELECT t2.op,
                                                 'E'     typ,
                                                 t2.refnt,
                                                 refnt_type,
                                                 obj_type,
                                                 obj_id,
                                                 m_unit,
                                                 t2.end_m
                                            FROM ldat t2))) t3) t4
           WHERE     p_typ IS NOT NULL
                 AND start_m < end_m
                 AND ((   p_op = 'A' AND typ1 = 'E' AND p_typ = 'S'
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
        WITH
            RPt_union
            AS
                (SELECT t1.*
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
          FROM (SELECT DISTINCT
                       refnt,
                       refnt_type,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       MIN (start_m) OVER (PARTITION BY seg)     start_m,
                       MAX (end_m) OVER (PARTITION BY seg)       end_m,
                       m_unit
                  FROM (SELECT q3.*,
                               SUM (sc)
                                   OVER (
                                       ORDER BY refnt, start_m, end_m
                                       ROWS BETWEEN UNBOUNDED PRECEDING
                                            AND     CURRENT ROW)
                                   seg
                          FROM (SELECT q2.*,
                                       CASE SIGN (
                                                NVL (prior_end - end_m, -1))
                                           WHEN -1
                                           THEN
                                               1
                                           ELSE
                                               0
                                       END
                                           sc
                                  FROM (SELECT q1.*
                                          FROM (  SELECT t.*,
                                                         LAG (end_m, 1)
                                                             OVER (
                                                                 PARTITION BY refnt
                                                                 ORDER BY
                                                                     start_m,
                                                                     end_m)
                                                             prior_end
                                                    FROM rpt_union t
                                                ORDER BY refnt,
                                                         start_m,
                                                         end_m) q1) q2) q3)
                       q4);

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

    FUNCTION rpt_append (p_Rpt1        IN lb_rpt_tab,
                         p_Rpt2        IN lb_rpt_tab,
                         CARDINALITY      INTEGER)
        RETURN lb_rpt_tab
    IS
        retval           lb_rpt_tab;
        l1c              INTEGER := p_Rpt1.COUNT;
        l_cnct           INTEGER := 0;
        l_part           INTEGER := 0;
        last_refnt       INTEGER;
        last_seg_id      INTEGER;
        last_seq_id      INTEGER;
        last_dir_flag    INTEGER;
        last_start_m     NUMBER;
        last_end_m       NUMBER;
        first_refnt      INTEGER;
        first_seg_id     INTEGER;
        first_seq_id     INTEGER;
        first_dir_flag   INTEGER;
        first_start_m    NUMBER;
        first_end_m      NUMBER;

        --
        FUNCTION is_connected (refnt1      IN INTEGER,
                               dir_flag1   IN INTEGER,
                               start_m1    IN NUMBER,
                               end_m1      IN NUMBER,
                               refnt2      IN INTEGER,
                               dir_flag2   IN INTEGER,
                               start_m2    IN NUMBER,
                               end_m2      IN NUMBER)
            RETURN BOOLEAN
        IS
            retval    BOOLEAN;
            l_dummy   INTEGER;
        BEGIN
            BEGIN
                SELECT 1
                  INTO l_dummy
                  FROM DUAL
                 WHERE EXISTS
                           (SELECT 1
                              FROM nm_elements     e1,
                                   nm_elements     e2,
                                   nm_node_usages  n1,
                                   nm_node_usages  n2
                             WHERE     e1.ne_id = refnt1
                                   AND N1.NNU_NE_ID = e1.ne_id
                                   AND n1.nnu_no_node_id = n2.nnu_no_node_id
                                   AND N2.NNU_NE_ID = e2.ne_id
                                   AND e2.ne_id = refnt2
                                   AND n1.nnu_node_type =
                                       CASE dir_flag1
                                           WHEN 1 THEN 'E'
                                           ELSE 'S'
                                       END
                                   AND n2.nnu_node_type =
                                       CASE dir_flag2
                                           WHEN 1 THEN 'S'
                                           ELSE 'E'
                                       END
                                   AND CASE dir_flag1
                                           WHEN 1 THEN end_m1
                                           ELSE start_m1
                                       END =
                                       CASE dir_flag1
                                           WHEN 1 THEN e1.ne_length
                                           ELSE 0
                                       END
                                   AND CASE dir_flag2
                                           WHEN 1 THEN start_m2
                                           ELSE end_m2
                                       END =
                                       CASE dir_flag2
                                           WHEN 1 THEN 0
                                           ELSE e2.ne_length
                                       END);

                retval := TRUE;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    retval := FALSE;
            END;

            RETURN retval;
        END;
    --
    BEGIN
        last_refnt := p_Rpt1 (l1c).refnt;
        last_seg_id := p_Rpt1 (l1c).seg_id;
        last_seq_id := p_Rpt1 (l1c).seq_id;
        last_dir_flag := p_Rpt1 (l1c).dir_flag;
        last_start_m := p_Rpt1 (l1c).start_m;
        last_end_m := p_Rpt1 (l1c).end_m;
        first_refnt := p_Rpt2 (1).refnt;
        first_seg_id := p_Rpt2 (1).seg_id;
        first_seq_id := p_Rpt2 (1).seq_id;
        first_dir_flag := p_Rpt2 (1).dir_flag;
        first_start_m := p_Rpt2 (1).start_m;
        first_end_m := p_Rpt2 (1).end_m;

        --
        IF last_refnt = first_refnt
        THEN
            IF last_dir_flag = first_dir_flag
            THEN
                IF last_dir_flag = 1
                THEN
                    IF last_end_m = first_start_m
                    THEN
                        l_cnct := 1;
                        l_part := 1;
                    ELSE
                        l_cnct := 0;
                        l_part := 0;
                    END IF;
                ELSE
                    IF last_start_m = first_end_m
                    THEN
                        l_cnct := 1;
                        l_part := 1;
                    ELSE
                        l_cnct := 0;
                    END IF;
                END IF;
            ELSE
                l_cnct := 0;
            END IF;
        ELSE
            --   check connectivity at the node level
            IF is_connected (last_refnt,
                             last_dir_flag,
                             last_start_m,
                             last_end_m,
                             first_refnt,
                             first_dir_flag,
                             first_start_m,
                             first_end_m)
            THEN
                l_cnct := 1;
                l_part := 0;
            ELSE
                l_cnct := 0;
                l_part := 0;
            END IF;
        END IF;

        nm_debug.debug_on;
        nm_debug.debug (
               'cnct = '
            || l_cnct
            || ', part = '
            || l_part
            || 'last_refnt = '
            || last_refnt
            || ', dir1 = '
            || last_dir_flag
            || ', dir2='
            || first_dir_flag
            || ' start1 = '
            || last_start_m
            || ' start2 = '
            || first_start_m);

        --
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
          FROM (SELECT 1
                           table_number,
                       ROWNUM
                           rn,
                       t1.refnt,
                       t1.refnt_type,
                       t1.obj_type,
                       t1.obj_id,
                       t1.seg_id,
                       t1.seq_id,
                       t1.dir_flag,
                       CASE
                           WHEN     refnt = first_refnt
                                AND l_cnct = 1
                                AND l_part = 1
                           THEN
                               CASE
                                   WHEN dir_flag = 1 THEN t1.start_m
                                   ELSE first_start_m
                               END
                           ELSE
                               t1.start_m
                       END
                           start_m,
                       CASE
                           WHEN     refnt = first_refnt
                                AND l_cnct = 1
                                AND l_part = 1
                           THEN
                               CASE
                                   WHEN dir_flag = 1 THEN first_end_m
                                   ELSE t1.end_m
                               END
                           ELSE
                               t1.end_m
                       END
                           end_m,
                       t1.m_unit
                  FROM TABLE (p_Rpt1) t1
                UNION ALL
                SELECT 2
                           table_number,
                       ROWNUM
                           rn,
                       t2.refnt,
                       t2.refnt_type,
                       t2.obj_type,
                       t2.obj_id,
                       CASE
                           WHEN l_cnct = 1 THEN last_seg_id
                           ELSE t2.seg_id + last_seg_id
                       END
                           seg_id,
                       CASE
                           WHEN l_cnct = 1
                           THEN
                                 last_seq_id
                               + t2.seq_id
                               - (CASE WHEN l_part = 1 THEN 1 ELSE 0 END)
                           ELSE
                               t2.seq_id
                       END
                           seq_id,
                       t2.dir_flag,
                       t2.start_m,
                       t2.end_m,
                       t2.m_unit
                  FROM TABLE (p_Rpt2) t2
                 WHERE l_part = 0 OR (l_part = 1 AND t2.refnt != last_refnt));

        --
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
                         MIN (seq_id)       seq_id,
                         MIN (dir_flag)     dir_flag,
                         MIN (start_m)      start_m,
                         MAX (end_m)        end_m,
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
                                             ne_length
                                                 refnt_length,
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
                                                 WHEN 1
                                                 THEN
                                                     end_m
                                                 WHEN -1
                                                 THEN
                                                     ne_length - start_m
                                             END
                                                 end_m2
                                        FROM TABLE (p_lb_rpt_tab) t,
                                             nm_elements
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
        IF lb_rpt_tab_has_network (pi_rpt_tab) = 'FALSE'
        THEN
            raise_application_error (
                -20019,
                'You must specify a network referent or referent type');
        END IF;

        SELECT lb_rpt (ne_id,
                       nlt_id,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m * uc.uc_conversion_factor,
                       end_m * uc.uc_conversion_factor,
                       uc.uc_unit_id_out)
          BULK COLLECT INTO retval
          FROM TABLE (pi_rpt_tab)   t,
               nm_linear_types      nlt,
               nm_unit_conversions  uc,
               nm_elements
         WHERE     uc.uc_unit_id_in = t.m_unit
               AND uc.uc_unit_id_out = nlt.nlt_units
               AND nlt.nlt_id = NVL (t.refnt_type, nlt.nlt_id)
               AND nlt_nt_type = ne_nt_type
               AND NVL (ne_gty_group_type, '¿¿¿¿$%^') =
                   NVL (nlt_gty_type, '¿¿¿¿$%^')
               AND ne_id = refnt
               AND m_unit IS NOT NULL
        UNION ALL
        SELECT lb_rpt (ne_id,
                       nlt_id,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m * uc.uc_conversion_factor,
                       end_m * uc.uc_conversion_factor,
                       uc.uc_unit_id_out)
          FROM TABLE (pi_rpt_tab)   t,
               nm_linear_types      nlt,
               nm_unit_conversions  uc,
               nm_elements
         WHERE     uc.uc_unit_id_in = NVL (t.m_unit, nlt_units)
               AND uc.uc_unit_id_out = NVL (t.m_unit, nlt.nlt_units)
               AND nlt.nlt_id = NVL (t.refnt_type, nlt.nlt_id)
               AND nlt_nt_type = ne_nt_type
               AND NVL (ne_gty_group_type, '¿¿¿¿$%^') =
                   NVL (nlt_gty_type, '¿¿¿¿$%^')
               AND ne_id = refnt
               AND refnt IS NOT NULL
               AND m_unit IS NULL
        UNION ALL
        SELECT lb_rpt (refnt,
                       nlt_id,
                       obj_type,
                       obj_id,
                       seg_id,
                       seq_id,
                       dir_flag,
                       start_m * uc.uc_conversion_factor,
                       end_m * uc.uc_conversion_factor,
                       uc.uc_unit_id_out)
          --        BULK COLLECT INTO retval
          FROM TABLE (pi_rpt_tab)   t,
               nm_linear_types      nlt,
               nm_unit_conversions  uc,
               nm_inv_nw
         WHERE     uc.uc_unit_id_in = NVL (t.m_unit, nlt_units)
               AND uc.uc_unit_id_out = NVL (t.m_unit, nlt.nlt_units)
               AND nlt.nlt_id = NVL (t.refnt_type, nlt.nlt_id)
               AND nlt_nt_type = nin_nw_type
               AND refnt IS NULL
               AND obj_type = nin_nit_inv_code
               AND obj_type IS NOT NULL
               AND refnt IS NULL;

        --
        RETURN retval;
    END;

    FUNCTION translate_rpt_tab_units (pi_rpt_tab   IN lb_rpt_tab,
                                      unit_out     IN INTEGER)
        RETURN lb_rpt_tab
    IS
        retval   lb_rpt_tab;
    BEGIN
        IF unit_out IS NULL
        THEN
            raise_application_error (-200017, 'A unit must be specified');
        END IF;

        IF check_lb_rpt_tab (pi_rpt_tab) = 'FALSE'
        THEN
            raise_application_error (
                -20018,
                'You must specify a unit via the unit value or through the refnt or refnt_type values ');
        END IF;

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
         WHERE     uc.uc_unit_id_in = t.m_unit
               AND uc.uc_unit_id_out = unit_out
               AND m_unit IS NOT NULL
        UNION ALL
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
          FROM TABLE (pi_rpt_tab) t, nm_unit_conversions uc, nm_linear_types
         WHERE     uc.uc_unit_id_in = nlt_units
               AND uc.uc_unit_id_out = unit_out
               AND nlt_id = refnt_type
               AND m_unit IS NULL
               AND refnt_type IS NOT NULL
        UNION ALL
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
          FROM TABLE (pi_rpt_tab)   t,
               nm_unit_conversions  uc,
               nm_linear_types,
               nm_elements
         WHERE     uc.uc_unit_id_in = nlt_units
               AND uc.uc_unit_id_out = unit_out
               AND ne_id = refnt
               AND nlt_nt_type = ne_nt_type
               AND NVL (nlt_gty_type, '¿¿$%^') =
                   NVL (ne_gty_group_type, '¿¿$%^')
               AND m_unit IS NULL
               AND refnt_type IS NULL
               AND refnt IS NOT NULL;

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
          FROM TABLE (pi_xrpt_tab)  t,
               nm_linear_types      nlt,
               nm_unit_conversions  uc
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
        WITH
            rpts
            AS
                (SELECT lb_rpt (refnt,
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
                  FROM rpts,
                       TABLE (lb_get.get_lb_rpt_d_tab (lb_rpt_tab (rpt))));

        RETURN retval;
    END;

    FUNCTION lb_rpt_tab_has_network (pi_rpt_tab IN lb_rpt_tab)
        RETURN VARCHAR2
    IS
        dummy    INTEGER;
        retval   VARCHAR2 (10) := 'FALSE';
    BEGIN
        BEGIN
            SELECT 1
              INTO dummy
              FROM DUAL
             WHERE EXISTS
                       (SELECT 1
                          FROM TABLE (pi_rpt_tab)
                         WHERE refnt IS NOT NULL);

            retval := 'TRUE';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                retval := 'FALSE';
        END;

        RETURN retval;
    END;

    FUNCTION check_lb_rpt_tab (pi_rpt_tab IN lb_rpt_tab)
        RETURN VARCHAR2
    IS
        l_dummy   INTEGER;
        retval    VARCHAR2 (8) := 'FALSE';
    BEGIN
        BEGIN
            SELECT 1
              INTO l_dummy
              FROM DUAL
             WHERE EXISTS
                       (SELECT 1
                          FROM TABLE (pi_rpt_tab)
                         WHERE     refnt IS NULL
                               AND refnt_type IS NULL
                               AND m_unit IS NULL);

            retval := 'FALSE';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                retval := 'TRUE';
        END;

        RETURN retval;
    END;
END;
/
