CREATE OR REPLACE TRIGGER nm_inv_items_all_sdo_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_sdo_a_stm.trg	1.1 02/28/06
--       Module Name      : nm_inv_items_all_sdo_a_stm.trg
--       Date into SCCS   : 06/02/28 13:57:24
--       Date fetched Out : 07/06/13 17:02:57
--       SCCS Version     : 1.1
--
--   Author  : Ade Edwards
--   Purpose : This trigger is used to action the regeneration of XY driven
--             asset shapes
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
  l_rec_iit nm_inv_items%ROWTYPE;
--
BEGIN
--
  IF nm3sdo_edit.g_tab_inv.COUNT > 0
  THEN
    nm3sdo_edit.process_inv_xy_update;
  END IF;
--
END nm_inv_items_all_sdo_a_stm;
/


