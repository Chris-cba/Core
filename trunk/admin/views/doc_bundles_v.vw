CREATE OR REPLACE FORCE VIEW doc_bundles_v AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/doc_bundles_v.vw-arc   3.3   Apr 13 2018 11:47:14   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   doc_bundles_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:14  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:30:00  $
--       Version          : $Revision:   3.3  $
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
       dbun_bundle_id      
      ,dbun_filename                
      ,dbun_location       
      ,dbun_unzip_location 
      ,dbun_unzip_log     
      ,dbun_date_created              
      ,dbun_date_modified             
      ,dbun_modified_by                
      ,dbun_created_by
      ,dbun_success_flag
      ,(SELECT hco_meaning
          FROM hig_codes
         WHERE hco_domain = 'PROCESS_SUCCESS_FLAG'
           AND hco_code = dbun_success_flag) dbun_success_flag_meaning      
      ,dbun_error_text
      ,dbun_process_id
      ,hig_process_framework_utils.formatted_process_id(dbun_process_id) dbun_formatted_process_id
      ,(select max(dbfr_hftq_batch_no) 
          from doc_bundle_file_relations
              ,doc_bundle_files
          where dbf_bundle_id = dbun_bundle_id
          and   dbfr_child_file_id = dbf_file_id
        ) latest_hftq_batch_no
from doc_bundles
/
comment on table doc_bundles_v is 'To support the bulk document loader'
/
