CREATE OR REPLACE TRIGGER nm_members_all_excl_b_row
 BEFORE INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
 FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_members_all_excl_b_row.trg-arc   2.2   Apr 28 2009 10:19:30   lsorathia  $
--       Module Name      : $Workfile:   nm_members_all_excl_b_row.trg  $
--       Date into SCCS   : $Date:   Apr 28 2009 10:19:30  $
--       Date fetched Out : $Modtime:   Apr 27 2009 13:08:00  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   l_rec_excl nm3nwval.rec_excl;
--
BEGIN
  -- MJA add 31-Aug-07
  -- New functionality to allow override of triggers
  If Not nm3net.bypass_nm_members_trgs
  Then
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
       l_rec_excl.nm_start_date                                 := :NEW.nm_start_date; -- LS passed this date in the array for end dating members for exclusive groups
       nm3nwval.g_tab_rec_excl(nm3nwval.g_tab_rec_excl.COUNT+1) := l_rec_excl;
    END IF;
  --
  End If;
END nm_members_all_excl_b_row;
/
