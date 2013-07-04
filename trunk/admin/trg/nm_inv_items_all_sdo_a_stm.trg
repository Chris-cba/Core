CREATE OR REPLACE TRIGGER nm_inv_items_all_sdo_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_sdo_a_stm.trg-arc   2.2   Jul 04 2013 09:53:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_items_all_sdo_a_stm.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:38:24  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
--   Author  : Ade Edwards
--   Purpose : This trigger is used to action the regeneration of XY driven
--             asset shapes
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  l_rec_iit nm_inv_items%ROWTYPE;
--
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3inv.bypass_inv_items_all_trgs
  Then 
    IF nm3sdo_edit.g_tab_inv.COUNT > 0
    THEN
      nm3sdo_edit.process_inv_xy_update;
    END IF;
  End If;
--
END nm_inv_items_all_sdo_a_stm;
/


