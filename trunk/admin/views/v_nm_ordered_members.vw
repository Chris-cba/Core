CREATE OR REPLACE FORCE VIEW V_NM_ORDERED_MEMBERS
(
    NM_NE_ID_IN,
    NE_NT_TYPE,
    NM_SEG_NO,
    NM_SEQ_NO,
    NE_ID,
    NE_UNIQUE,
    NE_TYPE,
    DIR_FLAG,
    NM_BEGIN_MP,
    NM_END_MP,
    NM_SLK,
    NM_END_SLK,
    START_NODE,
    END_NODE,
    NE_LENGTH,
    NM_TRUE,
    NM_END_TRUE,
    NE_SUB_CLASS,
    NSC_SEQ_NO,
    PRIOR_NE,
    HAS_PRIOR
)
AS
    WITH
        q1
        AS
            (SELECT  /*+MATERIALIZE*/
                    -------------------------------------------------------------------------
                                                      --   PVCS Identifiers :-
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_ordered_members.vw-arc   1.10   May 30 2018 14:02:44   Chris.Baugh  $
--       Module Name      : $Workfile:   v_nm_ordered_members.vw  $
--       Date into PVCS   : $Date:   May 30 2018 14:02:44  $
--       Date fetched Out : $Modtime:   May 30 2018 14:02:18  $
                               --       Version          : $Revision:   1.10  $
--
--------------------------------------------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------------------------------------------
--
                    nm_ne_id_in,
                    ne_nt_type,
                    nm_seg_no,
                    nm_seq_no,
                    nm_ne_id_of
                        ne_id,
                    ne_unique,
                    ne_type,
                    nm_cardinality
                        dir_flag,
                    CASE nm_cardinality
                        WHEN 1 THEN nm_begin_mp
                        ELSE ne_length - nm_end_mp
                    END
                        nm_begin_mp,
                    CASE nm_cardinality
                        WHEN 1 THEN nm_end_mp
                        ELSE ne_length - nm_begin_mp
                    END
                        nm_end_mp,
                    nm_slk,
                    nm_end_slk,
                    CASE nm_cardinality
                        WHEN 1 THEN ne_no_start
                        ELSE ne_no_end
                    END
                        start_node,
                    CASE nm_cardinality
                        WHEN 1 THEN ne_no_end
                        ELSE ne_no_start
                    END
                        end_node,
                    ne_length,
                    nm_true,
                    nm_end_true,
                    ne_sub_class,
                    (SELECT nsc_seq_no
                       FROM nm_type_subclass
                      WHERE     nsc_nw_type = ne_nt_type
                            AND nsc_sub_class = ne_sub_class)
                        nsc_seq_no
               FROM nm_members, nm_elements
              WHERE     nm_ne_id_in = SYS_CONTEXT ('NM3SQL', 'ORDERED_ROUTE')
                    AND nm_ne_id_of = ne_id)
      SELECT q2."NM_NE_ID_IN",
             q2."NE_NT_TYPE",
             q2."NM_SEG_NO",
             q2."NM_SEQ_NO",
             q2."NE_ID",
             q2."NE_UNIQUE",
             q2."NE_TYPE",
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
             CASE WHEN prior_ne IS NULL THEN NULL ELSE 1 END has_prior
        FROM (  SELECT *
                  FROM (SELECT a.nm_ne_id_in,
                               a.ne_nt_type,
                               a.nm_seg_no,
                               a.nm_seq_no,
                               a.ne_id,
                               a.ne_unique,
                               a.ne_type,
                               a.dir_flag,
                               a.nm_begin_mp,
                               a.nm_end_mp,
                               a.nm_slk,
                               a.nm_end_slk,
                               a.start_node,
                               a.end_node,
                               a.ne_length,
                               a.nm_true,
                               a.nm_end_true,
                               a.ne_sub_class,
                               a.nsc_seq_no,
                               FIRST_VALUE (
                                   b.ne_id)
                               OVER (
                                   PARTITION BY a.ne_id
                                   ORDER BY
                                       CASE
                                           WHEN NVL (a.ne_sub_class, '£$%^') =
                                                NVL (b.ne_sub_class, '£$%%')
                                           THEN
                                               1
                                           ELSE
                                               2
                                       END,
                                       DECODE (NVL (b.nsc_seq_no, 0),
                                               0, 99999,
                                               b.nsc_seq_no)
                                   ROWS BETWEEN UNBOUNDED PRECEDING
                                        AND     UNBOUNDED FOLLOWING)
                                   prior_ne
                          FROM q1 a, q1 b
                         WHERE a.start_node = b.end_node(+))
              GROUP BY nm_ne_id_in,
                       ne_nt_type,
                       nm_seg_no,
                       nm_seq_no,
                       ne_id,
                       ne_unique,
                       ne_type,
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
    ORDER BY nm_seg_no, nm_seq_no;
