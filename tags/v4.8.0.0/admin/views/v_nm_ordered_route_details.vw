CREATE OR REPLACE FORCE VIEW V_NM_ORDERED_ROUTE_DETAILS
(
    NM_NE_ID_IN,
    NM_NE_ID_OF,
    NE_UNIQUE,
    PRIOR_NE,
    NM_SEQ_NO,
    NM_CARDINALITY,
    NM_BEGIN_MP,
    NM_END_MP,
    START_NODE,
    END_NODE,
    NE_LENGTH,
    NE_NT_TYPE,
    NE_TYPE,
    NE_SUB_CLASS,
    NSC_SEQ_NO,
    NM_SLK_STORED,
    NM_END_SLK_STORED,
    NM_CALC_SEQ_NO,
    NM_SLK_CALC,
    NM_END_SLK_CALC,
    WHOLE_OR_PART,
    SLK_DIFFERENCE,
    GAP_OR_OVRL_STORED
)
AS
    SELECT --------------------------------------------------------------------------------
           --   PVCS Identifiers :-
           --
           --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_ordered_route_details.vw-arc   1.3   Nov 30 2017 09:24:50   Rob.Coupe  $
           --       Module Name      : $Workfile:   v_nm_ordered_route_details.vw  $
           --       Date into PVCS   : $Date:   Nov 30 2017 09:24:50  $
           --       Date fetched Out : $Modtime:   Nov 30 2017 09:24:30  $
           --       PVCS Version     : $Revision:   1.3  $
           --
           --   Author : R.A. Coupe
           --
           --   View to assist in linear routes rescale (not suitable for divided highways)
           --
           -----------------------------------------------------------------------------
           -- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
           ----------------------------------------------------------------------------
           --
           SYS_CONTEXT ('NM3SQL', 'ORDERED_ROUTE')
               nm_ne_id_in,
           ne_id
               nm_ne_id_of,
           ne_unique,
           prior_ne,
           nm_seq_no,
           dir
               nm_cardinality,
           nm_begin_mp,
           nm_end_mp,
           start_node,
           end_node,
           ne_length,
           ne_nt_type,
           ne_type,
           ne_sub_class,
           nsc_seq_no,
           nm_slk
               nm_slk_stored,
           nm_end_slk
               nm_end_slk_stored,
           ROW_NUMBER () OVER (ORDER BY order1)
               nm_calc_seq_no,
           slk + NVL (TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'START_SLK')), 0)
               nm_slk_calc,
           end_slk + NVL (TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'START_SLK')), 0)
               nm_end_slk_calc,
           whole_or_part,
           slk_difference,
           gap_or_ovrl_stored
      FROM (SELECT q6.*,
                   nm_slk - slk                slk_difference,
                   nm_slk - NVL (p_end_slk, 0) gap_or_ovrl_stored
              FROM (SELECT q5.prior_ne,
                           q5.ne_id,
                           q5.ne_unique,
                           q5.nm_seq_no,
                           q5.dir,
                           q5.nm_begin_mp,
                           q5.nm_end_mp,
                           q5.start_node,
                           q5.end_node,
                           q5.ne_length,
                           q5.nm_slk,
                           q5.nm_end_slk,
                           q5.ne_nt_type,
                           q5.ne_sub_class,
                           q5.ne_type,
                           q5.nsc_seq_no,
                           q5.has_prior,
                           q5.order1,
                           q5.is_cycle,
                           q5.p_length,
                           q5.p_end_slk,
                           q5.slk * conversion_factor
                               slk,
                           q5.end_slk * conversion_factor
                               end_slk,
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
                      FROM (WITH
                                r_units
                                AS
                                    (SELECT route_unit,
                                            datum_unit,
                                            (SELECT CASE route_unit
                                                        WHEN datum_unit
                                                        THEN
                                                            1
                                                        ELSE
                                                            (SELECT uc_conversion_factor
                                                               FROM nm_unit_conversions
                                                              WHERE     uc_unit_id_in =
                                                                        datum_unit
                                                                    AND uc_unit_id_out =
                                                                        route_unit)
                                                    END
                                                        conversion_factor
                                               FROM DUAL)
                                                conversion_factor
                                       FROM (  SELECT ru.un_unit_id route_unit,
                                                      du.un_unit_id datum_unit
                                                 FROM nm_elements r,
                                                      nm_types   rt,
                                                      nm_units   ru,
                                                      nm_nt_groupings,
                                                      nm_types   dt,
                                                      nm_units   du
                                                WHERE     r.ne_nt_type =
                                                          rt.nt_type
                                                      AND rt.nt_length_unit =
                                                          ru.un_unit_id
                                                      AND nng_group_type =
                                                          R.NE_GTY_GROUP_TYPE
                                                      AND dt.nt_type =
                                                          nng_nt_type
                                                      AND dt.nt_length_unit =
                                                          du.un_unit_id
                                                      AND ne_id =
                                                          SYS_CONTEXT (
                                                              'NM3SQL',
                                                              'ORDERED_ROUTE')
                                             GROUP BY ru.un_unit_id,
                                                      du.un_unit_id))
                            SELECT conversion_factor, q4.*
                              FROM (SELECT q3.*
                                      FROM ( (SELECT *
                                                FROM (WITH
                                                          rsc3 (prior_ne,
                                                                ne_id,
                                                                ne_unique,
                                                                nm_seq_no,
                                                                dir,
                                                                nm_begin_mp,
                                                                nm_end_mp,
                                                                start_node,
                                                                end_node,
                                                                ne_length,
                                                                nm_slk,
                                                                nm_end_slk,
                                                                ne_nt_type,
                                                                ne_sub_class,
                                                                ne_type,
                                                                nsc_seq_no,
                                                                has_prior,
                                                                slk,
                                                                end_slk,
                                                                p_end_slk,
                                                                p_length)
                                                          AS
                                                              (SELECT -1,
                                                                      a.ne_id,
                                                                      a.ne_unique,
                                                                      a.nm_seq_no,
                                                                      a.dir_flag,
                                                                      a.nm_begin_mp,
                                                                      a.nm_end_mp,
                                                                      a.start_node,
                                                                      a.end_node,
                                                                      a.ne_length,
                                                                      a.nm_slk,
                                                                      a.nm_end_slk,
                                                                      a.ne_nt_type,
                                                                      a.ne_sub_class,
                                                                      a.ne_type,
                                                                      nsc_seq_no,
                                                                      a.has_prior,
                                                                      0
                                                                          slk,
                                                                      ne_length
                                                                          end_slk,
                                                                      nm_slk
                                                                          p_end_slk,
                                                                      NULL
                                                                          p_length
                                                                 FROM v_nm_ordered_members
                                                                      a
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
                                                                      b.ne_unique,
                                                                      b.nm_seq_no,
                                                                      b.dir_flag,
                                                                      b.nm_begin_mp,
                                                                      b.nm_end_mp,
                                                                      b.start_node,
                                                                      b.end_node,
                                                                      b.ne_length,
                                                                      b.nm_slk,
                                                                      b.nm_end_slk,
                                                                      b.ne_nt_type,
                                                                      b.ne_sub_class,
                                                                      b.ne_type,
                                                                      b.nsc_seq_no,
                                                                      b.has_prior,
                                                                      a.end_slk
                                                                          slk,
                                                                        a.end_slk
                                                                      + b.ne_length
                                                                          end_slk,
                                                                      a.nm_end_slk
                                                                          p_end_slk,
                                                                      a.ne_length
                                                                          p_length
                                                                 FROM v_nm_ordered_members
                                                                      b
                                                                      JOIN
                                                                      rsc3 a
                                                                          ON (a.ne_id =
                                                                              b.prior_ne))
                                                              SEARCH DEPTH FIRST BY start_node,
                                                                                    nm_seq_no SET order1
                                                              CYCLE ne_id SET is_cycle TO 'Y' DEFAULT 'N'
                                                      SELECT *
                                                        FROM rsc3)
                                               WHERE is_cycle = 'N') q3)) q4,
                                   r_units) q5) q6);
