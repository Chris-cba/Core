CREATE OR REPLACE PACKAGE BODY hig_alert
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--3
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_alert.pkb-arc   3.16   Jul 25 2011 10:18:14   linesh.sorathia  $
--       Module Name      : $Workfile:   hig_alert.pkb  $
--       Date into PVCS   : $Date:   Jul 25 2011 10:18:14  $
--       Date fetched Out : $Modtime:   Jul 25 2011 10:17:16  $
--       Version          : $Revision:   3.16  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid   CONSTANT varchar2(2000) := '$Revision:   3.16  $';

  c_date_format   CONSTANT varchar2(30) := 'DD-Mon-YYYY HH24:MI:SS';
  g_trigger_text  clob;
  --g_trigger_text1 Varchar2(32767) ;  

  g_package_name CONSTANT varchar2(30) := 'hig_alert';
  
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
FUNCTION replaceClob(pi_clob         IN CLOB,
                     pi_search_for   IN varchar2,
                     pi_replace_with IN varchar2 )
RETURN CLOB 
IS          
--
   l_buffer     VARCHAR2(29000);
   l_buffer_new VARCHAR2(32767);
   l_amount BINARY_INTEGER := 29000;
   l_pos INTEGER := 1;
   l_clob_len INTEGER;
   newClob clob := EMPTY_CLOB;   
BEGIN 
--
   dbms_lob.CreateTemporary( newClob, TRUE ); 
   l_clob_len := DBMS_LOB.getlength (pi_clob);
   WHILE l_pos < l_clob_len
   LOOP  
       dbms_lob.read(pi_clob,l_amount,l_pos,l_buffer);
       IF l_buffer IS NOT NULL
       THEN
       -- replace the text
          l_buffer_new := Replace(l_buffer,pi_search_for,pi_replace_with);
          -- write it to the new clob
          dbms_lob.writeappend(newClob, LENGTH(l_buffer_new), l_buffer_new);
       END IF;
       l_pos :=   l_pos + l_amount;   
   END LOOP;  
   RETURN newClob;    
END replaceClob;
--
Procedure derive_meaning(pi_inv_type    IN  nm_inv_type_attribs.ita_inv_type%TYPE
                        ,pi_attrib_name IN  nm_inv_type_attribs.ita_attrib_name%TYPE
                        ,pi_value       IN  Varchar2
                        ,po_meaning     OUT Varchar2)
IS
--
   l_ita_rec       nm_inv_type_attribs%ROWTYPE; 
   l_ial_rec       nm_inv_attri_lookup_all%ROWTYPE;
   l_value         Varchar2(100);
--
BEGIN
--
   l_ita_rec := nm3get.get_ita(pi_ita_inv_type    => pi_inv_type
                              ,pi_ita_attrib_name => pi_attrib_name);
       
   IF l_ita_rec.ita_id_domain IS NOT NULL
   THEN
       l_ial_rec := nm3get.get_ial(pi_ial_domain => l_ita_rec.ita_id_domain
                                  ,pi_ial_value  => pi_value);
       po_meaning := l_ial_rec.ial_meaning ;
   ELSIF l_ita_rec.ita_query IS NOT NULL
   THEN
       BEGIN
          nm3inv.validate_flex_inv(p_inv_type               => pi_inv_type
                                  ,p_attrib_name            => pi_attrib_name
                                  ,pi_value                 => pi_value
                                  ,po_value                 => l_value
                                  ,po_meaning               => po_meaning
                                  ,pi_validate_domain_dates => FALSE);
       EXCEPTION
       WHEN OTHERS THEN 
           Null ;
       END ;
   ELSE
       po_meaning := pi_value ;
   END IF ;
--
END derive_meaning;
--
FUNCTION get_hal(pi_hal_id IN hig_alerts.hal_id%TYPE) 
RETURN hig_alerts%ROWTYPE
IS
--
   CURSOR c_get_hal
   IS
   SELECT * 
   FROM   hig_alerts
   WHERE  hal_id = pi_hal_id;
   l_hal_rec hig_alerts%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_hal;
   FETCH c_get_hal INTO l_hal_rec;
   CLOSE c_get_hal;

   RETURN l_hal_rec ;
--
END get_hal;
--
PROCEDURE upd_hal_status(pi_hal_id IN hig_alerts.hal_id%TYPE
                      ,pi_status IN hig_alerts.hal_status%TYPE)
IS   
BEGIN
--
   UPDATE hig_alerts
   SET    hal_status = pi_status
   WHERE  hal_id     = pi_hal_id;  
--
END upd_hal_status;
--
--
PROCEDURE upd_har_status(pi_har_id    IN hig_alert_recipients.har_id%TYPE DEFAULT NULL
                        ,pi_hal_id    IN hig_alerts.hal_id%TYPE           DEFAULT NULL
                        ,pi_status    IN hig_alert_recipients.har_status%TYPE
                        ,pi_comments  IN hig_alert_recipients.har_comments%TYPE DEfault Null)
IS   
BEGIN
--
   IF pi_har_id IS NOT NULL
   THEN
       UPDATE hig_alert_recipients
       SET    har_status    = pi_status
             ,har_comments  = pi_comments
       WHERE  har_id        = pi_har_id   ;
   ELSE
       UPDATE hig_alert_recipients
       SET    har_status    = pi_status
             ,har_comments  = pi_comments
       WHERE  har_hal_id    = pi_hal_id   ;
   END IF ;       
--
END upd_har_status;
--
PROCEDURE send_mail(pi_hal_id      IN hig_alerts.hal_id%TYPE           DEFAULT NULL
                   ,pi_har_id      IN hig_alert_recipients.har_id%TYPE DEFAULT NULL
                   ,pi_from_screen IN Varchar2 DEFAULT 'N' )
IS
-- 
   l_har_rec          hig_alert_recipients%ROWTYPE ;  
   l_hal_rec          hig_alerts%ROWTYPE ;
   l_hatm_rec         hig_alert_type_mail%ROWTYPE ;
   l_halt_rec         hig_alert_types%ROWTYPE ;
   l_hael_rec         hig_alert_error_logs%ROWTYPE;
   l_hatr_rec         hig_alert_type_recipients%ROWTYPE ;
   l_to_recipient     Varchar2(32767);
   l_cc_recipient     Varchar2(32767);
   l_bcc_recipient    Varchar2(32767);
   l_send_mail_status Boolean;
   l_error_text       Varchar2(2000);
   l_attachment       Blob ;
   l_att_name         Varchar2(100);
   l_hpt_rec          hig_process_types%ROWTYPE;
   l_hp_rec           hig_processes%ROWTYPE;
   l_hpal_rec         hig_process_alert_log%ROWTYPE;
   CURSOR c_hpal(qp_hpal_id hig_process_alert_log.hpal_id%TYPE)
   IS
   SELECT *
   FROM   hig_process_alert_log
   WHERE  hpal_id = qp_hpal_id ;

   recipient_not_found Exception ;
   Pragma Exception_Init(recipient_not_found,-22000);
--
BEGIN
--
   IF pi_har_id IS NOT NULL
   THEN       
       l_har_rec  := get_har(pi_har_id);
       l_hal_rec  := get_hal(l_har_rec.har_hal_id);
       l_hatm_rec := get_hatm(l_hal_rec.hal_halt_id);
       l_halt_rec := get_halt(l_hal_rec.hal_halt_id);   
       l_hatr_rec := get_hatr(l_har_rec.har_hatr_id);
       IF l_har_rec.har_recipient_email IS NULL
       THEN    
           Raise recipient_not_found;
       END IF ;
       IF l_hatr_rec.hatr_type = 'To :'
       THEN
           l_to_recipient  := l_har_rec.har_recipient_email;
       ELSIF l_hatr_rec.hatr_type = 'Cc :'
       THEN
          l_cc_recipient  := l_har_rec.har_recipient_email;
       ELSIF l_hatr_rec.hatr_type = 'Bcc :'
       THEN
           l_bcc_recipient := l_har_rec.har_recipient_email;
       END IF ;
   ELSIF pi_hal_id IS NOT NULL
   THEN
       l_hal_rec  := get_hal(pi_hal_id);
       l_halt_rec := get_halt(l_hal_rec.hal_halt_id);
       l_hatm_rec := get_hatm(l_hal_rec.hal_halt_id);
       FOR i IN (SELECT *
                 FROM   hig_alert_recipients
                        ,hig_alert_type_recipients
                 WHERE  pi_hal_id   = har_hal_id
                 AND    har_hatr_id = hatr_id)
       LOOP
           IF i.har_recipient_email IS NOT NULL
           THEN      
               IF i.hatr_type = 'To :'
               THEN
                   IF l_to_recipient IS NOT NULL
                   THEN
                       l_to_recipient  := l_to_recipient||';'||i.har_recipient_email;
                   ELSE
                       l_to_recipient  := i.har_recipient_email;
                   END IF  ;
               ELSIF i.hatr_type = 'Cc :'
               THEN
                   IF l_cc_recipient IS NOT NULL
                   THEN 
                       l_cc_recipient  := l_cc_recipient ||';'||i.har_recipient_email;
                   ELSE
                       l_cc_recipient  := i.har_recipient_email;
                   END IF ;
               ELSIF i.hatr_type = 'Bcc :'
               THEN
                   IF l_bcc_recipient IS NOT NULL
                   THEN
                       l_bcc_recipient := l_bcc_recipient||';'||i.har_recipient_email;
                   ELSE
                       l_bcc_recipient := i.har_recipient_email;
                   END IF ;
               END IF ;
           END IF ;
       END LOOP;
   END IF ;
   IF l_halt_rec.halt_nit_inv_type = 'PRO$'
   THEN
       IF pi_from_screen  = 'N'
       THEN       
           l_hp_rec     := hig_process_framework.get_process(hig_process_api.get_current_process_id);
           l_hpt_rec    := hig_process_framework.get_process_type(l_hp_rec.hp_process_type_id);
           l_attachment := hig_process_framework.log_text_as_blob(pi_process_id            => hig_process_api.get_current_process_id           
                                                                 ,pi_job_run_seq           => hig_process_api.get_current_job_run_seq
                                                                 ,pi_only_summary_messages => 'N');
       ELSE
           OPEN  c_hpal(l_hal_rec.hal_pk_id);
           FETCH c_hpal INTO l_hpal_rec;
           CLOSE c_hpal ;
           l_hpt_rec    := hig_process_framework.get_process_type(l_hpal_rec.hpal_process_type_id);
           l_attachment := hig_process_framework.log_text_as_blob(pi_process_id            => l_hpal_rec.hpal_process_id           
                                                                 ,pi_job_run_seq           => l_hpal_rec.hpal_job_run_seq
                                                                 ,pi_only_summary_messages => 'N');
            
       END IF ;
       IF l_attachment IS NOT NULL
       THEN
           l_att_name := 'Log for '||l_hpt_rec.hpt_name||' '||To_Char(Sysdate,'DD-Mon-YYYY')||'.txt' ;
       END IF ;
   END IF ;
   l_send_mail_status := nm3mail.send_mail(pi_mail_from     => l_hatm_rec.hatm_mail_from
                                          ,pi_recipient_to  => l_to_recipient 
                                          ,pi_recipient_cc  => l_cc_recipient
                                          ,pi_recipient_bcc => l_bcc_recipient
                                          ,pi_subject       => l_hal_rec.hal_subject
                                          ,pi_mailformat    => Nvl(l_hatm_rec.hatm_mail_type,'T')
                                          ,pi_mail_body     => l_hal_rec.hal_mail_text
                                          ,pi_att_file_name => l_att_name
                                          ,pi_file_att      => l_attachment
                                          ,po_error_text    => l_error_text);                 
   IF pi_har_id IS NOT NULL
   THEN
       IF l_send_mail_status
       THEN   
           upd_har_status(pi_har_id => l_har_rec.har_id
                         ,pi_status => 'Completed');
       ELSE
           upd_har_status(pi_har_id     => l_har_rec.har_id
                         ,pi_status     => 'Failed'
                         ,pi_comments   => l_error_text);
       END IF ;
   ELSE
       IF l_send_mail_status
       THEN   
           upd_har_status(pi_hal_id => pi_hal_id
                         ,pi_status => 'Completed');
       ELSE
           upd_har_status(pi_hal_id   =>     pi_hal_id
                         ,pi_status   =>     'Failed'
                         ,pi_comments => l_error_text);
       END IF ;
   END IF ;    
   IF pi_from_screen = 'Y'
   THEN
       Commit;
   END IF ;
EXCEPTION   
    WHEN recipient_not_found THEN
        --upd_har_status(l_har_rec.har_id,'Failed','Recipient email ID is blank');
        IF l_halt_rec.halt_nit_inv_type != 'ERR'
        THEN
            l_hael_rec.hael_nit_inv_type := l_halt_rec.halt_nit_inv_type ;
            l_hael_rec.hael_har_id       := pi_har_id  ; 
            l_hael_rec.hael_pk_id        := l_hal_rec.hal_pk_id ;
            l_hael_rec.hael_alert_description := l_halt_rec.halt_description;
            l_hael_rec.hael_description :=  'Recipient email ID is blank' ;
            insert_hael(l_hael_rec);
            IF pi_from_screen = 'Y'
            THEN
                Commit;
            END IF ;
        END IF ;   
--    
END send_mail;
--
FUNCTION get_halt(pi_halt_id IN hig_alert_types.halt_id%TYPE) 
RETURN hig_alert_types%ROWTYPE
IS
--
   CURSOR c_get_halt
   IS
   SELECT * 
   FROM   hig_alert_types
   WHERE  halt_id = pi_halt_id;
   l_halt_rec hig_alert_types%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_halt;
   FETCH c_get_halt INTO l_halt_rec;
   CLOSE c_get_halt;

   RETURN l_halt_rec ;
--
END get_halt;
--
FUNCTION get_hatr(pi_hatr_id IN hig_alert_type_recipients.hatr_id%TYPE) 
RETURN hig_alert_type_recipients%ROWTYPE
IS
--
   CURSOR c_get_hatr
   IS
   SELECT * 
   FROM   hig_alert_type_recipients
   WHERE  hatr_id = pi_hatr_id;
   l_hatr_rec hig_alert_type_recipients%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_hatr;
   FETCH c_get_hatr INTO l_hatr_rec;
   CLOSE c_get_hatr;

   RETURN l_hatr_rec ;
--
END get_hatr;
--
FUNCTION get_har(pi_har_id IN hig_alert_recipients.har_id%TYPE) 
RETURN hig_alert_recipients%ROWTYPE
IS
--
   CURSOR c_get_har
   IS
   SELECT * 
   FROM   hig_alert_recipients
   WHERE  har_id = pi_har_id;
   l_har_rec hig_alert_recipients%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_har;
   FETCH c_get_har INTO l_har_rec;
   CLOSE c_get_har;

   RETURN l_har_rec ;
--
END get_har;
--
FUNCTION get_harr(pi_harr_id       IN hig_alert_recipient_rules.harr_id%TYPE)
RETURN hig_alert_recipient_rules%ROWTYPE
IS
--
   CURSOR c_get_harr
   IS
   SELECT * 
   FROM   hig_alert_recipient_rules
   WHERE  harr_id   = pi_harr_id ;
   l_harr_rec hig_alert_recipient_rules%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_harr;
   FETCH c_get_harr INTO l_harr_rec;
   CLOSE c_get_harr;

   RETURN l_harr_rec ;
--
END get_harr;
--
PROCEDURE insert_hael(pi_hael_rec IN hig_alert_error_logs%ROWTYPE)
IS
BEGIN
--
   INSERT INTO hig_alert_error_logs
   (hael_id
   ,hael_nit_inv_type
   ,hael_har_id
   ,hael_batch_name 
   ,hael_alert_description 
   ,hael_pk_id      
   ,hael_description
   )
   VALUES
   (hael_id_seq.NEXTVAL
   ,pi_hael_rec.hael_nit_inv_type
   ,pi_hael_rec.hael_har_id
   ,pi_hael_rec.hael_batch_name 
   ,pi_hael_rec.hael_alert_description
   ,pi_hael_rec.hael_pk_id      
   ,pi_hael_rec.hael_description
   );                                                                                                                                          
-- 
END insert_hael;
--
FUNCTION get_hatm(pi_halt_id IN hig_alert_types.halt_id%TYPE)
RETURN hig_alert_type_mail%ROWTYPE
IS
--
   CURSOR c_get_hatm
   IS
   SELECT *
   FROM   hig_alert_type_mail
   WHERE  hatm_halt_id = pi_halt_id ;
   l_hatm_rec hig_alert_type_mail%ROWTYPE;
--
BEGIN
--
   OPEN  c_get_hatm;
   FETCH c_get_hatm INTO l_hatm_rec;
   CLOSE c_get_hatm;
   RETURN l_hatm_rec;
--
END get_hatm;
--
PROCEDURE insert_har(pi_har_rec IN hig_alert_recipients%ROWTYPE)
IS
BEGIN
--
   INSERT INTO hig_alert_recipients
   (har_id
   ,har_hatr_id
   ,har_hal_id
   ,har_recipient_email
   ,har_status
   )
   Values
   (har_id_seq.NEXTVAL
   ,pi_har_rec.har_hatr_id
   ,pi_har_rec.har_hal_id
   ,pi_har_rec.har_recipient_email
   ,pi_har_rec.har_status
   );                                                                                                                                          
-- 
END insert_har;
--
PROCEDURE insert_hal(pi_hal_rec IN OUT hig_alerts%ROWTYPE)
IS
BEGIN
--
   INSERT INTO hig_alerts
   (hal_id
   ,hal_halt_id
   ,hal_subject
   ,hal_mail_text
   ,hal_pk_id
   ,hal_status
   )
   Values
   (hal_id_seq.NEXTVAL
   ,pi_hal_rec.hal_halt_id
   ,pi_hal_rec.hal_subject
   ,pi_hal_rec.hal_mail_text
   ,pi_hal_rec.hal_pk_id
   ,'Pending'
   )
   RETURNING
    hal_id
   ,hal_halt_id
   ,hal_pk_id
   INTO 
    pi_hal_rec.hal_id
   ,pi_hal_rec.hal_halt_id
   ,pi_hal_rec.hal_pk_id; 
-- 
END insert_hal;
--
FUNCTION alert_already_sent(pi_halt_id    IN hig_alert_types.halt_id%TYPE
                           ,pi_hal_pk_id  IN hig_alerts.hal_pk_id%TYPE) 
RETURN Boolean 
IS
--
   CURSOR c_alert_already_sent
   IS
   SELECT 'x'
   FROM   hig_alerts
   WHERE  hal_halt_id  = pi_halt_id
   AND    hal_pk_id   = pi_hal_pk_id ;

   l_value Varchar2(1);
   l_found Boolean;
--
BEGIN
-- 
   OPEN  c_alert_already_sent;
   FETCH c_alert_already_sent INTO l_value;
   l_found := c_alert_already_sent%FOUND;
   CLOSE c_alert_already_sent;

   RETURN l_found;
--  
END alert_already_sent;
--
PROCEDURE create_alert(pi_hal_rec IN hig_alerts%ROWTYPE)
IS
--
   l_recipient_sql      Varchar2(32767);
   l_recipient_user_id  Number ;
   l_hatm_rec           hig_alert_type_mail%ROWTYPE;
   l_nit_rec            nm_inv_types%ROWTYPE;
   l_halt_rec           hig_alert_types%ROWTYPE ;
   l_har_rec            hig_alert_recipients%ROWTYPE;
   l_harr_rec           hig_alert_recipient_rules%ROWTYPE ;
   TYPE l_email_type_tab IS TABLE OF Varchar2(50);
   l_email_tab          l_email_type_tab;
--
BEGIN
--
   l_halt_rec := hig_alert.get_halt(pi_hal_rec.hal_halt_id);
   l_nit_rec := nm3get.get_nit(l_halt_rec.halt_nit_inv_type);
   l_hatm_rec:= get_hatm(pi_hal_rec.hal_halt_id);
   FOR hatr IN (SELECT * FROM hig_alert_type_recipients WHERE hatr_halt_id = l_halt_rec.halt_id)
   LOOP
       IF hatr.hatr_harr_id IS NOT NULL
       THEN
           l_harr_rec := hig_alert.get_harr(hatr.hatr_harr_id); 
           l_recipient_sql := ' SELECT '||l_harr_rec.harr_attribute_name||
                              ' FROM '||l_nit_rec.nit_table_name||
                              ' WHERE '||l_nit_rec.nit_foreign_pk_column||' = :1 ' ; 
           EXECUTE IMMEDIATE l_recipient_sql INTO l_recipient_user_id USING pi_hal_rec.hal_pk_id;
           IF l_harr_rec.harr_recipient_type = 'USER_ID'
           THEN
               FOR nmu IN (SELECT nmu_email_address FROM nm_mail_users WHERE nmu_hus_user_id = l_recipient_user_id )
               LOOP
                   l_har_rec.har_hatr_id         := hatr.hatr_id ; 
                   l_har_rec.har_hal_id          := pi_hal_rec.hal_id ;
                   l_har_rec.har_recipient_email := nmu.nmu_email_address ;
                   l_har_rec.har_status          := 'Pending' ;
                   insert_har(l_har_rec);
               END LOOP;
           ELSE 
               EXECUTE IMMEDIATE l_harr_rec.harr_sql||' :1 ' Bulk Collect INTO l_email_tab Using pi_hal_rec.hal_pk_id;
               FOR i IN 1..l_email_tab.Count
               LOOP
                   l_har_rec.har_hatr_id         := hatr.hatr_id ;
                   l_har_rec.har_hal_id          := pi_hal_rec.hal_id ;
                   l_har_rec.har_recipient_email := l_email_tab(i) ;
                   l_har_rec.har_status          := 'Pending' ;
                   insert_har(l_har_rec); 
               END LOOP ;
           END IF ;
       END IF ;
       IF hatr.hatr_nmu_id IS NOT NULL
       THEN
           FOR nmu IN (SELECT nmu_email_address FROM nm_mail_users WHERE nmu_id = hatr.hatr_nmu_id )
           LOOP 
               l_har_rec.har_hatr_id         := hatr.hatr_id ;
               l_har_rec.har_hal_id          := pi_hal_rec.hal_id ; 
               l_har_rec.har_recipient_email := nmu.nmu_email_address ;
               l_har_rec.har_status          := 'Pending' ; 
               insert_har(l_har_rec);
           END LOOP;
       END IF ;
       IF hatr.hatr_nmg_id IS NOT NULL
       THEN
           FOR nmg IN (SELECT nmu_email_address FROM nm_mail_group_membership,nm_mail_users WHERE nmgm_nmu_id = nmu_id AND nmgm_nmg_id = hatr.hatr_nmg_id) 
           LOOP
               l_har_rec.har_hatr_id         := hatr.hatr_id ;
               l_har_rec.har_hal_id          := pi_hal_rec.hal_id ; 
               l_har_rec.har_recipient_email := nmg.nmu_email_address ; 
               l_har_rec.har_status          := 'Pending' ; 
               insert_har(l_har_rec);
           END LOOP; 
       END IF ;
   END LOOP ;
--
END create_alert ;
--
PROCEDURE create_trg_alert(pi_halt_rec     IN hig_alert_types%ROWTYPE
                          ,pi_param_1      IN Varchar2
                          ,pi_param_2      IN Varchar2
                          ,pi_param_3      IN Varchar2
                          ,pi_param_4      IN Varchar2
                          ,pi_param_5      IN Varchar2
                          ,pi_param_6      IN Varchar2
                          ,pi_param_7      IN Varchar2
                          ,pi_param_8      IN Varchar2
                          ,pi_param_9      IN Varchar2
                          ,pi_param_10     IN Varchar2
                          ,po_subject    OUT Varchar2
                          ,po_email_body OUT Clob)
IS
--
   l_bind_param1   Varchar2(1000);
   l_bind_param2   Varchar2(1000);
   l_bind_param3   Varchar2(1000);
   l_bind_param4   Varchar2(1000);
   l_bind_param5   Varchar2(1000);
   l_bind_param6   Varchar2(1000);
   l_bind_param7   Varchar2(1000);
   l_bind_param8   Varchar2(1000);
   l_bind_param9   Varchar2(1000);
   l_bind_param10  Varchar2(1000);
   l_email_body    Clob;
   l_subject       Clob;
   l_hatm_rec      hig_alert_type_mail%ROWTYPE;
   l_nit_rec       nm_inv_types%ROWTYPE;
   l_har_rec       hig_alert_recipients%ROWTYPE; 
   l_bind_value    Varchar2(4000);  
   l_email_body_length Binary_Integer := 4000;
   l_subject_length    Binary_Integer := 500;
--
BEGIN
--
   l_nit_rec := nm3get.get_nit(pi_halt_rec.halt_nit_inv_type);
   l_hatm_rec:= get_hatm(pi_halt_rec.halt_id);
   l_email_body := l_hatm_rec.hatm_mail_text ;
   IF pi_param_1 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_1
                     ,pi_value       => pi_param_1
                    ,po_meaning      => l_bind_value);
       l_bind_param1 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_2 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_2
                     ,pi_value       => pi_param_2
                    ,po_meaning      => l_bind_value);
       l_bind_param2 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_3 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_3
                     ,pi_value       => pi_param_3
                    ,po_meaning      => l_bind_value);
       l_bind_param3 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_4 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_4
                     ,pi_value       => pi_param_4
                    ,po_meaning      => l_bind_value);
       l_bind_param4 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_5 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_5
                     ,pi_value       => pi_param_5
                    ,po_meaning      => l_bind_value);
       l_bind_param5 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_6 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_6
                     ,pi_value       => pi_param_6
                    ,po_meaning      => l_bind_value);
       l_bind_param6 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_7 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_7
                     ,pi_value       => pi_param_7
                    ,po_meaning      => l_bind_value);
       l_bind_param7 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_8 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_8
                     ,pi_value       => pi_param_8
                    ,po_meaning      => l_bind_value);
       l_bind_param8 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_9 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_9
                     ,pi_value       => pi_param_9
                    ,po_meaning      => l_bind_value);
       l_bind_param9 := Substr(l_bind_value,1,1000);
   END IF ;
   IF pi_param_10 IS NOT NULL
   THEN
       derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                     ,pi_attrib_name => l_hatm_rec.hatm_param_10
                     ,pi_value       => pi_param_10
                    ,po_meaning      => l_bind_value);
       l_bind_param10 := Substr(l_bind_value,1,1000);
   END IF ;
   IF l_email_body LIKE '%{0}%'
   THEN
       IF l_bind_param1 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{0}',l_bind_param1);
       ELSE
           l_email_body := Replace(l_email_body,'{0}',pi_param_1);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{1}%'
   THEN       
       IF l_bind_param2 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{1}',l_bind_param2);
       ELSE
           l_email_body := Replace(l_email_body,'{1}',pi_param_2);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{2}%'
   THEN
       IF l_bind_param3 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{2}',l_bind_param3);
       ELSE
           l_email_body := Replace(l_email_body,'{2}',pi_param_3);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{3}%'
   THEN
       IF l_bind_param4 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{3}',l_bind_param4);
       ELSE
           l_email_body := Replace(l_email_body,'{3}',pi_param_4);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{4}%'
   THEN
       IF l_bind_param5 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{4}',l_bind_param5);
       ELSE
           l_email_body := Replace(l_email_body,'{4}',pi_param_5);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{5}%'
   THEN
       IF l_bind_param6 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{5}',l_bind_param6);
       ELSE
           l_email_body := Replace(l_email_body,'{5}',pi_param_6);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{6}%'
   THEN       
       IF l_bind_param7 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{6}',l_bind_param7);
       ELSE
           l_email_body := Replace(l_email_body,'{6}',pi_param_7);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{7}%'
   THEN
       IF l_bind_param8 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{7}',l_bind_param8);
       ELSE
           l_email_body := Replace(l_email_body,'{7}',pi_param_8);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{8}%'
   THEN
       IF l_bind_param9 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{8}',l_bind_param9);
       ELSE
           l_email_body := Replace(l_email_body,'{8}',pi_param_9);
       END IF ;
   END IF ;
   IF l_email_body LIKE '%{9}%'
   THEN
       IF l_bind_param10 IS NOT NULL
       THEN  
           l_email_body := Replace(l_email_body,'{9}',l_bind_param10);
       ELSE
           l_email_body := Replace(l_email_body,'{9}',pi_param_10);
       END IF ;
   END IF ;
   l_subject := l_hatm_rec.hatm_subject ;
   IF l_subject LIKE '%{0}%'
   THEN
       IF l_bind_param1 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{0}',l_bind_param1 );
       ELSE
           l_subject := Replace(l_subject,'{0}',pi_param_1);
       END IF ;
   END IF ;
   IF  l_subject LIKE '%{1}%'
   THEN       
       IF l_bind_param2 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{1}',l_bind_param2 );
       ELSE
           l_subject := Replace(l_subject,'{1}',pi_param_2);
       END IF ;
   END IF ;
   IF l_subject LIKE '%{2}%'
   THEN
       IF l_bind_param3 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{2}',l_bind_param3 );
       ELSE
           l_subject := Replace(l_subject,'{2}',pi_param_3);
       END IF ; 
   END IF ;
   IF l_subject LIKE '%{3}%'
   THEN
       IF l_bind_param4 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{3}',l_bind_param4 );
       ELSE
           l_subject := Replace(l_subject,'{3}',pi_param_4);
       END IF ;
   END IF ;
   IF l_subject LIKE '%{4}%'
   THEN
       IF l_bind_param5 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{4}',l_bind_param5 );
       ELSE
           l_subject := Replace(l_subject,'{4}',pi_param_5);
       END IF ;
   END IF ;
   IF l_subject LIKE '%{5}%'
   THEN
       IF l_bind_param6 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{5}',l_bind_param6 );
       ELSE
           l_subject := Replace(l_subject,'{5}',pi_param_6);
       END IF ;
   END IF ;
   IF l_subject LIKE '%{6}%'
   THEN
       IF l_bind_param7 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{6}',l_bind_param7 );
       ELSE
           l_subject := Replace(l_subject,'{6}',pi_param_7);
       END IF ;
   END IF ;
   IF l_subject LIKE '%{7}%'
   THEN
       IF l_bind_param8 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{7}',l_bind_param8 );
       ELSE
           l_subject := Replace(l_subject,'{7}',pi_param_8);
       END IF ;
   END IF ;
   IF l_subject LIKE '%{8}%'
   THEN
       IF l_bind_param9 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{8}',l_bind_param9 );
       ELSE
           l_subject := Replace(l_subject,'{8}',pi_param_9);
       END IF ;
   END IF ;
   IF l_subject LIKE '%{9}%'
   THEN
       IF l_bind_param10 IS NOT NULL
       THEN  
           l_subject := Replace(l_subject,'{9}',l_bind_param10 );
       ELSE
           l_subject := Replace(l_subject,'{9}',pi_param_10);
       END IF ;
   END IF ;   
   DBMS_LOB.READ (l_subject,l_subject_length,1,po_subject);
   DBMS_LOB.READ (l_email_body,l_email_body_length,1,po_email_body);
--
END create_trg_alert ;
--
PROCEDURE process_query_batch(pi_halt_rec IN hig_alert_types%ROWTYPE)
IS
--
   l_bind_param_cnt Number := 0 ;
   l_bind_param_sql Varchar2(32767) ;
   l_bind_param1    Varchar2(4000);
   l_bind_param2    Varchar2(4000);
   l_bind_param3    Varchar2(4000);
   l_bind_param4    Varchar2(4000);
   l_bind_param5    Varchar2(4000);
   l_bind_param6    Varchar2(4000);
   l_bind_param7    Varchar2(4000);
   l_bind_param8    Varchar2(4000);
   l_bind_param9    Varchar2(4000);
   l_bind_param10   Varchar2(4000);
   l_ita_rec nm_inv_type_attribs%ROWTYPE; 
   TYPE l_pk_type IS TABLE OF Varchar2(100) INDEX BY BINARY_INTEGER;
   l_pk_tab l_pk_type;
   l_sql Varchar2(32767) ;
   l_hqt_rec  hig_query_types%ROWTYPE;
   l_hal_rec  hig_alerts%ROWTYPE;
   l_hatm_rec hig_alert_type_mail%ROWTYPE;
   l_nit_rec nm_inv_types%ROWTYPE;
   l_halt_rec hig_alert_types%ROWTYPE ;
   l_har_rec hig_alert_recipients%ROWTYPE;
   l_bind_param   Varchar2(4000);
   l_subject_temp Varchar2(4000);
--
BEGIN
--
   l_nit_rec := nm3get.get_nit(pi_halt_rec.halt_nit_inv_type);
   l_hqt_rec := hig_qry_builder.get_hqt(pi_halt_rec.halt_hqt_id);
   l_hatm_rec:= get_hatm(pi_halt_rec.halt_id);
   l_sql := 'SELECT '||l_nit_rec.nit_foreign_pk_column||
            ' FROM '||l_nit_rec.nit_table_name||' '||
            l_hqt_rec.hqt_where_clause;
            
   EXECUTE IMMEDIATE l_sql BULK COLLECT INTO l_pk_tab ;
   FOR i in 1..l_pk_tab.Count
   LOOP
       IF NOT alert_already_sent(pi_halt_rec.halt_id
                                       ,l_pk_tab(i))
       THEN            
           l_halt_rec := hig_alert.get_halt(pi_halt_rec.halt_id);
           l_nit_rec := nm3get.get_nit(l_halt_rec.halt_nit_inv_type);
           l_hatm_rec:= get_hatm(pi_halt_rec.halt_id);
           l_bind_param_sql := ' SELECT '||Nvl(l_hatm_rec.hatm_param_1,'NULL')||','||Nvl(l_hatm_rec.hatm_param_2,'NULL')||','||Nvl(l_hatm_rec.hatm_param_3,'NULL')||','||Nvl(l_hatm_rec.hatm_param_4,'NULL')||','
                                       ||Nvl(l_hatm_rec.hatm_param_5,'NULL')||','||Nvl(l_hatm_rec.hatm_param_6,'NULL')||','||Nvl(l_hatm_rec.hatm_param_7,'NULL')||','||Nvl(l_hatm_rec.hatm_param_8,'NULL')||','
                                      ||Nvl(l_hatm_rec.hatm_param_9,'NULL')||','||Nvl(l_hatm_rec.hatm_param_10,'NULL')||
                               ' FROM '||l_nit_rec.nit_table_name||
                               ' WHERE '||l_nit_rec.nit_foreign_pk_column||' = :1 ' ;
           EXECUTE IMMEDIATE l_bind_param_sql INTO l_bind_param1,l_bind_param2,l_bind_param3,l_bind_param4,l_bind_param5,l_bind_param6,l_bind_param7,l_bind_param8,l_bind_param9,l_bind_param10 USING l_pk_tab(i);
           -- find and replace bind variables
           IF l_bind_param1 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_1
                             ,pi_value       => l_bind_param1
                             ,po_meaning     => l_bind_param1);
               l_bind_param1 := Substr(l_bind_param1,1,1000);              
           END IF ;
           IF l_bind_param2 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_2
                             ,pi_value       => l_bind_param2
                             ,po_meaning     => l_bind_param2);
               l_bind_param2 := Substr(l_bind_param2,1,1000);
           END IF ;
           IF l_bind_param3 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_3
                             ,pi_value       => l_bind_param3
                             ,po_meaning     => l_bind_param3);
               l_bind_param3 := Substr(l_bind_param3,1,1000);
           END IF ;
           IF l_bind_param4 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_4
                             ,pi_value       => l_bind_param4
                             ,po_meaning     => l_bind_param4);
               l_bind_param4 := Substr(l_bind_param4,1,1000);
           END IF ;
           IF l_bind_param5 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_5
                             ,pi_value       => l_bind_param5
                             ,po_meaning     => l_bind_param5);
               l_bind_param5 := Substr(l_bind_param5,1,1000);
           END IF ;
           IF l_bind_param6 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_6
                             ,pi_value       => l_bind_param6
                             ,po_meaning     => l_bind_param6);
               l_bind_param6 := Substr(l_bind_param6,1,1000);
           END IF ;
           IF l_bind_param7 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_7
                             ,pi_value       => l_bind_param7
                             ,po_meaning     => l_bind_param7);
               l_bind_param7 := Substr(l_bind_param7,1,1000);
           END IF ;
           IF l_bind_param8 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_8
                             ,pi_value       => l_bind_param8
                             ,po_meaning     => l_bind_param8);
               l_bind_param8 := Substr(l_bind_param8,1,1000);
           END IF ;
           IF l_bind_param9 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_9
                             ,pi_value       => l_bind_param9
                             ,po_meaning     => l_bind_param9);
               l_bind_param9 := Substr(l_bind_param9,1,1000);
           END IF ;
           IF l_bind_param10 IS NOT NULL  
           THEN
               derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                             ,pi_attrib_name => l_hatm_rec.hatm_param_10
                             ,pi_value       => l_bind_param10
                             ,po_meaning     => l_bind_param10);
               l_bind_param10 := Substr(l_bind_param10,1,1000);
           END IF ;
           l_hal_rec.hal_mail_text := l_hatm_rec.hatm_mail_text ;
           IF l_hal_rec.hal_mail_text LIKE '%{0}%'
           THEN                 
               l_hal_rec.hal_mail_text := Replace(l_hal_rec.hal_mail_text ,'{0}',l_bind_param1);
           END IF ;
           IF l_hal_rec.hal_mail_text LIKE '%{1}%'
           THEN
               l_hal_rec.hal_mail_text := Replace(l_hal_rec.hal_mail_text ,'{1}',l_bind_param2);
           END IF ;
           IF l_hal_rec.hal_mail_text LIKE '%{2}%'
           THEN
               l_hal_rec.hal_mail_text  := Replace(l_hal_rec.hal_mail_text ,'{2}',l_bind_param3);
           END IF ;
           IF l_hal_rec.hal_mail_text LIKE '%{3}%'
           THEN
               l_hal_rec.hal_mail_text  := Replace(l_hal_rec.hal_mail_text ,'{3}',l_bind_param4);
           END IF ;
           IF l_hal_rec.hal_mail_text  LIKE '%{4}%'
           THEN
               l_hal_rec.hal_mail_text  := Replace(l_hal_rec.hal_mail_text ,'{4}',l_bind_param5);
           END IF ;
           IF l_hal_rec.hal_mail_text  LIKE '%{5}%'
           THEN
               l_hal_rec.hal_mail_text  := Replace(l_hal_rec.hal_mail_text ,'{5}',l_bind_param6);
           END IF ;
           IF l_hal_rec.hal_mail_text  LIKE '%{6}%'
           THEN
               l_hal_rec.hal_mail_text  := Replace(l_hal_rec.hal_mail_text ,'{6}',l_bind_param7);
           END IF ;
           IF l_hal_rec.hal_mail_text LIKE '%{7}%'
           THEN
                l_hal_rec.hal_mail_text := Replace(l_hal_rec.hal_mail_text ,'{7}',l_bind_param8);
           END IF ;
           IF l_hal_rec.hal_mail_text LIKE '%{8}%'
           THEN
                l_hal_rec.hal_mail_text := Replace(l_hal_rec.hal_mail_text ,'{8}',l_bind_param9);
           END IF ;
           IF l_hal_rec.hal_mail_text LIKE '%{9}%'
           THEN
               l_hal_rec.hal_mail_text := Replace(l_hal_rec.hal_mail_text ,'{9}',l_bind_param10);
           END IF ;
           l_hal_rec.hal_subject  := l_hatm_rec.hatm_subject ;
           IF l_hal_rec.hal_subject LIKE '%{0}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_subject_temp := Replace(l_hal_rec.hal_subject,'{0}',l_bind_param1);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{1}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{1}',l_bind_param2);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{2}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{2}',l_bind_param3);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{3}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{3}',l_bind_param4);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{4}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{4}',l_bind_param5);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{5}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{5}',l_bind_param6);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{6}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{6}',l_bind_param7);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{7}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{7}',l_bind_param8);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%8}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{8}',l_bind_param9);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           IF l_hal_rec.hal_subject LIKE '%{9}%'
           AND Nvl(Length(l_subject_temp),0) < 500
           THEN
               l_hal_rec.hal_subject := Replace(l_hal_rec.hal_subject,'{9}',l_bind_param10);
               l_hal_rec.hal_subject := Substr(l_subject_temp,1,500);
           END IF ;
           l_hal_rec.hal_halt_id := pi_halt_rec.halt_id;
           l_hal_rec.hal_pk_id  := l_pk_tab(i);
           insert_hal(l_hal_rec);    
       END IF ;
   END LOOP;
   Commit;
   FOR hno IN (SELECT * FROM hig_alerts 
               WHERE  hal_halt_id =  pi_halt_rec.halt_id
               AND    hal_status = 'Pending')
   LOOP
       create_alert(hno);        
   END LOOP;
--
END process_query_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE run_alert_batch
IS
--
   l_time_counter_ela Boolean := FALSE ;
   l_hal_cnt  Number ;
   l_last_run Date ;
   l_hns_value Number ;
   l_hsfr_rec hig_scheduling_frequencies%ROWTYPE ;
--
BEGIN
--
   -- loop through all the notifications that are schedule for run
   FOR hna IN (SELECT hna.* 
               FROM   hig_alert_types hna,hig_scheduling_frequencies
               WHERE  halt_frequency_id = hsfr_frequency_id(+) 
               AND   ((    halt_alert_type = 'T' 
                        AND Nvl(halt_immediate,'N') = 'N')
                      OR 
                       (    halt_alert_type ='Q'
                        AND Nvl(halt_suspend_query,'N') = 'N'
                        AND halt_next_run_date <= Sysdate 
                      ))
             )
   LOOP
       l_time_counter_ela := FALSE ;
       IF hna.halt_alert_type = 'Q'
       THEN
           process_query_batch(hna); 
           l_time_counter_ela := TRUE;    
       ELSE
           IF hna.halt_trigger_count IS NOT NULL
           THEN
               SELECT Count(0)
               INTO   l_hal_cnt 
               FROM   hig_alerts 
               WHERE  hal_halt_id = hna.halt_id 
               AND    hal_status = 'Pending' ;
               IF l_hal_cnt >= hna.halt_trigger_count
               THEN
                   l_time_counter_ela := TRUE;
               END IF ;
           END IF;
           IF  hna.halt_frequency_id IS NOT NULL
           AND NOT l_time_counter_ela 
           THEN
               SELECT Max(hal_date_modified)
               INTO   l_last_run
               FROM   hig_alerts 
               WHERE  hal_halt_id = hna.halt_id 
               AND    hal_status = 'Completed' ;

               SELECT Count(0)
               INTO   l_hal_cnt 
               FROM   hig_alerts 
               WHERE  hal_halt_id = hna.halt_id 
               AND    hal_status = 'Pending' ;
               
               l_hsfr_rec := hig_process_framework.get_frequency(hna.halt_frequency_id);
               l_hns_value  := l_hsfr_rec.hsfr_interval_in_mins /(24*60) ;
               
               IF l_hal_cnt >=  1 
               AND l_last_run IS NULL
               THEN 
                   l_time_counter_ela := TRUE;               
               ELSIF l_hal_cnt >=  1 
               AND (l_last_run + l_hns_value) < Sysdate 
               THEN                    
                   l_time_counter_ela := TRUE;                    
               ELSE
                   l_time_counter_ela := FALSE; 
               END IF ;
           END IF ;
       END IF ;
       IF l_time_counter_ela 
       THEN
           FOR hal IN (SELECT har_recipient_email
                       FROM   hig_alerts
                             ,hig_alert_recipients 
                             ,hig_alert_type_recipients
                       WHERE  hal_halt_id = hna.halt_id
                       AND    hal_id      = har_hal_id
                       AND    hal_status  = 'Pending'
                       AND    har_status  = 'Pending'
                       AND    har_hatr_id = hatr_id
                       AND    hatr_type = 'To :'
                       GROUP BY har_recipient_email
                       HAVING Count(0) > 1 )
           LOOP
           --
               send_batch_mail(pi_halt_id         => hna.halt_id
                              ,pi_recipient_email => hal.har_recipient_email);        
           -- 
           END LOOP;
           FOR hno IN (SELECT * FROM hig_alerts 
                       WHERE  hal_halt_id = hna.halt_id 
                       AND   hal_status = 'Pending'
                       ORDER  by hal_date_created)
           LOOP
               --FOR har IN (SELECT * FROM hig_alert_recipients 
               --             WHERE  har_hal_id = hno.hal_id     
               --             AND    har_status = 'Pending'
               --             ORDER  BY har_date_created)                                                               
               --LOOP
                   send_batch_single_mail(pi_halt_id   => hna.halt_id
                                         ,pi_hal_id    => hno.hal_id);
--                                         ,pi_har_id    => har.har_id);
               --END LOOP;
           END LOOP;
           UPDATE hig_alerts
           SET    hal_status  = 'Completed'     
           WHERE  hal_halt_id =  hna.halt_id;
            Commit;   
       END IF ;
       IF hna.halt_alert_type = 'Q'
       THEN
           UPDATE hig_alert_types
           SET    halt_last_run_date = Sysdate
                 ,halt_next_run_date = hig_alert.get_next_run_date(halt_frequency_id)
           WHERE  halt_id = hna.halt_id ;
           Commit ;
       END IF ;   
   END LOOP;
   Commit ;
--
END run_alert_batch;
--
PROCEDURE send_batch_mail(pi_halt_id         IN hig_alert_types.halt_id%TYPE
                         ,pi_recipient_email IN hig_alert_recipients.har_recipient_email%TYPE)
IS
--
   TYPE               l_col_name_type IS TABLE OF VARCHAR(30) INDEX BY BINARY_INTEGER;
   l_col_tab          l_col_name_type;
   TYPE               l_col_value_type IS TABLE OF VARCHAR(1000) INDEX BY BINARY_INTEGER;
   l_col_value_tab    l_col_value_type;
   l_hatm_rec         hig_alert_type_mail%ROWTYPE;
   l_nit_rec          nm_inv_types%ROWTYPE ;
   l_halt_rec         hig_alert_types%ROWTYPE ; 
   --l_email_body       Varchar2(32767);
   l_email_body       Clob;
   l_subject          Varchar2(1000);
   l_ita_rec          nm_inv_type_attribs_all%ROWTYPE;
   l_value            Varchar2(4000) ;
   l_email_table      Clob;
   l_send_mail_status Boolean;
   l_error_text       clob;
   l_cc_recipient     Varchar2(32767);
   l_bcc_recipient    Varchar2(32767);
   l_num_tab          nm3type.tab_number;
--
BEGIN
--
   l_hatm_rec := hig_alert.get_hatm(pi_halt_id);
   IF l_hatm_rec.hatm_param_1 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_1;
   END IF ;   
   IF l_hatm_rec.hatm_param_2 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_2;
   END IF ;
   IF l_hatm_rec.hatm_param_3 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_3;
   END IF ;
   IF l_hatm_rec.hatm_param_4 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_4;
   END IF ;
   IF l_hatm_rec.hatm_param_5 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_5;
   END IF ;
   IF l_hatm_rec.hatm_param_6 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_6;
   END IF ;
   IF l_hatm_rec.hatm_param_7 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_7;
   END IF ;
   IF l_hatm_rec.hatm_param_8 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_8;
   END IF ;
   IF l_hatm_rec.hatm_param_9 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_9;
   END IF ;
   IF l_hatm_rec.hatm_param_10 IS NOT NULL
   THEN
       l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_10;
   END IF ;
   l_halt_rec    := hig_alert.get_halt(pi_halt_id);
   l_nit_rec     := nm3get.get_nit(l_halt_rec.halt_nit_inv_type);
   l_subject     := l_hatm_rec.hatm_subject ;
   l_email_table := '<table border="1">  <tr> ' ;
   IF Nvl(l_col_tab.count,0) > 0
   THEN     
       FOR i in 1..l_col_tab.count 
       LOOP
           l_ita_rec      := nm3get.get_ita(pi_ita_inv_type => l_nit_rec.nit_inv_type ,pi_ita_attrib_name => l_col_tab(i));                
           l_email_table  := l_email_table|| ' <td> <b>'||l_ita_rec.ita_scrn_text ||' </b></td> ';
       END LOOP;
   ELSE
       l_ita_rec := nm3get.get_ita(pi_ita_inv_type => l_nit_rec.nit_inv_type ,pi_ita_attrib_name => l_nit_rec.nit_foreign_pk_column); 
       l_email_table  := l_email_table|| ' <td> <b>'||l_ita_rec.ita_scrn_text ||' </b></td> ';
   END IF;     
   l_email_body := l_email_body ||' </tr> ';                                
   FOR hal IN (SELECT hal.* 
                FROM   hig_alerts hal ,hig_alert_recipients 
                WHERE  hal_halt_id = pi_halt_id
                AND    hal_id = har_hal_id
                AND    hal_status = 'Pending'
                AND    har_status = 'Pending'
                AND    har_recipient_email = pi_recipient_email )
   LOOP
       l_num_tab(l_num_tab.Count+1) := hal.hal_id;
       l_email_table  := l_email_table ||' <tr> ';             
       IF Nvl(l_col_tab.count,0) > 0
       THEN     
           FOR i in 1..l_col_tab.count 
           LOOP
               Execute Immediate 'SELECT '||l_col_tab(i)||Chr(10)||
                                 'FROM   '||l_nit_rec.nit_table_name||Chr(10)||
                                 'WHERE  '||l_nit_rec.nit_foreign_pk_column||' = :1' INTO l_value  USING hal.hal_pk_id;
               IF l_value IS NOT NULL
               THEN 
                   derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                                 ,pi_attrib_name => l_col_tab(i)
                                 ,pi_value       => l_value
                                 ,po_meaning     => l_value);
               END IF ;
               l_email_table  := l_email_table|| ' <td>'||Nvl(l_value,nm3web.c_nbsp)||'</td> ';                  
           END LOOP;
       ELSE
           l_email_table  := l_email_table|| ' <td>'||hal.hal_pk_id||'</td> ';
       END IF ;   
       l_email_table  := l_email_table ||' </tr> '||Chr(10);      
   END LOOP;    
   l_email_table  := l_email_table ||Chr(10)||'</table>'||Chr(10);
   --IF l_max_lenght 
   --THEN 
   --    l_email_table := l_email_table ||'<b> Note :- This list is truncated as it has exceeded the maximum size because there are too many rows in the batch. </b>';
   --END IF ;
   l_hatm_rec.hatm_mail_text := Replace(l_hatm_rec.hatm_mail_text,Chr(10),'</br>');
   IF Instr(l_hatm_rec.hatm_mail_text,'{table}') > 0
   THEN
       l_email_body := Substr(l_hatm_rec.hatm_mail_text,1,Instr(l_hatm_rec.hatm_mail_text,'{table}')-1)||l_email_table||substr(l_hatm_rec.hatm_mail_text,Instr(l_hatm_rec.hatm_mail_text,'{table}')+7);
       --l_email_body   := replaceClob(l_email_body,Chr(10),'</br>');
   END IF;
   --l_email_body   := Replace(l_hatm_rec.hatm_mail_text,'{table}',l_email_table);
   --l_email_body   := Replace(l_email_body,Chr(10),'</br>');
   For i IN (SELECT Distinct har_recipient_email 
             FROM   hig_alerts,hig_alert_recipients,hig_alert_type_recipients 
             WHERE  hal_halt_id = pi_halt_id
             AND    hal_id      = har_hal_id
             AND    har_hatr_id = hatr_id
             AND    hal_id IN     (SELECT hal_id FROM hig_alerts,hig_alert_recipients,hig_alert_type_recipients 
                                   WHERE  hatr_type           = 'To :'
                                   AND    hal_halt_id         = pi_halt_id                      
                                   AND    hal_id              = har_hal_id
                                   AND    har_recipient_email = pi_recipient_email 
                                   AND    hal_status          = 'Pending'
                                   AND    har_status          = 'Pending'
                                   AND    har_hatr_id         = hatr_id)    
             AND    hatr_type = 'Cc :')
   Loop 
       IF l_cc_recipient IS NOT NULL
       THEN
           l_cc_recipient := l_cc_recipient||';'||i.har_recipient_email;  
       ELSE
           l_cc_recipient :=   i.har_recipient_email;
       END IF ;
   End loop;
   For i IN (SELECT Distinct har_recipient_email 
             FROM   hig_alerts,hig_alert_recipients,hig_alert_type_recipients 
             WHERE  hal_halt_id = pi_halt_id
             AND    hal_id      = har_hal_id
             AND    har_hatr_id = hatr_id
             AND    hal_id IN     (SELECT hal_id FROM hig_alerts,hig_alert_recipients,hig_alert_type_recipients 
                                   WHERE  hatr_type           = 'To :'
                                   AND    hal_halt_id         = pi_halt_id                      
                                   AND    hal_id              = har_hal_id
                                   AND    har_recipient_email = pi_recipient_email 
                                   AND    hal_status          = 'Pending'
                                   AND    har_status          = 'Pending'
                                   AND    har_hatr_id         = hatr_id)    
             AND    hatr_type = 'Bcc :')
   Loop 
       IF l_bcc_recipient IS NOT NULL
       THEN
           l_bcc_recipient := l_bcc_recipient||';'||i.har_recipient_email;  
       ELSE
           l_bcc_recipient :=   i.har_recipient_email;
       END IF ;
   End loop;
   l_send_mail_status := nm3mail.send_mail(pi_mail_from     => l_hatm_rec.hatm_mail_from
                                          ,pi_recipient_to  => pi_recipient_email 
                                          ,pi_recipient_cc  => l_cc_recipient
                                          ,pi_recipient_bcc => l_bcc_recipient
                                          ,pi_subject       => l_subject
                                          ,pi_mailformat    => 'H'
                                          ,pi_mail_body     => l_email_body
                                          ,po_error_text    => l_error_text);                 
   IF l_send_mail_status
   THEN   
       Update hig_alert_recipients
       SET    har_status = 'Completed'
       WHERE  har_hal_id IN (SELECT hal_id 
                             FROM   hig_alerts
                             WHERE  hal_halt_id = pi_halt_id 
                             AND    hal_status = 'Pending')
       AND    har_status  = 'Pending'
       AND    har_recipient_email = pi_recipient_email;
 
       FOR i IN 1..l_num_tab.Count
       LOOP
           Update hig_alert_recipients 
           SET    har_status = 'Completed'
           WHERE  har_hal_id = l_num_tab(i)
           AND    har_hatr_id IN (SELECT hatr_id 
                                  FROM   hig_alert_type_recipients 
                                  WHERE  hatr_type IN ('Bcc :','Cc :')) ;
       END LOOP;         
   ELSE
       Update hig_alert_recipients
       SET    har_status   = 'Failed'
             ,har_comments = l_error_text
       WHERE  har_hal_id IN (SELECT hal_id 
                             FROM   hig_alerts
                             WHERE  hal_halt_id = pi_halt_id 
                             AND    hal_status = 'Pending')
       AND    har_status  = 'Pending'
       AND    har_recipient_email = pi_recipient_email;
       FOR i IN 1..l_num_tab.Count
       LOOP
           Update hig_alert_recipients 
           SET    har_status = 'Failed'
                 ,har_comments = l_error_text
           WHERE  har_hal_id = l_num_tab(i)
           AND    har_hatr_id IN (SELECT hatr_id 
                                  FROM   hig_alert_type_recipients 
                                  WHERE  hatr_type IN ('Bcc :','Cc :')) ;
       END LOOP;
   END IF ;
   Commit;
--
END send_batch_mail;
--
PROCEDURE send_batch_single_mail(pi_halt_id  IN hig_alert_types.halt_id%TYPE
                                ,pi_hal_id   IN hig_alerts.hal_id%TYPE )
--                                ,pi_har_id   IN hig_alert_recipients.har_id%TYPE)
IS
--
   TYPE               l_col_name_type IS TABLE OF VARCHAR(30) INDEX BY BINARY_INTEGER;
   l_col_tab          l_col_name_type;
   TYPE               l_col_value_type IS TABLE OF VARCHAR(1000) INDEX BY BINARY_INTEGER;
   l_col_value_tab    l_col_value_type;
   l_hatm_rec         hig_alert_type_mail%ROWTYPE;
   l_nit_rec          nm_inv_types%ROWTYPE ;
   l_halt_rec         hig_alert_types%ROWTYPE ; 
   --l_email_body       Varchar2(32767);
   l_email_body       Clob;
   l_subject          Varchar2(1000);
   l_ita_rec          nm_inv_type_attribs_all%ROWTYPE;
   l_value            Varchar2(4000) ;
   l_email_table      clob;
   l_send_mail_status Boolean;
   l_error_text       clob;
   l_har_rec          hig_alert_recipients%ROWTYPE;
   l_hal_rec          hig_alerts%ROWTYPE;
   l_cc_recipient     Varchar2(32767);
   l_bcc_recipient    Varchar2(32767);
   l_to_recipient     Varchar2(32767);
   l_found            Boolean ;
   l_max_lenght       Boolean ;
--
BEGIN
--
   l_hatm_rec  := hig_alert.get_hatm(pi_halt_id);
   l_hal_rec   := hig_alert.get_hal(pi_hal_id);
   FOR i IN (SELECT distinct hatr_type,har_recipient_email
             FROM   hig_alert_recipients
                   ,hig_alert_type_recipients
             WHERE  har_hal_id  = pi_hal_id   
             AND    har_hatr_id = hatr_id
             AND    har_status  = 'Pending')
   LOOP
       l_found := True;
       IF i.har_recipient_email IS NOT NULL
       THEN      
           IF i.hatr_type = 'To :'
           THEN
               IF l_to_recipient IS NOT NULL
               THEN
                   l_to_recipient  := l_to_recipient||';'||i.har_recipient_email;
               ELSE
                   l_to_recipient  := i.har_recipient_email;
               END IF  ;
           ELSIF i.hatr_type = 'Cc :'
           THEN
               IF l_cc_recipient IS NOT NULL
               THEN 
                   l_cc_recipient  := l_cc_recipient ||';'||i.har_recipient_email;
               ELSE
                   l_cc_recipient  := i.har_recipient_email;
               END IF ;
           ELSIF i.hatr_type = 'Bcc :'
           THEN
               IF l_bcc_recipient IS NOT NULL
               THEN
                   l_bcc_recipient := l_bcc_recipient||';'||i.har_recipient_email;
               ELSE
                   l_bcc_recipient := i.har_recipient_email;
               END IF ;
           END IF ;
       END IF ;
   END LOOP;   
   IF l_found 
   THEN   
       IF l_hatm_rec.hatm_param_1 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_1;
       END IF ;   
       IF l_hatm_rec.hatm_param_2 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_2;
       END IF ;
       IF l_hatm_rec.hatm_param_3 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_3;
       END IF ;
       IF l_hatm_rec.hatm_param_4 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_4;
       END IF ;
       IF l_hatm_rec.hatm_param_5 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_5;
       END IF ;
       IF l_hatm_rec.hatm_param_6 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_6;
       END IF ;
       IF l_hatm_rec.hatm_param_7 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_7;
       END IF ;
       IF l_hatm_rec.hatm_param_8 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_8;
       END IF ;
       IF l_hatm_rec.hatm_param_9 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_9;
       END IF ;
       IF l_hatm_rec.hatm_param_10 IS NOT NULL
       THEN
           l_col_tab(l_col_tab.Count+1) :=  l_hatm_rec.hatm_param_10;
       END IF ;
       l_halt_rec    := hig_alert.get_halt(pi_halt_id);
       l_nit_rec     := nm3get.get_nit(l_halt_rec.halt_nit_inv_type);
       l_subject     := l_hatm_rec.hatm_subject ;
       l_email_table := '<table border="1">  <tr> ' ;
       IF Nvl(l_col_tab.count,0) > 0
       THEN     
           FOR i in 1..l_col_tab.count 
           LOOP
               l_ita_rec := nm3get.get_ita(pi_ita_inv_type => l_nit_rec.nit_inv_type ,pi_ita_attrib_name => l_col_tab(i));                
               l_email_table  := l_email_table|| ' <td> <b>'||l_ita_rec.ita_scrn_text ||' </b> </td> ';
           END LOOP;
       ELSE
           l_ita_rec := nm3get.get_ita(pi_ita_inv_type => l_nit_rec.nit_inv_type ,pi_ita_attrib_name => l_nit_rec.nit_foreign_pk_column); 
           l_email_table  := l_email_table|| ' <td> <b>'||l_ita_rec.ita_scrn_text ||' </b></td> ';    
       END IF;     
       l_email_body := l_email_body ||' </tr> ';                                
       l_email_table  := l_email_table ||' <tr> ';             
       IF Nvl(l_col_tab.count,0) > 0
       THEN     
           FOR i in 1..l_col_tab.count 
           LOOP
               Execute Immediate 'SELECT '||l_col_tab(i)||Chr(10)||
                                 'FROM   '||l_nit_rec.nit_table_name||Chr(10)||
                                 'WHERE  '||l_nit_rec.nit_foreign_pk_column||' = :1' INTO l_value  USING l_hal_rec.hal_pk_id;
               IF l_value IS NOT NULL
               THEN 
                   derive_meaning(pi_inv_type    => l_nit_rec.nit_inv_type
                                 ,pi_attrib_name => l_col_tab(i)
                                 ,pi_value       => l_value
                                 ,po_meaning     => l_value);
               END IF ;
               l_email_table  := l_email_table|| ' <td>'||Nvl(l_value,nm3web.c_nbsp)||'</td> ';                  
           END LOOP;
       ELSE
           l_email_table  := l_email_table|| ' <td>'||l_hal_rec.hal_pk_id||'</td> ';
       END IF ;   
       l_email_table  := l_email_table ||' </tr> ';   
       l_email_table  := l_email_table ||Chr(10)||'</table>'||Chr(10);
       --IF Instr(l_hatm_rec.hatm_mail_text,'{table}') > 0
       --THEN
       --    l_email_body := Substr(l_hatm_rec.hatm_mail_text,1,Instr(l_hatm_rec.hatm_mail_text,'{table}')-1)||l_email_table||substr(l_hatm_rec.hatm_mail_text,Instr(l_hatm_rec.hatm_mail_text,'{table}')+7);
       --    l_email_body   := replaceClob(l_email_body,Chr(10),'</br>');
       --END IF;
       l_email_body   := Replace(l_hatm_rec.hatm_mail_text,'{table}',l_email_table);
       l_email_body   := Replace(l_email_body,Chr(10),'</br>');   
       
       l_send_mail_status := nm3mail.send_mail(pi_mail_from     => l_hatm_rec.hatm_mail_from
                                              ,pi_recipient_to  => l_to_recipient
                                              ,pi_recipient_cc  => l_cc_recipient
                                              ,pi_recipient_bcc => l_bcc_recipient
                                              ,pi_subject       => l_subject
                                              ,pi_mailformat    => 'H'
                                              ,pi_mail_body     => l_email_body
                                              ,po_error_text    => l_error_text);                 
       IF l_send_mail_status
       THEN   
           Update hig_alert_recipients
           SET    har_status  = 'Completed'
           WHERE  har_hal_id  = pi_hal_id;                      
       ELSE
           Update hig_alert_recipients
           SET    har_status   = 'Failed'
                 ,har_comments = l_error_text
           WHERE  har_hal_id   = pi_hal_id;
       END IF ;
       Commit;   
   END IF;
--
END send_batch_single_mail;
--
PROCEDURE append(pi_text     Varchar2
                ,pi_new_line Varchar2 Default 'Y' )
IS
BEGIN
--
   IF pi_new_line = 'Y'
   THEN
       g_trigger_text := g_trigger_text||CHR(10)||pi_text;
   ELSE
       g_trigger_text := g_trigger_text||' '||pi_text;
   END IF ;
--
END append;
--
PROCEDURE trg_body (pi_operation   IN Varchar2
                   ,pi_halt_id      IN hig_alert_types.halt_id%TYPE
                   ,pi_pk_col      IN Varchar2)
IS
--
   l_hatm_rec hig_alert_type_mail%ROWTYPE; 
   l_halt_rec hig_alert_types%ROWTYPE;
   l_harr_rec hig_alert_recipient_rules%ROWTYPE ;
--
BEGIN
--
   l_hatm_rec := hig_alert.get_hatm(pi_halt_id); 
   l_halt_rec  := hig_alert.get_halt(pi_halt_id) ;
   IF pi_operation != 'Delete'
   THEN
       append ('   l_hal_rec.hal_pk_id := :NEW.'||pi_pk_col||' ;');
       IF l_hatm_rec.hatm_param_1 IS NOT NULL 
       THEN 
           append ('    l_param_1 := Substr(:NEW.'||l_hatm_rec.hatm_param_1||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_2 IS NOT NULL 
       THEN 
           append ('    l_param_2 := Substr(:NEW.'||l_hatm_rec.hatm_param_2||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_3 IS NOT NULL 
       THEN 
           append ('    l_param_3 := Substr(:NEW.'||l_hatm_rec.hatm_param_3||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_4 IS NOT NULL 
       THEN 
           append ('    l_param_4 := Substr(:NEW.'||l_hatm_rec.hatm_param_4||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_5 IS NOT NULL 
       THEN 
           append ('    l_param_5 := Substr(:NEW.'||l_hatm_rec.hatm_param_5||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_6 IS NOT NULL 
       THEN 
           append ('    l_param_6 := Substr(:NEW.'||l_hatm_rec.hatm_param_6||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_7 IS NOT NULL 
       THEN 
           append ('    l_param_7 := Substr(:NEW.'||l_hatm_rec.hatm_param_7||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_8 IS NOT NULL 
       THEN 
           append ('    l_param_8 := Substr(:NEW.'||l_hatm_rec.hatm_param_8||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_9 IS NOT NULL 
       THEN 
           append ('    l_param_9 := Substr(:NEW.'||l_hatm_rec.hatm_param_9||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_10 IS NOT NULL 
       THEN 
           append ('    l_param_10 := Substr(:NEW.'||l_hatm_rec.hatm_param_10||',1,1000);');
       END IF ;    
       append ('   l_halt_rec := hig_alert.get_halt('||pi_halt_id||');');       
       append ('   hig_alert.create_trg_alert(l_halt_rec,l_param_1,l_param_2,l_param_3,l_param_4,l_param_5,l_param_6,l_param_7,l_param_8,l_param_9,l_param_10,l_hal_rec.hal_subject,l_hal_rec.hal_mail_text);');
       append ('   hig_alert.insert_hal(l_hal_rec); ');
       FOR hatr IN (SELECT * FROM hig_alert_type_recipients WHERE hatr_halt_id = pi_halt_id)
       LOOP
           IF hatr.hatr_harr_id IS NOT NULL
           THEN
               l_harr_rec := hig_alert.get_harr(hatr.hatr_harr_id);
               IF l_harr_rec.harr_recipient_type = 'USER_ID'
               THEN               
                   append ('   FOR nmu IN (SELECT nmu_email_address email_address FROM nm_mail_users WHERE nmu_hus_user_id = :NEW.'||l_harr_rec.harr_attribute_name||') LOOP ');
                   append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');
                   append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
                   append ('       l_har_rec.har_recipient_email := nmu.email_address ; ');
                   append ('       l_har_rec.har_status          := ''Pending'' ; ' );
                   append ('       hig_alert.insert_har(l_har_rec); ');
                   append ('   END LOOP; ');     
               ELSE
                   append ('   FOR nmu IN ('||l_harr_rec.harr_sql ||' :NEW.'||l_harr_rec.harr_attribute_name||') LOOP ');
                   append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');
                   append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
                   append ('       l_har_rec.har_recipient_email := Lower(nmu.email_address) ; ');
                   append ('       l_har_rec.har_status          := ''Pending'' ; ' );
                   append ('       hig_alert.insert_har(l_har_rec); ');
                   append ('   END LOOP; ');
               END IF ;
           END IF ;
           IF hatr.hatr_nmu_id IS NOT NULL
           THEN
               append ('   FOR nmu IN (SELECT nmu_email_address FROM nm_mail_users WHERE nmu_id = '||hatr.hatr_nmu_id||') LOOP ');
               append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');
               append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
               append ('       l_har_rec.har_recipient_email := nmu.nmu_email_address ; ');
               append ('       l_har_rec.har_status          := ''Pending'' ; ' );
               append ('       hig_alert.insert_har(l_har_rec); ');
               append ('   END LOOP; ');
           END IF ;
           IF hatr.hatr_nmg_id IS NOT NULL
           THEN
               append ('   FOR nmg IN (SELECT nmu_email_address FROM nm_mail_group_membership,nm_mail_users WHERE nmgm_nmu_id = nmu_id AND nmgm_nmg_id = '||hatr.hatr_nmg_id||') LOOP ');
               append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');            
               append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
               append ('       l_har_rec.har_recipient_email := nmg.nmu_email_address ; ');
               append ('       l_har_rec.har_status          := ''Pending'' ; ' );
               append ('       hig_alert.insert_har(l_har_rec); ');
               append ('   END LOOP; ');
           END IF ;
       END LOOP;
       append ('   IF Nvl(l_halt_rec.halt_immediate,''N'') = ''Y''');
       append ('   THEN ');
       --append ('       FOR hnmd IN (SELECT * FROM hig_alert_recipients ');
       --append ('                    WHERE  har_hal_id = l_hal_rec.hal_id     ');
       --append ('                    AND    har_status = ''Pending'' ');
       --append ('                    ORDER  BY har_date_created )');
       --append ('      LOOP ');
       append ('       hig_alert.send_mail(pi_hal_id => l_hal_rec.hal_id); ');
       --append ('      END LOOP; ');
       append ('       hig_alert.upd_hal_status(l_hal_rec.hal_id,''Completed''); ');   
       --END LOOP;
       append ('   END IF ;'); 
   ELSE  
       append ('   l_hal_rec.hal_pk_id := :OLD.'||pi_pk_col||' ;');
       IF l_hatm_rec.hatm_param_1 IS NOT NULL 
       THEN 
           append ('    l_param_1 := := Substr(:OLD.'||l_hatm_rec.hatm_param_1||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_2 IS NOT NULL 
       THEN 
           append ('    l_param_2 := := Substr(:OLD.'||l_hatm_rec.hatm_param_2||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_3 IS NOT NULL 
       THEN 
           append ('    l_param_3 := := Substr(:OLD.'||l_hatm_rec.hatm_param_3||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_4 IS NOT NULL 
       THEN 
           append ('    l_param_4 := := Substr(:OLD.'||l_hatm_rec.hatm_param_4||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_5 IS NOT NULL 
       THEN 
           append ('    l_param_5 := := Substr(:OLD.'||l_hatm_rec.hatm_param_5||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_6 IS NOT NULL 
       THEN 
           append ('    l_param_6 := := Substr(:OLD.'||l_hatm_rec.hatm_param_6||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_7 IS NOT NULL 
       THEN 
           append ('    l_param_7 := := Substr(:OLD.'||l_hatm_rec.hatm_param_7||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_8 IS NOT NULL 
       THEN 
           append ('    l_param_8 := := Substr(:OLD.'||l_hatm_rec.hatm_param_8||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_9 IS NOT NULL 
       THEN 
           append ('    l_param_9 := := Substr(:OLD.'||l_hatm_rec.hatm_param_9||',1,1000);');
       END IF ;
       IF l_hatm_rec.hatm_param_10 IS NOT NULL 
       THEN 
           append ('    l_param_10 := Substr(:OLD.'||l_hatm_rec.hatm_param_10||',1,1000);');
       END IF ;  
       append ('   l_halt_rec := hig_alert.get_halt('||pi_halt_id||');');
       append ('   hig_alert.create_trg_alert(l_halt_rec,l_param_1,l_param_2,l_param_3,l_param_4,l_param_5,l_param_6,l_param_7,l_param_8,l_param_9,l_param_10,l_hal_rec.hal_subject,l_hal_rec.hal_mail_text);');
       append ('   hig_alert.insert_hal(l_hal_rec); ');
       FOR hatr IN (SELECT * FROM hig_alert_type_recipients WHERE hatr_halt_id = pi_halt_id)
       LOOP
           IF hatr.hatr_harr_id IS NOT NULL
           THEN
               l_harr_rec := hig_alert.get_harr(hatr.hatr_harr_id);
               IF l_harr_rec.harr_recipient_type = 'USER_ID'
               THEN               
                   append ('   FOR nmu IN (SELECT nmu_email_address email_address FROM nm_mail_users WHERE nmu_hus_user_id = :OLD.'||l_harr_rec.harr_attribute_name||') LOOP ');
                   append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');
                   append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
                   append ('       l_har_rec.har_recipient_email := nmu.email_address ; ');
                   append ('       l_har_rec.har_status          := ''Pending'' ; ' );
                   append ('       hig_alert.insert_har(l_har_rec); ');
                   append ('   END LOOP; ');     
               ELSE
                   append ('   FOR nmu IN ('||l_harr_rec.harr_sql ||' :OLD.'||l_harr_rec.harr_attribute_name||') LOOP ');
                   append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');
                   append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
                   append ('       l_har_rec.har_recipient_email := Lower(nmu.email_address) ; ');
                   append ('       l_har_rec.har_status          := ''Pending'' ; ' );
                   append ('       hig_alert.insert_har(l_har_rec); ');
                   append ('   END LOOP; ');
               END IF ;
           END IF ;
           IF hatr.hatr_nmu_id IS NOT NULL
           THEN
               append ('   FOR nmu IN (SELECT nmu_email_address FROM nm_mail_users WHERE nmu_id = '||hatr.hatr_nmu_id||') LOOP ');
               append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');
               append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
               append ('       l_har_rec.har_recipient_email := nmu.nmu_email_address ; ');
               append ('       l_har_rec.har_status          := ''Pending'' ; ' );
               append ('       hig_alert.insert_har(l_har_rec); ');
               append ('   END LOOP; ');
           END IF ;
           IF hatr.hatr_nmg_id IS NOT NULL
           THEN
               append ('   FOR nmg IN (SELECT nmu_email_address FROM nm_mail_group_membership,nm_mail_users WHERE nmgm_nmu_id = nmu_id AND nmgm_nmg_id = '||hatr.hatr_nmg_id||') LOOP ');
               append ('       l_har_rec.har_hatr_id         := '||hatr.hatr_id||' ; ');
               append ('       l_har_rec.har_hal_id          := l_hal_rec.hal_id ; ');
               append ('       l_har_rec.har_recipient_email := nmg.nmu_email_address ; ');
               append ('       l_har_rec.har_status          := ''Pending'' ; ' );
               append ('       hig_alert.insert_har(l_har_rec); ');
               append ('   END LOOP; ');
           END IF ;
       END LOOP;
       append ('   IF Nvl(l_halt_rec.halt_immediate,''N'') = ''Y''');
       append ('   THEN ');
       --append ('       FOR hnmd IN (SELECT * FROM hig_alert_recipients ');
       --append ('                    WHERE  har_hal_id = l_hal_rec.hal_id     ');
       --append ('                    AND    har_status = ''Pending'' ');
       --append ('                    ORDER  BY har_date_created )');
       --append ('      LOOP ');
       append ('       hig_alert.send_mail(pi_hal_id => l_hal_rec.hal_id); ');
       --append ('      END LOOP; ');
       append ('       hig_alert.upd_hal_status(l_hal_rec.hal_id,''Completed''); ');   
       append ('   END IF ;');
   END IF;--
END trg_body;
--
FUNCTION create_trigger(pi_halt_id     IN  hig_alert_types.halt_id%TYPE
                       ,po_error_text OUT Varchar2 ) RETURN Boolean
IS
--
   l_cnt            Number := 0 ;
   l_trigger_name   Varchar2(30) ; 
   l_tab_level      Boolean ;
   l_trg_cnt        Number ;
   l_old_new        Varchar2(10) ;
   l_nit_rec        nm_inv_types%ROWTYPE;
   l_when_condition Boolean ;
   l_halt_rec       hig_alert_types%ROWTYPE;
   l_if_or          Varchar2(10) ;
--
BEGIN
--
--nm_debug.debug_on;
   g_trigger_text  := Null ;
   IF pi_halt_id IS NOT NULL
   THEN        
        l_halt_rec := get_halt(pi_halt_id);
        l_tab_level := True;
        l_when_condition := False;
        IF l_halt_rec.halt_trigger_name IS NOT NULL
        THEN
            l_trigger_name := l_halt_rec.halt_trigger_name;
        ELSE
            l_trigger_name := Substr(l_halt_rec.halt_table_name,1,24); 
            l_trigger_name := l_trigger_name ||'_ALT'; 
            FOR i in 1..99 
            LOOP 
                BEGIN
                   SELECT 1
                   INTO   l_trg_cnt 
                   FROM   hig_alert_types
                   WHERE  halt_nit_inv_type = l_halt_rec.halt_nit_inv_type
                   AND    halt_table_name   = l_halt_rec.halt_table_name 
                   AND    halt_trigger_name = Upper(l_trigger_name||i) ;
                EXCEPTION
                    WHEN OTHERS THEN
                        l_trigger_name := Upper(l_trigger_name||i) ;
                        Exit;
                END ;
            END LOOP;
            UPDATE hig_alert_types
            SET    halt_trigger_name = l_trigger_name 
            WHERE  halt_id           = pi_halt_id ;
        END IF ;         
        l_nit_rec := nm3get.get_nit(l_halt_rec.halt_nit_inv_type);                          
        append('CREATE OR REPLACE TRIGGER '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_trigger_name,'N');
        append('AFTER') ;
        append(l_halt_rec.halt_operation,'N');
        l_cnt := 0 ;
        FOR hata IN (SELECT * FROM hig_alert_type_attributes WHERE hata_halt_id = pi_halt_id)
        LOOP
            l_cnt := l_cnt + 1;
            IF l_cnt = 1
            THEN
                append('OF '||hata.hata_attribute_name);
            ELSE
                append(','||hata.hata_attribute_name,'N'); 
            END IF ; 
            l_tab_level := False;
        END LOOP;    
        append('ON '||l_halt_rec.halt_table_name);
        append('For Each Row');
        l_cnt := 0 ;
        FOR hatc IN (SELECT * FROM hig_alert_type_conditions WHERE hatc_halt_id = pi_halt_id ORDER BY hatc_id)
        LOOP
            l_when_condition := True;
            l_cnt := l_cnt + 1;
            IF l_cnt = 1
            THEN
                append('WHEN');  
                append('('); 
            ELSE
                append(hatc.hatc_operator);
            END IF ; 
            IF hatc.hatc_old_new_type = 'O'
            THEN
                append (hatc.hatc_pre_bracket,'N');
                IF hatc.hatc_condition IN ( 'IS NULL','IS NOT NULL')
                THEN
                    append('(OLD.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition|| ' )' );
                ELSE
                    append('(OLD.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition||' '''||hatc.hatc_attribute_value||''')' );
                END IF ;
                append (hatc.hatc_post_bracket,'N');
                ELSIF hatc.hatc_old_new_type = 'N'
                THEN
                    append (hatc.hatc_pre_bracket,'N');
                    IF hatc.hatc_condition IN ( 'IS NULL','IS NOT NULL')
                    THEN
                        append('(NEW.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition|| ' )' );                    
                    ELSE
                        append('(NEW.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition||' '''||hatc.hatc_attribute_value||''')' );
                    END IF ;
                    append (hatc.hatc_post_bracket,'N');
                ELSE
                    append (hatc.hatc_pre_bracket,'N');
                    IF hatc.hatc_condition IN ( 'IS NULL','IS NOT NULL')
                    THEN
                        append('(OLD.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition||' OR ' );
                        append(' NEW.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition||' )' );
                    ELSE
                        append('(OLD.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition||' '''||hatc.hatc_attribute_value||''' OR ' );
                        append(' NEW.'||hatc.hatc_attribute_name||' '||hatc.hatc_condition||' '''||hatc.hatc_attribute_value||''')' );
                    END IF ;
                    append (hatc.hatc_post_bracket,'N'); 
                END IF ; 
        END LOOP;  
        IF l_when_condition
        THEN
            append(')'); 
        END IF ;
        append('DECLARE');
        append ('--');
        append ('-- Alert Trigger for '||l_halt_rec.halt_table_name);
        append ('-- Generated '||TO_CHAR(SYSDATE,c_date_format));
        append ('-- automatically by '||g_package_name);
        append ('-- '||g_package_name||' version information');
        append ('-- Header : '||get_version);
        append ('-- Body   : '||get_body_version);
        append ('   l_hal_rec hig_alerts%ROWTYPE; ');
        append ('   l_halt_rec hig_alert_types%ROWTYPE; ');        
        append ('   l_har_rec hig_alert_recipients%ROWTYPE; '); 
        append ('   l_param_1     Varchar2(1000); ');
        append ('   l_param_2     Varchar2(1000); ');
        append ('   l_param_3     Varchar2(1000); ');
        append ('   l_param_4     Varchar2(1000); ');
        append ('   l_param_5     Varchar2(1000); ');
        append ('   l_param_6     Varchar2(1000); ');
        append ('   l_param_7     Varchar2(1000); ');
        append ('   l_param_8     Varchar2(1000); ');
        append ('   l_param_9     Varchar2(1000); ');
        append ('   l_param_10    Varchar2(1000); ');
        append ('   l_subject     Varchar2(1000); ');
        append ('   l_email_body  Clob; ');
        append ('BEGIN');
        append ('--');
        append ('   l_hal_rec.hal_halt_id := '||l_halt_rec.halt_id||';'); 
        IF l_halt_rec.halt_operation = 'Update'
        THEN
            l_cnt := 0 ;
            IF l_tab_level
            THEN
                FOR ita IN (SELECT * FROM nm_inv_type_attribs WHERE ita_inv_type = l_halt_rec.halt_nit_inv_type)
                LOOP               
                    l_cnt :=  l_cnt + 1;
                    IF l_cnt = 1
                    THEN
                        l_if_or := ' IF ';
                    ELSE
                        l_if_or := ' OR ';
                    END IF ;                    
                    IF ita.ita_format = 'DATE'
                    THEN
                        append  (l_if_or||' Nvl(:OLD.'||ita.ita_attrib_name||',Trunc(Sysdate+9999)) != '); append  ('Nvl(:NEW.'||ita.ita_attrib_name||',Trunc(Sysdate+9999))','N');
                    ELSIF ita.ita_format = 'VARCHAR2'
                    THEN
                        append  (l_if_or||' Nvl(:OLD.'||ita.ita_attrib_name||',''$$$$$$$$$$'') != '); append  ('Nvl(:NEW.'||ita.ita_attrib_name||',''$$$$$$$$$$'')','N');
                    ELSIF ita.ita_format = 'NUMBER'
                    THEN
                        append  (l_if_or||' Nvl(:OLD.'||ita.ita_attrib_name||',-999999999) != '); append  ('Nvl(:NEW.'||ita.ita_attrib_name||',-999999999)','N');                        
                    END IF ;
                END LOOP;
            ELSE             
                FOR halt IN (SELECT * FROM hig_alert_type_attributes,nm_inv_type_attribs 
                             WHERE  hata_halt_id = pi_halt_id
                             AND    ita_inv_type = l_halt_rec.halt_nit_inv_type
                             AND    hata_attribute_name = ita_attrib_name)
                LOOP
                    l_cnt :=  l_cnt + 1;
                    IF l_cnt = 1
                    THEN
                        l_if_or := ' IF ';
                    ELSE
                        l_if_or := ' OR ';
                    END IF ;
                    IF halt.ita_format = 'DATE'
                    THEN
                        append  (l_if_or||' Nvl(:OLD.'||halt.ita_attrib_name||',Trunc(Sysdate+9999)) != '); append  ('Nvl(:NEW.'||halt.ita_attrib_name||',Trunc(Sysdate+9999))','N');
                    ELSIF halt.ita_format = 'VARCHAR2'
                    THEN
                        append  (l_if_or||' Nvl(:OLD.'||halt.ita_attrib_name||',''$$$$$$$$$$'') != '); append  ('Nvl(:NEW.'||halt.ita_attrib_name||',''$$$$$$$$$$'')','N');
                    ELSIF halt.ita_format = 'NUMBER'
                    THEN
                        append  (l_if_or||' Nvl(:OLD.'||halt.ita_attrib_name||',-999999999) != '); append  ('Nvl(:NEW.'||halt.ita_attrib_name||',-999999999)','N');                        
                    END IF ;
                END LOOP;
            END IF ;
            append  ('THEN');   
            trg_body(l_halt_rec.halt_operation,l_halt_rec.halt_id,l_nit_rec.nit_foreign_pk_column) ;
            append  ('END IF;'); 
        ELSE
               trg_body(l_halt_rec.halt_operation,l_halt_rec.halt_id,l_nit_rec.nit_foreign_pk_column) ;
        END IF ; 
        append ('END;');
        g_trigger_text := Substr(g_trigger_text,2);
--nm_debug.debug_on;
--nm_debug.debug(l_trigger_name);
--nm_debug.debug(g_trigger_text);
--nm_debug.debug(Length(g_trigger_text));
       --Execute Immediate g_trigger_text||g_trigger_text1 ;
       nm3clob.execute_immediate_clob(g_trigger_text);
       Commit;
       g_trigger_text :=  Null ;
   END IF ; 
   Return True;
EXCEPTION
   WHEN OTHERS THEN        
       po_error_text := sqlerrm;
       BEGIN
       --
          UPDATE hig_alert_types
          SET    halt_trigger_name = Null 
          WHERE  halt_id           = pi_halt_id ;
          Commit ;
          Execute Immediate 'Drop Trigger '||l_trigger_name;
       -- 
       EXCEPTION
           WHEN OTHERS THEN
                NULL;
       END ;
       Return False;
--
END create_trigger;
--
FUNCTION get_trigger_status(pi_trigger_name hig_alert_types.halt_trigger_name%TYPE) 
RETURN varchar2
IS
--
  CURSOR c_get_status
  IS
  SELECT  INITCAP(dt.status)
  FROM    dba_triggers  dt
  WHERE   dt.trigger_name   = UPPER(pi_trigger_name)
  AND     owner = sys_context('NM3CORE','APPLICATION_OWNER');
 
   l_status Varchar2(50);
--
BEGIN
--
   OPEN  c_get_status;
   FETCH c_get_status INTO l_status;
   CLOSE c_get_status;

   RETURN l_status ;
--
END get_trigger_status ;
--
FUNCTION drop_trigger(pi_halt_id       IN  hig_alert_types.halt_id%TYPE
                     ,pi_trigger_name IN  hig_alert_types.halt_trigger_name%TYPE
                     ,po_error_text   OUT Varchar2) 
RETURN Boolean
IS
BEGIN
--
   UPDATE hig_alert_types
   SET    halt_trigger_name = Null 
   WHERE  halt_id           = pi_halt_id ;

   Execute Immediate 'DROP TRIGGER '||pi_trigger_name;
 
   Commit ;
   
   Return True;
--
EXCEPTION
    WHEN OTHERS THEN
    po_error_text := sqlerrm;
    Return False; 
END drop_trigger;
--
FUNCTION get_next_run_date(pi_hsfr_id IN hig_scheduling_frequencies.hsfr_frequency_id%TYPE)
RETURN DATE
IS
--
   CURSOR c_schedule_freq 
   IS
   SELECT *
   FROM   hig_scheduling_frequencies
   WHERE  hsfr_frequency_id = pi_hsfr_id;

   l_hsfr_rec hig_scheduling_frequencies%ROWTYPE;
  
   l_next_run_date Date ;
   l_hour          Varchar2(2);
--
BEGIN
--
   OPEN  c_schedule_freq;
   FETCH c_schedule_freq INTO l_hsfr_rec;
   CLOSE c_schedule_freq;
   --
   IF l_hsfr_rec.hsfr_interval_in_mins IS NOT NULL
   THEN
       l_next_run_date := Sysdate+(l_hsfr_rec.hsfr_interval_in_mins/1440) ;
   ELSE
       IF Lower(l_hsfr_rec.hsfr_frequency) Like 'freq=daily;%'
       THEN
           l_hour          := Rpad(Replace(Substr(l_hsfr_rec.hsfr_frequency,Instr(Lower(l_hsfr_rec.hsfr_frequency),'byhour=')+7,2),';'),2,'0') ;
           l_next_run_date := To_date(To_Char(Trunc(Sysdate),'dd-mon-yyyy')||' '||l_hour||':00:00','DD-MON-YYYY HH24:MI:SS');
           IF l_next_run_date <= Sysdate 
           THEN
               l_next_run_date := l_next_run_date + 1;
           END IF;              
       ELSIF Lower(l_hsfr_rec.hsfr_frequency) Like 'freq=hourly;%'
       THEN
           l_hour := To_Char(Sysdate,'HH24');
           IF l_hour = '23'
           THEN
               l_hour := '00';
               l_next_run_date := To_date(To_Char(Trunc(Sysdate),'dd-mon-yyyy')||' '||l_hour||':00:00','DD-MON-YYYY HH24:MI:SS');        
           ELSE
               l_hour := Rpad(l_hour+1,2,'0');
               l_next_run_date := To_date(To_Char(Trunc(Sysdate),'dd-mon-yyyy')||' '||l_hour||':00:00','DD-MON-YYYY HH24:MI:SS');               
           END IF ;
       END IF ;         
   END IF ;
   --
   RETURN l_next_run_date;
--
END get_next_run_date;
--
END hig_alert;
/
