CREATE OR REPLACE FORCE VIEW hig_file_transfer_details
(
  hftd_hftl_id
 ,hftd_hftq_id
 ,hftd_hftq_batch_no
 ,hftd_hftl_date
 ,hftd_source_path
 ,hftd_hftq_source_filename
 ,hftd_destination_path
 ,hftd_hftq_destination_filename
 ,hftd_hftq_status
 ,hftd_hftq_direction
 ,hftd_hftl_message
)
AS
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_file_transfer_details.vw-arc   3.2   Apr 13 2018 11:47:14   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_file_transfer_details.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:14  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  SELECT hftl_id
        ,hftq_id
        ,hftq_batch_no
        ,hftl_date
        ,nvl(s.hdir_path, hftq_source)
        ,hftq_source_filename
        ,nvl(d.hdir_path, hftq_destination)
        ,hftq_destination_filename
        ,hftq_status
        ,hftq_direction
        ,hftl_message
    FROM hig_file_transfer_log
        ,hig_file_transfer_queue
        ,hig_directories s
        ,hig_directories d
   WHERE     hftq_id = hftl_hftq_id
         AND upper(hftq_destination) = upper(d.hdir_name(+))
         AND upper(hftq_source) = upper(s.hdir_name(+))
/
