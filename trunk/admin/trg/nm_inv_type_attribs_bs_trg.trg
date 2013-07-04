CREATE OR REPLACE TRIGGER nm_inv_type_attribs_bs_trg
BEFORE DELETE OR INSERT OR UPDATE
ON NM_INV_TYPE_ATTRIBS_ALL

-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_type_attribs_bs_trg.trg	1.1 06/03/05
--       Module Name      : nm_inv_type_attribs_bs_trg.trg
--       Date into SCCS   : 05/06/03 11:41:32
--       Date fetched Out : 07/06/13 17:03:04
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------


BEGIN
  nm3inv.g_tab_ita.DELETE;
END nm_inv_type_attribs_bs_trg;
/
