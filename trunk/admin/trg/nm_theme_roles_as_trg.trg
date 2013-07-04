CREATE OR REPLACE TRIGGER nm_theme_roles_as_trg
   AFTER DELETE OR INSERT OR UPDATE
   ON nm_theme_roles
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_theme_roles_as_trg.trg	1.1 01/04/05
--       Module Name      : nm_theme_roles_as_trg.trg
--       Date into SCCS   : 05/01/04 11:25:41
--       Date fetched Out : 07/06/13 17:03:35
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.process_subuser_nthr;
END nm_theme_roles_as_trg;
/
