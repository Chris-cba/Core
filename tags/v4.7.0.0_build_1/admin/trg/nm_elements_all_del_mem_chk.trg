CREATE OR REPLACE TRIGGER nm_elements_all_del_mem_chk
 BEFORE DELETE
 ON nm_elements_all
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_elements_all_del_mem_chk.trg	1.1 10/01/01
--       Module Name      : nm_elements_all_del_mem_chk.trg
--       Date into SCCS   : 01/10/01 11:11:03
--       Date fetched Out : 07/06/13 17:02:43
--       SCCS Version     : 1.1
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--   TRIGGER nm_elements_all_del_mem_chk
--    BEFORE DELETE
--    ON nm_elements_all
--    FOR EACH ROW
--
BEGIN

  IF NOT nm3net.bypass_nm_elements_trgs THEN

       IF nm3ausec.do_locations_exist( :OLD.ne_id )
        THEN
          RAISE_APPLICATION_ERROR(-20001,'Cannot delete NM_ELEMENTS_ALL records for which NM_MEMBERS_ALL records exist');
       END IF;
       
  END IF;
         
END nm_elements_all_del_mem_chk;
/
