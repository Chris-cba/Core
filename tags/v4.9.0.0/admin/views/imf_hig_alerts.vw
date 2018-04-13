CREATE OR REPLACE FORCE VIEW imf_hig_alerts(
        Alert_id
       ,Alert_description
       ,inv_type
       ,Primary_key
       ,Alert_subject
       ,Alert_Mail_text
       ,Alert_recipient_type
       ,Alert_Recipient
       ,Alert_Status
       ,Created_date
       ,created_by
       ,modified_date
       ,modified_by
       ) AS    
SELECT        
--            
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--          
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/imf_hig_alerts.vw-arc   3.2   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   imf_hig_alerts.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:32:38  $
--       PVCS Version     : $Revision:   3.2  $
--            
--------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
--       
        hal_id
       ,halt_description
       ,halt_nit_inv_type
       ,hal_pk_id
       ,hal_subject
       ,hal_mail_text
       ,hatr_type
       ,har_recipient_email
       ,har_status
       ,har_date_created
       ,har_created_by
       ,har_date_modified
       ,har_modified_by
FROm    hig_alerts
       ,hig_alert_recipients
       ,hig_alert_types
       ,hig_alert_type_recipients
WHERE   hal_halt_id = halt_id
AND     hal_id      = har_hal_id
AND     har_hatr_id = hatr_id
WITH READ ONLY
/


COMMENT ON TABLE imf_hig_alerts IS 'Alert Manager foundation view showing details of all the Alerts generated';

COMMENT ON COLUMN imf_hig_alerts.alert_id IS 'The unique identifier for a Alert';

COMMENT ON COLUMN imf_hig_alerts.Alert_description IS 'The description of the Alert';

COMMENT ON COLUMN imf_hig_alerts.inv_type IS 'The meta model type on which the Alert is based';

COMMENT ON COLUMN imf_hig_alerts.Primary_key IS 'The Primary key of the Meta Model';

COMMENT ON COLUMN imf_hig_alerts.Alert_subject IS 'Subject of the Alert';

COMMENT ON COLUMN imf_hig_alerts.Alert_Mail_text IS 'The mail body of the Alert';

COMMENT ON COLUMN imf_hig_alerts.Alert_recipient_type IS 'The recipient type of the Alert, To:, CC:, Bcc';

COMMENT ON COLUMN imf_hig_alerts.Alert_Recipient IS 'The email id of the Alert';

COMMENT ON COLUMN imf_hig_alerts.Alert_Status IS 'The status of the Alert, Pending, Running and Completed';

COMMENT ON COLUMN imf_hig_alerts.Created_date IS 'Audit Details';

COMMENT ON COLUMN imf_hig_alerts.created_by IS 'Audit Details';

COMMENT ON COLUMN imf_hig_alerts.modified_date IS 'Audit Details';

COMMENT ON COLUMN imf_hig_alerts.modified_by IS 'Audit Details';


