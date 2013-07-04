CREATE OR REPLACE TRIGGER nm_theme_roles_br_trg
   BEFORE DELETE OR INSERT OR UPDATE OF nthr_role, nthr_theme_id
   ON NM_THEME_ROLES
   FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_theme_roles_br_trg.trg	1.3 08/03/05
--       Module Name      : nm_theme_roles_br_trg.trg
--       Date into SCCS   : 05/08/03 11:25:48
--       Date fetched Out : 07/06/13 17:03:35
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   l_nth   NM_THEMES_ALL%ROWTYPE;
BEGIN

   IF NOT Nm3sdm.g_del_theme 
   THEN
     Nm3sdm.g_role_idx := Nm3sdm.g_role_idx + 1;
   END IF;
   
   IF INSERTING
   THEN

      l_nth := Nm3get.get_nth (:NEW.nthr_theme_id);
      IF l_nth.nth_theme_type = Nm3sdo.c_sdo
      THEN
         Nm3sdm.set_subuser_globals_nthr 
           ( :NEW.nthr_role
           , :NEW.nthr_theme_id
           , 'I');
      END IF;
      
   ELSIF UPDATING
   THEN

      l_nth := Nm3get.get_nth (:OLD.nthr_theme_id);
      IF l_nth.nth_theme_type = Nm3sdo.c_sdo
      THEN
         Nm3sdm.set_subuser_globals_nthr 
           ( :OLD.nthr_role
           , :OLD.nthr_theme_id
           , 'D');
      END IF;

      l_nth := Nm3get.get_nth (:NEW.nthr_theme_id);
      IF l_nth.nth_theme_type = Nm3sdo.c_sdo
      THEN
         Nm3sdm.g_role_idx := Nm3sdm.g_role_idx + 1;
         Nm3sdm.set_subuser_globals_nthr 
           ( :NEW.nthr_role
           , :NEW.nthr_theme_id
           , 'I');
      END IF;

   ELSE

      IF NOT Nm3sdm.g_del_theme 
      THEN 
        l_nth := Nm3get.get_nth (:OLD.nthr_theme_id);
        IF l_nth.nth_theme_type = Nm3sdo.c_sdo
        THEN
           Nm3sdm.set_subuser_globals_nthr 
             ( :OLD.nthr_role
             , :OLD.nthr_theme_id
             , 'D');
        END IF;
      END IF;
   END IF;
END nm_theme_roles_br_trg;
/
