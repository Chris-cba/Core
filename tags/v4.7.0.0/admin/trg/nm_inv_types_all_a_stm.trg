CREATE OR REPLACE TRIGGER nm_inv_types_all_a_stm
 AFTER INSERT OR UPDATE
 ON nm_inv_types_all
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_types_all_a_stm.trg	1.1 05/14/02
--       Module Name      : nm_inv_types_all_a_stm.trg
--       Date into SCCS   : 02/05/14 09:55:19
--       Date fetched Out : 07/06/13 17:03:07
--       SCCS Version     : 1.1
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
--
   nm3invval.process_inv_type_chk_tab;
--
END nm_inv_types_all_a_stm;
/

