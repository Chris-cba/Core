CREATE OR REPLACE FORCE VIEW hig_scheduling_intervals_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_scheduling_intervals_v.vw-arc   3.1   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_scheduling_intervals_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:58:18  $
--       Version          : $Revision:   3.1  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
