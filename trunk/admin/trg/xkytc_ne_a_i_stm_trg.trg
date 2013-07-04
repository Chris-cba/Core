CREATE OR REPLACE TRIGGER xkytc_ne_a_i_stm_trg
   AFTER INSERT
   ON nm_elements_all
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xkytc_ne_a_i_stm_trg.trg	1.1 02/02/04
--       Module Name      : xkytc_ne_a_i_stm_trg.trg
--       Date into SCCS   : 04/02/02 16:30:40
--       Date fetched Out : 07/06/13 17:03:54
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Kentucky Create Securing inventory trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   xkytc_create_securing_inv.process_globals;
END xkytc_ne_a_i_stm_trg;
/
