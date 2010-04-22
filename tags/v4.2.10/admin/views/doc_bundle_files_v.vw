CREATE OR REPLACE FORCE VIEW doc_bundle_files_v AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/doc_bundle_files_v.vw-arc   3.0   Apr 22 2010 11:35:48   gjohnson  $
--       Module Name      : $Workfile:   doc_bundle_files_v.vw  $
--       Date into PVCS   : $Date:   Apr 22 2010 11:35:48  $
--       Date fetched Out : $Modtime:   Apr 22 2010 11:35:12  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
       dbf_file_id
     , dbf_bundle_id
     , dbf_filename
     , dbf_driving_file_flag
     , dbf_blob
     , appearances_in_driving_files
     , count_docs_created
     , count_files_transferred
      ,case when appearances_in_driving_files = 0 and dbf_driving_file_flag = 'N' then
            'Filename Not in Driving File'
            when dbf_file_included_with_bundle = 'N' then
            'File Not Found'            
            when count_docs_created != appearances_in_driving_files then
            'Document Creation failed'
            when count_files_transferred != count_docs_created then
            'File Transfer failed'
            else 
            'Success'
            end error_text
      ,case when appearances_in_driving_files = 0 and dbf_driving_file_flag = 'N' then
            1
            when dbf_file_included_with_bundle = 'N' then
            2            
            when count_docs_created != appearances_in_driving_files then
            3
            when count_files_transferred != count_docs_created then
            4
            else 
             Null
            end error_stage                           
from
(
select dbf_file_id
     , dbf_bundle_id
     , dbf_filename
     , dbf_driving_file_flag
     , dbf_file_included_with_bundle
     , dbf_blob
     , (select count(*) from doc_bundle_file_relations
        where dbfr_child_file_id = dbf_file_id) appearances_in_driving_files
     , (select count(*) from doc_bundle_file_relations
        where dbfr_child_file_id = dbf_file_id
        and   dbfr_doc_id is not null) count_docs_created
     , (select count(*) from doc_bundle_file_relations
                             ,hig_file_transfer_queue 
        where dbfr_child_file_id = dbf_file_id
        and   hftq_batch_no = dbfr_hftq_batch_no
        and   hftq_destination_filename = dbfr_doc_filename
        and   hftq_status = 'TRANSFER COMPLETE') count_files_transferred                  
from doc_bundle_files
)
/
comment on table doc_bundle_files_v is 'To support the bulk document loader'
/