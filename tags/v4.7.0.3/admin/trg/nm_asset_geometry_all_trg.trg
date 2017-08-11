CREATE OR REPLACE TRIGGER NM_ASSET_GEOMETRY_ALL_TRG
BEFORE INSERT
ON NM_ASSET_GEOMETRY_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/nm_asset_geometry_all_trg.trg-arc   1.0   Aug 11 2017 13:27:26   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_asset_geometry_all_trg.trg  $
--       Date into PVCS   : $Date:   Aug 11 2017 13:27:26  $
--       Date fetched Out : $Modtime:   Aug 11 2017 13:26:54  $
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
  :new.NAG_ID := NAG_ID_SEQ.nextval;
END NM_ASSET_GEOMETRY_ALL_TRG;
/
