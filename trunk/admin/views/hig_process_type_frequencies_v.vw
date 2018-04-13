CREATE OR REPLACE FORCE VIEW hig_process_type_frequencies_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_process_type_frequencies_v.vw-arc   3.2   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_process_type_frequencies_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
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
