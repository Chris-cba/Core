CREATE OR REPLACE FORCE VIEW NM_XSP
(
   NWX_NW_TYPE,
   NWX_X_SECT,
   NWX_NSC_SUB_CLASS,
   NWX_DESCR,
   NWX_SEQ,
   NWX_OFFSET,
   NWX_DATE_CREATED,
   NWX_DATE_MODIFIED,
   NWX_MODIFIED_BY,
   NWX_CREATED_BY
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_xsp.vw-arc   2.3   Apr 13 2018 11:47:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_xsp.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:36:08  $
--       Version          : $Revision:   2.3  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   SELECT nwx_nw_type,
          nwx_x_sect,
          nwx_nsc_sub_class,
          NWX_DESCR,
          NWX_SEQ,
          NWX_OFFSET,
          NWX_DATE_CREATED,
          NWX_DATE_MODIFIED,
          NWX_MODIFIED_BY,
          NWX_CREATED_BY
     FROM nm_nw_xsp
   UNION
   SELECT nng_nt_type,
          nwx_x_sect,
          nwx_nsc_sub_class,
          NWX_DESCR,
          NWX_SEQ,
          NWX_OFFSET,
          NWX_DATE_CREATED,
          NWX_DATE_MODIFIED,
          NWX_MODIFIED_BY,
          NWX_CREATED_BY
     FROM nm_nw_xsp, nm_nt_groupings, nm_group_types
    WHERE ngt_group_type = nng_group_type AND ngt_nt_type = nwx_nw_type;