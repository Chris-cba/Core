--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_ordered_route_details.vw-arc   1.0   Apr 24 2013 16:03:40   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_ordered_route_details.vw  $
--       Date into PVCS   : $Date:   Apr 24 2013 16:03:40  $
--       Date fetched Out : $Modtime:   Apr 24 2013 16:02:52  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   View to assist in linear routes rescale (not suitable for divided highways)
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2001
----------------------------------------------------------------------------
--
CREATE OR REPLACE FORCE VIEW V_NM_ORDERED_ROUTE_DETAILS
(
   NM_NE_ID_IN,
   NM_NE_ID_OF,
   S_NE_ID,
   NM_SEQ_NO,
   NM_CARDINALITY,
   NM_BEGIN_MP,
   NM_END_MP,
   START_NODE,
   END_NODE,
   NE_LENGTH,
   NM_SLK_STORED,
   NM_END_SLK_STORED,
   NM_CALC_SEQ_NO,
   NM_SLK_CALC,
   NM_END_SLK_CALC,
   WHOLE_OR_PART,
   SLK_DIFFERENCE,
   GAP_OR_OVRL_STORED,
   GAP_OR_OVRL_CALC
)
AS
   SELECT SYS_CONTEXT ('NM3SQL', 'ORDERED_ROUTE') nm_ne_id_in,
          ne_id nm_ne_id_of,
          s_ne,
          nm_seq_no,
          dir nm_cardinality,
          nm_begin_mp,
          nm_end_mp,
          start_node,
          end_node,
          ne_length,
          nm_slk nm_slk_stored,
          nm_end_slk nm_end_slk_stored,
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
                     FROM (WITH r_units
                                AS (SELECT route_unit,
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
                                                     nm_types rt,
                                                     nm_units ru,
                                                     nm_nt_groupings,
                                                     nm_types dt,
                                                     nm_units du
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
                           SELECT conversion_factor,
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
                                              FROM (WITH rsc3 (s_ne, ne_id, nm_seq_no, dir, nm_begin_mp, nm_end_mp, start_node, end_node, ne_length, nm_slk, nm_end_slk, has_prior)
                                                         AS (SELECT -1,
                                                                    a.ne_id,
                                                                    a.nm_seq_no,
                                                                    a.dir_flag,
                                                                    a.nm_begin_mp,
                                                                    a.nm_end_mp,
                                                                    a.start_node,
                                                                    a.end_node,
                                                                    a.ne_length,
                                                                    a.nm_slk,
                                                                    a.nm_end_slk,
                                                                    a.has_prior
                                                               FROM v_nm_ordered_members a
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
                                                                    b.nm_seq_no,
                                                                    b.dir_flag,
                                                                    b.nm_begin_mp,
                                                                    b.nm_end_mp,
                                                                    b.start_node,
                                                                    b.end_node,
                                                                    b.ne_length,
                                                                    b.nm_slk,
                                                                    b.nm_end_slk,
                                                                    b.has_prior
                                                               FROM    v_nm_ordered_members b
                                                                    JOIN
                                                                       rsc3 a
                                                                    ON (a.end_node =
                                                                           b.start_node))
                                                               SEARCH DEPTH FIRST BY start_node,
                                                                                     nm_seq_no SET order1
                                                               CYCLE ne_id SET is_cycle TO 'Y' DEFAULT 'N'
                                                    SELECT *
                                                      FROM rsc3)
                                             WHERE is_cycle = 'N') q3)) q4,
                                  r_units) q5) q6);
