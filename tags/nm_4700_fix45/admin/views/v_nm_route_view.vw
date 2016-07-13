--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       Pvcs Details     : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_route_view.vw-arc   1.0   Jul 13 2016 10:38:28   Chris.Baugh  $
--       Module Name      : $Workfile:   v_nm_route_view.vw  $
--       Date into PVCS   : $Date:   Jul 13 2016 10:38:28  $
--       Date fetched Out : $Modtime:   Jul 13 2016 10:35:52  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   View designed to ease the reading of route connectivity 
--
-----------------------------------------------------------------------------
-- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW V_NM_ROUTE_VIEW
(ROUTE_ID, ROUTE_NAME, NE_NT_TYPE, NE_GTY_GROUP_TYPE, DATUM_ID,
 DATUM_NAME, DATUM_TYPE, DATUM_START, DATUM_END, ROUTE_START,
 ROUTE_END, NM_SEG_NO, NM_SEQ_NO, DATUM_DIRECTION, START_NODE,
 END_NODE, PRIOR_END_NODE, PRIOR_ROUTE_END, CONTINUITY_FLAG, MEASURE_CONTINUITY,
 MEASURE_DIFFERENCE)
AS
  SELECT t2."ROUTE_ID",
         t2."ROUTE_NAME",
         t2."NE_NT_TYPE",
         t2."NE_GTY_GROUP_TYPE",
         t2."DATUM_ID",
         t2."DATUM_NAME",
         t2."DATUM_TYPE",
         t2."DATUM_START",
         t2."DATUM_END",
         t2."ROUTE_START",
         t2."ROUTE_END",
         t2."NM_SEG_NO",
         t2."NM_SEQ_NO",
         t2."DATUM_DIRECTION",
         t2."START_NODE",
         t2."END_NODE",
         t2."PRIOR_END_NODE",
         t2."PRIOR_ROUTE_END",
         CASE start_node WHEN nvl(prior_end_node, start_node) THEN NULL ELSE 'DISCONTINUITY' END
            continuity_flag,
         CASE route_start
            WHEN nvl(prior_route_end, route_start) THEN NULL
            ELSE 'MEASURE DISCONTINUITY'
         END
            measure_continuity,
         route_start - prior_route_end  measure_difference
    FROM (SELECT t1.*,
                 LAG (end_node, 1)
                    OVER (ORDER BY nm_seg_no, nm_seq_no, route_start)
                    prior_end_node,
                 LAG (route_end, 1)
                    OVER (ORDER BY nm_seg_no, nm_seq_no, route_start)
                    prior_route_end
            FROM (SELECT p.ne_id route_id,
                         p.ne_unique route_name,
                         p.ne_nt_type,
                         p.ne_gty_group_type,
                         e.ne_id datum_id,
                         e.ne_unique datum_name,
                         e.ne_nt_type datum_type,
                         m.nm_begin_mp datum_start,
                         m.nm_end_mp datum_end,
                         m.nm_slk route_start,
                         m.nm_end_slk route_end,
                         nm_seg_no,
                         nm_seq_no,
                         m.nm_cardinality datum_direction,
                         CASE m.nm_cardinality
                            WHEN 1 THEN e.ne_no_start
                            ELSE e.ne_no_end
                         END
                            start_node,
                         CASE m.nm_cardinality
                            WHEN -1 THEN e.ne_no_start
                            ELSE e.ne_no_end
                         END
                            end_node
                    FROM nm_elements p, nm_elements e, nm_members m
                   WHERE     p.ne_id = m.nm_ne_id_in
                         AND e.ne_id = m.nm_ne_id_of
                         AND p.ne_id =
                                TO_NUMBER (
                                   SYS_CONTEXT ('NM3SQL', 'ROUTE_NE_ID'))) t1)
         t2
ORDER BY nm_seg_no, nm_seq_no, route_start;