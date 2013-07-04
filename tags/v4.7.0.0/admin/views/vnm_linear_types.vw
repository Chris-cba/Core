CREATE OR REPLACE FORCE VIEW vnm_linear_types
       (nlt_type
       ,nlt_descr
       ,nlt_seq_no
       ,nlt_units
       ,nlt_start_date
       ,nlt_end_date
       ,nlt_admin_type
       ,nlt_g_or_i
       ) AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)vnm_linear_types.vw	1.2 12/03/03
--       Module Name      : vnm_linear_types.vw
--       Date into SCCS   : 03/12/03 10:06:28
--       Date fetched Out : 07/06/13 17:08:41
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       ngt_group_type
      ,ngt_descr
      ,ngt_search_group_no
      ,nt_length_unit
      ,ngt_start_date
      ,ngt_end_date
      ,nt_admin_type
      ,'G'
 FROM  nm_group_types
      ,nm_types
WHERE  ngt_nt_type           = nt_type
 AND   nt_linear             = 'Y'
 AND   ngt_sub_group_allowed = 'N'
UNION ALL
SELECT nit_inv_type
      ,nit_descr
      ,nit_screen_seq
      ,1
      ,nit_start_date
      ,nit_end_date
      ,nit_admin_type
      ,'I'
 FROM  nm_inv_types
WHERE  nit_pnt_or_cont = 'C'
 AND   nit_linear      = 'Y'
/
