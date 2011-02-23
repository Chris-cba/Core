CREATE OR REPLACE PACKAGE BODY nm3mail AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mail.pkb-arc   2.7.1.0   Feb 23 2011 15:47:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3mail.pkb  $
--       Date into PVCS   : $Date:   Feb 23 2011 15:47:36  $
--       Date fetched Out : $Modtime:   Feb 23 2011 15:42:06  $
--       Version          : $Revision:   2.7.1.0  $
--       Based on SCCS version : 1.12
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   nm3mail package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.7.1.0  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3mail';
--
   TYPE tab_varchar IS TABLE OF varchar2(2000) INDEX BY binary_integer;
--
   g_mail_conn        utl_smtp.connection;
   g_rec_vi           v$instance%ROWTYPE;
--
   c_user_id CONSTANT hig_users.hus_user_id%TYPE := nm3user.get_user_id;
--
   g_include_sender_info_in_title CONSTANT BOOLEAN := NVL(hig.get_sysopt('SMTPAUDTIT'),'Y') = 'Y';
--
-----------------------------------------------------------------------------
--
PROCEDURE check_server;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_individual (p_rec_nmm IN OUT nm_mail_message%ROWTYPE);
--
----------------------------------------------------------------------------------------
--
PROCEDURE write_data (p_text     IN varchar2,p_crlf boolean DEFAULT TRUE);
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
PROCEDURE send_stored_mail IS
--
   CURSOR cs_to_send IS
   SELECT *
    FROM  nm_mail_message
   WHERE  nmm_status IS NULL
    AND   EXISTS (SELECT 1
                   FROM  nm_mail_message_recipients
                  WHERE  nmmr_nmm_id = nmm_id
                 )
    AND   EXISTS (SELECT 1
                   FROM  nm_mail_message_text
                  WHERE  nmmt_nmm_id = nmm_id
                 );
--
   l_open_connection boolean := FALSE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'send_stored_mail');
--
   check_server;
--
   FOR cs_rec IN cs_to_send
    LOOP
--
      IF NOT l_open_connection
       THEN
         --nm_debug.debug('Opening connection : '||g_smtp_server||' port '||g_smtp_port);
         g_mail_conn := utl_smtp.open_connection(g_smtp_server, g_smtp_port);
         --nm_debug.debug('Helo');
         utl_smtp.helo(g_mail_conn, g_smtp_domain);
         l_open_connection := TRUE;
         --nm_debug.debug('Connection open');
      END IF;
--
      send_individual (cs_rec);
      UPDATE nm_mail_message
       SET   nmm_status        = cs_rec.nmm_status
            ,nmm_date_modified = SYSDATE
            ,nmm_modified_by   = USER
      WHERE  nmm_id = cs_rec.nmm_id;
      COMMIT;
--
   END LOOP;
--
   IF l_open_connection
    THEN
      --nm_debug.debug('Closing connection');
      utl_smtp.quit(g_mail_conn);
      l_open_connection := FALSE;
      --nm_debug.debug('Connection closed');
   END IF;
--
   nm_debug.proc_end(g_package_name,'send_stored_mail');
--
EXCEPTION
  WHEN OTHERS
  THEN utl_smtp.quit(g_mail_conn);
       RAISE;
END send_stored_mail;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_individual (p_rec_nmm IN OUT nm_mail_message%ROWTYPE) IS
--
   l_tab_email_addr tab_varchar;
   l_tab_send_type  tab_varchar;
   l_tab_recipients tab_varchar;
--
   l_sender      varchar2(2000);
   l_sender_full varchar2(2000);
--
   CURSOR cs_sender (p_sender_id number) IS
   SELECT nmu_name||' <'||nmu_email_address||'>'
         ,nmu_email_address
    FROM  nm_mail_users
   WHERE  nmu_id = p_sender_id;
--
   l_to_list nm3type.max_varchar2;
   l_cc_list nm3type.max_varchar2;
--
   c_is_html CONSTANT BOOLEAN := (p_rec_nmm.nmm_html = 'Y');
--
BEGIN
--
   --nm_debug.proc_start(g_package_name,'send_individual');
--
   FOR cs_rec IN (SELECT nmu_email_address
                        ,nmmr_send_type
                        ,nmu_name
                   FROM  nm_mail_message_recipients
                        ,nm_mail_users
                  WHERE  nmmr_nmm_id    = p_rec_nmm.nmm_id
                   AND   nmmr_rcpt_id   = nmu_id
                   AND   nmmr_rcpt_type = c_user
                  UNION
                  SELECT nmu_email_address
                        ,nmmr_send_type
                        ,nmu_name
                   FROM  nm_mail_message_recipients
                        ,nm_mail_users
                        ,nm_mail_group_membership
                  WHERE  nmmr_nmm_id    = p_rec_nmm.nmm_id
                   AND   nmmr_rcpt_id   = nmgm_nmg_id
                   AND   nmgm_nmu_id    = nmu_id
                   AND   nmmr_rcpt_type = c_group
                  )
    LOOP
      l_tab_email_addr(l_tab_email_addr.COUNT+1) := cs_rec.nmu_email_address;
      l_tab_send_type(l_tab_send_type.COUNT+1)   := cs_rec.nmmr_send_type;
      l_tab_recipients(l_tab_recipients.COUNT+1) := cs_rec.nmu_name;
   END LOOP;
--
   OPEN  cs_sender (p_rec_nmm.nmm_from_nmu_id);
   FETCH cs_sender INTO l_sender_full, l_sender;
   CLOSE cs_sender;
--
   --nm_debug.debug('   utl_smtp.mail(g_mail_conn, "'||l_sender||'");');
   utl_smtp.mail(g_mail_conn, l_sender);
--
   --nm_debug.debug('   FOR l_count IN 1..l_tab_email_addr.COUNT');
   FOR l_count IN 1..l_tab_email_addr.COUNT
    LOOP
      DECLARE
         l_dummy varchar2(2000) := l_tab_email_addr(l_count);
      BEGIN
         --nm_debug.debug('         utl_smtp.rcpt(g_mail_conn, "'||l_dummy||'");');
         utl_smtp.rcpt(g_mail_conn, l_dummy);
         IF    l_tab_send_type(l_count) = c_to
          THEN
            IF l_to_list IS NOT NULL
             THEN
               l_to_list := l_to_list||'; ';
            END IF;
            l_to_list := l_to_list||l_dummy;
         ELSIF l_tab_send_type(l_count) = c_cc
          THEN
            IF l_cc_list IS NOT NULL
             THEN
               l_cc_list := l_to_list||'; ';
            END IF;
            l_cc_list := l_to_list||l_dummy;
         END IF;
      END;
   END LOOP;
--
   --nm_debug.debug('   utl_smtp.open_data (g_mail_conn);');
   utl_smtp.open_data (g_mail_conn);
--
   write_data('Date:' || TO_CHAR(p_rec_nmm.nmm_date_created, 'dd Mon yyyy hh24:mi:ss'));
   write_data('Subject:' || p_rec_nmm.nmm_subject);
   write_data('From:' || l_sender_full);
--
   FOR cs_rec IN (SELECT nmu_name||' <'||nmu_email_address||'>' send_to
                        ,nmmr_send_type
                   FROM  nm_mail_message_recipients
                        ,nm_mail_users
                  WHERE  nmmr_nmm_id    = p_rec_nmm.nmm_id
                   AND   nmmr_rcpt_id   = nmu_id
                   AND   nmmr_rcpt_type = c_user
                   AND   nmmr_send_type != c_bcc
                  UNION
                  SELECT nmg_name||' <'||REPLACE(nmg_name,' ','_')||'@'||g_smtp_domain||'>' send_to
                        ,nmmr_send_type
                   FROM  nm_mail_message_recipients
                        ,nm_mail_groups
                        ,nm_mail_group_membership
                  WHERE  nmmr_nmm_id    = p_rec_nmm.nmm_id
                   AND   nmmr_rcpt_id   = nmgm_nmg_id
                   AND   nmgm_nmg_id    = nmg_id
                   AND   nmmr_rcpt_type = c_group
                   AND   nmmr_send_type != c_bcc
                  )
    LOOP
      write_data(INITCAP(cs_rec.nmmr_send_type)||': '
                 ||cs_rec.send_to
                );
   END LOOP;
--
   IF c_is_html
    THEN
      write_data('MIME-Version: 1.0');
      write_data('Content-type: text/html');
   END IF;
--
   write_data(c_crlf);
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_mail_message_text
                  WHERE  nmmt_nmm_id = p_rec_nmm.nmm_id
                  ORDER BY nmmt_line_id
                 )
    LOOP
      write_data(cs_rec.nmmt_text_line,FALSE);
--      IF   cs_rec.nmmt_suppress_lf != 'Y'
--       THEN
--         IF c_is_html
--          THEN
--            write_data('<BR>');
----         ELSE
----            write_data(c_crlf,FALSE);
--         END IF;
--      END IF;
      IF c_is_html
       THEN
         write_data(c_crlf,FALSE);
      END IF;
   END LOOP;
--
   --nm_debug.debug('   utl_smtp.close_data (g_mail_conn);');
   utl_smtp.close_data (g_mail_conn);
--
   p_rec_nmm.nmm_status := 'Sent '||TO_CHAR(SYSDATE,'DD Mon YYYY HH24:MI:SS');
--
   --nm_debug.proc_end(g_package_name,'send_individual');
--
EXCEPTION
--
   WHEN others
    THEN
      utl_smtp.rset(g_mail_conn);
      p_rec_nmm.nmm_status := SQLERRM;
--
END send_individual;
--
----------------------------------------------------------------------------------------
--
PROCEDURE write_data (p_text     IN varchar2,p_crlf boolean DEFAULT TRUE) IS
   l_text nm3type.max_varchar2 := NVL(p_text,' ');
BEGIN
   l_text := REPLACE(l_text,c_lf,c_crlf);          -- replace all CHR(10) with CHR(13)||CHR(10)
   l_text := REPLACE(l_text,c_cr||c_crlf,c_crlf);  -- this will leave the propect of CHR(13)||CHR(13)||CHR(10) (if c_crlf was in there originally)
                                                   --  - so change them back to CHR(13)||CHR(10)
   IF p_crlf
    THEN
      utl_smtp.write_data(g_mail_conn,l_text||c_crlf);
   ELSE
      utl_smtp.write_data(g_mail_conn,l_text);
   END IF;
END write_data;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_nmg_id RETURN number IS
BEGIN
--
   RETURN nm3seq.next_nmg_id_seq;
--
END get_nmg_id;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_nmm_id RETURN number IS
BEGIN
--
   RETURN nm3seq.next_nmm_id_seq;
--
END get_nmm_id;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_nmmt_line_id RETURN number IS
BEGIN
--
   RETURN nm3seq.next_nmmt_line_id_seq;
--
END get_nmmt_line_id;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_nmu_id RETURN number IS
BEGIN
--
   RETURN nm3seq.next_nmu_id_seq;
--
END get_nmu_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE chunk_it (p_nmm_id number, p_text varchar2) IS
   l_substr              varchar2(500);
BEGIN
   IF LENGTH(p_text) <= c_chunk_size
    THEN
      INSERT INTO nm_mail_message_text(nmmt_nmm_id,nmmt_line_id,nmmt_text_line)
      VALUES (p_nmm_id,nm3mail.get_nmmt_line_id,NVL(p_text,' '));
   ELSE
      l_substr := SUBSTR(p_text,1,c_chunk_size);
      INSERT INTO nm_mail_message_text(nmmt_nmm_id,nmmt_line_id,nmmt_text_line)
      VALUES (p_nmm_id,nm3mail.get_nmmt_line_id,l_substr);
      chunk_it(p_nmm_id,SUBSTR(p_text,c_chunk_size+1,LENGTH(p_text)-c_chunk_size));
   END IF;
END chunk_it;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_line (p_nmm_id number, p_text varchar2) IS
BEGIN
   chunk_it(p_nmm_id,p_text);
END write_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_server IS
   PROCEDURE check_it (p_option VARCHAR2, p_value VARCHAR2) IS
   BEGIN
      IF p_value IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 163
                       ,pi_supplementary_info => p_option
                       );
      END IF;
   END check_it;
BEGIN
   check_it (g_server_sysopt,g_smtp_server);
   check_it (g_port_sysopt,g_smtp_port);
   check_it (g_domain_sysopt,g_smtp_domain);
--   IF  g_smtp_server IS NULL
--    OR g_smtp_port   IS NULL
--    OR g_smtp_domain IS NULL
--    THEN
--      Raise_Application_Error(-20001,'Product Options "'||g_server_sysopt||'","'||g_domain_sysopt||'" and "'||g_port_sysopt||'" must be set');
--   END IF;
END check_server;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmm (p_rec_nmm IN nm_mail_message%ROWTYPE) IS
   l_nmm_subject          nm3type.max_varchar2 := p_rec_nmm.nmm_subject;
   c_terminal    CONSTANT nm3type.max_varchar2 := USERENV('TERMINAL');
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmm');
--
   IF  USER = hig.get_application_owner
    OR get_nmu(p_rec_nmm.nmm_from_nmu_id).nmu_hus_user_id = c_user_id
    THEN
      IF g_include_sender_info_in_title
       THEN
         l_nmm_subject := l_nmm_subject||'(sent from ';
         IF c_terminal IS NOT NULL
          THEN
            l_nmm_subject := l_nmm_subject||c_terminal||' connected to ';
         END IF;
         l_nmm_subject := l_nmm_subject||g_rec_vi.instance_name||'@'||g_rec_vi.host_name||' as '||USER||' at '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS')||')';
         l_nmm_subject := SUBSTR(l_nmm_subject,1,255);
      END IF;
      INSERT INTO nm_mail_message
             (nmm_id
             ,nmm_subject
             ,nmm_status
             ,nmm_from_nmu_id
             ,nmm_html
             )
      VALUES (p_rec_nmm.nmm_id
             ,l_nmm_subject
             ,p_rec_nmm.nmm_status
             ,p_rec_nmm.nmm_from_nmu_id
             ,NVL(p_rec_nmm.nmm_html,'Y')
             );
   ELSE
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 220
                    );
      --Raise_Application_Error(-20001,'You can only send email as your own user');
   END IF;
--
   nm_debug.proc_end(g_package_name,'ins_nmm');
--
END ins_nmm;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmmr (p_rec_nmmr IN nm_mail_message_recipients%ROWTYPE) IS
--
   l_tab_rcpt_id   nm3type.tab_number;
   l_tab_rcpt_type nm3type.tab_varchar30;
   l_tab_send_type nm3type.tab_varchar30;
--
BEGIN
--
   l_tab_rcpt_id(1)   := p_rec_nmmr.nmmr_rcpt_id;
   l_tab_rcpt_type(1) := p_rec_nmmr.nmmr_rcpt_type;
   l_tab_send_type(1) := p_rec_nmmr.nmmr_send_type;
   ins_nmmr (p_nmm_id        => p_rec_nmmr.nmmr_nmm_id
            ,p_tab_rcpt_id   => l_tab_rcpt_id
            ,p_tab_rcpt_type => l_tab_rcpt_type
            ,p_tab_send_type => l_tab_send_type
            );
--
END ins_nmmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmmr (p_nmm_id            IN nm_mail_message.nmm_id%TYPE
                   ,p_tab_to            IN tab_recipient
                   ,p_tab_cc            IN tab_recipient
                   ,p_tab_bcc           IN tab_recipient
                   ) IS
--
   l_tab_rcpt_id   nm3type.tab_number;
   l_tab_rcpt_type nm3type.tab_varchar30;
   l_tab_send_type nm3type.tab_varchar30;
--
   l_count         pls_integer := 0;
--
BEGIN
--
   FOR i IN 1..p_tab_to.COUNT
    LOOP
      l_count := l_count + 1;
      l_tab_rcpt_id(l_count)   := p_tab_to(i).rcpt_id;
      l_tab_rcpt_type(l_count) := p_tab_to(i).rcpt_type;
      l_tab_send_type(l_count) := c_to;
   END LOOP;
--
   FOR i IN 1..p_tab_cc.COUNT
    LOOP
      l_count := l_count + 1;
      l_tab_rcpt_id(l_count)   := p_tab_cc(i).rcpt_id;
      l_tab_rcpt_type(l_count) := p_tab_cc(i).rcpt_type;
      l_tab_send_type(l_count) := c_cc;
   END LOOP;
--
   FOR i IN 1..p_tab_bcc.COUNT
    LOOP
      l_count := l_count + 1;
      l_tab_rcpt_id(l_count)   := p_tab_bcc(i).rcpt_id;
      l_tab_rcpt_type(l_count) := p_tab_bcc(i).rcpt_type;
      l_tab_send_type(l_count) := c_bcc;
   END LOOP;
--
   ins_nmmr (p_nmm_id        => p_nmm_id
            ,p_tab_rcpt_id   => l_tab_rcpt_id
            ,p_tab_rcpt_type => l_tab_rcpt_type
            ,p_tab_send_type => l_tab_send_type
            );
--
END ins_nmmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmmr (p_nmm_id            IN nm_mail_message.nmm_id%TYPE
                   ,p_tab_rcpt_id_to    IN nm3type.tab_number
                   ,p_tab_rcpt_type_to  IN nm3type.tab_varchar30
                   ,p_tab_rcpt_id_cc    IN nm3type.tab_number
                   ,p_tab_rcpt_type_cc  IN nm3type.tab_varchar30
                   ,p_tab_rcpt_id_bcc   IN nm3type.tab_number
                   ,p_tab_rcpt_type_bcc IN nm3type.tab_varchar30
                   ) IS
--
   l_tab_send_type nm3type.tab_varchar30;
--
BEGIN
--
   l_tab_send_type.DELETE;
   FOR i IN 1..p_tab_rcpt_id_to.COUNT
    LOOP
      l_tab_send_type(i) := c_to;
   END LOOP;
   ins_nmmr (p_nmm_id        => p_nmm_id
            ,p_tab_rcpt_id   => p_tab_rcpt_id_to
            ,p_tab_rcpt_type => p_tab_rcpt_type_to
            ,p_tab_send_type => l_tab_send_type
            );
--
   l_tab_send_type.DELETE;
   FOR i IN 1..p_tab_rcpt_id_cc.COUNT
    LOOP
      l_tab_send_type(i) := c_cc;
   END LOOP;
   ins_nmmr (p_nmm_id        => p_nmm_id
            ,p_tab_rcpt_id   => p_tab_rcpt_id_cc
            ,p_tab_rcpt_type => p_tab_rcpt_type_cc
            ,p_tab_send_type => l_tab_send_type
            );
--
   l_tab_send_type.DELETE;
   FOR i IN 1..p_tab_rcpt_id_bcc.COUNT
    LOOP
      l_tab_send_type(i) := c_bcc;
   END LOOP;
   ins_nmmr (p_nmm_id        => p_nmm_id
            ,p_tab_rcpt_id   => p_tab_rcpt_id_bcc
            ,p_tab_rcpt_type => p_tab_rcpt_type_to
            ,p_tab_send_type => p_tab_rcpt_type_bcc
            );
--
END ins_nmmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmmr (p_nmm_id         IN nm_mail_message.nmm_id%TYPE
                   ,p_tab_rcpt_id    IN nm3type.tab_number
                   ,p_tab_rcpt_type  IN nm3type.tab_varchar30
                   ,p_tab_send_type  IN nm3type.tab_varchar30
                   ) IS
--
   l_no_to EXCEPTION;
   l_to_found boolean := FALSE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmmr');
--
   IF  p_tab_rcpt_id.COUNT != p_tab_rcpt_type.COUNT
    OR p_tab_rcpt_id.COUNT != p_tab_send_type.COUNT
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'All arrays for recipents must have the same number of entries'
                    );
      --Raise_Application_Error(-20001,'All arrays for recipents must have the same number of entries');
   ELSIF p_tab_rcpt_id.COUNT = 0
    THEN
      RAISE l_no_to;
   END IF;
--
   FOR i IN 1..p_tab_rcpt_id.COUNT
    LOOP
      IF p_tab_send_type(i) = c_to
       THEN
         l_to_found := TRUE;
         EXIT;
      END IF;
   END LOOP;
--
   IF NOT l_to_found
    THEN
      RAISE l_no_to;
   END IF;
--
   FORALL i IN 1..p_tab_rcpt_id.COUNT
      INSERT INTO nm_mail_message_recipients
             (nmmr_nmm_id
             ,nmmr_rcpt_id
             ,nmmr_rcpt_type
             ,nmmr_send_type
             )
      VALUES (p_nmm_id
             ,p_tab_rcpt_id(i)
             ,NVL(p_tab_rcpt_type(i),c_user)
             ,NVL(p_tab_send_type(i),c_to)
             );
--
   nm_debug.proc_end(g_package_name,'ins_nmmr');
--
EXCEPTION
--
   WHEN l_no_to
    THEN
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 221
                    );
--      Raise_Application_Error(-20001,'All mail messages should have at least 1 "TO" recipient');
--
END ins_nmmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmmt (p_nmm_id         IN     nm_mail_message.nmm_id%TYPE
                   ,p_nmmt_line_id   IN OUT nm_mail_message_text.nmmt_line_id%TYPE
                   ,p_text_line      IN     varchar2
                   ) IS
--
   l_tab_text nm3type.tab_varchar32767;
--
BEGIN
--
   l_tab_text(1) := p_text_line;
   ins_nmmt (p_nmm_id         => p_nmm_id
            ,p_nmmt_line_id   => p_nmmt_line_id
            ,p_tab_text_line  => l_tab_text
            );
--
END ins_nmmt;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmmt (p_nmm_id         IN     nm_mail_message.nmm_id%TYPE
                   ,p_tab_text_line  IN     nm3type.tab_varchar32767
                   ) IS
   l_line_id nm_mail_message_text.nmmt_line_id%TYPE := 0;
BEGIN
--
   ins_nmmt (p_nmm_id         => p_nmm_id
            ,p_nmmt_line_id   => l_line_id
            ,p_tab_text_line  => p_tab_text_line
            );
--
END ins_nmmt;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmmt (p_nmm_id         IN     nm_mail_message.nmm_id%TYPE
                   ,p_nmmt_line_id   IN OUT nm_mail_message_text.nmmt_line_id%TYPE
                   ,p_tab_text_line  IN     nm3type.tab_varchar32767
                   ) IS
--
   l_tab_line_id     nm3type.tab_number;
   l_tab_chunked     nm3type.tab_varchar2000;
--
   PROCEDURE chunk_arr (p_text varchar2) IS
   BEGIN
      IF NVL(LENGTH(p_text),0) <= c_chunk_size
       THEN
         p_nmmt_line_id := p_nmmt_line_id + 1;
         l_tab_line_id(l_tab_line_id.COUNT+1)         := p_nmmt_line_id;
         l_tab_chunked(l_tab_chunked.COUNT+1)         := p_text;
      ELSE
         p_nmmt_line_id := p_nmmt_line_id + 1;
         l_tab_line_id(l_tab_line_id.COUNT+1)         := p_nmmt_line_id;
         l_tab_chunked(l_tab_chunked.COUNT+1)         := SUBSTR(p_text,1,c_chunk_size);
         chunk_arr(SUBSTR(p_text,c_chunk_size+1,LENGTH(p_text)-c_chunk_size));
      END IF;
   END chunk_arr;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmmt');
--
   p_nmmt_line_id := NVL(p_nmmt_line_id,0);
--
   FOR i IN 1..p_tab_text_line.COUNT
    LOOP
      chunk_arr (p_tab_text_line(i));
   END LOOP;
--
   FORALL i IN 1..l_tab_chunked.COUNT
      INSERT INTO nm_mail_message_text
             (nmmt_nmm_id
             ,nmmt_line_id
             ,nmmt_text_line
             )
      VALUES (p_nmm_id
             ,l_tab_line_id(i)
             ,NVL(l_tab_chunked(i),' ')
             );
--
   p_nmmt_line_id := p_nmmt_line_id + l_tab_chunked.COUNT;
--
   nm_debug.proc_end(g_package_name,'ins_nmmt');
--
END ins_nmmt;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmu (p_nmu_id IN nm_mail_users.nmu_id%TYPE) RETURN nm_mail_users%ROWTYPE IS
--
--   CURSOR cs_nmu (c_nmu_id nm_mail_users.nmu_id%TYPE) IS
--   SELECT *
--    FROM  nm_mail_users
--   WHERE  nmu_id = c_nmu_id;
----
--   l_rec_nmu nm_mail_users%ROWTYPE;
----
BEGIN
--
--   OPEN  cs_nmu (p_nmu_id);
--   FETCH cs_nmu INTO l_rec_nmu;
--   IF cs_nmu%NOTFOUND
--    THEN
--      CLOSE cs_nmu;
--      Raise_Application_Error(-20001,'NM_MAIL_USERS record not found');
--   END IF;
--   CLOSE cs_nmu;
--
   RETURN nm3get.get_nmu (p_nmu_id);
--
END get_nmu;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_send_mail_job (p_every_n_minutes number DEFAULT 10) IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
   c_bare_what CONSTANT varchar2(62) :=  g_package_name||'.send_stored_mail;';
   c_what               nm3type.max_varchar2;
--
   l_existing_job_id user_jobs.job%TYPE;
--
   l_job_id   binary_integer;
   l_found    BOOLEAN;
   l_interval nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'submit_send_mail_job');
--
   c_what :=            'DECLARE'
             ||CHR(10)||'--'
             ||CHR(10)||'-----------------------------------------------------------------------------'
             ||CHR(10)||'--'
             ||CHR(10)||'--   SCCS Identifiers :-'
             ||CHR(10)||'--'
             ||CHR(10)||'--       sccsid           : @(#)nm3mail.pkb	1.12 01/05/05'
             ||CHR(10)||'--       Module Name      : nm3mail.pkb'
             ||CHR(10)||'--       Date into SCCS   : 05/01/05 22:09:16'
             ||CHR(10)||'--       Date fetched Out : 07/06/13 14:12:34'
             ||CHR(10)||'--       SCCS Version     : 1.12'
             ||CHR(10)||'--'
             ||CHR(10)||'--'
             ||CHR(10)||'--   Author : Jonathan Mills'
             ||CHR(10)||'--'
             ||CHR(10)||'--   nm3mail sending job'
             ||CHR(10)||'--'
             ||CHR(10)||'-----------------------------------------------------------------------------'
             ||CHR(10)||'--	Copyright (c) exor corporation ltd, 2004'
             ||CHR(10)||'-----------------------------------------------------------------------------'
             ||CHR(10)||'--'
             ||CHR(10)||'   l_server_not_there EXCEPTION;'
             ||CHR(10)||'   PRAGMA EXCEPTION_INIT (l_server_not_there,-29278);'
             ||CHR(10)||'BEGIN'
             ||CHR(10)||'   '||c_bare_what
             ||CHR(10)||'EXCEPTION'
             ||CHR(10)||'   WHEN l_server_not_there'
             ||CHR(10)||'    THEN'
             ||CHR(10)||'      IF NVL(INSTR(SQLERRM,'||nm3flx.string('421')||',1,1),0) != 0'
             ||CHR(10)||'       THEN'
             ||CHR(10)||'         Null;'
             ||CHR(10)||'      ELSE'
             ||CHR(10)||'         RAISE;'
             ||CHR(10)||'      END IF;'
             ||CHR(10)||'END;';
--
   IF NVL(p_every_n_minutes,0) <= 0
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => TO_CHAR(NVL(p_every_n_minutes,0))||' <= 0'
                    );
   END IF;
   l_interval := 'SYSDATE+('||p_every_n_minutes||'/(60*24))';
--
   OPEN  cs_job (c_bare_what);
   FETCH cs_job INTO l_existing_job_id;
   l_found := cs_job%FOUND;
   CLOSE cs_job;
   IF l_found
    THEN
      -- modify the existing job
      dbms_job.change (job       => l_existing_job_id
                      ,what      => c_what
                      ,next_date => SYSDATE
                      ,interval  => l_interval
                      );
      dbms_job.broken (job       => l_existing_job_id
                      ,broken    => FALSE
                      );
   ELSE
      OPEN  cs_job (c_what);
      FETCH cs_job INTO l_existing_job_id;
      l_found := cs_job%FOUND;
      CLOSE cs_job;
      IF l_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 143
                       ,pi_supplementary_info => CHR(10)||c_what||CHR(10)||' (JOB_ID = '||l_existing_job_id||')'
                       );
      END IF;
   --
      dbms_job.submit
          (job       => l_job_id
          ,what      => c_what
          ,next_date => SYSDATE
          ,interval  => l_interval
          );
   --
   END IF;
--
   nm_debug.proc_end(g_package_name,'submit_send_mail_job');
--
   COMMIT;
--
END submit_send_mail_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_mail_complete (p_from_user        IN nm_mail_message.nmm_from_nmu_id%TYPE
                              ,p_subject          IN nm_mail_message.nmm_subject%TYPE
                              ,p_html_mail        IN boolean DEFAULT TRUE
                              ,p_tab_to           IN tab_recipient
                              ,p_tab_cc           IN tab_recipient
                              ,p_tab_bcc          IN tab_recipient
                              ,p_tab_message_text IN nm3type.tab_varchar32767
                              ) IS
--
   l_rec_nmm nm_mail_message%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'write_mail_complete');
--
   check_server;
--
   l_rec_nmm.nmm_id          := get_nmm_id;
   l_rec_nmm.nmm_subject     := p_subject;
   l_rec_nmm.nmm_status      := NULL;
   l_rec_nmm.nmm_from_nmu_id := p_from_user;
   l_rec_nmm.nmm_html        := nm3flx.i_t_e(p_html_mail,'Y','N');
   ins_nmm  (l_rec_nmm);
--
   ins_nmmr (p_nmm_id  => l_rec_nmm.nmm_id
            ,p_tab_to  => p_tab_to
            ,p_tab_cc  => p_tab_cc
            ,p_tab_bcc => p_tab_bcc
            );
--
   ins_nmmt (p_nmm_id        => l_rec_nmm.nmm_id
            ,p_tab_text_line => p_tab_message_text
            );
--
   nm_debug.proc_end(g_package_name,'write_mail_complete');
--
END write_mail_complete;
--
-----------------------------------------------------------------------------
--
FUNCTION nmm_predicate ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
   l_predicate nm3type.max_varchar2;
BEGIN
--
   IF nm3user.is_user_unrestricted
    THEN
      l_predicate := Null;
   ELSE
      l_predicate := 'EXISTS (SELECT 1 FROM nm_mail_users WHERE nmu_id = nmm_from_nmu_id AND nmu_hus_user_id = nm3user.get_user_id)';
   END IF;
   RETURN l_predicate;
--
END nmm_predicate;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_server_file_as_email
                              (p_from_user        IN nm_mail_message.nmm_from_nmu_id%TYPE
                              ,p_subject          IN nm_mail_message.nmm_subject%TYPE
                              ,p_html_mail        IN boolean DEFAULT TRUE
                              ,p_tab_to           IN tab_recipient
                              ,p_tab_cc           IN tab_recipient
                              ,p_tab_bcc          IN tab_recipient
                              ,p_file_path        IN varchar2
                              ,p_file_name        IN varchar2
                              ) IS
--
   l_tab_varchar nm3type.tab_varchar32767;
--
BEGIN
--
   nm3file.get_file (location     => p_file_path
                    ,filename     => p_file_name
                    ,max_linesize => 32767
                    ,all_lines    => l_tab_varchar
                    );
--
   write_mail_complete (p_from_user        => p_from_user
                       ,p_subject          => p_subject
                       ,p_html_mail        => p_html_mail
                       ,p_tab_to           => p_tab_to
                       ,p_tab_cc           => p_tab_cc
                       ,p_tab_bcc          => p_tab_bcc
                       ,p_tab_message_text => l_tab_varchar
                       );
--
END send_server_file_as_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_url_as_email
                              (p_from_user        IN nm_mail_message.nmm_from_nmu_id%TYPE
                              ,p_subject          IN nm_mail_message.nmm_subject%TYPE
                              ,p_html_mail        IN boolean DEFAULT TRUE
                              ,p_tab_to           IN tab_recipient
                              ,p_tab_cc           IN tab_recipient
                              ,p_tab_bcc          IN tab_recipient
                              ,p_url              IN varchar2
                              ) IS
--
   l_tab_varchar nm3type.tab_varchar32767;
   l_pieces      utl_http.html_pieces;
--
BEGIN
--
   l_pieces := utl_http.request_pieces(p_url);
--
   FOR i IN 1..l_pieces.COUNT
    LOOP
      l_tab_varchar(i) := l_pieces(i);
   END LOOP;
--
   write_mail_complete (p_from_user        => p_from_user
                       ,p_subject          => p_subject
                       ,p_html_mail        => p_html_mail
                       ,p_tab_to           => p_tab_to
                       ,p_tab_cc           => p_tab_cc
                       ,p_tab_bcc          => p_tab_bcc
                       ,p_tab_message_text => l_tab_varchar
                       );
--
END send_url_as_email;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_nmu_id RETURN nm_mail_users.nmu_id%TYPE IS

  l_retval nm_mail_users.nmu_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_default_nmu_id');

  SELECT
    nmu.nmu_id
  INTO
    l_retval
  FROM
    nm_mail_users nmu
  WHERE
    nmu.nmu_hus_user_id = hig.get_application_owner_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_default_nmu_id');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 286);

END get_default_nmu_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_nmu_id RETURN nm_mail_users.nmu_id%TYPE IS

  l_retval nm_mail_users.nmu_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_current_nmu_id');

  SELECT
    nmu.nmu_id
  INTO
    l_retval
  FROM
    nm_mail_users nmu
  WHERE
    nmu.nmu_hus_user_id = c_user_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_current_nmu_id');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 287);

END get_current_nmu_id;
--
FUNCTION send_mail (pi_mail_from     IN  Varchar2 Default Null
                   ,pi_recipient_to  IN  Varchar2 Default Null
                   ,pi_recipient_cc  IN  Varchar2 Default Null
                   ,pi_recipient_bcc IN  Varchar2 Default Null
                   ,pi_subject       IN  Varchar2 Default Null
                   ,pi_mailformat    IN  Varchar2 Default 'T' --T for Plain Text H for HTML
                   ,pi_mail_body     IN  Clob     Default Null 
                   ,pi_att_file_name IN  Varchar2 Default Null 
                   ,pi_file_att      IN  Blob     Default Null
                   ,po_error_text    Out Varchar2)
RETURN Boolean
IS
--
   --g_smtp_server   CONSTANT hig_options.hop_value%TYPE := 'gbexor284' ;     --hig.get_sysopt(g_server_sysopt);
   --g_smtp_port     CONSTANT hig_options.hop_value%TYPE := '25' ;            --hig.get_sysopt(g_port_sysopt);
   --g_smtp_domain   CONSTANT hig_options.hop_value%TYPE := 'exorcorp.local' ;--hig.get_sysopt(g_domain_sysopt); 
   --g_mail_conn     utl_smtp.connection;
   v_length integer := 0;
   v_buffer_size integer := 57;
   v_offset integer := 1;
   v_raw raw(57); 
   crlf    VARCHAR2(2)  := chr(13)||chr(10);
   i       Number ;
   j       Number ;
   l_email Varchar2(500);
   CURSOR cs_sender  
   IS
   SELECT nmu_name||' <'||nmu_email_address||'>' sender_name
         ,nmu_email_address sender_email
   FROM  nm_mail_users
   WHERE nmu_hus_user_id = nm3user.get_user_id ;
   l_sender_rec cs_sender%ROWTYPE;
   PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) 
   IS
   BEGIN
      utl_smtp.write_data(g_mail_conn, name || ': ' || header || utl_tcp.CRLF);
   END ;
--
BEGIN
--
--dbms_output.put_line(g_smtp_server||' '||g_smtp_port||' '||g_smtp_domain);
   OPEN  cs_sender ;
   FETCH cs_sender INTO l_sender_rec;
   CLOSE cs_sender;
   g_mail_conn := utl_smtp.open_connection(g_smtp_server, g_smtp_port);
   utl_smtp.helo(g_mail_conn, g_smtp_domain);   
   utl_smtp.mail(g_mail_conn, l_sender_rec.sender_email);
   IF pi_recipient_to IS NOT NULL
   THEN
       BEGIN
          i := 1;
          j := 1;
          While Instr(pi_recipient_to,';',i) != 0 
          LOOP
              l_email := Substr(pi_recipient_to,i,Instr(pi_recipient_to,';',i)-j);
              i := Instr(pi_recipient_to,';',i)+1;
              j := i;
              utl_smtp.rcpt(g_mail_conn, l_email); 
         END LOOP;
         l_email := Substr(pi_recipient_to,i,Length(pi_recipient_to));
         utl_smtp.rcpt(g_mail_conn, l_email);
       END ;
   END IF ;
   IF pi_recipient_cc IS NOT NULL
   THEN
       BEGIN
          i := 1;
          j := 1;
          While Instr(pi_recipient_cc,';',i) != 0 
          LOOP
              l_email := Substr(pi_recipient_cc,i,Instr(pi_recipient_cc,';',i)-j);
              i := Instr(pi_recipient_cc,';',i)+1;
              j := i;
              utl_smtp.rcpt(g_mail_conn, l_email); 
         END LOOP;
         l_email := Substr(pi_recipient_cc,i,Length(pi_recipient_cc));
         utl_smtp.rcpt(g_mail_conn, l_email);
       END ;
   END IF ;
   IF pi_recipient_bcc IS NOT NULL
   THEN
       BEGIN
          i := 1;
          j := 1;
          While Instr(pi_recipient_bcc,';',i) != 0 
          LOOP
              l_email := Substr(pi_recipient_bcc,i,Instr(pi_recipient_bcc,';',i)-j);
              i := Instr(pi_recipient_bcc,';',i)+1;
              j := i;
              utl_smtp.rcpt(g_mail_conn, l_email); 
         END LOOP;
         l_email := Substr(pi_recipient_bcc,i,Length(pi_recipient_bcc));
         utl_smtp.rcpt(g_mail_conn, l_email);
       END ;
   END IF ;
   utl_smtp.open_data(g_mail_conn);
   send_header('From',   pi_mail_from );
   IF pi_recipient_to IS NOT NULL
   THEN
       send_header('To',     pi_recipient_to  );
   END IF ;
   IF pi_recipient_cc IS NOT NULL
   THEN
       send_header('cc',          pi_recipient_cc  );
   END IF ;
   IF pi_recipient_bcc IS NOT NULL
   THEN
       send_header('Bcc',     pi_recipient_bcc  );
   END IF ;
   send_header('Subject', pi_subject);
   utl_smtp.write_data( g_mail_conn,'MIME-Version: 1.0'|| crlf || -- Use MIME mail standard
                         'Content-Type: multipart/mixed;'|| crlf ||
                         ' boundary="-----SECBOUND"'|| crlf ||crlf );

   IF pi_mailformat = 'H'
   THEN
       utl_smtp.write_data(g_mail_conn,'-------SECBOUND'|| crlf ||'Content-Type: text/html' || utl_tcp.crlf);  
   ELSE
       utl_smtp.write_data( g_mail_conn,'-------SECBOUND'|| crlf ||
                                        'Content-Type: text/plain;'|| crlf );      
   END IF ;
   --utl_smtp.write_data(g_mail_conn,crlf ||pi_mail_body|| crlf );  -- Message body   
   DECLARE
   --
     l_buffer     VARCHAR2(30000);
     l_amount     BINARY_INTEGER := 30000;
     l_pos        INTEGER := 1;
     l_clob_len   INTEGER;
   --
   BEGIN 
   --
     l_clob_len := DBMS_LOB.getlength (pi_mail_body);
     WHILE l_pos < l_clob_len
     LOOP  
         DBMS_LOB.READ (pi_mail_body,l_amount,l_pos,l_buffer);
         IF l_buffer IS NOT NULL
         THEN
             utl_smtp.write_data(g_mail_conn,crlf ||l_buffer|| crlf );  -- Message body
         END IF;
         l_pos :=   l_pos + l_amount;   
     END LOOP;
   END ;
   If pi_att_file_name is not null
   THen         
       utl_smtp.write_data( g_mail_conn, crlf ||'-------SECBOUND'|| crlf );
       utl_smtp.write_data( g_mail_conn, 'Content-Disposition: attachment; filename="' || pi_att_file_name || '"' || crlf);
       utl_smtp.write_data( g_mail_conn, crlf );      
       --Task 0110530 to remove the encoding from attachment, but now only Text attachment can be send    
       DECLARE
       --
          l_buffer     VARCHAR2(30000);
          l_amount     BINARY_INTEGER := 30000;
          l_pos        INTEGER := 1;
          l_clob_len   INTEGER;
          l_attachment_clob clob := nm3clob.blob_to_clob(pi_file_att);
       --
       BEGIN 
       --
          l_clob_len := DBMS_LOB.getlength (l_attachment_clob);
          WHILE l_pos < l_clob_len
          LOOP  
              DBMS_LOB.READ (l_attachment_clob,l_amount,l_pos,l_buffer);
              IF l_buffer IS NOT NULL
              THEN
                  utl_smtp.write_data(g_mail_conn,crlf ||l_buffer|| crlf );  -- Attachment Text 
              END IF;
              l_pos :=   l_pos + l_amount;   
          END LOOP;
       --
       END ;          
   END IF ;
   utl_smtp.write_data( g_mail_conn,crlf ||'-------SECBOUND--' );  -- End MIME mail
   utl_smtp.write_data( g_mail_conn, utl_tcp.crlf );
   --utl_smtp.write_data(g_mail_conn, utl_tcp.CRLF || pi_mail_body);
   DECLARE
   --
     l_buffer     VARCHAR2(30000);
     l_amount     BINARY_INTEGER := 30000;
     l_pos        INTEGER := 1;
     l_clob_len   INTEGER;
   --
   BEGIN 
   --
     l_clob_len := DBMS_LOB.getlength (pi_mail_body);
     WHILE l_pos < l_clob_len
     LOOP  
         DBMS_LOB.READ (pi_mail_body,l_amount,l_pos,l_buffer);
         IF l_buffer IS NOT NULL
         THEN
             utl_smtp.write_data(g_mail_conn,crlf ||l_buffer|| crlf );  -- Message body
         END IF;
         l_pos :=   l_pos + l_amount;   
     END LOOP;
   END ;
   utl_smtp.close_data(g_mail_conn);
   RETURN  TRUE;
EXCEPTION
  WHEN utl_smtp.transient_error OR utl_smtp.permanent_error 
  THEN           
      po_error_text := sqlerrm; --'SMTP server is down or unavailable';
      utl_smtp.quit(g_mail_conn);
      RETURN  FALSE;

  WHEN OTHERS 
  THEN    
      po_error_text := SQLERRM;  
      BEGIN
      --
         utl_smtp.close_data(g_mail_conn); 
         utl_smtp.quit(g_mail_conn);
      --
      EXCEPTION
          WHEN OTHERS 
          THEN
              utl_smtp.quit(g_mail_conn);
              NULL;
      END ;
      RETURN  FALSE;
--
END send_mail;
--
-----------------------------------------------------------------------------
--
BEGIN
   DECLARE
      CURSOR cs_vi IS
      SELECT *
       FROM  v$instance;
   BEGIN
      OPEN  cs_vi;
      FETCH cs_vi INTO g_rec_vi;
      CLOSE cs_vi;
   END;
END nm3mail;
/
