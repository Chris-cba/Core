CREATE OR REPLACE FUNCTION get_lb_RPt_r_tab (
   p_lb_RPt_tab        IN lb_RPt_tab,
   p_linear_obj_type   IN VARCHAR2,
   p_cardinality       IN INTEGER DEFAULT NULL)
   RETURN lb_RPt_tab
IS
   retval         lb_RPt_tab;
   l_refnt_type   nm_linear_types%ROWTYPE;
BEGIN
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
                  m_unit)
     BULK COLLECT INTO retval
     FROM (  SELECT route_id refnt,
                    1 refnt_type,
                    inv_type obj_type,
                    inv_id obj_id,
                    inv_segment_id seg_id,
                    INV_START_SLK start_m,
                    inv_end_slk end_m,
                    1 m_unit
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
                               end_seg
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
                                                              m.nm_ne_id_in
                                                                 route_id,
                                                              m.nm_slk,
                                                              m.nm_end_slk,
                                                              nm_seg_no,
                                                              nm_seq_no,
                                                              CASE m.nm_cardinality
                                                                 WHEN 1
                                                                 THEN
                                                                    ne_no_start
                                                                 ELSE
                                                                    ne_no_end
                                                              END
                                                                 start_node,
                                                              CASE m.nm_cardinality
                                                                 WHEN 1
                                                                 THEN
                                                                    ne_no_end
                                                                 ELSE
                                                                    ne_no_start
                                                              END
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
                                                              CASE m.nm_cardinality
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
                                                              CASE m.nm_cardinality
                                                                 WHEN -1
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
                                                                 end_slk
                                                         FROM INV_IDS i,
                                                              nm_members m,
                                                              nm_elements e
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
                                                     ORDER BY m.nm_ne_id_in,
                                                              nm_seg_no,
                                                              nm_seq_no,
                                                              nm_ne_id_of,
                                                              datum_st * dir,
                                                              datum_end * dir)
                                                    i) j) k) l)
           GROUP BY route_id,
                    inv_id,
                    inv_segment_id,
                    inv_type,
                    sc,
                    inv_start_slk,
                    inv_end_slk,
                    start_seg,
                    end_seg
           ORDER BY route_id, inv_start_slk);

   RETURN retval;
END;
/