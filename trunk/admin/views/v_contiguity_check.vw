CREATE OR REPLACE FORCE VIEW V_CONTIGUITY_CHECK
(
    NE_ID,
    GAP_OVERLAP,
    START_M,
    END_M
)
AS
    WITH
        membs
        AS
            (    SELECT *
                   --   PVCS Identifiers :-
                   --
                   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_contiguity_check.vw-arc   1.4   Jan 24 2019 17:42:56   Rob.Coupe  $
                   --       Module Name      : $Workfile:   v_contiguity_check.vw  $
                   --       Date into PVCS   : $Date:   Jan 24 2019 17:42:56  $
                   --       Date fetched Out : $Modtime:   Jan 24 2019 17:41:32  $
                   --       PVCS Version     : $Revision:   1.4  $
                   --
                   --   Author : R.A. Coupe
                   --
                   --   Date-tracked view of the aggregated asset geometry data.
                   --
                   -----------------------------------------------------------------------------
                   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
                   -----------------------------------------------------------------------------
                   --
                   FROM nm_members
                  WHERE nm_type = 'G'
             CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in AND nm_type = 'G'
             START WITH nm_ne_id_in =
                        TO_NUMBER (
                            SYS_CONTEXT ('NM3SQL', 'CONTIGUOUS_OVER_NE'))),
        datum_membs
        AS ( select rownum rn, m.* from 
            (SELECT nm_ne_id_in,
                    ne_id,
                    ne_length,
                    nm_obj_type,
                    iit_x_sect,
                    nm_begin_mp,
                    nm_end_mp
               FROM (SELECT i.nm_ne_id_in,
                            ne_id,
                            ne_length,
                            ne_nt_type,
                            i.nm_obj_type,
                            iit_x_sect,
                            GREATEST (i.nm_begin_mp, m.nm_begin_mp)
                                nm_begin_mp,
                            LEAST (i.nm_end_mp, m.nm_end_mp)
                                nm_end_mp
                       FROM (SELECT ne_id,
                                    ne_nt_type,
                                    ne_length,
                                    nm_begin_mp,
                                    nm_end_mp
                               FROM membs, nm_elements
                              WHERE ne_id = nm_ne_id_of AND ne_type = 'S') m,
                            nm_members  i,
                            nm_inv_items,
                            nm_inv_types
                      WHERE     i.nm_ne_id_of = ne_id
                            AND i.nm_obj_type =
                                SYS_CONTEXT ('NM3SQL',
                                             'CONTIGUOUS_ASSET_TYPE')
                            AND nm_obj_type = nit_inv_type
                            AND m.nm_end_mp >= i.nm_begin_mp
                            AND i.nm_end_mp >= m.nm_begin_mp
                            AND i.nm_ne_id_in = iit_ne_id
                            --                                             and i.nm_begin_mp <> 0.042
                            AND CASE
                                    WHEN SYS_CONTEXT ('NM3SQL',
                                                      'CONTIGUOUS_XSP')
                                             IS NULL or nit_x_sect_allow_flag = 'N'
                                    THEN
                                        '£$%^'
                                    ELSE
                                        SYS_CONTEXT ('NM3SQL',
                                                     'CONTIGUOUS_XSP')
                                END =
                                CASE
                                    WHEN SYS_CONTEXT ('NM3SQL',
                                                      'CONTIGUOUS_XSP')
                                             IS NULL or nit_x_sect_allow_flag = 'N'
                                    THEN
                                        '£$%^'
                                    ELSE
                                        iit_x_sect
                                END)group by nm_ne_id_in,
                    ne_id,
                    ne_length,
                    nm_obj_type,
                    iit_x_sect,
                    nm_begin_mp,
                    nm_end_mp) m ),
membs_of_interest as ( select q1.*, NVL (
                                          LEAD (nm_begin_mp, 1)
                                              OVER (
                                                  PARTITION BY ne_id,
                                                               nm_obj_type,
                                                               iit_x_sect
                                                  ORDER BY nm_begin_mp asc, nm_end_mp desc),
                                          ne_length)    next_begin,
                                      NVL (
                                          LAG (nm_end_mp, 1)
                                              OVER (
                                                  PARTITION BY ne_id,
                                                               nm_obj_type,
                                                               iit_x_sect
                                                  ORDER BY nm_begin_mp asc, nm_end_mp desc),
                                          0)            prior_end
from (
select a.* from datum_membs a
where not exists ( select 1 from datum_membs b where a.ne_id = b.ne_id and b.nm_begin_mp <= a.nm_begin_mp and b.nm_end_mp >= a.nm_end_mp and a.rn != b.rn )
) q1 ) 
--select * from membs_of_interest order by ne_id, nm_begin_mp
--
      SELECT ne_id,
             GAP_OVERLAP,
             start_m,
             end_m
        FROM (SELECT ne_id,
                     CASE
                         WHEN nm_begin_mp > prior_end THEN 'GAP'
                         ELSE CASE WHEN next_begin > nm_end_mp THEN 'GAP' END
                     END    gap_overlap,
                     CASE gap_type
                         WHEN 'S' THEN nm_end_mp
                         WHEN 'E' THEN prior_end
                     END    start_m,
                     CASE gap_type
                         WHEN 'S' THEN next_begin
                         WHEN 'E' THEN nm_begin_mp
                     END    end_m
                FROM (SELECT 'S'     gap_type,
                             ne_id,
                             ne_length,
                             nm_obj_type,
                             iit_x_sect,
                             nm_begin_mp,
                             nm_end_mp,
                             next_begin,
                             prior_end
                        FROM membs_of_interest
                       WHERE nm_end_mp < next_begin
                      UNION ALL
                      SELECT 'E',
                             ne_id,
                             ne_length,
                             nm_obj_type,
                             iit_x_sect,
                             nm_begin_mp,
                             nm_end_mp,
                             next_begin,
                             prior_end
                        FROM membs_of_interest
                       WHERE nm_begin_mp > prior_end)
               WHERE (prior_end < nm_begin_mp OR next_begin > nm_end_mp))
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
                     CASE gap_type
                         WHEN 'S' THEN nm_end_mp
                         WHEN 'E' THEN prior_end
                     END    start_m,
                     CASE gap_type
                         WHEN 'S' THEN next_begin
                         WHEN 'E' THEN nm_begin_mp
                     END    end_m
                FROM (                
                WITH
                          datum_membs
                          AS ( select rownum rn, m.* from (
                              (SELECT 
                              ne_id,
                                      ne_length,
                                      nm_obj_type,
                                      iit_x_sect,
                                      nm_begin_mp,
                                      nm_end_mp
                                 FROM nm_members,
                                      nm_elements,
                                      nm_inv_items,
                                      nm_inv_types
                                WHERE     nm_type = 'I'
                                      AND nm_ne_id_of =
                                          TO_NUMBER (
                                              SYS_CONTEXT (
                                                  'NM3SQL',
                                                  'CONTIGUOUS_OVER_NE'))
                                      AND ne_id = nm_ne_id_of
                                      AND nm_ne_id_in = iit_ne_id
                                      AND iit_inv_type = nit_inv_type
                                      AND CASE
                                              WHEN    SYS_CONTEXT (
                                                          'NM3SQL',
                                                          'CONTIGUOUS_XSP')
                                                          IS NULL
                                                   OR nit_x_sect_allow_flag =
                                                      'N'
                                              THEN
                                                  '$%^&'
                                              ELSE
                                                  SYS_CONTEXT (
                                                      'NM3SQL',
                                                      'CONTIGUOUS_XSP')
                                          END =
                                          CASE
                                              WHEN    SYS_CONTEXT (
                                                          'NM3SQL',
                                                          'CONTIGUOUS_XSP')
                                                          IS NULL
                                                   OR nit_x_sect_allow_flag =
                                                      'N'
                                              THEN
                                                  '$%^&'
                                              ELSE
                                                  iit_x_sect
                                          END
                                      AND nm_obj_type =
                                          SYS_CONTEXT ('NM3SQL',
                                                       'CONTIGUOUS_ASSET_TYPE')
                                                       group by ne_id,
                                      ne_length,
                                      nm_obj_type,
                                      iit_x_sect,
                                      nm_begin_mp,
                                      nm_end_mp) m )),
membs as ( select q1.*, NVL (
                                          LEAD (nm_begin_mp, 1)
                                              OVER (
                                                  PARTITION BY ne_id,
                                                               nm_obj_type,
                                                               iit_x_sect
                                                  ORDER BY nm_begin_mp asc, nm_end_mp desc),
                                          ne_length)    next_begin,
                                      NVL (
                                          LAG (nm_end_mp, 1)
                                              OVER (
                                                  PARTITION BY ne_id,
                                                               nm_obj_type,
                                                               iit_x_sect
                                                  ORDER BY nm_begin_mp asc, nm_end_mp desc),
                                          0)            prior_end
from (
select a.* from datum_membs a
where not exists ( select 1 from datum_membs b where b.nm_begin_mp <= a.nm_begin_mp and b.nm_end_mp >= a.nm_end_mp and a.rn != b.rn )
) q1 )
                      SELECT 'S'     gap_type,
                             ne_id,
                             ne_length,
                             nm_obj_type,
                             iit_x_sect,
                             nm_begin_mp,
                             nm_end_mp,
                             next_begin,
                             prior_end
                        FROM membs a
                       WHERE nm_end_mp < next_begin
                      UNION ALL
                      SELECT 'E',
                             ne_id,
                             ne_length,
                             nm_obj_type,
                             iit_x_sect,
                             nm_begin_mp,
                             nm_end_mp,
                             next_begin,
                             prior_end
                        FROM membs a
                       WHERE nm_begin_mp > prior_end )
               WHERE (prior_end < nm_begin_mp OR next_begin > nm_end_mp))
    GROUP BY ne_id,
             gap_overlap,
             start_m,
             end_m;
			 