CREATE OR REPLACE FORCE VIEW hig_processes_all_v
(
   HP_PROCESS_ID,
   HP_FORMATTED_PROCESS_ID,
   HP_PROCESS_TYPE_ID,
   HP_PROCESS_TYPE_NAME,
   HP_PROCESS_LIMIT,
   HP_INITIATED_BY_USERNAME,
   HP_INITIATED_DATE,
   HP_INITIATORS_REF,
   HP_JOB_NAME,
   HP_JOB_OWNER,
   HP_FULL_JOB_NAME,
   HP_FREQUENCY_ID,
   MAX_RUNS,
   MAX_FAILURES,
   HP_SUCCESS_FLAG,
   HP_SUCCESS_FLAG_MEANING,
   HP_WHAT_TO_CALL,
   HP_POLLING_FLAG,
   HP_AREA_TYPE,
   HP_AREA_TYPE_DESCRIPTION,
   HP_AREA_ID,
   HP_AREA_MEANING,
   HPJ_JOB_ACTION,
   HPJ_SCHEDULE_TYPE,
   HPJ_REPEAT_INTERVAL,
   HPJ_JOB_STATE,
   HPJ_RUN_COUNT,
   HPJ_RUN_FAILURE_COUNT,
   HPJ_LAST_RUN_DATE,
   HPJ_NEXT_RUN_DATE,
   HP_REQUIRES_ATTENTION_FLAG,
   HP_INTERNAL_MODULE,
   HP_INTERNAL_MODULE_TITLE,
   HP_INTERNAL_MODULE_PARAM
)
AS
   SELECT                                                                   --
        --
        -------------------------------------------------------------------------
        --   PVCS Identifiers :-
        --
        --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_processes_all_v.vw-arc   3.0   Feb 25 2011 14:54:24   Ade.Edwards  $
        --       Module Name      : $Workfile:   hig_processes_all_v.vw  $
        --       Date into PVCS   : $Date:   Feb 25 2011 14:54:24  $
        --       Date fetched Out : $Modtime:   Feb 25 2011 11:02:20  $
        --       Version          : $Revision:   3.0  $
        -------------------------------------------------------------------------
        --
          hp_process_id,
          hig_process_framework_utils.formatted_process_id (hp_process_id)       hp_formatted_process_id,
          hp_process_type_id,
          hpt_name hp_process_type_name,
          hpt_process_limit hp_process_limit,
          hp_initiated_by_username,
          hp_initiated_date,
          hp_initiators_ref,
          hp_job_name,
          hp_job_owner,
          hp_job_owner || '.' || hp_job_name hp_full_job_name,
          hp_frequency_id,
          a.max_runs,
          a.max_failures,
          hp_success_flag,
          (SELECT hco_meaning
             FROM hig_codes
            WHERE hco_domain = 'PROCESS_SUCCESS_FLAG'
                  AND hco_code = hp_success_flag)
             hp_success_flag_meaning,
          hp_what_to_call hp_what_to_call,
          hp_polling_flag,
          hp_area_type,
          (SELECT hpa_description
             FROM hig_process_areas
            WHERE hpa_area_type = hp_area_type)
             hp_area_type_description,
          hp_area_id,
          hp_area_meaning,
          a.job_action hpj_job_action,
          a.schedule_type hpj_schedule_type,
          a.repeat_interval hpj_repeat_interval,
          DECODE (a.state, 'SUCCEEDED', 'Completed', INITCAP (a.state))
             hpj_job_state,
          (SELECT COUNT (hpjr_process_id)
             FROM hig_process_job_runs
            WHERE hpjr_process_id = hp_process_id)
             hpj_run_count,
          (SELECT COUNT (hpjr_process_id)
             FROM hig_process_job_runs
            WHERE hpjr_process_id = hp_process_id AND hpjr_success_flag = 'N')
             hpj_run_failure_count,
          CAST (
             CAST (a.last_start_date AS TIMESTAMP WITH LOCAL TIME ZONE) AS DATE)
             hpj_last_run_date,
          CASE
             WHEN a.state = 'SCHEDULED'
             THEN
                CAST (
                   CAST (a.next_run_date AS TIMESTAMP WITH LOCAL TIME ZONE) AS DATE)
             ELSE
                NULL
          END
             hpj_next_run_date,
          CASE
             WHEN a.state IN ('SCHEDULED', 'SUCCEEDED', 'DISABLED')
                  AND (SELECT COUNT (hpjr_process_id)
                         FROM hig_process_job_runs
                        WHERE hpjr_process_id = c.hp_process_id
                              AND hpjr_success_flag = 'N') = 0 THEN 'N'
             ELSE 'Y'
          END
             hp_requires_attention_flag,
          hpt_internal_module hp_internal_module,
          hpt_internal_module_title hp_internal_module_title,
          hpt_internal_module_param hp_internal_module_param
from dba_scheduler_jobs a
   , hig_users b
   , hig_processes c
   , hig_process_types_v d
where  b.hus_username = a.owner
and  c.hp_job_name = a.job_name(+)
and  d.hpt_process_type_id = c.hp_process_type_id
/
COMMENT ON TABLE HIG_PROCESSES_ALL_V IS 'Exor Process Framework view.  Show process and job details for all processes'
/


