CREATE OR REPLACE FORCE VIEW V_NM_ORDERED_EXTENT
(
    NTE_JOB_ID,
    NE_NT_TYPE,
    NTE_SEG_NO,
    NTE_SEQ_NO,
    NE_ID,
    DIR_FLAG,
    NTE_BEGIN_MP,
    NTE_END_MP,
    NTE_SLK,
    NTE_END_SLK,
    START_NODE,
    END_NODE,
    NE_LENGTH,
    NTE_TRUE,
    NTE_END_TRUE,
    NE_SUB_CLASS,
    NSC_SEQ_NO,
    PRIOR_NE,
    HAS_PRIOR
)
AS
    WITH
        q1
        AS
            (SELECT /*+MATERIALIZE*/
     -------------------------------------------------------------------------
                                                      --   PVCS Identifiers :-
                   --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_ordered_extent.vw-arc   1.1   Apr 23 2019 12:20:06   Rob.Coupe  $
                   --       Module Name      : $Workfile:   v_nm_ordered_extent.vw  $
                   --       Date into PVCS   : $Date:   Apr 23 2019 12:20:06  $
                   --       Date fetched Out : $Modtime:   Apr 23 2019 12:19:46  $
                               --       Version          : $Revision:   1.1  $
--------------------------------------------------------------------------
--   Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------
                                                                          ----
                   nte_job_id,
                   ne_nt_type,
                   1
                       nte_seg_no,
                   nte_seq_no,
                   nte_ne_id_of
                       ne_id,
                   nte_cardinality
                       dir_flag,
                   CASE nte_cardinality
                       WHEN 1 THEN nte_begin_mp
                       ELSE ne_length - nte_end_mp
                   END
                       nm_begin_mp,
                   CASE nte_cardinality
                       WHEN 1 THEN nte_end_mp
                       ELSE ne_length - nte_begin_mp
                   END
                       nm_end_mp,
                   NULL
                       nm_slk,
                   NULL
                       nm_end_slk,
                   CASE nte_cardinality WHEN 1 THEN ne_no_start ELSE ne_no_end END
                       start_node,
                   CASE nte_cardinality WHEN 1 THEN ne_no_end ELSE ne_no_start END
                       end_node,
                   ne_length,
                   NULL
                       nm_true,
                   NULL
                       nm_end_true,
                   ne_sub_class,
                   (SELECT nsc_seq_no
                      FROM nm_type_subclass
                     WHERE     nsc_nw_type = ne_nt_type
                           AND nsc_sub_class = ne_sub_class)
                       nsc_seq_no
              FROM nm_nw_temp_extents, nm_elements
             WHERE     nte_job_id = SYS_CONTEXT ('NM3SQL', 'ORDERED_EXTENT')
                   AND nte_ne_id_of = ne_id)
      SELECT q2."NTE_JOB_ID",
             q2."NE_NT_TYPE",
             q2."NTE_SEG_NO",
             q2."NTE_SEQ_NO",
             q2."NE_ID",
             q2."DIR_FLAG",
             q2."NM_BEGIN_MP",
             q2."NM_END_MP",
             q2."NM_SLK",
             q2."NM_END_SLK",
             q2."START_NODE",
             q2."END_NODE",
             q2."NE_LENGTH",
             q2."NM_TRUE",
             q2."NM_END_TRUE",
             q2."NE_SUB_CLASS",
             q2."NSC_SEQ_NO",
             q2."PRIOR_NE",
             CASE WHEN prior_ne IS NULL THEN NULL ELSE 1 END     has_prior
        FROM (  SELECT *
                  FROM (SELECT a.*,
                               FIRST_VALUE (b.ne_id)
                                   OVER (
                                       PARTITION BY a.ne_id
                                       ORDER BY b.nte_seq_no
                                       ROWS BETWEEN UNBOUNDED PRECEDING
                                            AND     UNBOUNDED FOLLOWING)    prior_ne
                          FROM q1 a, q1 b
                         WHERE a.start_node = b.end_node(+))
              GROUP BY nte_job_id,
                       ne_nt_type,
                       nte_seg_no,
                       nte_seq_no,
                       ne_id,
                       dir_flag,
                       nm_begin_mp,
                       nm_end_mp,
                       nm_slk,
                       nm_end_slk,
                       start_node,
                       end_node,
                       ne_length,
                       nm_true,
                       nm_end_true,
                       ne_sub_class,
                       nsc_seq_no,
                       prior_ne) q2
    ORDER BY nte_seq_no;

select * from v_nm_ordered_extent