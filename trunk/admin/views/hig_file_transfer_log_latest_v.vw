CREATE OR REPLACE FORCE VIEW hig_file_transfer_log_latest_v
AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_file_transfer_log_latest_v.vw-arc   3.1   Jul 04 2013 11:20:04   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_file_transfer_log_latest_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:51:20  $
--       Version          : $Revision:   3.1  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

--
   hftl_date
 , hftl_id
 , hftl_hftq_id
 , hftl_hftq_batch_no
 , hftl_filename
 , hftl_destination_path
 , hftl_message
      FROM  (SELECT 
                   hftl_date
                 , hftl_id
                 , hftl_hftq_id
                 , hftl_hftq_batch_no
                 , hftl_filename
                 , hftl_destination_path
                 , hftl_message
                 , DENSE_RANK () OVER   ( PARTITION BY hftl_hftq_id ORDER BY hftl_id DESC) ranking
               FROM hig_file_transfer_log) ranked_records
WHERE ranked_records.ranking = 1
/                                                
COMMENT ON TABLE hig_file_transfer_log_latest_v IS 'To support hig file transfer functionality.  This view return the latest log entry for a file to transfer'
/
