CREATE OR REPLACE FORCE VIEW V_NM_ORDERED_EXTENT_DETAILS
(NM_NE_ID_IN, NM_NE_ID_OF, S_NE_ID, NE_NT_TYPE, NE_SUB_CLASS, NM_SEQ_NO, NM_CARDINALITY, 
 NM_BEGIN_MP, NM_END_MP, START_NODE, END_NODE, NE_LENGTH, 
 NM_SLK_STORED, NM_END_SLK_STORED, NM_CALC_SEG_NO, NM_CALC_SEQ_NO, NM_SLK_CALC, NM_END_SLK_CALC, 
 WHOLE_OR_PART, SLK_DIFFERENCE, GAP_OR_OVRL_STORED, GAP_OR_OVRL_CALC)
AS 
SELECT SYS_CONTEXT ('NM3SQL', 'ORDERED_EXTENT') nm_ne_id_in,
          ne_id nm_ne_id_of,
          s_ne,
          ne_nt_type,
          ne_sub_class,
          nm_seq_no,
          dir nm_cardinality,
          nm_begin_mp,
          nm_end_mp,
          start_node,
          end_node,
          ne_length,
          nm_slk nm_slk_stored,
          nm_end_slk nm_end_slk_stored,
          1,
          ROW_NUMBER () OVER (ORDER BY order1) nm_calc_seq_no,
          slk nm_slk_calc,
          end_slk nm_end_slk_calc,
          whole_or_part,
          slk_difference,
          gap_or_ovrl_stored,
          gap_or_ovrl_calc
     FROM (SELECT q6.*,
                  nm_slk - slk1 slk_difference,
                  nm_slk - NVL (p_end_slk, 0) gap_or_ovrl_stored,
                  slk1 - NVL (LAG (end_slk1, 1) OVER (ORDER BY nm_seq_no), 0)
                     gap_or_ovrl_calc
             FROM (SELECT q5.*,
                          slk * conversion_factor slk1,
                          end_slk * conversion_factor end_slk1,
                          CASE nm_begin_mp
                             WHEN 0
                             THEN
                                CASE nm_end_mp
                                   WHEN ne_length THEN 'W'
                                   ELSE 'P'
                                END
                             ELSE
                                'P'
                          END
                             whole_or_part
                     FROM (
                           SELECT 1 conversion_factor,
                                  q4.*,
                                  SUM (s_length) OVER (ORDER BY order1)
                                     AS slk,
                                  SUM (ne_length) OVER (ORDER BY order1)
                                     AS end_slk,
                                  LAG (nm_end_slk, 1)
                                     OVER (ORDER BY nm_seq_no)
                                     p_end_slk
                             FROM (SELECT q3.*,
                                          NVL (
                                             LAG (ne_length, 1)
                                                OVER (ORDER BY order1),
                                             0)
                                             s_length
                                     FROM ((SELECT *
                                              FROM (
WITH rsc3 (s_ne, ne_id, ne_nt_type, ne_sub_class, nm_seg_no, nm_seq_no, dir, nm_begin_mp, nm_end_mp, start_node, end_node, ne_length, nm_slk, nm_end_slk, has_prior)
                                                         AS (SELECT -1,
                                                                    a.ne_id,
                                                                    a.ne_nt_type,
                                                                    a.ne_sub_class,
                                                                    1,
                                                                    a.nte_seq_no,
                                                                    a.dir_flag,
                                                                    a.nte_begin_mp,
                                                                    a.nte_end_mp,
                                                                    a.start_node,
                                                                    a.end_node,
                                                                    a.ne_length,
                                                                    a.nte_slk,
                                                                    a.nte_end_slk,
                                                                    a.has_prior
                                                               FROM v_nm_ordered_extent a
                                                              WHERE    has_prior
                                                                          IS NULL
                                                                    OR a.ne_id =
                                                                          TO_NUMBER (
                                                                             SYS_CONTEXT (
                                                                                'NM3SQL',
                                                                                'RSC_START'))
                                                             UNION ALL
                                                             SELECT a.ne_id,
                                                                    b.ne_id,
                                                                    b.ne_nt_type,
                                                                    b.ne_sub_class,
                                                                    1,
                                                                    b.nte_seq_no,
                                                                    b.dir_flag,
                                                                    b.nte_begin_mp,
                                                                    b.nte_end_mp,
                                                                    b.start_node,
                                                                    b.end_node,
                                                                    b.ne_length,
                                                                    b.nte_slk,
                                                                    b.nte_end_slk,
                                                                    b.has_prior
                                                               FROM    v_nm_ordered_extent b
                                                                    JOIN
                                                                       rsc3 a
                                                                    ON (a.end_node =
                                                                           b.start_node))
                                                               SEARCH DEPTH FIRST BY start_node,
                                                                                     nm_seq_no SET order1
                                                               CYCLE start_node SET is_cycle TO 'Y' DEFAULT 'N'
                                                    SELECT *
                                                      FROM rsc3)
                                             WHERE is_cycle = 'N'
                                             ) q3)) q4
                                  ) q5) q6);


select * from v_nm_ordered_extent_details