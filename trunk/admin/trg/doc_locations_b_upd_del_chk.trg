CREATE OR REPLACE TRIGGER doc_locations_b_upd_del_chk
 BEFORE UPDATE OR DELETE
 ON DOC_LOCATIONS
 FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/doc_locations_b_upd_del_chk.trg-arc   3.1   Jul 04 2013 09:53:16   James.Wadsworth  $
--       Module Name      : $Workfile:   doc_locations_b_upd_del_chk.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:53:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:30  $
--       Version          : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   IF (UPDATING AND :OLD.dlc_location_type = 'TABLE' AND :NEW.dlc_location_type != 'TABLE')
   OR (DELETING AND :OLD.dlc_location_type = 'TABLE')
   THEN
   --
     DELETE FROM doc_location_tables WHERE dlt_dlc_id = :OLD.dlc_id;
   --
   END IF;
--
END doc_locations_b_upd_del_chk;
/
