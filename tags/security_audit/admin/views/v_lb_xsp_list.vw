CREATE OR REPLACE VIEW v_lb_xsp_list
(
   XSP,
   XSP_DESCR
)
AS
   SELECT                            /* +INDEX( e NE_PK) +CARDINALITY(t 10) */
          --   PVCS Identifiers :-
          --
          --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_lb_xsp_list.vw-arc   1.2   Jan 02 2019 12:05:16   Chris.Baugh  $
          --       Module Name      : $Workfile:   v_lb_xsp_list.vw  $
          --       Date into PVCS   : $Date:   Jan 02 2019 12:05:16  $
          --       Date fetched Out : $Modtime:   Jan 02 2019 12:04:54  $
          --       PVCS Version     : $Revision:   1.2  $
          --
          --   Author : R.A. Coupe
          --
          --   View definition script for interim install of Location Bridge
          --
          -----------------------------------------------------------------------------
          -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
                          TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'START_MEASURE')), --l_startM,
                          TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'END_MEASURE')), --l_endM,
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
                          TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'START_MEASURE')), --l_startM,
                          TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'END_MEASURE')), --l_endM,
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
          AND SYS_CONTEXT('NM3SQL', 'START_MEASURE') is NULL
          AND SYS_CONTEXT('NM3SQL', 'END_MEASURE') is NULL
   UNION ALL
   SELECT /*+ INDEX(m NM_OBJ_TYPE_NE_ID_OF_IND) CARDINALITY(t 10)  */
          DISTINCT xsr_x_sect_value, xsr_descr
     FROM nm_elements e, nm_members m, nm_xsp_restraints
    WHERE     nm_ne_id_of = TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID'))
          AND nm_ne_id_in = ne_id
          AND ne_sub_class = xsr_scl_class
          AND xsr_ity_inv_code = SYS_CONTEXT ('NM3SQL', 'NLT_DATA_INV_TYPE')
          AND xsr_nw_type = ne_nt_type
          AND SYS_CONTEXT('NM3SQL', 'START_MEASURE') is NULL
          AND SYS_CONTEXT('NM3SQL', 'END_MEASURE') is NULL
/