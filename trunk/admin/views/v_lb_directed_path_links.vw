CREATE OR REPLACE FORCE VIEW V_LB_DIRECTED_PATH_LINKS
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
   WITH recursive_path (path_seq,
                        ne_id,
                        ne_no_start,
                        ne_no_end,
                        ne_length,
                        cum_length,
                        dir_flag)
        AS (SELECT
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_lb_directed_path_links.vw-arc   1.1   Jan 02 2019 14:14:06   Chris.Baugh  $
--       Module Name      : $Workfile:   v_lb_directed_path_links.vw  $
--       Date into PVCS   : $Date:   Jan 02 2019 14:14:06  $
--       Date fetched Out : $Modtime:   Dec 07 2018 10:19:00  $
--       Version          : $Revision:   1.1  $
--------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------
----
                   p.path_seq,
                   p.ne_id,
                   p.ne_no_start,
                   p.ne_no_end,
                   p.ne_length,
                   p.cum_length,
                   p.dir_flag
              FROM v_lb_path_links p
             WHERE path_seq = 1
            UNION ALL
            SELECT c.path_seq,
                   c.ne_id,
                   c.ne_no_start,
                   c.ne_no_end,
                   c.ne_length,
                   c.cum_length,
                   CASE p.dir_flag
                      WHEN 1
                      THEN
                         CASE
                            WHEN p.ne_no_end = c.ne_no_start THEN 1
                            WHEN p.ne_no_end = c.ne_no_end THEN -1
                            ELSE 0
                         END
                      WHEN -1
                      THEN
                         CASE
                            WHEN p.ne_no_start = c.ne_no_start THEN 1
                            WHEN p.ne_no_start = c.ne_no_end THEN -1
                            ELSE 0
                         END
                      ELSE
                         0
                   END
                      dir_flag
              FROM recursive_path p, v_lb_path_links c
             WHERE c.path_seq = p.path_seq + 1)
   SELECT "PATH_SEQ",
          "NE_ID",
          "NE_NO_START",
          "NE_NO_END",
          "NE_LENGTH",
          "CUM_LENGTH",
          "DIR_FLAG"
     FROM recursive_path;
