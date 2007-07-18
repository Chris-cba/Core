CREATE OR REPLACE TRIGGER nm_inv_types_all_b_stm
 BEFORE INSERT OR UPDATE
 ON nm_inv_types_all
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_types_all_b_stm.trg	1.1 05/14/02
--       Module Name      : nm_inv_types_all_b_stm.trg
--       Date into SCCS   : 02/05/14 09:55:03
--       Date fetched Out : 07/06/13 17:03:08
--       SCCS Version     : 1.1
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
BEGIN
--
   nm3invval.clear_inv_type_chk_tab;
--
END nm_inv_types_all_b_stm;
/
