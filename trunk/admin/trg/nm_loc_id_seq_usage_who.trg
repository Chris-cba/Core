CREATE OR REPLACE TRIGGER NM_LOC_ID_SEQ_USAGE_WHO
BEFORE INSERT
ON NM_LOCATIONS_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_loc_id_seq_usage_who.trg-arc   1.1   Jun 13 2019 12:06:58   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_loc_id_seq_usage_who.trg  $
--       Date into PVCS   : $Date:   Jun 13 2019 12:06:58  $
--       Date fetched Out : $Modtime:   Jun 13 2019 12:06:10  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
    IF inserting and :new.NM_LOC_ID is NULL
    THEN
      :new.NM_LOC_ID        := NM_LOC_ID_SEQ.nextval;
   END IF;
--
--
END nm_locations_all_who;
/
