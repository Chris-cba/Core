CREATE OR REPLACE TRIGGER nm_nt_groupings_all_b_stm
   BEFORE INSERT OR UPDATE ON nm_nt_groupings_all
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nt_groupings_all_b_stm.trg	1.1 06/04/03
--       Module Name      : nm_nt_groupings_all_b_stm.trg
--       Date into SCCS   : 03/06/04 09:04:58
--       Date fetched Out : 07/06/13 17:03:28
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--    nm_nt_groupings_all_b_stm
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
BEGIN
  nm3nwval.clear_nng_tab;

END nm_nt_groupings_all_b_stm;
/
