CREATE OR REPLACE TRIGGER nmid_b_iu_stm_trg
   BEFORE INSERT OR UPDATE
   ON nm_mrg_ita_derivation
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nmid_b_iu_stm_trg.trg	1.1 09/06/05
--       Module Name      : nmid_b_iu_stm_trg.trg
--       Date into SCCS   : 05/09/06 10:24:01
--       Date fetched Out : 07/06/13 17:03:47
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Composite Inventory trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3inv_composite.nmid_b_iu_stm_trg;
END nmid_b_iu_stm_trg;
/
