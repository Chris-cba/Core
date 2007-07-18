CREATE OR REPLACE TRIGGER nm_inv_items_all_excl_b_row
 BEFORE UPDATE
 ON NM_INV_ITEMS_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_excl_b_row.trg	1.2 05/10/02
--       Module Name      : nm_inv_items_all_excl_b_row.trg
--       Date into SCCS   : 02/05/10 15:56:44
--       Date fetched Out : 07/06/13 17:02:55
--       SCCS Version     : 1.2
--
--   Author : Jonathan Mills
--
--   Exclusivity policing trigger
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
BEGIN
--
   nm3invval.pop_excl_check_tab (pi_iit_ne_id    => :NEW.iit_ne_id
                                ,pi_iit_inv_type => :NEW.iit_inv_type
                                );
--
   nm3invval.pop_update_au_tab (pi_iit_ne_id          => :NEW.iit_ne_id
                               ,pi_iit_admin_unit_old => :OLD.iit_admin_unit
                               ,pi_iit_admin_unit_new => :NEW.iit_admin_unit
                               );
--
END nm_inv_items_all_excl_b_row;
/
