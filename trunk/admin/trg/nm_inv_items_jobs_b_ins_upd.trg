CREATE OR REPLACE TRIGGER nm_inv_items_jobs_b_ins_upd 
 BEFORE INSERT OR UPDATE ON nm_inv_items_all
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_jobs_b_ins_upd.trg	1.1 07/17/02
--       Module Name      : nm_inv_items_jobs_b_ins_upd.trg
--       Date into SCCS   : 02/07/17 16:12:39
--       Date fetched Out : 07/06/13 17:03:00
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   nm_inv_items_jobs_b_ins_upd trigger
--
--     Handles locking of items being operated on by an NM3 job.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3job.check_job_inv_item_lock(pi_iit_ne_id => :NEW.iit_ne_id
                                ,pi_inv_type  => :NEW.iit_inv_type);
                       
END nm_members_all_jobs_b_ins_upd;
/
