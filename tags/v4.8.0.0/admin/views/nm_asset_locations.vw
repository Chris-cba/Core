CREATE OR REPLACE FORCE VIEW nm_asset_locations
(
   NAL_ID,
   NAL_NIT_TYPE,
   NAL_ASSET_ID,
   NAL_DESCR,
   NAL_JXP,
   NAL_PRIMARY,
   NAL_LOCATION_TYPE,
   NAL_START_DATE,
   NAL_END_DATE,
   NAL_SECURITY_KEY,
   NAL_DATE_CREATED,
   NAL_DATE_MODIFIED,
   NAL_CREATED_BY,
   NAL_MODIFIED_BY
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_asset_locations.vw-arc   1.1   Jan 02 2019 11:59:36   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_asset_locations.vw  $
--       Date into PVCS   : $Date:   Jan 02 2019 11:59:36  $
--       Date fetched Out : $Modtime:   Jan 02 2019 11:59:00  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
          "NAL_ID",
          "NAL_NIT_TYPE",
          "NAL_ASSET_ID",
          "NAL_DESCR",
          "NAL_JXP",
          "NAL_PRIMARY",
          "NAL_LOCATION_TYPE",
          "NAL_START_DATE",
          "NAL_END_DATE",
          "NAL_SECURITY_KEY",
          "NAL_DATE_CREATED",
          "NAL_DATE_MODIFIED",
          "NAL_CREATED_BY",
          "NAL_MODIFIED_BY"
     FROM nm_asset_locations_all
    WHERE     nal_start_date <=
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
          AND NVL (nal_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
/