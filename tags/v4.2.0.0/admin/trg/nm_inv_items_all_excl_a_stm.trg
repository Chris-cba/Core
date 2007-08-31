CREATE OR REPLACE TRIGGER nm_inv_items_all_excl_a_stm
 AFTER UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_excl_a_stm.trg-arc   2.1   Aug 31 2007 17:14:56   malexander  $
--       Module Name      : $Workfile:   nm_inv_items_all_excl_a_stm.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 17:14:56  $
--       Date fetched Out : $Modtime:   Aug 31 2007 16:19:50  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
--
--   Author : Jonathan Mills
--
--   Exclusivity policing trigger
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3inv.bypass_inv_items_all_trgs
  Then 
    nm3invval.process_excl_check_tab;
    nm3invval.process_update_au_tab;
  End If;
--
END nm_inv_items_all_excl_a_stm;
/

