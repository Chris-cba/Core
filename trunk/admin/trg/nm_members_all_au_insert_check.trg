CREATE OR REPLACE TRIGGER NM_MEMBERS_ALL_AU_INSERT_CHECK
 BEFORE INSERT OR UPDATE ON nm_members_all
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_au_insert_check.trg	1.4 09/14/01
--       Module Name      : nm_members_all_au_insert_check.trg
--       Date into SCCS   : 01/09/14 14:02:32
--       Date fetched Out : 07/06/13 17:03:16
--       SCCS Version     : 1.4
--
--   TRIGGER NM_MEMBERS_ALL_AU_INSERT_CHECK
--    BEFORE INSERT OR UPDATE ON nm_members_all
--    FOR EACH ROW
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   l_rec_each_nm nm3ausec.rec_each_nm;
--
BEGIN
--
   l_rec_each_nm.nm_ne_id_in       := :NEW.nm_ne_id_in;
   l_rec_each_nm.nm_ne_id_of       := :NEW.nm_ne_id_of;
   l_rec_each_nm.nm_admin_unit_old := :OLD.nm_admin_unit;
   l_rec_each_nm.nm_begin_mp_old   := :OLD.nm_begin_mp;
   l_rec_each_nm.nm_end_mp_old     := :OLD.nm_end_mp;
   l_rec_each_nm.nm_admin_unit_new := :NEW.nm_admin_unit;
   l_rec_each_nm.nm_begin_mp_new   := :NEW.nm_begin_mp;
   l_rec_each_nm.nm_end_mp_new     := :NEW.nm_end_mp;
   l_rec_each_nm.nm_type_new       := :NEW.nm_type;
--
   IF inserting
    THEN
      l_rec_each_nm.trigger_mode   := nm3type.c_inserting;
   ELSE
      l_rec_each_nm.trigger_mode   := nm3type.c_updating;
   END IF;
--
   nm3ausec.check_each_nm_row (l_rec_each_nm);
--
END NM_MEMBERS_ALL_AU_INSERT_CHECK;
/
