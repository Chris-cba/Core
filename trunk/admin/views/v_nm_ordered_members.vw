CREATE OR REPLACE FORCE VIEW V_NM_ORDERED_MEMBERS
(
    NM_NE_ID_IN,
    NE_NT_TYPE,
    NM_SEG_NO,
    NM_SEQ_NO,
    NE_ID,
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
    SELECT 
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       Pvcs Details     : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_ordered_members.vw-arc   1.4   Nov 24 2017 16:08:48   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_ordered_members.vw  $
--       Date into PVCS   : $Date:   Nov 24 2017 16:08:48  $
--       Date fetched Out : $Modtime:   Nov 24 2017 16:07:36  $
--       PVCS Version     : $Revision:   1.4  $
--
--   Author : R.A. Coupe
--
--   View designed to ease the reading of route connectivity 
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------    
           "NM_NE_ID_IN",
           "NE_NT_TYPE",
           "NM_SEG_NO",
           "NM_SEQ_NO",
           "NE_ID",
           "DIR_FLAG",
           "NM_BEGIN_MP",
           "NM_END_MP",
           "NM_SLK",
           "NM_END_SLK",
           "START_NODE",
           "END_NODE",
           "NE_LENGTH",
           "NM_TRUE",
           "NM_END_TRUE",
           "NE_SUB_CLASS",
           "NSC_SEQ_NO",
           "PRIOR_NE",
           "HAS_PRIOR"
      FROM (WITH
                q1
                AS
                    (SELECT  /*+MATERIALIZE*/
                            nm_ne_id_in,
                            ne_nt_type,
                            nm_seg_no,
                            nm_seq_no,
                            nm_ne_id_of
                                ne_id,
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
                            nsc_seq_no
                       FROM nm_members, nm_elements, nm_type_subclass
                      WHERE     nm_ne_id_in =
                                SYS_CONTEXT ('NM3SQL', 'ORDERED_ROUTE')
                            AND nm_ne_id_of = ne_id
                            AND nsc_nw_type(+) = ne_nt_type
                            AND NVL (nsc_sub_class, '£$%^') =
                                NVL (ne_sub_class, '£$%^'))
            SELECT q2.*,
                   CASE WHEN prior_ne IS NULL THEN NULL ELSE 1 END has_prior
              FROM (SELECT a.*,
                           (SELECT FIRST_VALUE (
                                       ne_id)
                                   OVER (
                                       ORDER BY
                                           CASE
                                               WHEN a.ne_sub_class =
                                                    b.ne_sub_class
                                               THEN
                                                   1
                                               ELSE
                                                   2
                                           END,
                                           DECODE (NVL (b.nsc_seq_no, 0),
                                                   0, 99999,
                                                   b.nsc_seq_no))
                                       prior_ne 
                              FROM q1 b
                             WHERE     b.end_node = a.start_node
                                   AND a.ne_id != b.ne_id
                                   AND ROWNUM = 1)
                               prior_ne
                      FROM q1 a) q2);

