CREATE OR REPLACE TRIGGER V_NM_MEMBERS_I_TRG
 INSTEAD OF INSERT
 ON V_NM_MEMBERS
 FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/trg/v_nm_members_i_trg.trg-arc   2.3   Apr 13 2018 11:06:58   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_nm_members_i_trg.trg  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:06:58  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:02:38  $
--       Version          : $Revision:   2.3  $
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
 l_rec_nm nm_members%ROWTYPE;
BEGIN
 l_rec_nm.nm_ne_id_in     := :NEW.nm_ne_id_in;
 l_rec_nm.nm_ne_id_of     := :NEW.nm_ne_id_of;
 l_rec_nm.nm_type         := :NEW.nm_type;
 l_rec_nm.nm_obj_type     := :NEW.nm_obj_type;
 l_rec_nm.nm_begin_mp     := :NEW.nm_begin_mp;
 l_rec_nm.nm_start_date   := :NEW.nm_start_date;
 l_rec_nm.nm_end_date     := :NEW.nm_end_date;
 l_rec_nm.nm_end_mp       := :NEW.nm_end_mp;
 l_rec_nm.nm_slk          := :NEW.nm_slk;
 l_rec_nm.nm_cardinality  := :NEW.nm_cardinality;
 l_rec_nm.nm_admin_unit   := :NEW.nm_admin_unit;
 l_rec_nm.nm_seq_no       := :NEW.nm_seq_no;
 l_rec_nm.nm_seg_no       := :NEW.nm_seg_no;
 l_rec_nm.nm_true         := :NEW.nm_true;
 l_rec_nm.nm_end_slk      := :NEW.nm_end_slk;
 l_rec_nm.nm_end_true     := :NEW.nm_end_true;

 nm3ins.ins_nm(l_rec_nm);
END;
/
