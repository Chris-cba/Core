CREATE OR REPLACE TRIGGER hig_user_roles_br_trg
   BEFORE DELETE OR INSERT OR UPDATE OF hur_username, hur_role
   ON hig_user_roles
   FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_user_roles_br_trg.trg	1.1 01/04/05
--       Module Name      : hig_user_roles_br_trg.trg
--       Date into SCCS   : 05/01/04 11:25:05
--       Date fetched Out : 07/06/13 17:02:31
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.g_role_idx := nm3sdm.g_role_idx + 1;
   IF INSERTING
   THEN
      nm3sdm.set_subuser_globals_hur
        ( :NEW.hur_role, :NEW.hur_username, 'I');
   ELSIF UPDATING
   THEN
      nm3sdm.set_subuser_globals_hur
        ( :OLD.hur_role, :OLD.hur_username, 'D');

      nm3sdm.g_role_idx := nm3sdm.g_role_idx + 1;

      nm3sdm.set_subuser_globals_hur
        ( :NEW.hur_role, :NEW.hur_username, 'I');
   ELSE
      nm3sdm.set_subuser_globals_hur
        ( :OLD.hur_role, :OLD.hur_username, 'D');
   END IF;
END hig_user_roles_br_trg;
/
