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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/xsp_reversal.vw-arc   2.2   Sep 15 2014 14:37:24   Chris.Baugh  $
--       Module Name      : $Workfile:   xsp_reversal.vw  $
--       Date into PVCS   : $Date:   Sep 15 2014 14:37:24  $
--       Date fetched Out : $Modtime:   Sep 03 2014 14:10:00  $
--       Version          : $Revision:   2.2  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
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