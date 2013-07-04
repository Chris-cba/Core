CREATE OR REPLACE TRIGGER nm_ngt_ins_nlt_trg
 AFTER INSERT
 OR UPDATE OF ngt_linear_flag 
 ON NM_GROUP_TYPES_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_ngt_ins_nlt_trg.trg	1.4 12/08/04
--       Module Name      : nm_ngt_ins_nlt_trg.trg
--       Date into SCCS   : 04/12/08 15:17:54
--       Date fetched Out : 07/06/13 17:03:26
--       SCCS Version     : 1.4
--
--
--   Author : Adrian Edwards
--
--   Create NM_LINEAR_TYPES trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
	 
   l_rec_nt			nm_types%ROWTYPE;
   l_rec_nlt		nm_linear_types%ROWTYPE;
   
BEGIN

  IF :NEW.ngt_linear_flag = 'Y'
     AND :NEW.ngt_sub_group_allowed = 'N' THEN
      -- only create one if it doesnt exist
    l_rec_nlt := nm3get.get_nlt(pi_nlt_nt_type     => :NEW.ngt_nt_type
                               ,pi_nlt_gty_type    => :NEW.ngt_group_type
                               ,pi_raise_not_found => FALSE);

    IF l_rec_nlt.nlt_id IS NULL THEN
      l_rec_nt := nm3get.get_nt(pi_nt_type => :NEW.ngt_nt_type);
  
      l_rec_nlt.nlt_id          :=  nm3seq.next_nlt_id_seq;
      l_rec_nlt.nlt_nt_type     := :NEW.ngt_nt_type;
      l_rec_nlt.nlt_gty_type    := :NEW.ngt_group_type;
      l_rec_nlt.nlt_descr       := :NEW.ngt_descr;
      l_rec_nlt.nlt_seq_no      := :NEW.ngt_search_group_no;
      l_rec_nlt.nlt_units       :=  l_rec_nt.nt_length_unit;
      l_rec_nlt.nlt_start_date  := :NEW.ngt_start_date;
      l_rec_nlt.nlt_admin_type  :=  l_rec_nt.nt_admin_type;
      l_rec_nlt.nlt_g_i_d       := 'G';

      nm3ins.ins_nlt(p_rec_nlt => l_rec_nlt);
    END IF;
  ELSIF :NEW.ngt_linear_flag = 'N' AND UPDATING THEN
    -- cannot update record, as it will blow the unique key if this group type becomes linear once more
    nm3del.del_nlt(pi_nlt_nt_type     => :NEW.ngt_nt_type
                  ,pi_nlt_gty_type    => :NEW.ngt_group_type
                  ,pi_raise_not_found => FALSE);

  END IF;
--
END nm_ngt_ins_nlt_trg;
/

