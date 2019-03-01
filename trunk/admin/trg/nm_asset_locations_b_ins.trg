CREATE OR REPLACE TRIGGER NM_ASSET_LOCATIONS_ALL_B_INS
   BEFORE INSERT
   ON NM_ASSET_LOCATIONS_ALL
   REFERENCING NEW AS New OLD AS Old
   FOR EACH ROW
BEGIN
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_asset_locations_b_ins.trg-arc   1.0   Mar 01 2019 16:44:38   Rob.Coupe  $
   --       Module Name      : $Workfile:   nm_asset_locations_b_ins.trg  $
   --       Date into PVCS   : $Date:   Mar 01 2019 16:44:38  $
   --       Date fetched Out : $Modtime:   Mar 01 2019 16:43:06  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : Rob Coupe
   --
   --   Location Bridge trigger script.
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --
   --
      IF :new.NAL_ID IS NULL
      THEN
         :new.NAL_ID := NAL_ID_SEQ.NEXTVAL;
      END IF;

--
END NM_ASSET_LOCATIONS_ALL_B_INS;
/
