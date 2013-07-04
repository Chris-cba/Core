CREATE OR REPLACE TRIGGER nm_nt_groupings_all_a_stm
   AFTER INSERT OR UPDATE ON nm_nt_groupings_all
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nt_groupings_all_a_stm.trg	1.1 06/04/03
--       Module Name      : nm_nt_groupings_all_a_stm.trg
--       Date into SCCS   : 03/06/04 09:04:31
--       Date fetched Out : 07/06/13 17:03:27
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--    nm_nt_groupings_all_a_stm
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3nwval.process_nng_tab;

END nm_nt_groupings_all_a_stm;
/
