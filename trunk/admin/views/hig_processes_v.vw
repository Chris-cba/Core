CREATE OR REPLACE FORCE VIEW hig_processes_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_processes_v.vw-arc   3.1   May 21 2010 10:35:04   gjohnson  $
--       Module Name      : $Workfile:   hig_processes_v.vw  $
--       Date into PVCS   : $Date:   May 21 2010 10:35:04  $
--       Date fetched Out : $Modtime:   May 20 2010 15:06:18  $
--       Version          : $Revision:   3.1  $
-------------------------------------------------------------------------
        hp_process_id
      , hig_process_framework_utils.formatted_process_id(hp_process_id) hp_formatted_process_id
      , hp_process_type_id
      , hpt_name hp_process_type_name
      , hpt_process_limit hp_process_limit
      , hp_initiated_by_username
      , hp_initiated_date
      , hp_initiators_ref
      , hp_job_name
      , hp_job_owner
      , hp_job_owner||'.'||hp_job_name hp_full_job_name 
      , hp_frequency_id
      , b.max_runs
      , b.max_failures
      , hp_success_flag
     , (select hco_meaning from hig_codes where hco_domain = 'PROCESS_SUCCESS_FLAG' and hco_code = hp_success_flag) hp_success_flag_meaning      
      , hp_what_to_call    hp_what_to_call
      , hp_polling_flag
      , hp_area_type
      , (select hpa_description from hig_process_areas where hpa_area_type = hp_area_type) hp_area_type_description
      , hp_area_id
      , hp_area_meaning      
      ,b.job_action         hpj_job_action
      ,b.schedule_type      hpj_schedule_type
      ,b.repeat_interval    hpj_repeat_interval
      ,decode(b.state,'SUCCEEDED','Completed',initcap(b.state))              hpj_job_state
      ,(select count(hpjr_process_id) from hig_process_job_runs where hpjr_process_id = hp_process_id)   hpj_run_count
      ,(select count(hpjr_process_id) from hig_process_job_runs where hpjr_process_id = hp_process_id and hpjr_success_flag = 'N')   hpj_run_failure_count
      ,cast(b.last_start_date as date)    hpj_last_run_date
      ,case when b.state = 'SCHEDULED' then 
                 cast(b.next_run_date   as date)
            else 
                 Null    
            end hpj_next_run_date 
      ,case when b.state IN ('SCHEDULED' 
                            ,'SUCCEEDED'
                            ,'DISABLED') AND (select count(hpjr_process_id) 
                                                from   hig_process_job_runs
                                               where  hpjr_process_id = a.hp_process_id
                                                 AND  hpjr_success_flag = 'N') = 0 THEN
                     'N'
                  ELSE
                     'Y'
                  END hp_requires_attention_flag
      , hpt_internal_module hp_internal_module
      , hpt_internal_module_title hp_internal_module_title
      , hpt_internal_module_param hp_internal_module_param                  
from hig_processes      a
    ,hig_process_types_restricted_v
    ,dba_scheduler_jobs b
where a.hp_job_name = b.job_name(+) -- outer join in case dba_scheduler_jobs records has been purged
and   hpt_process_type_id = hp_process_type_id
/

COMMENT ON TABLE hig_processes_v IS 'Exor Process Framework view.  Show process and job details'
/
