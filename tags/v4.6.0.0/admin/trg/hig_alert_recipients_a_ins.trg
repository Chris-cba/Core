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
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/hig_alert_recipients_a_ins.trg-arc   3.0   Jan 17 2011 09:11:14   Mike.Alexander  $
--       Module Name      : $Workfile:   hig_alert_recipients_a_ins.trg  $
--       Date into PVCS   : $Date:   Jan 17 2011 09:11:14  $
--       Date fetched Out : $Modtime:   Jan 17 2011 09:10:58  $
--       PVCS Version     : $Revision:   3.0  $
--       Based on SCCS version : 
--
--   Author : Chris Baugh
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
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
   
      INSERT INTO doc_history
        (dhi_doc_id
        ,dhi_date_changed
        ,dhi_changed_by
        ,dhi_reason)
      VALUES
        (lv_alert_pk
        ,sysdate + .00005
        ,user
        ,'email sent to '||:NEW.har_recipient_email);
   
    END IF;
           
END hig_alert_recipients_a_ins;
/
