CREATE OR REPLACE FORCE VIEW hig_process_log_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_log_v.vw-arc   3.2   Jul 04 2013 11:20:04   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_process_log_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:53:32  $
--       Version          : $Revision:   3.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hpl_process_id
     , hpl_job_run_seq
     , hpl_log_seq
     , cast( cast( hpl_timestamp AS TIMESTAMP WITH LOCAL TIME ZONE) AS DATE) hpl_date
     , hpl_message_type
     , (select hco_meaning
        from hig_codes
        where hco_domain = 'LOG_MESSAGE_TYPE'
        and  hco_code = hpl_message_type) hpl_message_type_meaning
       ,hpl_summary_flag
     , hpl_message
FROM hig_process_log
/

COMMENT ON TABLE hig_process_log_v IS 'Exor Process Framework view.  Used in the Monitor Process form to show logged messages against the given run of a process.'
/
