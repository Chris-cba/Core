CREATE OR REPLACE TRIGGER nm_inv_items_all_sdo_b_stm
 BEFORE INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_sdo_b_stm.trg-arc   2.2   Jul 04 2013 09:53:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_items_all_sdo_b_stm.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:38:34  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
--   Author  : Ade Edwards
--   Purpose : This trigger is used to cleardown the global array used for
--             XY asset shape regeneration
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3inv.bypass_inv_items_all_trgs
  Then 
    nm3sdo_edit.g_tab_inv.DELETE;
  End If;
--
END nm_inv_items_all_sdo_b_stm;
/


