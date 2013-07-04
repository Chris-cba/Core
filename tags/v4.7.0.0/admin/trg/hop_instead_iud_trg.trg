CREATE OR REPLACE TRIGGER hop_instead_iud_trg
   INSTEAD OF INSERT OR UPDATE OR DELETE
   ON hig_options
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hop_instead_iud_trg.trg	1.4 09/04/02
--       Module Name      : hop_instead_iud_trg.trg
--       Date into SCCS   : 02/09/04 10:49:27
--       Date fetched Out : 07/06/13 17:02:34
--       SCCS Version     : 1.4
--
--
--   Author : Jonathan Mills
--
--   hop_instead_iud_trg INSTEAD OF trigger on HIG_OPTIONS
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_hol   hig_option_list%ROWTYPE;
   l_rec_hov   hig_option_values%ROWTYPE;
   l_hol_rowid ROWID;
--
BEGIN
--
   l_rec_hol.hol_id         := :NEW.hop_id;
   l_rec_hol.hol_product    := :NEW.hop_product;
   l_rec_hol.hol_name       := :NEW.hop_name;
   l_rec_hol.hol_remarks    := :NEW.hop_remarks;
   l_rec_hol.hol_domain     := :NEW.hop_domain;
   l_rec_hol.hol_datatype   := :NEW.hop_datatype;
   l_rec_hol.hol_mixed_case := :NEW.hop_mixed_case;
--
   l_rec_hov.hov_id         := :NEW.hop_id;
   l_rec_hov.hov_value      := :NEW.hop_value;
--
   IF INSERTING
    THEN
      -- If inserting then create the new HOL record
      --  and maybe create the new HOV record
      nm3ins.ins_hol (l_rec_hol);
      IF l_rec_hov.hov_value IS NOT NULL
       THEN
         nm3ins.ins_hov (l_rec_hov);
      END IF;
   ELSIF UPDATING
    THEN
      --
      -- Update the HOL record
      --
      l_hol_rowid := nm3lock_gen.lock_hol (pi_hol_id => l_rec_hol.hol_id);
      --
      UPDATE hig_option_list
       SET   hol_id         = l_rec_hol.hol_id -- Trigger will catch this one
            ,hol_product    = l_rec_hol.hol_product
            ,hol_name       = l_rec_hol.hol_name
            ,hol_remarks    = l_rec_hol.hol_remarks
            ,hol_domain     = l_rec_hol.hol_domain
            ,hol_datatype   = l_rec_hol.hol_datatype
            ,hol_mixed_case = l_rec_hol.hol_mixed_case
      WHERE  ROWID          = l_hol_rowid;
      --
      -- If we're updating then delete and then potentially recreate the old hig_option_values record
      --
      nm3del.del_hov (pi_hov_id          => l_rec_hov.hov_id
                     ,pi_raise_not_found => FALSE
                     );
      IF l_rec_hov.hov_value IS NOT NULL
       THEN
         nm3ins.ins_hov (l_rec_hov);
      END IF;
      --
   ELSIF DELETING
    THEN
      --
      -- If deleting then get rid of the HOV record (leave the HOL record)
      --
      nm3del.del_hov (pi_hov_id          => l_rec_hov.hov_id
                     ,pi_raise_not_found => FALSE
                     );
   END IF;
END hop_instead_iud_trg;
/
