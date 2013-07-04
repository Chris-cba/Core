CREATE OR REPLACE TRIGGER financial_years_as_trg
   AFTER DELETE OR INSERT OR UPDATE
   ON financial_years
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)financial_years_as_trg.trg	1.1 09/02/05
--       Module Name      : financial_years_as_trg.trg
--       Date into SCCS   : 05/09/02 11:14:04
--       Date fetched Out : 07/06/13 17:02:29
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   hig_tab_fyr.enforce_contiguous_sequence;
END financial_years_as_trg;
/
