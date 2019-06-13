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
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_location_geometry_trg.trg-arc   1.2   Jun 13 2019 12:15:38   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_location_geometry_trg.trg  $
--       Date into PVCS   : $Date:   Jun 13 2019 12:15:38  $
--       Date fetched Out : $Modtime:   Jun 13 2019 12:12:22  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  if :new.NLG_ID is NULL then
     :new.NLG_ID := NLG_ID_SEQ.nextval;
  end if;	 
END NM_LOCATION_GEOMETRY_TRG;
/
