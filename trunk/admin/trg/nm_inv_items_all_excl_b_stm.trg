CREATE OR REPLACE TRIGGER nm_inv_items_all_excl_b_stm
 BEFORE UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_inv_items_all_excl_b_stm.trg-arc   2.3   Apr 13 2018 11:06:28   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_inv_items_all_excl_b_stm.trg  $
--       Date into SCCS   : $Date:   Apr 13 2018 11:06:28  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:56:54  $
--       SCCS Version     : $Revision:   2.3  $
--       Based on 
--
--   Author : Jonathan Mills
--
--   Exclusivity policing trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3inv.bypass_inv_items_all_trgs
  Then 
    nm3invval.clear_excl_check_tab;
    nm3invval.clear_update_au_tab;
  End If;
--
END nm_inv_items_all_excl_b_stm;
/
