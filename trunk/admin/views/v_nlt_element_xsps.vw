CREATE OR REPLACE FORCE VIEW V_NLT_ELEMENT_XSPS
(
    ELEMENT_ID,
    XSP_ELEMENT_ID,
    XSP_DIRECTION,
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
          --       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/views/v_nlt_element_xsps.vw-arc   1.0   Mar 02 2018 18:32:10   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_nlt_element_xsps.vw  $
          --       Date into PVCS   : $Date:   Mar 02 2018 18:32:10  $
          --       Date fetched Out : $Modtime:   Mar 02 2018 18:30:34  $
          --       PVCS Version     : $Revision:   1.0  $
          --
          --   Author : Rob Coupe
          --
          --   Network types and XSPs.
          --
          -----------------------------------------------------------------------------
          --   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          --         
           nm_ne_id_of    element_id,
           nm_ne_id_in    xsp_element_id,
           nm_cardinality xsp_direction,
           r."ELEMENT_NLT_ID",
           r."XSP_NLT_ID",
           r."ELEMENT_TYPE",
           r."XSP_NT_TYPE",
           r."XSP_GROUP_TYPE",
           r."NWX_NSC_SUB_CLASS",
           r."NWX_X_SECT",
           r."XSP_INHERITANCE",
           r."XRV_NEW_SUB_CLASS",
           r."XRV_NEW_XSP"
      FROM v_nlt_xsp_rvrs r, nm_members, nm_elements
     WHERE     nm_obj_type = xsp_group_type
           AND nm_ne_id_in = ne_id
           AND ne_sub_class = nwx_nsc_sub_class
           AND ne_nt_type = xsp_nt_type
    UNION ALL
    SELECT ne_id,
           ne_id,
           1,
           r."ELEMENT_NLT_ID",
           r."XSP_NLT_ID",
           r."ELEMENT_TYPE",
           r."XSP_NT_TYPE",
           r."XSP_GROUP_TYPE",
           r."NWX_NSC_SUB_CLASS",
           r."NWX_X_SECT",
           r."XSP_INHERITANCE",
           r."XRV_NEW_SUB_CLASS",
           r."XRV_NEW_XSP"
      FROM v_nlt_xsp_rvrs r, nm_elements
     WHERE ne_sub_class = nwx_nsc_sub_class AND ne_nt_type = xsp_nt_type;