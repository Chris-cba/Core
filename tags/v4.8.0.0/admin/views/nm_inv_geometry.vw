CREATE OR REPLACE FORCE VIEW NM_INV_GEOMETRY
(
   ASSET_ID,
   ASSET_TYPE,
   START_DATE,
   END_DATE,
   SHAPE
)
AS
   SELECT 
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_inv_geometry.vw-arc   1.2   Apr 26 2018 09:01:30   Gaurav.Gaurkar  $
   --       Module Name      : $Workfile:   nm_inv_geometry.vw  $
   --       Date into PVCS   : $Date:   Apr 26 2018 09:01:30  $
   --       Date fetched Out : $Modtime:   Apr 26 2018 09:00:12  $
   --       PVCS Version     : $Revision:   1.2  $
   --
   --   Author : R.A. Coupe
   --
   --   Date-tracked view of the aggregated asset geometry data.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
          "ASSET_ID",
          "ASSET_TYPE",
          "START_DATE",
          "END_DATE",
          "SHAPE"
     FROM nm_inv_geometry_all
    WHERE     start_date <= (SELECT nm3context.get_effective_date FROM DUAL)
          AND NVL (end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 (SELECT nm3context.get_effective_date FROM DUAL); 
