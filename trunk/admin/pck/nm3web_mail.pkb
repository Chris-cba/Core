CREATE OR REPLACE PACKAGE BODY nm3web_mail AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web_mail.pkb-arc   2.3   Jul 04 2013 16:35:56   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3web_mail.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:56:34  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on         : 1.4
--
--
--   Author : Jonathan Mills
--
--   NM3 Web Mail package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.3  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web_mail';
--
   c_this_module  CONSTANT HIG_MODULES.hmo_module%TYPE := 'HIGWEB1902';
   c_module_title CONSTANT HIG_MODULES.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
-----------------------------------------------------------------------------
--
PROCEDURE check_sysopts;
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags;
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
PROCEDURE write_mail IS
--
   l_rec_nmu nm_mail_users%ROWTYPE;
--
   CURSOR cs_other_users (c_not_nmu NUMBER) IS
   SELECT nmu_id
         ,nmu_name
         ,hus_username
    FROM  nm_mail_users
         ,hig_users
   WHERE  nmu_id         != c_not_nmu
    AND   nmu_hus_user_id = hus_user_id (+)
   ORDER BY nmu_name;
--
   CURSOR cs_groups IS
   SELECT nmg_id
         ,nmg_name
    FROM  nm_mail_groups;
--
   l_tab_nmu_id       nm3type.tab_number;
   l_tab_nmu_name     nm3type.tab_varchar2000;
   l_tab_hus_username nm3type.tab_varchar30;
--
   l_tab_nmg_id       nm3type.tab_number;
   l_tab_nmg_name     nm3type.tab_varchar2000;
--
   l_user_desc VARCHAR2(32767);
--
   l_tab_value        nm3type.tab_varchar30;
   l_tab_prompt       nm3type.tab_varchar30;
   l_checked    VARCHAR2(8);
--
   l_tab_send_type    nm3type.tab_varchar4;
--
BEGIN
   --
   l_tab_value(1)  := nm3mail.c_user;
   l_tab_prompt(1) := 'User';
   l_tab_value(2)  := nm3mail.c_group;
   l_tab_prompt(2) := 'Group';
   --
   nm3web.module_startup(c_this_module);
   l_rec_nmu := get_my_nmu;
   check_sysopts;
   --
   OPEN  cs_other_users (l_rec_nmu.nmu_id);
   FETCH cs_other_users BULK COLLECT INTO l_tab_nmu_id, l_tab_nmu_name, l_tab_hus_username;
   CLOSE cs_other_users;
   IF l_tab_nmu_id.COUNT = 0
    THEN
      hig.raise_ner('HIG',67,NULL,'Mail Users (other than self)');
   END IF;
   --
   OPEN  cs_groups;
   FETCH cs_groups BULK COLLECT INTO l_tab_nmg_id, l_tab_nmg_name;
   CLOSE cs_groups;
   --
   nm3web.head(p_close_head => FALSE
              ,p_title      => c_module_title
              );
   nm3web.js_funcs;
   htp.p('var user_count='||l_tab_nmu_id.COUNT);
   htp.p('var users=new Array(user_count)');
   htp.p('var group_count='||l_tab_nmg_id.COUNT);
   htp.p('var groups=new Array(group_count)');
   htp.p('for (i=0; i<user_count; i++)');
   htp.p('   {');
   htp.p('   users[i]=new Array()');
   htp.p('   }');
   FOR i IN 1..l_tab_nmu_id.COUNT
    LOOP
      l_user_desc := l_tab_nmu_name(i);
      IF l_tab_hus_username(i) IS NOT NULL
       THEN
         l_user_desc := l_user_desc||' ('||l_tab_hus_username(i)||')';
      END IF;
      htp.p('   users['||i||']   =new Option("'||l_user_desc||'","'||l_tab_nmu_id(i)||'");');
   END LOOP;
   htp.p('for (i=0; i<group_count; i++)');
   htp.p('   {');
   htp.p('   groups[i]=new Array()');
   htp.p('   }');
   FOR i IN 1..l_tab_nmg_id.COUNT
    LOOP
      htp.p('   groups['||i||']   =new Option("'||l_tab_nmg_name(i)||'","'||l_tab_nmg_id(i)||'");');
   END LOOP;
   htp.p('function populate_user(p_option)');
   htp.p('   {');
   htp.p('   for (m=p_option.options.length-1;m>0;m--)');
   htp.p('      {');
   htp.p('      p_option.options[m]=null');
   htp.p('      }');
   htp.p('   for (i=0;i<users.length;i++)');
   htp.p('      {');
   htp.p('      p_option.options[i]=new Option(users[i].text,users[i].value)');
   htp.p('      }');
   htp.p('   p_option.options[0]=null');
   htp.p('   }');
   htp.p('function populate_group(p_option)');
   htp.p('   {');
   htp.p('   for (m=p_option.options.length-1;m>0;m--)');
   htp.p('      {');
   htp.p('      p_option.options[m]=null');
   htp.p('      }');
   htp.p('   for (i=0;i<groups.length;i++)');
   htp.p('      {');
   htp.p('      p_option.options[i]=new Option(groups[i].text,groups[i].value)');
   htp.p('      }');
   htp.p('   p_option.options[0]=null');
   htp.p('   }');
   htp.p('');
   htp.p('function initialise_form()');
   htp.p('   {');
   --
   l_tab_send_type.DELETE;
   l_tab_send_type(1) := 'to';
   l_tab_send_type(2) := 'cc';
   l_tab_send_type(3) := 'bcc';
   --
   FOR i IN 1..l_tab_send_type.COUNT
    LOOP
      htp.p('   populate_user(mail.p_'||l_tab_send_type(i)||'_user)');
   END LOOP;
   htp.p('   }');
   htp.p('//-->');
   htp.p('</SCRIPT>');
   htp.headclose;
   sccs_tags;
   htp.headclose;
   htp.bodyopen (cattributes=>'onLoad="initialise_form()"');
   --
   htp.formopen(g_package_name||'.send_mail', cattributes => 'NAME="mail"');
   htp.tableopen(cattributes=>'WIDTH=100% ALIGN=CENTER');
   --
   htp.tablerowopen(cattributes=>' ALIGN=CENTER');
   FOR j IN 1..l_tab_send_type.COUNT
    LOOP
      htp.p('<TD WIDTH=33%>');
         htp.tableopen(cattributes=>'ALIGN="CENTER"');
         htp.tablerowopen;
         htp.tableheader(INITCAP(l_tab_send_type(j)));
         htp.p('<TD>');
            htp.tableopen;
            htp.tablerowopen;
            l_checked := ' CHECKED';
            FOR i IN 1..l_tab_value.COUNT
             LOOP
               htp.p('<TD><INPUT TYPE=RADIO NAME="p_'||l_tab_send_type(j)||'_dest_type" VALUE="'||l_tab_value(i)||'"'||l_checked||' onClick="populate_'||lower(l_tab_value(i))||'(mail.p_'||l_tab_send_type(j)||'_user)">'||l_tab_prompt(i)||'</TD>');
               l_checked := NULL;
            END LOOP;
            htp.tablerowclose;
            htp.tablerowopen;
            htp.p('<TD COLSPAN='||l_tab_value.COUNT||'>');
            htp.p('<SELECT NAME="p_'||l_tab_send_type(j)||'_user" MULTIPLE HEIGHT=5>');
            htp.p('<OPTION VALUE="-1">Javascript Failure</OPTION>');
            htp.p('</SELECT>');
            htp.p('</TD>');
            htp.tablerowclose;
            htp.tableclose;
         htp.p('</TD>');
         htp.tablerowClose;
         htp.tableclose;
      htp.p('</TD>');
   END LOOP;
   htp.tablerowClose;
   htp.tableclose;
   --
   htp.tableopen(cattributes=>'WIDTH=100% ALIGN=CENTER');
   htp.tablerowopen;
   htp.tableheader('Subject');
   htp.tablerowClose;
   htp.tablerowopen;
   htp.p('<TD ALIGN=CENTER>');
      htp.formtext(cname      => 'p_subject'
                  ,cmaxlength => 255
                  ,csize      => 60
                  );
   htp.p('</TD>');
   htp.tablerowClose;
   --
   htp.tablerowopen;
   htp.tableheader('Message Text');
   htp.tablerowClose;
   htp.tablerowopen;
   htp.p('<TD ALIGN=CENTER>');
      htp.formtextarea(cname      => 'p_message'
                      ,nrows      => 5
                      ,ncolumns   => 60
                      );
   htp.p('</TD>');
   htp.tablerowClose;
   --
   htp.tablerowopen;
   htp.p('<TD ALIGN=CENTER>');
   htp.formsubmit (cvalue=>'Enqueue Message');
   htp.p('</TD>');
   htp.tablerowClose;
   --
   htp.formclose;
   --
   htp.bodyclose;
   htp.htmlclose;
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END write_mail;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_mail (p_to_user       owa_util.ident_arr DEFAULT g_empty_tab
                    ,p_to_dest_type  VARCHAR2           DEFAULT nm3mail.c_user
                    ,p_cc_user       owa_util.ident_arr DEFAULT g_empty_tab
                    ,p_cc_dest_type  VARCHAR2           DEFAULT nm3mail.c_user
                    ,p_bcc_user      owa_util.ident_arr DEFAULT g_empty_tab
                    ,p_bcc_dest_type VARCHAR2           DEFAULT nm3mail.c_user
                    ,p_subject       VARCHAR2           DEFAULT g_no_subject
                    ,p_message       VARCHAR2           DEFAULT NULL
                    ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_rec_nmu nm_mail_users%ROWTYPE;
--
   l_tab_to  nm3mail.tab_recipient;
   l_tab_cc  nm3mail.tab_recipient;
   l_tab_bcc nm3mail.tab_recipient;
--
   l_rec_recipient nm3mail.rec_recipient;
--
   l_tab_message nm3type.tab_varchar32767;
--
   PROCEDURE check_tab_rcpt (p_tab_1 nm3mail.tab_recipient
                            ,p_tab_2 nm3mail.tab_recipient
                            ) IS
      l_rec_rcpt_1 nm3mail.rec_recipient;
      l_rec_rcpt_2 nm3mail.rec_recipient;
   BEGIN
      FOR i IN 1..p_tab_1.COUNT
       LOOP
         l_rec_rcpt_1 := p_tab_1(i);
         FOR j IN 1..p_tab_2.COUNT
          LOOP
            l_rec_rcpt_2 := p_tab_2(j);
            IF   l_rec_rcpt_1.rcpt_type = l_rec_rcpt_2.rcpt_type
             AND l_rec_rcpt_1.rcpt_id   = l_rec_rcpt_2.rcpt_id
             THEN
               RAISE_APPLICATION_ERROR(-20001,'Recipient Specified more than once');
            END IF;
         END LOOP;
      END LOOP;
   END check_tab_rcpt;
--
BEGIN
   --
   nm_debug.proc_start(g_package_name,'send_mail');
   --
   nm3web.module_startup(c_this_module);
   l_rec_nmu := get_my_nmu;
   check_sysopts;
   --
   l_rec_recipient.rcpt_type    := p_to_dest_type;
   FOR i IN 1..p_to_user.COUNT
    LOOP
      l_rec_recipient.rcpt_id   := p_to_user(i);
      l_tab_to(i)               := l_rec_recipient;
   END LOOP;
   --
   l_rec_recipient.rcpt_type    := p_cc_dest_type;
   FOR i IN 1..p_cc_user.COUNT
    LOOP
      l_rec_recipient.rcpt_id   := p_cc_user(i);
      l_tab_cc(i)               := l_rec_recipient;
   END LOOP;
   --
   l_rec_recipient.rcpt_type    := p_bcc_dest_type;
   FOR i IN 1..p_bcc_user.COUNT
    LOOP
      l_rec_recipient.rcpt_id   := p_bcc_user(i);
      l_tab_bcc(i)              := l_rec_recipient;
   END LOOP;
   --
   -- Check the recipient tables against one another
   --  to make sure any recipient is not specified more than once
   --
   check_tab_rcpt (l_tab_to, l_tab_cc);
   check_tab_rcpt (l_tab_to, l_tab_bcc);
   check_tab_rcpt (l_tab_cc, l_tab_bcc);
   --
   l_tab_message(1) := p_message;
   l_tab_message(2) := CHR(10)||' ';
   l_tab_message(3) := CHR(10)||' ';
   l_tab_message(4) := CHR(10)||'Sent by   : '||nm3web.get_client_ip_address;
   l_tab_message(5) := CHR(10)||'Timestamp : '||to_char(sysdate,'DD-Mon-YYYY HH24:MI:SS');
   --
   nm3mail.write_mail_complete (p_from_user        => l_rec_nmu.nmu_id
                               ,p_subject          => p_subject
                               ,p_html_mail        => FALSE
                               ,p_tab_to           => l_tab_to
                               ,p_tab_cc           => l_tab_cc
                               ,p_tab_bcc          => l_tab_bcc
                               ,p_tab_message_text => l_tab_message
                               );
   --
   nm3web.head(p_title => c_module_title);
   htp.bodyopen;
   sccs_tags;
   --
   DECLARE
      l_ner EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_ner,-20666);
   BEGIN
      hig.raise_ner(nm3type.c_hig,139,-20666);
   EXCEPTION
     WHEN l_ner
      THEN
         htp.header(2,nm3flx.parse_error_message(SQLERRM));
   END;
   --
   htp.bodyclose;
   htp.htmlclose;
   --
   COMMIT;
   --
   nm_debug.proc_end(g_package_name,'send_mail');
   --
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN ROLLBACK;
  WHEN OTHERS
   THEN
     ROLLBACK;
     nm3web.failure(SQLERRM);
END send_mail;
--
-----------------------------------------------------------------------------
--
FUNCTION get_my_nmu (pi_raise_not_found BOOLEAN DEFAULT TRUE) RETURN nm_mail_users%ROWTYPE IS
--
   CURSOR cs_my_nmu  IS
   SELECT *
    FROM  nm_mail_users
   WHERE  nmu_hus_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'));
--
   l_rec_nmu nm_mail_users%ROWTYPE;
   l_found   BOOLEAN;
--
BEGIN
   --
   OPEN  cs_my_nmu;
   FETCH cs_my_nmu INTO l_rec_nmu;
   l_found := cs_my_nmu%FOUND;
   CLOSE cs_my_nmu;
   --
   IF NOT l_found
    AND pi_raise_not_found
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 86
                   ,pi_supplementary_info => 'Send mail from this account'
                   );
   END IF;
   --
   RETURN l_rec_nmu;
   --
END get_my_nmu;
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   SCCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : @(#)nm3web_mail.pkb	1.4 07/23/03');
   htp.p('--       Module Name      : nm3web_mail.pkb');
   htp.p('--       Date into SCCS   : 03/07/23 01:44:05');
   htp.p('--       Date fetched Out : 07/06/13 14:13:52');
   htp.p('--       SCCS Version     : 1.4');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   NM3 Web Mail package.');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_sysopts IS
   c_ner_app   CONSTANT VARCHAR2(6)  := 'HIG';
   c_ner_id    CONSTANT NUMBER       := 67;
   c_supp_text CONSTANT VARCHAR2(20) := ' product option';
BEGIN
   IF  nm3mail.g_smtp_server IS NULL
    THEN
      hig.raise_ner(c_ner_app,c_ner_id,NULL,nm3mail.g_server_sysopt||c_supp_text);
   ELSIF nm3mail.g_smtp_port IS NULL
    THEN
      hig.raise_ner(c_ner_app,c_ner_id,NULL,nm3mail.g_port_sysopt||c_supp_text);
   ELSIF nm3mail.g_smtp_domain IS NULL
    THEN
      hig.raise_ner(c_ner_app,c_ner_id,NULL,nm3mail.g_domain_sysopt||c_supp_text);
   END IF;
END check_sysopts;
--
-----------------------------------------------------------------------------
--
PROCEDURE can_mail_be_sent (pi_write_htp        IN     BOOLEAN
                           ,po_rec_nmu             OUT nm_mail_users%ROWTYPE
                           ,po_mail_can_be_sent IN OUT BOOLEAN
                           ) IS
BEGIN
   --
   nm_debug.proc_start(g_package_name,'can_mail_be_sent');
   --
   po_rec_nmu := nm3web_mail.get_my_nmu (FALSE);
   --
   IF pi_write_htp
    THEN
      htp.p('<FONT SIZE=-1>');
   END IF;
   --
   IF po_rec_nmu.nmu_id IS NULL
    THEN
      IF pi_write_htp
       THEN
         htp.p(hig.raise_and_catch_ner(nm3type.c_net,287));
         htp.br;
      END IF;
      po_mail_can_be_sent := FALSE;
   END IF;
   --
   IF  nm3mail.g_smtp_server IS NULL
    THEN
      IF pi_write_htp
       THEN
         htp.p(hig.raise_and_catch_ner(pi_appl               => nm3type.c_hig
                                      ,pi_id                 => 67
                                      ,pi_supplementary_info => nm3mail.g_server_sysopt||' product option'
                                      )
              );
         htp.br;
      END IF;
      po_mail_can_be_sent := FALSE;
   END IF;
   --
   IF nm3mail.g_smtp_port IS NULL
    THEN
      IF pi_write_htp
       THEN
         htp.p(hig.raise_and_catch_ner(pi_appl               => nm3type.c_hig
                                      ,pi_id                 => 67
                                      ,pi_supplementary_info => nm3mail.g_port_sysopt||' product option'
                                      )
              );
         htp.br;
      END IF;
      po_mail_can_be_sent := FALSE;
   END IF;
   --
   IF nm3mail.g_smtp_domain IS NULL
    THEN
      IF pi_write_htp
       THEN
         htp.p(hig.raise_and_catch_ner(pi_appl               => nm3type.c_hig
                                      ,pi_id                 => 67
                                      ,pi_supplementary_info => nm3mail.g_domain_sysopt||' product option'
                                      )
              );
         htp.br;
      END IF;
      po_mail_can_be_sent := FALSE;
   END IF;
   --
   IF pi_write_htp
    THEN
      htp.p('</FONT>');
   END IF;
   --
   nm_debug.proc_end(g_package_name,'can_mail_be_sent');
   --
END can_mail_be_sent;
--
-----------------------------------------------------------------------------
--
END nm3web_mail;
/
