CREATE OR REPLACE PACKAGE BODY nm3event_log AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3event_log.pkb-arc   2.2   Jul 04 2013 15:33:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3event_log.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:33:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version :  1.2
--
--   Author : Kevin Angus
--
--   Procs/Functions for manipulating the NM3 event log
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
  g_package_name     CONSTANT  varchar2(30) := 'nm3event_log';
  c_session_id       CONSTANT number       := NVL(USERENV('SESSIONID'),-1);
  c_terminal         CONSTANT varchar2(30) := NVL(USERENV('TERMINAL'),'Unknown');
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
-----------------------------------------------------------------------------
--
FUNCTION get_next_nel_id RETURN t_nel_id IS

  l_retval t_nel_id;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_next_nel_id');

  SELECT
    nel_id_seq.NEXTVAL
  INTO
    l_retval
  FROM
    dual;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_next_nel_id');

  RETURN l_retval;

END get_next_nel_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nel(pi_nel_rec IN t_nel_rec
                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ins_nel');

  INSERT INTO
    nm_event_log(nel_id
                ,nel_net_type
                ,nel_timestamp
                ,nel_terminal
                ,nel_session
                ,nel_source
                ,nel_event
                ,nel_severity)
  VALUES(pi_nel_rec.nel_id
        ,pi_nel_rec.nel_net_type
        ,pi_nel_rec.nel_timestamp
        ,pi_nel_rec.nel_terminal
        ,pi_nel_rec.nel_session
        ,pi_nel_rec.nel_source
        ,pi_nel_rec.nel_event
        ,pi_nel_rec.nel_severity);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ins_nel');

END ins_nel;
--
-----------------------------------------------------------------------------
--
FUNCTION get_net(pi_net_type IN t_net_type
                ) RETURN t_net_rec IS

  l_retval t_net_rec;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_net');

  SELECT
    *
  INTO
    l_retval
  FROM
    nm_event_types net
  WHERE
    net.net_type = pi_net_type;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_net');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    hig.raise_ner(pi_appl               => 'HIG'
                 ,pi_id                 => 67
                 ,pi_supplementary_info => 'NM_EVENT_TYPES.net_type = ' || pi_net_type);
             
  WHEN too_many_rows
  THEN
    hig.raise_ner(pi_appl               => 'HIG'
                 ,pi_id                 => 105
                 ,pi_supplementary_info => 'NM_EVENT_TYPES.net_type = ' || pi_net_type);
  
END get_net;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nel(pi_nel_id IN t_nel_id
                ) RETURN t_nel_rec IS

  l_retval t_nel_rec;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_nel');

  SELECT
    *
  INTO
    l_retval
  FROM
    nm_event_log nel
  WHERE
    nel.nel_id = pi_nel_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_nel');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    hig.raise_ner(pi_appl               => 'HIG'
                 ,pi_id                 => 67
                 ,pi_supplementary_info => 'NM_EVENT_LOG.nel_id = ' || pi_nel_id);
             
  WHEN too_many_rows
  THEN
    hig.raise_ner(pi_appl               => 'HIG'
                 ,pi_id                 => 105
                 ,pi_supplementary_info => 'NM_EVENT_LOG.nel_id = ' || pi_nel_id);
  
END get_nel;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_entry(pi_source   IN nm_event_log.nel_source%TYPE
                      ,pi_event    IN nm_event_log.nel_event%TYPE
                      ,pi_net_type IN nm_event_types.net_type%TYPE DEFAULT c_default_net_type
                      ,pi_severity IN nm_event_log.nel_severity%TYPE DEFAULT 3
                      ) IS

  PRAGMA autonomous_transaction;
  
  l_nel_rec t_nel_rec;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_entry');

  l_nel_rec.nel_id        := get_next_nel_id;
  l_nel_rec.nel_net_type  := pi_net_type;
  l_nel_rec.nel_timestamp := SYSDATE;
  l_nel_rec.nel_terminal  := c_terminal;
  l_nel_rec.nel_session   := c_session_id;
  l_nel_rec.nel_source    := pi_source;
  l_nel_rec.nel_event     := pi_event;
  l_nel_rec.nel_severity  := pi_severity;
  
  ins_nel(pi_nel_rec => l_nel_rec);
  
  COMMIT;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_entry');

END create_entry;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_alert_mail(pi_nel_id IN t_nel_id
                          ) IS
  
  CURSOR cs_nea_exists(p_net_type nm_event_types.net_type%TYPE
                      ,p_severity nm_event_alert_mails.nea_severity%TYPE
                      ) IS
    SELECT
      1
    FROM
      dual
    WHERE
      EXISTS(SELECT
               1
             FROM
               nm_event_alert_mails nea
             WHERE
               NVL(nea.nea_net_type, p_net_type) = p_net_type
             AND
               NVL(nea_severity, p_severity) = p_severity);
      
  CURSOR cs_nea(p_net_type nm_event_types.net_type%TYPE
               ,p_severity nm_event_alert_mails.nea_severity%TYPE
               ) IS
    SELECT
      nea_recipient,
      nea_recipient_type,
      nea_send_type
    FROM
      nm_event_alert_mails nea
    WHERE
      NVL(nea.nea_net_type, p_net_type) = p_net_type
    AND
      NVL(nea_severity, p_severity) = p_severity
    GROUP BY
      nea_recipient,
      nea_recipient_type,
      nea_send_type;
  
  l_mails_to_send boolean;
  
  l_dummy pls_integer;
  
  l_net_rec t_net_rec;
  l_nel_rec t_nel_rec;
  
  l_to_tab  nm3mail.tab_recipient;
  l_cc_tab  nm3mail.tab_recipient;
  l_bcc_tab nm3mail.tab_recipient;
  
  l_index pls_integer;
  
  l_message_tab nm3type.tab_varchar32767;
  
  l_title nm3type.max_varchar2;

  PROCEDURE append(p_text varchar2
                  ) IS
  BEGIN
     l_message_tab(l_message_tab.COUNT + 1) := p_text;
  END append;
                          
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'send_alert_mail');

  l_nel_rec := get_nel(pi_nel_id => pi_nel_id);
  l_net_rec := get_net(pi_net_type => l_nel_rec.nel_net_type);
  
  OPEN cs_nea_exists(p_net_type => l_nel_rec.nel_net_type
                    ,p_severity => l_nel_rec.nel_severity);
    FETCH cs_nea_exists INTO l_dummy;
    l_mails_to_send := cs_nea_exists%FOUND;
  CLOSE cs_nea_exists;
  
  IF l_mails_to_send
  THEN  
    --------------------
    --get all recipients
    --------------------
    FOR l_rec IN cs_nea(p_net_type => l_nel_rec.nel_net_type
                       ,p_severity => l_nel_rec.nel_severity)
    LOOP
      IF l_rec.nea_send_type = nm3mail.c_to
      THEN
        l_index := l_to_tab.COUNT + 1;
        l_to_tab(l_index).rcpt_id   := l_rec.nea_recipient;
        l_to_tab(l_index).rcpt_type := l_rec.nea_recipient_type;
      
      ELSIF l_rec.nea_send_type = nm3mail.c_cc
      THEN
        l_index := l_to_tab.COUNT + 1;
        l_cc_tab(l_index).rcpt_id   := l_rec.nea_recipient;
        l_cc_tab(l_index).rcpt_type := l_rec.nea_recipient_type;
      
      ELSIF l_rec.nea_send_type = nm3mail.c_bcc
      THEN
        l_index := l_to_tab.COUNT + 1;
        l_bcc_tab(l_index).rcpt_id   := l_rec.nea_recipient;
        l_bcc_tab(l_index).rcpt_type := l_rec.nea_recipient_type;
      END IF;
    END LOOP;

    ------------------------
    --build message contents
    ------------------------
    append('<HTML>');
    append('<BODY>');

    l_title := 'Severity ' || l_nel_rec.nel_severity || ' ' || l_net_rec.net_descr || ' has occurred.';
    
    append('<h1>' || l_title || '</h1>'); 

    append('Source: ' || l_nel_rec.nel_source);

    append('<hr>');

    append(l_nel_rec.nel_event);
    
    append('</BODY>');
    append('</HTML>');

    ----------------
    --create message
    ----------------
    nm3mail.write_mail_complete(p_from_user        => nm3mail.get_default_nmu_id
                               ,p_subject          => l_title
                               ,p_html_mail        => TRUE
                               ,p_tab_to           => l_to_tab
                               ,p_tab_cc           => l_cc_tab
                               ,p_tab_bcc          => l_bcc_tab
                               ,p_tab_message_text => l_message_tab);
      
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'send_alert_mail');

END send_alert_mail;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_nel_tab IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_nel_tab');

  FOR l_i IN 1..g_nel_id_tab.COUNT
  LOOP
    send_alert_mail(pi_nel_id => g_nel_id_tab(l_i));
  END LOOP;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_nel_tab');

END process_nel_tab;
--
-----------------------------------------------------------------------------
--
END nm3event_log;
/ 

