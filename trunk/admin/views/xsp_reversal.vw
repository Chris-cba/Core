CREATE OR REPLACE FORCE VIEW XSP_REVERSAL
(
   XRV_NW_TYPE,
   XRV_OLD_SUB_CLASS,
   XRV_OLD_XSP,
   XRV_NEW_SUB_CLASS,
   XRV_NEW_XSP,
   XRV_MANUAL_OVERRIDE,
   XRV_DEFAULT_XSP
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/xsp_reversal.vw-arc   2.3   Apr 13 2018 11:47:28   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   xsp_reversal.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:28  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:44:38  $
--       Version          : $Revision:   2.3  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   SELECT XRV_NW_TYPE,
          XRV_OLD_SUB_CLASS,
          XRV_OLD_XSP,
          XRV_NEW_SUB_CLASS,
          XRV_NEW_XSP,
          XRV_MANUAL_OVERRIDE,
          XRV_DEFAULT_XSP
     FROM nm_xsp_reversal
   UNION ALL
   SELECT nng_nt_type,
          XRV_OLD_SUB_CLASS,
          XRV_OLD_XSP,
          XRV_NEW_SUB_CLASS,
          XRV_NEW_XSP,
          XRV_MANUAL_OVERRIDE,
          XRV_DEFAULT_XSP
     FROM nm_nt_groupings, nm_xsp_reversal, nm_group_types
    WHERE xrv_nw_type = ngt_nt_type 
      AND ngt_group_type = nng_group_type;