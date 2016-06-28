CREATE OR REPLACE FORCE VIEW EXOR.NM_INV_GEOMETRY
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
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_inv_geometry.vw-arc   1.0   Jun 28 2016 15:55:42   Rob.Coupe  $
   --       Module Name      : $Workfile:   nm_inv_geometry.vw  $
   --       Date into PVCS   : $Date:   Jun 28 2016 15:55:42  $
   --       Date fetched Out : $Modtime:   Jun 28 2016 15:55:06  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Date-tracked view of the aggregated asset geometry data.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
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
