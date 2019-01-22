CREATE OR REPLACE FORCE VIEW V_CONTIGUITY_CHECK
(
    NE_ID,
    GAP_OVERLAP,
    START_M,
    END_M
)
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_contiguity_check.vw-arc   1.2   Jan 22 2019 11:12:32   Chris.Baugh  $
    --       Module Name      : $Workfile:   v_contiguity_check.vw  $
    --       Date into PVCS   : $Date:   Jan 22 2019 11:12:32  $
    --       Date fetched Out : $Modtime:   Jan 22 2019 11:11:48  $
    --       PVCS Version     : $Revision:   1.2  $
    --
    --   Author : R.A. Coupe
    --
    --   Date-tracked view of the aggregated asset geometry data.
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    WITH
        membs
        AS
            (    SELECT *
                   FROM nm_members
                  WHERE nm_type = 'G'
             CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in AND nm_type = 'G'
             START WITH nm_ne_id_in =
                        TO_NUMBER (
                            SYS_CONTEXT ('NM3SQL', 'CONTIGUOUS_OVER_NE')))
      SELECT q4."NE_ID",
             q4."GAP_OVERLAP",
             q4."START_M",
             q4."END_M"
        FROM (SELECT q3.ne_id,
                     CASE
                         WHEN nm_begin_mp > prior_end THEN 'GAP'
                         ELSE CASE WHEN next_begin > nm_end_mp THEN 'GAP' END
                     END    gap_overlap,
                     CASE
                         WHEN nm_begin_mp > prior_end
                         THEN
                             prior_end
                         ELSE
                             CASE
                                 WHEN next_begin > nm_end_mp THEN nm_end_mp
                             END
                     END    start_m,
                     CASE
                         WHEN nm_begin_mp > prior_end
                         THEN
                             nm_begin_mp
                         ELSE
                             CASE
                                 WHEN next_begin > nm_end_mp THEN next_begin
                             END
                     END    end_m
                FROM (SELECT q2.*,
                             CASE
                                 WHEN nm_begin_mp != NVL (prior_end, 0)
                                 THEN
                                     'gap on begin from 0 to ' || nm_begin_mp
                             END    gap_begin,
                             CASE
                                 WHEN nm_end_mp != NVL (next_begin, ne_length)
                                 THEN
                                        'gap on end from '
                                     || nm_end_mp
                                     || ' to '
                                     || NVL (next_begin, ne_length)
                             END    gap_end
                        FROM (SELECT q1.*,
                                     LEAD (nm_begin_mp, 1)
                                         OVER (PARTITION BY ne_id
                                               ORDER BY nm_begin_mp)
                                         next_begin,
                                     NVL (
                                         LAG (nm_end_mp, 1)
                                             OVER (PARTITION BY ne_id
                                                   ORDER BY nm_end_mp),
                                         0)
                                         prior_end
                                FROM (SELECT i.nm_ne_id_in,
                                             ne_id,
                                             ne_length,
                                             ne_nt_type,
                                             i.nm_obj_type,
                                             GREATEST (i.nm_begin_mp,
                                                       m.nm_begin_mp)
                                                 nm_begin_mp,
                                             LEAST (i.nm_end_mp, m.nm_end_mp)
                                                 nm_end_mp
                                        FROM (SELECT ne_id,
                                                     ne_nt_type,
                                                     ne_length,
                                                     nm_begin_mp,
                                                     nm_end_mp
                                                FROM membs, nm_elements
                                               WHERE     ne_id = nm_ne_id_of
                                                     AND ne_type = 'S') m,
                                             nm_members i,
                                             nm_inv_items
                                       WHERE     i.nm_ne_id_of = ne_id
                                             AND i.nm_obj_type =
                                                 SYS_CONTEXT (
                                                     'NM3SQL',
                                                     'CONTIGUOUS_ASSET_TYPE')
                                             AND m.nm_end_mp >= i.nm_begin_mp
                                             AND i.nm_end_mp >= m.nm_begin_mp
                                             AND i.nm_ne_id_in = iit_ne_id
--                                             and i.nm_begin_mp <> 0.042
                                             AND CASE
                                                     WHEN SYS_CONTEXT (
                                                              'NM3SQL',
                                                              'CONTIGUOUS_XSP')
                                                              IS NULL
                                                     THEN
                                                         '£$%^'
                                                     ELSE
                                                         SYS_CONTEXT (
                                                             'NM3SQL',
                                                             'CONTIGUOUS_XSP')
                                                 END =
                                                 CASE
                                                     WHEN SYS_CONTEXT (
                                                              'NM3SQL',
                                                              'CONTIGUOUS_XSP')
                                                              IS NULL
                                                     THEN
                                                         '£$%^'
                                                     ELSE
                                                         iit_x_sect
                                                 END) q1) q2) q3
               WHERE prior_end != nm_begin_mp OR next_begin != nm_end_mp) q4
    GROUP BY ne_id,
             gap_overlap,
             start_m,
             end_m
    UNION ALL
      SELECT ne_id,
             GAP_OVERLAP,
             start_m,
             end_m
        FROM (SELECT ne_id,
                     CASE
                         WHEN nm_begin_mp > prior_end THEN 'GAP'
                         ELSE CASE WHEN next_begin > nm_end_mp THEN 'GAP' END
                     END    gap_overlap,
                     CASE
                         WHEN nm_begin_mp > prior_end
                         THEN
                             prior_end
                         ELSE
                             CASE
                                 WHEN next_begin > nm_end_mp THEN nm_end_mp
                             END
                     END    start_m,
                     CASE
                         WHEN nm_begin_mp > prior_end
                         THEN
                             nm_begin_mp
                         ELSE
                             CASE
                                 WHEN next_begin > nm_end_mp THEN next_begin
                             END
                     END    end_m
                FROM (SELECT ne_id,
                             ne_length,
                             nm_obj_type,
                             iit_x_sect,
                             nm_begin_mp,
                             nm_end_mp,
                             NVL (
                                 LEAD (nm_begin_mp, 1)
                                     OVER (
                                         PARTITION BY nm_ne_id_of,
                                                      nm_obj_type,
                                                      iit_x_sect
                                         ORDER BY nm_begin_mp),
                                 ne_length)    next_begin,
                             NVL (
                                 LAG (nm_end_mp, 1)
                                     OVER (
                                         PARTITION BY nm_ne_id_of,
                                                      nm_obj_type,
                                                      iit_x_sect
                                         ORDER BY nm_begin_mp),
                                 0)            prior_end
                        FROM nm_members, nm_elements, nm_inv_items
                       WHERE     nm_type = 'I'
                             AND nm_ne_id_of =
                                 TO_NUMBER (
                                     SYS_CONTEXT ('NM3SQL',
                                                  'CONTIGUOUS_OVER_NE'))
                             AND ne_id = nm_ne_id_of
                             AND nm_ne_id_in = iit_ne_id
--                             and nm_begin_mp <> 0.042
                             AND CASE
                                     WHEN SYS_CONTEXT ('NM3SQL',
                                                       'CONTIGUOUS_XSP')
                                              IS NULL
                                     THEN
                                         '$%^&'
                                     ELSE
                                         SYS_CONTEXT ('NM3SQL',
                                                      'CONTIGUOUS_XSP')
                                 END =
                                 CASE
                                     WHEN SYS_CONTEXT ('NM3SQL',
                                                       'CONTIGUOUS_XSP')
                                              IS NULL
                                     THEN
                                         '$%^&'
                                     ELSE
                                         iit_x_sect
                                 END
                             AND nm_obj_type =
                                 SYS_CONTEXT ('NM3SQL',
                                              'CONTIGUOUS_ASSET_TYPE'))
               WHERE (prior_end < nm_begin_mp OR next_begin > nm_end_mp))
    GROUP BY ne_id,
             gap_overlap,
             start_m,
             end_m;
			 