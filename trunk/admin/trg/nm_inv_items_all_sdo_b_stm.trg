CREATE OR REPLACE TRIGGER nm_inv_items_all_sdo_b_stm
 BEFORE INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_inv_items_all_sdo_b_stm.trg-arc   2.3   Apr 13 2018 11:06:30   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_inv_items_all_sdo_b_stm.trg  $
--       Date into SCCS   : $Date:   Apr 13 2018 11:06:30  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:56:54  $
--       SCCS Version     : $Revision:   2.3  $
--       Based on 
--
--   Author  : Ade Edwards
--   Purpose : This trigger is used to cleardown the global array used for
--             XY asset shape regeneration
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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


