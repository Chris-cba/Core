CREATE OR REPLACE FORCE VIEW hig_processes_v
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
SELECT 
        --
        -------------------------------------------------------------------------
        --   PVCS Identifiers :-
        --
        --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_processes_v.vw-arc   3.5   Jul 04 2013 11:20:06   James.Wadsworth  $
        --       Module Name      : $Workfile:   hig_processes_v.vw  $
        --       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
        --       Date fetched Out : $Modtime:   Jul 04 2013 10:56:20  $
        --       Version          : $Revision:   3.5  $
        -----------------------------------------------------------------------------
        --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
        -----------------------------------------------------------------------------
        --
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
FROM hig_processes_all_v a 
   , hig_process_type_users_v b -- this adds the restriction in so you can only see processes of a type you are permitted to see
WHERE a.hp_process_type_id = B.HPT_PROCESS_TYPE_ID
AND   b.hus_username = USER
/
COMMENT ON TABLE HIG_PROCESSES_V IS 'Exor Process Framework view.  Show process and job details - but only for process types the user is permitted to see'
/
