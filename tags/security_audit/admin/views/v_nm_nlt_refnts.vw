CREATE OR REPLACE VIEW v_nm_nlt_refnts
AS
   SELECT --   PVCS Identifiers :-
          --
          --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_nlt_refnts.vw-arc   1.0   Aug 11 2017 14:53:02   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_nm_nlt_refnts.vw  $
          --       Date into PVCS   : $Date:   Aug 11 2017 14:53:02  $
          --       Date fetched Out : $Modtime:   Aug 07 2017 22:03:10  $
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
          t.*
     FROM nm_elements, v_nm_nlt_data t
    WHERE     nlt_g_i_d IN ('G', 'D')
          AND ne_nt_type = nt_type
          AND NVL (gty_type, '^%&$') = NVL (ne_gty_group_type, '^%&$')
          AND NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_NLT_ID'), nlt_id) =
                 nlt_id
          AND ne_unique LIKE
                 NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_UNIQUE'), '%')
   UNION ALL
   SELECT iit_ne_id,
          iit_primary_key,
          iit_descr,
          t.*
     FROM nm_inv_items, v_nm_nlt_data t
    WHERE     nlt_g_i_d = 'I'
          AND iit_inv_type = nt_type
          AND gty_type IS NULL
          AND NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_NLT_ID'), nlt_id) =
                 nlt_id
          AND iit_primary_key LIKE
                 NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_UNIQUE'), '%')
/