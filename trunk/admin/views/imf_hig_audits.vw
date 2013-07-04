CREATE OR REPLACE FORCE VIEW imf_hig_audits(
        audit_id
       ,audit_description
       ,inv_type
       ,table_name
       ,attribute_name
       ,Primary_key
       ,Old_value
       ,New_value
       ,audit_timestamp
       ,audit_operation
       ,audit_user_id
       ,database_user_name
       ,terminal
       ,operating_system_user_name
) AS    
SELECT        
--            
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--          
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/imf_hig_audits.vw-arc   3.2   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_hig_audits.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:40  $
--       PVCS Version     : $Revision:   3.2  $
--            
--------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
--            
        haud_id
       ,haud_description
       ,haud_nit_inv_type
       ,haud_table_name
       ,haud_attribute_name
       ,haud_pk_id
       ,haud_old_value
       ,haud_new_value
       ,haud_timestamp
       ,Decode(haud_operation,'I','Insert','U','Update','D','Delete')
       ,haud_hus_user_id
       ,hus_name
       ,haud_terminal
       ,haud_os_user
FROm    hig_audits
       ,hig_users
       ,nm_inv_types      
WHERE   haud_hus_user_id = hus_user_id
AND     haud_nit_inv_type   = nit_inv_type
AND     haud_table_name = nit_table_name
AND     1 = hig_audit.security_check(nit_category,nit_table_name,nit_foreign_pk_column,haud_pk_id)
WITH READ ONLY
/


COMMENT ON TABLE imf_hig_audits IS 'Audit Manager foundation view showing details of all the Audits generated';

COMMENT ON COLUMN imf_hig_audits.audit_id IS 'The unique identifier for a Audit';

COMMENT ON COLUMN imf_hig_audits.audit_description IS 'The description of the Audit setup';

COMMENT ON COLUMN imf_hig_audits.inv_type IS 'The meta model type on which the audit is setup';

COMMENT ON COLUMN imf_hig_audits.table_name IS 'The table name of which the audit is created';

COMMENT ON COLUMN imf_hig_audits.attribute_name IS 'The column name of the audited attribute';

COMMENT ON COLUMN imf_hig_audits.Primary_key IS 'The primary key id of the audited table';

COMMENT ON COLUMN imf_hig_audits.Old_value IS 'Old value of the audited attribute';

COMMENT ON COLUMN imf_hig_audits.new_value IS 'New value of the audited attribute';

COMMENT ON COLUMN imf_hig_audits.audit_timestamp IS 'Timestamp of the generated audit';

COMMENT ON COLUMN imf_hig_audits.audit_operation IS 'Audit operation, I = Insert, U = Update, D = Delete';

COMMENT ON COLUMN imf_hig_audits.audit_user_id IS 'Database User Id who generated the audit';

COMMENT ON COLUMN imf_hig_audits.database_user_name IS 'Database User Name who generated the audit';

COMMENT ON COLUMN imf_hig_audits.terminal IS 'Terminal from where the audit was generated';

COMMENT ON COLUMN imf_hig_audits.operating_system_user_name IS 'Operating System User Name who generated the audit';

