CREATE OR REPLACE VIEW v_lb_xsp_list
(
   XSP,
   XSP_DESCR
)
AS
   SELECT                            /* +INDEX( e NE_PK) +CARDINALITY(t 10) */
          --   PVCS Identifiers :-
          --
          --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_lb_xsp_list.vw-arc   1.0   Aug 11 2017 15:01:52   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_lb_xsp_list.vw  $
          --       Date into PVCS   : $Date:   Aug 11 2017 15:01:52  $
          --       Date fetched Out : $Modtime:   Aug 07 2017 22:11:04  $
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
          DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
     FROM nm_elements e,
          nm_xsp_restraints,
          TABLE (lb_get.get_lb_rpt_d_tab (
                    LB_RPT_TAB (
                       LB_RPt (
                          TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID')), --NetworkElementID,
                          TO_NUMBER (
                             SYS_CONTEXT ('NM3SQL', 'NLT_DATA_NLT_ID')), --NetworkTypeId,
                          NULL,
                          NULL,
                          NULL,
                          NULL,
                          1,
                          TO_NUMBER (SYS_CONTEXT ('NMSQL', 'START_MEASURE')), --l_startM,
                          TO_NUMBER (SYS_CONTEXT ('NMSQL', 'END_MEASURE')), --l_endM,
                          NULL)))) t
    WHERE     ne_sub_class = xsr_scl_class
          AND xsr_ity_inv_code = SYS_CONTEXT ('NM3SQL', 'NLT_DATA_INV_TYPE')
          AND xsr_nw_type = ne_nt_type
          AND ne_id = t.refnt
   UNION
   SELECT /*+ INDEX(m NM_OBJ_TYPE_NE_ID_OF_IND) CARDINALITY(t 10)  */
          DISTINCT xsr_x_sect_value, xsr_descr
     FROM nm_elements e,
          nm_members  m,
          nm_xsp_restraints,
          TABLE (lb_get.get_lb_rpt_d_tab (
                    LB_RPT_TAB (
                       LB_RPt (
                          TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID')), --NetworkElementID,
                          TO_NUMBER (
                             SYS_CONTEXT ('NM3SQL', 'NLT_DATA_NLT_ID')), --NetworkTypeId,
                          NULL,
                          NULL,
                          NULL,
                          NULL,
                          1,
                          TO_NUMBER (SYS_CONTEXT ('NMSQL', 'START_MEASURE')), --l_startM,
                          TO_NUMBER (SYS_CONTEXT ('NMSQL', 'END_MEASURE')), --l_endM,
                          NULL)))) t
    WHERE     nm_ne_id_of = refnt
          AND nm_ne_id_in = ne_id
          AND ne_sub_class = xsr_scl_class
          AND xsr_ity_inv_code = SYS_CONTEXT ('NM3SQL', 'NLT_DATA_INV_TYPE')
          AND xsr_nw_type = ne_nt_type
   UNION
   SELECT                            /* +INDEX( e NE_PK) +CARDINALITY(t 10) */
          DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
     FROM nm_elements e, nm_xsp_restraints
    WHERE     ne_sub_class = xsr_scl_class
          AND xsr_ity_inv_code = SYS_CONTEXT ('NM3SQL', 'NLT_DATA_INV_TYPE')
          AND xsr_nw_type = ne_nt_type
          AND ne_id = TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID'))
   UNION ALL
   SELECT /*+ INDEX(m NM_OBJ_TYPE_NE_ID_OF_IND) CARDINALITY(t 10)  */
          DISTINCT xsr_x_sect_value, xsr_descr
     FROM nm_elements e, nm_members m, nm_xsp_restraints
    WHERE     nm_ne_id_of = TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID'))
          AND nm_ne_id_in = ne_id
          AND ne_sub_class = xsr_scl_class
          AND xsr_ity_inv_code = SYS_CONTEXT ('NM3SQL', 'NLT_DATA_INV_TYPE')
          AND xsr_nw_type = ne_nt_type
/