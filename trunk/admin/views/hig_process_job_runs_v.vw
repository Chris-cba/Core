CREATE OR REPLACE FORCE VIEW hig_process_job_runs_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_job_runs_v.vw-arc   3.2   Jul 04 2013 11:20:04   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_process_job_runs_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:53:16  $
--       Version          : $Revision:   3.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hpjr_process_id
     , hig_process_framework_utils.formatted_process_id (hpjr_process_id) hpjr_formatted_process_id
     , hpjr_job_run_seq
     , hpt_name
     , hp_initiated_by_username
     , hp_initiators_ref
     , cast( cast( hpjr_start AS TIMESTAMP WITH LOCAL TIME ZONE) AS DATE) hpjr_start_date
     , cast( cast( hpjr_end AS TIMESTAMP WITH LOCAL TIME ZONE) AS DATE) hpjr_end_date
     , hpjr_success_flag 
     , (select hco_meaning from hig_codes where hco_domain = 'PROCESS_SUCCESS_FLAG' and hco_code = hpjr_success_flag) hpjr_success_flag_meaning
     , hpjr_additional_info
     , hpjr_internal_reference
     , EXTRACT(DAY FROM hpjr_end-hpjr_start) run_duration_days 
     , EXTRACT(HOUR FROM hpjr_end-hpjr_start) run_duration_hours     
     , EXTRACT(MINUTE FROM hpjr_end-hpjr_start) run_duration_mins     
     , EXTRACT(SECOND FROM hpjr_end-hpjr_start) run_duration_secs
FROM hig_process_job_runs
    ,hig_processes
    ,hig_process_types
WHERE hp_process_id = hpjr_process_id
AND   hpt_process_type_id = hp_process_type_id    
/

COMMENT ON TABLE hig_process_job_runs_v IS 'Exor Process Framework view.  Used in the Monitor Process form to show details of the execution(s) of a given process '
/
