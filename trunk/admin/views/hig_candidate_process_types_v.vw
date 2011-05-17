CREATE OR REPLACE FORCE VIEW hig_candidate_process_types_v AS 
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_candidate_process_types_v.vw-arc   3.1   May 17 2011 08:32:42   Steve.Cooper  $
--       Module Name      : $Workfile:   hig_candidate_process_types_v.vw  $
--       Date into PVCS   : $Date:   May 17 2011 08:32:42  $
--       Date fetched Out : $Modtime:   Apr 04 2011 10:22:36  $
--       Version          : $Revision:   3.1  $
-------------------------------------------------------------------------
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