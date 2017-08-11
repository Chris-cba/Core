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
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/nm_location_geometry_trg.trg-arc   1.0   Aug 11 2017 13:29:52   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_location_geometry_trg.trg  $
--       Date into PVCS   : $Date:   Aug 11 2017 13:29:52  $
--       Date fetched Out : $Modtime:   Aug 11 2017 13:29:04  $
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
  :new.NLG_ID := NLG_ID_SEQ.nextval;
END NM_LOCATION_GEOMETRY_TRG;
/
