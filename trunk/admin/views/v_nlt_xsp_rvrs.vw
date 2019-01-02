CREATE OR REPLACE FORCE VIEW V_NLT_XSP_RVRS
(
    ELEMENT_NLT_ID,
    XSP_NLT_ID,
    ELEMENT_TYPE,
    XSP_NT_TYPE,
    XSP_GROUP_TYPE,
    NWX_NSC_SUB_CLASS,
    NWX_X_SECT,
    XSP_INHERITANCE,
    XRV_NEW_SUB_CLASS,
    XRV_NEW_XSP
)
AS
    SELECT 
--
          -----------------------------------------------------------------------------
          --
          --   PVCS Identifiers :-
          --
          --       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nlt_xsp_rvrs.vw-arc   1.1   Jan 02 2019 14:16:00   Chris.Baugh  $
          --       Module Name      : $Workfile:   v_nlt_xsp_rvrs.vw  $
          --       Date into PVCS   : $Date:   Jan 02 2019 14:16:00  $
          --       Date fetched Out : $Modtime:   Dec 07 2018 10:17:20  $
          --       PVCS Version     : $Revision:   1.1  $
          --
          --   Author : Rob Coupe
          --
          --   Network types and XSP reversal rules.
          --
          -----------------------------------------------------------------------------
          --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          --     
           x."ELEMENT_NLT_ID",
           x."XSP_NLT_ID",
           x."ELEMENT_TYPE",
           x."XSP_NT_TYPE",
           x."XSP_GROUP_TYPE",
           x."NWX_NSC_SUB_CLASS",
           x."NWX_X_SECT",
           x."XSP_INHERITANCE",
           xrv_new_sub_class,
           xrv_new_xsp
      FROM v_nlt_xsps x, nm_xsp_reversal
     WHERE     xrv_nw_type(+) = xsp_nt_type
           AND xrv_old_sub_class(+) = nwx_nsc_sub_class
           AND xrv_old_xsp(+) = nwx_x_sect;