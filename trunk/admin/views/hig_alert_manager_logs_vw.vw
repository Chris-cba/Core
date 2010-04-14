CREATE OR REPLACE FORCE VIEW hig_alert_manager_logs_vw
(
 haml_halt_id
,haml_hal_id
,haml_har_id
,haml_nit_inv_type
,haml_descr
,haml_alert_type
,haml_description
,haml_pk_column
,haml_pk_id
,haml_created_date
,haml_email_date_sent
,haml_recipient_email
,haml_subject
,haml_email_body
,haml_status
,haml_comments
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_alert_manager_logs_vw.vw-arc   3.0   Apr 14 2010 10:45:10   malexander  $
--       Module Name      : $Workfile:   hig_alert_manager_logs_vw.vw  $
--       Date into PVCS   : $Date:   Apr 14 2010 10:45:10  $
--       Date fetched Out : $Modtime:   Apr 14 2010 10:44:40  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
-- 
SELECT halt_id
      ,hal_id
      ,har_id
      ,nit_inv_type
      ,nit_descr
      ,DEcode(halt_alert_type,'T','Triggered Events','Q','Scheduled Events') alert_type
      ,halt_description
      ,ita_scrn_text
      ,hal_pk_id
      ,har_date_created
      ,har_date_modified
      ,har_recipient_email
      ,hal_subject
      ,hal_mail_text
      ,har_status
      ,har_comments
from   hig_alerts
      ,hig_alert_recipients
      ,hig_alert_types
      ,nm_inv_types
      ,nm_inv_type_attribs
WHERE  hal_id = har_hal_id
AND    halt_id = hal_halt_id
AND    halt_nit_inv_type = nit_inv_type
and    nit_inv_type = ita_inv_type
AND    nit_foreign_pk_column = ita_attrib_name
/


