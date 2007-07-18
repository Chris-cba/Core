CREATE OR REPLACE TRIGGER nm_inv_items_all_del_mem_chk
 BEFORE DELETE
 ON nm_inv_items_all
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_del_mem_chk.trg	1.1 10/01/01
--       Module Name      : nm_inv_items_all_del_mem_chk.trg
--       Date into SCCS   : 01/10/01 11:11:25
--       Date fetched Out : 07/06/13 17:02:54
--       SCCS Version     : 1.1
--
--   TRIGGER nm_inv_items_all_del_mem_chk
--    BEFORE DELETE
--    ON nm_inv_items_all
--    FOR EACH ROW
--
BEGIN
   IF nm3ausec.do_locations_exist( :OLD.iit_ne_id )
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Cannot delete NM_INV_ITEMS_ALL records for which NM_MEMBERS_ALL records exist');
   END IF;
END nm_inv_items_all_del_mem_chk;
/
