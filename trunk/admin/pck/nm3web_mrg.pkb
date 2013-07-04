CREATE OR REPLACE PACKAGE BODY nm3web_mrg AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web_mrg.pkb-arc   2.3   Jul 04 2013 16:35:56   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3web_mrg.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:57:12  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on         : 1.3
--
--
--   Author : Jonathan Mills
--
--   Web Merge package body
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
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web_mrg';
--
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB7057';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
   c_continue         CONSTANT  nm_errors.ner_descr%TYPE    := hig.get_ner(nm3type.c_hig,165).ner_descr;
--
   c_client        CONSTANT varchar2(6) := 'CLIENT';
   c_server        CONSTANT varchar2(6) := 'SERVER';
   c_client_server CONSTANT varchar2(6) := 'C/S';
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags;
--
-----------------------------------------------------------------------------
--
FUNCTION mand_field RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION smaller (p_text varchar2) RETURN varchar2;
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
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   SCCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : @(#)nm3web_mrg.pkb	1.3 05/17/04');
   htp.p('--       Module Name      : nm3web_mrg.pkb');
   htp.p('--       Date into SCCS   : 04/05/17 03:17:50');
   htp.p('--       Date fetched Out : 07/06/13 14:13:54');
   htp.p('--       SCCS Version     : 1.3');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   NM3 Web Merge package.');
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
PROCEDURE main (pi_nmq_id nm_mrg_query.nmq_id%TYPE DEFAULT NULL) IS
   l_tab_nmq_id     nm3type.tab_number;
   l_tab_nmq_unique nm3type.tab_varchar30;
BEGIN
--
   nm_debug.proc_start(g_package_name,'main');
--
   IF pi_nmq_id IS NOT NULL
    THEN
      specific_query (p_nmq_id => pi_nmq_id);
   ELSE
      nm3web.module_startup(c_this_module);
   --
      nm3web.head(p_close_head => TRUE
                 ,p_title      => c_module_title
                 );
      sccs_tags;
      htp.bodyopen;
      nm3dbms_job.make_sure_processes_available;
      --
      nm3mrg_security.reset_all_security_states;
      --
      SELECT nmq_id
            ,nmq_unique
       BULK  COLLECT
       INTO  l_tab_nmq_id
            ,l_tab_nmq_unique
       FROM  nm_mrg_query_executable
      WHERE  EXISTS (SELECT 1
                      FROM  nm_mrg_output_file
                     WHERE  nmf_nmq_id = nmq_id
                    )
      ORDER BY nmq_unique;
      --
      IF l_tab_nmq_id.COUNT = 0
       THEN
         htp.small(hig.raise_and_catch_ner (pi_appl => nm3type.c_net
                                           ,pi_id   => 326
                                           )
                  );
      ELSE
         htp.formopen(g_package_name||'.specific_query', cattributes => 'NAME="specific_query"');
         htp.tableopen;
         htp.tablerowopen;
         htp.tableheader('Select Query'||mand_field);
         htp.p('<TD>');
         htp.p('<SELECT NAME="p_nmq_id">');
         FOR i IN 1..l_tab_nmq_id.COUNT
          LOOP
            htp.p('<OPTION VALUE="'||l_tab_nmq_id(i)||'">'||l_tab_nmq_unique(i)||'</OPTION>');
         END LOOP;
         htp.p('</SELECT>');
         htp.p('</TD>');
         htp.tabledata(htf.formsubmit (cvalue=>c_continue));
         htp.tablerowclose;
         htp.tableclose;
         htp.formclose;
      END IF;
      --
      htp.bodyclose;
      htp.htmlclose;
   END IF;
--
   nm_debug.proc_end(g_package_name,'main');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN others
   THEN
     nm3web.failure(SQLERRM);
END main;
--
-----------------------------------------------------------------------------
--
PROCEDURE specific_query (p_nmq_id nm_mrg_query.nmq_id%TYPE) IS
--
   l_rec_nmq          nm_mrg_query%ROWTYPE;
   l_tab_nmf_id       nm3type.tab_number;
   l_tab_nmf_filename nm3type.tab_varchar30;
--
   PROCEDURE blank_row (p_text varchar2 DEFAULT NULL) IS
   BEGIN
      htp.tablerowopen;
      htp.tabledata(NVL(p_text,nm3web.c_nbsp),cattributes=>'COLSPAN=3 ALIGN=CENTER');
      htp.tablerowclose;
   END blank_row;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'specific_query');
--
   nm3web.module_startup(c_this_module);
   --
   nm3web.head(p_close_head => FALSE
              ,p_title      => c_module_title
              );
--   htp.p('<script language="JavaScript" src="'||nm3web.get_download_url('date-picker.js')||'"></script>');
   htp.headclose;
   sccs_tags;
   htp.bodyopen;
--
   nm3dbms_job.make_sure_processes_available;
   l_rec_nmq := nm3get.get_nmq (pi_nmq_id => p_nmq_id);
--
   nm3mrg.validate_mrg_query (l_rec_nmq.nmq_id);
--
   htp.formopen(g_package_name||'.run_query', cattributes => 'NAME="run_query"');
   htp.tableopen (cattributes=>'BORDER=0');
   htp.tablerowopen;
   htp.tableheader ('Query'||mand_field, cattributes=>'ALIGN=RIGHT');
   htp.p('<TD COLSPAN=2>');
   htp.formhidden (cname   => 'p_nmq_id'
                  ,cvalue  => l_rec_nmq.nmq_id
                  );
   htp.p (l_rec_nmq.nmq_unique||' - '||l_rec_nmq.nmq_descr);
   htp.tablerowclose;
   --
   SELECT nmf_id
         ,nmf_filename
    BULK  COLLECT
    INTO  l_tab_nmf_id
         ,l_tab_nmf_filename
    FROM  nm_mrg_output_file
   WHERE  nmf_nmq_id = l_rec_nmq.nmq_id
   ORDER  BY nmf_filename;
   --
   htp.tablerowopen;
   htp.tableheader('Specification'||mand_field, cattributes=>'ALIGN=RIGHT');
   htp.p('<TD COLSPAN=2>');
   IF l_tab_nmf_id.COUNT = 1
    THEN
      htp.formhidden (cname   => 'p_nmf_id'
                     ,cvalue  => l_tab_nmf_id(1)
                     );
      htp.p(l_tab_nmf_filename(1));
   ELSE
      htp.p('<SELECT NAME="p_nmf_id">');
      FOR i IN 1..l_tab_nmf_id.COUNT
       LOOP
         htp.p('<OPTION VALUE="'||l_tab_nmf_id(i)||'">'||l_tab_nmf_filename(i)||'</OPTION>');
      END LOOP;
      htp.p('</SELECT>');
   END IF;
   htp.p('</TD>');
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader('Filename Prefix', cattributes=>'ALIGN=RIGHT');
   htp.tabledata(htf.formtext (cname=>'p_prefix',cvalue=>Sys_Context('NM3_SECURITY_CTX','USERNAME')||'_', cattributes=>'MAXLENGTH=35'),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   --
--   htp.tablerowopen;
--   htp.tableheader('Retain Results'||mand_field, cattributes=>'ALIGN=RIGHT');
--   htp.p('<TD COLSPAN=2>');
--      htp.tableopen;
--      htp.tablerowopen;
--      htp.tabledata('<INPUT TYPE=RADIO NAME="p_commit_results" VALUE="'||nm3type.c_true||'" CHECKED>'||smaller('Yes')||'</INPUT>');
--      htp.tabledata('<INPUT TYPE=RADIO NAME="p_commit_results" VALUE="'||nm3type.c_false||'">'||smaller('No')||'</INPUT>');
--      htp.tablerowclose;
--      htp.tableclose;
--   htp.p('</TD>');
--   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader('Output Style'||mand_field, cattributes=>'ALIGN=RIGHT');
   htp.p('<TD COLSPAN=2>');
      htp.tableopen;
      htp.tablerowopen;
      htp.tabledata('<INPUT TYPE=CHECKBOX NAME="p_do_txt" VALUE="Y">'||smaller('Fixed Width (.txt)')||'</INPUT>',cattributes=>'COLSPAN=2');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('<INPUT TYPE=CHECKBOX NAME="p_do_csv" VALUE="Y" CHECKED>'||smaller('Comma Seperated (.csv)')||'</INPUT>',cattributes=>'COLSPAN=2');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('<INPUT TYPE=CHECKBOX NAME="p_do_htm" VALUE="Y">'||smaller('HTML Table (.htm)')||'</INPUT>',cattributes=>'COLSPAN=2');
      htp.tablerowclose;
      htp.tableclose;
   htp.p('</TD>');
   htp.tablerowclose;
   --
   DECLARE
      l_rec_nmu nm_mail_users%ROWTYPE;
      l_sending_mail boolean := TRUE;
      l_checked varchar2(10) := ' CHECKED';
   BEGIN
      nm3web_mail.can_mail_be_sent (pi_write_htp        => FALSE
                                   ,po_rec_nmu          => l_rec_nmu
                                   ,po_mail_can_be_sent => l_sending_mail
                                   );
      IF l_sending_mail
       THEN
         htp.tablerowopen;
         htp.tableheader('File Availability'||mand_field, cattributes=>'ALIGN=RIGHT');
         htp.p('<TD COLSPAN=2>');
            htp.tableopen;
            htp.tablerowopen;
               FOR cs_rec IN (SELECT hco_code, hco_meaning
                            FROM  hig_codes
                           WHERE  hco_domain = 'MRG_OUTPUT_TYPE'
                          )
                LOOP
                  htp.tabledata('<INPUT TYPE=RADIO NAME="p_file_prod_type" VALUE="'||cs_rec.hco_code||'"'||l_checked||'>'||smaller(cs_rec.hco_meaning)||'</INPUT>');
                  l_checked := NULL;
               END LOOP;
            htp.tablerowclose;
            htp.tableclose;
         htp.p('</TD>');
         htp.tablerowclose;
      ELSE
         htp.formhidden (cname  => 'p_file_prod_type'
                        ,cvalue => c_server
                        );
      END IF;
   END;
   --
   htp.tablerowopen;
   htp.tableheader('Effective Date'||mand_field, cattributes=>'ALIGN=RIGHT');
   htp.tabledata(htf.formtext (cname       => 'p_effective_date'
                              ,cvalue      => TO_CHAR(To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'),Sys_Context('NM3CORE','USER_DATE_MASK'))
                              ,cattributes => 'MAXLENGTH=30'
                              )
--                 ||'<a href="javascript:show_calendar('||nm3flx.string('run_query.p_effective_date')||');" onmouseover="window.status='||nm3flx.string('Date Picker')||';return true;" onmouseout="window.status='||nm3flx.string('')||';return true;">XX</A>'
                ,cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader('Region Of Interest'||mand_field, cattributes=>'ALIGN=RIGHT');
   htp.tabledata(htf.formtext (cname=>'p_roi_unique',cvalue=>'', cattributes=>'MAXLENGTH=30'));
   htp.p('<TD>');
      htp.tableopen;
      htp.tablerowopen;
      htp.tabledata('<INPUT TYPE=RADIO NAME="p_roi_type" VALUE="'||nm3extent.c_route||'" CHECKED>'||smaller('Element')||'</INPUT>');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('<INPUT TYPE=RADIO NAME="p_roi_type" VALUE="'||nm3extent.c_saved||'">'||smaller('Saved Extent')||'</INPUT>');
      htp.tablerowclose;
      htp.tableclose;
   htp.p('</TD>');
   htp.tablerowclose;
   --
   blank_row(htf.formsubmit (cvalue=>c_continue));
   --
   htp.tableclose;
   --
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'specific_query');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN others
   THEN
     nm3web.failure(SQLERRM);
END specific_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE run_query (p_nmq_id         nm_mrg_query.nmq_id%TYPE
                    ,p_nmf_id         nm_mrg_output_file.nmf_id%TYPE
                    ,p_effective_date varchar2 DEFAULT TO_CHAR(To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'),'DD-MON-YYYY')
                    ,p_roi_unique     varchar2
                    ,p_roi_type       varchar2
                    ,p_prefix         varchar2
                    ,p_commit_results varchar2 DEFAULT 'TRUE'
                    ,p_do_txt         varchar2 DEFAULT 'N'
                    ,p_do_csv         varchar2 DEFAULT 'N'
                    ,p_do_htm         varchar2 DEFAULT 'N'
                    ,p_file_prod_type varchar2
                    ) IS
--
   PRAGMA autonomous_transaction;
--
   l_rec_nmq          nm_mrg_query%ROWTYPE;
   l_rec_nmf          nm_mrg_output_file%ROWTYPE;
   l_source_id        number;
--
   l_block            user_jobs.what%TYPE;
   l_job              user_jobs.job%TYPE;
   l_rec_nmu          nm_mail_users%ROWTYPE;
   l_sending_mail     boolean := TRUE;
--
   l_produce_server   boolean;
   l_produce_client   boolean;
--
   l_effective_date   date;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'run_query');
--
   nm3web.module_startup(c_this_module);
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
  -- htp.bodyopen (cattributes=>'onLoad="initialise_form()"');
   htp.bodyopen;
   nm3dbms_job.make_sure_processes_available;
--
   l_rec_nmq        := nm3get.get_nmq (pi_nmq_id => p_nmq_id);
   l_rec_nmf        := nm3get.get_nmf (pi_nmf_id => p_nmf_id);
--
   l_produce_client := p_file_prod_type IN (c_client,c_client_server);
   l_produce_server := p_file_prod_type IN (c_server,c_client_server);
--
   nm3mrg_output.validate_file (p_nmf_id  => p_nmf_id);
--
   IF p_effective_date IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'Effective Date'
                    );
   END IF;
--
   IF p_roi_unique IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'Region Of Interest'
                    );
   END IF;
--
   l_effective_date := hig.date_convert (p_effective_date);
   IF l_effective_date IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 137
                    ,pi_supplementary_info => p_effective_date
                    );
   END IF;
--
   IF   NVL(p_do_txt,'N') = 'N'
    AND NVL(p_do_csv,'N') = 'N'
    AND NVL(p_do_htm,'N') = 'N'
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'You must select at least one output style'
                    );
   END IF;
   --
   nm3user.set_effective_date(l_effective_date);
   --
   IF    p_roi_type = nm3extent.c_route
    THEN
      l_source_id := nm3net.get_ne_id (UPPER(p_roi_unique)); -- Will fail if NE_UNIQUE is not UNIQUE (allowed for different NT)
   ELSIF p_roi_type = nm3extent.c_saved
    THEN
      l_source_id := nm3get.get_nse (pi_nse_name => UPPER(p_roi_unique)).nse_id;
   ELSE
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'p_roi_type = '||p_roi_type
                    );
   END IF;
   --
   htp.HEADER (2,'Query enqueued');
   --
   l_block :=            'DECLARE'
              ||CHR(10)||' l_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;'
              ||CHR(10)||' l_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE;'
              ||CHR(10)||' l_tab_to nm3mail.tab_recipient;'
              ||CHR(10)||' l_tab_empty nm3mail.tab_recipient;'
              ||CHR(10)||' l_tab_mail_text nm3type.tab_varchar32767;'
              ||CHR(10)||' c_sysdate CONSTANT DATE := SYSDATE;'
              ||CHR(10)||' c_nmf_id  CONSTANT nm_mrg_output_file.nmf_id%TYPE := '||p_nmf_id||';'
              ||CHR(10)||' c_prefix  CONSTANT nm3type.max_varchar2 := '||nm3flx.string(RTRIM(p_prefix,'_'))||';'
              ||CHR(10)||' PROCEDURE append (p_text VARCHAR2) IS'
              ||CHR(10)||'  c PLS_INTEGER := l_tab_mail_text.COUNT+1;'
              ||CHR(10)||' BEGIN'
              ||CHR(10)||'  l_tab_mail_text(c) := p_text;'
              ||CHR(10)||' END append;'
              ||CHR(10)||' PROCEDURE add_pair (p_header VARCHAR2, p_detail VARCHAR2 DEFAULT NULL) IS'
              ||CHR(10)||' BEGIN'
              ||CHR(10)||'  append ('||nm3flx.string('<TR><TH>')||'||NVL(p_header,nm3web.c_nbsp)||'||nm3flx.string('</TH>')||');'
              ||CHR(10)||'  append ('||nm3flx.string('<TD>')||'||NVL(p_detail,nm3web.c_nbsp)||'||nm3flx.string('</TD></TR>')||');'
              ||CHR(10)||' END add_pair;'
              ||CHR(10)||' PROCEDURE do_filename (p_extension VARCHAR2, p_server BOOLEAN DEFAULT TRUE) IS'
              ||CHR(10)||'  l_filename nm3type.max_varchar2;'
              ||CHR(10)||' BEGIN'
              ||CHR(10)||'  IF p_server THEN'
              ||CHR(10)||'   add_pair (p_extension,nm3mrg_output.get_server_filename(c_nmf_id,c_prefix,p_extension));'
              ||CHR(10)||'  ELSE'
              ||CHR(10)||'   l_filename := nm3mrg_output.get_client_filename(c_nmf_id,l_job_id,c_prefix,p_extension);'
              ||CHR(10)||'   add_pair (p_extension,'||nm3flx.string('<A HREF="')||'||nm3web_load.get_full_download_url(l_filename)||'||nm3flx.string('">')||'||l_filename||'||nm3flx.string('</A>')||');'
              ||CHR(10)||'  END IF;'
              ||CHR(10)||' END do_filename;'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||' nm3user.set_effective_date(TO_DATE('||nm3flx.string(TO_CHAR(l_effective_date,'DDMMYYYY'))||','||nm3flx.string('DDMMYYYY')||'));'
              ||CHR(10)||' BEGIN';
   --
   nm3web_mail.can_mail_be_sent (pi_write_htp        => TRUE
                                ,po_rec_nmu          => l_rec_nmu
                                ,po_mail_can_be_sent => l_sending_mail
                                );
   IF l_sending_mail
    THEN
      l_block := l_block
              ||CHR(10)||'  l_tab_to(1).rcpt_id   := '||l_rec_nmu.nmu_id||';'
              ||CHR(10)||'  append ('||nm3flx.string('<HTML><BODY>')||');';
   END IF;
   l_block := l_block
              ||CHR(10)||'  nm3extent.create_temp_ne'
              ||CHR(10)||'   (pi_source_id  => '||l_source_id||' -- '||p_roi_unique
              ||CHR(10)||'   ,pi_source => nm3extent.c_'||LOWER(p_roi_type)
              ||CHR(10)||'   ,po_job_id => l_nte_job_id'
              ||CHR(10)||'   );'
              ||CHR(10)||'  nm3mrg.execute_mrg_query'
              ||CHR(10)||'   (pi_query_id  => '||p_nmq_id||' -- '||l_rec_nmq.nmq_unique
              ||CHR(10)||'   ,pi_nte_job_id => l_nte_job_id'
              ||CHR(10)||'   ,pi_description => '||nm3flx.string('Submitted by '||Sys_Context('NM3_SECURITY_CTX','USERNAME')||' at '||TO_CHAR(SYSDATE,nm3type.c_full_date_time_format))
              ||CHR(10)||'   ,po_result_job_id => l_job_id'
              ||CHR(10)||'   );'
              ||CHR(10)||'  nm3mrg_output.do_txt('||nm3flx.string(p_do_txt)||');'
              ||CHR(10)||'  nm3mrg_output.do_csv('||nm3flx.string(p_do_csv)||');'
              ||CHR(10)||'  nm3mrg_output.do_htm('||nm3flx.string(p_do_htm)||');'
              ||CHR(10)||'  nm3mrg_output.write_results'
              ||CHR(10)||'   (p_nqr_id  => l_job_id'
              ||CHR(10)||'   ,p_nmf_id => c_nmf_id -- '||l_rec_nmf.nmf_filename
              ||CHR(10)||'   ,p_prefix => c_prefix'
              ||CHR(10)||'   ,p_produce_server_file => nm3flx.char_to_boolean('||nm3flx.string(nm3flx.boolean_to_char(l_produce_server))||')'
              ||CHR(10)||'   ,p_produce_client_file => nm3flx.char_to_boolean('||nm3flx.string(nm3flx.boolean_to_char(l_produce_client))||')'
              ||CHR(10)||'   );';
   --
   IF l_sending_mail
    THEN
      l_block := l_block
              ||CHR(10)||' EXCEPTION'
              ||CHR(10)||'  WHEN others THEN append (htf.header(2,SQLERRM));';
   END IF;
   --
   l_block := l_block
              ||CHR(10)||' END;';
   --
   htp.p('<FONT SIZE=-1>');
   htp.br;
   htp.tableopen(cattributes=>'BORDER=1');
   htp.tablerowopen;
   htp.tableheader(htf.small('Filename'));
   htp.tabledata (htf.small(RTRIM(p_prefix,'_')||'_'||l_rec_nmf.nmf_filename));
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader(htf.small('Base Directory'));
   htp.tabledata (htf.small(l_rec_nmf.nmf_file_path));
   htp.tablerowclose;
   IF l_rec_nmf.nmf_append_merge_au_to_path = 'Y'
    THEN
      htp.tablerowopen;
      htp.tableheader(htf.small('Sub Directory'));
      htp.tabledata (htf.small(nm3ausec.get_nau_unit_code(nm3ausec.get_highest_au_of_au_type(hig.get_sysopt('MRGAUTYPE')))));
      htp.tablerowclose;
   END IF;
   htp.tableclose;
   htp.br;
   --
   IF l_sending_mail
    THEN
      l_block := l_block
              ||CHR(10)||' append ('||nm3flx.string('<TABLE BORDER=1>')||');'
              ||CHR(10)||' l_tab_to(1).rcpt_type := nm3mail.c_user;'
              ||CHR(10)||' add_pair ('||nm3flx.string('Submitted')||','||nm3flx.string(TO_CHAR(SYSDATE,nm3type.c_full_date_time_format))||');'
              ||CHR(10)||' add_pair ('||nm3flx.string('Started')||',to_char(c_sysdate,nm3type.c_full_date_time_format));'
              ||CHR(10)||' add_pair ('||nm3flx.string('Completed')||',to_char(SYSDATE,nm3type.c_full_date_time_format));'
--              ||CHR(10)||' add_pair ('||nm3flx.string(Null)||','||nm3flx.string(Null)||');'
              ||CHR(10)||' add_pair ('||nm3flx.string('Merge Query')||','||nm3flx.string(l_rec_nmq.nmq_unique)||');'
              ||CHR(10)||' add_pair ('||nm3flx.string('Effective Date')||','||nm3flx.string(TO_CHAR(l_effective_date,Sys_Context('NM3CORE','USER_DATE_MASK')))||');'
              ||CHR(10)||' add_pair ('||nm3flx.string('R.O.I.')||','||nm3flx.string(p_roi_unique)||');';
      IF l_produce_server
       THEN
         l_block := l_block
              ||CHR(10)||' add_pair ('||nm3flx.string('File Path (server)')||',nm3mrg_output.get_filepath (c_nmf_id,l_job_id));';
         l_block := l_block
              ||CHR(10)||' add_pair ('||nm3flx.string('Server Files')||');';
         IF p_do_txt = 'Y'
          THEN
            l_block := l_block
              ||CHR(10)||' do_filename ('||nm3flx.string('TXT')||');';
         END IF;
         IF p_do_csv = 'Y'
          THEN
            l_block := l_block
              ||CHR(10)||' do_filename ('||nm3flx.string('CSV')||');';
         END IF;
         IF p_do_htm = 'Y'
          THEN
            l_block := l_block
              ||CHR(10)||' do_filename ('||nm3flx.string('HTM')||');';
         END IF;
      END IF;
      IF l_produce_client
       THEN
         l_block := l_block
              ||CHR(10)||' add_pair ('||nm3flx.string('Client Files')||');';
         IF p_do_txt = 'Y'
          THEN
            l_block := l_block
              ||CHR(10)||' do_filename ('||nm3flx.string('TXT')||',FALSE);';
         END IF;
         IF p_do_csv = 'Y'
          THEN
            l_block := l_block
              ||CHR(10)||' do_filename ('||nm3flx.string('CSV')||',FALSE);';
         END IF;
         IF p_do_htm = 'Y'
          THEN
            l_block := l_block
              ||CHR(10)||' do_filename ('||nm3flx.string('HTM')||',FALSE);';
         END IF;
      END IF;
      l_block := l_block
              ||CHR(10)||' append ('||nm3flx.string('</TABLE></BODY></HTML>')||');'
              ||CHR(10)||' nm3mail.write_mail_complete'
              ||CHR(10)||'  (p_from_user => l_tab_to(1).rcpt_id'
              ||CHR(10)||'  ,p_subject => '||nm3flx.string('Merge Extract Completed')
              ||CHR(10)||'  ,p_html_mail => TRUE'
              ||CHR(10)||'  ,p_tab_to => l_tab_to'
              ||CHR(10)||'  ,p_tab_cc => l_tab_empty'
              ||CHR(10)||'  ,p_tab_bcc => l_tab_empty'
              ||CHR(10)||'  ,p_tab_message_text => l_tab_mail_text'
              ||CHR(10)||'  );';
      htp.p('Mail message will be delivered to <A HREF="mailto:'||l_rec_nmu.nmu_email_address||'">'||l_rec_nmu.nmu_email_address||'</A> when complete');
      htp.br;
   END IF;
   --
   IF NOT nm3flx.char_to_boolean(p_commit_results)
    THEN
      l_block := l_block
              ||CHR(10)||' -- Not retaining merge results'
              ||CHR(10)||' nm3del.del_nmqr (pi_nqr_mrg_job_id => l_job_id);';
   END IF;
   --
   l_block := l_block
              ||CHR(10)||' COMMIT;'
              ||CHR(10)||'END;';
   --
   nm_debug.delete_debug(TRUE);
   nm_debug.debug_on;
   nm_debug.DEBUG(l_block);
   nm_debug.debug_off;
   DBMS_JOB.SUBMIT (job  => l_job
                   ,what => l_block
                   );
   --
   htp.br;
   htp.p('DBMS Job ID = '||l_job);
   --
   htp.p('</FONT>');
   --
   htp.br;
   htp.br;
   htp.p('<MARQUEE BEHAVIOR="ALTERNATE">'||htf.HEADER(3,'You may now close this page')||'</MARQUEE>');
   --
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'run_query');
--
   COMMIT;
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN others
   THEN
     nm3web.failure(SQLERRM);
END run_query;
--
-----------------------------------------------------------------------------
--
FUNCTION mand_field RETURN varchar2 IS
BEGIN
   RETURN '<SUP>'||smaller('*')||'</SUP>';
END mand_field;
--
-----------------------------------------------------------------------------
--
FUNCTION smaller (p_text varchar2) RETURN varchar2 IS
BEGIN
   RETURN '<FONT SIZE=-1>'||p_text||'</FONT>';
END smaller;
--
-----------------------------------------------------------------------------
--
END nm3web_mrg;
/
