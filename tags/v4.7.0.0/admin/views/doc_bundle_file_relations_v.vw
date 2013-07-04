CREATE OR REPLACE FORCE VIEW doc_bundle_file_relations_v AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/doc_bundle_file_relations_v.vw-arc   3.1   Jul 04 2013 11:20:02   James.Wadsworth  $
--       Module Name      : $Workfile:   doc_bundle_file_relations_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:02  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:40:48  $
--       Version          : $Revision:   3.1  $
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
----
          dbfr_relationship_id
        , dbfr_driving_file_id
        , b.dbf_filename dbfr_driving_filename
        , dbfr_driving_file_recno
        , dbfr_child_file_id
        , dbfr_doc_title
        , dbfr_doc_descr
        , dbfr_doc_type
        , dbfr_dlc_name
        , dbfr_gateway_table_name
        , dbfr_x_coordinate
        , dbfr_y_coordinate
        , dbfr_rec_id
        , dbfr_doc_id
        , dbfr_doc_filename
        , dbfr_hftq_batch_no
        , case when dbfr_error_text is not null then
                 dbfr_error_text
               when hftq_status = 'ERROR' THEN
                 hftl_message  
               else
                 null
               end create_or_transfer_error_text   
from doc_bundle_file_relations a
    ,doc_bundle_files  b    
    ,hig_file_transfer_queue c
    ,hig_file_transfer_log_latest_v d
where   a.dbfr_driving_file_id = b.dbf_file_id
and   c.hftq_batch_no(+) = a.dbfr_hftq_batch_no
and   c.hftq_destination_filename(+) = a.dbfr_doc_filename
and   d.hftl_hftq_id(+) = c.hftq_id         
/
comment on table doc_bundle_file_relations_v is 'To support the bulk document loader'
/

            
            
