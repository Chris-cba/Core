CREATE OR REPLACE FORCE VIEW V_NLT_XSPS
(
    ELEMENT_NLT_ID,
    XSP_NLT_ID,
    ELEMENT_TYPE,
    XSP_NT_TYPE,
    XSP_GROUP_TYPE,
    NWX_NSC_SUB_CLASS,
    NWX_X_SECT,
    XSP_INHERITANCE
)
AS
    SELECT 
	          -----------------------------------------------------------------------------
          --
          --   PVCS Identifiers :-
          --
          --       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/views/v_nlt_xsps.vw-arc   1.1   Mar 02 2018 18:52:56   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_nlt_xsps.vw  $
          --       Date into PVCS   : $Date:   Mar 02 2018 18:52:56  $
          --       Date fetched Out : $Modtime:   Mar 02 2018 18:53:26  $
          --       PVCS Version     : $Revision:   1.1  $
          --
          --   Author : Rob Coupe
          --
          --   Network types and XSP.
          --
          -----------------------------------------------------------------------------
          --   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          --     
	       e.nlt_id        element_nlt_id,
           g.nlt_id        xsp_nlt_id,
           nng_nt_type     element_type,
           ngt_nt_type     xsp_nt_type,
           nng_group_type  xsp_group_type,
           nwx_nsc_sub_class,
           nwx_x_sect,
           'Inherited XSP' XSP_inheritance
      FROM nm_nt_groupings_all,
           nm_group_types,
           nm_nw_xsp,
           nm_linear_types  e,
           nm_linear_types  g
     WHERE     nng_group_type = ngt_group_type
           AND nwx_nw_type = ngt_nt_type
           AND g.nlt_gty_type = ngt_group_type
           AND g.nlt_nt_type = ngt_nt_type
           AND e.nlt_nt_type = nng_nt_type
           AND E.NLT_G_I_D = 'D'
    UNION ALL
    SELECT nlt_id,
           nlt_id,
           nwx_nw_type,
           nwx_nw_type,
           NULL,
           nwx_nsc_sub_class,
           nwx_x_sect,
           'Base XSP'
      FROM nm_nw_xsp, nm_linear_types
     WHERE nlt_nt_type = nwx_nw_type AND nlt_g_i_d = 'D';