CREATE OR REPLACE TRIGGER nm_job_control_b_ui_trg
  BEFORE INSERT OR UPDATE
  ON nm_job_control
  FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_job_control_b_ui_trg.trg	1.1 07/10/02
--       Module Name      : nm_job_control_b_ui_trg.trg
--       Date into SCCS   : 02/07/10 11:23:38
--       Date fetched Out : 07/06/13 17:03:10
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_job_control_b_ui_trg
--     BEFORE INSERT OR UPDATE
--     ON nm_job_control
--     FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_njc        nm_job_control%ROWTYPE;
   l_check_measures BOOLEAN := FALSE;
--
BEGIN
--
   IF INSERTING
    THEN
      l_check_measures := TRUE;
   ELSIF UPDATING
    THEN
      IF   :OLD.njc_route_ne_id        = :NEW.njc_route_ne_id
       AND :OLD.njc_route_begin_mp     = :NEW.njc_route_begin_mp
       AND :OLD.njc_route_end_mp       = :NEW.njc_route_end_mp
       AND NVL(:OLD.njc_npe_job_id,-1) = NVL(:NEW.njc_npe_job_id,-1)
       THEN
         Null; -- Nothing's changed that we're interested in here
      ELSE
--
         IF :NEW.njc_status != nm3job.c_not_started
          THEN
            -- They have updated one of the location fields once the job is started
            --  Error
            hig.raise_ner(nm3type.c_net,271);
         END IF;
         l_check_measures := TRUE;
      END IF;
--
   END IF;
   IF l_check_measures
    THEN
      l_rec_njc.njc_job_id             := :NEW.njc_job_id;
      l_rec_njc.njc_njt_type           := :NEW.njc_njt_type;
      l_rec_njc.njc_job_descr          := :NEW.njc_job_descr;
      l_rec_njc.njc_status             := :NEW.njc_status;
      l_rec_njc.njc_date_created       := :NEW.njc_date_created;
      l_rec_njc.njc_date_modified      := :NEW.njc_date_modified;
      l_rec_njc.njc_created_by         := :NEW.njc_created_by;
      l_rec_njc.njc_modified_by        := :NEW.njc_modified_by;
      l_rec_njc.njc_route_ne_id        := :NEW.njc_route_ne_id;
      l_rec_njc.njc_route_begin_mp     := :NEW.njc_route_begin_mp;
      l_rec_njc.njc_route_end_mp       := :NEW.njc_route_end_mp;
      l_rec_njc.njc_npe_job_id         := :NEW.njc_npe_job_id;
      l_rec_njc.njc_effective_date     := :NEW.njc_effective_date;
--
      nm3job.validate_njc_mp_against_njo (l_rec_njc);
   END IF;
--
END nm_job_control_b_ui_trg;
/
