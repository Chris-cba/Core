CREATE OR REPLACE TRIGGER nm_inv_items_all_a_dt_trg
       AFTER   INSERT OR UPDATE OF iit_start_date, iit_end_date
       ON      NM_INV_ITEMS_ALL
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_a_dt_trg.trg	1.1 03/01/01
--       Module Name      : nm_inv_items_all_a_dt_trg.trg
--       Date into SCCS   : 01/03/01 16:24:25
--       Date fetched Out : 07/06/13 17:02:52
--       SCCS Version     : 1.1
--
--       TRIGGER nm_inv_items_all_a_dt_trg
--       AFTER   INSERT OR UPDATE OF iit_start_date, iit_end_date
--       ON      NM_INV_ITEMS_ALL
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   IF (UPDATING AND Nm3invval.g_process_update_trigger)
    OR INSERTING
    THEN
      Nm3invval.process_date_chk_tab;
   END IF;
--
END nm_inv_items_all_a_ins_upd;
/
