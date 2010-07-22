CREATE OR REPLACE TRIGGER nm_inv_items_all_excl_a_stm
 AFTER UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_excl_a_stm.trg-arc   2.2   Jul 22 2010 09:20:24   cstrettle  $
--       Module Name      : $Workfile:   nm_inv_items_all_excl_a_stm.trg  $
--       Date into SCCS   : $Date:   Jul 22 2010 09:20:24  $
--       Date fetched Out : $Modtime:   Jul 20 2010 16:25:12  $
--       SCCS Version     : $Revision:   2.2  $
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
    --CWS 20/JULY/2010 0109041
    nm3invval.process_latest_asset_chk;
    --
    nm3invval.process_excl_check_tab;
    nm3invval.process_update_au_tab;
  End If;
--
END nm_inv_items_all_excl_a_stm;
/

