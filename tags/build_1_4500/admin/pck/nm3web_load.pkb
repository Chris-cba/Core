CREATE OR REPLACE PACKAGE BODY nm3web_load AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web_load.pkb-arc   2.4   May 17 2011 08:26:28   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3web_load.pkb  $
--       Date into PVCS   : $Date:   May 17 2011 08:26:28  $
--       Date fetched Out : $Modtime:   May 05 2011 14:46:22  $
--       PVCS Version     : $Revision:   2.4  $
--       Based on SCCS version : 
--
--
--   Author : Jonathan Mills
--
--   NM3 CSV Loader Web package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.4  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web_load';
--
   c_this_module     CONSTANT  hig_modules.hmo_module%TYPE := 'HIGWEB2030';
   c_module_title    CONSTANT  hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   CURSOR cs_hco (c_hco_domain hig_codes.hco_domain%TYPE) IS
   SELECT *
    FROM  hig_codes
   WHERE  hco_domain = c_hco_domain
   ORDER BY hco_seq;
--
   c_csv_process_type CONSTANT  hig_domains.hdo_domain%TYPE := 'CSV_PROCESS_TYPE';
   --
   c_interactive_mode      CONSTANT  varchar2(1)  := 'I';
   c_batch_mode            CONSTANT  varchar2(1)  := 'B';
   c_interactive_mode_desc CONSTANT  varchar2(11) := 'Interactive';
   c_batch_mode_desc       CONSTANT  varchar2(5)  := 'Batch';
--
   c_validate_subtype      CONSTANT  VARCHAR2(1)  := 'V';
   c_load_subtype          CONSTANT  VARCHAR2(1)  := 'L';
   c_log_files_subtype     CONSTANT  VARCHAR2(1)  := 'F';
   c_process_line_subtype  CONSTANT  VARCHAR2(1)  := 'Z';
--
   g_checked                         varchar2(8);
   c_checked  CONSTANT               varchar2(8)  := ' CHECKED';
   g_disabled CONSTANT               varchar2(9)  := ' DISABLED';
--
-----------------------------------------------------------------------------
--
PROCEDURE load_new_file (p_nlf_id       nm_load_files.nlf_id%TYPE
                        ,p_client_or_server varchar2
                        );
--
-----------------------------------------------------------------------------
--
PROCEDURE select_existing_batch (p_nlf_id       nm_load_files.nlf_id%TYPE
                                ,p_nlb_id       number
                                );
--
-----------------------------------------------------------------------------
--
PROCEDURE show_log_files (p_nlb_batch_no   nm_load_batches.nlb_batch_no%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE batch_housekeeping (p_nlf_id       nm_load_files.nlf_id%TYPE);
--
-----------------------------------------------------------------------------
--
FUNCTION validation_procs_exist (p_nlf_id       nm_load_files.nlf_id%TYPE) RETURN boolean;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_mode_table;
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
   htp.p('--       sccsid           : @(#)nm3web_load.pkb	1.10 03/08/05');
   htp.p('--       Module Name      : nm3web_load.pkb');
   htp.p('--       Date into SCCS   : 05/03/08 02:27:46');
   htp.p('--       Date fetched Out : 06/03/28 12:06:03');
   htp.p('--       SCCS Version     : 1.10');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   NM3 CSV Loader Web package');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) exor corporation ltd, 2002');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
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
PROCEDURE main IS
--
   CURSOR cs_nlf IS
   SELECT nlf_id
         ,nlf_unique
         ,nlf_descr
    FROM  nm_load_files
   WHERE nlf_unique not like '%_LINE'
   ORDER  BY nlf_unique;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'main');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   htp.tableopen;
   --
   htp.tablerowopen;
   htp.formopen(g_package_name||'.process');
   htp.tableheader ('Select File Definition');
   htp.p('<TD>');
   htp.formselectopen (cname => 'p_nlf_id');
   FOR cs_nlf_rec IN cs_nlf
    LOOP
      htp.p('<OPTION VALUE="'||cs_nlf_rec.nlf_id||'">'||cs_nlf_rec.nlf_unique||' - '||cs_nlf_rec.nlf_descr||'</OPTION>');
   END LOOP;
   htp.formselectclose;
   htp.p('</TD>');
   htp.tablerowclose;
--
   htp.tablerowopen;
   htp.p('<TD COLSPAN=2>');
      htp.tableopen(cattributes=>'WIDTH=100%');
      g_checked := c_checked;
      FOR cs_rec IN cs_hco (c_csv_process_type)
       LOOP
         htp.tablerowopen;
         htp.tabledata(htf.small(cs_rec.hco_meaning));
         htp.tabledata('<INPUT TYPE=RADIO NAME="p_process_type" VALUE="'||cs_rec.hco_code||'"'||g_checked||'>'
                      );
         g_checked := NULL;
         htp.tablerowclose;
      END LOOP;
      htp.tablerowclose;
   htp.p('</TD>');
--
   htp.tablerowopen(calign => 'CENTER');
   htp.tabledata(htf.formsubmit (cvalue=> c_continue)
                ,cattributes => 'COLSPAN=2'
                );
   htp.p('</TD>');
   htp.tablerowclose;
--
   htp.tableclose;
--
   nm3web.CLOSE;
--
   nm_debug.proc_end (g_package_name,'main');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END main;
--
-----------------------------------------------------------------------------
--
PROCEDURE process (p_nlf_id       nm_load_files.nlf_id%TYPE
                  ,p_process_type varchar2 DEFAULT NULL
                  ,p_nlb_id       number   DEFAULT NULL
                  ) IS
--
   l_rec_nlf nm_load_files%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'process');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   IF p_process_type IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'p_process_type'
                    );
   ELSIF p_process_type NOT IN ('T','P','C','H')
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'p_process_type='||p_process_type
                    );
   END IF;
--
   l_rec_nlf := nm3load.get_nlf(p_nlf_id);
--
   htp.HEADER (1, l_rec_nlf.nlf_unique||' - '||l_rec_nlf.nlf_descr);
   htp.br;
--
   IF    p_process_type = 'T'
    THEN
      load_new_file (p_nlf_id,'S');
   ELSIF p_process_type = 'C'
    THEN
      load_new_file (p_nlf_id,'C');
   ELSIF p_process_type = 'P'
    THEN
      select_existing_batch (p_nlf_id,p_nlb_id);
   ELSIF p_process_type = 'H'
    THEN
      batch_housekeeping (p_nlf_id);
   END IF;
--
   nm3web.CLOSE;
--
   nm_debug.proc_end (g_package_name,'process');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END process;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_new_file (p_nlf_id           nm_load_files.nlf_id%TYPE
                        ,p_client_or_server varchar2
                        ) IS
   l_rec_nlf nm_load_files%ROWTYPE;
BEGIN
--
   nm_debug.proc_start (g_package_name,'load_new_file');
--
   htp.tableopen;
   --
   htp.tablerowopen;
   l_rec_nlf := nm3get.get_nlf (pi_nlf_id => p_nlf_id);
--
   IF p_client_or_server = 'S'
    THEN
      IF l_rec_nlf.nlf_path IS NULL
       THEN
         hig.raise_ner (pi_appl => nm3type.c_hig
                       ,pi_id   => 186
                       );
      END IF;
      htp.formopen (curl     => g_package_name||'.load_file_web'
                   );
      htp.formhidden (cname  => 'p_nlf_id'
                     ,cvalue => p_nlf_id
                     );
      htp.tableheader ('Server Path');
      htp.tabledata (htf.small(l_rec_nlf.nlf_path));
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tableheader ('Server Filename');
      htp.tabledata (htf.formtext (cname => 'p_server_filename'));
      submit_mode_table;
   ELSIF p_client_or_server = 'C'
    THEN
      htp.formopen (curl     => g_package_name||'.load_file_web'
                   ,cenctype => 'multipart/form-data'
                   );
      htp.formhidden (cname  => 'p_nlf_id'
                     ,cvalue => p_nlf_id
                     );
      htp.tableheader ('Client Filename');
      htp.tabledata (htf.formfile(cname => 'p_client_filename'));
      htp.tablerowclose;
      submit_mode_table;
   END IF;
--
   htp.tablerowopen(calign => 'CENTER');
   htp.tabledata(htf.formsubmit (cvalue=>c_continue)
                ,cattributes => 'COLSPAN=2'
                );
   htp.p('</TD>');
   htp.tablerowclose;
--
   htp.tableclose;
--
   nm_debug.proc_end (g_package_name,'load_new_file');
--
EXCEPTION
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END load_new_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_file_web (p_nlf_id          nm_load_files.nlf_id%TYPE
                        ,p_server_filename varchar2
                        ,p_submit_mode     varchar2 DEFAULT 'I'
                        ) IS
   l_batch_no        pls_integer;
BEGIN
--
   IF p_submit_mode = c_interactive_mode
    THEN
      l_batch_no := nm3load.transfer_to_holding (p_nlf_id       => p_nlf_id
                                                ,p_file_name    => p_server_filename
                                                ,p_batch_source => 'S'
                                                );
   --
      htp.formopen(g_package_name||'.process');
      htp.formhidden (cname  => 'p_nlf_id'
                     ,cvalue => p_nlf_id
                     );
      htp.formhidden (cname  => 'p_process_type'
                     ,cvalue => 'P'
                     );
      htp.formhidden (cname  => 'p_nlb_id'
                     ,cvalue => l_batch_no
                     );
      htp.formsubmit (cvalue=>c_continue);
   --
      show_log_files (p_nlb_batch_no => l_batch_no);
   ELSE
      nm3load.transfer_to_holding_dbms_job (p_nlf_id       => p_nlf_id
                                           ,p_file_name    => p_server_filename
                                           ,p_batch_source => 'S'
                                           ,p_produce_htp  => TRUE
                                           );
   END IF;
--
EXCEPTION
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END load_file_web;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_file_web (p_nlf_id          nm_load_files.nlf_id%TYPE
                        ,p_client_filename varchar2
                        ,p_submit_mode     varchar2  DEFAULT 'I'
                        ) IS
--
   l_batch_no          pls_integer;
   l_client_filename   nm_load_batches.nlb_filename%TYPE;
   l_stripped_filename nm_load_batches.nlb_filename%TYPE;
   l_new_filename      nm_load_batches.nlb_filename%TYPE;
   l_rec_nlf           nm_load_files%ROWTYPE;
--
BEGIN
--
   l_rec_nlf := nm3get.get_nlf(pi_nlf_id => p_nlf_id);
--
   l_stripped_filename := nm3upload.strip_dad_reference(p_client_filename);
   l_client_filename   := TO_CHAR(SYSDATE,'YYMMDDHH24MISS')||'.'||l_stripped_filename;
--
   UPDATE nm_upload_files
    SET   name = l_client_filename
   WHERE  name = p_client_filename;
--
   IF p_submit_mode = c_interactive_mode
    THEN
      l_batch_no := nm3load.transfer_to_holding (p_nlf_id       => p_nlf_id
                                                ,p_file_name    => l_client_filename
                                                ,p_batch_source => 'C'
                                                );
   --
      l_new_filename := l_batch_no||'.'||l_stripped_filename;
   --
      UPDATE nm_upload_files
       SET   name                   = l_new_filename
            ,nuf_nufg_table_name    = nm3load.c_nlb
            ,nuf_nufgc_column_val_1 = l_batch_no
      WHERE  name                   = l_client_filename;
   --
      UPDATE nm_load_batches
       SET   nlb_filename = l_new_filename
      WHERE  nlb_batch_no = l_batch_no;
--
      COMMIT;
   --
      htp.formopen(g_package_name||'.process');
      htp.formhidden (cname  => 'p_nlf_id'
                     ,cvalue => p_nlf_id
                     );
      htp.formhidden (cname  => 'p_process_type'
                     ,cvalue => 'P'
                     );
      htp.formhidden (cname  => 'p_nlb_id'
                     ,cvalue => l_batch_no
                     );
      htp.formsubmit (cvalue=>c_continue);
   --
      show_log_files (p_nlb_batch_no => l_batch_no);
   --
   ELSE
      nm3load.transfer_to_holding_dbms_job (p_nlf_id       => p_nlf_id
                                           ,p_file_name    => l_client_filename
                                           ,p_batch_source => 'C'
                                           ,p_produce_htp  => TRUE
                                           );
   END IF;
--
EXCEPTION
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END load_file_web;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_log_files (p_nlb_batch_no   nm_load_batches.nlb_batch_no%TYPE) IS
BEGIN
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   nm3load.produce_log_files (p_nlb_batch_no   => p_nlb_batch_no
                             ,p_produce_as_htp => TRUE
                             );
--
   nm3web.CLOSE;
--
   nm_debug.proc_end (g_package_name,'process');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
--
END show_log_files;
--
-----------------------------------------------------------------------------
--
FUNCTION load_module_is_readonly RETURN BOOLEAN IS
   l_rec_hmo  hig_modules%ROWTYPE;
   l_hmr_mode hig_module_roles.hmr_mode%TYPE;
BEGIN
--
   hig.get_module_details (pi_module => c_this_module
                          ,po_hmo    => l_rec_hmo
                          ,po_mode   => l_hmr_mode
                          );
--
   RETURN (l_hmr_mode = nm3type.c_readonly);
--
END load_module_is_readonly;
--
-----------------------------------------------------------------------------
--
FUNCTION make_smaller (p_text varchar2) RETURN varchar2 IS
BEGIN
   RETURN '<FONT SIZE=-2>'||p_text||'</FONT>';
END make_smaller;
--
-----------------------------------------------------------------------------
--
FUNCTION batch_is_readonly (p_module_is_readonly BOOLEAN
                           ,p_nlb_created_by     VARCHAR2
                           ) RETURN BOOLEAN IS
   l_readonly_batch BOOLEAN := FALSE;
BEGIN
   IF   p_module_is_readonly
    AND p_nlb_created_by != Sys_Context('NM3_SECURITY_CTX','USERNAME')
    THEN
      l_readonly_batch := TRUE;
   END IF;
   RETURN l_readonly_batch;
END batch_is_readonly;
--
-----------------------------------------------------------------------------
--
PROCEDURE select_existing_batch (p_nlf_id       nm_load_files.nlf_id%TYPE
                                ,p_nlb_id       number
                                ) IS
--
   CURSOR cs_nlb (c_nlb_nlf_id nm_load_batches.nlb_nlf_id%TYPE
                 ) IS
   SELECT *
    FROM  nm_load_batches
   WHERE  nlb_nlf_id  = c_nlb_nlf_id
   ORDER BY nlb_date_modified DESC;
--
   l_found    boolean := FALSE;
   l_selected varchar2(9);
   l_attribute VARCHAR2(30);
   l_readonly  BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'select_existing_batch');
--
   htp.formopen(g_package_name||'.process_existing');
--
   htp.tableopen;
   htp.tablerowopen;
   htp.tableheader('Select Batch');
--
   l_readonly := load_module_is_readonly;
--
   htp.p('<TD>');
   FOR cs_nlb_rec IN cs_nlb (p_nlf_id)
    LOOP
      IF cs_nlb_rec.nlb_batch_no = p_nlb_id
       THEN
         l_selected := ' SELECTED';
      ELSE
         l_selected := NULL;
      END IF;
      IF NOT batch_is_readonly (l_readonly,cs_nlb_rec.nlb_created_by)
       THEN
         IF NOT l_found
          THEN
            htp.formselectopen (cname => 'p_nlb_batch_no');
         END IF;
         htp.p('<OPTION VALUE="'||cs_nlb_rec.nlb_batch_no||'"'||l_selected||'>'
               ||cs_nlb_rec.nlb_batch_no
               ||' - "'
               ||cs_nlb_rec.nlb_filename
               ||'" ('||TO_CHAR(cs_nlb_rec.nlb_date_modified,nm3type.c_full_date_time_format)
               ||')</OPTION>'
              );
         l_found := TRUE;
      END IF;
   END LOOP;
   IF NOT l_found
    THEN
      IF p_nlb_id IS NOT NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => 'nm_load_batches.nlb_nlf_id='||p_nlf_id
                       );
      ELSE
         htp.italic ('No batches found');
         RETURN;
      END IF;
   END IF;
   htp.formselectclose;
   htp.p('</TD>');
   htp.tablerowclose;
--
   htp.tablerowopen;
   htp.tableheader('Process');
   htp.p('<TD>');
--
      htp.tableopen(cattributes=>'WIDTH=100%');
      g_checked := c_checked;
      FOR cs_rec IN cs_hco ('CSV_PROCESS_SUBTYPE')
       LOOP
         IF  (cs_rec.hco_code = c_validate_subtype
             AND NOT validation_procs_exist (p_nlf_id)
             )
          OR (cs_rec.hco_code = c_load_subtype
              AND l_readonly
             )
          THEN
            l_attribute := g_disabled;
         ELSE
            l_attribute := g_checked;
            g_checked   := NULL;
         END IF;
         htp.tablerowopen;
         htp.tabledata(htf.small(cs_rec.hco_meaning));
         htp.tabledata('<INPUT TYPE=RADIO NAME="p_process_subtype" VALUE="'||cs_rec.hco_code||'"'||l_attribute||'>'
                      );
         htp.tablerowclose;
      END LOOP;
      htp.tablerowclose;
      htp.tableclose;
   htp.p('</TD>');
   htp.tablerowclose;
   submit_mode_table;
--
   htp.tablerowopen(calign => 'CENTER');
   htp.tabledata(htf.formsubmit (cvalue=>c_continue)
                ,cattributes => 'COLSPAN=2'
                );
   htp.p('</TD>');
   htp.tablerowclose;
--
   htp.tableclose;
--
   nm_debug.proc_end (g_package_name,'select_existing_batch');
--
EXCEPTION
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END select_existing_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_existing (p_nlb_batch_no    nm_load_batches.nlb_batch_no%TYPE
                           ,p_process_subtype varchar2 DEFAULT NULL
                           ,p_submit_mode     varchar2 DEFAULT 'I'
                           ) IS
--
   l_rec_nlb     nm_load_batches%ROWTYPE;
   l_new_nlf_id  nm_load_files.nlf_id%TYPE;
   l_new_nlb_id  nm_load_batches.nlb_batch_no%TYPE;
--
  p_join_column  VARCHAR2(30);
--
   CURSOR c_tab_cols (cp_table_name IN VARCHAR2)
   IS
    SELECT * 
    FROM   user_tab_columns
    WHERE  table_name = cp_table_name
    ORDER BY 1;
--
   FUNCTION get_asset_type (pi_nlf_id IN nm_load_files.nlf_id%TYPE)
     RETURN nm_inv_types.nit_inv_type%TYPE
   IS
     retval nm_inv_types.nit_inv_type%TYPE;
     l_rec_nlf  nm_load_files%ROWTYPE;
   BEGIN
     l_rec_nlf := nm3get.get_nlf(pi_nlf_id=>pi_nlf_id);
     RETURN  substr(l_rec_nlf.nlf_unique,0,instr(l_rec_nlf.nlf_unique,'_')-1);
   END get_asset_type;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'process_existing');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   IF p_process_subtype IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'p_process_subtype'
                    );
   ELSIF p_process_subtype NOT IN (c_validate_subtype,c_load_subtype,c_log_files_subtype,c_process_line_subtype)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'p_process_subtype='||p_process_subtype
                    );
   END IF;
--
   l_rec_nlb := nm3load.get_nlb (p_nlb_batch_no);
--
   IF batch_is_readonly (load_module_is_readonly,l_rec_nlb.nlb_created_by)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 339
                    );
   END IF;
--
   IF p_process_subtype = c_log_files_subtype
    THEN
      htp.tableopen;
      htp.tablerowopen;
      htp.formopen(g_package_name||'.main');
      htp.tabledata(htf.formsubmit (cvalue=>c_continue));
      htp.formclose;
      htp.formopen(g_package_name||'.process_existing');
      htp.formhidden (cname  => 'p_nlb_batch_no'
                     ,cvalue => p_nlb_batch_no
                     );
      htp.formhidden (cname  => 'p_process_subtype'
                     ,cvalue => p_process_subtype
                     );
      htp.tabledata(htf.formsubmit (cvalue=>'Refresh'));
      htp.formclose;
      htp.tablerowclose;
      htp.tableclose;
      show_log_files (p_nlb_batch_no => p_nlb_batch_no);
   ELSIF p_submit_mode = c_interactive_mode
    THEN
      IF    p_process_subtype = c_validate_subtype
       THEN
         htp.formopen(g_package_name||'.process');
         htp.formhidden (cname  => 'p_nlf_id'
                        ,cvalue => l_rec_nlb.nlb_nlf_id
                        );
         htp.formhidden (cname  => 'p_process_type'
                        ,cvalue => 'P'
                        );
         htp.formhidden (cname  => 'p_nlb_id'
                        ,cvalue => p_nlb_batch_no
                        );
         htp.formsubmit (cvalue=>c_continue);
         nm3load.validate_batch(p_nlb_batch_no);
      ELSIF p_process_subtype = c_load_subtype
       THEN
         htp.formopen(g_package_name||'.main');
         htp.formsubmit (cvalue=>c_continue);
         nm3load.load_batch(p_nlb_batch_no);

      ELSIF p_process_subtype = c_process_line_subtype
       THEN

         htp.tableopen;

           htp.tablerowopen;
           htp.tableheader('Pre-Process Line Data');
           htp.tablerowclose;
         --
           htp.formopen(g_package_name||'.process_lines');
         --
           htp.formhidden (cname  => 'pi_asset_type'
                          ,cvalue => get_asset_type(l_rec_nlb.nlb_nlf_id));
         --
           htp.formhidden (cname  => 'pi_load_file_unique'
                          ,cvalue => nm3get.get_nlf(pi_nlf_id=>l_rec_nlb.nlb_nlf_id).nlf_unique);
--
           htp.formhidden (cname  => 'pi_batch_no'
                          ,cvalue => p_nlb_batch_no);
         --
 
           htp.tabledata ('Join Column');
           htp.p('<TD>');
           htp.formselectopen (cname => 'pi_join_column');

           FOR i IN c_tab_cols ('NM_LD_'||nm3get.get_nlf(pi_nlf_id=>l_rec_nlb.nlb_nlf_id).nlf_unique||'_TMP')
           LOOP
             --htp.p('<OPTION VALUE="'||i.column_name||'"</OPTION>');
             htp.p('<OPTION VALUE="'||i.column_name||'">'||i.column_name||'</OPTION>');
           END LOOP;

           htp.formselectclose;
           htp.p('</TD>');
           htp.tablerowclose;

           htp.tabledata ('Start/End Identifier Column');
           htp.p('<TD>');
           htp.formselectopen (cname => 'pi_locate_ref_column');

           FOR i IN c_tab_cols ('NM_LD_'||nm3get.get_nlf(pi_nlf_id=>l_rec_nlb.nlb_nlf_id).nlf_unique||'_TMP')
           LOOP
             --htp.p('<OPTION VALUE="'||i.column_name||'"</OPTION>');
             htp.p('<OPTION VALUE="'||i.column_name||'">'||i.column_name||'</OPTION>');
           END LOOP;

           htp.formselectclose;
           htp.p('</TD>');
           htp.tablerowclose;

         htp.tableclose;

         htp.formsubmit (cvalue=>c_continue);

      END IF;
--
      IF p_process_subtype != c_process_line_subtype
      THEN
        show_log_files (p_nlb_batch_no => p_nlb_batch_no);
      END IF;
--
   ELSE
      IF    p_process_subtype = c_validate_subtype
       THEN
         nm3load.validate_dbms_job (p_batch_no      => p_nlb_batch_no
                                   ,p_produce_htp   => TRUE
                                   );
      ELSIF p_process_subtype = c_load_subtype
       THEN
         nm3load.load_dbms_job (p_batch_no      => p_nlb_batch_no
                               ,p_produce_htp   => TRUE
                               );
      END IF;
   END IF;
--
   nm3web.CLOSE;
--
   nm_debug.proc_end (g_package_name,'process_existing');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
--
END process_existing;
--
-----------------------------------------------------------------------------
--
  PROCEDURE process_lines
        ( pi_asset_type         IN nm_inv_types.nit_inv_type%TYPE
        , pi_load_file_unique   IN nm_load_files.nlf_unique%TYPE
        , pi_batch_no           IN nm_load_batches.nlb_batch_no%TYPE
        , pi_join_column        IN VARCHAR2 DEFAULT 'LFK'
        , pi_locate_ref_column  IN VARCHAR2 DEFAULT 'LOCATEREF')
  IS
    l_nlf_id nm_load_files.nlf_id%TYPE;
    l_nlb_id nm_load_batches.nlb_batch_no%TYPE;
  BEGIN
    nm3inv_load.process_line_data
        ( pi_asset_type         => pi_asset_type
        , pi_load_file_unique   => pi_load_file_unique
        , pi_batch_no           => pi_batch_no
        , pi_join_column        => pi_join_column
        , pi_locate_ref_column  => pi_locate_ref_column
        , po_nlf_id             => l_nlf_id
        , po_nlb_batch_no       => l_nlb_id);

----    nm_debug.debug('Done process lines data');
----    
--    htp.formopen(g_package_name||'.process');
--    htp.formhidden (cname  => 'p_nlf_id'
--                   ,cvalue => l_nlf_id);
--    htp.formhidden (cname  => 'p_process_type'
--                   ,cvalue => 'P' );
--    htp.formhidden (cname  => 'p_nlb_id'
--                   ,cvalue => l_nlb_id);
    nm3web_load.process(p_nlf_id=>l_nlf_id, p_process_type=>'P',p_nlb_id=>l_nlb_id);
--    nm_debug.debug('built new call');
  END process_lines;
--
-----------------------------------------------------------------------------
--
PROCEDURE batch_housekeeping (p_nlf_id       nm_load_files.nlf_id%TYPE) IS
--
   CURSOR cs_nlb (c_nlb_nlf_id nm_load_batches.nlb_nlf_id%TYPE) IS
   SELECT nlb_batch_no
         ,nlb_filename
         ,nlb_record_count
         ,nlb_date_created
         ,nlb_date_modified
         ,nlb_modified_by
         ,nlb_created_by
         ,nlb_batch_source
    FROM  nm_load_batches
   WHERE  nlb_nlf_id  = c_nlb_nlf_id
   ORDER BY nlb_date_created;
--
   CURSOR cs_nlbs (c_nlbs_nlb_batch_no nm_load_batch_status.nlbs_nlb_batch_no%TYPE) IS
   SELECT nlbs_status
         ,COUNT(*) status_count
    FROM  nm_load_batch_status
   WHERE  nlbs_nlb_batch_no = c_nlbs_nlb_batch_no
   GROUP BY nlbs_status;
--
   l_tab_nlb_batch_no      nm3type.tab_number;
   l_tab_nlb_filename      nm3type.tab_varchar2000;
   l_tab_nlb_record_count  nm3type.tab_number;
   l_tab_nlb_date_created  nm3type.tab_date;
   l_tab_nlb_date_modified nm3type.tab_date;
   l_tab_nlb_modified_by   nm3type.tab_varchar30;
   l_tab_nlb_created_by    nm3type.tab_varchar30;
   l_tab_nlb_batch_source  nm3type.tab_varchar4;
--
   l_readonly              BOOLEAN;
   l_readonly_batch        BOOLEAN;
--
   c_not_available CONSTANT nm3type.max_varchar2 := make_smaller('Batch details not available');
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'batch_housekeeping');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   l_readonly := load_module_is_readonly;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   htp.HEADER(2
             ,nm3get.get_hco(pi_hco_domain => c_csv_process_type
                            ,pi_hco_code   => 'H'
                            ).hco_meaning
             );
--
   OPEN  cs_nlb (p_nlf_id);
   FETCH cs_nlb
    BULK COLLECT
    INTO l_tab_nlb_batch_no
        ,l_tab_nlb_filename
        ,l_tab_nlb_record_count
        ,l_tab_nlb_date_created
        ,l_tab_nlb_date_modified
        ,l_tab_nlb_modified_by
        ,l_tab_nlb_created_by
        ,l_tab_nlb_batch_source;
   CLOSE cs_nlb;
--
   IF l_tab_nlb_batch_no.COUNT = 0
    THEN
      htp.italic ('No batches found');
   ELSE
      htp.formopen(g_package_name||'.delete_batch');
      htp.p('<TABLE BORDER=1>');
      htp.tablerowopen('CENTER');
      htp.tableheader(make_smaller('Batch No'));
      htp.tableheader(make_smaller('Filename'));
      htp.tableheader(make_smaller('Source'));
      htp.tableheader(make_smaller('Rec Cnt'));
      htp.tableheader(make_smaller('Batch Dets'));
      htp.tableheader(make_smaller('Created'));
      htp.tableheader(make_smaller('Created By'));
      htp.tableheader(make_smaller('Last Modified'));
      htp.tableheader(make_smaller('Modified By'));
      htp.tableheader(htf.formsubmit (cvalue=>'Delete'));
      htp.tablerowclose;
      FOR i IN 1..l_tab_nlb_batch_no.COUNT
       LOOP
         l_readonly_batch := batch_is_readonly (l_readonly,l_tab_nlb_created_by(i));
         htp.tablerowopen('CENTER');
         htp.tabledata(make_smaller(l_tab_nlb_batch_no(i)));
         IF l_tab_nlb_batch_source(i) = 'C'
          THEN
            DECLARE
               PROCEDURE link_nuf (p_name varchar2) IS
                  CURSOR cs_nuf (c_name nm_upload_files.NAME%TYPE) IS
                  SELECT 1
                   FROM  nm_upload_files
                  WHERE  NAME            = c_name
                   AND   NVL(doc_size,0) > 0;
                  l_dummy pls_integer;
                  l_found boolean;
               BEGIN
                  OPEN  cs_nuf (p_name);
                  FETCH cs_nuf INTO l_dummy;
                  l_found := cs_nuf%FOUND;
                  CLOSE cs_nuf;
                  IF l_found
                   THEN
                     htp.tablerowopen;
                     htp.tabledata(make_smaller(htf.anchor(curl  => nm3web.get_download_url(p_name)
                                                          ,ctext => p_name
                                                          )
                                               )
                                  );
                     htp.tablerowclose;
                  END IF;
               END link_nuf;
            BEGIN
               htp.p('<TD>');
               IF l_readonly_batch
                THEN
                  htp.p(c_not_available);
               ELSE
               htp.tableopen;
               link_nuf(l_tab_nlb_filename(i));
               link_nuf(l_tab_nlb_filename(i)||'.log');
               link_nuf(l_tab_nlb_filename(i)||'.bad');
               htp.tableclose;
               END IF;
               htp.p('</TD>');
            END;
         ELSE
            IF l_readonly_batch
             THEN
               htp.tabledata(c_not_available);
            ELSE
               htp.tabledata(make_smaller(l_tab_nlb_filename(i)));
            END IF;
         END IF;
         htp.tabledata(make_smaller(l_tab_nlb_batch_source(i)));
         htp.tabledata(make_smaller(l_tab_nlb_record_count(i)));
         --
         htp.p('<TD>');
         htp.p('<TABLE BORDER=1>');
         htp.tablerowopen('CENTER');
         htp.tableheader(make_smaller('Status'));
         htp.tableheader(make_smaller('Count'));
         htp.tablerowclose;
         FOR cs_rec IN cs_nlbs (l_tab_nlb_batch_no(i))
          LOOP
            htp.tablerowopen('CENTER');
            htp.tabledata (make_smaller(cs_rec.nlbs_status));
            htp.tabledata (make_smaller(cs_rec.status_count));
            htp.tablerowclose;
         END LOOP;
         htp.p('</TABLE>');
         htp.p('</TD>');
         --
         htp.tabledata(make_smaller(TO_CHAR(l_tab_nlb_date_created(i),nm3type.c_full_date_time_format)));
         htp.tabledata(make_smaller(l_tab_nlb_created_by(i)));
         htp.tabledata(make_smaller(TO_CHAR(l_tab_nlb_date_modified(i),nm3type.c_full_date_time_format)));
         htp.tabledata(make_smaller(l_tab_nlb_modified_by(i)));
         --
         htp.p('<TD>');
         htp.formcheckbox  (cname       => 'p_nlb_batch_no'
                           ,cvalue      => l_tab_nlb_batch_no(i)
                           ,cattributes => nm3flx.i_t_e (l_readonly_batch
                                                        ,'DISABLED'
                                                        ,Null
                                                        )
                           );
         htp.p('</TD>');
         --
         htp.tablerowclose;
      END LOOP;
      htp.tableclose;
--
      htp.br;
      htp.br;
      htp.tableopen('BORDER=1');
      htp.tablerowopen;
      htp.tableheader(make_smaller('Status'));
      htp.tableheader(make_smaller('Meaning'));
      htp.tablerowclose;
      FOR cs_rec IN cs_hco ('CSV_LOAD_STATUSES')
       LOOP
         htp.tablerowopen;
         htp.tabledata(make_smaller(cs_rec.hco_code));
         htp.tabledata(make_smaller(cs_rec.hco_meaning));
         htp.tablerowclose;
      END LOOP;
      htp.tableclose;
--
   END IF;
--
   nm3web.CLOSE;
--
   nm_debug.proc_end (g_package_name,'batch_housekeeping');
--
END batch_housekeeping;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_batch (p_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE
                       ) IS
   l_tab_nlb_batch_no owa_util.ident_arr;
BEGIN
--
   nm_debug.proc_start (g_package_name,'delete_batch');
--
   l_tab_nlb_batch_no(1) := p_nlb_batch_no;
--
   delete_batch (p_nlb_batch_no => l_tab_nlb_batch_no);
--
   nm_debug.proc_end (g_package_name,'delete_batch');
--
END delete_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_batch (p_nlb_batch_no owa_util.ident_arr DEFAULT nm3web.g_empty_ident_arr
                       ) IS
--
   PRAGMA autonomous_transaction;
--
   l_tab_to_delete nm3type.tab_number;
   i pls_integer;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'delete_batch');
--
   i := p_nlb_batch_no.FIRST;
   WHILE i IS NOT NULL
    LOOP
      IF p_nlb_batch_no.EXISTS(i)
       THEN
         l_tab_to_delete(l_tab_to_delete.COUNT+1) := p_nlb_batch_no(i);
      END IF;
      i := p_nlb_batch_no.NEXT(i);
   END LOOP;
--
   FORALL i IN 1..l_tab_to_delete.COUNT
      DELETE FROM nm_load_batches
      WHERE  nlb_batch_no = l_tab_to_delete(i);
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   nm3web.CLOSE;
--
   COMMIT;
--
   nm_debug.proc_end (g_package_name,'delete_batch');
--
   main;
--
END delete_batch;
--
-----------------------------------------------------------------------------
--
FUNCTION validation_procs_exist (p_nlf_id       nm_load_files.nlf_id%TYPE) RETURN boolean IS
   CURSOR cs_val (c_nlf_id       nm_load_files.nlf_id%TYPE) IS
   SELECT 1
    FROM  nm_load_file_destinations
         ,nm_load_destinations
   WHERE  nlfd_nlf_id = c_nlf_id
    AND   nlfd_nld_id = nld_id
    AND   nld_validation_proc IS NOT NULL;
   l_retval boolean;
   l_dummy  pls_integer;
BEGIN
--
   OPEN  cs_val (p_nlf_id);
   FETCH cs_val INTO l_dummy;
   l_retval := cs_val%FOUND;
   CLOSE cs_val;
--
   RETURN l_retval;
--
END validation_procs_exist;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_mode_table IS
BEGIN
   htp.tablerowopen;
   htp.tableheader ('Process Method');
   htp.p('<TD>');
      htp.tableopen;
      htp.tablerowopen;
      htp.tabledata('<INPUT TYPE=RADIO NAME="p_submit_mode" VALUE="'||c_batch_mode||'"><FONT SIZE=-1>'||c_batch_mode_desc||'</FONT></INPUT>');
      htp.tabledata('<INPUT TYPE=RADIO NAME="p_submit_mode" VALUE="'||c_interactive_mode||'"'||c_checked||'><FONT SIZE=-1>'||c_interactive_mode_desc||'</FONT></INPUT>');
      htp.tablerowclose;
      htp.tableclose;
   htp.p('</TD>');
   htp.tablerowclose;
END submit_mode_table;
--
-----------------------------------------------------------------------------
--
FUNCTION get_full_download_url (p_filename varchar2) RETURN varchar2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   l_retval := hig.get_sysopt('NM3WEBHOST')||hig.get_sysopt('NM3WEBPATH');
   IF nm3flx.right(l_retval,1) NOT IN ('\','/')
    THEN
      l_retval := l_retval||'/';
   END IF;
   l_retval := l_retval||nm3web.get_download_url(p_filename);
   RETURN l_retval;
END get_full_download_url;
--
-------------------------------------------------------------------------------
--
END nm3web_load;
/
