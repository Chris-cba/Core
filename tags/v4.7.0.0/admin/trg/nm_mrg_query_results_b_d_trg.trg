CREATE OR REPLACE TRIGGER nm_mrg_query_results_b_d_trg
   BEFORE DELETE
    ON    nm_mrg_query_results_all
   FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_mrg_query_results_b_d_trg.trg	1.1 02/24/04
--       Module Name      : nm_mrg_query_results_b_d_trg.trg
--       Date into SCCS   : 04/02/24 09:46:26
--       Date fetched Out : 07/06/13 17:03:25
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   trigger to delete NM_UPLOAD_FILES records for merge query results records
--    so that stored results don't hang around
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   DELETE FROM nm_upload_files
   WHERE nuf_nufg_table_name = 'NM_MRG_QUERY_RESULTS'
    AND  NUF_NUFGC_COLUMN_VAL_1 = :OLD.nqr_mrg_job_id;
END nm_mrg_query_results_b_d_trg;
/
