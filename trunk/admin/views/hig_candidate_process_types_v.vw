CREATE OR REPLACE FORCE VIEW hig_candidate_process_types_v AS 
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_candidate_process_types_v.vw-arc   3.3   Apr 13 2018 11:47:14   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_candidate_process_types_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:14  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:30:00  $
--       Version          : $Revision:   3.3  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
    job_name
     , replace(job_name,'_',' ') formatted_job_name
     , replace(job_name,'_',' ') job_description
     , job_action  
     ,(select min(hsfr_frequency_id)
      from hig_scheduling_frequencies
      where lower(hsfr_frequency) = lower(repeat_interval)) hsfr_frequency_id
from dba_scheduler_jobs
where owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
and job_name not like 'PROCESS%'
and job_type = 'PLSQL_BLOCK'
and schedule_type = 'CALENDAR'
and not exists (select 'already converted' 
                from   hig_process_types
                where  hpt_name = replace(job_name,'_',' '))
/

COMMENT ON TABLE hig_candidate_process_types_v IS 'Exor Process Framework view.  List of scheduler jobs which are not plugged into the framework'
/
