CREATE OR REPLACE TRIGGER nm_inv_nw_all_b_stm
 BEFORE DELETE OR UPDATE OF nin_end_date
 ON nm_inv_nw_all
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_nw_all_b_stm.trg	1.1 05/14/02
--       Module Name      : nm_inv_nw_all_b_stm.trg
--       Date into SCCS   : 02/05/14 11:22:33
--       Date fetched Out : 07/06/13 17:03:01
--       SCCS Version     : 1.1
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
--
   nm3invval.clear_nm_inv_nw_child_chk_tab;
--
END nm_inv_nw_all_b_stm;
/
