CREATE OR REPLACE VIEW v_lb_nlt_refnts
AS
    SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_lb_nlt_refnts.vw-arc   1.0   Jan 02 2019 12:04:22   Chris.Baugh  $
--       Module Name      : $Workfile:   v_lb_nlt_refnts.vw  $
--       Date into PVCS   : $Date:   Jan 02 2019 12:04:22  $
--       Date fetched Out : $Modtime:   Dec 06 2018 09:52:08  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
           nlt_id,
           ne_id,
           ne_unique,
           ne_descr,
           nt_type,
           nt_descr,
           un_unit_name
      FROM v_lb_networkTypes t, nm_elements
     WHERE     nlt_g_i_d IN ('G', 'D')
           AND ne_nt_type = nt_type
           AND NVL (gty_type, '^%&$') = NVL (ne_gty_group_type, '^%&$')
           AND NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_NLT_ID'), nlt_id) =
                   nlt_id
           AND ne_unique LIKE
                   NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_UNIQUE'), '%')
    UNION ALL
    SELECT nlt_id,
           iit_ne_id,
           iit_primary_key,
           iit_descr,
           nt_type,
           nt_descr,
           un_unit_name
      FROM v_lb_networkTypes t, nm_inv_items
     WHERE     nlt_g_i_d = 'I'
           AND iit_inv_type = nt_type
           AND gty_type IS NULL
           AND NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_NLT_ID'), nlt_id) =
                   nlt_id
           AND iit_primary_key LIKE
                   NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_UNIQUE'), '%')
/