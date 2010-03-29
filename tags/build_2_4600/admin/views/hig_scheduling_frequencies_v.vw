CREATE OR REPLACE FORCE VIEW hig_scheduling_frequencies_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_scheduling_frequencies_v.vw-arc   3.0   Mar 29 2010 17:14:50   gjohnson  $
--       Module Name      : $Workfile:   hig_scheduling_frequencies_v.vw  $
--       Date into PVCS   : $Date:   Mar 29 2010 17:14:50  $
--       Date fetched Out : $Modtime:   Mar 29 2010 17:14:16  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
      hsfr_frequency_id
    , hsfr_meaning
    , lower(hsfr_frequency) hsfr_frequency 
    , hig_process_framework.when_would_job_be_scheduled(hsfr_frequency,sysdate,sysdate) hsfr_next_schedule_date
    , case when hsfr_frequency_id != -1 THEN
           hig_process_framework.when_would_job_be_scheduled(hsfr_frequency,sysdate,hig_process_framework.when_would_job_be_scheduled(hsfr_frequency,sysdate,sysdate)    ) 
           ELSE
             Null
           END  hsfr_subsequent_schedule_date
    ,case when hsfr_frequency_id < 0 THEN
       'Y'
      else
        'N'
      end hsfr_system      
     ,hsfr_interval_in_mins          
from hig_scheduling_frequencies
/                   

COMMENT ON TABLE hig_scheduling_frequencies_v IS 'Exor Process Framework view.  Used in the Process Submission module to present the frequencies in a sensible order i.e. least interval to most'
/                                    