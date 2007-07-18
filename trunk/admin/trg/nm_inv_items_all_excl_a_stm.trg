CREATE OR REPLACE TRIGGER nm_inv_items_all_excl_a_stm
 AFTER UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_excl_a_stm.trg	1.2 05/10/02
--       Module Name      : nm_inv_items_all_excl_a_stm.trg
--       Date into SCCS   : 02/05/10 15:57:05
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
BEGIN
--
   nm3invval.process_excl_check_tab;
   nm3invval.process_update_au_tab;
--
END nm_inv_items_all_excl_a_stm;
/

