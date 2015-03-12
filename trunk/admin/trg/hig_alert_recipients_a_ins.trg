--
CREATE OR REPLACE TRIGGER hig_alert_recipients_a_ins
  AFTER INSERT ON HIG_ALERT_RECIPIENTS
       FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/hig_alert_recipients_a_ins.trg-arc   3.2   Mar 12 2015 15:29:28   Shivani.Gaind  $
--       Module Name      : $Workfile:   hig_alert_recipients_a_ins.trg  $
--       Date into PVCS   : $Date:   Mar 12 2015 15:29:28  $
--       Date fetched Out : $Modtime:   Mar 12 2015 15:28:40  $
--       PVCS Version     : $Revision:   3.2  $
--       Based on SCCS version : 
--
--   Author : Chris Baugh
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
CURSOR C_alert_type(pi_hal_id   hig_alerts.hal_id%TYPE) IS 
  SELECT hal_pk_id,
         halt_nit_inv_type
    FROM hig_alert_types,
         hig_alerts
   WHERE halt_id = hal_halt_id
     AND hal_id = pi_hal_id;
     
lv_alert_pk     hig_alerts.hal_pk_id%TYPE;     
lv_alert_type   hig_alert_types.halt_nit_inv_type%TYPE;
   
BEGIN
   OPEN C_alert_type(:NEW.har_hal_id);
   FETCH C_alert_type INTO lv_alert_pk,
                           lv_alert_type;
   CLOSE C_alert_type;
   
   IF lv_alert_type = 'ENQ$'
   THEN
      MERGE INTO doc_history D
           USING (SELECT hal_pk_id, halt_nit_inv_type
                    FROM hig_alert_types, hig_alerts
                   WHERE halt_id = hal_halt_id AND hal_id = :NEW.har_hal_id) S
              ON (    D.dhi_doc_id = S.hal_pk_id
                  AND dhi_date_changed = SYSDATE + .00005)
      WHEN MATCHED
      THEN
         UPDATE SET D.dhi_reason = D.dhi_reason ||', '|| :NEW.har_recipient_email
      WHEN NOT MATCHED
      THEN
         INSERT     (D.dhi_doc_id,
                     D.dhi_date_changed,
                     D.dhi_changed_by,
                     D.dhi_reason)
             VALUES (S.hal_pk_id,
                     SYSDATE + .00005,
                     USER,
                     'email sent to ' || :NEW.har_recipient_email);
					 
     /* INSERT INTO doc_history
        (dhi_doc_id
        ,dhi_date_changed
        ,dhi_changed_by
        ,dhi_reason)
      VALUES
        (lv_alert_pk
        ,sysdate + .00005
        ,user
        ,'email sent to '||:NEW.har_recipient_email);
   */
    END IF;
           
END hig_alert_recipients_a_ins;
/
