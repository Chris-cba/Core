CREATE OR REPLACE TRIGGER doc_locations_b_upd_del_chk
 BEFORE UPDATE OR DELETE
 ON DOC_LOCATIONS
 FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/trg/doc_locations_b_upd_del_chk.trg-arc   3.2   Apr 13 2018 11:06:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   doc_locations_b_upd_del_chk.trg  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:06:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:51:58  $
--       Version          : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
