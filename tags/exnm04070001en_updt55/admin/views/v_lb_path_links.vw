CREATE OR REPLACE FORCE VIEW V_LB_PATH_LINKS
(
   PATH_SEQ,
   NE_ID,
   NE_NO_START,
   NE_NO_END,
   NE_LENGTH,
   CUM_LENGTH,
   DIR_FLAG
)
AS
   SELECT -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/views/v_lb_path_links.vw-arc   1.0   Oct 08 2015 13:37:38   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_lb_path_links.vw  $
          --       Date into PVCS   : $Date:   Oct 08 2015 13:37:38  $
          --       Date fetched Out : $Modtime:   Oct 08 2015 13:37:58  $
          --       Version          : $Revision:   1.0  $
          --------------------------------------------------------------------------
          --   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
          --------------------------------------------------------------------------
          --
          path_seq,
          ne_id,
          ne_no_start,
          ne_no_end,
          ne_length,
          SUM (ne_length) OVER (ORDER BY path_seq) cum_length,
          CASE path_seq
             WHEN 1
             THEN
                CASE TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'START_NODE'))
                   WHEN ne_no_start THEN 1
                   WHEN ne_no_end THEN -1
                   ELSE 0
                END
             ELSE
                0
          END
             dir_flag
     FROM (SELECT /*+CARDINALITY (T 100) */
                 ROWNUM path_seq, COLUMN_VALUE l_ne_id
             FROM TABLE (
                     lb_path.get_sdo_path (
                        TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'START_NODE')),
                        TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'END_NODE')))) t),
          nm_elements ne
    WHERE ne_id = l_ne_id
/    
