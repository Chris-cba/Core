CREATE OR REPLACE TRIGGER nm_job_op_data_value_b_iud_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON nm_job_operation_data_values
  FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_job_op_data_value_b_iud_trg.trg	1.3 07/16/02
--       Module Name      : nm_job_op_data_value_b_iud_trg.trg
--       Date into SCCS   : 02/07/16 16:26:05
--       Date fetched Out : 07/06/13 17:03:10
--       SCCS Version     : 1.3
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_job_op_data_value_b_iud_trg
--     BEFORE INSERT OR UPDATE OR DELETE
--     ON nm_job_operation_data_values
--     FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_njc_rowid             ROWID;
   l_njo_rowid             ROWID;
   c_njo_njc_id   CONSTANT nm_job_operations.njo_njc_job_id%TYPE := NVL(:OLD.njv_njc_job_id,:NEW.njv_njc_job_id);
   c_njo_id       CONSTANT nm_job_operations.njo_id%TYPE         := NVL(:OLD.njv_njo_id,:NEW.njv_njo_id);
--
BEGIN
--
   l_njc_rowid := nm3job.lock_njc (c_njo_njc_id); -- Lock the NM_JOB_CONTROL record
--
   IF NOT DELETING
    THEN -- Do not check the status on delete - this will mutate if this is a cascade delete
      l_njo_rowid := nm3job.lock_njo (pi_njo_njc_job_id => c_njo_njc_id
                                     ,pi_njo_id         => c_njo_id
                                     ); -- Lock the NM_JOB_OPERATIONS record
--
      IF nm3job.get_njo(c_njo_njc_id,c_njo_id).njo_status != nm3job.c_not_started
       THEN
         hig.raise_ner(nm3type.c_net,271);
      END IF;
   END IF;
--
END nm_job_op_data_value_b_iud_trg;
/
