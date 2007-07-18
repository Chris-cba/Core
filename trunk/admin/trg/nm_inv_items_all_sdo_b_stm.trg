CREATE OR REPLACE TRIGGER nm_inv_items_all_sdo_b_stm
 BEFORE INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_sdo_b_stm.trg	1.1 02/28/06
--       Module Name      : nm_inv_items_all_sdo_b_stm.trg
--       Date into SCCS   : 06/02/28 14:04:15
--       Date fetched Out : 07/06/13 17:02:57
--       SCCS Version     : 1.1
--
--   Author  : Ade Edwards
--   Purpose : This trigger is used to cleardown the global array used for
--             XY asset shape regeneration
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
BEGIN
--
  nm3sdo_edit.g_tab_inv.DELETE;
--
END nm_inv_items_all_sdo_b_stm;
/


