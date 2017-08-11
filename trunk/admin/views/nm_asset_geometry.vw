CREATE OR REPLACE FORCE VIEW NM_ASSET_GEOMETRY
(
   NAG_ID,
   NAG_LOCATION_TYPE,
   NAG_ASSET_ID,
   NAG_OBJ_TYPE,
   NAG_START_DATE,
   NAG_END_DATE,
   NAG_GEOMETRY
)
AS
   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/views/nm_asset_geometry.vw-arc   1.0   Aug 11 2017 15:11:16   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_asset_geometry.vw  $
--       Date into PVCS   : $Date:   Aug 11 2017 15:11:16  $
--       Date fetched Out : $Modtime:   Aug 11 2017 15:10:52  $
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
          "NAG_ID",
          "NAG_LOCATION_TYPE",
          "NAG_ASSET_ID",
          "NAG_OBJ_TYPE",
          "NAG_START_DATE",
          "NAG_END_DATE",
          "NAG_GEOMETRY"
     FROM nm_asset_geometry_all
    WHERE     nag_start_date <=
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
          AND NVL (nag_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY');