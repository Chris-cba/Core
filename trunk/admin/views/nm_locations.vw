CREATE OR REPLACE FORCE VIEW NM_LOCATIONS
(
   NM_NE_ID_OF,
   NM_LOC_ID,
   NM_OBJ_TYPE,
   NM_NE_ID_IN,
   NM_BEGIN_MP,
   NM_START_DATE,
   NM_END_DATE,
   NM_END_MP,
   NM_TYPE,
   NM_SLK,
   NM_DIR_FLAG,
   NM_SECURITY_ID,
   NM_SEQ_NO,
   NM_SEG_NO,
   NM_TRUE,
   NM_END_SLK,
   NM_END_TRUE,
   NM_X_SECT_ST,
   NM_OFFSET_ST,
   NM_UNIQUE_PRIMARY,
   NM_PRIMARY,
   NM_STATUS,
   TRANSACTION_ID,
   NM_DATE_CREATED,
   NM_DATE_MODIFIED,
   NM_MODIFIED_BY,
   NM_CREATED_BY,
   NM_X_SECT_END,
   NM_OFFSET_END,
   NM_FACTOR
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/nm_locations.vw-arc   1.0   Aug 11 2017 15:09:42   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_locations.vw  $
--       Date into PVCS   : $Date:   Aug 11 2017 15:09:42  $
--       Date fetched Out : $Modtime:   Aug 07 2017 22:08:20  $
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
          "NM_NE_ID_OF",
          "NM_LOC_ID",
          "NM_OBJ_TYPE",
          "NM_NE_ID_IN",
          "NM_BEGIN_MP",
          "NM_START_DATE",
          "NM_END_DATE",
          "NM_END_MP",
          "NM_TYPE",
          "NM_SLK",
          "NM_DIR_FLAG",
          "NM_SECURITY_ID",
          "NM_SEQ_NO",
          "NM_SEG_NO",
          "NM_TRUE",
          "NM_END_SLK",
          "NM_END_TRUE",
          "NM_X_SECT_ST",
          "NM_OFFSET_ST",
          "NM_UNIQUE_PRIMARY",
          "NM_PRIMARY",
          "NM_STATUS",
          "TRANSACTION_ID",
          "NM_DATE_CREATED",
          "NM_DATE_MODIFIED",
          "NM_MODIFIED_BY",
          "NM_CREATED_BY",
          "NM_X_SECT_END",
          "NM_OFFSET_END",
          "NM_FACTOR"
     FROM nm_locations_all
    WHERE     nm_start_date <=
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
          AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
/                          