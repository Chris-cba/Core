CREATE OR REPLACE FORCE VIEW V_NM_ELEMENT_XSP
(
    ELEMENT_ID,
    XSP_NE_TYPE,
    XSP_NE_NT_TYPE,
    XSP_GROUP_ID,
    XSP_GROUP_TYPE,
    NGT_NT_TYPE,
    NWX_NSC_SUB_CLASS,
    NWX_X_SECT,
    XSP_DIRECTION_FLAG,
    XSP_INHERITANCE
)
AS
    SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_element_xsp.vw-arc   1.0   Mar 02 2018 16:20:24   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_element_xsp.vw  $
--       Date into PVCS   : $Date:   Mar 02 2018 16:20:24  $
--       Date fetched Out : $Modtime:   Mar 02 2018 16:19:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--   
           nm_ne_id_of     element_id,
           'S'             xsp_ne_type,
           ne_nt_type      xsp_ne_nt_type,
           ne_id           xsp_group_id,
           nng_group_type  xsp_group_type,
           ngt_nt_type,
           nwx_nsc_sub_class,
           nwx_x_sect,
           nm_cardinality  xsp_direction_flag,
           'Inherited XSP' XSP_inheritance
      FROM nm_elements  ne,
           nm_members,
           nm_nt_groupings_all,
           nm_group_types,
           nm_nw_xsp
     WHERE     nng_group_type = ngt_group_type
           AND nwx_nw_type = ngt_nt_type
           AND nm_ne_id_in = ne_id
           AND ngt_group_type = nm_obj_type
           AND ngt_nt_type = nwx_nw_type
           AND nm_type = 'G'
           AND ngt_linear_flag = 'Y'
           AND ne_gty_group_type = nng_group_type
           AND ne_sub_class = nwx_nsc_sub_class
    UNION ALL
    SELECT  /*+INDEX(ne ne_pkxxx) */
           ne_id,
           ne_type,
           ne_nt_type,
           ne_id,
           ne_gty_group_type,
           ne_gty_group_type,
           nwx_nsc_sub_class,
           nwx_x_sect,
           1,
           'Base XSP'
      FROM nm_elements ne, nm_nw_xsp
     WHERE ne_nt_type = nwx_nw_type AND ne_sub_class = nwx_nsc_sub_class;