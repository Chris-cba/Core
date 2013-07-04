--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       Pvcs Details     : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_ordered_members.vw-arc   1.3   Jul 04 2013 11:23:50   James.Wadsworth  $
--       Module Name      : $Workfile:   v_nm_ordered_members.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:23:50  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:42  $
--       PVCS Version     : $Revision:   1.3  $
--
--   Author : R.A. Coupe
--
--   View designed to ease the reading of route connectivity 
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW V_NM_ORDERED_MEMBERS
(
   NM_NE_ID_IN,
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
   HAS_PRIOR
)
AS
   SELECT q2."NM_NE_ID_IN",
          q2."NM_SEG_NO",
          q2."NM_SEQ_NO",
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
          q2."HAS_PRIOR"
     FROM (WITH q1
                AS (SELECT nm_ne_id_in,
                           nm_seg_no,
                           nm_seq_no,
                           nm_ne_id_of ne_id,
                           nm_cardinality dir_flag,
                           CASE nm_cardinality
                              WHEN 1 then nm_begin_mp
                              ELSE ne_length - nm_end_mp
                           END nm_begin_mp,
                           CASE nm_cardinality
                              WHEN 1 then nm_end_mp
                              ELSE ne_length - nm_begin_mp
                           END nm_end_mp,
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
                           nm_end_true
                      FROM nm_members, nm_elements
                     WHERE     nm_ne_id_in =
                                  SYS_CONTEXT ('NM3SQL', 'ORDERED_ROUTE')
                           AND nm_ne_id_of = ne_id)
           SELECT a.*,
                  (SELECT 1
                     FROM DUAL
                    WHERE EXISTS
                             (SELECT 1
                                FROM q1 b
                               WHERE b.end_node = a.start_node))
                     has_prior
             FROM q1 a) q2;
