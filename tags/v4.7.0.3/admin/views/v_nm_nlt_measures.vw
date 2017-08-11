CREATE OR REPLACE FORCE VIEW v_nm_nlt_measures
(
   NE_ID,
   NE_UNIQUE,
   NE_DESCR,
   START_MEASURE,
   END_MEASURE,
   UNIT_NAME
)
AS
   SELECT --   PVCS Identifiers :-
          --
          --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_nlt_measures.vw-arc   1.0   Aug 11 2017 14:54:00   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_nm_nlt_measures.vw  $
          --       Date into PVCS   : $Date:   Aug 11 2017 14:54:00  $
          --       Date fetched Out : $Modtime:   Aug 07 2017 22:06:18  $
          --       PVCS Version     : $Revision:   1.0  $
          --
          --   Author : R.A. Coupe
          --
          --   View definition script for interim install of Location Bridge
          --
          -----------------------------------------------------------------------------
          -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
          ----------------------------------------------------------------------------
          --
          ne_id,
          ne_unique,
          ne_descr,
          CASE NVL (ne_length, -999)
             WHEN -999
             THEN
                (SELECT MIN (nm_slk)
                   FROM nm_members
                  WHERE nm_ne_id_in = ne_id)
             ELSE
                0
          END
             start_measure,
          CASE NVL (ne_length, -999)
             WHEN -999
             THEN
                (SELECT MAX (nm_end_slk)
                   FROM nm_members
                  WHERE nm_ne_id_in = ne_id)
             ELSE
                ne_length
          END
             end_measure,
          un_unit_name
     FROM nm_elements, v_lb_networktypes
    WHERE     ne_id = TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID'))
          AND ne_nt_type = nt_type
          AND NVL (ne_gty_group_type, '£$%^') = NVL (gty_type, '£$%^')
          AND nlt_g_i_d != 'I'
   UNION ALL
   SELECT iit_ne_id,
          iit_primary_key,
          iit_descr,
          (SELECT MIN (nm_slk)
             FROM nm_members
            WHERE nm_ne_id_in = iit_ne_id),
          (SELECT MAX (nm_end_slk)
             FROM nm_members
            WHERE nm_ne_id_in = iit_ne_id),
          un_unit_name
     FROM nm_inv_items, v_lb_networktypes
    WHERE     iit_ne_id = TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID'))
          AND nt_type = iit_inv_type
          AND gty_type IS NULL
          AND nlt_g_i_d = 'I'
/