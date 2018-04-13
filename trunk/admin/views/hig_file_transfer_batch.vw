CREATE OR REPLACE FORCE VIEW hig_file_transfer_batch
(
  hftb_hftq_batch_no
 ,hftb_total
 ,hftb_compl
 ,hftb_error
)
AS
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_file_transfer_batch.vw-arc   3.2   Apr 13 2018 11:47:14   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_file_transfer_batch.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:14  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  SELECT hftl_hftq_batch_no
       , count(*)
       , count(no_compl)
       , count(no_error)
    FROM (SELECT DISTINCT
                 hftl_hftq_batch_no
                ,hftl_hftq_id
                ,hftq_status
                ,hftq_hp_process_id
                ,decode(hftq_status, 'TRANSFER COMPLETE', 'X', NULL) no_compl
                ,decode(hftq_status, 'ERROR', 'X', NULL) no_error
            FROM hig_file_transfer_log, hig_file_transfer_queue
           WHERE hftq_id = hftl_hftq_id)
  GROUP BY hftl_hftq_batch_no
  ORDER BY hftl_hftq_batch_no DESC
/
