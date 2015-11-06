CREATE OR REPLACE TRIGGER nm_members_all_jobs_b_ins_upd 
 BEFORE INSERT OR UPDATE ON nm_members_all
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_jobs_b_ins_upd.trg	1.1 07/17/02
--       Module Name      : nm_members_all_jobs_b_ins_upd.trg
--       Date into SCCS   : 02/07/17 16:12:59
--       Date fetched Out : 07/06/13 17:03:19
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   nm_members_all_jobs_b_ins_upd trigger
--
--     Handles locking of items being operated on by an NM3 job.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3job.check_job_member_lock(pi_nm_type     => :NEW.nm_type
                              ,pi_nm_ne_id_in => :NEW.nm_ne_id_in
                              ,pi_nm_ne_id_of => :NEW.nm_ne_id_of
                              ,pi_nm_obj_type => :NEW.nm_obj_type);
                       
END nm_members_all_jobs_b_ins_upd;
/ 
