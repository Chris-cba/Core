CREATE OR REPLACE TRIGGER nm_job_operations_b_iud_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON nm_job_operations
  FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_job_operations_b_iud_trg.trg	1.3 07/10/02
--       Module Name      : nm_job_operations_b_iud_trg.trg
--       Date into SCCS   : 02/07/10 09:09:12
--       Date fetched Out : 07/06/13 17:03:11
--       SCCS Version     : 1.3
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_job_operations_b_iud_trg
--     BEFORE INSERT OR UPDATE OR DELETE
--     ON nm_job_operations
--     FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_njc_rowid             ROWID;
   c_njo_njc_id   CONSTANT nm_job_operations.njo_njc_job_id%TYPE := NVL(:OLD.njo_njc_job_id,:NEW.njo_njc_job_id);
--
   l_check_status          BOOLEAN;
   l_check_measures        BOOLEAN := FALSE;
--
BEGIN
--
   l_njc_rowid := nm3job.lock_njc (c_njo_njc_id);
--
   IF    DELETING
    THEN
      l_check_status   := TRUE;
      l_check_measures := FALSE;
   ELSIF INSERTING
    THEN
      l_check_status   := TRUE;
      l_check_measures := TRUE;
   ELSIF UPDATING
    THEN
      IF   :OLD.njo_njc_job_id       = :NEW.njo_njc_job_id
       AND :OLD.njo_id               = :NEW.njo_id
       AND :OLD.njo_nmo_operation    = :NEW.njo_nmo_operation
       AND :OLD.njo_seq              = :NEW.njo_seq
       AND :OLD.njo_begin_mp         = :NEW.njo_begin_mp
       AND :OLD.njo_end_mp           = :NEW.njo_end_mp
       THEN
         l_check_status := FALSE;
      ELSE
         l_check_status := TRUE;
      END IF;
      IF  :OLD.njo_begin_mp != :NEW.njo_begin_mp
       OR :OLD.njo_end_mp   != :NEW.njo_end_mp
       THEN
         l_check_measures := TRUE;
      END IF;
   END IF;
--
   IF   l_check_status
    AND nm3job.get_njc(c_njo_njc_id).njc_status != nm3job.c_not_started
    THEN
      hig.raise_ner(nm3type.c_net,271);
   END IF;
--
   IF l_check_measures
    THEN
      nm3job.validate_njo_mp_against_njc (pi_njo_begin_mp   => :NEW.njo_begin_mp
                                         ,pi_njo_end_mp     => :NEW.njo_end_mp
                                         ,pi_njo_njc_job_id => c_njo_njc_id
                                         );
   END IF;
--
END nm_job_operations_b_iud_trg;
/
