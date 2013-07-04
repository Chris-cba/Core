CREATE OR REPLACE TRIGGER hig_user_roles_as_trg
   AFTER DELETE OR INSERT OR UPDATE
   ON hig_user_roles
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_user_roles_as_trg.trg	1.1 01/04/05
--       Module Name      : hig_user_roles_as_trg.trg
--       Date into SCCS   : 05/01/04 11:24:34
--       Date fetched Out : 07/06/13 17:02:31
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.process_subuser_hur;
END hig_user_roles_as_trg;
/
