CREATE OR REPLACE TRIGGER nm_inv_items_all_excl_b_stm
 BEFORE UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_excl_b_stm.trg	1.2 05/10/02
--       Module Name      : nm_inv_items_all_excl_b_stm.trg
--       Date into SCCS   : 02/05/10 16:00:41
--       Date fetched Out : 07/06/13 17:02:56
--       SCCS Version     : 1.2
--
--   Author : Jonathan Mills
--
--   Exclusivity policing trigger
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
BEGIN
--
   nm3invval.clear_excl_check_tab;
   nm3invval.clear_update_au_tab;
--
END nm_inv_items_all_excl_b_stm;
/
