--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/inv_item_auditing.sql-arc   2.1   Jul 04 2013 10:30:10   James.Wadsworth  $
--       Module Name      : $Workfile:   inv_item_auditing.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:23:36  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
set feedback off
--
INSERT INTO nm_audit_tables
       (nat_table_name
       ,nat_table_alias
       ,nat_audit_insert
       ,nat_audit_update
       ,nat_audit_delete
       )
VALUES ('NM_INV_ITEMS_ALL'
       ,Null
       ,'N'
       ,'Y'
       ,'N'
       );
--
INSERT INTO nm_audit_key_cols
       (nkc_table_name
       ,nkc_seq_no
       ,nkc_column_name
       )
VALUES ('NM_INV_ITEMS_ALL'
       ,1
       ,'IIT_NE_ID'
       );
INSERT INTO nm_audit_key_cols
       (nkc_table_name
       ,nkc_seq_no
       ,nkc_column_name
       )
VALUES ('NM_INV_ITEMS_ALL'
       ,2
       ,'IIT_INV_TYPE'
       );
INSERT INTO nm_audit_key_cols
       (nkc_table_name
       ,nkc_seq_no
       ,nkc_column_name
       )
VALUES ('NM_INV_ITEMS_ALL'
       ,3
       ,'IIT_ADMIN_UNIT'
       );
INSERT INTO nm_audit_key_cols
       (nkc_table_name
       ,nkc_seq_no
       ,nkc_column_name
       )
VALUES ('NM_INV_ITEMS_ALL'
       ,4
       ,'IIT_X_SECT'
       );
INSERT INTO nm_audit_key_cols
       (nkc_table_name
       ,nkc_seq_no
       ,nkc_column_name
       )
VALUES ('NM_INV_ITEMS_ALL'
       ,5
       ,'IIT_PRIMARY_KEY'
       );
INSERT INTO nm_audit_key_cols
       (nkc_table_name
       ,nkc_seq_no
       ,nkc_column_name
       )
VALUES ('NM_INV_ITEMS_ALL'
       ,6
       ,'IIT_FOREIGN_KEY'
       );
--
INSERT INTO nm_audit_columns
      (nac_table_name
      ,nac_column_id
      ,nac_column_name
      )
SELECT table_name
      ,column_id
      ,column_name
 FROM  user_tab_columns
WHERE  table_name IN (SELECT nat_table_name
                       FROM  nm_audit_tables
                     )
 AND   column_name NOT like '%CREATED_BY'
 AND   column_name NOT like '%MODIFIED_BY'
 AND   column_name NOT like '%DATE_CREATED'
 AND   column_name NOT like '%DATE_MODIFIED'
 AND   column_name <> 'IIT_END_DATE';
--
-- Build the auditing triggers
exec nm3audit.build_all_audit_triggers;
-- Build the view for looking at the processed data
exec nm3audit.build_audit_views;
-- Submit the DBMS_JOB to process the data
exec nm3audit.submit_process_job;
--
set feedback on
--
