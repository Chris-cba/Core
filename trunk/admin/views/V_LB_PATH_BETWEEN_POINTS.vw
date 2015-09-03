CREATE OR REPLACE FORCE VIEW V_LB_PATH_BETWEEN_POINTS
(
   TAB_DATA
)
AS
   WITH start_data
        AS ( -------------------------------------------------------------------------
                                                      --   PVCS Identifiers :-
                                                                            --
 --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/views/V_LB_PATH_BETWEEN_POINTS.vw-arc   1.2   Sep 03 2015 13:34:46   Rob.Coupe  $
       --       Module Name      : $Workfile:   V_LB_PATH_BETWEEN_POINTS.vw  $
                  --       Date into PVCS   : $Date:   Sep 03 2015 13:34:46  $
               --       Date fetched Out : $Modtime:   Sep 03 2015 13:33:56  $
                               --       Version          : $Revision:   1.2  $
            ------------------------------------------------------------------
    --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
            ------------------------------------------------------------------
                                                                          ----
           SELECT 'S',
                  n2.*,
                  MIN (dist) OVER (PARTITION BY nnu_ne_id) min_dist
             FROM (SELECT n.*,
                          CASE nnu_node_type
                             WHEN 'S'
                             THEN
                                TO_NUMBER (
                                   SYS_CONTEXT ('NM3SQL', 'L1_OFFSET'))
                             WHEN 'E'
                             THEN
                                  nnu_chain
                                - TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L1_OFFSET'))
                          END
                             dist
                     FROM nm_node_usages n
                    WHERE n.nnu_ne_id IN (TO_NUMBER (
                                             SYS_CONTEXT ('NM3SQL',
                                                          'L1_NE_ID')))) n2),
        end_data
        AS (SELECT 'E',
                   n2.*,
                   MIN (dist) OVER (PARTITION BY nnu_ne_id) min_dist
              FROM (SELECT n.*,
                           CASE nnu_node_type
                              WHEN 'S'
                              THEN
                                 TO_NUMBER (
                                    SYS_CONTEXT ('NM3SQL', 'L2_OFFSET'))
                              WHEN 'E'
                              THEN
                                   nnu_chain
                                 - TO_NUMBER (
                                      SYS_CONTEXT ('NM3SQL', 'L2_OFFSET'))
                           END
                              dist
                      FROM nm_node_usages n
                     WHERE n.nnu_ne_id IN (TO_NUMBER (
                                              SYS_CONTEXT ('NM3SQL',
                                                           'L2_NE_ID')))) n2)
   SELECT CAST (COLLECT (lb_rpt (refnt,
                                 refnt_type,
                                 obj_type,
                                 obj_id,
                                 seg_id,
                                 seq_id,
                                 dir_flag,
                                 start_m,
                                 end_m,
                                 m_unit) ORDER BY seq_id) AS lb_rpt_tab)
     --        INTO retval
     --s_inc_flag, e_inc_flag, start_node, end_node
     FROM (                                                  --select * from (
           SELECT refnt,
                  refnt_type,
                  obj_type,
                  obj_id,
                  seg_id,
                  seq_id,
                  dir_flag,
                  CASE
                     WHEN (    s_inc_flag = 1
                           AND refnt =
                                  TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L1_NE_ID')))
                     THEN
                        CASE dir_flag
                           WHEN 1
                           THEN
                              TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'L1_OFFSET'))
                           ELSE
                              0
                        END
                     WHEN (    e_inc_flag = 1
                           AND refnt =
                                  TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L2_NE_ID')))
                     THEN
                        CASE dir_flag
                           WHEN 1
                           THEN
                              0
                           ELSE
                              TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'L2_OFFSET'))
                        END
                     ELSE
                        start_m
                  END
                     start_m,
                  CASE
                     WHEN (    e_inc_flag = 1
                           AND refnt =
                                  TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L2_NE_ID')))
                     THEN
                        CASE dir_flag
                           WHEN 1
                           THEN
                              TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'L2_OFFSET'))
                           ELSE
                              end_m
                        END
                     WHEN (    s_inc_flag = 1
                           AND refnt =
                                  TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L1_NE_ID')))
                     THEN
                        CASE dir_flag
                           WHEN 1
                           THEN
                              end_m
                           ELSE
                              TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'L1_OFFSET'))
                        END
                     ELSE
                        end_m
                  END
                     end_m,
                  m_unit,
                  s_inc_flag,
                  e_inc_flag,
                  start_node,
                  end_node
             FROM (WITH t2_data
                        AS (SELECT t2.*,
                                   NVL (
                                      FIRST_VALUE (s_inc)
                                         OVER (ORDER BY s_inc NULLS LAST),
                                      0)
                                      s_inc_flag,
                                   NVL (
                                      FIRST_VALUE (e_inc)
                                         OVER (ORDER BY e_inc NULLS LAST),
                                      0)
                                      e_inc_flag
                              FROM (SELECT t1.*,
                                           CASE refnt
                                              WHEN TO_NUMBER (
                                                      SYS_CONTEXT (
                                                         'NM3SQL',
                                                         'L1_NE_ID'))
                                              THEN
                                                 1
                                           END
                                              S_INC,
                                           CASE refnt
                                              WHEN TO_NUMBER (
                                                      SYS_CONTEXT (
                                                         'NM3SQL',
                                                         'L2_NE_ID'))
                                              THEN
                                                 1
                                           END
                                              E_INC
                                      FROM (SELECT s.start_node,
                                                   e.end_node,
                                                   t.*
                                              FROM (SELECT nnu_no_node_id
                                                              start_node
                                                      FROM start_data
                                                     WHERE dist = min_dist) s,
                                                   (SELECT nnu_no_node_id
                                                              end_node
                                                      FROM end_data
                                                     WHERE dist = min_dist) e,
                                                   TABLE (
                                                      LB_PATH.GET_PATH_AS_LB_RPT_TAB (
                                                         s.start_node,
                                                         e.end_node)) t) t1)
                                   t2)
                   SELECT *
                     FROM (SELECT te.refnt,
                                  te.refnt_type,
                                  te.obj_type,
                                  te.obj_id,
                                  te.seg_id,
                                  te.seq_id,
                                  te.dir_flag,
                                  te.start_m,
                                  te.end_m,
                                  te.m_unit,
                                  te.s_inc_flag,
                                  te.e_inc_flag,
                                  te.start_node,
                                  te.end_node
                             FROM t2_data te
                            WHERE TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L1_NE_ID')) !=
                                     TO_NUMBER (
                                        SYS_CONTEXT ('NM3SQL', 'L2_NE_ID'))
                           UNION ALL
                           SELECT TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L1_NE_ID'))
                                     refnt,
                                  nlt_id refnt_type,
                                  'PATH' obj_type,
                                  1 obj_id,
                                  1 seg_id,
                                  0 seq_id,
                                  CASE
                                     WHEN TO_NUMBER (
                                             SYS_CONTEXT ('NM3SQL',
                                                          'L1_NE_ID')) =
                                             TO_NUMBER (
                                                SYS_CONTEXT ('NM3SQL',
                                                             'L2_NE_ID'))
                                     THEN
                                        CASE
                                           WHEN TO_NUMBER (
                                                   SYS_CONTEXT ('NM3SQL',
                                                                'L1_OFFSET')) <=
                                                   TO_NUMBER (
                                                      SYS_CONTEXT (
                                                         'NM3SQL',
                                                         'L2_OFFSET'))
                                           THEN
                                              1
                                           ELSE
                                              -1
                                        END
                                     ELSE
                                        CASE n.nnu_node_type
                                           WHEN 'S' THEN -1
                                           WHEN 'E' THEN 1
                                        END
                                  END
                                     dir_flag,
                                  CASE
                                     WHEN TO_NUMBER (
                                             SYS_CONTEXT ('NM3SQL',
                                                          'L1_NE_ID')) =
                                             TO_NUMBER (
                                                SYS_CONTEXT ('NM3SQL',
                                                             'L2_NE_ID'))
                                     THEN
                                        LEAST (
                                           TO_NUMBER (
                                              SYS_CONTEXT ('NM3SQL',
                                                           'L1_OFFSET')),
                                           TO_NUMBER (
                                              SYS_CONTEXT ('NM3SQL',
                                                           'L2_OFFSET')))
                                     ELSE
                                        CASE n.nnu_node_type
                                           WHEN 'S'
                                           THEN
                                              0
                                           WHEN 'E'
                                           THEN
                                              TO_NUMBER (
                                                 SYS_CONTEXT ('NM3SQL',
                                                              'L1_OFFSET'))
                                        END
                                  END
                                     start_m,
                                  CASE
                                     WHEN TO_NUMBER (
                                             SYS_CONTEXT ('NM3SQL',
                                                          'L1_NE_ID')) =
                                             TO_NUMBER (
                                                SYS_CONTEXT ('NM3SQL',
                                                             'L2_NE_ID'))
                                     THEN
                                        GREATEST (
                                           TO_NUMBER (
                                              SYS_CONTEXT ('NM3SQL',
                                                           'L1_OFFSET')),
                                           TO_NUMBER (
                                              SYS_CONTEXT ('NM3SQL',
                                                           'L2_OFFSET')))
                                     ELSE
                                        CASE n.nnu_node_type
                                           WHEN 'S'
                                           THEN
                                              TO_NUMBER (
                                                 SYS_CONTEXT ('NM3SQL',
                                                              'L1_OFFSET'))
                                           WHEN 'E'
                                           THEN
                                              n.nnu_chain
                                        END
                                  END
                                     end_m,
                                  nlt_units,
                                  NULL,                      -- te.s_inc_flag,
                                  NULL,                      -- te.e_inc_flag,
                                  ne_no_start,               --te.stnart_node,
                                  ne_no_end                      --te.end_node
                             FROM nm_elements,
                                  nm_linear_types,
                                  (SELECT *
                                     FROM start_data
                                    WHERE dist = min_dist AND ROWNUM = 1) n
                            WHERE     nlt_nt_type = ne_nt_type
                                  AND NOT EXISTS
                                         (SELECT 1
                                            FROM t2_data
                                           WHERE s_inc_flag = 1)
                                  AND (   (CASE nnu_node_type
                                              WHEN 'S'
                                              THEN
                                                 TO_NUMBER (
                                                    SYS_CONTEXT ('NM3SQL',
                                                                 'L1_OFFSET'))
                                              WHEN 'E'
                                              THEN
                                                   nnu_chain
                                                 - TO_NUMBER (
                                                      SYS_CONTEXT (
                                                         'NM3SQL',
                                                         'L1_OFFSET'))
                                           END < ne_length / 2)
                                       OR (TO_NUMBER (
                                              SYS_CONTEXT ('NM3SQL',
                                                           'L1_NE_ID')) =
                                              TO_NUMBER (
                                                 SYS_CONTEXT ('NM3SQL',
                                                              'L2_NE_ID'))))
                                  AND NVL (ne_gty_group_type, '£$%^') =
                                         NVL (nlt_gty_type, '£$%^')
                                  AND n.nnu_ne_id = ne_id
                                  AND CASE n.nnu_node_type
                                         WHEN 'E' THEN n.nnu_chain
                                         WHEN 'S' THEN 0
                                      END !=
                                         TO_NUMBER (
                                            SYS_CONTEXT ('NM3SQL',
                                                         'L1_OFFSET'))
                           UNION ALL
                           SELECT TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL', 'L2_NE_ID'))
                                     refnt,
                                  nlt_id refnt_type,
                                  'PATH' obj_type,
                                  1 obj_id,
                                  1 seg_id,
                                  999999 seq_id,
                                  CASE nnu_node_type
                                     WHEN 'S' THEN 1
                                     WHEN 'E' THEN -1
                                  END
                                     dir_flag,
                                  CASE nnu_node_type
                                     WHEN 'S'
                                     THEN
                                        0
                                     WHEN 'E'
                                     THEN
                                        TO_NUMBER (
                                           SYS_CONTEXT ('NM3SQL',
                                                        'L2_OFFSET'))
                                  END
                                     start_m,
                                  CASE nnu_node_type
                                     WHEN 'S'
                                     THEN
                                        TO_NUMBER (
                                           SYS_CONTEXT ('NM3SQL',
                                                        'L2_OFFSET'))
                                     WHEN 'E'
                                     THEN
                                        nnu_chain
                                  END
                                     end_m,
                                  nlt_units,
                                  NULL,                      -- te.s_inc_flag,
                                  NULL,                      -- te.e_inc_flag,
                                  ne_no_start,               --te.stnart_node,
                                  ne_no_end                      --te.end_node
                             FROM nm_elements,
                                  nm_linear_types,
                                  (SELECT *
                                     FROM end_data
                                    WHERE dist = min_dist AND ROWNUM = 1)
                            WHERE     nlt_nt_type = ne_nt_type
                                  AND NOT EXISTS
                                         (SELECT 1
                                            FROM t2_data
                                           WHERE e_inc_flag = 1)
                                  AND CASE nnu_node_type
                                         WHEN 'S'
                                         THEN
                                            TO_NUMBER (
                                               SYS_CONTEXT ('NM3SQL',
                                                            'L2_OFFSET'))
                                         WHEN 'E'
                                         THEN
                                              nnu_chain
                                            - TO_NUMBER (
                                                 SYS_CONTEXT ('NM3SQL',
                                                              'L2_OFFSET'))
                                      END < ne_length / 2
                                  AND NVL (ne_gty_group_type, '£$%^') =
                                         NVL (nlt_gty_type, '£$%^')
                                  AND ne_id =
                                         TO_NUMBER (
                                            SYS_CONTEXT ('NM3SQL',
                                                         'L2_NE_ID'))
                                  AND TO_NUMBER (
                                         SYS_CONTEXT ('NM3SQL', 'L1_NE_ID')) !=
                                         TO_NUMBER (
                                            SYS_CONTEXT ('NM3SQL',
                                                         'L2_NE_ID'))
                                  AND CASE nnu_node_type
                                         WHEN 'E' THEN nnu_chain
                                         WHEN 'S' THEN 0
                                      END !=
                                         TO_NUMBER (
                                            SYS_CONTEXT ('NM3SQL',
                                                         'L2_OFFSET'))
                                  AND nnu_ne_id = ne_id)) t3);
