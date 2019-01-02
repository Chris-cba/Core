CREATE OR REPLACE TRIGGER NM_LOCATION_GEOMETRY_TRG
BEFORE INSERT
ON NM_LOCATION_GEOMETRY
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_location_geometry_trg.trg-arc   1.1   Jan 02 2019 10:08:34   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_location_geometry_trg.trg  $
--       Date into PVCS   : $Date:   Jan 02 2019 10:08:34  $
--       Date fetched Out : $Modtime:   Jan 02 2019 10:08:10  $
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
  :new.NLG_ID := NLG_ID_SEQ.nextval;
END NM_LOCATION_GEOMETRY_TRG;
/
