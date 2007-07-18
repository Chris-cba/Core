CREATE OR REPLACE TRIGGER nm_members_all_excl_b_row
 BEFORE INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_excl_b_row.trg	1.2 09/18/01
--       Module Name      : nm_members_all_excl_b_row.trg
--       Date into SCCS   : 01/09/18 09:12:17
--       Date fetched Out : 07/06/13 17:03:17
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   l_rec_excl nm3nwval.rec_excl;
--
BEGIN
--
   IF :NEW.nm_type = 'G'
    AND (INSERTING
         OR (UPDATING AND (   :NEW.nm_ne_id_in != :OLD.nm_ne_id_in
                           OR :NEW.nm_ne_id_of != :OLD.nm_ne_id_of
                           OR :NEW.nm_begin_mp != :OLD.nm_begin_mp
                           OR :NEW.nm_end_mp   != :OLD.nm_end_mp
                           OR :NEW.nm_type     != :OLD.nm_type
                           OR :NEW.nm_obj_type != :OLD.nm_obj_type
                          )
            )
        )
    THEN
      l_rec_excl.nm_ne_id_in                                   := :NEW.nm_ne_id_in;
      l_rec_excl.nm_ne_id_of                                   := :NEW.nm_ne_id_of;
      l_rec_excl.nm_begin_mp                                   := :NEW.nm_begin_mp;
      l_rec_excl.nm_end_mp                                     := :NEW.nm_end_mp;
      nm3nwval.g_tab_rec_excl(nm3nwval.g_tab_rec_excl.COUNT+1) := l_rec_excl;
   END IF;
--
END nm_members_all_excl_b_row;
/
