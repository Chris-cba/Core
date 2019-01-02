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
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_asset_geometry_all_trg.trg-arc   1.1   Jan 02 2019 10:07:36   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_asset_geometry_all_trg.trg  $
--       Date into PVCS   : $Date:   Jan 02 2019 10:07:36  $
--       Date fetched Out : $Modtime:   Jan 02 2019 10:07:14  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  :new.NAG_ID := NAG_ID_SEQ.nextval;
END NM_ASSET_GEOMETRY_ALL_TRG;
/
