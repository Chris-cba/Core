DROP VIEW HIGHWAYS.V_NLT_ELEMENT_XSPS;

/* Formatted on 8/1/2018 10:08:30 AM (QP5 v5.256.13226.35538) */
CREATE OR REPLACE FORCE VIEW HIGHWAYS.V_NLT_ELEMENT_XSPS
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
   SELECT                                                                   --
 -----------------------------------------------------------------------------
                                                                            --
                                                      --   PVCS Identifiers :-
                                                                            --
 --       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/views/v_nlt_element_xsps.vw-arc   1.1   Aug 01 2018 11:52:28   Rob.Coupe  $
             --       Module Name      : $Workfile:   v_nlt_element_xsps.vw  $
                  --       Date into PVCS   : $Date:   Aug 01 2018 11:52:28  $
               --       Date fetched Out : $Modtime:   Aug 01 2018 11:51:20  $
                               --       PVCS Version     : $Revision:   1.1  $
                                                                            --
                                                       --   Author : Rob Coupe
                                                                            --
                                                  --   Network types and XSPs.
                                                                            --
 -----------------------------------------------------------------------------
    --   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
 -----------------------------------------------------------------------------
                                                                            --
         nm_ne_id_of element_id,
         nm_ne_id_in xsp_element_id,
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
    FROM v_nlt_xsp_rvrs r, nm_members, nm_elements g, nm_elements e
   WHERE     nm_obj_type = xsp_group_type
         AND nm_ne_id_in = g.ne_id
         AND g.ne_sub_class = nwx_nsc_sub_class
         AND g.ne_nt_type = xsp_nt_type
         AND e.ne_id = nm_ne_id_of
         and r.element_type = e.ne_nt_type
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


CREATE OR REPLACE PUBLIC SYNONYM V_NLT_ELEMENT_XSPS FOR HIGHWAYS.V_NLT_ELEMENT_XSPS;
