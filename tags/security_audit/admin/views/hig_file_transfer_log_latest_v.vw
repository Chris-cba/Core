CREATE OR REPLACE FORCE VIEW hig_file_transfer_log_latest_v
AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_file_transfer_log_latest_v.vw-arc   3.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_file_transfer_log_latest_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.3  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
