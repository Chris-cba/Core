CREATE OR REPLACE TRIGGER nm_inv_items_all_excl_b_row
 BEFORE UPDATE
 ON NM_INV_ITEMS_ALL
 FOR EACH ROW
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_excl_b_row.trg-arc   2.3   Jul 04 2013 09:53:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_items_all_excl_b_row.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.3  $
--       Based on 
--
--   Author : Jonathan Mills
--
--   Exclusivity policing trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3inv.bypass_inv_items_all_trgs
  Then 
    nm3invval.pop_excl_check_tab (pi_iit_ne_id    => :NEW.iit_ne_id
                                 ,pi_iit_inv_type => :NEW.iit_inv_type
                                 );
    --
    nm3invval.pop_update_au_tab (pi_iit_ne_id          => :NEW.iit_ne_id
                                ,pi_iit_admin_unit_old => :OLD.iit_admin_unit
                                ,pi_iit_admin_unit_new => :NEW.iit_admin_unit
                                );
    --CWS 20/JULY/2010 0109041
    nm3invval.pop_latest_asset_tab(pi_iit_ne_id          => :NEW.iit_ne_id);
    --
  End If;
--
END nm_inv_items_all_excl_b_row;
/
