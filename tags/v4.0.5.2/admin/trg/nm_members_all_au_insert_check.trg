CREATE OR REPLACE TRIGGER NM_MEMBERS_ALL_AU_INSERT_CHECK
 BEFORE INSERT OR UPDATE ON nm_members_all
 FOR EACH ROW
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_members_all_au_insert_check.trg-arc   2.1   Aug 31 2007 16:26:30   malexander  $
--       Module Name      : $Workfile:   nm_members_all_au_insert_check.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 16:26:30  $
--       Date fetched Out : $Modtime:   Aug 31 2007 15:25:26  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
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
  -- MJA add 31-Aug-07
  -- New functionality to allow override of triggers
  If Not nm3net.bypass_nm_members_trgs
  Then
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
  End If;
END NM_MEMBERS_ALL_AU_INSERT_CHECK;
/
