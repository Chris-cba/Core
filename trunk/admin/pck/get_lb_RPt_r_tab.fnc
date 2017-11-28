CREATE OR REPLACE FUNCTION GET_LB_RPT_R_TAB (p_lb_RPt_tab        IN lb_RPt_tab,
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
                     1, --relative_dir,
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
                       min_seq_id,
                       1 --relative_dir
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
                                                             PARTITION BY route_id, inv_id
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
                                                             PARTITION BY route_id, inv_id
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
                                                             PARTITION BY route_id, inv_id
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
                                                             PARTITION BY route_id, inv_id
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
                                                             PARTITION BY route_id, inv_id
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
                                                             PARTITION BY route_id, inv_id
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
                                                                        itab.seq_id,
                                                                        itab.dir_flag
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
                                                                 m.nm_cardinality * i.dir_flag relative_dir,
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
                       min_seq_id--,
--                       relative_dir
              ORDER BY min_seq_id, route_id, inv_start_slk);

      RETURN retval;
   END;
/
