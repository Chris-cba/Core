CREATE OR REPLACE TRIGGER nm_members_all_excl_b_stm
 BEFORE INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
BEGIN
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_excl_b_stm.trg	1.1 09/17/01
--       Module Name      : nm_members_all_excl_b_stm.trg
--       Date into SCCS   : 01/09/17 15:20:22
--       Date fetched Out : 07/06/13 17:03:19
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--
   nm3nwval.clear_tab_excl;
--
END nm_members_all_excl_b_stm;
/
