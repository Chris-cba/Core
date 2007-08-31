CREATE OR REPLACE TRIGGER nm_members_b_iu_end_slk_trg
  BEFORE INSERT
   OR    UPDATE OF nm_slk, nm_true, nm_begin_mp, nm_end_mp
   ON    nm_members_all
   FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_members_b_iu_end_slk_trg.trg-arc   2.1   Aug 31 2007 16:26:30   malexander  $
--       Module Name      : $Workfile:   nm_members_b_iu_end_slk_trg.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 16:26:30  $
--       Date fetched Out : $Modtime:   Aug 31 2007 15:26:16  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
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
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
BEGIN
  -- MJA add 31-Aug-07
  -- New functionality to allow override of triggers
  If Not nm3net.bypass_nm_members_trgs
  Then
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
  End If;
END;
/
