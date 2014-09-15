CREATE OR REPLACE FORCE VIEW NM_XSP_RELATED_INV_TYPES
(
   NXR_SCREEN_SEQ, 
   NXR_INV_TYPE, 
   NXR_DESCR, 
   NXR_NW_TYPE
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_xsp_related_inv_types.vw-arc   1.0   Sep 15 2014 14:19:20   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_xsp_related_inv_types.vw  $
--       Date into PVCS   : $Date:   Sep 15 2014 14:19:20  $
--       Date fetched Out : $Modtime:   Sep 03 2014 14:50:12  $
--       Version          : $Revision:   1.0  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   SELECT nit_screen_seq,
          nit_inv_type, 
          nit_descr, 
          nin_nw_type
     FROM (SELECT nin_nw_type, nin_nit_inv_code
             FROM nm_inv_nw nin, nm_linear_types
            WHERE nin_nw_type = sys_context('NM3SQL', 'XSP_NW_TYPE' )
              AND nin_nw_type = nlt_nt_type
              AND nlt_g_i_d = 'D'
            UNION ALL
           SELECT nin_nw_type, nin_nit_inv_code
             FROM nm_group_types,
                  nm_nt_groupings,
                  nm_inv_nw nin,
                  nm_types,
                  nm_linear_types
            WHERE ngt_group_type = nng_group_type
              AND nlt_nt_type = nt_type
              AND nlt_gty_type = ngt_group_type
              AND nlt_g_i_d = 'G'
              AND nin_nw_type = nng_nt_type
              AND nt_type = ngt_nt_type
              AND nt_type = sys_context('NM3SQL', 'XSP_NW_TYPE' )),
          nm_inv_types
    WHERE nit_inv_type = nin_nit_inv_code
      AND nit_x_sect_allow_flag = 'Y';
