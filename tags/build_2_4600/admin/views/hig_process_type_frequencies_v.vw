CREATE OR REPLACE FORCE VIEW hig_process_type_frequencies_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_type_frequencies_v.vw-arc   3.0   Mar 29 2010 17:14:52   gjohnson  $
--       Module Name      : $Workfile:   hig_process_type_frequencies_v.vw  $
--       Date into PVCS   : $Date:   Mar 29 2010 17:14:52  $
--       Date fetched Out : $Modtime:   Mar 29 2010 17:14:16  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
  hpfr_process_type_id
, hpfr_frequency_id
, hsfr_meaning
, hsfr_frequency
, hsfr_next_schedule_date
, hsfr_subsequent_schedule_date
, hpfr_seq
FROM hig_process_type_frequencies
    ,hig_scheduling_frequencies_v
WHERE hsfr_frequency_id = hpfr_frequency_id 
/

COMMENT ON TABLE hig_process_type_frequencies_v IS 'Exor Process Framework view. Valid frequencies for process types.'
/