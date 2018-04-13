CREATE OR REPLACE FORCE VIEW hig_process_files_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_process_files_v.vw-arc   3.2   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_process_files_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hpf_file_id
     , hpf_process_id
     , hpf_job_run_seq
     , hpf_filename
     , hpf_destination
     , hpf_destination_type
     , (select hco_meaning from   hig_codes where  hco_domain = 'FILE_DESTINATIONS' and hco_code = hpf_destination_type) hpf_destination_type_meaning    
     , hpf_input_or_output
     , (select hco_meaning from hig_codes where hco_domain = 'FILE_DIRECTION' and hco_code = hpf_input_or_output) hpf_input_or_output_meaning
     , hpf_file_type_id
     , (select hptf_name from hig_process_type_files where hptf_file_type_id = hpf_file_type_id) hpf_file_type_name
     , hpjr_start_date
     , hpjr_end_date
     , hpjr_success_flag  
     , hpjr_success_flag_meaning
FROM hig_process_files
    ,hig_process_job_runs_v
WHERE hpf_process_id = hpjr_process_Id(+) 
AND   hpf_job_run_seq = hpjr_job_run_seq(+)    
/

COMMENT ON TABLE hig_process_files_v IS 'Exor Process Framework view.  Used in the Monitor Process form to show the files attributed to a given process execution'
/
