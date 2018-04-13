CREATE OR REPLACE FORCE VIEW hig_scheduling_intervals_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_scheduling_intervals_v.vw-arc   3.2   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_scheduling_intervals_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hsfr_frequency_id
      ,hsfr_meaning
      ,hsfr_interval_in_mins
FROM   hig_scheduling_frequencies
WHERE  hsfr_interval_in_mins IS NOT NULL                    
/                   

COMMENT ON TABLE hig_scheduling_intervals_v IS 'Exor Process Framework view.  Returns a sub-set of HIG_SCHEDULING_FREQUENCIES records which are frequencies that can be resolved into an interval in minutes.'
/                                    
