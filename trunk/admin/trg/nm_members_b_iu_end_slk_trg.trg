CREATE OR REPLACE TRIGGER nm_members_b_iu_end_slk_trg
  BEFORE INSERT
   OR    UPDATE OF nm_slk, nm_true, nm_begin_mp, nm_end_mp
   ON    nm_members_all
   FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_b_iu_end_slk_trg.trg	1.1 09/18/02
--       Module Name      : nm_members_b_iu_end_slk_trg.trg
--       Date into SCCS   : 02/09/18 16:58:07
--       Date fetched Out : 07/06/13 17:03:23
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_members_b_iu_end_slk_trg
--    BEFORE INSERT
--     OR    UPDATE OF nm_slk, nm_true, nm_begin_mp, nm_end_mp
--     ON    nm_members_all
--     FOR EACH ROW
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
BEGIN
   nm3nwval.calc_end_slk_and_true (pi_nm_ne_id_in => :NEW.nm_ne_id_in
                                  ,pi_nm_ne_id_of => :NEW.nm_ne_id_of
                                  ,pi_nm_type     => :NEW.nm_type
                                  ,pi_nm_obj_type => :NEW.nm_obj_type
                                  ,pi_nm_slk      => :NEW.nm_slk
                                  ,pi_nm_true     => :NEW.nm_true
                                  ,pi_nm_begin_mp => :NEW.nm_begin_mp
                                  ,pi_nm_end_mp   => :NEW.nm_end_mp
                                  ,po_nm_end_slk  => :NEW.nm_end_slk
                                  ,po_nm_end_true => :NEW.nm_end_true
                                  );
END;
/
