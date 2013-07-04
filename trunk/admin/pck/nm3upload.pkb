CREATE OR REPLACE PACKAGE BODY nm3upload AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3upload.pkb	1.15 05/17/04
--       Module Name      : nm3upload.pkb
--       Date into SCCS   : 04/05/17 11:04:36
--       Date fetched Out : 07/06/13 14:13:43
--       SCCS Version     : 1.15
--
--
--   Author : K Angus, I Turnbull
--
--   NM3 Upload: Contains procedures and functions for uploading data.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3upload.pkb	1.15 05/17/04"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3upload';

   g_file_type    varchar2(30);
--
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0010';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   c_document_table CONSTANT varchar2(30) := nm3web.get_document_table;
   c_detail         CONSTANT varchar2(6)  := 'Detail';
   c_save           CONSTANT varchar2(4)  := 'Save';
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
----------------------------------------------------------------------------------------
--
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   SCCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : @(#)nm3upload.pkb	1.15 05/17/04');
   htp.p('--       Module Name      : nm3upload.pkb');
   htp.p('--       Date into SCCS   : 04/05/17 11:04:36');
   htp.p('--       Date fetched Out : 07/06/13 14:13:43');
   htp.p('--       SCCS Version     : 1.15');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : K Angus, I Turnbull');
   htp.p('--');
   htp.p('--   NM3 Upload: Contains procedures and functions for uploading data.');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	 Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
--
----------------------------------------------------------------------------------------
--
PROCEDURE rename_nuf (pi_old_name varchar2
                     ,pi_new_name varchar2
                     );
--
-----------------------------------------------------------------------------
--
PROCEDURE del_by_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_by_nuf_rowid;
--
-----------------------------------------------------------------------------
--
FUNCTION strip_dad_reference(pi_filename IN varchar2
                            ) RETURN varchar2 IS
BEGIN
   -------------------------------------------------------------------
   --remove unique reference the gateway puts on the uploaded filename
   -------------------------------------------------------------------

   nm_debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'strip_dad_reference');

   nm_debug.proc_end(p_package_name   => g_package_name
                    ,p_procedure_name => 'strip_dad_reference');

   RETURN SUBSTR(pi_filename, INSTR(pi_filename, '/') + 1);

END strip_dad_reference;
--
-----------------------------------------------------------------------------
--
PROCEDURE success(pi_file IN varchar2
                 ,pi_rows IN pls_integer
                 ) IS

   CURSOR cs_errors
   IS
   SELECT nxl_record_id, nxl_data
   FROM nm_xml_load_errors
   WHERE nxl_batch_id = nm3xml_load.g_batch_id;


   l_tab nm3type.tab_varchar32767;

   l_error_count number;
   l_sql_str     varchar2(2000);
   l_data        clob;
BEGIN
   -----------------------------------
   --build the upload success web page
   -----------------------------------

   nm_debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'success');

   nm3web.head(p_close_head => TRUE
              ,p_title      => 'NM3 XML Upload');
   htp.bodyopen;

   l_error_count := nm3xml_load.g_records_processed - pi_rows;

   htp.header(3,   'Import Filename : '
                 || strip_dad_reference(pi_file)
                 || '.');

   IF nm3xml_load.g_records_processed IS NOT NULL THEN
   htp.header(3, nm3xml_load.g_records_processed
              || ' Records '
              || ' Processed.'
             );
   END IF;

   htp.header(3, pi_rows
              || ' Records Inserted.'
             );

   IF l_error_count IS NOT NULL THEN
      htp.header(3, l_error_count
                 || ' Records Rejected.'
                );
   END IF;

   htp.br;

   IF l_error_count > 0 THEN

      htp.line;

      htp.header(2, 'Load Errors.' );

      l_sql_str := 'SELECT '                  ||CHR(10)||
                   'nxl_batch_id Batch'       ||CHR(10)||
                   ',nxl_record_id Record'    ||CHR(10)||
                   ',nxl_error Error_'        ||CHR(10)||
                   'FROM '                    ||CHR(10)||
                   'nm_xml_load_errors'       ||CHR(10)||
                   'WHERE nxl_batch_id = '    ||nm3xml_load.g_batch_id;

      l_tab := dm3query.execute_query_sql_tab (l_sql_str);
      nm3web.htp_tab_varchar(l_tab);

      htp.br;

      nm3xml_load.build_rejected_records( g_file_type,nm3xml_load.g_batch_id );

      htp.anchor(curl => nm3web.get_download_url('XML_ERRORS'), ctext => 'Rejected Records');

   END IF;

   nm3web.CLOSE;

   nm_debug.proc_end(p_package_name   => g_package_name
                    ,p_procedure_name => 'success');

END success;
--
-----------------------------------------------------------------------------
--
PROCEDURE failure(pi_error IN varchar2
                 ,pi_file  IN varchar2 DEFAULT NULL
                 ) IS

   l_text varchar2(32767);

BEGIN
   -----------------------------------
   --build the upload failure web page
   -----------------------------------

   nm_debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'failure');

   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title);
   htp.bodyopen;

   l_text := 'Error occurred';

   IF pi_file IS NOT NULL
   THEN
     l_text :=    l_text
               || ' during upload of ' || strip_dad_reference(pi_file);
   END IF;

   htp.header(1, l_text || ':');

   htp.br;

   htp.p(pi_error);

   htp.br;


   nm3web.CLOSE;

   nm_debug.proc_end(p_package_name   => g_package_name
                    ,p_procedure_name => 'failure');
END failure;
--
-----------------------------------------------------------------------------
--
PROCEDURE xml_upload IS

   c_this_module CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0010';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

   e_no_types EXCEPTION;

   CURSOR c_types IS
     SELECT
       nx.nxf_file_type
     FROM
       nm_xml_files nx
     WHERE
       nx.nxf_type = 'DTD'
     ORDER BY
       nx.nxf_file_type;

   l_type nm_xml_files.nxf_file_type%TYPE;

BEGIN

   nm_debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'xml_upload');
 --
   nm3web.user_can_run_module_web (c_this_module);
 --
   --get available XML file types
   OPEN c_types;
   FETCH c_types INTO l_type;
   IF c_types%NOTFOUND
   THEN
     RAISE e_no_types;
   END IF;

   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title);

   htp.bodyopen;

   nm3web.module_startup(pi_module => c_this_module);

   htp.header(1, 'Exor XML Loader');

   htp.br;

   htp.tableopen(cborder => 'border=0');

   htp.formopen(curl     => g_package_name||'.get_xml_file'
               ,cenctype => 'multipart/form-data');

   htp.tablerowopen;
   htp.tabledata(cvalue => 'File Type:');
   htp.p('<td>');
   htp.formselectopen(cname   => 'pi_file_type');
     LOOP
       htp.formselectoption(cvalue => l_type);

       FETCH c_types INTO l_type;
       EXIT WHEN c_types%NOTFOUND;
     END LOOP;
   htp.formselectclose;
   htp.p('</td>');
   htp.tablerowclose;

   htp.tablerowopen;
   htp.tabledata('Filename:');
   htp.tabledata(htf.formfile(cname => 'pi_file'));
   htp.tablerowclose;

   htp.tablerowopen;
   htp.tabledata('Validate Only:');
   htp.tabledata(htf.formcheckbox(cname => 'pi_commit', cvalue => 'N'));
   htp.tablerowclose;


   htp.tabledata(htf.formsubmit(cvalue => 'Upload'));

   htp.formclose;

   htp.tableclose;

   nm3web.CLOSE;

   nm_debug.proc_end(p_package_name   => g_package_name
                    ,p_procedure_name => 'xml_upload');

EXCEPTION
   WHEN e_no_types
   THEN
     failure('No file types defined for upload. Contact your system administrator.');
   WHEN nm3web.g_you_should_not_be_here THEN NULL;

END xml_upload;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_xml_file(pi_file      IN varchar2
                      ,pi_file_type IN varchar2
                      ,pi_commit    IN varchar2 DEFAULT 'Y'
                      ) IS

   e_no_file EXCEPTION;
   e_parse_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_parse_error, -20100);

   e_file_mismatch EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_file_mismatch, -20201);

--   CURSOR c1(p_file VARCHAR2
--             ) IS
--     SELECT
--       ROWID,
--       blob_content
--     FROM
--       NM_UPLOAD_FILES
--     WHERE
--       name = p_file
--     FOR UPDATE;

--  l_rowid ROWID;
  l_blob blob := EMPTY_BLOB();

  l_rows pls_integer;

  l_err_text varchar2(32767);

  l_sql nm3type.max_varchar2;
  l_cur nm3type.ref_cursor;
  l_found boolean;

BEGIN
   nm_debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'get_xml_file');
 --
    nm3web.user_can_run_module_web (c_this_module);
 --
   g_file_type := pi_file_type;

   IF pi_commit = 'N' THEN
      htp.header(1,   'File Loaded for Validation Only.');
      htp.header(1,   'No Data will be loaded.');
   END IF;

   IF pi_file IS NOT NULL
   THEN
     g_filename := pi_file;
     --get file from upload table
     l_sql :=            'SELECT ROWID'
              ||CHR(10)||'      ,BLOB_CONTENT'
              ||CHR(10)||' FROM  '||c_document_table
              ||CHR(10)||'WHERE  NAME = :g_filename'
              ||CHR(10)||'FOR UPDATE NOWAIT';
     OPEN  l_cur FOR l_sql USING g_filename;
     FETCH l_cur INTO g_nuf_rowid, l_blob;
     l_found := l_cur%FOUND;
     CLOSE l_cur;
     IF NOT l_found
      THEN
        RAISE_APPLICATION_ERROR(-20500, 'Upload file not found.');
     END IF;
--     OPEN c1(p_file => pi_file);
--       FETCH c1 INTO l_rowid, l_blob;
--       IF c1%NOTFOUND
--       THEN
--         RAISE_APPLICATION_ERROR(-20500, 'Upload file not found.');
--       END IF;
--     CLOSE c1;

     --load file contents into database
     l_rows := nm3xml_load.call_xml_loader(p_xml    => nm3clob.blob_to_clob(pi_blob => l_blob)
                                          ,p_name   => pi_file_type
                                          ,p_commit => pi_commit);
     del_by_nuf_rowid;

     success(pi_rows => l_rows
            ,pi_file => pi_file);

   ELSE
     RAISE e_no_file;
   END IF;

   nm_debug.proc_end(p_package_name   => g_package_name
                    ,p_procedure_name => 'get_xml_file');

EXCEPTION
   WHEN e_no_file
   THEN
     failure(pi_error => 'No filename specified.'
            ,pi_file  => NULL);

   WHEN e_parse_error
   THEN
     del_by_nuf_rowid;
     --DELETE
--       NM_UPLOAD_FILES
     --WHERE
--       ROWID = l_rowid;
     l_err_text := SQLERRM;
     failure(pi_error => SUBSTR(l_err_text, INSTR(l_err_text, ':') + 1)
            ,pi_file  => pi_file);

   WHEN e_file_mismatch
   THEN
     del_by_nuf_rowid;
     --DELETE
--       NM_UPLOAD_FILES
     --WHERE
--       ROWID = l_rowid;
     l_err_text := SQLERRM;
     failure(pi_error => SUBSTR(l_err_text, INSTR(l_err_text, ':') + 1)
            ,pi_file  => pi_file);
   WHEN nm3web.g_you_should_not_be_here THEN NULL;

    WHEN others
    THEN
     del_by_nuf_rowid;
      --DELETE
--        NM_UPLOAD_FILES
      --WHERE
--        ROWID = l_rowid;
      failure(pi_error => SQLERRM
             ,pi_file  => pi_file);

END get_xml_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_object IS

   c_this_module CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0030';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

BEGIN
  nm_debug.proc_start(g_package_name , 'load_object');

   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title);

   htp.bodyopen;

   nm3web.module_startup(pi_module => c_this_module);

   htp.header(1, 'Exor Load Objects');

   htp.br;

   htp.tableopen(cborder => 'border=0');

   htp.formopen(curl     => g_package_name||'.list_loaded'
               ,cenctype => 'multipart/form-data');

   htp.p('</td>');
   htp.tablerowclose;

   htp.tablerowopen;
   htp.tabledata('Filename:');
   htp.tabledata(htf.formfile(cname => 'p_in'));
   htp.tablerowclose;


   htp.tabledata(htf.formsubmit(cvalue => 'Upload'));

   htp.formclose;

   htp.tableclose;

   nm3web.CLOSE;

   nm_debug.proc_end(g_package_name , 'load_object');

END load_object;
--
----------------------------------------------------------------------------------------
--
PROCEDURE delete_loaded_object ( pi_delete IN nm3type.tab_varchar2000  )
IS
   PRAGMA autonomous_transaction;
   c_filename CONSTANT nm3type.max_varchar2 := g_filename;
BEGIN
   nm_debug.proc_start(g_package_name , 'delete_loaded_object');

   FOR i IN 1..pi_delete.COUNT
    LOOP

      g_filename := pi_delete(i);
      del_by_name;
--      DELETE NM_UPLOAD_FILES
--      WHERE name = pi_delete(i);
   END LOOP;
   nm_debug.proc_end(g_package_name , 'delete_loaded_object');
   COMMIT;
   g_filename := c_filename;
END delete_loaded_object;
--
----------------------------------------------------------------------------------------
--
PROCEDURE rename_loaded_object ( pi_rename IN nm3type.tab_varchar2000  )
IS
   PRAGMA autonomous_transaction;
BEGIN
   nm_debug.proc_start(g_package_name , 'rename_loaded_object');
--
--  THIS PROCEDURE DOES NOT DO ANYTHING!! JM 11/05/2004
--
   FOR i IN 1..pi_rename.COUNT
    LOOP
      rename_nuf (pi_old_name => pi_rename(i)
                 ,pi_new_name => pi_rename(i)
                 );
--      UPDATE NM_UPLOAD_FILES
--      SET name = pi_rename(i)
--      WHERE name = pi_rename(i);
   END LOOP;
   nm_debug.proc_end(g_package_name , 'rename_loaded_object');
   COMMIT;
END rename_loaded_object;
--
----------------------------------------------------------------------------------------
--
PROCEDURE rename_nuf (pi_old_name varchar2
                     ,pi_new_name varchar2
                     ) IS
   l_sql nm3type.max_varchar2;
--
   c_new_filename CONSTANT nm3type.max_varchar2 := g_new_filename;
   c_old_filename CONSTANT nm3type.max_varchar2 := g_old_filename;
BEGIN
   nm_debug.proc_start(g_package_name , 'rename_nuf');
--
   g_new_filename := pi_new_name;
   g_old_filename := pi_old_name;
--
   l_sql :=            'BEGIN'
            ||CHR(10)||'   UPDATE '||c_document_table
            ||CHR(10)||'    SET   NAME = '||g_package_name||'.g_new_filename'
            ||CHR(10)||'   WHERE  NAME = '||g_package_name||'.g_old_filename;'
            ||CHR(10)||'END;';
   EXECUTE IMMEDIATE l_sql;
--
   g_new_filename := c_new_filename;
   g_old_filename := c_old_filename;
--
   nm_debug.proc_end(g_package_name , 'rename_nuf');
--
EXCEPTION
   WHEN dup_val_on_index
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => g_new_filename
                    );
END rename_nuf;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_object_action ( pi_names IN varchar2 DEFAULT NULL
                            ,pi_action IN varchar2
                            ,pi_new_name IN varchar2 DEFAULT NULL
                           )
IS
  l_names nm3type.tab_varchar2000;
BEGIN
  l_names(1) := pi_names;
  do_object_action( l_names, pi_action, pi_new_name );
END do_object_action;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_object_action ( pi_names IN nm3type.tab_varchar2000
                            ,pi_action IN varchar2
                            ,pi_new_name IN varchar2 DEFAULT NULL
                           )
IS
  l_call_list_loaded boolean := TRUE;
BEGIN
   nm_debug.proc_start(g_package_name , 'do_object_action');
   IF UPPER(pi_action) = 'DELETE' THEN
      delete_loaded_object ( pi_names );
   ELSIF UPPER(pi_action) = 'RENAME' THEN
      rename_loaded_object ( pi_names );
   ELSIF UPPER(pi_action) = 'DATE LOADED' THEN
      l_call_list_loaded := FALSE;
      list_loaded ( pi_orderbydate => TRUE );
   ELSIF UPPER(pi_action) =  'OBJECT' THEN
      l_call_list_loaded := FALSE;
      list_loaded ( pi_orderbydate => FALSE );
   END IF;

   IF l_call_list_loaded THEN
      list_loaded;
   END IF;

   nm_debug.proc_end(g_package_name , 'do_object_action');

END do_object_action;
--
----------------------------------------------------------------------------------------
--
PROCEDURE list_loaded( p_in varchar2 DEFAULT NULL
                      ,pi_orderbydate boolean DEFAULT FALSE
                      ,p_replace varchar2 DEFAULT 'N'
                       )
IS

--    CURSOR cs_objects
--    IS
--    SELECT ROWNUM id, name ,last_updated
--    FROM NM_UPLOAD_FILES
--    ORDER BY UPPER(name);

   c_this_module CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0035';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

   l_id           nm3type.tab_number;
   l_name         nm3type.tab_varchar2000;
   l_last_updated nm3type.tab_date;
   l_size         nm3type.tab_number;

   l_order_by varchar2(60);
   l_cnt binary_integer;
   cs_objects nm3type.ref_cursor;
--
   c_filename CONSTANT nm3type.max_varchar2 := g_filename;
--
BEGIN

   nm_debug.proc_start(g_package_name , 'list_loaded');

   IF p_in IS NOT NULL THEN
     g_filename := nm3upload.strip_dad_reference (p_in);
     IF p_replace = 'Y'
      THEN
        del_by_name;
     END IF;
     rename_nuf (pi_old_name => p_in
                ,pi_new_name => g_filename
                );
     g_filename := c_filename;
--      UPDATE NM_UPLOAD_FILES
--      SET name = nm3upload.strip_dad_reference(p_in)
--      WHERE name = p_in;
   END IF;

   IF pi_orderbydate THEN
      l_order_by := 'ORDER BY last_updated DESC';
   ELSE
      l_order_by := 'ORDER BY upper(name)';
   END IF;

   OPEN cs_objects FOR 'SELECT ROWNUM id, name ,last_updated, doc_size '
--                  ||CHR(10)||'FROM NM_UPLOAD_FILES'
                  ||CHR(10)||'FROM '||c_document_table
                  ||CHR(10)||l_order_by;
   l_cnt := 1;
   LOOP
      FETCH cs_objects INTO l_id(l_cnt), l_name(l_cnt), l_last_updated(l_cnt), l_size(l_cnt);
      l_cnt := l_cnt + 1;
      EXIT WHEN cs_objects%NOTFOUND;
   END LOOP;
   CLOSE cs_objects;

   nm3web.head(p_close_head => FALSE
              ,p_title      => c_module_title);

   -- java script
   --nm3web.js_open;
   nm3web.js_funcs;
      htp.p('function getname(){');
      htp.p('   newname = prompt("Enter New Name:");');
      htp.p(' // do checking for not null');
      htp.p('document.myform.pi_ne_name.value = newname;');
      htp.p('event.returnValue=TRUE;');
      htp.p('}');
      
--       htp.p('function downloadFile(file) {');
--       --htp.p('  window.alert(file);');  
--       htp.p('  var df = window.open(file,"df");');
--       htp.p('  df.document.execCommand("saveas","C:\\");');
--       htp.p('  df.window.close();');
--       htp.p('}');
--       
--       htp.p('function downloadFiles () {');
--       htp.p('  window.alert(arguments[0]);');
--       htp.p('  for (var f = 0; f < arguments.length; f++) {');
--       htp.p('    if (document.all) {');
--       htp.p('  window.alert("if");');
--       htp.p('      var fr_name = "buffer" + f;');
--       htp.p('      var html = '''';');
--       htp.p('      html += ''<iframe'';');
--       htp.p('      html += '' name="'' + fr_name + ''"'';');
--       htp.p('      html += '' style="display: none;"'';');
--       htp.p('      html += '' src="'' + arguments[f] + ''"></\iframe>'';');
--       htp.p('  window.alert(html);');
--       htp.p('      document.body.insertAdjacentHTML(''beforeend'', html);');
--       htp.p('      document.frames[fr_name].document.execCommand(''saveas'');');
--       htp.p('    }');
--       htp.p('    else if (document.layers) {');
--       htp.p('  window.alert("else if 1");');
--       htp.p('      open(arguments[f])');
--       htp.p('    }');
--       htp.p('    else if (document.getElementById) {');
--       htp.p('  window.alert("else if 2");');
--       htp.p('      var iframe = document.createElement(''iframe'');');
--       htp.p('      iframe.setAttribute(''id'', ''buffer'' + f);');
--       htp.p('      iframe.setAttribute(''name'', ''buffer'' + f);');
--       htp.p('      iframe.setAttribute(''src'', arguments[f]);');
--       htp.p('      iframe.setAttribute(''style'', ''visibility: hidden;'');');
--       htp.p('      document.body.appendChild(iframe);');
--       htp.p('    }');
--       htp.p('  }');
--       htp.p('}');

   nm3web.js_close;
   htp.headclose;

   htp.bodyopen;

   nm3web.module_startup(pi_module => c_this_module);

   --htp.header(2, 'Objects Loaded in nm_upload_files');
   htp.header(2, 'Objects Loaded in '||c_document_table);

--   htp.br;

   htp.tableopen (cattributes=>'border=1');
   htp.tablerowopen;
   htp.p('<TD>');
      htp.tableopen(cborder => 'border=0');

      htp.formopen(curl     => g_package_name||'.list_loaded'
                  ,cenctype => 'multipart/form-data');


      htp.tablerowopen;
      htp.tabledata('Filename');
      htp.tabledata(htf.formfile(cname => 'p_in'));
      htp.tablerowclose;
   --
      htp.tablerowopen;
      htp.p('<TD COLSPAN=2>');
      htp.p('Replace');
      htp.formcheckbox(cname    => 'p_replace'
                      ,cvalue   => 'Y'
                      ,cchecked => 'CHECKED'
                      );
      htp.p('</TD>');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tableheader(htf.formsubmit(cvalue => 'Upload'),cattributes=>'COLSPAN=2');
      htp.tablerowclose;

      htp.formclose;

      htp.tableclose;
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tableclose;

   htp.br;

   --htp.formopen(curl     => g_package_name||'.delete_loaded_object');
   htp.formopen(curl     => g_package_name||'.do_object_action'

                );

   htp.tableopen(cborder => 'border=2');


   htp.tableheader(nm3web.c_nbsp);
   --htp.tableheader(nm3web.c_nbsp);
   htp.tableheader(htf.formsubmit(cvalue => 'Object',cname => 'pi_action') );
   htp.tableheader(htf.formsubmit(cvalue => 'Date Loaded',cname => 'pi_action') );
   htp.tableheader(htf.formsubmit(cvalue => 'Delete',cname => 'pi_action') );
--    htp.tableheader(htf.formsubmit(cvalue => 'Rename'
--                                  ,cname => 'pi_action'
--                                  ,cattributes => 'onClick="getname()"'
--                   ) );

   FOR i IN 1..l_id.COUNT LOOP
      htp.tablerowopen;

         htp.tabledata('<input type="button" value="'||c_detail||'" onClick="popUp('||nm3flx.string(g_package_name||'.show_detail?pi_name='||nm3web.string_to_url(l_name(i)))||')">');
         --htp.tabledata('<input type="button" value="' || c_save || '" onClick="downloadFiles(''' || nm3web.string_to_url(nm3web.get_download_url(l_name(i))) || ''')">');
         htp.p('<td>');
         IF l_size(i) > 0
          THEN
            --htp.anchor(curl  => 'javascript:popUp('||nm3flx.string(nm3web.string_to_url(nm3web.get_download_url(l_name(i))))||')'
            htp.anchor(curl  => nm3web.get_download_url(l_name(i))
                      ,cattributes =>  'onClick="popUp('||nm3flx.string(nm3web.string_to_url(nm3web.get_download_url(l_name(i))))||'); return false;"'           
                      ,ctext => l_name(i)
                      );
            --htp.anchor(curl  => nm3web.get_download_url(l_name(i))
         ELSE
            htp.p(l_name(i));
         END IF;
         htp.p('</td>');

         htp.tabledata( cvalue => TO_CHAR(l_last_updated(i),nm3type.c_full_date_time_format)
                       ,calign => 'CENTER' );

         htp.tabledata( cvalue => htf.formcheckbox(  cname => 'pi_names'
                                                   , cvalue => l_name(i))
                       ,calign => 'CENTER' );
--          htp.tabledata( cvalue => htf.formradio(  cname => 'pi_names'
--                                                  , cvalue => l_name(i))
--                        ,calign => 'CENTER' );

     htp.tablerowclose;
   END LOOP;

   htp.formclose;

   nm3web.CLOSE;

   nm_debug.proc_end(g_package_name , 'list_loaded');

   EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
   THEN
     NULL;
  WHEN others
   THEN
     nm3web.failure(SQLERRM);
END list_loaded;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_by_nuf_rowid IS
   l_sql nm3type.max_varchar2;
BEGIN
   l_sql :=            'BEGIN'
            ||CHR(10)||'   DELETE '||c_document_table
            ||CHR(10)||'   WHERE ROWID = '||g_package_name||'.g_nuf_rowid;'
            ||CHR(10)||'END;';
   EXECUTE IMMEDIATE l_sql;
END del_by_nuf_rowid;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_by_name IS
   l_sql nm3type.max_varchar2;
BEGIN
--   nm_debug.debug('Del_by_name = '||g_filename);
   l_sql :=            'BEGIN'
            ||CHR(10)||'   DELETE '||c_document_table
            ||CHR(10)||'   WHERE name = '||g_package_name||'.g_filename;'
            ||CHR(10)||'END;';
--   nm_debug.debug(l_sql);
   EXECUTE IMMEDIATE l_sql;
--   nm_debug.debug('done del_by_name');
END del_by_name;
--
----------------------------------------------------------------------------------------
--
PROCEDURE show_detail (pi_name varchar2) IS
--
   l_tab_col  nm3type.tab_varchar30;
   l_tab_disp nm3type.tab_varchar80;
   l_tab_func nm3type.tab_varchar2000;
--
   l_tab_sql  nm3type.tab_varchar32767;
--
   c_full_date_time_format_str CONSTANT varchar2(30) := 'c_full_date_time_format';
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_tab_sql, p_text, p_nl);
   END append;
--
   PROCEDURE add_col (p_col  varchar2
                     ,p_disp varchar2
                     ,p_func varchar2 DEFAULT NULL
                     ) IS
      c CONSTANT pls_integer := l_tab_col.COUNT+1;
   BEGIN
      l_tab_col(c)  := p_col;
      l_tab_disp(c) := p_disp;
      l_tab_func(c) := NVL(p_func,p_col);
   END add_col;
--
BEGIN
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_detail
               );
--
   sccs_tags;
   htp.headclose;
   htp.bodyopen;
--
   nm3web.do_close_window_button;
--
   IF c_document_table = c_nm_upload_files
    THEN
      add_col ('NAME'
              ,'Filename'
              ,'DECODE(doc_size,0,NAME,htf.anchor(nm3web.get_download_url(NAME),NAME))'
              );
      add_col ('MIME_TYPE'
              ,'MIME Type'
              );
      add_col ('DOC_SIZE'
              ,'Document Size'
              );
      add_col ('DAD_CHARSET'
              ,'Character Set'
              );
      add_col ('LAST_UPDATED'
              ,'Last Updated'
              ,'TO_CHAR(last_updated,'||c_full_date_time_format_str||')'
              );
      add_col ('CONTENT_TYPE'
              ,'Content Type'
              );
      add_col ('NUF_NUFG_TABLE_NAME'
              ,'Gateway Table'
              );
      FOR i IN 1..5
       LOOP
         add_col ('NUF_NUFGC_COLUMN_VAL_'||i
                 ,'Gateway Column Val '||i
                 );
      END LOOP;
   ELSE
      DECLARE
         l_tab_foreign_col       nm3type.tab_varchar30;
         l_tab_foreign_data_type nm3type.tab_varchar30;
         l_func                  varchar2(2000);
      BEGIN
         SELECT column_name
               ,data_type
          BULK  COLLECT
          INTO  l_tab_foreign_col
               ,l_tab_foreign_data_type
          FROM  all_tab_columns
         WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
          AND   table_name = c_document_table
          AND   data_type  IN (nm3type.c_varchar, nm3type.c_number, nm3type.c_date)
         ORDER BY column_id;
         FOR i IN 1..l_tab_foreign_col.COUNT
          LOOP
            l_func := NULL;
            IF l_tab_foreign_col(i) = 'NAME'
             THEN
               l_func := 'htf.anchor(nm3web.get_download_url('||l_tab_foreign_col(i)||'))';
            ELSIF l_tab_foreign_data_type(i) = nm3type.c_date
             THEN
               l_func := 'TO_CHAR('||l_tab_foreign_col(i)||','||c_full_date_time_format_str||')';
            END IF;
            add_col (l_tab_foreign_col(i)
                    ,INITCAP(REPLACE(l_tab_foreign_col(i),'_',' '))
                    ,l_func
                    );
         END LOOP;
      END;
   END IF;
--
   g_filename   := pi_name;
   g_tab_header := l_tab_disp;
--
   l_tab_sql.DELETE;
   append ('DECLARE',FALSE);
   append ('   '||c_full_date_time_format_str||' CONSTANT VARCHAR2(30) := nm3type.'||c_full_date_time_format_str||';');
   append ('   CURSOR cs_detail (c_name VARCHAR2) IS');
   append ('   SELECT 1 dummy_val');
   FOR i IN 1..l_tab_col.COUNT
    LOOP
      append ('         ,'||l_tab_func(i)||' '||l_tab_col(i));
   END LOOP;
   append ('     FROM  '||c_document_table);
   append ('    WHERE   name = c_name;');
   append ('--');
   append ('   l_rec   cs_detail%ROWTYPE;');
   append ('   l_found BOOLEAN;');
   append ('--');
   append ('   PROCEDURE show_it (p_index PLS_INTEGER, p_val VARCHAR2) IS');
   append ('      l_disp  nm3type.max_varchar2 := p_val;');
   append ('   BEGIN');
   append ('      IF l_disp IS NOT NULL');
   append ('       THEN');
   append ('         htp.tablerowopen;');
   append ('         htp.tableheader('||g_package_name||'.g_tab_header(p_index));');
   append ('         l_disp := NVL(l_disp,nm3web.c_nbsp);');
   append ('         htp.tabledata(l_disp);');
   append ('         htp.tablerowclose;');
   append ('      END IF;');
   append ('   END show_it;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   OPEN  cs_detail ('||g_package_name||'.g_filename);');
   append ('   FETCH cs_detail INTO l_rec;');
   append ('   l_found := cs_detail%FOUND;');
   append ('   CLOSE cs_detail;');
   append ('   IF NOT l_found');
   append ('    THEN');
   append ('      hig.raise_ner (pi_appl => nm3type.c_hig');
   append ('                    ,pi_id   => 67');
   append ('                    ,pi_supplementary_info => '||nm3flx.string(c_document_table||'.NAME = ')||'||'||g_package_name||'.g_filename');
   append ('                    );');
   append ('   END IF;');
   append ('--');
   FOR i IN 1..l_tab_col.COUNT
    LOOP
      append ('   show_it('||i||',l_rec.'||l_tab_col(i)||');');
   END LOOP;
   append ('--');
   append ('END;');
--
   htp.tableopen (cattributes=>'BORDER=1');
--
--   nm_debug.deletE_debug(TRUE);
--   nm_debug.debug_on;
--   nm3tab_varchar.debug_tab_varchar(l_tab_sql);
   nm3ddl.execute_tab_varchar(l_tab_sql);
--
   htp.tableclose;
--
   nm3web.do_close_window_button;
--
   htp.bodyclose;
   htp.htmlclose;
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN others
   THEN
     nm3web.failure(SQLERRM);
END show_detail;
--
----------------------------------------------------------------------------------------
--
--BEGIN
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm_debug.set_level(4);
END nm3upload;
/
