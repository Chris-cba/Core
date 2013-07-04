CREATE OR REPLACE TRIGGER nm_theme_roles_bs_trg
   BEFORE DELETE OR INSERT OR UPDATE
   ON nm_theme_roles
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_theme_roles_bs_trg.trg	1.1 01/04/05
--       Module Name      : nm_theme_roles_bs_trg.trg
--       Date into SCCS   : 05/01/04 11:27:07
--       Date fetched Out : 07/06/13 17:03:36
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.g_role_idx := 0;
END nm_theme_roles_bs_trg;
/
