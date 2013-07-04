CREATE OR REPLACE PACKAGE BODY nm3load AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3load.pkb-arc   2.8   Jul 04 2013 16:11:52   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3load.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:11:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       Version          : $Revision:   2.8  $
--       Based on SCCS version : 1.26
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 Generic Loader package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   --g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3load.pkb	1.26 03/08/05"';
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.8  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3load';
--
   c_linesize  CONSTANT pls_integer  := 32767;
--
   c_table_short_name_prefix        varchar2(2) := 'l_';
--
   c_this_module     CONSTANT  hig_modules.hmo_module%TYPE := 'HIGWEB2030';
   c_module_title    CONSTANT  hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   c_utlfiledir_sysopt CONSTANT hig_option_list.hol_id%TYPE := 'UTLFILEDIR';
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_and_load (p_batch_no      nm_load_batches.nlb_batch_no%TYPE
                            ,p_validate_only boolean
                            );
--
-----------------------------------------------------------------------------
--
PROCEDURE kick_nlb (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE);
--
-----------------------------------------------------------------------------
--
FUNCTION get_column_date_mask (p_nlfc_nlf_id nm_load_file_cols.nlfc_nlf_id%TYPE
                              ,p_nlfc_seq_no nm_load_file_cols.nlfc_seq_no%TYPE
                              ) RETURN nm_load_file_cols.nlfc_date_format_mask%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_and_load_dbms_job (p_batch_no      nm_load_batches.nlb_batch_no%TYPE
                                     ,p_validate_only boolean
                                     ,p_produce_htp   boolean DEFAULT FALSE
                                     );
--
-----------------------------------------------------------------------------
--
PROCEDURE put_line_feed_on_end (p_tab_lines IN OUT NOCOPY nm3type.tab_varchar32767
                               ,p_size      IN OUT number
                               ,p_lf        IN     varchar2 DEFAULT CHR(10)
                               );
--
-----------------------------------------------------------------------------
--
FUNCTION dump_nlf (p_nlf_unique       nm_load_files.nlf_unique%TYPE
                  ,p_output_filename  nm_load_files.nlf_descr%TYPE DEFAULT NULL
                  ,p_delete_if_exists BOOLEAN                      DEFAULT TRUE
                  ,p_dump_to_utl_file BOOLEAN                      DEFAULT TRUE
                  ) RETURN VARCHAR2;
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
PROCEDURE create_holding_table (p_nlf_id nm_load_files.nlf_id%TYPE) IS
--
   l_block      nm3type.max_varchar2;
   l_table_name varchar2(30);
   l_tab_rec_nlfc tab_rec_nlfc;
--
   PROCEDURE append (p_text varchar2
                    ,p_nl   boolean DEFAULT TRUE
                    ) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_block := l_block||p_text;
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_holding_table');
--
   l_table_name := get_holding_table_name (p_nlf_id);
--
   IF nm3ddl.does_object_exist (p_object_name => l_table_name
                               ,p_object_type => 'TABLE'
                               )
    THEN
      EXECUTE IMMEDIATE 'DROP TABLE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_table_name;
   END IF;
--
   l_tab_rec_nlfc := get_tab_nlfc (p_nlf_id);
--
   append ('CREATE TABLE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_table_name,FALSE);
   append ('     (batch_no  NUMBER(9) NOT NULL');
   append ('     ,record_no NUMBER(9) NOT NULL');
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      append ('     ,'||l_tab_rec_nlfc(i).nlfc_holding_col||' '||l_tab_rec_nlfc(i).nlfc_datatype);
      IF l_tab_rec_nlfc(i).nlfc_datatype = nm3type.c_varchar
       THEN
         append ('('||l_tab_rec_nlfc(i).nlfc_varchar_size||')', FALSE);
      END IF;
      IF l_tab_rec_nlfc(i).nlfc_mandatory = 'Y'
       THEN
         append (' NOT NULL',FALSE);
      END IF;
   END LOOP;
   append ('     ,PRIMARY KEY (batch_no,record_no)');
   append ('     )');
   nm3ddl.create_object_and_syns (p_object_name  => l_table_name
                                 ,p_ddl_text     => l_block
                                 );
--
   DELETE FROM nm_load_batches
   WHERE  nlb_nlf_id = p_nlf_id;
--
   nm_debug.proc_end(g_package_name,'create_holding_table');
--
END create_holding_table;
--
-----------------------------------------------------------------------------
--
FUNCTION get_holding_table_name (p_nlf_id nm_load_files.nlf_id%TYPE) RETURN varchar2 IS
   l_nlf    nm_load_files%ROWTYPE;
BEGIN
   l_nlf := nm3get.get_nlf(p_nlf_id);
   RETURN NVL(l_nlf.nlf_holding_table, 'NM_LD_'||l_nlf.nlf_unique||'_TMP');
END get_holding_table_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE transfer_to_holding_dbms_job (p_nlf_id       nm_load_files.nlf_id%TYPE
                                       ,p_file_name    varchar2
                                       ,p_batch_source nm_load_batches.nlb_batch_source%TYPE DEFAULT 'S'
                                       ,p_produce_htp  boolean DEFAULT FALSE
                                       ) IS
--
   PRAGMA autonomous_transaction;
--
   l_job          pls_integer;
   l_block        user_jobs.what%TYPE;
   l_rec_nmu      nm_mail_users%ROWTYPE;
   l_sending_mail boolean := TRUE;
   l_rec_nlf      nm_load_files%ROWTYPE;
BEGIN
--
   nm_debug.proc_start (g_package_name,'transfer_to_holding_dbms_job');
--
   nm3dbms_job.make_sure_processes_available;
--
   IF p_produce_htp
    THEN
      nm3web.head (p_close_head => TRUE
                  ,p_title      => c_module_title
                  );
   --
      htp.bodyopen;
   --
      nm3web.module_startup(pi_module => c_this_module);
   END IF;
--
   l_rec_nlf := get_nlf (p_nlf_id);
--
   nm3web_mail.can_mail_be_sent (pi_write_htp        => p_produce_htp
                                ,po_rec_nmu          => l_rec_nmu
                                ,po_mail_can_be_sent => l_sending_mail
                                );
--
   l_block :=            'DECLARE'
              ||CHR(10)||'   l_tab_to         nm3mail.tab_recipient;'
              ||CHR(10)||'   l_tab_empty      nm3mail.tab_recipient;'
              ||CHR(10)||'   l_tab_mail_text  nm3type.tab_varchar32767;'
              ||CHR(10)||'   c_sysdate CONSTANT DATE := SYSDATE;'
              ||CHR(10)||'   l_batch_no nm_load_batches.nlb_batch_no%TYPE;'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||'   l_batch_no := '||g_package_name||'.transfer_to_holding'
              ||CHR(10)||'         (p_nlf_id       => '||p_nlf_id
              ||CHR(10)||'         ,p_file_name    => '||nm3flx.string(p_file_name)
              ||CHR(10)||'         ,p_batch_source => '||nm3flx.string(p_batch_source)
              ||CHR(10)||'         );';
--
   IF l_sending_mail
    THEN
      l_block := l_block
              ||CHR(10)||'   l_tab_to(1).rcpt_id   := '||l_rec_nmu.nmu_id||';'
              ||CHR(10)||'   l_tab_to(1).rcpt_type := nm3mail.c_user;'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Submitted          : '||TO_CHAR(SYSDATE,nm3type.c_full_date_time_format))||');'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Started            : ')||'||to_char(c_sysdate,nm3type.c_full_date_time_format));'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Completed          : ')||'||to_char(SYSDATE,nm3type.c_full_date_time_format));'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string(NULL)||');'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Load File          : '||l_rec_nlf.nlf_unique)||');'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('File Name          : '||p_file_name)||');'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Batch Number       : ')||'||l_batch_no);'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string(NULL)||');'
              ||CHR(10)||'   nm3mail.write_mail_complete'
              ||CHR(10)||'      (p_from_user        => l_tab_to(1).rcpt_id'
              ||CHR(10)||'      ,p_subject          => '||nm3flx.string('Batch ')||'||l_batch_no||'||nm3flx.string(' - Transfer to holding table complete')
              ||CHR(10)||'      ,p_html_mail        => FALSE'
              ||CHR(10)||'      ,p_tab_to           => l_tab_to'
              ||CHR(10)||'      ,p_tab_cc           => l_tab_empty'
              ||CHR(10)||'      ,p_tab_bcc          => l_tab_empty'
              ||CHR(10)||'      ,p_tab_message_text => l_tab_mail_text'
              ||CHR(10)||'      );';
      IF p_produce_htp
       THEN
         htp.p('Mail message will be delivered to <A HREF="mailto:'||l_rec_nmu.nmu_email_address||'">'||l_rec_nmu.nmu_email_address||'</A> when complete');
         htp.br;
      END IF;
   END IF;
--
   l_block := l_block
              ||CHR(10)||'   '||g_package_name||'.produce_log_files(l_batch_no,FALSE,'||nm3flx.boolean_to_char(l_sending_mail)||');'
              ||CHR(10)||'   COMMIT;'
              ||CHR(10)||'END;';
--
   DBMS_JOB.SUBMIT (job  => l_job
                   ,what => l_block
                   );
--
   IF p_produce_htp
    THEN
      htp.br;
      htp.br;
      htp.p('<MARQUEE BEHAVIOR="ALTERNATE">'||htf.HEADER(3,'You may now close this page')||'</MARQUEE>');
      htp.bodyclose;
      htp.htmlclose;
      --
      htp.tableopen;
      htp.tablerowopen;
      htp.formopen('nm3web_load.main');
      htp.tabledata(htf.formsubmit (cvalue=>nm3web_load.c_continue));
      htp.formclose;
--      htp.formopen('nm3web_load.process_existing');
--      htp.formhidden (cname  => 'p_nlb_batch_no'
--                     ,cvalue => p_nlb_batch_no
--                     );
--      htp.formhidden (cname  => 'p_process_subtype'
--                     ,cvalue => p_process_subtype
--                     );
--      htp.tabledata(htf.formsubmit (cvalue=>nm3get.get_hco(pi_hco_domain => 'CSV_PROCESS_SUBTYPE'
--                                                          ,pi_hco_code   => 'F'
--                                                          ).hco_meaning
--                                   )
--                   );
--      htp.formclose;
      htp.tablerowclose;
      htp.tableclose;
   END IF;
--
   nm_debug.proc_end (g_package_name,'transfer_to_holding_dbms_job');
--
   COMMIT;
--
END transfer_to_holding_dbms_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE transfer_to_holding (p_nlf_id       nm_load_files.nlf_id%TYPE
                              ,p_file_name    varchar2
                              ,p_batch_source nm_load_batches.nlb_batch_source%TYPE DEFAULT 'S'
                              ) IS
   l_dummy number;
BEGIN
   l_dummy := transfer_to_holding (p_nlf_id,p_file_name,p_batch_source/*, FALSE*/);
END transfer_to_holding;
--
-----------------------------------------------------------------------------
--
FUNCTION transfer_to_holding (p_nlf_id       nm_load_files.nlf_id%TYPE
                             ,p_file_name    varchar2
                             ,p_batch_source nm_load_batches.nlb_batch_source%TYPE DEFAULT 'S'
                             ) RETURN pls_integer IS
--
   l_block        nm3type.tab_varchar32767;
   l_table_name   varchar2(30);
   l_tab_rec_nlfc tab_rec_nlfc;
   l_rec_nlfc     nm_load_file_cols%ROWTYPE;
   l_rec_nlf      nm_load_files%ROWTYPE;
   l_delim        varchar2(10);
   l_pre_format   varchar2(200) := NULL;
   l_post_format  varchar2(200) := NULL;
--
   PROCEDURE append (p_text varchar2
                    ,p_nl   boolean DEFAULT TRUE
                    ) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_block,p_text,p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'transfer_to_holding');
--
   l_rec_nlf      := get_nlf (p_nlf_id);
   l_table_name   := get_holding_table_name (p_nlf_id);
   IF Nvl(nm3mapcapture_ins_inv.l_mapcap_run,'N') = 'N'   
   THEN
       g_batch_no     := nm3pbi.get_job_id;
   ELSe
       g_batch_no     := nm3mapcapture_ins_inv.l_batch_no;
   END IF;
   g_nlf_id       := p_nlf_id;
   g_filename     := p_file_name;
   l_delim        := 'CHR('||ASCII(l_rec_nlf.nlf_delimiter)||')';
   g_batch_source := p_batch_source;
--
   l_tab_rec_nlfc := get_tab_nlfc (p_nlf_id);
--
   IF p_batch_source = 'S'
    THEN
      nm3file.get_file (LOCATION     => l_rec_nlf.nlf_path
                       ,filename     => p_file_name
                       ,max_linesize => c_linesize
                       ,all_lines    => g_tab_lines
                       );
   ELSE
      DECLARE
         l_tab_lines nm3type.tab_varchar32767;
      BEGIN
         g_tab_lines.DELETE;
         l_tab_lines := nm3clob.clob_to_tab_varchar(nm3clob.blob_to_clob(nm3get.get_nuf(pi_name =>p_file_name).blob_content));
--         nm_debug.debug(l_tab_lines.COUNT);
         FOR i IN 1..l_tab_lines.COUNT
          LOOP
            l_tab_lines(i) := RTRIM (l_tab_lines(i),CHR(10));
            l_tab_lines(i) := RTRIM (l_tab_lines(i),CHR(13));
            IF l_tab_lines(i) IS NOT NULL
             THEN
               g_tab_lines(g_tab_lines.COUNT+1) := l_tab_lines(i);
            END IF;
         END LOOP;
--         nm_debug.debug(g_tab_lines.COUNT);
      END;
   END IF;
--
   append ('DECLARE',FALSE);
   append ('   PRAGMA AUTONOMOUS_TRANSACTION;');
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      l_rec_nlfc := l_tab_rec_nlfc(i);
      append ('   l_'||l_rec_nlfc.nlfc_holding_col||' nm3type.tab_');
      IF l_rec_nlfc.nlfc_datatype = nm3type.c_varchar
       THEN
         append ('varchar32767',FALSE);
      ELSE
         append (LOWER(l_rec_nlfc.nlfc_datatype),FALSE);
      END IF;
      append (';',FALSE);
   END LOOP;
   append ('   l_rec_no           nm3type.tab_number;');
   append ('   l_count            PLS_INTEGER;');
   append ('   l_tab_status       nm3type.tab_varchar4;');
   append ('   l_tab_error        nm3type.tab_varchar32767;');
   append ('   l_tab_lines        nm3type.tab_varchar32767;');
   append ('   l_col              VARCHAR2(30);');
   append ('   l_holding_varchar2 nm3type.max_varchar2;');
   append ('   l_holding_date     DATE;');
   append ('   l_holding_number   NUMBER;');
   append ('   l_record_seq       NUMBER;');
   append ('   l_nlb_rowid        ROWID;');
   append ('   l_rec_count        BINARY_INTEGER := 0;');
   append ('   c_commit_threshold CONSTANT NUMBER := '||get_commit_threshold||';');
   append ('--');
   append ('   PROCEDURE commit_and_lock IS');
   append ('   BEGIN');
   append ('      COMMIT;');
   append ('      nm3lock_gen.lock_nlb ('||g_package_name||'.g_batch_no,'''||g_filename||''');');
   append ('   END commit_and_lock;');
   append ('--');
   append ('   PROCEDURE bulk_insert_arrays IS');
   append ('   BEGIN');
   append ('--');
   append ('      FORALL i IN 1..l_rec_count');
   append ('         INSERT INTO '||l_table_name|| '(');
   append ('                 batch_no');
   append ('                ,record_no');
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      l_rec_nlfc := l_tab_rec_nlfc(i);
      append ('                ,'||l_rec_nlfc.nlfc_holding_col);
   END LOOP;
   append ('         )');
   append ('         VALUES ('||g_package_name||'.g_batch_no');
   append ('                ,l_rec_no(i) ');
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      l_rec_nlfc := l_tab_rec_nlfc(i);
      append ('                ,l_'||l_rec_nlfc.nlfc_holding_col||'(i)');
   END LOOP;
   append ('                );');
   append ('--');
   append ('      FORALL i IN 1..l_rec_count');
   append ('         INSERT INTO nm_load_batch_status');
   append ('                (nlbs_nlb_batch_no');
   append ('                ,nlbs_record_no');
   append ('                ,nlbs_status');
   append ('                ,nlbs_text');
   append ('                ,nlbs_input_line');
   append ('                )');
   append ('         VALUES ('||g_package_name||'.g_batch_no');
   append ('                ,l_rec_no(i)');
   append ('                ,l_tab_status(i)');
   append ('                ,l_tab_error(i)');
   append ('                ,l_tab_lines(i)');
   append ('                );');
   append ('--');
   append ('      UPDATE nm_load_batches');
   append ('       SET   nlb_record_count = nlb_record_count + l_rec_count');
   append ('      WHERE  ROWID            = l_nlb_rowid;');
   append ('--');
   append ('      commit_and_lock;');
   append ('--');
   append ('      l_rec_count := 0;');
   append ('      l_rec_no.DELETE;');
   append ('      l_tab_status.DELETE;');
   append ('      l_tab_error.DELETE;');
   append ('      l_tab_lines.DELETE;');
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      append ('      l_'||l_tab_rec_nlfc(i).nlfc_holding_col||'.DELETE;');
   END LOOP;
   append ('--');
   append ('   END bulk_insert_arrays;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   INSERT INTO nm_load_batches (nlb_batch_no,nlb_nlf_id,nlb_filename,nlb_record_count,nlb_batch_source)');
   append ('   VALUES ('||g_package_name||'.g_batch_no,'||g_package_name||'.g_nlf_id,'||g_package_name||'.g_filename,0,'||g_package_name||'.g_batch_source)');
   append ('   RETURNING ROWID INTO l_nlb_rowid;');
   append ('--');
   append ('   FOR i IN 1..'||g_package_name||'.g_tab_lines.COUNT');
   append ('    LOOP');
   append ('      BEGIN');
   append ('         '||g_package_name||'.g_single_line := '||g_package_name||'.g_tab_lines(i);');
   append ('         l_rec_count               := l_rec_count + 1 ;');
   append ('         IF Nvl(nm3mapcapture_ins_inv.l_mapcap_run,'||nm3flx.string('N')||') = '||nm3flx.string('Y')||' THEN ');
   append ('         nm3mapcapture_ins_inv.l_recod_no  := Nvl(nm3mapcapture_ins_inv.l_recod_no,0) +1 ;');
   append ('         l_record_seq := nm3mapcapture_ins_inv.l_recod_no ; ');
   append ('         ELSE ');
   append ('         l_record_seq := i ; ');
   append ('         END IF ;');
   append ('         l_rec_no(l_rec_count)     := l_record_seq ; ');
   append ('         l_tab_status(l_rec_count) := '||nm3flx.string('H')||';');
   append ('         l_tab_error(l_rec_count)  := Null;');
   append ('         l_tab_lines(l_rec_count)  := '||g_package_name||'.g_single_line;');
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      l_rec_nlfc := l_tab_rec_nlfc(i);
      DECLARE
         l_val         varchar2(200);
      BEGIN
         IF l_rec_nlfc.nlfc_mandatory = 'Y'
          THEN
            IF    l_rec_nlfc.nlfc_datatype = nm3type.c_varchar
             THEN
               l_val := nm3flx.string('.');
            ELSIF l_rec_nlfc.nlfc_datatype = nm3type.c_number
             THEN
               l_val := '-1';
            ELSIF l_rec_nlfc.nlfc_datatype = nm3type.c_date
             THEN
               l_val := 'TO_DATE('||nm3flx.string(TO_CHAR(nm3type.c_nvl_date,nm3type.c_full_date_time_format))||','||nm3flx.string(nm3type.c_full_date_time_format)||')';
            END IF;
         ELSE
            l_val := 'Null';
         END IF;
         append ('         l_'||l_rec_nlfc.nlfc_holding_col||'(l_rec_count) := '||l_val||';');
      END;
   END LOOP;
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      append ('--');
      l_rec_nlfc := l_tab_rec_nlfc(i);
      append ('         l_col := '||nm3flx.string(l_rec_nlfc.nlfc_holding_col)||';');

      l_pre_format  := NULL;
      l_post_format := NULL;
      IF l_rec_nlfc.nlfc_datatype = nm3type.c_date
       THEN
         DECLARE
            l_date_mask nm_load_file_cols.nlfc_date_format_mask%TYPE;
         BEGIN
            l_date_mask := get_column_date_mask (l_rec_nlfc.nlfc_nlf_id,l_rec_nlfc.nlfc_seq_no);
            IF l_date_mask IS NOT NULL
             THEN
               l_pre_format  := 'to_date(';
               l_post_format := ','||nm3flx.string(l_date_mask)||')';
            ELSE
               l_pre_format  := 'hig.date_convert(';
               l_post_format := ')';
            END IF;
         END;
      END IF;
      append ('         l_holding_'||LOWER(l_rec_nlfc.nlfc_datatype)||' := '||l_pre_format||g_package_name||'.get_csv_value_from_line('||l_rec_nlfc.nlfc_seq_no||','||l_delim||')'||l_post_format||';');
      IF l_rec_nlfc.nlfc_mandatory = 'Y'
       THEN
         append ('         IF l_holding_'||LOWER(l_rec_nlfc.nlfc_datatype)||' IS NULL');
         append ('          THEN');
         append ('            hig.raise_ner(nm3type.c_net,50);');
         append ('         END IF;');
      END IF;
      IF l_rec_nlfc.nlfc_datatype = nm3type.c_varchar
       THEN
         append ('         IF LENGTH(l_holding_'||LOWER(l_rec_nlfc.nlfc_datatype)||') > '||l_rec_nlfc.nlfc_varchar_size);
         append ('          THEN');
         append ('            hig.raise_ner(pi_appl       => nm3type.c_net');
         append ('                         ,pi_id         => 275');
         append ('                         ,pi_supplementary_info => LENGTH(l_holding_'||LOWER(l_rec_nlfc.nlfc_datatype)||')||'||nm3flx.string(' > '||l_rec_nlfc.nlfc_varchar_size));
         append ('                         );');
         append ('         END IF;');
      END IF;
      append ('         l_'||l_rec_nlfc.nlfc_holding_col||'(l_rec_count) := '||'l_holding_'||LOWER(l_rec_nlfc.nlfc_datatype)||';');
   END LOOP;
   append ('--');
   append ('      EXCEPTION');
   append ('         WHEN others');
   append ('          THEN');
   append ('            l_tab_error(l_rec_count)  := NVL(nm3flx.parse_error_code_and_message(sqlerrm),SQLERRM)||'||nm3flx.string(':')||'||l_col;');
   append ('            l_tab_status(l_rec_count) := '||nm3flx.string('X')||';');
   append ('      END;');
   append ('      IF MOD(i,c_commit_threshold) = 0');
   append ('       THEN');
   append ('         bulk_insert_arrays;');
   append ('      END IF;');
   append ('   END LOOP;');
   append ('   bulk_insert_arrays;');
   append ('   COMMIT;');
   append ('END;');
--   nm_debug.debug_on;
   nm3tab_varchar.debug_tab_varchar(l_block);
--   nm_debug.debug_off;
--
   nm3ddl.execute_tab_varchar(l_block);
--
   nm_debug.proc_end(g_package_name,'transfer_to_holding');
--
   RETURN g_batch_no;
--
END transfer_to_holding;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_nlfc (p_nlf_id nm_load_files.nlf_id%TYPE) RETURN tab_rec_nlfc IS
   l_tab_rec_nlfc tab_rec_nlfc;
BEGIN
   FOR cs_rec IN (SELECT *
                   FROM  nm_load_file_cols
                  WHERE  nlfc_nlf_id = p_nlf_id
                  ORDER BY nlfc_seq_no
                 )
    LOOP
      l_tab_rec_nlfc(l_tab_rec_nlfc.COUNT+1) := cs_rec;
   END LOOP;
   RETURN l_tab_rec_nlfc;
END get_tab_nlfc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_csv_value_from_line (p_seq        nm_load_file_cols.nlfc_seq_no%TYPE
                                 ,p_delim_char VARCHAR2 DEFAULT ','
                                 ,p_line       VARCHAR2
                                 ) RETURN VARCHAR2 IS
   l_before_seq    nm_load_file_cols.nlfc_seq_no%TYPE := p_seq - 1;
   l_substr_before pls_integer;
   l_substr_after  pls_integer;
   l_single_line   nm3type.max_varchar2 := p_line;
   l_retval        nm3type.max_varchar2;
BEGIN
--
   IF ASCII(p_delim_char) = 8
    THEN
      l_single_line := REPLACE(l_single_line,CHR(9),p_delim_char);
   END IF;
--
   IF NVL(p_seq,0) <= 0
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 110
                    ,pi_supplementary_info => 'p_seq ('||p_seq||') must be >= 1'
                    );
   ELSIF p_seq = 1
    THEN
      l_substr_before := 1;
   ELSE
      l_substr_before := INSTR(l_single_line,p_delim_char,1,l_before_seq)+1;
   END IF;
--
   IF   l_substr_before = 1
    AND p_seq           > 1
    THEN
      -- there is not a "n"th delimiter so return null
      l_retval := Null;
   ELSE
      l_substr_after := INSTR(l_single_line,p_delim_char,1,p_seq)-1;
   --
      IF NVL(l_substr_after,-1) = -1
       THEN
         l_substr_after := LENGTH(l_single_line);
      END IF;
--
      l_retval := nm3flx.mid(l_single_line,l_substr_before, l_substr_after);
   END IF;
   RETURN l_retval;
--
END get_csv_value_from_line;
--
-----------------------------------------------------------------------------
--
FUNCTION get_csv_value_from_line (p_seq        nm_load_file_cols.nlfc_seq_no%TYPE
                                 ,p_delim_char varchar2 DEFAULT ','
                                 ) RETURN varchar2 IS
BEGIN
   RETURN get_csv_value_from_line(p_seq        => p_seq
                                 ,p_delim_char => p_delim_char
                                 ,p_line       => g_single_line
                                 );

END get_csv_value_from_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_batch (p_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'validate_batch');
--
   validate_and_load (p_batch_no      => p_batch_no
                     ,p_validate_only => TRUE
                     );
--
   nm_debug.proc_end (g_package_name,'validate_batch');
--
END validate_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_batch (p_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'load_batch');
--
   validate_and_load (p_batch_no      => p_batch_no
                     ,p_validate_only => FALSE
                     );
--
   nm_debug.proc_end (g_package_name,'load_batch');
--
END load_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_dbms_job (p_batch_no      nm_load_batches.nlb_batch_no%TYPE
                            ,p_produce_htp   boolean DEFAULT FALSE
                            ) IS
BEGIN
   validate_and_load_dbms_job (p_batch_no      => p_batch_no
                              ,p_validate_only => TRUE
                              ,p_produce_htp   => p_produce_htp
                              );
END validate_dbms_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_dbms_job (p_batch_no      nm_load_batches.nlb_batch_no%TYPE
                        ,p_produce_htp   boolean DEFAULT FALSE
                        ) IS
BEGIN
   validate_and_load_dbms_job (p_batch_no      => p_batch_no
                              ,p_validate_only => FALSE
                              ,p_produce_htp   => p_produce_htp
                              );
END load_dbms_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_and_load_dbms_job (p_batch_no      nm_load_batches.nlb_batch_no%TYPE
                                     ,p_validate_only boolean
                                     ,p_produce_htp   boolean DEFAULT FALSE
                                     ) IS
--
   PRAGMA autonomous_transaction;
--
   l_job          pls_integer;
   l_block        user_jobs.what%TYPE;
   l_rec_nmu      nm_mail_users%ROWTYPE;
   l_sending_mail boolean := TRUE;
   l_rec_nlf      nm_load_files%ROWTYPE;
   l_process_type varchar2(30);
BEGIN
--
   nm_debug.proc_start (g_package_name,'validate_and_load_dbms_job');
--
   nm3dbms_job.make_sure_processes_available;
--
   IF p_validate_only
    THEN
      l_process_type := 'Validate';
   ELSE
      l_process_type := 'Load';
   END IF;
--
   IF p_produce_htp
    THEN
      nm3web.head (p_close_head => TRUE
                  ,p_title      => c_module_title
                  );
   --
      htp.bodyopen;
   --
      nm3web.module_startup(pi_module => c_this_module);
   END IF;
--
   nm3web_mail.can_mail_be_sent (pi_write_htp        => p_produce_htp
                                ,po_rec_nmu          => l_rec_nmu
                                ,po_mail_can_be_sent => l_sending_mail
                                );
--
   l_block :=            'DECLARE'
              ||CHR(10)||'   l_tab_to         nm3mail.tab_recipient;'
              ||CHR(10)||'   l_tab_empty      nm3mail.tab_recipient;'
              ||CHR(10)||'   l_tab_mail_text  nm3type.tab_varchar32767;'
              ||CHR(10)||'   c_sysdate  CONSTANT DATE := SYSDATE;'
              ||CHR(10)||'   c_batch_no CONSTANT nm_load_batches.nlb_batch_no%TYPE := '||p_batch_no||';'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||'   '||g_package_name||'.'||l_process_type||'_batch (c_batch_no);';
--
   IF l_sending_mail
    THEN
      l_block := l_block
              ||CHR(10)||'   l_tab_to(1).rcpt_id   := '||l_rec_nmu.nmu_id||';'
              ||CHR(10)||'   l_tab_to(1).rcpt_type := nm3mail.c_user;'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Submitted          : '||TO_CHAR(SYSDATE,nm3type.c_full_date_time_format))||');'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Started            : ')||'||to_char(c_sysdate,nm3type.c_full_date_time_format));'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Completed          : ')||'||to_char(SYSDATE,nm3type.c_full_date_time_format));'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string(NULL)||');'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string('Batch Number       : ')||'||c_batch_no);'
              ||CHR(10)||'   nm3tab_varchar.append (l_tab_mail_text,'||nm3flx.string(NULL)||');'
              ||CHR(10)||'   nm3mail.write_mail_complete'
              ||CHR(10)||'      (p_from_user        => l_tab_to(1).rcpt_id'
              ||CHR(10)||'      ,p_subject          => '||nm3flx.string('Batch ')||'||c_batch_no||'||nm3flx.string(' - '||l_process_type||' completed')
              ||CHR(10)||'      ,p_html_mail        => FALSE'
              ||CHR(10)||'      ,p_tab_to           => l_tab_to'
              ||CHR(10)||'      ,p_tab_cc           => l_tab_empty'
              ||CHR(10)||'      ,p_tab_bcc          => l_tab_empty'
              ||CHR(10)||'      ,p_tab_message_text => l_tab_mail_text'
              ||CHR(10)||'      );';
      IF p_produce_htp
       THEN
         htp.p('Mail message will be delivered to <A HREF="mailto:'||l_rec_nmu.nmu_email_address||'">'||l_rec_nmu.nmu_email_address||'</A> when complete');
         htp.br;
      END IF;
   END IF;
--
   l_block := l_block
              ||CHR(10)||'   '||g_package_name||'.produce_log_files(c_batch_no,FALSE,'||nm3flx.boolean_to_char(l_sending_mail)||');'
              ||CHR(10)||'   COMMIT;'
              ||CHR(10)||'END;';
--
   DBMS_JOB.SUBMIT (job  => l_job
                   ,what => l_block
                   );
--
   IF p_produce_htp
    THEN
      htp.br;
      htp.br;
      htp.p('<MARQUEE BEHAVIOR="ALTERNATE">'||htf.HEADER(3,'You may now close this page')||'</MARQUEE>');
      --
      htp.tableopen;
      htp.tablerowopen;
      htp.formopen('nm3web_load.main');
      htp.tabledata(htf.formsubmit (cvalue=>nm3web_load.c_continue));
      htp.formclose;
      htp.formopen('nm3web_load.process_existing');
      htp.formhidden (cname  => 'p_nlb_batch_no'
                     ,cvalue => p_batch_no
                     );
      htp.formhidden (cname  => 'p_process_subtype'
                     ,cvalue => 'F'
                     );
      htp.tabledata(htf.formsubmit (cvalue=>nm3get.get_hco(pi_hco_domain => 'CSV_PROCESS_SUBTYPE'
                                                          ,pi_hco_code   => 'F'
                                                          ).hco_meaning
                                   )
                   );
      htp.formclose;
      htp.tablerowclose;
      htp.tableclose;
      --
      htp.bodyclose;
      htp.htmlclose;
   END IF;
--
   nm_debug.proc_end (g_package_name,'validate_and_load_dbms_job');
--
   COMMIT;
--
END validate_and_load_dbms_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_commit_threshold RETURN number IS
BEGIN
   RETURN NVL(hig.get_sysopt('PCOMMIT'),100);
END get_commit_threshold;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_and_load (p_batch_no      nm_load_batches.nlb_batch_no%TYPE
                            ,p_validate_only boolean
                            ) IS
--
   l_block        nm3type.tab_varchar32767;
   l_table_name   varchar2(30);
   l_tab_rec_nlfc tab_rec_nlfc;
   l_rec_nlfc     nm_load_file_cols%ROWTYPE;
   l_tab_rec_nld  tab_rec_nld;
   l_rec_nlf      nm_load_files%ROWTYPE;
   l_rec_nld      nm_load_destinations%ROWTYPE;
   l_tab_rec_nldd tab_rec_nldd;
   l_rec_nldd     nm_load_destination_defaults%ROWTYPE;
   l_rec_nlb      nm_load_batches%ROWTYPE;
   --
   l_tab_holding  nm3type.tab_varchar2000;
   l_tab_dest     nm3type.tab_varchar30;
--
   l_record_name  varchar2(30);
--
   FUNCTION get_record_name (p_nld_table_short_name varchar2) RETURN varchar2 IS
   BEGIN
       RETURN c_table_short_name_prefix||SUBSTR(p_nld_table_short_name,1,28);
   END get_record_name;
--
   PROCEDURE append (p_text varchar2
                    ,p_nl   boolean DEFAULT TRUE
                    ) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_block,p_text,p_nl);
   END append;
BEGIN
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--
   l_rec_nlb      := get_nlb (p_batch_no);
--
   l_table_name   := get_holding_table_name (l_rec_nlb.nlb_nlf_id);
   l_rec_nlf      := get_nlf (l_rec_nlb.nlb_nlf_id);
   l_tab_rec_nlfc := get_tab_nlfc (l_rec_nlb.nlb_nlf_id);
   l_tab_rec_nld  := get_nld_for_nlf(l_rec_nlb.nlb_nlf_id);
--
   g_batch_no     := p_batch_no;
--
   append ('DECLARE', FALSE);
   append ('--');
   append ('   CURSOR cs_rowid (c_batch_no NUMBER) IS');
   append ('   SELECT tab.ROWID  tab_rowid');
   append ('         ,nlbs.ROWID nlbs_rowid');
   append ('    FROM  '||l_table_name||' tab');
   append ('         ,nm_load_batch_status nlbs');
   append ('   WHERE  tab.batch_no           = c_batch_no');
   append ('    AND   nlbs.nlbs_nlb_batch_no = tab.batch_no');
   append ('    AND   nlbs.nlbs_record_no    = tab.record_no');
   append ('    AND   nlbs.nlbs_status       IN ('||nm3flx.string('H')||','||nm3flx.string('V')||')');
   append ('   ORDER BY tab.batch_no, tab.record_no;');
   append ('--');
   append ('   CURSOR cs_load (c_tab_rowid ROWID, c_nlbs_rowid ROWID) IS');
   append ('   SELECT tab.*');
   append ('         ,nlbs_status');
   append ('         ,nlbs_text');
   append ('    FROM  '||l_table_name||' tab');
   append ('         ,nm_load_batch_status nlbs');
   append ('   WHERE  tab.ROWID  = c_tab_rowid');
   append ('    AND   nlbs.ROWID = c_nlbs_rowid;');
   append ('--');
   append ('   l_tab_rowid      nm3type.tab_rowid;');
   append ('   l_tab_nlbs_rowid nm3type.tab_rowid;');
   append ('   '||l_rec_nlf.nlf_unique||' cs_load%ROWTYPE;');
   append ('   c_commit_threshold CONSTANT NUMBER := '||get_commit_threshold||';');
   append ('--');
   append ('   PROCEDURE commit_and_lock IS');
   append ('   BEGIN');
   append ('      COMMIT;');
   append ('      nm3lock_gen.lock_nlb ('||g_package_name||'.g_batch_no,'''||l_rec_nlb.nlb_filename||''');');
   append ('   END commit_and_lock;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   commit_and_lock;');
   append ('--');
   append ('   OPEN  cs_rowid ('||g_package_name||'.g_batch_no);');
   append ('   FETCH cs_rowid');
   append ('    BULK COLLECT');
   append ('    INTO l_tab_rowid');
   append ('        ,l_tab_nlbs_rowid;');
   append ('   CLOSE cs_rowid;');
   append ('--');
   append ('   FOR i IN 1..l_tab_rowid.COUNT');
   append ('    LOOP');
   append ('      OPEN  cs_load (l_tab_rowid(i),l_tab_nlbs_rowid(i));');
   append ('      FETCH cs_load INTO '||l_rec_nlf.nlf_unique||';');
   append ('      CLOSE cs_load;');
   append ('      DECLARE');
   FOR i IN 1..l_tab_rec_nld.COUNT
    LOOP
      l_rec_nld     := l_tab_rec_nld(i);
      l_record_name := get_record_name(l_rec_nld.nld_table_short_name);
      append ('         '||l_record_name||' '||l_rec_nld.nld_table_name||'%ROWTYPE;');
   END LOOP;
   append ('         l_sqlerrm nm3type.max_varchar2;');
   append ('      BEGIN');
   append ('         '||l_rec_nlf.nlf_unique||'.nlbs_text   := Null;');
   append ('         SAVEPOINT top_of_loop;');
   append ('--');
--
   FOR i IN 1..l_tab_rec_nld.COUNT
    LOOP
      l_rec_nld     := l_tab_rec_nld(i);
      l_record_name := get_record_name(l_rec_nld.nld_table_short_name);
      get_cols_to_move (pi_nlf_id          => l_rec_nlb.nlb_nlf_id
                       ,pi_nld_id          => l_rec_nld.nld_id
                       ,po_tab_holding_col => l_tab_holding
                       ,po_tab_dest_col    => l_tab_dest
                       );
      FOR j IN 1..l_tab_holding.COUNT
       LOOP
         append ('         '||l_record_name||'.'||l_tab_dest(j)||' := '||l_tab_holding(j)||';');
      END LOOP;
      IF l_rec_nld.nld_validation_proc IS NOT NULL
       THEN
         append ('         '||l_rec_nld.nld_validation_proc||'('||l_record_name||');');
         append ('         '||l_rec_nlf.nlf_unique||'.nlbs_status := '||nm3flx.string('V')||';');
      END IF;
   END LOOP;
--
   append ('--');
--
   FOR i IN 1..l_tab_rec_nld.COUNT
    LOOP
      l_rec_nld     := l_tab_rec_nld(i);
      l_record_name := get_record_name(l_rec_nld.nld_table_short_name);
      IF NOT p_validate_only
       THEN
         append ('         '||l_rec_nld.nld_insert_proc||'('||l_record_name||');');
         append ('         '||l_rec_nlf.nlf_unique||'.nlbs_status := '||nm3flx.string('I')||';');
         append ('--');
      END IF;
   END LOOP;
--
   IF p_validate_only
    THEN
      append ('         ROLLBACK TO top_of_loop;');
   ELSE
      append ('         IF MOD (i,c_commit_threshold) = 0');
      append ('          THEN');
      append ('            commit_and_lock;');
      append ('            SAVEPOINT top_of_loop;');
      append ('         END IF;');
   END IF;
   append ('--');
   append ('      EXCEPTION');
   append ('         WHEN others');
   append ('          THEN');
   append ('            '||l_rec_nlf.nlf_unique||'.nlbs_status := '||nm3flx.string('E')||';');
   append ('            '||l_rec_nlf.nlf_unique||'.nlbs_text   := SUBSTR(SQLERRM,1,4000);');
   append ('            ROLLBACK TO top_of_loop;');
   append ('      END;');
   append ('      '||g_package_name||'.update_status('||g_package_name||'.g_batch_no,'||l_rec_nlf.nlf_unique||'.record_no,'||l_rec_nlf.nlf_unique||'.nlbs_status,'||l_rec_nlf.nlf_unique||'.nlbs_text);');
   append ('   END LOOP;');
   append ('   COMMIT;');
   append ('END;');

   nm_debug.DEBUG('Commit Threshold : '||get_commit_threshold);
   nm3ddl.debug_tab_varchar(l_block);
   nm3ddl.execute_tab_varchar(l_block);
--
   kick_nlb (p_batch_no);
--
END validate_and_load;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_status (p_batch_no   number
                        ,p_record_no  number
                        ,p_status     varchar2
                        ,p_text       varchar2
                        ) IS
   PRAGMA autonomous_transaction;
BEGIN
   UPDATE nm_load_batch_status
    SET   nlbs_status       = p_status
         ,nlbs_text         = SUBSTR(p_text,1,4000)
   WHERE  nlbs_nlb_batch_no = p_batch_no
    AND   nlbs_record_no    = p_record_no;
   COMMIT;
END update_status;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nld (p_nld_id nm_load_destinations.nld_id%TYPE) RETURN nm_load_destinations%ROWTYPE IS
--
   CURSOR cs_nld (c_nld_id nm_load_destinations.nld_id%TYPE) IS
   SELECT *
    FROM  nm_load_destinations
   WHERE  nld_id = c_nld_id;
--
   l_found   boolean;
   l_rec_nld nm_load_destinations%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nld (p_nld_id);
   FETCH cs_nld INTO l_rec_nld;
   l_found := cs_nld%FOUND;
   CLOSE cs_nld;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'nm_load_destinations.nld_id='||p_nld_id
                    );
   END IF;
--
   RETURN l_rec_nld;
--
END get_nld;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nld_for_nlf (p_nlf_id nm_load_files.nlf_id%TYPE) RETURN tab_rec_nld IS
   l_tab_rec_nld tab_rec_nld;
BEGIN
   FOR cs_rec IN (SELECT nld.*
                   FROM  nm_load_file_destinations nlfd
                        ,nm_load_destinations      nld
                  WHERE  nlfd.nlfd_nlf_id = p_nlf_id
                   AND   nlfd.nlfd_nld_id = nld.nld_id
                  ORDER BY nlfd.nlfd_seq
                 )
    LOOP
      l_tab_rec_nld(l_tab_rec_nld.COUNT+1) := cs_rec;
   END LOOP;
   RETURN l_tab_rec_nld;
END get_nld_for_nlf;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_rec_nldd (p_nld_id IN     nm_load_destinations.nld_id%TYPE
                          ) RETURN tab_rec_nldd IS
   l_tab_rec_nldd tab_rec_nldd;
BEGIN
   FOR cs_rec IN (SELECT * FROM nm_load_destination_defaults WHERE nldd_nld_id = p_nld_id)
    LOOP
      l_tab_rec_nldd(l_tab_rec_nldd.COUNT+1) := cs_rec;
   END LOOP;
   RETURN l_tab_rec_nldd;
END get_tab_rec_nldd;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_cols_to_move (pi_nlf_id          IN     nm_load_files.nlf_id%TYPE
                           ,pi_nld_id          IN     nm_load_destinations.nld_id%TYPE
                           ,po_tab_holding_col    OUT nm3type.tab_varchar2000
                           ,po_tab_dest_col       OUT nm3type.tab_varchar30
                           ) IS
--
   CURSOR cs_cols (c_nlf_id nm_load_files.nlf_id%TYPE
                  ,c_nld_id nm_load_destinations.nld_id%TYPE
                  ) IS
   SELECT nlcd_dest_col
         ,NVL(nlcd_source_col,'Null')
         ,UPPER(SUBSTR(nlcd_source_col,1,INSTR(nlcd_source_col,'.')-1))
    FROM  nm_load_file_col_destinations
   WHERE  nlcd_nlf_id  = c_nlf_id
    AND   nlcd_nld_id  = c_nld_id
    AND   nlcd_source_col IS NOT NULL
   ORDER BY nlcd_seq_no;
--
   -- 0110869 CWS array was too small strings larger than 30 chars were being inserted.
   v_tab_holding_col_prefix nm3type.tab_varchar80; --.tab_varchar30;
--
   CURSOR c_check (cp_holding_col_prefix  nm_load_file_col_destinations.nlcd_source_col%TYPE) IS
   SELECT 'x'
   FROM   nm_load_file_destinations  nlfd
         ,nm_load_destinations       nld
   WHERE  nlfd_nlf_id = pi_nlf_id
   AND    nld_id      = nlfd_nld_id
   AND    nld_table_short_name = cp_holding_col_prefix;
--
   v_dummy  varchar2(1);
--
--
BEGIN
--
   OPEN  cs_cols(pi_nlf_id,pi_nld_id);
   FETCH cs_cols
    BULK COLLECT
    INTO po_tab_dest_col
        ,po_tab_holding_col
        ,v_tab_holding_col_prefix;
   CLOSE cs_cols;
--
--
   --------------------------------------------------------------------------------------------------
   -- GJ 24-FEB-2003
   -- loop through all the records in the pl/sql table returned by the previous cursor
   -- and if a source (holding) column had a prefix i.e. there was a dot in the value (e.g. iit.iit_ne_id)
   -- and that prefix is for another destination table on this file type then append the short table
   -- name prefix to the source column (e.g. iit.iit_ne_id becomes l_iit.iit_ne_id)
   --------------------------------------------------------------------------------------------------
   FOR v_recs IN 1..v_tab_holding_col_prefix.COUNT LOOP
--
       v_dummy := NULL;
       OPEN c_check(v_tab_holding_col_prefix(v_recs));
       FETCH c_check INTO v_dummy;
       CLOSE c_check;
--
       IF v_dummy IS NOT NULL THEN
          po_tab_holding_col(v_recs) := c_table_short_name_prefix ||po_tab_holding_col(v_recs);
       END IF;
--
   END LOOP;
--
--
END get_cols_to_move;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nlb (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) RETURN nm_load_batches%ROWTYPE IS
--
   CURSOR cs_nlb (c_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
   SELECT *
    FROM  nm_load_batches
   WHERE  nlb_batch_no = c_nlb_batch_no;
--
   l_found   boolean;
   l_rec_nlb nm_load_batches%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nlb (p_nlb_batch_no);
   FETCH cs_nlb INTO l_rec_nlb;
   l_found := cs_nlb%FOUND;
   CLOSE cs_nlb;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'nm_load_batches.nlb_batch_no='||p_nlb_batch_no
                    );
   END IF;
--
   RETURN l_rec_nlb;
--
END get_nlb;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nlf (p_nlf_id nm_load_files.nlf_id%TYPE) RETURN nm_load_files%ROWTYPE IS
--
   CURSOR cs_nlf (c_nlf_id nm_load_files.nlf_id%TYPE) IS
   SELECT *
    FROM  nm_load_files
   WHERE  nlf_id = c_nlf_id;
--
   l_found   boolean;
   l_rec_nlf nm_load_files%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nlf (p_nlf_id);
   FETCH cs_nlf INTO l_rec_nlf;
   l_found := cs_nlf%FOUND;
   CLOSE cs_nlf;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'nm_load_files.nlf_id='||p_nlf_id
                    );
   END IF;
--
   RETURN l_rec_nlf;
--
END get_nlf;
--
-----------------------------------------------------------------------------
--
PROCEDURE produce_logs (p_nlb_batch_no   nm_load_batches.nlb_batch_no%TYPE
                       ,p_produce_as_htp boolean DEFAULT FALSE
                       ,p_send_as_mail   boolean DEFAULT FALSE
                       ,p_mail_only      boolean DEFAULT FALSE
                       ,p_send_to        nm3mail.tab_recipient
                       ) IS
--
   CURSOR cs_count (c_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE
                   ,c_nlbs_status  nm_load_batch_status.nlbs_status%TYPE
                   ) IS
   SELECT COUNT(1)
    FROM  nm_load_batch_status
   WHERE  nlbs_nlb_batch_no = c_nlb_batch_no
    AND   nlbs_status       = c_nlbs_status;
--
   CURSOR cs_errors (c_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE
                    ) IS
   SELECT *
    FROM  nm_load_batch_status
   WHERE  nlbs_nlb_batch_no = c_nlb_batch_no
    AND   nlbs_status       IN ('X','E')
   ORDER BY nlbs_record_no;
--
   l_dummy cs_errors%ROWTYPE;
   l_found boolean;
--
   l_count   pls_integer;
--
   l_rec_nlb nm_load_batches%ROWTYPE;
   l_rec_nlf nm_load_files%ROWTYPE;
--
   l_holding_table varchar2(30);
--
   l_tab_log_lines     nm3type.tab_varchar32767;
   l_tab_bad_lines     nm3type.tab_varchar32767;
   l_tab_bad_record_no nm3type.tab_number;
--
   l_log_filename      varchar2(2000);
   l_bad_filename      varchar2(2000);
   l_log_filesize number               := 0;
   l_bad_filesize number               := 0;
--
   l_produce_server_file boolean := FALSE;
--
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 		CUSTOM CODE - Paul Sheedy 12/2007
--		declaration code start
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Variables used by the xy/route placement logic
-- added by Paul Sheedy

	t_xyroute_flag		NUMBER	:= 0;
   	t_other_bad_line		VARCHAR2(32767);
   	t_other_bad_recordno 	NUMBER;
--
--	The next function and procedure were added by Paul Sheedy for the purpose of producing a BAD file
--	that can be resubmitted for loading while loading via XY and snapping to a
--	route.  Without this code, one line of output is produced for every two lines
--	of input - making the bad file unusable for re-loading.  These changes will
--	only be used if the loading method uses V_LOAD_INV_MEM_ON_ELEMENT_XY.

-- 	Determine method of placement. 1 indicates that XY/Route snapping is used, 0 means it is not.

	FUNCTION is_placement_by_route_xy(p_batchno nm_load_batches.nlb_batch_no%TYPE) RETURN NUMBER IS

	CURSOR cur_routexy(cp_batchno IN NUMBER) IS
		SELECT 1
		FROM nm_load_batches a
			,nm_load_file_destinations b
			,nm_load_destinations c
		WHERE a.nlb_batch_no = cp_batchno
			AND a.nlb_nlf_id = b.nlfd_nlf_id 
			AND b.nlfd_nld_id = c.nld_id
			AND c.nld_table_name = 'V_LOAD_INV_MEM_ON_ELEMENT_XY';

	t_return	NUMBER;

	BEGIN
		t_return	:= 0;

		OPEN cur_routexy(p_batchno);
		FETCH cur_routexy INTO t_return;

		IF cur_routexy%FOUND THEN
			t_return	:= 1;
		END IF;

		CLOSE cur_routexy;

		RETURN t_return;

	EXCEPTION WHEN OTHERS THEN
		RETURN 0;
	END is_placement_by_route_xy;
--
--	This code will return the second line of input data.  It is invoked only in cases
--	where the placement method is XY/Route.

	PROCEDURE get_other_bad_line(p_batchno IN NUMBER
						,p_badrecordno_in  NUMBER
						,p_badline OUT VARCHAR2
						,p_badrecordno OUT NUMBER) IS

	CURSOR cur_assettype(cp_batchno IN NUMBER) IS
		SELECT nlf_unique
		FROM nm_load_batches a 
    			, nm_load_files b
		WHERE a.nlb_batch_no = cp_batchno
    			and a.nlb_nlf_id = b.nlf_id;

	CURSOR cur_origbatch(p_batchno IN NUMBER, p_asset IN VARCHAR2) IS
		SELECT max(nlb_batch_no)
		FROM nm_load_batches 
		WHERE nlb_batch_no <> p_batchno AND
			nlb_nlf_id = (SELECT nlf_id FROM nm_load_files WHERE nlf_unique = p_asset); 

	t_tablename			VARCHAR2(50);
	t_assettype			VARCHAR2(20);
	t_assettype_line		VARCHAR2(20);
	t_assettype_short		VARCHAR2(20);
	t_sql				VARCHAR2(500);
	t_newbatchno		NUMBER;
	t_found			BOOLEAN	:= FALSE;

	BEGIN
		p_badline		:= NULL;
		p_badrecordno	:= NULL;

		OPEN cur_assettype(p_batchno);
		FETCH cur_assettype INTO t_assettype;
		t_found	:= cur_assettype%FOUND;
		CLOSE cur_assettype;

		IF t_found THEN
			t_assettype		:= TRIM(t_assettype);
			IF instr(t_assettype,'_LINE') > 0 THEN
				t_assettype_line		:= t_assettype;
				t_assettype_short		:= substr(t_assettype,1,instr(t_assettype,'_LINE')-1);
			ELSE
				t_assettype_line		:= t_assettype || '_LINE';
				t_assettype_short		:= t_assettype;
			END IF;

			t_tablename		:= 'NM_LD_' || t_assettype_short || '_TMP';

			OPEN cur_origbatch(p_batchno, t_assettype_short);
			FETCH cur_origbatch INTO t_newbatchno;
			t_found	:= cur_origbatch%FOUND;
			CLOSE cur_origbatch;

			IF t_found THEN
				t_sql	:= 'SELECT nlbs_input_line, nlbs_record_no ' ||
					' FROM nm_load_batch_status ' ||
					' WHERE nlbs_nlb_batch_no = ' || t_newbatchno ||
					' AND nlbs_record_no = ' ||
					' (SELECT b.record_no ' ||
					' FROM ' || t_tablename || ' a, ' || t_tablename || ' b ' ||
					' WHERE a.batch_no = b.batch_no ' ||
					' AND a.batch_no = ' || t_newbatchno ||
					' AND a.lfk = b.lfk ' ||
					' AND a.record_no = ' || p_badrecordno_in ||
					' AND b.record_no <> ' || p_badrecordno_in || ')'; 

				EXECUTE IMMEDIATE t_sql INTO p_badline, p_badrecordno;
			END IF;
		END IF;

	EXCEPTION WHEN OTHERS THEN
		p_badline		:= NULL;
		p_badrecordno	:= NULL;
	END get_other_bad_line;
--
-- end of code added by Paul Sheedy for xy/route logic
-- ------------------------------------------------------------------------------------------------------------------
-- 		CUSTOM CODE - Paul Sheedy 12/2007
--		declaration code end
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
   PROCEDURE print_it (p_text varchar2) IS
   BEGIN
      l_tab_log_lines(l_tab_log_lines.COUNT+1) := p_text;
   END print_it;
--
   PROCEDURE print_sep IS
   BEGIN
      print_it (RPAD('-',91,'-'));
   END print_sep;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'produce_logs');
--
   l_rec_nlb             := get_nlb (p_nlb_batch_no);
   l_produce_server_file := (l_rec_nlb.nlb_batch_source = 'S') AND NOT p_mail_only;
   l_rec_nlf             := get_nlf (l_rec_nlb.nlb_nlf_id);
   l_holding_table       := nm3load.get_holding_table_name (p_nlf_id => l_rec_nlb.nlb_nlf_id);
   IF l_produce_server_file
    THEN
      l_log_filename     := l_rec_nlb.nlb_filename||'.'||p_nlb_batch_no||'.log';
      l_bad_filename     := l_rec_nlb.nlb_filename||'.'||p_nlb_batch_no||'.bad';
   ELSE
      l_log_filename     := l_rec_nlb.nlb_filename||'.log';
      l_bad_filename     := l_rec_nlb.nlb_filename||'.bad';
   END IF;
--
   print_it ('<LOG_FILE>');
   print_sep;
   print_it ('Batch No               : '||l_rec_nlb.nlb_batch_no);
   print_it ('Load File Unique Ref   : '||l_rec_nlf.nlf_unique);
   print_it ('Load File Description  : '||l_rec_nlf.nlf_descr);
   print_it ('Delimiting Character   : '||l_rec_nlf.nlf_delimiter||' (ASCII Char '||ASCII(l_rec_nlf.nlf_delimiter)||')');
   print_it ('Load File Date Mask    : '||NVL(l_rec_nlf.nlf_date_format_mask,'Null'));
   print_it ('Holding Table          : '||l_holding_table);
   IF l_produce_server_file
    THEN
      print_it ('Server Filepath        : '||l_rec_nlf.nlf_path);
   END IF;
   print_it ('Input Filename         : '||l_rec_nlb.nlb_filename);
   print_it ('Log Filename           : '||l_log_filename);
   print_it ('Bad Filename           : '||l_bad_filename);
   print_it ('Timestamp Loaded       : '||TO_CHAR(l_rec_nlb.nlb_date_created,nm3type.c_full_date_time_format));
   print_it ('Timestamp Log Produced : '||TO_CHAR(SYSDATE,nm3type.c_full_date_time_format));
   print_sep;
   FOR cs_rec IN (SELECT hco_code, hco_meaning
                   FROM  hig_codes
                  WHERE  hco_domain = 'CSV_LOAD_STATUSES'
                  ORDER BY hco_seq
                 )
    LOOP
      OPEN  cs_count (p_nlb_batch_no, cs_rec.hco_code);
      FETCH cs_count INTO l_count;
      CLOSE cs_count;
      print_it (cs_rec.hco_code||' - '||RPAD(cs_rec.hco_meaning,70,' ')||' : '||l_count);
   END LOOP;
   print_sep;
--
   OPEN  cs_errors (l_rec_nlb.nlb_batch_no);
   FETCH cs_errors INTO l_dummy;
   l_found := cs_errors%FOUND;
   CLOSE cs_errors;
--
   IF l_found
    THEN
      print_it ('Record Num Bad File # St Error Text');
      print_it ('---------- ---------- -- ------------------------------------------------------------------');
      FOR cs_rec IN cs_errors (l_rec_nlb.nlb_batch_no)
       LOOP
         print_it (TO_CHAR(cs_rec.nlbs_record_no,'999999999')||' '||TO_CHAR(cs_errors%rowcount,'999999999')||' '||cs_rec.nlbs_status||'  '||nm3flx.parse_error_message(cs_rec.nlbs_text));
         l_tab_bad_lines(l_tab_bad_lines.COUNT+1) := cs_rec.nlbs_input_line;
         l_tab_bad_record_no(l_tab_bad_record_no.COUNT+1) := cs_rec.nlbs_record_no;
	
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 		CUSTOM CODE - Paul Sheedy 12/2007
--		execution code start
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Customized code written by Paul Sheedy - adds the second error line to the BAD file so that it can
-- be used as input for a subsequent load attempt.
-- This code will only execute if the placement method is xy/route.

	    t_xyroute_flag		:= is_placement_by_route_xy(p_nlb_batch_no);
	    IF NVL(t_xyroute_flag,0) = 1 THEN
			BEGIN
				t_other_bad_line		:= NULL;
				t_other_bad_recordno	:= NULL;

				get_other_bad_line(cs_rec.nlbs_nlb_batch_no, cs_rec.nlbs_record_no, t_other_bad_line, t_other_bad_recordno);

				IF nvl(t_other_bad_recordno,-1) > -1 THEN
			         	l_tab_bad_lines(l_tab_bad_lines.COUNT+1) := t_other_bad_line;
         				l_tab_bad_record_no(l_tab_bad_record_no.COUNT+1) := t_other_bad_recordno;
				END IF;
			EXCEPTION WHEN OTHERS THEN
				NULL;
			END;
	    END IF;
-- ------------------------------------------------------------------------------------------------------------------
-- 		CUSTOM CODE - Paul Sheedy 12/2007
--		execution code end
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      END LOOP;
      print_sep;
   END IF;
   print_it ('</LOG_FILE>');
--
   IF l_produce_server_file
    THEN
      nm3file.write_file (LOCATION       => l_rec_nlf.nlf_path
                         ,filename       => l_log_filename
                         ,max_linesize   => c_linesize
                         ,all_lines      => l_tab_log_lines
                         );
      nm3file.write_file (LOCATION       => l_rec_nlf.nlf_path
                         ,filename       => l_bad_filename
                         ,max_linesize   => c_linesize
                         ,all_lines      => l_tab_bad_lines
                         );
--      put_line_feed_on_end (l_tab_log_lines,l_log_filesize);
--      put_line_feed_on_end (l_tab_bad_lines,l_bad_filesize);
   ELSIF NOT p_mail_only THEN
      DECLARE
         l_rec_nuf_log           nm_upload_files%ROWTYPE;
         l_rec_nuf_bad           nm_upload_files%ROWTYPE;
         c_mime_type    CONSTANT varchar2(10) := 'text/plain';
         c_sysdate      CONSTANT date         := SYSDATE;
         c_content_type CONSTANT varchar2(4)  := 'BLOB';
         c_dad_charset  CONSTANT varchar2(5)  := 'ascii';
         l_tab_log_lines_local   nm3type.tab_varchar32767;
         l_tab_bad_lines_local   nm3type.tab_varchar32767;
      BEGIN
      --
--         l_log_filename := l_log_filename||'.txt';
--         l_bad_filename := l_bad_filename||'.txt';
      --
         delete_nuf_for_nlf (pi_nlf_id => l_rec_nlf.nlf_id);
      --
         DELETE nm_upload_files
         WHERE  NAME IN (l_log_filename,l_bad_filename);
      --
         l_tab_log_lines_local  := l_tab_log_lines;
         l_tab_bad_lines_local  := l_tab_bad_lines;
      --
         put_line_feed_on_end (l_tab_log_lines_local,l_log_filesize);
         put_line_feed_on_end (l_tab_bad_lines_local,l_bad_filesize);
      --
         l_rec_nuf_log.NAME                   := l_log_filename;
         l_rec_nuf_log.mime_type              := c_mime_type;
         l_rec_nuf_log.doc_size               := l_log_filesize;
         l_rec_nuf_log.dad_charset            := c_dad_charset;
         l_rec_nuf_log.last_updated           := c_sysdate;
         l_rec_nuf_log.content_type           := c_content_type;
         l_rec_nuf_log.blob_content           := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab_log_lines_local));
         l_rec_nuf_log.nuf_nufg_table_name    := c_nlb;
         l_rec_nuf_log.nuf_nufgc_column_val_1 := l_rec_nlb.nlb_batch_no;
         nm3ins.ins_nuf (l_rec_nuf_log);
         l_rec_nuf_bad.NAME                   := l_bad_filename;
         l_rec_nuf_bad.mime_type              := c_mime_type;
         l_rec_nuf_bad.doc_size               := l_bad_filesize;
         l_rec_nuf_bad.dad_charset            := c_dad_charset;
         l_rec_nuf_bad.last_updated           := c_sysdate;
         l_rec_nuf_bad.content_type           := c_content_type;
         l_rec_nuf_bad.blob_content           := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab_bad_lines_local));
         l_rec_nuf_bad.nuf_nufg_table_name    := c_nlb;
         l_rec_nuf_bad.nuf_nufgc_column_val_1 := l_rec_nlb.nlb_batch_no;
         nm3ins.ins_nuf (l_rec_nuf_bad);
      --
      END;
   END IF;
--
   IF p_produce_as_htp
    THEN
      htp.br;
      IF l_produce_server_file
       THEN
         htp.bold('Log File');
      ELSE
         htp.anchor(curl  => nm3web.get_download_url(l_log_filename)
                   ,ctext => htf.bold('Log File')
                   );
      END IF;
      htp.br;
      htp.p('<CODE>');
      nm3web.htp_tab_varchar (p_tab_vc         => l_tab_log_lines
                             ,p_br_each_line   => TRUE
                             ,p_replace_spaces => TRUE
                             );
      htp.p('</CODE>');
      IF l_tab_bad_lines.COUNT > 0
       THEN
         htp.br;
         IF l_produce_server_file
          THEN
            htp.bold('"BAD" records');
         ELSE
            htp.anchor(curl  => nm3web.get_download_url(l_bad_filename)
                      ,ctext => htf.bold('"BAD" records')
                      );
         END IF;
         htp.br;
         htp.p('<CODE>');
         nm3web.htp_tab_varchar (p_tab_vc         => l_tab_bad_lines
                                ,p_br_each_line   => TRUE
                                ,p_replace_spaces => TRUE
                                );
         htp.p('</CODE>');
      END IF;
   END IF;
--
   IF p_send_as_mail
    THEN
      DECLARE
         l_sending_mail   boolean := p_send_as_mail;
         l_rec_nmu        nm_mail_users%ROWTYPE;
         l_tab_to         nm3mail.tab_recipient;
         l_tab_empty      nm3mail.tab_recipient;
         l_tab_local_bad  nm3type.tab_varchar32767;
         l_tab_local_log  nm3type.tab_varchar32767;
         l_user_specified boolean := p_send_to.EXISTS(1);
      BEGIN
         IF l_sending_mail
          THEN
            IF l_user_specified THEN
              l_tab_to := p_send_to;
            ELSE
              nm3web_mail.can_mail_be_sent (pi_write_htp        => p_produce_as_htp
                                           ,po_rec_nmu          => l_rec_nmu
                                           ,po_mail_can_be_sent => l_sending_mail
                                           );
              l_tab_to(1).rcpt_id   := l_rec_nmu.nmu_id;
              l_tab_to(1).rcpt_type := nm3mail.c_user;
            END IF;
            l_tab_local_log(1)    := '<HTML><BODY>';
            IF NOT l_produce_server_file AND NOT p_mail_only
             THEN
               l_tab_local_log(1) := l_tab_local_log(1)||'<A HREF="'||nm3web_load.get_full_download_url(l_log_filename)||'">Log File</A><BR>';
            END IF;
            l_tab_local_log(2) := '<CODE>';
            FOR i IN 1..l_tab_log_lines.COUNT
             LOOP
               l_tab_local_log(l_tab_local_log.COUNT+1) := nm3web.replace_chevrons(REPLACE(l_tab_log_lines(i),' ',nm3web.c_nbsp))||'<BR>';
            END LOOP;
            l_tab_local_log(l_tab_local_log.COUNT+1) := '</CODE></BODY></HTML>';
            nm3mail.write_mail_complete
                         (p_from_user        => nm3mail.get_current_nmu_id
                         ,p_subject          => 'Batch '||l_rec_nlb.nlb_batch_no||' - Log File'
                         ,p_html_mail        => TRUE
                         ,p_tab_to           => l_tab_to
                         ,p_tab_cc           => l_tab_empty
                         ,p_tab_bcc          => l_tab_empty
                         ,p_tab_message_text => l_tab_local_log
                         );
            IF l_tab_bad_lines.COUNT > 0
             THEN
      --
               l_tab_local_bad(1) := '<HTML><BODY>';
      --
               IF NOT l_produce_server_file AND NOT p_mail_only
                THEN
                  l_tab_local_bad(1) := l_tab_local_bad(1)||'<A HREF="'||nm3web_load.get_full_download_url(l_bad_filename)||'">"BAD" File</A><BR>';
               END IF;
               l_tab_local_bad(2) := '<TABLE BORDER=1>';
               l_tab_local_bad(3) := '<TR><TH>Record #</TH><TH>BAD Rec #</TH><TH>Input Line</TH></TR>';
               FOR i IN 1..l_tab_bad_lines.COUNT
                LOOP
                  l_tab_local_bad(l_tab_local_bad.COUNT+1) := '<TR><TD>'||l_tab_bad_record_no(i)||'</TD><TD>'||i||'</TD><TD><CODE>'||nm3web.replace_chevrons(REPLACE(l_tab_bad_lines(i),' ',nm3web.c_nbsp))||'</CODE></TD></TR>';
               END LOOP;
               l_tab_local_bad(l_tab_local_bad.COUNT+1) := '</TABLE></BODY></HTML>';
               nm3mail.write_mail_complete
                         (p_from_user        => nm3mail.get_current_nmu_id
                         ,p_subject          => 'Batch '||l_rec_nlb.nlb_batch_no||' - "BAD" File'
                         ,p_html_mail        => TRUE
                         ,p_tab_to           => l_tab_to
                         ,p_tab_cc           => l_tab_empty
                         ,p_tab_bcc          => l_tab_empty
                         ,p_tab_message_text => l_tab_local_bad
                         );
            END IF;
         END IF;
      END;
   END IF;
--
   kick_nlb (p_nlb_batch_no);
--
   nm_debug.proc_end (g_package_name,'produce_logs');
--
END produce_logs;
--
-----------------------------------------------------------------------------
--
PROCEDURE produce_log_email (p_nlb_batch_no   nm_load_batches.nlb_batch_no%TYPE
                            ,p_produce_as_htp boolean DEFAULT FALSE
                            ,p_send_to        nm3mail.tab_recipient
                            ) IS
PRAGMA autonomous_transaction;
BEGIN
  produce_logs (p_nlb_batch_no   => p_nlb_batch_no
               ,p_produce_as_htp => p_produce_as_htp
               ,p_send_as_mail   => TRUE
               ,p_mail_only      => TRUE
               ,p_send_to        => p_send_to);
  COMMIT;
END produce_log_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE produce_log_files (p_nlb_batch_no   nm_load_batches.nlb_batch_no%TYPE
                            ,p_produce_as_htp boolean DEFAULT FALSE
                            ,p_send_as_mail   boolean DEFAULT FALSE
                            ) IS
l_to nm3mail.tab_recipient;
BEGIN
  produce_logs (p_nlb_batch_no   => p_nlb_batch_no
               ,p_produce_as_htp => p_produce_as_htp
               ,p_send_as_mail   => p_send_as_mail
               ,p_send_to        => l_to);
END produce_log_files;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nld_id RETURN pls_integer IS
   l_retval pls_integer;
BEGIN
   SELECT nld_id_seq.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END get_next_nld_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nlf_id RETURN pls_integer IS
   l_retval pls_integer;
BEGIN
   SELECT nlf_id_seq.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END get_next_nlf_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE kick_nlb (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
  PRAGMA autonomous_transaction;
BEGIN
   UPDATE nm_load_batches
    SET   nlb_date_modified = nlb_date_modified
   WHERE  nlb_batch_no      = p_nlb_batch_no;
   COMMIT;
END kick_nlb;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_columns_for_destinations (p_nlf_id nm_load_files.nlf_id%TYPE
                                       ,p_nld_id nm_load_destinations.nld_id%TYPE
                                       ) IS
--
   l_table_name all_tab_columns.table_name%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_columns_for_destinations');
--
   l_table_name := get_nld(p_nld_id).nld_table_name;
--
   INSERT INTO nm_load_file_col_destinations
         (nlcd_nlf_id
         ,nlcd_nld_id
         ,nlcd_seq_no
         ,nlcd_dest_col
         ,nlcd_source_col
         )
   SELECT p_nlf_id
         ,p_nld_id
         ,column_id
         ,column_name
         ,get_column_default(p_nld_id,column_name)
    FROM  all_tab_columns
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = l_table_name;
--
   nm_debug.proc_end(g_package_name,'add_columns_for_destinations');
--
END add_columns_for_destinations;
--
-----------------------------------------------------------------------------
--
FUNCTION get_column_default (p_nldd_nld_id      nm_load_destination_defaults.nldd_nld_id%TYPE
                            ,p_nldd_column_name nm_load_destination_defaults.nldd_column_name%TYPE
                            ) RETURN nm_load_destination_defaults.nldd_value%TYPE IS
--
   CURSOR cs_nldd (c_nldd_nld_id      nm_load_destination_defaults.nldd_nld_id%TYPE
                  ,c_nldd_column_name nm_load_destination_defaults.nldd_column_name%TYPE
                  ) IS
   SELECT nldd_value
    FROM  nm_load_destination_defaults
   WHERE  nldd_nld_id      = c_nldd_nld_id
    AND   nldd_column_name = c_nldd_column_name;
--
   l_retval nm_load_destination_defaults.nldd_value%TYPE;
--
BEGIN
--
   OPEN  cs_nldd (p_nldd_nld_id,p_nldd_column_name);
   FETCH cs_nldd INTO l_retval;
   CLOSE cs_nldd;
--
   RETURN l_retval;
--
END get_column_default;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_dtd (p_nlf_id nm_load_files.nlf_id%TYPE) IS
--
   l_rec_nlf      nm_load_files%ROWTYPE;
   l_rec_nxf      nm_xml_files%ROWTYPE;
   l_tab_vc       nm3type.tab_varchar32767;
   l_tab_rec_nlfc tab_rec_nlfc;
   l_rec_nlfc     nm_load_file_cols%ROWTYPE;
   l_start        varchar2(1);
--
   PROCEDURE append (p_text varchar2
                    ,p_nl   boolean DEFAULT TRUE
                    ) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_tab_vc,p_text,p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_end(g_package_name,'create_dtd');
--
   l_rec_nlf := get_nlf (p_nlf_id);
--
   l_rec_nxf.nxf_file_type := get_holding_table_name(p_nlf_id);
   l_rec_nxf.nxf_type      := 'DTD';
   l_rec_nxf.nxf_descr     := l_rec_nlf.nlf_descr;
--
   l_tab_rec_nlfc          := get_tab_nlfc (p_nlf_id);
--
   nm3del.del_nxf (pi_nxf_file_type   => l_rec_nxf.nxf_file_type
                  ,pi_nxf_type        => l_rec_nxf.nxf_type
                  ,pi_raise_not_found => FALSE
                  );
--
   append ('<?xml version="1.0" encoding="UTF-8"?>',FALSE);
   append ('<!--DTD generated by exor corp. (http://www.exorcorp.com)-->');
--
   append ('<!ELEMENT '||l_rec_nxf.nxf_file_type||' ('||l_rec_nlf.nlf_unique||')*>');
   append ('<!ELEMENT '||l_rec_nlf.nlf_unique||' ');
--
   l_start := '(';
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      l_rec_nlfc := l_tab_rec_nlfc(i);
      append (l_start||l_rec_nlfc.nlfc_holding_col,FALSE);
      IF l_rec_nlfc.nlfc_mandatory = 'N'
       THEN
         append ('?',FALSE);
      END IF;
      l_start := ',';
   END LOOP;
   append (')>',FALSE);
--
   append ('<!ATTLIST '||l_rec_nlf.nlf_unique||' num CDATA #REQUIRED>');
   FOR i IN 1..l_tab_rec_nlfc.COUNT
    LOOP
      l_rec_nlfc := l_tab_rec_nlfc(i);
      append ('<!ELEMENT '||l_rec_nlfc.nlfc_holding_col||' (#PCDATA)>');
   END LOOP;
--
   l_rec_nxf.nxf_doc       := nm3clob.tab_varchar_to_clob (l_tab_vc);
--
   nm3ins.ins_nxf (l_rec_nxf);
--
   nm_debug.proc_end(g_package_name,'create_dtd');
--
END create_dtd;
--
-----------------------------------------------------------------------------
--
FUNCTION get_column_date_mask (p_nlfc_nlf_id nm_load_file_cols.nlfc_nlf_id%TYPE
                              ,p_nlfc_seq_no nm_load_file_cols.nlfc_seq_no%TYPE
                              ) RETURN nm_load_file_cols.nlfc_date_format_mask%TYPE IS
--
   l_retval nm_load_file_cols.nlfc_date_format_mask%TYPE;
--
BEGIN
--
   l_retval := nm3get.get_nlfc (pi_nlfc_nlf_id => p_nlfc_nlf_id
                               ,pi_nlfc_seq_no => p_nlfc_seq_no
                               ).nlfc_date_format_mask;
   IF l_retval IS NULL
    THEN
      l_retval := nm3get.get_nlf (pi_nlf_id => p_nlfc_nlf_id).nlf_date_format_mask;
   END IF;
--
   RETURN l_retval;
--
END get_column_date_mask;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_nlf_to_server
                   (p_nlf_unique       nm_load_files.nlf_unique%TYPE
                   ,p_output_filename  nm_load_files.nlf_descr%TYPE DEFAULT NULL
                   ,p_delete_if_exists BOOLEAN                      DEFAULT TRUE
                   ) IS
   l_dummy nm3type.max_varchar2;
BEGIN
   l_dummy := dump_nlf_to_server
                   (p_nlf_unique       => p_nlf_unique
                   ,p_output_filename  => p_output_filename
                   ,p_delete_if_exists => p_delete_if_exists
                   );
END dump_nlf_to_server;
--
-----------------------------------------------------------------------------
--
FUNCTION dump_nlf_to_server
                   (p_nlf_unique       nm_load_files.nlf_unique%TYPE
                   ,p_output_filename  nm_load_files.nlf_descr%TYPE DEFAULT NULL
                   ,p_delete_if_exists BOOLEAN                      DEFAULT TRUE
                   ) RETURN VARCHAR2 IS
BEGIN
   RETURN dump_nlf (p_nlf_unique       => p_nlf_unique
                   ,p_output_filename  => p_output_filename
                   ,p_delete_if_exists => p_delete_if_exists
                   ,p_dump_to_utl_file => TRUE
                   );
END dump_nlf_to_server;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_nlf_to_client
                   (p_nlf_unique       nm_load_files.nlf_unique%TYPE
                   ,p_delete_if_exists BOOLEAN                      DEFAULT TRUE
                   ) IS
   l_dummy nm3type.max_varchar2;
BEGIN
   l_dummy := dump_nlf_to_client
                   (p_nlf_unique       => p_nlf_unique
                   ,p_delete_if_exists => p_delete_if_exists
                   );
END dump_nlf_to_client;

--
-----------------------------------------------------------------------------
--
FUNCTION dump_nlf_to_client
                   (p_nlf_unique       nm_load_files.nlf_unique%TYPE
                   ,p_delete_if_exists BOOLEAN                      DEFAULT TRUE
                   ) RETURN VARCHAR2 IS
BEGIN
   RETURN dump_nlf (p_nlf_unique       => p_nlf_unique
                   ,p_output_filename  => Null
                   ,p_delete_if_exists => p_delete_if_exists
                   ,p_dump_to_utl_file => FALSE
                   );
END dump_nlf_to_client;
--
-----------------------------------------------------------------------------
--
FUNCTION dump_nlf (p_nlf_unique       nm_load_files.nlf_unique%TYPE
                  ,p_output_filename  nm_load_files.nlf_descr%TYPE DEFAULT NULL
                  ,p_delete_if_exists BOOLEAN                      DEFAULT TRUE
                  ,p_dump_to_utl_file BOOLEAN                      DEFAULT TRUE
                  ) RETURN VARCHAR2 IS
--
   l_full_path       nm3type.max_varchar2;
--
   l_rec_nlf         nm_load_files%ROWTYPE;
--
   l_tab             nm3type.tab_varchar32767;
   l_output_filename nm_load_files.nlf_descr%TYPE;
   l_output_path     nm3type.max_varchar2;
   c_null   CONSTANT VARCHAR2(4) := 'Null';
--
   PROCEDURE add_it (p_text VARCHAR2) IS
   BEGIN
      l_tab(l_tab.COUNT+1) := p_text;
   END add_it;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'dump_nlf');
--
   SAVEPOINT top_of_proc;
--
   l_rec_nlf         := nm3get.get_nlf (pi_nlf_unique => p_nlf_unique);
--
--   nm3lock_gen.lock_nlf (pi_nlf_id => l_rec_nlf.nlf_id);
--
   l_output_filename := NVL(p_output_filename
                           ,l_rec_nlf.nlf_id||'.'||l_rec_nlf.nlf_unique||'.sql'
                           );
--
   add_it ('DECLARE');
   add_it ('--');
   add_it ('-- ###############################################################');
   add_it ('--');
   add_it ('--  File           : '||l_output_filename);
   IF p_dump_to_utl_file
    THEN
      l_output_path     := NVL(l_rec_nlf.nlf_path
                              ,hig.get_sysopt(c_utlfiledir_sysopt)
                              );
      IF l_output_path IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 163
                       ,pi_supplementary_info => c_utlfiledir_sysopt
                       );
      END IF;
      add_it ('--  Path           : '||l_output_path);
   END IF;
   add_it ('--  Extracted from : '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'@'||Sys_Context('NM3CORE','INSTANCE_NAME')||'.'|| Sys_Context('NM3CORE','HOST_NAME'));
   add_it ('--  Extracted by   : '||Sys_Context('NM3_SECURITY_CTX','USERNAME'));
   add_it ('--  At             : '||TO_CHAR(SYSDATE,nm3type.c_full_date_time_format));
--   add_it ('--');
--   add_it ('--  NM_LOAD_FILES record as extracted');
--   add_it ('--    NLF_ID               = '||l_rec_nlf.nlf_id||' - will be different on new record');
--   add_it ('--    NLF_UNIQUE           = '||l_rec_nlf.nlf_unique);
--   add_it ('--    NLF_DESCR            = '||nm3flx.repl_quotes_amps_for_dyn_sql(l_rec_nlf.nlf_descr));
--   add_it ('--    NLF_PATH             = '||l_rec_nlf.nlf_path);
--   add_it ('--    NLF_DELIMITER        = '||l_rec_nlf.nlf_delimiter);
--   add_it ('--    NLF_DATE_FORMAT_MASK = '||l_rec_nlf.nlf_date_format_mask);
--   add_it ('--    NLF_HOLDING_TABLE    = '||l_rec_nlf.nlf_holding_table);
   add_it ('--');
   add_it ('-- ###############################################################');
   add_it ('--');
   add_it ('   l_rec_nlf  nm_load_files%ROWTYPE;');
   add_it ('   l_rec_nlfc nm_load_file_cols%ROWTYPE;');
   add_it ('   l_rec_nlfd nm_load_file_destinations%ROWTYPE;');
   add_it ('--');
   add_it ('   PROCEDURE add_nlfc (p_nlfc_holding_col      nm_load_file_cols.nlfc_holding_col%TYPE');
   add_it ('                      ,p_nlfc_datatype         nm_load_file_cols.nlfc_datatype%TYPE');
   add_it ('                      ,p_nlfc_varchar_size     nm_load_file_cols.nlfc_varchar_size%TYPE');
   add_it ('                      ,p_nlfc_mandatory        nm_load_file_cols.nlfc_mandatory%TYPE');
   add_it ('                      ,p_nlfc_seq_no           nm_load_file_cols.nlfc_seq_no%TYPE');
   add_it ('                      ,p_nlfc_date_format_mask nm_load_file_cols.nlfc_date_format_mask%TYPE');
   add_it ('                      ) IS');
   add_it ('   BEGIN');
   add_it ('      l_rec_nlfc.nlfc_seq_no           := p_nlfc_seq_no;');
   add_it ('      l_rec_nlfc.nlfc_holding_col      := p_nlfc_holding_col;');
   add_it ('      l_rec_nlfc.nlfc_datatype         := p_nlfc_datatype;');
   add_it ('      l_rec_nlfc.nlfc_varchar_size     := p_nlfc_varchar_size;');
   add_it ('      l_rec_nlfc.nlfc_mandatory        := p_nlfc_mandatory;');
   add_it ('      l_rec_nlfc.nlfc_date_format_mask := p_nlfc_date_format_mask;');
   add_it ('      nm3ins.ins_nlfc (l_rec_nlfc);');
   add_it ('   END add_nlfc;');
   add_it ('--');
   add_it ('   PROCEDURE upd_nlcd (p_nlcd_dest_col   VARCHAR2');
   add_it ('                      ,p_nlcd_source_col VARCHAR2');
   add_it ('                      ) IS');
   add_it ('   BEGIN');
   add_it ('      UPDATE nm_load_file_col_destinations');
   add_it ('       SET   nlcd_source_col = p_nlcd_source_col');
   add_it ('      WHERE  nlcd_nlf_id     = l_rec_nlf.nlf_id');
   add_it ('       AND   nlcd_nld_id     = l_rec_nlfd.nlfd_nld_id');
   add_it ('       AND   nlcd_dest_col   = p_nlcd_dest_col;');
   add_it ('   END upd_nlcd;');
   add_it ('--');
   add_it ('BEGIN');
   add_it ('--');
   add_it ('   l_rec_nlf.nlf_unique           := '||nm3flx.string(l_rec_nlf.nlf_unique)||';');
   add_it ('--');
   IF p_delete_if_exists
    THEN
      add_it ('   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique');
      add_it ('                  ,pi_raise_not_found => FALSE');
      add_it ('                  );');
   ELSE
      add_it ('   IF nm3get.get_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique');
      add_it ('                     ,pi_raise_not_found => FALSE');
      add_it ('                     ).nlf_id IS NOT NULL');
      add_it ('    THEN');
      add_it ('      hig.raise_ner (pi_appl               => nm3type.c_hig');
      add_it ('                    ,pi_id                 => 64');
      add_it ('                    ,pi_supplementary_info => l_rec_nlf.nlf_unique');
      add_it ('                    );');
      add_it ('   END IF;');
   END IF;
   add_it ('--');
   add_it ('   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;');
   add_it ('   l_rec_nlf.nlf_descr            := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(l_rec_nlf.nlf_descr))||';');
   add_it ('   l_rec_nlf.nlf_path             := '||nm3flx.i_t_e (l_rec_nlf.nlf_path IS NULL
                                                                 ,c_null
                                                                 ,nm3flx.string(l_rec_nlf.nlf_path)
                                                                 )||';');
   add_it ('   l_rec_nlf.nlf_delimiter        := '||nm3flx.string(l_rec_nlf.nlf_delimiter)||';');
   add_it ('   l_rec_nlf.nlf_date_format_mask := '||nm3flx.i_t_e (l_rec_nlf.nlf_date_format_mask IS NULL
                                                                 ,c_null
                                                                 ,nm3flx.string(l_rec_nlf.nlf_date_format_mask)
                                                                 )||';');
   add_it ('   l_rec_nlf.nlf_holding_table    := '||nm3flx.i_t_e (l_rec_nlf.nlf_holding_table IS NULL
                                                                 ,c_null
                                                                 ,nm3flx.string(l_rec_nlf.nlf_holding_table)
                                                                 )||';');
   add_it ('--');
   add_it ('   nm3ins.ins_nlf (l_rec_nlf);');
   add_it ('--');
   add_it ('   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;');
   add_it ('   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;');
   add_it ('--');
   FOR cs_rec IN (SELECT nlfc_holding_col
                        ,'nm3type.c_'||LOWER(DECODE(nlfc_datatype
                                                   ,nm3type.c_varchar,SUBSTR(nm3type.c_varchar,1,7) -- 'varchar'
                                                   ,nlfc_datatype
                                                   )
                                            ) nlfc_datatype
                        ,DECODE(nlfc_varchar_size
                               ,Null,c_null
                               ,nlfc_varchar_size
                               ) nlfc_varchar_size
                        ,nlfc_mandatory
                        ,nlfc_seq_no
                        ,DECODE(nlfc_date_format_mask
                               ,Null,c_null
                               ,nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(nlfc_date_format_mask))
                               ) nlfc_date_format_mask
                   FROM  nm_load_file_cols
                  WHERE  nlfc_nlf_id = l_rec_nlf.nlf_id
                  ORDER BY nlfc_seq_no
                 )
    LOOP
      add_it ('   add_nlfc ('||nm3flx.string(cs_rec.nlfc_holding_col)||','||cs_rec.nlfc_datatype||','||cs_rec.nlfc_varchar_size||','||nm3flx.string(cs_rec.nlfc_mandatory)||','||cs_rec.nlfc_seq_no||','||cs_rec.nlfc_date_format_mask||');');
   END LOOP;
   add_it ('--');
   FOR cs_rec IN (SELECT nlfd_seq
                        ,nld_table_name
                        ,nlfd_nlf_id
                        ,nlfd_nld_id
                   FROM  nm_load_file_destinations
                        ,nm_load_destinations
                  WHERE  nlfd_nlf_id = l_rec_nlf.nlf_id
                   AND   nlfd_nld_id = nld_id
                  ORDER BY nlfd_seq
                 )
    LOOP
      add_it ('   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => '||nm3flx.string(cs_rec.nld_table_name)||').nld_id;');
      add_it ('   l_rec_nlfd.nlfd_seq            := '||cs_rec.nlfd_seq||';');
      add_it ('   nm3ins.ins_nlfd (l_rec_nlfd);');
      add_it ('--');
      FOR cs_inner IN (SELECT DECODE(nlcd_source_col
                                    ,Null,c_null
                                    ,nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(nlcd_source_col))
                                    ) nlcd_source_col
                             ,nlcd_dest_col
                        FROM  nm_load_file_col_destinations
                       WHERE  nlcd_nlf_id     = l_rec_nlf.nlf_id
                        AND   nlcd_nld_id     = cs_rec.nlfd_nld_id
--                        AND   nlcd_source_col IS NOT NULL
                       ORDER BY nlcd_seq_no
                      )
       LOOP
         add_it ('   upd_nlcd ('||nm3flx.string(cs_inner.nlcd_dest_col)||','||cs_inner.nlcd_source_col||');');
      END LOOP;
      add_it ('--');
   END LOOP;
   add_it ('   nm3load.create_holding_table (l_rec_nlf.nlf_id);');
   add_it ('--');
   add_it ('END;');
   add_it ('/');
   add_it (Null);
--
   ROLLBACK TO top_of_proc;
--
   IF p_dump_to_utl_file
    THEN
      nm3file.write_file (location     => l_output_path
                         ,filename     => l_output_filename
                         ,max_linesize => 32767
                         ,all_lines    => l_tab
                         );
      l_full_path := l_output_path||hig.get_sysopt('DIRREPSTRN')||l_output_filename;
   ELSE -- Write to NUF
      DECLARE
         l_rec_nuf               nm_upload_files%ROWTYPE;
         c_mime_type    CONSTANT varchar2(30) := 'application/unknown';
         c_sysdate      CONSTANT date         := SYSDATE;
         c_content_type CONSTANT varchar2(4)  := 'BLOB';
         c_dad_charset  CONSTANT varchar2(5)  := 'ascii';
      BEGIN
      --
--         l_log_filename := l_log_filename||'.txt';
--         l_bad_filename := l_bad_filename||'.txt';
      --
         delete_nuf_for_nlf (pi_nlf_id => l_rec_nlf.nlf_id);
      --
         DELETE nm_upload_files
         WHERE  name = l_output_filename;
      --
         l_rec_nuf.name                   := l_output_filename;
         l_rec_nuf.mime_type              := c_mime_type;
         l_rec_nuf.dad_charset            := c_dad_charset;
         l_rec_nuf.last_updated           := c_sysdate;
         l_rec_nuf.content_type           := c_content_type;
         l_rec_nuf.doc_size               := 0;
         l_rec_nuf.nuf_nufg_table_name    := c_nlf;
         l_rec_nuf.nuf_nufgc_column_val_1 := l_rec_nlf.nlf_id;
      --
         put_line_feed_on_end (l_tab,l_rec_nuf.doc_size);
         l_rec_nuf.blob_content           := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab));
      --
         nm3ins.ins_nuf (l_rec_nuf);
         l_full_path := nm3web_load.get_full_download_url(l_output_filename);
         COMMIT;
      END;
   END IF;
--
   nm_debug.proc_end (g_package_name,'dump_nlf');
--
   RETURN l_full_path;
--
END dump_nlf;
--
-----------------------------------------------------------------------------
--
PROCEDURE put_line_feed_on_end (p_tab_lines IN OUT NOCOPY nm3type.tab_varchar32767
                               ,p_size      IN OUT number
                               ,p_lf        IN     varchar2 DEFAULT CHR(10)
                               ) IS
BEGIN
   FOR i IN 1..p_tab_lines.COUNT
    LOOP
      p_tab_lines(i) := p_tab_lines(i)||p_lf;
      p_size         := p_size + LENGTH(p_tab_lines(i));
   END LOOP;
END put_line_feed_on_end;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_nuf_for_nlf (pi_nlf_id nm_load_files.nlf_id%TYPE) IS
BEGIN
   DELETE nm_upload_files
   WHERE  nuf_nufg_table_name    = c_nlf
    AND   nuf_nufgc_column_val_1 = pi_nlf_id;
END delete_nuf_for_nlf;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_nuf_for_nlb(pi_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE) IS
BEGIN
   DELETE nm_upload_files
   WHERE  nuf_nufg_table_name    = c_nlb
    AND   nuf_nufgc_column_val_1 = pi_nlb_batch_no;
END delete_nuf_for_nlb;
--
-----------------------------------------------------------------------------
--
END nm3load;
/
