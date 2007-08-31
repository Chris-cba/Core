CREATE OR REPLACE TRIGGER nm_inv_items_all_sdo_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_sdo_a_stm.trg-arc   2.1   Aug 31 2007 17:14:56   malexander  $
--       Module Name      : $Workfile:   nm_inv_items_all_sdo_a_stm.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 17:14:56  $
--       Date fetched Out : $Modtime:   Aug 31 2007 16:21:40  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
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


