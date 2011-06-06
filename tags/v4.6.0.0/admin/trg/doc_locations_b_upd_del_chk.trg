CREATE OR REPLACE TRIGGER doc_locations_b_upd_del_chk
 BEFORE UPDATE OR DELETE
 ON DOC_LOCATIONS
 FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/doc_locations_b_upd_del_chk.trg-arc   3.0   Jun 06 2011 10:00:30   Ade.Edwards  $
--       Module Name      : $Workfile:   doc_locations_b_upd_del_chk.trg  $
--       Date into PVCS   : $Date:   Jun 06 2011 10:00:30  $
--       Date fetched Out : $Modtime:   Jun 06 2011 09:36:06  $
--       Version          : $Revision:   3.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley Systems, 2011
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
